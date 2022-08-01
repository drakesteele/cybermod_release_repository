debugPrint(3,"CyberScript: Gang module loaded")
questMod.module = questMod.module +1


function waitSelectionFinished(timer,functionprint)
	
	Cron.After(timer, function()
		if (selectedEntity == true) then
			
			
			functionprint()	
			else
			
			
			waitSelectionFinished(timer,functionprint)
		end
	end)
	
end

function finishCrewclicking()
	inCrewManager = false
	Game.GetTimeSystem():UnsetTimeDilation("crewmanager")
end

function CloseCrewWindows()
	inCrewManager = false
	selectedCompanion = nil
	Game.GetTimeSystem():UnsetTimeDilation("crewmanager")
end





function setRelationBetweenGang(gang,rival)
	
	
	
	local AIC = objlook:GetAIControllerComponent()
	local targetAttAgent = objlook:GetAttitudeAgent()
	local reactionComp = objlook.reactionComponent
	
	local aiRole = NewObject('objlook:AIRole')
	aiRole:OnRoleSet(objlook)
	
	Game['senseComponent::RequestMainPresetChange;GameObjectString'](objlook, "Combat")
	Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](objlook, "Combat")
	AIC:SetAIRole(aiRole)
	objlook.movePolicies:Toggle(true)
	
	targetAttAgent:SetAttitudeGroup(CName.new(gang))
	Game.GetAttitudeSystem():SetAttitudeRelation(CName.new(gang), CName.new(rival), Enum.new("EAIAttitude", "AIA_Hostile"))
	
	
	reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
	
	reactionComp:TriggerCombat(target)
	
	ToggleImmortal(objlook, false)
	
	
	
end

function setAttitudeByGangScore()
	local GangWarsEnabled = getUserSetting("GangWarsEnabled")
	if(objLook ~= nil and GangWarsEnabled == 1) then
		local targeName = objLook:ToString()
		if(string.match(targeName, "NPCPuppet"))then 
			local targetAttAgent = objLook:GetAttitudeAgent()
			local group = Game.NameToString(targetAttAgent:GetAttitudeGroup())
			local npcCurrentName = Game.NameToString(objLook:GetCurrentAppearanceName())
			
		
			
			--debugPrint(1,npcCurrentName)
			
			
			for k,v in pairs(arrayFaction) do
				
				for y=1,#arrayFaction[k].faction.AttitudeGroup do
					
					if(string.find(group,arrayFaction[k].faction.AttitudeGroup[y]) ~= nil or string.find(npcCurrentName,arrayFaction[k].faction.AttitudeGroup[y]) ~= nil)then
						if(string.find(npcCurrentName,"beyond_bouncer") == nil)then
							
							local score = getScorebyTag(arrayFaction[k].faction.Tag)
	
	
									setAttituteByScore(targetAttAgent,score,objLook)
	
							
							
						end
						
						
					end
					
				end
				
			end
			
			
			
			
		end 
		
		
		
	end
	
	
	

end

function checkAttitudeByGangScore(enti)
	
	
	local isAlly = false
	local isAllyscore = nil
	local lookedgang = nil
	
	if(enti ~= nil) then
		local targeName = enti:ToString()
		if(string.match(targeName, "NPCPuppet"))then 
			local targetAttAgent = enti:GetAttitudeAgent()
			local group = Game.NameToString(targetAttAgent:GetAttitudeGroup())
			local npcCurrentName = Game.NameToString(enti:GetCurrentAppearanceName())
			
			--print(tostring(group))
			
			for k,v in pairs(arrayFaction) do
				
				for y=1,#arrayFaction[k].faction.AttitudeGroup do
					
					if(string.find(group,arrayFaction[k].faction.AttitudeGroup[y]) ~= nil or string.find(npcCurrentName,arrayFaction[k].faction.AttitudeGroup[y]) ~= nil)then
						if(string.find(npcCurrentName,"beyond_bouncer") == nil)then
							
						local score = getScorebyTag(arrayFaction[k].faction.Tag)
							
							isAlly = checkAlliesByScore(score)
							isAllyscore = checkAlliesScoreByScore(score)
							lookedgang = arrayFaction[k].faction
							
							
						end
						
						
					end
					
				end
				
			end
			
			
			
		end 
		
		
		
	end
	
	return isAlly,isAllyscore,lookedgang
	
end

function checkAlliesByScore(score)
	
	if(score >= 5) then
		--debugPrint(1,"Is potential ally")
		return true
		
		elseif(score < 0) then
		
		--debugPrint(1,"Is not potential ally")
		return false
		
		elseif(score== 0) then
		
		--debugPrint(1,"Is neutral")
		return true
	end
	
	
end

