debugPrint(3,"CyberScript: scripting module loaded")
questMod.module = questMod.module +1


--Script Execution Engine
function CompileCachedThread()
	workerTableKey = {}
	if(workerTable ~= nil)then
		
		for k in pairs(workerTable) do
			table.insert(workerTableKey, k)
		end
		
	end
	
end

function ScriptExecutionEngine()
	
	
	if(workerTable ~= nil )then
		
		
		
		for i=1,#workerTableKey do 
			local k = workerTableKey[i]
			if(workerTable[k] ~= nil) then
			
			if(GameUI.IsMenu() == false or (workerTable[k]["bypassMenu"] ~= nil and workerTable[k]["bypassMenu"] == true)) then
				local index = workerTable[k]["index"]
				local list = workerTable[k]["action"]
				local parent = workerTable[k]["parent"]
				local pending = workerTable[k]["pending"]
				
				-- debugPrint(1,k)
				-- debugPrint(1,list)
				-- debugPrint(1,index)
				
				if(workerTable[k]["index"] > #workerTable[k]["action"] and workerTable[k]["pending"] == false and workerTable[k]["started"] == true) then
					
					if workerTable[k]["parent"] ~= nil and workerTable[k]["parent"] ~= ""then
						
						if(workerTable[workerTable[k]["parent"]] ~= nil) then
							workerTable[workerTable[k]["parent"]]["pending"] = false
							
							workerTable[workerTable[k]["parent"]]["index"] = workerTable[workerTable[k]["parent"]]["index"] + 1
						end
					end
					
					if workerTable[k]["children"] == "" then
						
						--
						
						if(workerTable[k].quest == nil)then
							workerTable[k] = nil
							workerTableKey[i] = nil
							else
							workerTable[k].disabled = true
						end
						
						else
						
						if workerTable[workerTable[k]["children"]] == nil then
							
							--workerTable[k] = nil
							--workerTableKey[i] = nil
							--		workerTable[k].disabled = true
							if(workerTable[k].quest == nil or workerTable[k].quest == false)then
								workerTable[k] = nil
								workerTableKey[i] = nil
								else
								workerTable[k].disabled = true
							end
						end
						
					end
					
					
				end
				
				if(workerTable[k] ~= nil) then
					
					if(index <= #list and workerTable[k].disabled == false) then
						workerTable[k]["started"] = true
						if(pending == false) then
							
							if(workerTable[k]["index"] ~= nil) then
								
								if(list[index].name == "goto") then
									
									if(list[index].parent == true) then
										debugPrint(1,"Go to"..list[index].index.." of "..parent)
										
										workerTable[parent]["index"] = list[index].index-1
										workerTable[k]["index"] = workerTable[k]["index"]+1
										workerTable[parent]["pending"] =  false
										k = parent
										else
										debugPrint(1,"Go to"..list[index].index.." of "..k)
										
										
										workerTable[k]["index"] = list[index].index 
									end
									
									else
									local isfinish = false
									
									
									local action = list[index]
									local status, retval = pcall(executeAction,action,k,parent,workerTable[k]["index"],workerTable[k]["source"],workerTable[k]["executortag"])
									
									
									
									if status == false then
									
										print(getLang("scripting_error") .. retval)
										print(getLang("scripting_error") .. retval.." Action : "..tostring(JSON:encode_pretty((list[index]))).." tag "..k.." parent "..parent.." index "..workerTable[k]["index"])
										spdlog.error(getLang("scripting_error") .. retval.." Action : "..tostring(JSON:encode_pretty((list[index]))).." tag "..k.." parent "..parent.." index "..workerTable[k]["index"])
										--Game.GetPlayer():SetWarningMessage("CyberScript Scripting error, check the log for more detail")
										workerTable[k] =  nil
										else
										isfinish = retval
										
									end
										
								
									
									
								
									if(workerTable[k] ~= nil) then
										if(isfinish == true) then
											
											
											workerTable[k]["index"] = workerTable[k]["index"]+1
											
											--debugPrint(1,"action finished")
											workerTable[k]["pending"] = false
											
											else
											
											workerTable[k]["pending"] = true
											
											
											
											
										end
										
										
									end
									
								end
								
								else
								
								--	workerTable[k] =  nil
								--workerTable[k].disabled = true
								--	workerTableKey[i] = nil
								if(workerTable[k].quest == nil)then
									workerTable[k] = nil
									workerTableKey[i] = nil
									else
									workerTable[k].disabled = true
								end
							end
							else
							
							
							local actionisgood = checkWaitingAction(list[index],k,parent,index)
							
							workerTable[k]["pending"] = (actionisgood ~= pending)
							
							if(workerTable[k]["pending"] == false) then
								
								workerTable[k]["index"] = workerTable[k]["index"]+1
							end
							
							
							
							
						end
						
						
					end
				end
				
			end
			end
			
		end
		
		
		-- for i=1,#toremove do
		
		-- workerTable[toremove[i]] = nil
		-- table.remove(toremove,i)
		-- end
		
	end
	
end

function checkWaitingAction(action,tag,parent,index)
	
	
	
	result = false
	
	
	if(action.name == "wait") then
		
		local temp = getGameTime()
		
		if(temp.hour > action.hour or (temp.hour == action.hour and temp.min > action.min)) then
			result = true
		end
		
		
		
		
	end
	
	
	
	
	if(action.name == "wait_second") then
		
		if(tick >= action.tick) then
			result = true
		end
		
		
		
	end
	
	
	if(action.name == "subtitle" or action.name == "random_subtitle") then
		
		if(tick >= action.tick) then
			result = true
			currentSubtitlesGameController:Cleanup()
		end
		
		
		
	end
	
	if(action.name == "npc_chat" or action.name == "random_npc_chat") then
		
		if(tick >= action.tick) then
			result = true
			currentChattersGameController:Cleanup()
		end
		
		
		
	end
	
	
	if(action.name == "fade_in") then
		
		
		
		isFadeIn = true
		--debugPrint(1,opacity)
		
		
		if(tick >= action.tick) then
			
			
			opacity = 1
			
			
			
			result = true
			
		else
			local fadeincursor = tonumber(action.tick)
			
			
			
			local currentcursor = tonumber(tick)
			
			
			--debugPrint(1,fadeincursor)
			--debugPrint(1,currentcursor)
			
			
			opacity = (100/(fadeincursor-currentcursor))
			
			
		end	
	end
	
	if(action.name == "fade_out") then
		
		
		
		
		--debugPrint(1,opacity)
		
		
		if(tick >= action.tick) then
			
			
			opacity = 0
			isFadeIn = false
			
			
			result = true
			
		else
			local fadeoutcursor = tonumber(action.tick)
			
			
			
			local currentcursor = tonumber(tick)
			
			
			--debugPrint(1,fadeincursor)
			--debugPrint(1,currentcursor)
			
			
			opacity = 1 - (100/(fadeoutcursor-currentcursor))
			
			
		end	
	end
	
	if(action.name == "wait_for_trigger") then
		
		
		local trigger = action.trigger
		result = checkTrigger(trigger)
		
	end
	
	if(action.name == "wait_for_framework") then
		
		
		
	result = (waiting == false)
		
	end
	
	
	if(action.name == "wait_for_target") then
		
		if(selectTarget ~= nil) then
			
			result =  true
			
		end
		
		
	end
	
	if(action.name == "wait_for_selection") then
		
		result = selectedEntity
		
		
	end
	
	
	if(action.name == "while_one") then
		
		local trigger = action.trigger
		result = checkTrigger(trigger)
		debugPrint(1,"while one "..tostring(result))
		executeAction(action.action,tag,parent,index,source,executortag)
		
		
	end
	
	if(action.name == "finish_mission") then
	
		if currentQuest ~= nil and currentQuest.tag == action.tag then
				
				result = true
				canDoEndAction = true
				
		else
			 
				 if currentQuest == nil or (currentQuest ~= nil and currentQuest.tag ~= action.tag) then
					 
					result = false
				
					 
				end
		 
		end
	
	end
	
	return result
end

function cleanThreadManager()
	if GameUI.IsDetached() then
		workerTable = {}
		actionistaken = false
	end
	
	local count = 0
	if(#workerTable > 0 ) then
		
		for i=1, #workerTable do
			
			if workerTable[i].active == false then
				count = count + 1
			end
			
		end
		
		
		if(count == #workerTable) then
			----debugPrint(1,"clean worker table")
			workerTable = {}
			actionistaken = false
		end
		
	end
	
end




--requirement
function checkTriggerRequirement(requirement,triggerlist)
	
	local result = false
	
	if GameUI.IsLoading() == false and requirement ~= nil then
		
		for i=1, #requirement do --pour chaque requirement de la quete
			
			local requirementcondition = requirement[i]
			local count = 0
			
			for y =1,#requirementcondition do --pour chaque condition du requirement en cours
				
				
				if(result == false) then --si un requirement n'a pas été validé déja
					
					local trigger = triggerlist[requirementcondition[y]]
					
					local triggerIsOk = checkTrigger(trigger) --on evalue le trigger
					
					if(triggerIsOk) then --on incrémente le compteur si le trigger est ok
						
						
						count = count +1
					end
					
					
				end
				
				
				
				
			end
			
			if(count == #requirementcondition) then --si le compteur de bon trigger est egale a la totalité du requirementcondition, c'est que tout les parametres sont requis pour ce requirement
				result = true
			end
			
			
			
			
			
		end	
		
		if(#requirement == 0 and #triggerlist == 0) then
			result = true
			
		end
		
	end
	
	return result
end

function testTriggerRequirement(requirement,triggerlist)
	local result = false
	
	for i=1, #requirement do --pour chaque requirement de la quete
		
		local requirementcondition = requirement[i]
		
		local count = 0
		print("Requirement : "..#requirementcondition)
		debugPrint(1,dump(requirementcondition))
		for y =1,#requirementcondition do --pour chaque condition du requirement en cours
			
			print("Requirement : "..requirementcondition[y])
			if(result == false) then --si un requirement n'a pas été validé déja
				print("Trigger : "..requirementcondition[y])
				local trigger = triggerlist[requirementcondition[y]]
				print("Trigger : ")
				print(trigger.name)
				
				local triggerIsOk = checkTrigger(trigger) --on evalue le trigger
				print(triggerIsOk)
				if(triggerIsOk) then --on incrémente le compteur si le trigger est ok
					
					
					
					count = count +1
					print(count)
				end
				
				
			end
			
			
			
			
		end
		
		if(count == #requirementcondition) then --si le compteur de bon trigger est egale a la totalité du requirementcondition, c'est que tout les parametres sont requis pour ce requirement
			result = true
		end
		
		
		
		
		
	end	
	
	if(#requirement == 0 and #triggerlist == 0) then
		result = true
		
	end
	
	return result
end




--run action Thread
function runActionList(actionlist, tag, source,isquest,executortag,bypassMenu)
	
	
	local copy = deepcopy(actionlist, copies)
	
	-- for k,v in pairs(copy) then
	-- copy[k]["active"] = true
	-- end
	
	if(source == nil) then
		source = "interact"
	end
	
	
	
	
	if(workerTable[tag] == nil) then
		workerTable[tag] = {}
	end
	
	workerTable[tag]["action"] = copy
	workerTable[tag]["index"] = 1
	workerTable[tag]["parent"] = ""
	workerTable[tag]["started"] = false
	workerTable[tag]["pending"] = false
	workerTable[tag]["disabled"] = false
	workerTable[tag]["source"] = source
	workerTable[tag]["executortag"] = executortag
	workerTable[tag]["bypassMenu"] = bypassMenu
	
	if(isquest ~= nil) then
		workerTable[tag]["quest"] = isquest
	end
	
end

function runSubActionList(actionlist, tag, parent, source, isquest,executortag,bypassMenu)
	
	
	
	local copy = deepcopy(actionlist, copies)
	
	-- for k,v in pairs(copy) then
	-- copy[k]["active"] = true
	-- end
	
	if(source == nil) then
		source = "interact"
	end
	
	if(workerTable[tag] == nil) then
		workerTable[tag] = {}
	end
	
	
	workerTable[tag]["action"] = copy
	workerTable[tag]["index"] = 1
	workerTable[tag]["parent"] = parent
	workerTable[tag]["pending"] = false
	workerTable[tag]["started"] = false
	workerTable[tag]["source"] = source
	workerTable[parent]["pending"] = true
	workerTable[parent]["children"] = tag
	workerTable[tag]["disabled"] = false
	workerTable[tag]["executortag"] = executortag
	workerTable[tag]["bypassMenu"] = bypassMenu
	
	if(isquest ~= nil and isquest == true) then
		workerTable[tag]["quest"] = true
	end
	
end




--Do and Check object
function doEvent(tag)
	
	local boj = arrayEvent[tag]
	
	if( boj ~= nil) then
		local event = boj.event
		--testTriggerRequirement(event.requirement,event.trigger)
		
		if(checkTriggerRequirement(event.requirement,event.trigger))then
		
			--print("CyberScript : Doing event : "..event.name)
			
			--	doActionof(event.action,"interact")
			runActionList(event.action, tag, "interact",false,"nothing")
			else
			--print("CyberScript : can't do event : "..event.name)
			
		end
	end
end

function doFunction(tag)
	
	local boj = arrayFunction[tag]
	local event = boj.func
	debugPrint(1,event.tag)
	runActionList(event.action, tag, "interact",false,"nothing",boj.func.bypassmenu)
	
end

function doTriggeredEvent()
	
	
	
	worldprocessing = true
	
	possibleEvent = {}
	
	
	
	for key,value in pairs(arrayEvent) do --actualcode
		
		local event = arrayEvent[key].event
		
		if(event.way == "world") then
			--debugPrint(1,"check for "..event.name)
			--testTriggerRequirement(event.requirement,event.trigger)
			if(checkTriggerRequirement(event.requirement,event.trigger))then
				
				runActionList(event.action,key,"interact",false,"nothing")
				
			end
		end 
	end
	
	worldprocessing = false
	
	
end

function doInitEvent()
	
	
	
	worldprocessing = true
	
	possibleEvent = {}
	
	
	
	for key,value in pairs(arrayEvent) do --actualcode
		
		local event = value.event
		
		if(event.way == "init") then
			
			if(checkTriggerRequirement(event.requirement,event.trigger))then
				
				
				
				runActionList(event.action,key,"interact",false,"nothing")
			end
		end 
	end
	
	worldprocessing = false
	print("CyberScript : doing init event...")
	
end

function doIf(action,list,currentindex,listaction)
	if(list[1].name ~= "goto" or list[1].name ~= "if") then
		local moveindex = #list
		local newlist = listaction
		for i = 1, moveindex do
			newlist[currentindex+moveindex+i] =  newlist[currentindex+i]
		end
		
		for i = 1, moveindex do
			newlist[currentindex+i] =  list[i]
		end
		
		debugPrint(1,"List Is :")
		for i=1, #newlist do
			debugPrint(1,newlist[i].name)
		end
		debugPrint(1,"End of ")
		action.newlist = newlist
		
		
		
		return false
	end	
	
end

function checkIf(action,parent,source,executortag)
	
	local trigger = action.trigger
	if(checkTrigger(trigger)) then
		
		local tag= "if_"..math.random(1,9999)
		local actiontodo = action.if_action
		runSubActionList(actiontodo, tag.."_if", parent,source,false,executortag)
		
		else
		
		local tag= "else_"..math.random(1,9999)
		local actiontodo = action.else_action
		runSubActionList(actiontodo, tag.."_else", parent,source,false,executortag)
		
		
		
		
	end
	
	
	
	
end

function checkEvents()
	
	getTriggeredActions()
	local message = ""
	
	if(#possibleInteract > 0) then
		message = message.."There is some interactions"
		else
		message = message.."There is no interactions"
	end
	
	if currentQuest == nil then
		
		if(#possibleQuest > 0) then
			message = message.." and some quest"
			else
			message = message.." and no quest"
		end
		
		
	end
	
	message = message.." available near from you"
	Game.GetPlayer():SetWarningMessage(message)
	
end

function checkAmbush()
	local ambushevent = {}
	
	if(AmbushEnabled == true and isAVinService == false) then
		--debugPrint(1,"mark1")
		if(currentDistricts2.customdistrict ~= nil) then
			--debugPrint(1,"mark1")		
			
			
			print("check ambsush")
			--	debugPrint(1,"mark1")	
			for k,v in pairs(arrayEvent) do
				
				if(arrayEvent[k].event.way == "ambush") then
					--debugPrint(1,arrayEvent[k].event.way)
					--table.insert(ambushevent,k)
					print(k)
					doEvent(k)
					
					
				end
			end
			
			-- if(#ambushevent > 0) then
				-- local tag = math.random(1,#ambushevent)
				-- debugPrint(1,"doing ambush "..tag)
				-- doEvent(ambushevent[tag])
			-- end
			
			
			
			
			
			
			
			
		end
	end
	
end

function checkSpeakDialog()
	
	if currentStar ~= nil then
		--if string.match(currentStar.Names,targName) then
		
	
		
		if tostring(TweakDBID.new(currentStar.TweakIDs)) == tostring(objLook:GetRecordID()) then
			
			if startSpeak == false then
				
				selectNPCForSpeak(currentStar)
				
				
				
				
			end
			else
			if(currentDialogHub ~= nil) then
			openSpeakDialogWindow = false	
			startSpeak =false
			isdialogactivehub = false
			removeDialog()
			currentDialogHub = nil
			debugPrint(1,"totot")
			end
		end
		
	
	end
	
	if objLook == nil then
		
		openSpeakDialogWindow = false	
		startSpeak =false
		
	end
	
end

function checkFixer()
	
	if (arrayQuest2 ~= nil ) then
		
		
		if phonedFixer == false then
			if curPos ~= nil then
				--	debugPrint(1,curPos)
				currentfixer = checkWithFixer(curPos)
			end
		end
		
		
		
		-- pcall(function() 
		if(currentfixer ~= nil) then
			
			
			if(checkTriggerRequirement(currentfixer.requirement,currentfixer.trigger)) then
				
				
				
				if(currentfixer.npcexist == false) then
					
					if(fixerCanSpawn == true)then
						
						
						
						local obj = getEntityFromManager(currentfixer.Tag)
						
						
						
						
						if(obj.tag == nil) then
							
							
							local twkVehi = TweakDBID.new(currentfixer.NPCId)
							
							spawnEntity(currentfixer.NPCId,currentfixer.Tag,currentfixer.LOC_X, currentfixer.LOC_Y, currentfixer.LOC_Z, 5, false, false)
							
							
							Cron.After(1, function()
								local obj = getEntityFromManager(currentfixer.Tag)
								local enti = Game.FindEntityByID(obj.id)
								lookAtPlayer(enti, 999999999)
								currentfixer.Id = enti
							end)
							
							
							fixerCanSpawn = false
							
							debugPrint(1,oldfixer)
						end
						
					end
					
				end
				
				if(currentfixer.spawn_action ~= nil and #currentfixer.spawn_action >0 and fixerIsSpawn == false) then
					debugPrint(1,"fixer Ok")
					--doActionof(currentfixer.action,"interact")
					
					runActionList(currentfixer.spawn_action, currentfixer.Tag.."_Spawn",nil,nil,currentfixer.Tag)
					--fixerIsSpawn = true
				end
				
				fixerIsSpawn = true
				oldfixer = currentfixer.Tag
				
				
				
				
				
			end
			
			
			--	local dbPnjId = getNPCById(currentfixer.NPCId)
			
			local tarbName = ""
			
			if objLook ~= nil then
				
				tarbName =  objLook:ToString()
				
			end
			
			if(string.match(tarbName, "NPCPuppet"))then
				--debugPrint(1,tostring(TweakDBID.new(dbPnjId.TweakIDs)))
				--debugPrint(1,tostring(objLook:GetRecordID()))
				--if string.match(currentfixer.Name,targName) then
				if objLook ~= nil and currentfixer ~= nil and objLook:GetEntityID() == currentfixer.Id and tostring(TweakDBID.new(currentfixer.NPCId)) == tostring(objLook:GetRecordID()) then
					
					
					local handle = objLook
					local NPC = handle:GetAIControllerComponent()
					local targetTeam = handle:GetAttitudeAgent()
					
					local SetState = NewObject('handle:AIRole')
					--SetState:SetFollowTarget(Game:GetPlayerSystem():GetLocalPlayerControlledGameObject())
					SetState:OnRoleSet(handle)
					SetState.followerRef = Game.CreateEntityReference("#player", {})
					targetTeam:SetAttitudeGroup(CName.new("player"))
					SetState.attitudeGroupName = CName.new("player")
					
					Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](handle, Game:GetPlayer())
					Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](handle, "Relaxed")
					NPC:SetAIRole(SetState)
					handle.movePolicies:Toggle(true)
					--local get_godmode = Game.GetGodModeSystem()
					--get_godmode:AddGodMode(objLook,"Immortal", CName.new("Default"))	
					
					
				end		
				
			end
			else
			
			
			if fixerIsSpawn == true then
				debugPrint(1,"oldfixer")
				if(oldfixer ~= nil)then
					
					despawnEntity(oldfixer)
					
					
				end
				
				local oldFixer = getFixerByTag(oldfixer)
				
				if(oldFixer ~= nil and oldFixer.despawn_action ~= nil and #oldFixer.despawn_action >0) then
					
					--doActionof(currentfixer.action,"interact")
					runActionList(oldFixer.despawn_action, oldFixer.Tag.."_Despawn",nil, nil,currentfixer.Tag)
					
					
					
				end
				
				fixerIsSpawn = false
				fixerCanSpawn = true
				
				Game.ChangeZoneIndicatorPublic()
				QuestNotOpen = false
			
			end
			
			
			
		end
		
		-- end)
		
	end
	
	
end

function checkNPC()
	
	
	local playerpos= Game.GetPlayer():GetWorldPosition()
	
		for k,v in pairs(arrayCustomNPC) do
			
			local npc = arrayCustomNPC[k].npc
			
			--testTriggerRequirement(npc.requirement,npc.triggers)
			--spdlog.error(npc.tag)
			if(check3DPos(playerpos, npc.workinglocation.x,  npc.workinglocation.y,  npc.workinglocation.z, npc.workinglocation.radius) and npc.isspawn==false and checkTriggerRequirement(npc.requirement,npc.triggers) ) then
				
				
				local tweakDBnpc =  npc.tweakDB
				
				if(tweakDBnpc== "district") then
					
					local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
					
					if(#gangs == 0) then
					
					break
					
					end
					
					local gang = getFactionByTag(gangs[1].tag)
					
					if(#gang.SpawnableNPC > 0) then
						local index = math.random(1,#gang.SpawnableNPC)
						
						tweakDBnpc = gang.SpawnableNPC[index]
					else
					break
					end
				
				elseif (tweakDBnpc== "subdistrict") then
				
				local gangs = {}
				
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						
						
					gangs = getGangfromDistrict(test,20)
					
						if(#gangs == 0) then
							
						break
						
						end
					end
				end
					
					local gang = getFactionByTag(gangs[1].tag)
					
					if(#gang.SpawnableNPC > 0) then
						local index = math.random(1,#gang.SpawnableNPC)
						
						tweakDBnpc = gang.SpawnableNPC[index]
					else
					break
					end
				
				if(tweakDBnpc== "districttag") then
					
					gangs = getGangfromDistrict(npc.locationtag,20)
					
					if(#gangs == 0) then
					
					break
					
					end
					
					local gang = getFactionByTag(gangs[1].tag)
					
					if(#gang.SpawnableNPC > 0) then
						local index = math.random(1,#gang.SpawnableNPC)
						
						tweakDBnpc = gang.SpawnableNPC[index]
					else
					break
					end
				
				elseif (tweakDBnpc== "subdistricttag") then
				
				local gangs = {}
				
					gangs = getGangfromDistrict(npc.locationtag,20)
					
					local gang = getFactionByTag(gangs[1].tag)
					
					if(#gang.SpawnableNPC > 0) then
						local index = math.random(1,#gang.SpawnableNPC)
						
						tweakDBnpc = gang.SpawnableNPC[index]
					else
					break
					end
						
						
						
						
					end
				end
				
				
				if(npc.location.value ~= nil and npc.locationtag ~= nil and (tweakDBnpc== "district" or tweakDBnpc== "subdistrict" or tweakDBnpc== "districttag" or tweakDBnpc== "subdistricttag")) then
				
					
					
					
					
				if(npc.location.value == "poi_near") then
					
						local district = npc.locationtag
						
							
						local currentpoi = nil
						
						if(tweakDBnpc== "district")then
						
						district = currentDistricts2.Tag
						
						end
						
						if(tweakDBnpc== "subdistrict")then
						
						district = currentDistricts2.districtLabels[2]
						
						end
					
					
					
				
				
					
					for k,v in pairs(arrayPOI) do
						
						if(#v.poi.locations > 0) then
							
							
							for y=1,#v.poi.locations do
								
								local location = v.poi.locations[y]
								
								
									if((location.subdistrict == district or location.district == district) and check3DPos(curPos, location.x, location.y,location.z,npc.location.range,20)) then
										
										currentpoi = location
										break;
										
									end
									
									
									
									
								end
								
							end
							
							
						
						
					end
				
			
					
					if(currentpoi ~= nil) then
						if(npc.useBetaSpawn == true) then
												
							spawnEntity(tweakDBnpc, npc.tag,  currentpoi.x ,  currentpoi.y , currentpoi.z, 90, true, false, true)
							
							else
							spawnEntity(tweakDBnpc, npc.tag,  currentpoi.x ,  currentpoi.y , currentpoi.z, 90, true, false, false)
						end
					end
				end
				
				else
				
				
				if(npc.useBetaSpawn == true) then
										
					spawnEntity(tweakDBnpc, npc.tag,  npc.location.x ,  npc.location.y , npc.location.z, 90, true, false, true)
					
					else
					spawnEntity(tweakDBnpc, npc.tag,  npc.location.x ,  npc.location.y , npc.location.z, 90, true, false, false)
				end
				
				
				
				
				end
				
				npc.isspawn=true
				npc.init=false
				
				
				elseif(npc.isspawn==true) then
				
				local obj = getEntityFromManager(arrayCustomNPC[k].npc.tag)
				
				if(obj.id ~= nil) then
					local enti = Game.FindEntityByID(obj.id)	
					
					
					if(enti ~= nil) then
						
						if((check3DPos(Game.GetPlayer():GetWorldPosition(), npc.workinglocation.x,  npc.workinglocation.y,  npc.workinglocation.z, npc.workinglocation.radius) and npc.spawnforced == false) or npc.spawnforced == true) then
							
							if(arrayCustomNPC[k].npc.init==false) then
								
								local npc = arrayCustomNPC[k].npc
								
								if(npc.appeareance ~= nil or npc.appeareance ~= "" and arrayCustomNPC[k].npc.appearancesetted == false) then
									
									local obj = getEntityFromManager(npc.tag)
									local enti = Game.FindEntityByID(obj.id)
									if(enti ~= nil) then
										
										--getAppearance(enti)
										setAppearance(enti,npc.appeareance)
										arrayCustomNPC[k].npc.appearancesetted = true
									end
									
									
								end
								
								if(npc.spawnEdited == nil or npc.spawnEdited == false) then
									
									local newnpcspawn = {}
									
									local rotateaction = {}
									
									rotateaction.name = "rotate_entity_to_entity"
									rotateaction.tag = "this"
									rotateaction.entity = "player"
									
									table.insert(newnpcspawn,rotateaction)
									
									local wait01action = {}
									
									wait01action.name = "wait_second"
									wait01action.value = "1"
									
									table.insert(newnpcspawn,wait01action)
									
									local lookataction = {}
									
									lookataction.name = "look_at_entity_entity"
									lookataction.tag = "this"
									lookataction.entity = "player"
									
									
									
									table.insert(newnpcspawn,lookataction)
									
									table.insert(newnpcspawn,wait01action)
									
									if(#npc.spawnaction > 0) then
										
										for i=1,#npc.spawnaction do
											
											table.insert(newnpcspawn,npc.spawnaction[i])
											
										end
										
										
									end
									
									npc.spawnaction = newnpcspawn
									arrayCustomNPC[k].npc.spawnEdited = true
								end
								
								if(workerTable[npc.tag.."_spawn"] == nil and #npc.spawnaction > 0 and npc.dospawnaction == true) then
									
									
									
									runActionList(npc.spawnaction, npc.tag.."_spawn", "interact",false,npc.tag)
									
								end
								
								if(workerTable[npc.tag.."_routine"] == nil and #npc.routineaction > 0 and npc.doroutineaction == true) then
									runActionList(npc.routineaction, npc.tag.."_routine", "interact",false,npc.tag)
									
								end
								
								
								arrayCustomNPC[k].npc.init = true
								
								else
								
								
								
								if(workerTable[npc.tag.."_routine"] == nil and npc.repeat_routine == true and #npc.routineaction > 0 and npc.doroutineaction == true) then
									runActionList(npc.routineaction, npc.tag.."_routine", "interact",false,npc.tag)
								--	debugPrint(1,"doing routine of "..npc.name)
									
								end
								
								
								if (workerTable[npc.tag.."_death"] == nil and npc.deathaction ~= nil and #npc.deathaction > 0 and (enti:IsDead() == true or enti:IsActive() == false) and npc.dodeathaction == true)then
									runActionList(npc.deathaction, npc.tag.."_death", "interact",false,npc.tag)
									
									npc.dodeathaction= false
								end
							end
							
							
							else
							
							
							if(npc.auto_despawn == true) then
								
								arrayCustomNPC[k].npc.isspawn=false
								arrayCustomNPC[k].npc.init=false
								arrayCustomNPC[k].npc.appearancesetted = nil
								
								if(workerTable[npc.tag.."_spawn"] ~= nil) then
									
									workerTable[npc.tag.."_spawn"] = nil
									
								end
								
								if(workerTable[npc.tag.."_routine"] ~= nil) then
									
									workerTable[npc.tag.."_routine"] = nil
									
								end
								
								if(workerTable[npc.tag.."_death"] ~= nil) then
									
									workerTable[npc.tag.."_death"] = nil
									
								end
								
								despawnEntity(npc.tag)
								
								if(workerTable[npc.tag.."_despawn"] == nil and #npc.despawnaction > 0 and npc.dospawnaction == true) then
									runActionList(npc.despawnaction, npc.tag.."_despawn", "interact",false,npc.tag)
									
								end
								
							end
							
						end
						
					end
				end
				
				
				
			end
			
			
			
			
			
		end
	
	
end

function checkValue(operator,value1,value2)
return (
	(value1 ~= nil and value2 ~= nil and 
		(
		(operator == "<" and value1 < value2) or 
		(operator == "<=" and value1 <= value2) or
		(operator == ">" and value1 > value2) or
		(operator == ">=" and value1 >= value2) or
		(operator == "!=" and value1 ~= value2) or 
		(operator == "=" and value1 == value2)
		)
	) or
	(operator == "empty" and value1 == nil) or
	(operator == "notempty" and value1 ~= nil)
	)
		
		
end

--Get List

function getInteractGroup()
	
	currentInteractGroup ={}
	
	local groupof = {}
	
	for key,value in pairs(arrayInteract) do --actualcode
		
	
		local interact2 = arrayInteract[key].interact
		local canadd = true
		
		for i=1,#currentInteractGroup do
		
			if(currentInteractGroup[i] == interact2.group)  then
				canadd = false
		
			end
		
		end
		
		if(canadd == true) then
			
			table.insert(currentInteractGroup, interact2.group)
			
		end
		
		
	end
	
	
	
	
end

function getTriggeredActions()
	
	
	
	worldprocessing = true
	local possibleinteractchunk = {}
	possibleInteract = {}
	local possibleinteractchunked = {}
	
	
	for key,value in pairs(arrayInteract) do --actualcode
		
		local interact2 = arrayInteract[key].interact
		
		--testTriggerRequirement(interact2.requirement,interact2.trigger)
		if(checkTriggerRequirement(interact2.requirement,interact2.trigger)) and (interact2.group == currentInteractGroup[currentInteractGroupIndex] or key == "open_datapack_group_ui") then
			
		--debugPrint(1,"check for "..interact2.name.." "..tostring(checkTriggerRequirement(interact2.requirement,interact2.trigger)))
			table.insert(possibleinteractchunk, interact2)
		else
			
			if(#currentInputHintList > 0) then
		
				for i = 1, #currentInputHintList do
					
					if(currentInputHintList[i].tag == interact2.tag) then
						hideCustomHints(interact2.tag)
						currentInputHintList[i] = nil
					end
					
				
				end
			
			
			end
		
	end
	end
	local chunk = {}
	local count = 1
	
	
	for i=1,#possibleinteractchunk+1 do 
		
		--	
		if(#chunk < 4 and i<#possibleinteractchunk+1) then
			
			
			if(possibleinteractchunk[i] ~= nil) then
				
				table.insert(chunk,possibleinteractchunk[i])
				count = count + 1
				
			end
			
			else
			
			
			
			local chunkcopy = {}
			for z=1,#chunk do 
				
				table.insert(chunkcopy,chunk[z])
				
			end
			
			table.insert(possibleInteract,chunkcopy)
			
			
			if(possibleinteractchunk[i] ~= nil) then
				chunk = {}
				table.insert(chunk,possibleinteractchunk[i])
				
				count = 1
				
			end
		end
		
		
	end
	
	
	
	
	
	
	worldprocessing = false
	
	
end

function getTriggeredActionsDisplay()
	
	-- if(#currentInputHintList > 0) then
		
		-- for i = 1, #currentInputHintList do
		
			-- hideCustomHints(currentInputHintList[i].tag)
		
		-- end
		
	-- end
	
	
	possibleinteractchunk = {}
	
	local possibleinteractchunked = {}
	possibleInteractDisplay = {}
	for i=1,#possibleInteract do
		
		for z=1,#possibleInteract[i] do 
			
			
			if((possibleInteract[i][z].display == "event_interact" 
				or 
				(currentHouse ~= nil and (possibleInteract[i][z].display == "place"
					or possibleInteract[i][z].display == "place_main" or 
					possibleInteract[i][z].display == "event_interact")))) then
				table.insert(possibleinteractchunk,possibleInteract[i][z])
			end
			
			
		end
		
		
	end
	
	
	local chunk = {}
	
	for i=1,#possibleinteractchunk+1 do 
		
		--	
		if(#chunk < 4 and i<#possibleinteractchunk+1) then
			
			
			if(possibleinteractchunk[i] ~= nil) then
				
				table.insert(chunk,possibleinteractchunk[i])
				
				
			end
			
			else
			
			
			
			local chunkcopy = {}
			for z=1,#chunk do 
				chunk[z].input=z
				table.insert(chunkcopy,chunk[z])
				
			end
			
			table.insert(possibleInteractDisplay,chunkcopy)
			
			if(possibleinteractchunk[i] ~= nil) then
				chunk = {}
				table.insert(chunk,possibleinteractchunk[i])
				
				
			end
		end
		
		
	end
	
	
	
	
	
	
	
end

function getMissionByTrigger()
	
	
	--find new mission
	
		
		possibleQuest = {}
		
		for key,value in pairs(arrayQuest2) do --actualcode
			
			
			-- debugPrint(1,tostring(QuestManager.isVisited(key)))
			if(checkQuestStatutByTag(key, nil) == true or checkQuestStatutByTag(key, -1) == true) then
				local quest = arrayQuest2[key].quest
				debugPrint(1,key)
			--	debugPrint(1,tostring(HaveTriggerCondition(quest)))
				if(HaveTriggerCondition(quest))then
				debugPrint(1,key.."is triggerable")
					--------debugPrint(1,"trigger")
					
					--if(possibleQuest[quest] ~= nil) then
					table.insert(possibleQuest, quest)
					QuestManager.MarkQuestAsActive(quest.tag)
				
					--end
					
					else
					--debugPrint(1,tostring(QuestManager.isVisited(key)))
					if not QuestManager.isVisited(key) then
						QuestManager.MarkQuestAsInactive(key)
						--debugPrint(1,"remove"..key)
					end
				end
					
			else
					if(checkQuestStatutByTag(key, 3) == true) then
						--QuestManager.MarkQuestAsInactive(key)
						QuestManager.MarkQuestASucceeded(key)
					end
			
			end
			
		end
		
		
		
	
	
	
	takenQuest = {}
		
	for key,value in pairs(arrayQuest2) do --actualcode
			local statuQue = checkQuestStatutByTag(key, 0) or checkQuestStatutByTag(key, 1) or checkQuestStatutByTag(key, 2)
			
		if( statuQue== true) then
		
			local quest = arrayQuest2[key].quest
			
				
			
				
				--if(possibleQuest[quest] ~= nil) then
				--table.insert(takenQuest, quest)
				QuestManager.MarkQuestAsActive(quest.tag)
				--end
			
		end
		
	end
	
	
	
end





--GET objects

function getEventByTag(tag)
	debugPrint(1,"d,f,	")
	for i=1,#arrayEvent do
		debugPrint(1,arrayEvent[i].event.name)
		if(arrayEvent[i].event.tag == tag)then
			
			return arrayEvent[i].event
			
		end
		
	end
	
	return nil
end

function getSubtitleByTag(tag)
	
	for i=1,#arraySubtitle do
		
		if(arraySubtitle[i].tag == tag)then
			
			return arraySubtitle[i]
			
		end
		
	end
	
	return nil
end

function getShardByTag(tag)
	

	if(arrayShard[tag] ~= nil)then
			
			return arrayShard[tag].shard
			
	end
	return nil
	
end

function getCustomNPCByTag(tag)
	
	
		if(arrayCustomNPC[tag] ~= nil)then
			
			return arrayCustomNPC[tag].npc
			
		end
	return nil
	
end

function getInteractByTag(tag)
	
	return arrayInteract[tag].interact
	
	
end

function getInteractsBySortTag(tag)
	local result = {}
	
	for i = 1, #possibleInteract do
		
		for z = 1, #possibleInteract[i] do
			--debugPrint(1,possibleInteract[i].name)
			if(possibleInteract[i][z].sorttag == tag)then
				
				table.insert(result, possibleInteract[i][z])
				
			end
			
		end
		
	end
	
	return result
end

function getPhoneConversationByTag(tag)
	
		if(arrayPhoneConversation[tag] ~= tag)then
			
			return arrayPhoneConversation[tag].conv
			
		end
	
	return nil
	
end

function getPath(tag)
	
	
	if(arrayPath[tag] ~= nil) then
	return arrayPath[tag].gamepath
	end
	return nil
	
end

function getPOI(tag)
	
	
	if(arrayPOI[tag] ~= nil) then
	return arrayPOI[tag].poi
	end
	return nil
	
	
end

function FindPOI(tag,district,subdistrict,iscar,poitype,locationtag,fromposition,range)
	local currentpoilist = {}
	for k,v in pairs(arrayPOI) do
							
							
			
			
			if
				(#v.poi.locations > 0) then	
				
				for y=1,#v.poi.locations do
					
					local location = v.poi.locations[y]
					
					-- debugPrint(1,"TEST POI ---")
					-- debugPrint(1,"tag : "..tostring((
									-- ((tag == nil or tag == "" or (v.poi.tag ~= nil and v.poi.tag == tag)) and locationtag == false) or
									-- ((tag == nil or tag == "" or (location.Tag ~= nil and location.Tag == tag)) and locationtag == true)
								-- )))
								
					-- debugPrint(1,"district : "..tostring((district == nil or district == "" or (district ~= nil and location.district == district))))
					-- debugPrint(1,"subdistrict : "..tostring((subdistrict == nil or subdistrict == "" or (subdistrict ~= nil and location.subdistrict == subdistrict))))
					
					-- debugPrint(1,"iscar : "..tostring((iscar == nil or (iscar ~= nil and location.inVehicule == iscar))))
					-- debugPrint(1,"poitype : "..tostring((poitype == nil or poitype == 1 or (poitype == v.poi.isFor))))
					-- debugPrint(1,"fromposition : "..tostring((fromposition == false or	(fromposition == true and check3DPos(curPos, location.x, location.y, location.z, range)))))
					-- debugPrint(1,"TEST POI ---")
							
							if
							(
								(
									((tag == nil or tag == "" or (v.poi.tag ~= nil and v.poi.tag == tag)) and locationtag == false) or
									((tag == nil or tag == "" or (location.Tag ~= nil and location.Tag == tag)) and locationtag == true)
								)
								
								and
								
								(district == nil or district == "" or (district ~= nil and location.district == district)) and
								(subdistrict == nil or subdistrict == "" or (subdistrict ~= nil and location.subdistrict == subdistrict)) and
								(iscar == nil or (iscar ~= nil and location.inVehicule == iscar)) and
								
								
								(poitype == nil or 
								
									(
										(isArray(poitype) == false and isArray(v.poi.isFor) == false and (poitype == 1 or (poitype == v.poi.isFor))) or
										(isArray(poitype) == true and isArray(v.poi.isFor) == false and table.contains(poitype,v.poi.isFor)) or
										(isArray(poitype) == false and isArray(v.poi.isFor) == true and table.contains(v.poi.isFor,poitype)) or
										(isArray(poitype) == true and isArray(v.poi.isFor) == true and table.compare(poitype, v.poi.isFor))
									)
									
								) and
							
							
							(fromposition == false or	(fromposition == true and check3DPos(curPos, location.x, location.y, location.z, range)))
							
							
							)
							then
								
								
									
								
									table.insert(currentpoilist,v.poi.locations[y])
									
									
									
															
								
							
								
							end
							
							
						
					
					
				end
				
				
			end
			
		end
	
	if(#currentpoilist > 0) then
	
		local currentpoi = nil
		currentpoi = currentpoilist[math.random(#currentpoilist)]
		
		return currentpoi
		else
		return nil
	end
	
end

function getNodeIndexFromCircuit(tag,listnodes)
	for i=1,#listnodes do
		
		
		
		
		if(listnodes[i] == tag)then
			return i
		end
		
		
		
		
		
		
	end
end

function getPathBetweenTwoNode(CurrentNode, NextNode)
	debugPrint(1,"CurrentNode"..CurrentNode)
	debugPrint(1,"NextNode"..NextNode)
	for k,v in pairs(arrayPath)do
		
		
		local path = v.gamepath
		debugPrint(1,"startNode"..path.startNode)
		debugPrint(1,"endNode"..path.endNode)
		
		if(path.startNode == CurrentNode and path.endNode == NextNode)then
			return path
		end
		
		
		
		
		
		
	end
end

function getNodefromPosition(x,y,z,range)
	local vec4 = {}
	vec4.x = x
	vec4.y = y
	vec4.z = z
	
	for k,v in pairs(arrayNode) do
		
		
		local node = v.node
		
		
		
		if(check3DPos(vec4,node.X,node.Y,node.Z,range) or check3DPos(vec4,node.GameplayX,node.GameplayY,node.GameplayZ,range))then
			return node
		end
		
		
		
		
		
		
	end
	
	
end

function getTrack(tag)
	
	for i=1,#arrayTrack do
		
		
		local location = arrayTrack[i]
		
		if(location.tag == tag)then
			return location
		end
		
		
		
		
		
		
	end
	
	
end

function getCurrentTrack(tag)
	
	for i=1,#enabledTrack do
		
		
		local location = enabledTrack[i]
		
		if(location.tag == tag)then
			return location
		end
		
		
		
		
		
		
	end
	
	
end

function getCurrentTrackIndex(tag)
	
	for i=1,#enabledTrack do
		
		
		local location = enabledTrack[i]
		
		if(location.tag == tag)then
			return i
		end
		
		
		
		
		
		
	end
	
	
end

function checkQuestStatutByTag(tag, statut)
	local result = false
	
	
	
	
	
	
	
	
	if(currentSave.Score[tag] ~= nil) then
	
		
		
		if( currentSave.Score[tag]["Score"] == statut) then
			result = true
		end
		
	else
	
		if(currentSave.Score[tag] == statut) then
		
			result = true
		
		end
			
	end
	
	return result
end

function getCircuit(tag)
	
	
	
	if(arrayCircuit[tag] ~= nil) then
	return arrayCircuit[tag].circuit
	end
	
	
end

function getNode(tag)
	
	
	if(arrayNode[tag] ~= nil) then
	return arrayNode[tag].node
	end
		
		
		
		
		
		
	end

function getRadioByTag(tag)
	
		
			
			if(arrayRadio[tag] ~= nil)then
				return arrayRadio[tag].radio
			end
		
		
		return nil
	
end	

function getMappinByTag(tag)
	
	
	return mappinManager[tag]
	
end

function getPNJ (tab, val)
    for index, value in ipairs(tab) do
        if value.ID == val then
			
            return value
        end
    end

    return false
end

function getGameTime()

	local temp = {}
	local gameTime = Game.GetTimeSystem():GetGameTime()
	
	temp.hour = GetSingleton('GameTime'):Hours(gameTime)
	temp.min = GetSingleton('GameTime'):Minutes(gameTime)
	temp.sec = GetSingleton('GameTime'):Seconds(gameTime)
	temp.day = GetSingleton('GameTime'):Days(gameTime)
	
	return temp

end

function getDistrictfromEnum(enum)
	
	for i = 1, #arrayDistricts do
		if arrayDistricts[i].EnumName:upper() == Game.GetLocalizedText(enum):upper() then
				return arrayDistricts[i]
				
				
		end
			
	end
	
end

function getDistrictBySubfromEnum(enum)
	
	for i = 1, #arrayDistricts do
	if(#arrayDistricts[i].SubDistrict > 0) then
		for j=1,#arrayDistricts[i].SubDistrict do
			if arrayDistricts[i].SubDistrict[j]:upper() == Game.GetLocalizedText(enum):upper() then
					return arrayDistricts[i]
					
					
			end
		end
	end	
	end
	
end

function getDistrictByTag(district)
	
	for i = 1, #arrayDistricts do
	if(arrayDistricts[i].Tag == district) then
		
		
					return arrayDistricts[i]
					
					
		
		end
	end	
end
	
function getMappinByGroup(group)
	local mapLot = {}
	
	for k,v in pairs(mappinManager) do
		if(v.group and v.group == group )then
			table.insert(mapLot,v)
		end
	end
	
	return mapLot
end

function GetPlayerGender()
  -- True = Female / False = Male
  if string.find(tostring(Game.GetPlayer():GetResolvedGenderName()), "Female") then
		return "female"
	else
		return "male"
	end
end

function GetEntityGender(entity)
  -- True = Female / False = Male
  debugPrint(1,tostring(Game.NameToString(entity:GetBodyType())))
  if string.find(tostring(Game.NameToString(entity:GetBodyType())), "oman") then
		return "female"
	else
		return "male"
	end
end

function getQuestByTag(tag)
	
	local parentquest = arrayQuest2[tag]
	local quest = nil
	if(parentquest ~= nil) then
		quest =  parentquest.quest
		--debugPrint(1,parentquest.file)
	end
	return quest
	
	
	end
	
function getQuestStatut(tag)
	
	
	
	local score = getScoreKey(tag,"Score")
			
	if(score ~= nil) then
			return score
			
	end
	
	return nil
	
	
end

function getMarketScoreByTag(tag)
	
	local result = nil

	for i=1,#arrayMarket do
	
		if(arrayMarket[i].tag == tag) then
		return arrayMarket[i]
		end
		
		
	
	end
	
	return result
	
end

function getScorebyTag(tag)
	
	local score = 0
	
	score = getScoreKey(tag,"Score")
	if(score == nil)then
		score = 0
	end
			
	
	
	return score
	
end

function getFactionByDistrictTag(tag)
	
	local factiontable = {}
	
	for k,v in pairs(arrayFaction) do
		
		if(arrayFaction[k].faction.DistrictTag == tag) then
			
			table.insert(factiontable,arrayFaction[k].faction)
			
		end
		
		
		
	end
	
	return factiontable
	
end

function getVIPfromfactionbyscore(factiontag)
	local tempvip = {}
	
	local faction = getFactionByTag(factiontag)
	
	local playerscore = getScorebyTag(factiontag)
	
	
	if(#faction.VIP > 0) then
		for i=1,#faction.VIP do 
		
			if(faction.VIP[i].score <= playerscore) then
			
				local npc = getNPCByName(faction.VIP[i].name)
				
				table.insert(tempvip,npc.TweakIDs)
		
			end
		
		
		end
	end
	
	if(#tempvip == 0) then
	print(getLang("scripting_novip01")..factiontag..getLang("scripting_novip02")..playerscore)
	end
	
	return tempvip
end

function getGangfromDistrict(district,minimum)
	
	local factiontable = {}
	
	for k,v in pairs(currentSave.Score) do
		
		if(currentSave.Score[k][district] ~= nil and currentSave.Score[k][district] >= minimum) then
			
			local factionscore= {}
			factionscore.tag = k
			factionscore.score = currentSave.Score[k][district]
			table.insert(factiontable,factionscore)
			
			else
			
			if(currentSave.Score[k][district] == nil) then
			
				currentSave.Score[k][district] = 0
		
			end
			
		end
		
		
		
	end
	
	table.sort(factiontable, function(a,b) return a.score > b.score end)
	
	return factiontable
	
end

function getGangRivalsFromGang(gang)
	
	local factiontable = {}
	if(currentSave.Score[gang] ~= nil) then
		for k,v in pairs(currentSave.Score[gang]) do
			if(k ~= "Score") then
					local factionscore= {}
					factionscore.tag = k
					factionscore.score =getFactionRelation(gang,k)
					table.insert(factiontable,factionscore)
			end
		end
	end
	table.sort(factiontable, function(a,b) return a.score < b.score end)
	
	return factiontable
	
end

function getGangRivalfromDistrict(gang,district,minimum)
	
	local districttable = {}
	local factiontable = {}
	
	for k,v in pairs(currentSave.Score) do
		
		if(currentSave.Score[k][district] ~= nil and currentSave.Score[k][district] >= minimum) then
			
			local factionscore= {}
			factionscore.tag = k
			factionscore.score = currentSave.Score[k][district]
			table.insert(districttable,factionscore)
			
			else
			
			if(currentSave.Score[k][district] == nil) then
			
				currentSave.Score[k][district] = 0
		
			end
			
		end
		
		
		
	end
	
	
	
	
	for i=1,#districttable do
		
		local factionscore= {}
		factionscore.tag = districttable[i].tag
		factionscore.score = getFactionRelation(gang,districttable[i].tag)
		table.insert(factiontable,factionscore)
	
	end
	
	
	table.sort(factiontable, function(a,b) return a.score > b.score end)
	return factiontable
	
end

function getGangfromDistrictAndSubdistrict(district,minimum)
	
	local factiontable = {}
	
	
	local mydistrict = getDistrictByTag(district)
	
	for k,v in pairs(currentSave.Score) do
		
		
		if(currentSave.Score[k][mydistrict.Tag] ~= nil and currentSave.Score[k][mydistrict.Tag] >= minimum) then
			-- debugPrint(1,k)
			
			local obj = {}
			obj.tag = k
			obj.score = currentSave.Score[k][mydistrict.Tag]
			table.insert(factiontable,obj)
			
			
			
			
			else
			
			if(currentSave.Score[k][mydistrict.Tag] == nil) then
			
				currentSave.Score[k][mydistrict.Tag] = 0
		
			end
			
		end
		
		
		
	end
	
	

	
	table.sort(factiontable, function(a,b) return a.score > b.score end)
	
	return factiontable
	
end

function getGangAffinityfromDistrictAndSubdistrict(district,minimum)
	
	local factiontable = {}
	
	
	
	local mydistrict = getDistrictByTag(district)
	
	for k,v in pairs(currentSave.Score) do
		
		
		if(currentSave.Score[k][mydistrict.Tag] ~= nil and currentSave.Score[k][mydistrict.Tag] >= minimum) then
			
		
			local obj = {}
			obj.tag = k
			obj.score = getScorebyTag(k)
			table.insert(factiontable,obj)
			
			
			
			
			else
			
			if(currentSave.Score[k][mydistrict.Tag] == nil) then
			
				currentSave.Score[k][mydistrict.Tag] = 0
		
			end
			
		end
		
		
		
	end
	
	for i=1,#mydistrict.SubDistrict do
	
	local subdist = mydistrict.SubDistrict[i]
	debugPrint(1,subdist)
		for k,v in pairs(currentSave.Score) do
			
			
			if(currentSave.Score[k][subdist] ~= nil and currentSave.Score[k][subdist] >= minimum) then
			for i=1,#factiontable do
				if(factiontable[i].tag == k) then
				
					factiontable[i].score =  factiontable[i].score + getScorebyTag(k)
				else
					
					local obj = {}
					obj.tag = k
					obj.score = getScorebyTag(k)
					table.insert(factiontable,obj)
					debugPrint(1,k)
					
				end
				
				
				
			end
			end
			
			
		end
	end
	
	
	
	table.sort(factiontable, function(a,b) return a.score > b.score end)
	
	return factiontable
	
end

function getFactionByTag(tag)
	
	local factiontable = {}
	
	for k,v in pairs(arrayFaction) do
		
		if(arrayFaction[k].faction.Tag == tag) then
			
			return arrayFaction[k].faction
			
		end
		
		
		
	end
	
	return factiontable
	
end

function getItemEntityFromManager(entid)
	
	local obj =  nil
	
	if(#currentItemSpawned > 0) then
		for i = 1, #currentItemSpawned do
			
			local enti = currentItemSpawned[i]
			
			
			
			if type(enti.entityId) ~= "number" then
				
				if(enti.entityId.hash == entid.hash) then
					
					obj = enti
					
				end
				
			end
			
			
			
			
			
		end
	end
	return obj
	
	
	
end

function getItemEntityIndexFromManager(entid)
	
	
	
	if(#currentItemSpawned > 0) then
		for i = 1, #currentItemSpawned do
			
			local enti = currentItemSpawned[i]
			
			
			
			if type(enti.entityId) ~= "number" then
				
				if(enti.entityId.hash == entid.hash) then
					
					return i
					
				end
				
			end
			
			
			
			
			
		end
	end
	
	return nil
	
	
	
end

function getItemByHouseTagandTagFromManager(tag,housetag)
	
	
	
	if(#currentItemSpawned > 0) then
		for i = 1, #currentItemSpawned do
			
			local enti = currentItemSpawned[i]
			
			
			
			if enti.HouseTag == housetag and enti.Tag == tag then
				
				
					
					return i
					
				
				
			end
			
			
			
			
			
		end
	end
	
	return nil
	
	
	
end

function getItemEntityFromManagerByPlayerLookinAt()
	
	local obj =  nil
	
	if(#currentItemSpawned > 0) then
		for i = 1, #currentItemSpawned do
			
			local enti = currentItemSpawned[i]
			local playerlook = getForwardPosition(Game.GetPlayer(),2)
			
			
			
			if type(enti.entityId) ~= "number" then
				local postion = Vector4.new(enti.X, enti.Y, enti.Z, 1)
				
				if(check3DPos(postion, playerlook.x, playerlook.y, playerlook.z,1, 3)) then
					
					obj = enti
					
				end
				
			end
			
			
			
			
			
		end
	end
	return obj
	
	
	
end

function getItemFromArrayHousing(tag,X,Y,Z,HouseTag,ItemPath)
	if(#currentSave.arrayHousing > 0) then
		for i=1,#currentSave.arrayHousing do
		
			if(currentSave.arrayHousing[i].Tag == tag and currentSave.arrayHousing[i].X == X and currentSave.arrayHousing[i].Y == Y and currentSave.arrayHousing[i].Z == Z and currentSave.arrayHousing[i].HouseTag == HouseTag and currentSave.arrayHousing[i].ItemPath == ItemPath) then
				return currentSave.arrayHousing[i]
			end
		
		end
	end
	return nil
end

function getItemCountInCart(tag) 
	
	local count = 0
	
	for i=1,#ItemsCart do
	
	if(ItemsCart[i].tag == tag) then
	
	count = count + 1
	
	end
	
	end
	
	
	return count
	
end

function getEntityFromManager(tag)
	local obj = {}
	obj.id = nil
	
		
	local enti = questMod.EntityManager[tag]
	if(enti ~= nil) then
		obj = enti
	end
		
		
	
	
	if(tag == "lookat" and objLook ~= nil) then
		
		
		
		
		
		local enti = questMod.EntityManager["lookat"]
		if(enti ~= nil) and type(enti.id) ~= "number" then
		
			if(enti.id ~= nil and enti.id.hash == objLook:GetEntityID().hash) then
				obj = enti
			end
	
		end	
		
		
		if(obj.id == nil and lookatEntity == nil) then
			obj.id = objLook:GetEntityID()
			obj.tag = "lookat"
			obj.tweak = nil
			
		else
	--		obj.tag = "lookat"
		end
		
		
	end
	
	if(tag == "mounted_vehicle" ) then
		
		if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
						
		
	
		
				local enti = questMod.EntityManager["mounted_vehicle"]
				if (enti ~= nil) and type(enti.id) ~= "number" then
				
					if(enti.id ~= nil and enti.id.hash == Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetEntityID().hash) then
						obj = enti
					end
			
				end	
		
		
		if(obj.id == nil) then
			obj.id = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetEntityID()
			obj.tag = "mounted_vehicle"
			obj.tweak = nil
		else
	--		obj.tag = "lookat"
		end
		
		end
	end
	
	
	
	return obj
end

function getTrueEntityFromManager(tag)
	
	
		
		local enti = questMod.EntityManager[tag]
		if((enti ~= nil) and enti.tag == tag) then
			return enti
		end
		
		
	
	
end

function setEntityFromManager(tag,obju)
	
	
	
		
		questMod.EntityManager[tag] = obju
		
		
		
	
	
	
end

function getExpression(name)
	
	for i = 1, #reactionlist do
		
		local enti = reactionlist[i]
		if(enti.name == name) then
			return enti
		end
		
		
	end
	
end

function getEntityFromManagerById(Id)
	local obj = {}
	obj.id = nil
	for k,v in pairs(questMod.EntityManager) do
		
		local enti = v
		
		
		
		if type(enti.id) ~= "number" then
			
			if(enti.id ~= nil and Id ~= nil and enti.id.hash == Id.hash) then
				obj = v
				
				
			end
			
		end
		
		
		
		
		
	end
	return obj
	
end


function getScannerdataFromEntityOrGroupOfEntity(entity)

	if (ScannerInfoManager[entity.tag] ~= nil) then
		return ScannerInfoManager[entity.tag]
		
	else
		local group= getEntityGroupfromEntityTag(entity.tag)
		if group ~= nil then
		
			if (ScannerInfoManager[group.tag] ~= nil) then
				return ScannerInfoManager[group.tag]
			end
		end
			
	end
	
	return nil


end

function getGroupfromManager(tag)
	
	
	
	return questMod.GroupManager[tag]
	
	
end

function getEntityGroupfromEntityTag(tag)
	local goodgroup = nil
	
	for k,v in pairs(questMod.GroupManager)do
		
		local group = v
		if(#group.entities > 0) then
			
			for y=1,#group.entities do
				
				local entity = group.entities[y]
				
				if(entity.tag == tag) then
					goodgroup = group
				end
				
				
				
			end
		end
	end
	
	return goodgroup
end

function getEntityIndexIntoGroup(grouptag, tag)
	local group = getGroupfromManager(grouptag)
	local index = nil
	for i, v in ipairs (group) do 
		if (v == tag) then
			index = i 
		end
	end
	return index
end



function getCustomNPCbyTag(tag)
	
	
		
		if (arrayCustomNPC[tag] ~= nil) then
			
			return arrayCustomNPC[tag].npc
			
		end
		
		
	
	return nil
	
end

function getInkWidget(tag)
	for y=1,#currentevt do
		if(currentevt[y].tag == tag) then
			return currentevt[y]
		end
	end
	return nil
end

function getCustomAction(house,roomTypeId)
	
	
	for i=1, #arrayPlaceInteract do 
		if(has_value(arrayPlaceInteract[i].place,house.type)) then
			
			if(arrayPlaceInteract[i].type == roomTypeId) then
				
				if(arrayPlaceInteract[i].placetag ~= "")then
					
					
					customActionUI(arrayPlaceInteract[i])
					
					
					else
					if(arrayPlaceInteract[i].placeTag == house.tag)then 
						
						customActionUI(arrayPlaceInteract[i])
						
					end
				end
				
				
			end
			
			
		end
		
	end
end

function getHouseByTag(tag)
	
	return arrayHouse[tag].house
end

function getRoomByTag(tag, housetag)
	
	for i=1,#arrayHouse[housetag].house.rooms do
	
		if(arrayHouse[housetag].house.rooms[i].tag == tag) then
			return arrayHouse[housetag].house.rooms[i]
		end
	end
	return nil
end

function getHouseStatut(houseTag)
	
	
	 return getScoreKey(houseTag,"Statut")
	
	
end

function getHouseProperties(houseTag)
	
		
		return getScore(houseTag)
		
		
		
end

function getNPCById(npcId)
	
	for i=1, #arrayPnjDb do
		
		if arrayPnjDb[i].ID == npcId then
			
			
			
			return arrayPnjDb[i]
		end
		
	end
end

function getNPCByTweakId(tweak)
	
	for i=1, #arrayPnjDb do
		
		if arrayPnjDb[i].TweakIDs == tweak then
			
			
			
			return arrayPnjDb[i]
		end
		
	end
end

function getNPCByName(name)
	
	for i=1, #arrayPnjDb do
		
		if arrayPnjDb[i].Names == name then
			
			
			
			return arrayPnjDb[i]
		end
		
	end
end

function getPhonedNPCByName(name)
	
	for i=1, #arrayPhoneNPC do
		
		if arrayPhoneNPC[i].Names == name then
			
			
			
			return arrayPhoneNPC[i]
		end
		
	end
end

function findPhonedNPCByName(name)
	debugPrint(1,#arrayPhoneNPC)
	for i=1, #arrayPhoneNPC do
		
		if string.find(string.lower(name),string.lower(arrayPhoneNPC[i].Names) ) then
			
			
			
			return arrayPhoneNPC[i]
		end
		
	end
end

function getPhonedNPCByTweakDBId(tweak)
	
	for i=1, #arrayPhoneNPC do
		
		if arrayPhoneNPC[i].TweakIDs == tweak then
			
			
			
			return arrayPhoneNPC[i]
		end
		
	end
end

function getFixerByTag(tag)
	
	
		
		if arrayFixer[tag] ~= nil then
			
			
			
			return arrayFixer[tag].fixer
		end
		
		return nil
end

function getSoundByName(name)
	
	for k,v in pairs(arraySound) do
		
		if v.sound.name == name then
			
			
			
			return v.sound
		end
		
	end
	
	return nil
end

function getLang(text)
	
	if(lang[text] ~= nil and lang[text] ~= "" )then
	    
		return lang[text]	
	end	
	
	return text
	
end
	
function getCustomScorebyTag(tag)
	
	return getScore(tag)
	
end
	
function getPlayerItemsbyTag(tag)
	
	for i=1,#currentSave.arrayPlayerItems do
		if(currentSave.arrayPlayerItems[i].Tag == tag) then
			return currentSave.arrayPlayerItems[i]
		end
	end
	
end



function getSoundByNameNamespace(name,namespace)
	
	for k,v in pairs(arraySound) do
	
		if k == name and v.sound.namespace == namespace then
			
			debugPrint(1,"sound founded")
			
			return v.sound
		end
		
	end
	
	return nil
end

function GetSoundSettingValue(volumTag)
	
	local SfxVolume = Game.GetSettingsSystem():GetVar("/audio/volume", volumTag)
	return SfxVolume:GetValue()
end

function getHelpByTag(tag)
	for i=1, #arrayHelp do
		
		if arrayHelp[i].tag == tag then
			return arrayHelp[i].help
		end
	end
	return
end


function getTextureByTag(tag)
	
	
		
		if arrayTexture[tag] ~= nil then
			
			
			
			return arrayTexture[tag].texture
		end
		
		return nil
end