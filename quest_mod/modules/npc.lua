debugPrint(3,"CyberMod: NPC module loaded")
questMod.module = questMod.module +1


local spawnRegion = true
local actionRegion = true
local attitudeRegion = true
local vehiculeRegion = true


if spawnRegion then 
	
	
	--Other player spawn management
	
	function spawnOtherPlayer(chara, tag, x, y ,z, spawnlevel)
		
		
		if ('string' == type(chara)) and string.match(chara, "Vehicle.") then
		spawnVehicleV2(chara, "", tag, x, y ,z, spawnlevel,1, false,false,true,false,999)
		
		else
		spawnNPC(chara,"", tag, x, y ,z, spawnlevel, false, true, 999)
		
		end
		
		
		
		
	end
	
	function despawnOtherPlayer(tag)
		
		despawnEntity(tag)
	end
	
	
	
	function spawnCamera(tag,types,entity,pos,angle,surveillance)
		
		if(type == "entity") then
			local objent = getEntityFromManager(entity)
			local entient = Game.FindEntityByID(objent.id)
			if(entient ~= nil) then
				
				local position = {}
				position.x = 0
				position.y = 0
				position.z = 0
				
				
				local vec4 = entient:GetWorldPosition()
				
				
				
				position.x = vec4.x + pos.x
				position.y = vec4.y + pos.y
				position.z = vec4.z + pos.z
				
				local angless = {}
				angless.roll = 0
				angless.pitch = 0
				angless.yaw = 0
				
				local qat = entient:GetWorldOrientation()
				local euler = GetSingleton('Quaternion'):ToEulerAngles(qat)
				
				
				angless = euler.pitch+ angle.pitch
				angless = euler.roll+ angle.roll
				angless = euler.yaw + angle.yaw
				
				if(surveillance == true)then
				spawnNPC("base\\gameplay\\devices\\security_systems\\surveillance_cameras\\appearances\\ceiling_camera_1_militech.ent","", tag, position.x, position.y ,position.z, -90, false, false, 0,true)
				else
				spawnNPC("base\\entities\\cameras\\simple_free_camera.ent","", tag, position.x, position.y ,position.z, -90, false, false, 0,true)
				
				end
				Cron.After(1, function()
					local obj = getEntityFromManager(tag)
					obj.surveillance = surveillance
					local enti = Game.FindEntityByID(obj.id)
						
					if(enti ~= nil) then
						RotateEntityTo(enti, angle.pitch, angle.yaw, angle.roll)
								else
						error("CyberMod : spawnCamera : No camera founded")
					end
				end)
				
				
			end
			
			
		else
			
			
			
			if(surveillance == true)then
				spawnNPC("base\\gameplay\\devices\\security_systems\\surveillance_cameras\\appearances\\ceiling_camera_1_militech.ent","", tag, pos.x, pos.y ,pos.z, -90, false, false, 0,true)
				else
				spawnNPC("base\\entities\\cameras\\simple_free_camera.ent","", tag, pos.x, pos.y ,pos.z, -90, false, false, 0,true)
				
			end
			Cron.After(0.3, function()
				local obj = getEntityFromManager(tag)
				obj.surveillance = surveillance
				local enti = Game.FindEntityByID(obj.id)
					
				if(enti ~= nil) then
					RotateEntityTo(enti, angle.pitch, angle.yaw, angle.roll)
							else
					error("CyberMod : spawnCamera : No camera founded")
				end
			end)
			
			
		end
		
		
		
		
		
	
	end
	
	
	function moveCamera(tag, types ,entity,pos,angle)
	
	
		
		if(type == "entity") then
			local objent = getEntityFromManager(entity)
			local entient = Game.FindEntityByID(objent.id)
			if(entient ~= nil) then
				
				local position = {}
				position.x = 0
				position.y = 0
				position.z = 0
				
				
				local vec4 = entient:GetWorldPosition()
				
				
				
				position.x = vec4.x + pos.x
				position.y = vec4.y + pos.y
				position.z = vec4.z + pos.z
				
				local angless = {}
				angless.roll = 0
				angless.pitch = 0
				angless.yaw = 0
				
				local qat = entient:GetWorldOrientation()
				local euler = GetSingleton('Quaternion'):ToEulerAngles(qat)
				
				
				angless = euler.pitch+ angle.pitch
				angless = euler.roll+ angle.roll
				angless = euler.yaw + angle.yaw
				
			
				
				local obj = getEntityFromManager(tag)
				local enti = Game.FindEntityByID(obj.id)
					
				if(enti ~= nil) then
					teleportTo(enti, position, angless, false)
			
					-- Cron.After(0.3, function()
						-- local obj = getEntityFromManager(tag)
						-- local enti = Game.FindEntityByID(obj.id)
							
						-- if(enti ~= nil) then
							-- RotateEntityTo(enti, angless.pitch, angless.yaw, angless.roll)
									-- else
							-- error("CyberMod : moveCamera : No camera founded")
						-- end
					-- end)
					else
				error("CyberMod : moveCamera : No camera founded")
				end
				
				
			end
			
			
		else
			
			
			

			local obj = getEntityFromManager(tag)
			local enti = Game.FindEntityByID(obj.id)
				
			if(enti ~= nil) then
				teleportTo(enti, pos,angle, false)
			-- Cron.After(1, function()
						-- local obj = getEntityFromManager(tag)
						-- local enti = Game.FindEntityByID(obj.id)
							
						-- if(enti ~= nil) then
							-- RotateEntityTo(enti, angle.pitch, angle.yaw, angle.roll)
									-- else
							-- error("CyberMod : moveCamera : No camera founded")
						-- end
					-- end)
				else
				error("CyberMod : moveCamera : No camera founded")
			end
			
		end
		
		
	end
	
	
	function enableCamera(tag)
	
	
		
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
			
			
		if(enti ~= nil) then
		
			if(obj.surveillance == true) then
			enti:OnToggleTakeOverControl(ToggleTakeOverControl.new())
			else
			local camera = enti:FindComponentByName("camera")
			camera:Activate(1,false)
			end
			
		end
	
	
	end
	
	function stopCamera(tag)
	
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
			
			
		if(enti ~= nil) then
			
			if(obj.surveillance == true) then
			enti:OnToggleTakeOverControl(ToggleTakeOverControl.new())
			else
			local camera = enti:FindComponentByName("camera")
			camera:Deactivate(1,false)
			end
		end
				
				
	
	end
	
	
	function spawnNPC(chara,appearance, tag, x, y ,z, spawnlevel, isprevention, isMPplayer, scriptlevel, isitem)
		
		print(chara)
		if (('string' == type(chara)) and (string.match(tostring(chara), "AMM_Character.") == nil or (string.match(tostring(chara), "AMM_Character.") ~= nil and AMM ~= nil)  )  )then
		debugPrint(1,appearance)
		
		if ('string' == type(chara)) and string.match(chara, "Vehicle.") then
			
			error("Vehicle is not allowed, use spawn_vehicle action for it !")
			
			
			else
			
			local player = Game.GetPlayer()
			local worldpos = player:GetWorldTransform()
			
			range = 5
			
			if isprevention then
				range = 10
			end
			
			local vec4 = getBehindPosition(player,range)
			
			worldpos:SetPosition(worldpos, vec4)	
			
			local twk = TweakDBID.new(chara)
			
			local NPC = nil 
			
			
			if isprevention == false then
				
				local postp = Vector4.new( x, y, z,1)
				
				worldpos:SetPosition(worldpos, postp)	
				
				if(isitem == nil or isitem == false)then
					if(appearance ~= "" and appearance ~= "none") then
						NPC = exEntitySpawner.SpawnRecord(chara, worldpos,appearance)
						else
						NPC = exEntitySpawner.SpawnRecord(chara, worldpos)
					end
				else
					if(appearance ~= "" and appearance ~= "none") then
						NPC = exEntitySpawner.Spawn(chara, worldpos,appearance)
						else
						NPC = exEntitySpawner.Spawn(chara, worldpos)
					end
				end
				
				else
				
				NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
				
				
			end
			
			
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			entity.isprevention = isprevention
			if(scriptlevel == nil) then
			entity.scriptlevel = 0
			else
			entity.scriptlevel = scriptlevel
			end
			entity.isMP = isMPplayer
			
			if(isitem == nil or isitem == false) then
			
				local npgc = getNPCByTweakId(chara)
				
				entity.name = npgc.Names
		
			else
			
				entity.name = tag
			
			end
			
			if(isMPplayer ~= nil and isMPplayer == true)then
				entity.name = tag
			end
			
			table.insert(questMod.EntityManager,entity)
			
			
			
			
			
			Cron.After(1, function()
				if isprevention == true then
					local postp = Vector4.new( x, y, z,1)
					teleportTo(Game.FindEntityByID(NPC), postp, 1,false)
				end
			end)
			
			
		end
		
		else
		
		print("CyberMod : AMM entity is not allowed to spawn if you don't have AMM")
		
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	function spawnEntity(chara, tag, x, y ,z, spawnlevel, isprevention, isAV,beta)
		
		local prev = isprevention or false
		
		if(isAV == nil)then
			
			isAV = false
			
		end
		
		
		
		
		if ('string' == type(chara)) and string.match(chara, "Vehicle.") and prev == false then
			
			calledfromgarage = false
			if(beta == nil or beta == false) then
				spawnVehicle(chara,beta,nil,nil)
				local param = isAV
				Cron.After(0.7, function(param)
					
					local NPC = vehicleEntId
					debugPrint(1,NPC)
					local entity = {}
					entity.id = NPC
					entity.tag = tag
					entity.tweak = chara
					entity.takenSeat = {}
					entity.isAV = isAV
					entity.name = chara
					
					local veh = Game.FindEntityByID(NPC)
					entity.availableSeat = GetSeats(veh)
					--entity.availableSeat = {}
					entity.driver = {}
					
					table.insert(questMod.EntityManager,entity)
					
					local postp = Vector4.new( x, y, z,1)
					teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
					
					calledfromgarage = true
				end)
				else
				local postp = Vector4.new( x, y, z,1)
				local NPC = exEntitySpawner.SpawnRecord(chara, postp)
				debugPrint(1,NPC)
				local entity = {}
				entity.id = NPC
				entity.tag = tag
				entity.tweak = chara
				entity.takenSeat = {}
				entity.isAV = isAV
				entity.name = chara
				
				local veh = Game.FindEntityByID(NPC)
				entity.availableSeat = GetSeats(veh)
				--entity.availableSeat = {}
				entity.driver = {}
				
				table.insert(questMod.EntityManager,entity)
				
				
				
				calledfromgarage = false
			end
			
			
			
			else
			local player = Game.GetPlayer()
			local worldpos = player:GetWorldTransform()
			debugPrint(1,chara)
			range = 5
			
			if prev then
				range = 10
			end
			
			local vec4 = getBehindPosition(player,range)
			
			worldpos:SetPosition(worldpos, vec4)	
			
			local twk = nil
			
			if('string' ~= type(chara)) then
				twk = chara
				
				
				else
				
				if(chara == "random") then
					
					local indexchara = math.random(1,#arrayPnjDb)
					
					chara = arrayPnjDb[indexchara].TweakIDs
					
				end
				twk = TweakDBID.new(chara)
			end
			
			
			local NPC = nil 
			
			
			if beta ~= nil and beta == true then
				
				local postp = Vector4.new( x, y, z,1)
				
				worldpos:SetPosition(worldpos, postp)	
				
				NPC = exEntitySpawner.SpawnRecord(chara, worldpos)
				
				else
				if prev then
					NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
					else
					-- NPC = exEntitySpawner.SpawnRecord(chara, worldpos)
					
					NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
				end
			end
			
			
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			
			local npgc = getNPCByTweakId(chara)
			
			entity.name = npgc.Names
			table.insert(questMod.EntityManager,entity)
			
			
			
			
			
			Cron.After(1, function()
				local postp = Vector4.new( x, y, z,1)
				
				teleportTo(Game.FindEntityByID(NPC), postp, 1,false)
			end)
		end
	end
	
	function spawnEntityBeta(chara, tag, x, y ,z, spawnlevel, isprevention, isAV)
		
		local prev = isprevention or false
		
		if(isAV == nil)then
			
			isAV = false
			
		end
		
		if string.match(chara, "Vehicle.") and prev == false then
			debugPrint(1,chara)
			debugPrint(1,#arrayVehicles)
			calledfromgarage = false
			spawnVehicle(chara,nil,nil,nil)
			
			
			local param = isAV
			Cron.After(0.5, function(param)
				
				local NPC = vehicleEntId
				debugPrint(1,NPC)
				local entity = {}
				entity.id = NPC
				entity.tag = tag
				entity.tweak = chara
				entity.takenSeat = {}
				entity.isAV = isAV
				local veh = Game.FindEntityByID(NPC)
				entity.availableSeat = GetSeats(veh)
				--entity.availableSeat = {}
				entity.driver = {}
				
				table.insert(questMod.EntityManager,entity)
				
				local postp = Vector4.new( x, y, z,1)
				teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
				calledfromgarage = true
			end)
			
			else
			local player = Game.GetPlayer()
			local worldpos = player:GetWorldTransform()
			
			range = 5
			
			if prev then
				range = 10
			end
			
			local vec4 = getBehindPosition(player,range)
			
			worldpos:SetPosition(worldpos, vec4)	
			
			local twk = TweakDBID.new(chara)
			local NPC = nil 
			if prev then
				NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
				else
				NPC = exEntitySpawner.SpawnRecord(chara, worldpos)
				--NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
			end
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			table.insert(questMod.EntityManager,entity)
			
			
			
			
			
			Cron.After(1, function()
				local postp = Vector4.new( x, y, z,1)
				teleportTo(Game.FindEntityByID(NPC), postp, 1,false)
			end)
		end
	end
	
	
	function spawnEntityPath(chara, tag, x, y ,z, spawnlevel)
		
		
		
		
		if string.match(chara, "Vehicle.") and prev == false then
			debugPrint(1,"vehicule are not allowed")
			
			else
			local player = Game.GetPlayer()
			local worldpos = player:GetWorldTransform()
			
			range = 5
			
			if prev then
				range = 10
			end
			
			local vec4 = getBehindPosition(player,range)
			
			worldpos:SetPosition(worldpos, vec4)	
			
			local twk = TweakDBID.new(chara)
			
			local NPC = WorldFunctionalTests.SpawnEntity(chara, worldpos, '')
			
			
			
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			entity.newmethod = true
			table.insert(questMod.EntityManager,entity)
			
			
			Cron.After(1, function()
				local postp = Vector4.new( x, y, z,1)
				teleportTo(Game.FindEntityByID(NPC), postp, 1,false)
			end)
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
	function despawnEntity(tag)
		
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
		local index = getIndexFromManager(tag)
		
		
		if enti == nil then
			
			else
			if(enti:IsVehicle() == false) then
				if(obj.isprevention ~= nil and obj.isprevention == false) then
					
					exEntitySpawner.Despawn(enti)
					else
					
					Game.GetPreventionSpawnSystem():RequestDespawn(enti:GetEntityID())
					
				end
				
				else
				if(obj.isprevention == false) then
						if(obj.fromgarage == true) then
							despawnVehicle(obj.tweak)
						else
							exEntitySpawner.Despawn(enti)
						end
					else
						Game.GetPreventionSpawnSystem():RequestDespawn(enti:GetEntityID())
				end
			end
			
			enti:Dispose()
			
			
			table.remove(questMod.EntityManager,index)
		end
		
		--enti:Dispose()	
		
		
		--Game.GetPreventionSpawnSystem():RequestDespawn(enti:GetEntityID())
		--Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(spawnlevel * -1)
		--Game.GetPreventionSpawnSystem():RequestDespawn(enti:GetEntityID())
		--enti:Dispose()
		
	end
	
	
	function Despawn(objLook)
		if objLook:IsVehicle() == false then
			--not needed
			else
			
			local vehicule = objLook:GetVehiclePS()
			vehicule:SetHasExploded(true)
			
		end
		
		
		local enti = Game.FindEntityByID(objLook)
		Game.GetPreventionSpawnSystem():RequestDespawn(objLook:GetEntityID())
		objlook:Dispose()
		
	end
	
	
	
	function despawnAll()
		
		
		for i = 1, #questMod.EntityManager do
			
			local enti = questMod.EntityManager[i]
			if(enti.isprevention ~= nil and enti.isprevention == false) then
				local np = Game.FindEntityByID(enti.id)
				exEntitySpawner.Despawn(np)
			end
			
			
		end
		
		questMod.NPCManager = {}
		questMod.FriendManager = {}
		questMod.EnemyManager = {}
		questMod.EntityManager = {}
		questMod.GroupManager = {}
		
		
		
		
		if(Game.GetPlayer()) then
			local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
			if(inVehicule == false) then
				
				
				for i = -100, 1 do
					
						Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(i)
					
				end
				
				for i=1,#arrayVehicles do
					despawnVehicle(arrayVehicles[i])
				end
				
				
				else
				
				Game.GetPlayer():SetWarningMessage("Go out of vehicule to despawn entities")
				
				
			end
		end
		-- Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-2)
		-- Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-95)
		-- Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-2)
		-- Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-17)
		-- Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-18)
		
		
		if(objLook ~= nil) then
			Game.GetPreventionSpawnSystem():RequestDespawn(objLook:GetEntityID())
		end
		
		if(Game.GetPlayer()) then
			local entity = {}
			entity.id = Game.GetPlayer():GetEntityID()
			entity.tag = "player"
			entity.tweak = "player"
			
			table.insert(questMod.EntityManager,entity)
			
			local entity1 = {}
			entity1.id = 0
			entity1.tag = "selection1"
			entity1.tweak = "selection1"
			
			table.insert(questMod.EntityManager,entity1)
			
			local entity2 = {}
			entity2.id = 0
			entity2.tag = "selection2"
			entity2.tweak = "selection2"
			
			table.insert(questMod.EntityManager,entity2)
			
			local entity3 = {}
			entity3.id = 0
			entity3.tag = "selection3"
			entity3.tweak = "selection3"
			
			table.insert(questMod.EntityManager,entity3)
			
			local entity4 = {}
			entity4.id = 0
			entity4.tag = "selection4"
			entity4.tweak = "selection4"
			
			table.insert(questMod.EntityManager,entity4)
			
			local entity5 = {}
			entity5.id = 0
			entity5.tag = "selection5"
			entity5.tweak = "selection5"
			
			table.insert(questMod.EntityManager,entity5)
			
			local group = {}
			
			group.tag = "AMMCompanion"
			group.entities = {}
			
			
			table.insert(questMod.GroupManager,group)
			
			local group = {}
			
			group.tag = "Multi"
			group.entities = {}
			
			
			table.insert(questMod.GroupManager,group)
			local group = {}
			
			group.tag = "AV"
			group.entities = {}
			
			
			table.insert(questMod.GroupManager,group)
			local group2 = {}
			
			group2.tag = "Crew"
			group2.entities = {}
			
			
			table.insert(questMod.GroupManager,group2)
			
			local group2 = {}
			
			group2.tag = "companion"
			group2.entities = {}
			
			
			table.insert(questMod.GroupManager,group2)
		end
		debugPrint(1,"Despawn finished")
		
	end
	
	
	
	
	