function checkAlliesScoreByScore(score)
	
	if(score >= 5) then
		--debugPrint(1,"Is potential ally")
		return 1
		
		elseif(score < 0) then
		
		--debugPrint(1,"Is not potential ally")
		return -1
		
		elseif(score== 0) then
		
		--debugPrint(1,"Is neutral")
		return 0
	end
	
	
end

function setAttituteByScore(targetAttAgent,score, objlook)
	
	local GangWarsEnabled = getUserSetting("GangWarsEnabled")
	
	if(GangWarsEnabled == 0) then
		score = 0
	end
	
	
	local currentRole = objlook:GetAIControllerComponent():GetAIRole()
	local isFollower = false
	isFollower = (currentRole and (currentRole:IsA('AIFollowerRole')) )
	if(isFollower == nil) then
		
		isFollower = false
		
	end
	local CanbeChanged = true
	
	
		for k,v in pairs(questMod.EntityManager) do 
			if(v.id ~= nil and v.id ~= 0) then
				
				local enti = Game.FindEntityByID(v.id)
				
				if(enti ~= nil) then
					if(enti:GetEntityID().hash == objlook:GetEntityID().hash) then
						CanbeChanged = false
						
					end			
				end
			end
		end	
	
	
	--debugPrint(1,"isFollower "..tostring(isFollower))
	if isFollower == false and CanbeChanged then
		--debugPrint(1,"it's a npc")
		if(score > 0) then
			
			local FriendlyFollower = objlook	
			ToggleImmortal(FriendlyFollower, false)
			-- local NPC = FriendlyFollower:GetAIControllerComponent()
			-- local targetTeam = FriendlyFollower:GetAttitudeAgent()
			
			-- local SetState = NewObject('handle:AIRole')
			
			-- SetState:OnRoleSet(FriendlyFollower)
			-- SetState.followerRef = Game.CreateEntityReference("#player", {})
			FriendlyFollower:GetAttitudeAgent():SetAttitudeGroup(CName.new("player"))
			
			
			Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](FriendlyFollower, Game:GetPlayer())
			-- Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](FriendlyFollower, "Relaxed")
			-- NPC:SetAIRole(SetState)
			-- FriendlyFollower.movePolicies:Toggle(true)
			
			local currentRole = FriendlyFollower:GetAIControllerComponent():GetAIRole()
			
			if currentRole then
				currentRole:OnRoleCleared(FriendlyFollower)
			end
			local followerRole = NewObject('handle:AIRole')
			
			
			FriendlyFollower:GetAIControllerComponent():SetAIRole(followerRole)
			
			FriendlyFollower:GetAttitudeAgent():SetAttitudeTowards(Game.GetPlayer():GetAttitudeAgent(), 'AIA_Friendly')
			FriendlyFollower:GetAIControllerComponent():OnAttach()	
			--Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](FriendlyFollower, Game:GetPlayer())
			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](FriendlyFollower, "Relaxed")
			FriendlyFollower.movePolicies:Toggle(true)
			
			
			--debugPrint(1,"Friend")
			
			elseif(score == 0) then
			
			
			
			
			
			
			local neutalEntity = objlook
			ToggleImmortal(neutalEntity, false)
			local currentRole = neutalEntity:GetAIControllerComponent():GetAIRole()
			
			if currentRole then
				currentRole:OnRoleCleared(neutalEntity)
			end
			--debugPrint(1,"Neutral")
			
			local followerRole = NewObject('handle:AIRole')
			--followerRole.followerRef = Game.CreateEntityReference('#player', {})
			neutalEntity:GetAIControllerComponent():SetAIRole(followerRole)
			neutalEntity:GetAIControllerComponent():OnAttach()	
			Game['senseComponent::RequestMainPresetChange;GameObjectString'](neutalEntity, "Relaxed")
			
			
			-- local AIController = neutalEntity:GetAIControllerComponent()
			-- local targetAttAgent = neutalEntity:GetAttitudeAgent()
			-- local reactionComp = neutalEntity.reactionComponent
			
			-- local aiRole = NewObject('handle:AIRole')
			-- aiRole:OnRoleSet(neutalEntity)
			
			
			-- Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](neutalEntity, "Relaxed")
			
			-- AIController:SetAIRole(aiRole)
			-- neutalEntity.movePolicies:Toggle(true)
			
			
			
			
			
			
			elseif(score < 0) then
			-- local hostileEntity = objlook
			-- local currentRole = hostileEntity:GetAIControllerComponent():GetAIRole()
			
			-- if currentRole then
			-- currentRole:OnRoleCleared(hostileEntity)
			-- end
			
			-- local reactionComp = hostileEntity.reactionComponent
			
			
			
			-- local followerRole = NewObject('handle:AIRole')
			-- --followerRole.followerRef = Game.CreateEntityReference('#player', {})
			-- hostileEntity:GetAttitudeAgent():SetAttitudeGroup(CName.new("hostile"))
			
			
			-- Game['senseComponent::RequestMainPresetChange;GameObjectString'](hostileEntity, "Combat")
			
			-- -- Game['senseComponent::RequestMainPresetChange;GameObjectString'](objlook, "Combat")
			-- Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](hostileEntity, "Combat")
			-- -- --AIController:GetCurrentRole():OnRoleCleared(objlook)
			-- -- AIController:SetAIRole(aiRole)
			-- hostileEntity.movePolicies:Toggle(true)
			-- -- targetAttAgent:SetAttitudeGroup(CName.new("hostile"))
			-- reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
			-- hostileEntity:GetAIControllerComponent():SetAIRole(followerRole)
			-- hostileEntity:GetAIControllerComponent():OnAttach()	
			-- reactionComp:TriggerCombat(Game.GetPlayer())
			
			-- local get_godmode = Game.GetGodModeSystem()
			
			-- get_godmode:ClearGodMode(hostileEntity:GetEntityID(), CName.new("Default"))	
			ToggleImmortal(objlook, false)
			local AIController = objlook:GetAIControllerComponent()
			local targetAttAgent = objlook:GetAttitudeAgent()
			local reactionComp = objlook.reactionComponent
			
			local aiRole = NewObject('handle:AIRole')
			aiRole:OnRoleSet(objlook)
			
			Game['senseComponent::RequestMainPresetChange;GameObjectString'](objlook, "Combat")
			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](objlook, "Combat")
			--AIController:GetCurrentRole():OnRoleCleared(objlook)
			AIController:SetAIRole(aiRole)
			objlook.movePolicies:Toggle(true)
			targetAttAgent:SetAttitudeGroup(CName.new("hostile"))
			reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
			reactionComp:TriggerCombat(Game.GetPlayer())
			
			--debugPrint(1,"Hostile")
			
			
			
			objlook:GetAttitudeAgent():SetAttitudeTowards(Game.GetPlayer():GetAttitudeAgent(), 'AIA_Hostile')
			
			
		end
	end
	
end




function spawnAmbush(currentDistrict, ishostile)
	
	debugPrint(1,"Ambush Spawn !")
	
	charatableAmbush = {}
	vehicleambushtable = {}
	
	
	for k,v in pairs(arrayFaction) do
		
		if(currentDistrict.Tag == arrayFaction[k].faction.DistrictTag) then
			
			local factionscore=getScorebyTag(arrayFaction[k].faction.Tag)
			
			if(factionscore<0 and ishostile) then
				currentHostileFaction = arrayFaction[k].faction.Tag
				charatableAmbush= arrayFaction[k].faction.SpawnableNPC
				vehicleambushtable= arrayFaction[k].faction.SpawnableVehicule
				
				else
				currentHostileFaction = arrayFaction[k].faction.Tag
				charatableAmbush= arrayFaction[k].faction.SpawnableNPC
				vehicleambushtable= arrayFaction[k].faction.SpawnableVehicule
				
			end
			
		end
		
	end
	
	local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
	needvehicule = inVehicule
	vehicle = vehicleambushtable[math.random(1,#vehicleambushtable)]
	
	local currentpoi = nil
	
	
	for i=1,#arrayPOI do
		
		if(#arrayPOI[i].locations > 0) then
			
			
			for y=1,#arrayPOI[i].locations do
				
				local location = arrayPOI[i].locations[y]
				
				if(location.Tag ~= nil) then
					--new system of POI
					if(location.Tag == currentDistrict.Tag and checkPos(curPos, location.x, location.y,20) and location.inVehicule == inVehicule and arrayPOI[i].isFor == 4) then
						
						currentpoi = location
						break;
						
					end
					
					
					else
					--old one
					if(string.lower(location.district) == string.lower(currentDistrict.EnumName) and checkPos(curPos, location.x, location.y,20) and location.inVehicule == inVehicule) then
						
						currentpoi = location
						break;
						
					end
					
				end
				
			end
			
			
		end
		
	end
	local couinter = math.random(1,10)
	
	if ishostile == false then
		couinter = math.random(1,4)
	end
	
	if(#charatableAmbush > 0) then
		for i = 1,couinter  do
			chara = charatableAmbush[math.random(1,#charatableAmbush)]
			
			
			
			
			if currentpoi == nil then
				spawnNPC(chara, vehicle, needvehicule,ishostile)
				
				else
				debugPrint(1,"custom POI")
				debugPrint(1,round(currentpoi.x))
				debugPrint(1,round(currentpoi.y))
				debugPrint(1,round(currentpoi.z))
				spawnNPCAtPosition(chara, vehicule, needvehicule, ishostile, currentpoi.x+i, currentpoi.y ,currentpoi.z)
				debugPrint(1,chara)
			end
		end
		
		if needvehicule then 
			
			if currentpoi == nil then
				spawnvehicule(vehicle)
				
				else
				
				debugPrint(1,"custom POI vehicule")
				spawnvehiculeAtPosition(vehicle, currentpoi.x, currentpoi.y+5 ,currentpoi.z)
			end
			
			
			
		end
		
		if(ishostile == false)then
			questMod.NPCManager = {}
		end
		resetNPCManager = false
		
		else
		
		debugPrint(1,"No relationed district...	")
		
		
	end
	
end




function isHostileDistrict(currentDistrict)
	
	local factiontable = {}
	local score = 0
	
	
	if(#currentDistricts2.districtLabels > 1) then
			
				local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
				
				for i=1,#gangs do
				
					local factionscore =  getScorebyTag(gangs[i].tag)
					score = score + factionscore
					
				
				end
				
		else
				
				
				local gangs = getGangfromDistrict(currentDistricts2.districtLabels[1],20)
				
				for i=1,#gangs do
				
					
						local factionscore =  getScorebyTag(gangs[i].tag)
						score = score + factionscore
					
					
				
				end
				
				
	end
			
	
	
	return TestScoreIsHostile(score)
	
	
end

function TestScoreIsHostile(score)
	
	if(score == 0) then --neutre
		
		return 1
		
		elseif (score > 0) then -- friendly
		
		return 0
		
		elseif (score < 0) then --Hostile
		
		return 2
		
		
	end
	
end



function displayGangScore(score, libelle)
	local colorclass = "28F0FF"
	local state = lang.Neutral
	
	if(score > 0) then
		colorclass = "009933"
		state = lang.Friendly
		elseif(score < 0) then
		
		colorclass = "ff0000"
		state = lang.Hostile
		
	end
	
	
	CPS.colorBegin("Text", colorclass)
	ImGui.TextWrapped('· ' .. libelle.." : "..state.."("..score..")")
	CPS.colorEnd(1)
	
	
end

function displayGangScoreWidget(score, libelle,parent,top,isleader)
	
	local state = lang.Neutral
	local descText = inkText.new()
	
	if(score ~= nil) then
	
	
	
	local descText = inkText.new()
	descText:SetName(CName.new("faction"..top))
	
	if(score > 0) then
		
		state = lang.Friendly
		
		descText:SetTintColor(gamecolor(0,255,120,1))
		
		elseif(score < 0) then
		descText:SetTintColor(gamecolor(223,10,10,1))
		
		state = lang.Hostile
		
	end
	
	local test = '· ' .. libelle.." : "..state.."("..score..")"
	
	if(isleader == true) then
	
	test = '· ' .. libelle.." [Leader] : "..state.."("..score..")"
	
	else
	test = '· ' .. libelle.." : "..state.."("..score..")"
	
	
	end
	
	
	
	descText:SetText(test)
	descText:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
	descText:SetFontStyle('Medium')
	descText:SetFontSize(30)

	descText:SetVerticalAlignment(textVerticalAlignment.Center)
	descText:SetHorizontalAlignment(textHorizontalAlignment.Right)
	descText:SetMargin(inkMargin.new({ top = top, left = locationWidgetLeft}))
	descText:Reparent(parent, -1)
	
	descText:SetHorizontalAlignment(textHorizontalAlignment.Right)
	
	end
	
end







function GangAffinityCalculator()
	
	local getAffinity = {}
	
	
	
	local f = assert(io.open("data/db/gameaffinity.json"))
	
	lines = f:read("*a")
	
	encdo = lines
	
	
	
	getAffinity = json.decode(encdo)
	
	
	f:close()
	
	for i=1,#getAffinity do 
		
		local affinity = getAffinity[i]
		
		
		local isquestok = Game.GetQuestsSystem():GetFactStr(affinity.fact)
	--	print("testing fact "..affinity.fact.." result "..isquestok)
		if(isquestok == 1)then
			
			
			if #affinity.factionscore > 0 then
				
				for y=1,#affinity.factionscore  do
					local factionScore = affinity.factionscore[y]
					
					addFactionScoreByTagScore(factionScore.faction,factionScore.value)
					--print("added score "..tostring(factionScore.value).." to faction "..factionScore.faction)
					
					
				end
				
				
				
			end
			
			if #affinity.npcscore > 0 then
				for z=1,#affinity.npcscore  do
					local npcScore = affinity.npcscore[z]
					
					
					local score = getScoreKey(npcScore.Names,"Score")
					if(score == nil) then score = 0 end
					
					score = score + npcScore.value
					setScore(npcScore.Names,"Score",score)
				--	print("added score "..tostring(score).." to NPC "..npcScore.Names)
				
			end
			
		end
		
		
		
	end
	
	
end			
end