end

if actionRegion then 
	
	function toggleVBodyComponent(toggle)
		for _, component in ipairs(VBodyComponents) do
		  local comp = Game.GetPlayer():FindComponentByName(component)
		  if comp then comp:Toggle(toggle) end
		end
	end
	
	function getBehindPosition(entity,distance)
		local pos = entity:GetWorldPosition()
		local heading = entity:GetWorldForward()
		local vec4 = Vector4.new(pos.x - (heading.x * distance), pos.y - (heading.y * distance), pos.z, pos.w)
		return vec4
	end
	
	function getForwardPosition(entity,distance)
		local pos = entity:GetWorldPosition()
		local heading = entity:GetWorldForward()
		local vec4 = Vector4.new(pos.x + (heading.x * distance), pos.y + (heading.y * distance), pos.z, pos.w)
		return vec4
	end
	
	
	local function ToPositionSpec(targetPosition)
		local worldPosition = NewObject('WorldPosition')
		GetSingleton('WorldPosition'):SetVector4(worldPosition, targetPosition)
		
		local positionSpec = NewObject('AIPositionSpec')
		GetSingleton('AIPositionSpec'):SetWorldPosition(positionSpec, worldPosition)
		
		return positionSpec
	end
	
	function PlayerToggleInvisible(toggle)
		 GetPlayer():SetInvisible(toggle)
	end
	
	function ToggleImmortal(enti, isImmortal)
		local id = enti:GetEntityID()
		
		local godsystem = Game.GetGodModeSystem()
		-- Immortal = 1,
		-- Invulnerable = 0,
		-- Mortal = 2
		if isImmortal then
		
			godsystem:AddGodMode(id,gameGodModeType.Immortal, "FastTravel")
			godsystem:AddGodMode(id,gameGodModeType.Invulnerable, "FastTravel")
			godsystem:RemoveGodMode(id, gameGodModeType.Mortal, "")	
			
			else
			godsystem:ClearGodMode(id,"")
			
			godsystem:RemoveGodMode(id,gameGodModeType.Immortal, "FastTravel")
			godsystem:RemoveGodMode(id,gameGodModeType.Invulnerable, "FastTravel")
			godsystem:AddGodMode(id, gameGodModeType.Mortal, "")	
			
		end
		
	end
	
	
	
	
	function setAppearance(entity,appearance)
		
		if(AMM ~= nil) then
		
		AMM.API.ChangeAppearance(entity,appearance)
		
		else
		entity:PrefetchAppearanceChange(appearance)
		entity:ScheduleAppearanceChange(appearance)
		
		end
		
		
	end
	
	function randomAppearance(entity)
		if(AMM ~= nil) then
		
		AMM.API.ChangeAppearance(entity,"")
		
		else
		entity:ScheduleAppearanceChange("")
		end
	end
	
	function getAppearance(entity)
		if(AMM ~= nil) then
		
		local possibleApp = AMM.API.GetAppearancesForEntity(entity)
		
		for _, app in ipairs(possibleApp) do
			print((tostring(app)))
		end
		
		
		else
		for _, app in ipairs(entity:GetRecord():CrowdAppearanceNames()) do
			debugPrint(1,tostring(app))
		end
		end
	end
	
	function swapEntity(npc,newnpc)
		
		local temp = TweakDB:GetFlat(TweakDBID.new(newnpc..".entityTemplatePath"))
		
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc..".entityTemplatePath"), temp)
		
		TweakDB:Update(TweakDBID.new(npc))
		
	end
	
	
	function changePreset(npc,newnpc)
		
		
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.itemGroups'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.itemGroups')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.attachmentSlots'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.attachmentSlots')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.abilities'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.abilities')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.actionMap'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.actionMap')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.alertedSensesPreset'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.alertedSensesPreset')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.combatSensesPreset'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.combatSensesPreset')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.defaultEquipment'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.defaultEquipment')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.equipmentAreas'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.equipmentAreas')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.items'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.items')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.primaryEquipment'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.primaryEquipment')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.reactionPreset'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.reactionPreset')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.secondaryEquipment'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.secondaryEquipment')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.sensePreset'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.sensePreset')))
		TweakDB:SetFlatNoUpdate(TweakDBID.new(npc ..'.threatTrackingPreset'), TweakDB:GetFlat(TweakDBID.new(newnpc..'.threatTrackingPreset')))
		TweakDB:Update(TweakDBID.new(npc))
		
		
	end
	
	
	
	
	
	
	function EquipPrimaryWeaponCommand(objlook, equip)
		local cmd = NewObject("handle:AISwitchToPrimaryWeaponCommand")
		cmd.unEquip = equip
		cmd = cmd:Copy()
		
		executeCmd(objlook, cmd)
	end
	
	function EquipSecondaryWeaponCommand(objlook, equip)
		local cmd = NewObject("handle:AISwitchToSecondaryWeaponCommand")
		cmd.unEquip = equip
		cmd = cmd:Copy()
		
		executeCmd(objlook, cmd)
	end
	
	function EquipGivenWeapon(objlook, weapon, override)
		local cmd = NewObject("AIEquipCommand")
		cmd.slotId = TweakDBID.new("AttachmentSlots.WeaponRight")
		cmd.itemId = weapon
		cmd.failIfItemNotFound = false
		if override then
			cmd.durationOverride = 99999
		end
		cmd = cmd:Copy()
		
		executeCmd(objlook, cmd)
	end
	
	
	
	
	
	function FollowEntity(enti, target, movementType, stealth)
		if not target then
			local currentRole = enti:GetAIControllerComponent():GetAIRole()
			
			if currentRole and currentRole:IsA('AIFollowerRole') then
				target = currentRole.followTarget
				else
				target = Game.GetPlayer()
			end
		end
		
		if not movementType then
			movementType = 'Sprint'
		end
		
		local followCmd = NewObject('handle:AIFollowTargetCommand')
		followCmd.target = target
		followCmd.lookAtTarget = target
		followCmd.desiredDistance = 1.0
		followCmd.tolerance = 0.5
		followCmd.movementType = movementType
		followCmd.matchSpeed = true
		followCmd.teleport = false
		followCmd.stopWhenDestinationReached = false
		followCmd.ignoreInCombat = false
		followCmd.removeAfterCombat = false
		followCmd.alwaysUseStealth = stealth
		
		enti:GetAIControllerComponent():SendCommand(followCmd)
		
	end
	
	function lookAtPlayer(entity, duration)
		
		
		local stimReact = entity:GetStimReactionComponent()
		stimReact:ActivateReactionLookAt(Game.GetPlayer(), false, true, duration, true)
		
		
	end
	
	function playerLookAtEntity(tag)
		
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
		
		local player = Game.GetPlayer()
		local dirVector = diffVector(player:GetWorldPosition(), enti:GetWorldPosition())
		local angle = GetSingleton('Vector4'):ToRotation(dirVector)
		
		pitch = angle.pitch
		yaw = angle.yaw 
		freezeCamera =  true
		
	end
	
	
	function playerLookAtDirection(x, y, z)
		
		local player = Game.GetPlayer()
		
		local direction = {}
		direction.x = x
		direction.y = y
		direction.z = z
		direction.w = 1
		
		local dirVector = diffVector(player:GetWorldPosition(), direction)
		local angle = GetSingleton('Vector4'):ToRotation(dirVector)
		
		pitch = angle.pitch
		yaw = angle.yaw 
		
		freezeCamera =  true
		
	end
	
	
	
	
	
	function lookAtEntity(entity,tag, duration)
		
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
		
		if(enti ~= nil) then
			local stimReact = entity:GetStimReactionComponent()
			
			stimReact:ActivateReactionLookAt(enti, false, true, duration, true)
		end
		
	end
	
	
	
	function InterruptBehavior(objlook)
		teleportTo(objlook, objlook:GetWorldPosition(), 1,false)
	end
	
	function IsMoving(tag)
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
		
		return GetSingleton('AIbehaviorUniqueActiveCommandList'):IsActionCommandById(
			targetPuppet:GetAIControllerComponent().activeCommands,
			commandInstance.id
		)
	end
	
	function executeCmd(objlook, cmd)
		if objlook ~= nil or objlook ~= '' then
			AIComponent = objlook:GetAIControllerComponent()
			
			if (AIComponent ~= nil) then
				AIComponent:SendCommand(cmd)
			end
			
		end
	end
	
	function entityLookAtDirection(x, y, z)
		
		local obj = getEntityFromManager(tag)
		local enti = Game.FindEntityByID(obj.id)
		
		local direction = {}
		direction.x = x
		direction.y = y
		direction.z = z
		direction.w = 1
		
		local dirVector = diffVector(enti:GetWorldPosition(), direction)
		local angle = GetSingleton('Vector4'):ToRotation(dirVector)
		
		local pitch0 = angle.pitch
		local yaw0 = angle.yaw 
		
		Game.GetTeleportationFacility():Teleport(enti, enti:GetWorldPosition() , EulerAngles.new(0,pitch0,yaw0)) -- Set yaw when teleporting
		
		
		
	end
	
	function teleportTo(objlook, position, rotation, isplayer)
		--debugPrint(1,rotation)
		if rotation == nil then
			
			rotation = 1
			
		end
		
		local rot = rotation
		--debugPrint(1,rot)
		if(rotation ~= 1) then
			
			rot = EulerAngles.new(0,0,0)
			
			rot.roll = rotation.roll
			rot.pitch = rotation.pitch
			rot.yaw = rotation.yaw
			
			else
			
			rot = EulerAngles.new(0,0,0)
			
		end
		
		if(objlook ~= nil) then
		local item = nil
		
		
		pcall(function()
			if objlook:IsVehicle() == true then
				-- debugPrint(1,position.x)
				-- debugPrint(1,position.y)
				-- debugPrint(1,position.z)
				-- debugPrint(1,rot)
				rot.roll = 0
				rot.pitch = 0
				Game.GetTeleportationFacility():Teleport(objlook, Vector4.new(position.x, position.y, position.z,1), rot)
				-- debugPrint(1,"ok")
				else
				inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(objlook)
				if (inVehicule) then
					vehicule = Game['GetMountedVehicle;GameObject'](objlook)
					rot.roll = 0
					rot.pitch = 0
					GetSingleton('gameTeleportationFacility'):Teleport(vehicule, Vector4.new(position.x, position.y, position.z,1), rot)
				else
					
					if(isplayer) then
						print(tostring(rot.pitch))
						
						
						Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Vector4.new(position.x, position.y, position.z,1) , rot)
						Game.GetPlayer():GetFPPCameraComponent().pitchMin = rot.pitch - 0.01
						Game.GetPlayer():GetFPPCameraComponent().pitchMax = rot.pitch
						Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(rot.roll, 0, 0)))
					else
						local test = nil
						pcall(function()
						local cmd = NewObject('handle:AITeleportCommand')
						
						cmd.doNavTest = false
						cmd.rotation = 1
						cmd.position = position 
						
						executeCmd(objlook, cmd)
						test = "ok"
						end)
						
						if(test == nil) then
						rot.roll = 0
						rot.pitch = 0
						Game.GetTeleportationFacility():Teleport(objlook, Vector4.new(position.x, position.y, position.z,1) , rot)
						end
						
					end
					
					
					
				end
				
				
			end
			item = "ok"
			end)
						
			if(item == nil) then
			rot.roll = 0
			rot.pitch = 0
			Game.GetTeleportationFacility():Teleport(objlook, Vector4.new(position.x, position.y, position.z,1) , rot)
			end
			
		end
		
		
		
		
		
		
		
	end
	
	function RotateTo(objlook, target)
		local positionSpec = ToPositionSpec(target:GetWorldPosition())
		
		local rotateCmd = NewObject('handle:AIRotateToCommand')
		rotateCmd.target = positionSpec
		rotateCmd.angleTolerance = 10.0 -- If zero then command will never finish
		rotateCmd.angleOffset = 0.0
		rotateCmd.speed = 1.0
		
		objlook:GetAIControllerComponent():SendCommand(rotateCmd)
		
		
		
		
		
	end
	
	function RotateEntityTo(enti, pitch, yaw, roll)
		 local objpos = enti:GetWorldPosition()
					
		
		
		local qat = enti:GetWorldOrientation()
		local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
		
		angle.pitch = pitch
		angle.yaw = yaw
		angle.roll = roll
		
		Game.GetTeleportationFacility():Teleport(enti, objpos,  angle)
		
		
	end
	
	function HoldPosition(enti, timer,stealth)
		InterruptBehavior(enti)
		
		local cmd = NewObject('handle:AIHoldPositionCommand')
		cmd.alwaysUseStealth = stealth
		cmd.removeAfterCombat = false
		cmd.ignoreInCombat = false
		
		
		cmd.duration = timer
		
		executeCmd(enti, cmd)
	end
	
	function talk(enti,voiceText,target)
		local StimReaction = enti:GetStimReactionComponent()
		--local StimReaction = objlook:GetStimReactionComponent():ActivateReactionLookAt()
		resetFacial(enti)
		
		
		Cron.After(0.5, function()
			local AnimationController = enti:GetAnimationControllerComponent()
			
			
			
			if StimReaction ~= nil and AnimationController ~= nil then
				
				
				
				
				
				
				
				Game["gameObject::PlayVoiceOver;GameObjectCNameCNameFloatEntityIDBool"](enti, CName.new(voiceText), CName.new(""), 1)
				
				
				
			end
			
		end)
		
		
	end
	
	
	function makeFacial(tag,reactiontodo)
		print(tag)
		local obj = getEntityFromManager(tag)
		print(dump(obj))
		print(dump(reactiontodo))
		local enti = Game.FindEntityByID(obj.id)
		
		local StimReaction = enti:GetStimReactionComponent()
		
			
			  local stimComp = enti:FindComponentByName("ReactionManager")
			  local animComp = enti:FindComponentByName("AnimationControllerComponent")

			  if stimComp and animComp then
			  print("test")
				stimComp:ResetFacial(0)

				Cron.After(0.2, function()
				
				  local animFeat = NewObject("handle:AnimFeature_FacialReaction")
				  animFeat.category = reactiontodo.category
				  animFeat.idle = reactiontodo.idle
				  animComp:ApplyFeature(CName.new("FacialReaction"), animFeat)
				  print("test2")
				end)
			  end
			
		
		
	end
	
	
	function resetFacial(enti)
		local StimReaction = enti:GetStimReactionComponent()
		StimReaction:ResetFacial(0)
	
		
	end
	
	function resetLookAt(enti)
		
		local StimReactionComponent = enti:GetStimReactionComponent()
		if StimReactionComponent then
			StimReactionComponent:DeactiveLookAt()
		end
		
	end
	
	
	function setInvisible(tag,isHidden)
		
		if(tag == "player") then
			
			
			Game.GetPlayer():SetInvisible(isHidden)
			Game.GetPlayer():UpdateVisibility()
			
			
			-- else
			
			-- local obj = getEntityFromManager(tag)
			-- local enti = Game.FindEntityByID(obj.id)
			
			-- CreateTarget(enti, false, isHidden)
			
		end
		
		
	end
	
	function InterruptCombat(tag)
		
		local enti = nil
		local obj = nil 
		if(tag =="lookat") then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
		end
		
		
		enti:GetTargetTrackerComponent():ClearThreats()
		
		Game['NPCPuppet::ChangeHighLevelState;GameObjectgamedataNPCHighLevelState'](enti, 'Relaxed')
		Game['NPCPuppet::ChangeDefenseModeState;GameObjectgamedataDefenseMode'](enti, 'NoDefend')
		Game['NPCPuppet::ChangeUpperBodyState;GameObjectgamedataNPCUpperBodyState'](enti, 'Normal')
	end
	
	
	-- enum gamedataNPCStanceState
	-- {
	-- Any = 0,
	-- Cover = 1,
	-- Crouch = 2,
	-- Stand = 3,
	-- Swim = 4,
	-- Vehicle = 5,
	-- VehicleWindow = 6,
	-- Count = 7,
	-- Invalid = 8
	-- }
	function changeStance(tag,stance)
		

		NPCPuppet.ChangeStanceState(objLook, stance)
		
	end
	
	
	
	
	function MoveTo(targetPuppet, targetPosition, targetDistance, movementType)
		
		--debugPrint(1,"moving....")
		
		if not targetPosition then
			targetPosition = Game.GetPlayer():GetWorldPosition()
			
		end
		
		if not targetDistance then
			targetDistance = 1.0
		end
		
		if not movementType then
			movementType = 'Sprint'
		end
		
		local worldPosition = NewObject('WorldPosition')
		
		worldPosition:SetVector4(worldPosition,Vector4.new(targetPosition.x, targetPosition.y, targetPosition.z, targetPosition.w))
		
		local AIPositionSpec = NewObject('AIPositionSpec')
		AIPositionSpec:SetWorldPosition(AIPositionSpec, worldPosition)
		
		local moveCmd = NewObject('handle:AIMoveToCommand')
		moveCmd.movementTarget = AIPositionSpec
		moveCmd.movementType = movementType
		moveCmd.desiredDistanceFromTarget = targetDistance
		moveCmd.finishWhenDestinationReached = true
		moveCmd.rotateEntityTowardsFacingTarget = false
		moveCmd.ignoreNavigation = false
		executeCmd(targetPuppet, moveCmd)
		
		
	end
	
	
end

if attitudeRegion then 
	
	function IsFollower(enti)
		local currentRole = enti:GetAIControllerComponent():GetAIRole()
		
		return currentRole and currentRole:IsA('AIFollowerRole')
	end
	
	
	function SetFollower()
		
		if(objLook ~= nil) then
		local FriendlyFollower = objLook
		
		local player = Game.GetPlayer()
		
		local entity = {}
		entity.id = FriendlyFollower:GetEntityID()
		entity.tag = "Crew_"..tostring(math.random(1,99999))
		
		
		table.insert(questMod.EntityManager,entity)
		
		
		
		
		local index =getIndexFromGroupManager("Crew")
		
		
		table.insert(questMod.GroupManager[index].entities,entity.tag)
		
		local NPC = FriendlyFollower:GetAIControllerComponent()
		local targetTeam = FriendlyFollower:GetAttitudeAgent()
		
		local SetState = NewObject('handle:AIFollowerRole')
		SetState:SetFollowTarget(Game:GetPlayerSystem():GetLocalPlayerControlledGameObject())
		SetState:OnRoleSet(FriendlyFollower)
		SetState.followerRef = Game.CreateEntityReference("#player", {})
		targetTeam:SetAttitudeGroup(CName.new("player"))
		
		Game['senseComponent::RequestMainPresetChange;GameObjectString'](FriendlyFollower, "Follower")
		Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](FriendlyFollower, Game:GetPlayer())
		Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](FriendlyFollower, "Stand")
		
		NPC:SetAIRole(SetState)
		FriendlyFollower.movePolicies:Toggle(true)
		
		ToggleImmortal(FriendlyFollower, false)
		
		end
		
		
		
	end
	
	
	function UnsetFollowerDebug()
		
		
		
		local FriendlyFollower = objLook
		
		local player = Game.GetPlayer()
		
		local npcType = FriendlyFollower:IsCrowd()
		
		local entity =  getEntityFromManagerById(FriendlyFollower:GetEntityID())
		
		if entity ~= nil then
			local index =getIndexFromGroupManager("Crew")
			
			for i=1, #questMod.GroupManager[index].entities do 
				local entityTag = questMod.GroupManager[index].entities[i]
				
				if(entityTag == entity.tag) then
					table.remove(questMod.GroupManager[index].entities,i)
				end
				
			end
		end
		if npcType == false then
			debugPrint(1,"is not crowd")
			local NPC = FriendlyFollower:GetAIControllerComponent()
			local targetTeam = FriendlyFollower:GetAttitudeAgent()
			
			local SetState = NewObject('handle:AINoRole')
			
			targetTeam:SetAttitudeGroup(CName.new("player"))
			targetTeam:SetAttitudeTowards(player:GetAttitudeAgent(), 'AIA_Friendly ')
			
			
			
			
			local sensePreset = FriendlyFollower:GetRecord():SensePreset():GetID()
			Game['senseComponent::RequestPresetChange;GameObjectTweakDBIDBool'](FriendlyFollower, sensePreset, true)
			
			
			NPC:SetAIRole(SetState)
			FriendlyFollower.movePolicies:Toggle(true)
			debugPrint(1,"become friend")
			ToggleImmortal(FriendlyFollower, false)
			
			else
			debugPrint(1,"is crowd, destroy")
			local index =getIndexFromGroupManager("Crew")
			FriendlyFollower:Dispose()
			
			
		end
		
		
		
		
		
		
		
	end
	
	
	
	
	
	
	function setAggressiveKillMission()
		----debugPrint(1,"setAggressiveKillMission")
		
		if #questMod.EnemyManager > 0 then
			for i = 1, #questMod.EnemyManager do		
				-- Quickly
				
				
				local handle = Game.FindEntityByID(questMod.EnemyManager[i])
				if(handle ~= nil) then
					local AIC = handle:GetAIControllerComponent()
					local targetAttAgent = handle:GetAttitudeAgent()
					local reactionComp = handle.reactionComponent
					
					local aiRole = NewObject('handle:AIRole')
					aiRole:OnRoleSet(handle)
					
					Game['senseComponent::RequestMainPresetChange;GameObjectString'](handle, "Combat")
					Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](handle, "Stand")
					
					AIC:SetAIRole(aiRole)
					handle.movePolicies:Toggle(true)
					
					targetAttAgent:SetAttitudeGroup(CName.new("hostile"))
					reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
					--		reactionComp:TriggerCombat(Game.GetPlayer())
					debugPrint(1,"aggressive ok")
					-- >_< Remove invulnerability from "GodModed" enemies
					local get_godmode = Game.GetGodModeSystem()
					get_godmode:ClearGodMode(questMod.EnemyManager[i], CName.new("Default"))	
				end
			end
		end
		
	end
	
	function setPassiveMission()
		----debugPrint(1,"setAggressiveKillMission")
		
		if #questMod.NPCManager > 0 then
			for i = 1, #questMod.NPCManager do		
				-- Quickly
				
				
				local handle = Game.FindEntityByID(questMod.NPCManager[i])
				
				if(handle ~= nil) then
					
					if handle:IsVehicle() ~= true then
						local AIC = handle:GetAIControllerComponent()
						local targetAttAgent = handle:GetAttitudeAgent()
						local reactionComp = handle.reactionComponent
						
						local aiRole = NewObject('handle:AIRole')
						aiRole:OnRoleSet(handle)
						
						Game['senseComponent::RequestMainPresetChange;GameObjectString'](handle, "Relaxed")
						Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](handle, "Stand")
						
						AIC:SetAIRole(aiRole)
						handle.movePolicies:Toggle(true)
						
						
						
						local get_godmode = Game.GetGodModeSystem()
						get_godmode:ClearGodMode(questMod.EnemyManager[i], CName.new("Default"))	
					end
				end
				
			end
		end
		
	end
	
	
	function setFollowerEscortMission()
		
		if #questMod.FriendManager > 0 then
			for i = 1, #questMod.FriendManager do		
				
				local objLook = Game.FindEntityByID(questMod.FriendManager[i])
				if(objLook ~= nil) then
					local AIC = objLook:GetAIControllerComponent()
					local targetAttAgent = objLook:GetAttitudeAgent()
					local currTime = objLook.isPlayerCompanionCachedTimeStamp + 11
					
					
					-- if objLook.isPlayerCompanionCached == false then
					local roleComp = NewObject('handle:AIFollowerRole')
					
					roleComp:SetFollowTarget(Game:GetPlayerSystem():GetLocalPlayerControlledGameObject())
					roleComp:OnRoleSet(objLook)
					roleComp.followerRef = Game.CreateEntityReference("#player", {})
					targetAttAgent:SetAttitudeGroup(CName.new("player"))
					Game['senseComponent::RequestMainPresetChange;GameObjectString'](objLook, "Follower")
					Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](objLook, Game:GetPlayer())
					Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](objLook, "Stand")
					objLook.isPlayerCompanionCached = true
					objLook.isPlayerCompanionCachedTimeStamp = currTime
					
					if not string.match(targName, "Johnny") and not string.match(targName, "Nibbles") then
						AIC:SetAIRole(roleComp)
						objLook.movePolicies:Toggle(true)
					end
				end 
				
				
				
				-- elseif objLook.isPlayerCompanionCached == true then
				
				-- local npcType = objLook:IsCrowd()
				-- if npcType == false then
				-- local noRole = NewObject('handle:AINoRole')
				-- noRole:OnRoleSet(objLook)
				
				-- objLook.isPlayerCompanionCached = false
				-- objLook.isPlayerCompanionCachedTimeStamp = 0
				
				-- Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](objLook, "Combat")
				-- AIC:GetCurrentRole():OnRoleCleared(objLook)
				-- AIC:SetAIRole(noRole)
				-- objLook	.movePolicies:Toggle(true)
				-- targetAttAgent:SetAttitudeGroup(targetAttAgent.baseAttitudeGroup)
				-- end
				
				
				
				
			end
		end
		
	end
	
	
	function setAggressiveAgainstPlayer(tag, target)
		local enti = nil
		local obj = nil 
		if(tag =="lookat" and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
		end
		
		if enti ~= nil and enti:IsVehicle() ~= true then
			enti:GetAttitudeAgent():SetAttitudeTowards(Game.GetPlayer():GetAttitudeAgent(), EAIAttitude.AIA_Hostile)
			-- 			local AIC = enti:GetAIControllerComponent()
			-- 			local targetAttAgent = enti:GetAttitudeAgent()
			-- 			local reactionComp = enti.reactionComponent
			
			-- 			local aiRole = NewObject('handle:AIRole')
			-- 			aiRole:OnRoleSet(enti)
			
			-- 			Game['senseComponent::RequestMainPresetChange;GameObjectString'](enti, "Combat")
			-- 			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Combat")
			-- 			AIC:SetAIRole(aiRole)
			-- 			enti.movePolicies:Toggle(true)
			
			-- 			targetAttAgent:SetAttitudeTowards(target:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Hostile"))
			
			
			
			-- 			reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
			
			-- 	--		reactionComp:TriggerCombat(target)
			
			ToggleImmortal(enti, false)
		end
	end
	
	
	
	function setAggressiveAgainst(tag, target)
		
		local enti = nil
		local obj = nil 
		if(tag =="lookat" and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
		end
		
		local targets = nil
		
		if(target =="target") then 
			
			
			targets = Game.FindEntityByID(selectTarget)
			
			else
			
			local obj2 = getEntityFromManager(target)
			targets = Game.FindEntityByID(obj2.id)
			
			
		end
		
		
		
		
		if(enti== nil) then 
			
			
			
		end
		
		if(targets~= nil) then 
			
			
			
		
		
		if enti ~= nil and enti:IsVehicle() == false then
			local AIC = enti:GetAIControllerComponent()
			local targetAttAgent = enti:GetAttitudeAgent()
			local reactionComp = enti.reactionComponent
			
			local aiRole = NewObject('handle:AIRole')
			aiRole:OnRoleSet(enti)
			
			Game['senseComponent::RequestMainPresetChange;GameObjectString'](enti, "Combat")
			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Combat")
			AIC:SetAIRole(aiRole)
			enti.movePolicies:Toggle(true)
			
			targetAttAgent:SetAttitudeTowards(targets:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Hostile"))
			
			
			
			reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
			targetAttAgent:SetAttitudeTowardsAgentGroup(targetAttAgent, targetAttAgent, Enum.new("EAIAttitude", "AIA_Friendly"))
			targetAttAgent:SetAttitudeTowards(targets:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Hostile"))
			--		reactionComp:TriggerCombat(targets)
			
			ToggleImmortal(enti, false)
			
		end
		end
end
	
	function setFollower(tag)
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowCloseMovePolicy.distance'), 1)
		
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowCloseMovePolicy.avoidObstacleWithinTolerance'), true)
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowCloseMovePolicy.ignoreCollisionAvoidance'), false)
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowCloseMovePolicy.ignoreSpotReservation'), false)
		
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowCloseMovePolicy.tolerance'), 0.0)
		TweakDB:Update(TweakDBID.new('FollowerActions.FollowCloseMovePolicy'))
		TweakDB:Update(TweakDBID.new('FollowerActions.FollowStayPolicy'))
		TweakDB:Update(TweakDBID.new('FollowerActions.FollowGetOutOfWayMovePolicy'))
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowStayPolicy.distance'), 1)
		TweakDB:SetFlatNoUpdate(TweakDBID.new('FollowerActions.FollowGetOutOfWayMovePolicy.distance'), 0.0)
		
		
		local entity = nil
		local obj = nil 
		if(tag =="lookat" and objLook ~= nil) then 
			
			entity = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			entity = Game.FindEntityByID(obj.id)
			
			
		end
		
		if(entity ~= nil) then
			local AIC = entity:GetAIControllerComponent()
			local targetAttAgent = entity:GetAttitudeAgent()
			local currTime = entity.isPlayerCompanionCachedTimeStamp + 11
			
			local roleComp = NewObject('handle:AIFollowerRole')
			
			roleComp:SetFollowTarget(Game.GetPlayerSystem():GetLocalPlayerControlledGameObject())
			roleComp:OnRoleSet(entity)
			roleComp.attitudeGroupName = CName.new("player")
			roleComp.followerRef = Game.CreateEntityReference("#player", {})
			targetAttAgent:SetAttitudeGroup(CName.new("player"))
			Game['senseComponent::RequestMainPresetChange;GameObjectString'](entity, "Follower")
			Game['senseComponent::ShouldIgnoreIfPlayerCompanion;EntityEntity'](entity, Game.GetPlayer())
			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](entity, "Relaxed")
			entity.isPlayerCompanionCached = true
			entity.isPlayerCompanionCachedTimeStamp = currTime
			local targName = tostring(entity:GetTweakDBFullDisplayName(true))
			if not string.match(targName, "Johnny") and not string.match(targName, "Nibbles") then
				AIC:SetAIRole(roleComp)
				entity.movePolicies:Toggle(true)
			end
			-- if objLook.isPlayerCompanionCached == false then
			
		end 
		
	end
	
	function setPassiveAgainstPlayer(tag, target)
		local enti = nil
		local obj = nil 
		
		if(tag =="lookat" and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
		end
		
		if enti ~= nil and enti:IsVehicle() == false and targets ~= nil then
		local AIC = enti:GetAIControllerComponent()
		local targetAttAgent = enti:GetAttitudeAgent()
		local reactionComp = enti.reactionComponent
		
		local aiRole = NewObject('handle:AIRole')
		aiRole:OnRoleSet(enti)
		
		enti:GetAIControllerComponent():OnAttach()	
		Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Relaxed")
		AIC:SetAIRole(aiRole)
		enti.movePolicies:Toggle(true)
		
		targetAttAgent:SetAttitudeTowards(target:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Neutral"))
		
		
		
		
		ToggleImmortal(enti, false)
		end
	end
	
	function setPassiveAgainst(tag, target)
		
		
		local enti = nil
		local obj = nil 
		if(tag =="lookat" and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
			
		end	
		local targets = nil
		
		if(target =="target") then 
			
			
			targets = Game.FindEntityByID(selectTarget)
			
			else
			
			local obj2 = getEntityFromManager(target)
			targets = Game.FindEntityByID(obj2.id)
			
			
		end
		
		
		if enti ~= nil and enti:IsVehicle() == false and targets ~= nil then
		
		local AIC = enti:GetAIControllerComponent()
		local targetAttAgent = enti:GetAttitudeAgent()
		local reactionComp = enti.reactionComponent
		
		local aiRole = NewObject('handle:AIRole')
		aiRole:OnRoleSet(enti)
		
		enti:GetAIControllerComponent():OnAttach()	
		Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Relaxed")
		AIC:SetAIRole(aiRole)
		enti.movePolicies:Toggle(true)
		
		targetAttAgent:SetAttitudeTowards(targets:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Neutral"))
		
		
		
		
		ToggleImmortal(enti, false)
		end
	end
	
	function setFriendAgainst(tag, target)
		
		
		local enti = nil
		local obj = nil 
		if(tag =="lookat" and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
			
		end	
		local targets = nil
		
		if(target =="target") then 
			
			
			targets = Game.FindEntityByID(selectTarget)
			
			else
			
			local obj2 = getEntityFromManager(target)
			targets = Game.FindEntityByID(obj2.id)
			
			
		end
		
		
		
		if enti ~= nil and enti:IsVehicle() == false and targets ~= nil then
		local AIC = enti:GetAIControllerComponent()
		local targetAttAgent = enti:GetAttitudeAgent()
		local reactionComp = enti.reactionComponent
		
		local aiRole = NewObject('handle:AIRole')
		aiRole:OnRoleSet(enti)
		
		enti:GetAIControllerComponent():OnAttach()	
		Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Relaxed")
		AIC:SetAIRole(aiRole)
		enti.movePolicies:Toggle(true)
		
		targetAttAgent:SetAttitudeTowards(targets:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Friendly"))
		
		
		
		
		ToggleImmortal(enti, false)
		end
	end
	
	
	function setPassiveAgainstAttitudeGroup(tag,targetgroup, attitudegroup, attitudegrouptarget)
		
		
		
		local group =getGroupfromManager(tag)
		
		for i=1, #group.entities do 
			local entityTag = group.entities[i]
			
			
			local obj = getEntityFromManager(entityTag)
			
			
			local enti = Game.FindEntityByID(obj.id)
			
			
			
			
			
			
			ToggleImmortal(enti, false)
			local AIC = enti:GetAIControllerComponent()
			local targetAttAgent = enti:GetAttitudeAgent()
			local reactionComp = enti.reactionComponent
			
			local aiRole = NewObject('handle:AIRole')
			aiRole:OnRoleSet(enti)
			
			enti:GetAIControllerComponent():OnAttach()	
			Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Relaxed")
			AIC:SetAIRole(aiRole)
			enti.movePolicies:Toggle(true)
			
			
			local entityGroup = {}
			local targetAttGroup = {}
			
			for i=1, #arrayAttitudeGroup do
				
				if(arrayAttitudeGroup[i].properties['.name'] == attitudegroup) then
					entityGroup= arrayAttitudeGroup[i]
				end
				
				if(arrayAttitudeGroup[i].properties['.name'] == attitudegrouptarget) then
					targetAttGroup= arrayAttitudeGroup[i]
				end
				
			end
			
			targetAttAgent:SetAttitudeGroup(CName.new(entityGroup.properties['.name']))
			
			Game.GetAttitudeSystem():SetAttitudeRelationFromTweak(TweakDBID.new(entityGroup.path), TweakDBID.new(targetAttGroup.path), Enum.new("EAIAttitude", "AIA_Friendly"))
			
			
			
			
			
			targetAttAgent:SetAttitudeTowardsAgentGroup(targetAttAgent, targetAttAgent, Enum.new("EAIAttitude", "AIA_Friendly"))
			
			
			
			local targetgroup =getGroupfromManager(targetgroup)
			
			for y=1, #group.entities do 
				local entityTag2 = group.entities[y]
				
				
				local obj2 = getEntityFromManager(entityTag2)
				
				
				local target = Game.FindEntityByID(obj2.id)
				if(target ~= nil) then
					targetAttAgent:SetAttitudeTowards(target:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Friendly"))
					--		reactionComp:TriggerCombat(target)
				end
				
				
			end
			
			
		end
		
		
	end
	
	function setAggressiveAgainstAttitudeGroup(tag,targetgroup, attitudegroup, attitudegrouptarget)
		
		
		local group =getGroupfromManager(tag)
		
		for i=1, #group.entities do 
			local entityTag = group.entities[i]
			
			
			local obj = getEntityFromManager(entityTag)
			local enti = Game.FindEntityByID(obj.id)
			
			if(enti ~= nil) then
				ToggleImmortal(enti, false)
				local AIC = enti:GetAIControllerComponent()
				local targetAttAgent = enti:GetAttitudeAgent()
				local reactionComp = enti.reactionComponent
				
				local aiRole = NewObject('handle:AIRole')
				aiRole:OnRoleSet(enti)
				
				enti:GetAIControllerComponent():OnAttach()	
				Game['senseComponent::RequestMainPresetChange;GameObjectString'](enti, "Combat")
				Game['NPCPuppet::ChangeStanceState;GameObjectgamedataNPCStanceState'](enti, "Combat")
				AIC:SetAIRole(aiRole)
				enti.movePolicies:Toggle(true)
				
				
				local entityGroup = {}
				local targetAttGroup = {}
				
				for i=1, #arrayAttitudeGroup do --from json Attitude, may remork ?
					
					
					if(arrayAttitudeGroup[i].properties['.name'] == attitudegroup) then
						entityGroup= arrayAttitudeGroup[i]
					end
					
					if(arrayAttitudeGroup[i].properties['.name'] == attitudegrouptarget) then
						targetAttGroup= arrayAttitudeGroup[i]
					end
					
				end
				
				targetAttAgent:SetAttitudeGroup(CName.new(entityGroup.properties['.name']))
				
				Game.GetAttitudeSystem():SetAttitudeRelationFromTweak(TweakDBID.new(entityGroup.path), TweakDBID.new(targetAttGroup.path), Enum.new("EAIAttitude", "AIA_Hostile"))
				
				reactionComp:SetReactionPreset(GetSingleton("gamedataTweakDBInterface"):GetReactionPresetRecord(TweakDBID.new("ReactionPresets.Ganger_Aggressive")))
				
				
				
				targetAttAgent:SetAttitudeTowardsAgentGroup(targetAttAgent, targetAttAgent, Enum.new("EAIAttitude", "AIA_Friendly"))
				
				
				
				
				local targetgroup =getGroupfromManager(targetgroup)
				debugPrint(1,targetgroup.tag)
				for y=1, #targetgroup.entities do 
					local entityTag2 = targetgroup.entities[i]
					
					
					local obj2 = getEntityFromManager(entityTag2)
					
					
					local target = Game.FindEntityByID(obj2.id)
					
					if(target ~= nil) then
						targetAttAgent:SetAttitudeTowards(target:GetAttitudeAgent(), Enum.new("EAIAttitude", "AIA_Hostile"))
						--	reactionComp:TriggerCombat(target)
					end
				end
				
				
				
			end
		end
	end
	
	
	function setPsycho(tag, friendtag)
		
		local enti = nil
		local obj = nil 
		local targets = nil 
		
		if(tag =="lookat"and objLook ~= nil) then 
			
			enti = objLook
			obj = getEntityFromManagerById(objLook:GetEntityID())
			
			else
			
			
			obj = getEntityFromManager(tag)
			enti = Game.FindEntityByID(obj.id)
			
			
		end
		
		
		if not friendPuppet then
			targets = Game.GetPlayer()
			else
			if(target =="target") then 
				
				
				targets = Game.FindEntityByID(selectTarget)
				
				else
				
				local obj2 = getEntityFromManager(friendtag)
				targets = Game.FindEntityByID(obj2.id)
				
				
			end
		end
		
		if enti ~= nil and enti:IsVehicle() == false and targets ~= nil then
			enti:GetAttitudeAgent():SetAttitudeGroup('HostileToEveryone')
			enti:GetAttitudeAgent():SetAttitudeTowards(targets:GetAttitudeAgent(), EAIAttitude.AIA_Neutral)
		end
	end
end

if vehiculeRegion then 
	--0 garage
	--1 beta
	--2 prevention
	
	function spawnVehicleV2(chara, appearance, tag, x, y ,z, spawnlevel, spawn_system ,isAV,from_behind,isMP,wait_for_vehicule, scriptlevel)
		
		if (('string' == type(chara)) and (string.match(tostring(chara), "AMM_Vehicle.") == nil or (string.match(tostring(chara), "AMM_Vehicle.") ~= nil and AMM ~= nil)  )  )then
		
		isprevention = isprevention or false
		
		isAV = isAV or false
		
		
		local param = isAV
		
		if(spawn_system == 1) then
			
			local vehicleSystem = Game.GetVehicleSystem()
			
			local garageVehicleId = GetSingleton('vehicleGarageVehicleID'):Resolve(chara)
			
			if(from_behind == nil or from_behind == false) then
				Game.GetVehicleSystem():ToggleSummonMode()
			end
			
			vehicleSystem:TogglePlayerActiveVehicle(garageVehicleId, 'Car', true)
			
			vehicleSystem:SpawnPlayerVehicle('Car')
			
			if(from_behind == nil or from_behind == false) then
				Game.GetVehicleSystem():ToggleSummonMode()
			end
			
			print(tostring(scriptlevel))
			
			if(from_behind == nil or from_behind == false) then
			Cron.After(0.7, function(param)
				
				local NPC = vehicleEntId
				print(npc)
				local entity = {}
				entity.id = NPC
				entity.tag = tag
				entity.tweak = chara
				entity.takenSeat = {}
				entity.isAV = isAV
				entity.name = chara
				entity.isprevention = isprevention
				entity.fromgarage = true
				entity.isMP = isMP
				
				if(scriptlevel == nil) then
				entity.scriptlevel = 0
				else
				entity.scriptlevel = scriptlevel
				end
				
				if(isMP ~= nil and isMP == true)then
					entity.name = tag
				end
					
				local veh = Game.FindEntityByID(NPC)
				entity.availableSeat = GetSeats(veh)
				--entity.availableSeat = {}
				entity.driver = {}
				
				table.insert(questMod.EntityManager,entity)
				
				local postp = Vector4.new( x, y, z,1)
				teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
				
				calledfromgarage = true
			end)
			else
			Cron.After(0.7, function(param)
				
				local NPC = vehicleEntId
				debugPrint(1,NPC)
				local entity = {}
				entity.id = NPC
				entity.tag = tag
				entity.tweak = chara
				entity.takenSeat = {}
				entity.isAV = isAV
				entity.name = chara
				entity.isprevention = isprevention
				entity.fromgarage = true
				entity.isMP = isMP
				
				if(isMP ~= nil and isMP == true)then
					entity.name = tag
				end
					
				local veh = Game.FindEntityByID(NPC)
				entity.availableSeat = GetSeats(veh)
				--entity.availableSeat = {}
				entity.driver = {}
				
				table.insert(questMod.EntityManager,entity)
				calledfromgarage = true
				
				if wait_for_vehicule == true then
					Cron.After(7, function(param)
							local postp = Vector4.new( x, y, z,1)
							teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
						

					end)
				else
					local postp = Vector4.new( x, y, z,1)
					teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
			
				end
			end)
			end
			
		else
			
			local player = Game.GetPlayer()
			local worldpos = player:GetWorldTransform()
			
			range = 5
			
			if isprevention then
				range = 10
			end
			
			local vec4 = getBehindPosition(player,range)
			
			worldpos:SetPosition(worldpos, vec4)	
			
			local twk = TweakDBID.new(chara)
			
			local NPC = nil 
			
			
			if spawn_system == 2 then
				
				local postp = Vector4.new( x, y, z,1)
				
				worldpos:SetPosition(worldpos, postp)	
				if(appearance ~= "") then
					NPC = exEntitySpawner.SpawnRecord(chara, worldpos,appearance)
					else
					NPC = exEntitySpawner.SpawnRecord(chara, worldpos)
				end
				else
				
				NPC = Game.GetPreventionSpawnSystem():RequestSpawn(twk,spawnlevel * -1,worldpos)
				
				
			end
			
			
			
			
			
			
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			entity.takenSeat = {}
			entity.isAV = isAV
			entity.name = chara
			entity.isprevention = not usebeta
			entity.fromgarage = false
				entity.isMP = isMP
			if(isMP ~= nil and isMP == true)then
				entity.name = tag
			end
			local veh = Game.FindEntityByID(NPC)
			entity.availableSeat = GetSeats(veh)
			--entity.availableSeat = {}
			entity.driver = {}
			
			table.insert(questMod.EntityManager,entity)
			
			
			
			if spawn_system == 3 then
			
				Cron.After(0.7, function(param)
					
				
						local postp = Vector4.new( x, y, z,1)
						teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
					
				end)
			end
			
			
			
			
		end
		
		else
		
		print("CyberMod: AMM Vehicle is not allowed to spawn if you don't have AMM")
		end
		
		
		
	end
	
	
	function unlockVehicles(vehicles)
		local unlockableVehicles = TweakDB:GetFlat(TweakDBID.new('Vehicle.vehicle_list.list'))
		
		for _, vehiclePath in ipairs(vehicles) do
			
			local targetVehicleTweakDbId = TweakDBID.new(vehiclePath)
			local isVehicleUnlockable = false
			
			for _, unlockableVehicleTweakDbId in ipairs(unlockableVehicles) do
				if tostring(unlockableVehicleTweakDbId) == tostring(targetVehicleTweakDbId) then
					isVehicleUnlockable = true
					break
				end
			end
			
			if not isVehicleUnlockable then
				table.insert(unlockableVehicles, targetVehicleTweakDbId)
			end
		end
		
		TweakDB:SetFlat('Vehicle.vehicle_list.list', unlockableVehicles)
		print("unlocked")
	end
	
	
	function SetVehiculeToGarage(vehiclePath,enable,asAV,tag,fakeAV)
		
		
		
		local vehi =  getVehiclefromCustomGarage(vehiclePath)
		
		
		if(vehi == nil) then 
			
			local vehio = {}
			vehio.path = vehiclePath
			vehio.tag = tag
			vehio.enabled = enable
			vehio.asAV = asAV
			vehio.fakeAV = fakeAV
			
			table.insert(currentSave.garage,vehio)
		
			print("added")
			else
			
			
			vehi.enabled = enable
			vehi.asAV = asAV
			vehi.fakeAV = fakeAV
			
		end
		
		
		Game.GetVehicleSystem():EnablePlayerVehicle(vehiclePath,true,false)
		
		
	end
	
	
	function getVehiclefromCustomGarage(vehiclePath)
		--debugPrint(1, #currentSave.garage)
		for i = 1, #currentSave.garage do
			--		debugPrint(1,currentSave.garage[i].path)
			if(currentSave.garage[i].path == vehiclePath) then
				
				return currentSave.garage[i]
				
			end
			
		end
		
	end
	
	function getVehiclefromCustomGarageTag(tag)
		--debugPrint(1, #currentSave.garage)
		for i = 1, #currentSave.garage do
			--debugPrint(1,currentSave.garage[i].path)
			if(currentSave.garage[i].tag == tag) then
				
				return currentSave.garage[i]
				
			end
			
		end
		
	end
	
	
	function spawnVehicle(vehiclePath,behind,fromgarage, isAV)
		
		
		fromgarage = fromgarage or true
		
		isAV = isAV or false
		
		
		local param = isAV
		
		local vehicleSystem = Game.GetVehicleSystem()
		
		local garageVehicleId = GetSingleton('vehicleGarageVehicleID'):Resolve(vehiclePath)
		
		if(behind == nil or behind == false) then
			Game.GetVehicleSystem():ToggleSummonMode()
		end
		
		vehicleSystem:TogglePlayerActiveVehicle(garageVehicleId, 'Car', true)
		
		vehicleSystem:SpawnPlayerVehicle('Car')
		
		if(behind == nil or behind == false) then
			Game.GetVehicleSystem():ToggleSummonMode()
		end
		
		
		
		
		Cron.After(0.7, function(param)
			
			local NPC = vehicleEntId
			debugPrint(1,NPC)
			local entity = {}
			entity.id = NPC
			entity.tag = tag
			entity.tweak = chara
			entity.takenSeat = {}
			entity.isAV = isAV
			entity.name = chara
			
			local veh = Game.FindEntityByID(NPC)
			entity.availableSeat = GetSeats(veh)
			--entity.availableSeat = {}
			entity.driver = {}
			
			table.insert(questMod.EntityManager,entity)
			
			local postp = Vector4.new( x, y, z,1)
			teleportTo(Game.FindEntityByID(NPC), postp, 1, false)
			
			calledfromgarage = true
		end)
		
		
		
		
		
		
	end
	
	
	
	function despawnVehicle(vehiclePath)
		local vehicleSystem = Game.GetVehicleSystem()
		
		local garageVehicleId = GetSingleton('vehicleGarageVehicleID'):Resolve(vehiclePath)
		
		vehicleSystem:DespawnPlayerVehicle(garageVehicleId);
	end
	
	
	
	function SetSeat(entitytag, vehiculetag, wait, seat)
		
		local entity = nil
		
		
		local vehiculeobj =  nil
		local vehicule = nil
		
		local entityobj = nil
		
		
		if(entitytag == "player") then
			
			entityobj = getEntityFromManager(entitytag)
			entity = Game.FindEntityByID(entityobj.id)
			
			else
			
			if(tag =="lookat") then 
				
				entity = objLook
				entityobj = getEntityFromManagerById(objLook:GetEntityID())
				else
				
				
				entityobj = getEntityFromManager(entitytag)
				entity = Game.FindEntityByID(entityobj.id)
				
				
			end
			
		end
		
		if(vehiculetag =="target") then 
			
			vehicule = Game.FindEntityByID(selectTarget)
			
			vehiculeobj= {}
			
			vehiculeobj.id = selectTarget
			vehiculeobj.tag = "target_vehicule_"..math.random(50,9999)
			vehiculeobj.tweak = vehicule:GetRecordID()
			vehiculeobj.takenSeat = {}
			vehiculeobj.isAV = false
			vehiculeobj.availableSeat = GetSeats(vehicule)
			vehiculeobj.driver = nil
			
			table.insert(questMod.EntityManager,vehiculeobj)
			
			
			
			else
			
			
			vehiculeobj =  getEntityFromManager(vehiculetag)
			vehicule = Game.FindEntityByID(vehiculeobj.id)
			
			
		end
		debugPrint(1,"testing")
		debugPrint(1,vehicule)
		debugPrint(1,entity)
		debugPrint(1,tostring(vehicule:IsVehicle()))
		if(vehicule ~= nil and entity ~= nil and vehicule:IsVehicle() == true) then
			debugPrint(1,"ok")
			
			
			if seat == "seat_front_left" and vehiculeobj.driver == nil then
				
				vehiculeobj.driver = entitytag
				
				elseif vehiculeobj.driver == nil then
				
				vehiculeobj.driver = "player"
				
			end
			
			
			
			
			if IsSeatTaken(vehiculeobj,seat) == true then
				
				local newseat = nil
				
				for i=1, #seats do
					if IsSeatTaken(vehiculeobj,seats[i]) == false then
						newseat = seats[i]
					end
				end
				
				seat = newseat
				
			end
			
			
			
			
			if(seat ~= nil) then
					debugPrint(1,seat)
				if(entitytag == "player") then
					
					local player = Game.GetPlayer()
					
					local data = NewObject('handle:gameMountEventData')
					data.isInstant =  not wait
					data.slotName = seat
					data.mountParentEntityId = vehiculeobj.id
					data.entryAnimName = "forcedTransition"
					
					local slotID = NewObject('gamemountingMountingSlotId')
					slotID.id = seat
					
					local mountingInfo = NewObject('gamemountingMountingInfo')
					mountingInfo.childId = player:GetEntityID()
					mountingInfo.parentId = vehiculeobj.id
					mountingInfo.slotId = slotID
					
					local mountEvent = NewObject('handle:gamemountingMountingRequest')
					mountEvent.lowLevelMountingInfo = mountingInfo
					mountEvent.mountData = data
					AVseat = seat
					Game.GetMountingFacility():Mount(mountEvent)
					table.insert(vehiculeobj.takenSeat,seat)
					entityobj.vehicleid = vehiculeobj.id
					
				else
					
					local command = 'AIMountCommand'
					local cmd = NewObject(command)
					local mountData = NewObject('handle:gameMountEventData')
					mountData.mountParentEntityId = vehiculeobj.id
					mountData.isInstant = not wait
					mountData.setEntityVisibleWhenMountFinish = true
					mountData.removePitchRollRotationOnDismount = false
					mountData.ignoreHLS = false
					mountData.mountEventOptions = NewObject('handle:gameMountEventOptions')
					mountData.mountEventOptions.silentUnmount = false
					mountData.mountEventOptions.entityID = vehiculeobj.id
					mountData.mountEventOptions.alive = true
					mountData.mountEventOptions.occupiedByNeutral = true
					mountData.slotName = CName.new(seat)
					cmd.mountData = mountData
					cmd = cmd:Copy()
					
					executeCmd(entity,cmd)
					debugPrint(1,"ok2")
					if(vehiculeobj.takenSeat == nil) then
						vehiculeobj.takenSeat = {}
					end
					table.insert(vehiculeobj.takenSeat,seat)
					entityobj.vehicleid = vehiculeobj.id
				end
				
				else
				
				Game.GetPlayer():SetWarningMessage("This car is full. Choose another one.")
				
				
			end
			
		end
	end
	
	function UnsetSeat(entitytag,wait, seat)
		
		
		
		
		local entityobj = nil
		local entity = nil
		
		if(entitytag == "player") then
			
			entityobj = getEntityFromManager(entitytag)
			entity = Game.FindEntityByID(entityobj.id)
			
			else
			
			entityobj = getEntityFromManager(entitytag)
			entity = Game.FindEntityByID(entityobj.id)
			
		end
		
		local vehiculeobj =  getEntityFromManagerById(entityobj.vehicleid)
		local vehicule = Game.FindEntityByID(entityobj.vehicleid)
		
		if(vehicule ~= nil and entity ~= nil and vehicule:IsVehicle() == true) then
			
			
			
			
			
			if(seat ~= nil) then
				
				if(entitytag == "player") then
					
					local player = Game.GetPlayer()
					
					local data = NewObject('handle:gameMountEventData')
					data.isInstant = true
					data.slotName = seat
					data.mountParentEntityId = vehiculeobj.id
					data.entryAnimName = "forcedTransition"
					
					local slotID = NewObject('gamemountingMountingSlotId')
					slotID.id = seat
					
					local mountingInfo = NewObject('gamemountingMountingInfo')
					mountingInfo.childId = player:GetEntityID()
					mountingInfo.parentId = vehiculeobj.id
					mountingInfo.slotId = slotID
					
					local mountEvent = NewObject('handle:gamemountingUnmountingRequest')
					mountEvent.lowLevelMountingInfo = mountingInfo
					mountEvent.mountData = data
					
					Game.GetMountingFacility():Unmount(mountEvent)
					
					
					else
					
					
					
					local command = 'AIUnmountCommand'
					local cmd = NewObject(command)
					local mountData = NewObject('handle:gameMountEventData')
					mountData.mountParentEntityId = vehiculeobj.id
					mountData.isInstant = false
					mountData.setEntityVisibleWhenMountFinish = true
					mountData.removePitchRollRotationOnDismount = false
					mountData.ignoreHLS = false
					mountData.mountEventOptions = NewObject('handle:gameMountEventOptions')
					mountData.mountEventOptions.silentUnmount = false
					mountData.mountEventOptions.entityID = vehiculeobj.id
					mountData.mountEventOptions.alive = true
					mountData.mountEventOptions.occupiedByNeutral = true
					mountData.slotName = CName.new(seat)
					cmd.mountData = mountData
					cmd = cmd:Copy()
					
					executeCmd(entity,cmd)
					
					
				end
				
				local seatIndex = 0
				for i=1,#vehiculeobj.takenSeat do
					
					if(vehiculeobj.takenSeat[i] == entityobj.seat) then
						seatIndex = i
					end
					
				end
				
				table.remove(vehiculeobj.takenSeat,seatIndex)
				
				entityobj.seat = nil
				entityobj.vehicleid = nil
				
				
				
				
			end
			
		end
	end
	
	
	
	function IsSeatTaken(vehiculeobj,seat)
		
		local istaken = false
		
		if(vehiculeobj.takenSeat ~= nil) then
			for i=1,#vehiculeobj.takenSeat do
				
				if(vehiculeobj.takenSeat[i] == seat)then
					istaken = true
				end
				
			end
		end
		
		return istaken
		
	end
	
	
	
	function GetSeats(entityveh)
		
		
		
		local vehiculeSeat = {}
		
		for i=1, #seats do
			
			if Game['VehicleComponent::HasSlot;GameInstanceVehicleObjectCName'](entityveh, CName.new( seats[i])) then
				table.insert(vehiculeSeat, seats[i])
				-- debugPrint(1,seats[i])
			end
		end
		
		return vehiculeSeat
		
		
	end
	
	
	function VehicleFollowEntity(vehiculetag, entitytag)
		
		local entity = Game.GetPlayer()
		
		if entitytag ~= "player" then
			
			local entityobj = getEntityFromManager(entitytag)
			entity = Game.FindEntityByID(entityobj.id)
			
		end
		
		local vehiculeobj =  nil
		
		
		local vehicule = nil
		
		if(vehiculetag =="target") then 
			
			
			vehicule = Game.FindEntityByID(selectTarget)
			
			else
			
			vehiculeobj =  getEntityFromManager(vehiculetag)
			
			
			
		end
		
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			vehicule = Game.FindEntityByID(vehiculeobj.id)
			
		end
		
		
		local distance = 4
		if(vehicule ~= nil) then
			
			if string.find(tostring(vehicule:GetClassName()),"vehicleBikeBaseObject") ~= nil then
				distance = distance*2
			end
			
			local cmd = NewObject("handle:AIVehicleFollowCommand")
			cmd.target = entity
			cmd.distanceMin = distance
			cmd.needDriver = false
			cmd.useTraffic = false
			cmd.useKinematic = true
			cmd.stopWhenTargetReached = false
			
			
			
			local AINPCCommandEvent = NewObject("handle:AINPCCommandEvent")
			AINPCCommandEvent.command = cmd
			vehicule:QueueEvent(AINPCCommandEvent)
		end
	end
	
	
	function VehicleGoToGameNode(vehiculetag, noderef, speed, greenlight, needdriver, usetraffic)
		
		
		
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		
		
		local cmd = NewObject("handle:AIVehicleToNodeCommand")
		cmd.nodeRef = noderef
		cmd.needDriver = false
		
		cmd.stopAtPathEnd = true
		cmd.useTraffic = usetraffic or false
		cmd.speedInTraffic = speed
		cmd.forceGreenLights = greenlight
		cmd = cmd:Copy()
		
		
		local AINPCCommandEvent = NewObject("handle:AINPCCommandEvent")
		AINPCCommandEvent.command = cmd
		vehicule:QueueEvent(AINPCCommandEvent)
		
		
		
		
	end
	
	
	
	function VehicleDoors(vehiculetag, action)
		
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		local getTargetPS = vehicule:GetVehiclePS()
		
		
		if action == "open" then
			getTargetPS:OpenAllRegularVehDoors(false)
			
			elseif action == "close" then
			getTargetPS:CloseAllVehDoors(false)
			
			elseif action == "lock" then
			getTargetPS:LockAllVehDoors()
			
			elseif action == "unlock" then
			getTargetPS:UnlockAllVehDoors()
			
		end
		
		
	end
	
	function VehicleWindows(vehiculetag, action)
		
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		local getTargetPS = vehicule:GetVehiclePS()
		
		
		if action == "open" then
			getTargetPS:OpenAllVehWindows()
			
			elseif action == "close" then
			getTargetPS:CloseAllVehWindows()
			
			
			
		end
		
		
	end
	
	
	function VehicleDetachAll(vehiculetag)
		
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		vehicule:DetachAllParts()
		
	end
	
	function VehicleDestroy(vehiculetag)  
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		local getTargetPS = vehicule:GetVehiclePS()
		local getTargetVC = vehicule:GetVehicleComponent()
		
		getTargetVC:DestroyVehicle()
		getTargetVC:LoadExplodedState()
		getTargetVC:ExplodeVehicle(Game.GetPlayer())
		getTargetPS:ForcePersistentStateChanged()
		
	end
	
	function VehicleRepair(vehiculetag)
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		
		local getTargetPS = vehicule:GetVehiclePS()
		local getTargetVC = vehicule:GetVehicleComponent()
		
		vehicule:DestructionResetGrid()
		vehicule:DestructionResetGlass()
		
		getTargetVC:RepairVehicle()
		getTargetPS:ForcePersistentStateChanged()
		
	end
	
	function VehicleHonkFlash(vehiculetag)
		
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		if(vehicule ~= nil) then
			
			local getTargetVC = vehicule:GetVehicleComponent()
			
			getTargetVC:HonkAndFlash()
		end
		
		
	end 
	--"Off","Normal","High Beams",
	function VehicleLights(vehiculetag, state)
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		local getTargetVC = vehicule:GetVehicleComponent()
		local getTargetVCPS = getTargetVC:GetVehicleControllerPS()
		
		getTargetVCPS:SetLightMode(state)
		
		
	end
	
	function VehicleEngine(vehiculetag, state)
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		local getTargetVC = vehicule:GetVehicleComponent()
		local getTargetVCPS = getTargetVC:GetVehicleControllerPS()
		
		if state == "on" then 
			getTargetVCPS:SetState(2)
			
			elseif state == "off" then
			getTargetVCPS:SetState(1)
		end
		
		
	end
	
	function VehicleReset(vehiculetag)
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		local getTargetVC = vehicule:GetVehicleComponent()
		
		getTargetVC:ResetVehicle()
		
	end
	
	function VehicleSetInvincible(vehiculetag)
		local vehiculeobj =  getEntityFromManager(vehiculetag)
		if(vehiculetag =="lookat") then 
			
			local entity = objLook
			vehiculeobj = getEntityFromManagerById(objLook:GetEntityID())
			
			
		end
		local vehicule = Game.FindEntityByID(vehiculeobj.id)
		
		if(vehicule ~= nil) then
			local getTargetVC = vehicule:GetVehicleComponent()
			
			getTargetVC:SetImmortalityMode()
		end
		
	end
	
	
	
	
end


