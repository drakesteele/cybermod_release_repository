debugPrint(3,"CyberScript: multi module loaded")
questMod.module = questMod.module +1



function MultiWindows()
	
	local reader = dir("net/multi/player")
	if(reader ~= nil and #reader > 0) then
		
		for i=1,#reader do
			if(reader[i].name ~= "token.json") then
				local f = io.open("net/multi/player/"..reader[i].name)
				local lines = f:read("*a")
				
				if(lines ~= "" ) then
					local jsonf =trydecodeJSOn(lines, f,"net/multi/player/"..reader[i].name)
					
					currentSave.myAvatar = jsonf.myAvatar
					myFriendTag = jsonf.myFriendTag
					myTag = jsonf.myTag
					
				end
				
				f:close()
				AlreadyLogin = true
			end
		end
	end
	
	if ImGui.Begin("Multiplayer Menu") then
		ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(310, 0	, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(300, 500)
		
		ImGui.Text("Statut : ")
		ImGui.SameLine()
		ImGui.Text(tostring(MultiplayerOn))
		ImGui.Spacing()
		ImGui.Text("My Tag :")
		myTag = ImGui.InputText("myTag", myTag, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		ImGui.Text("My Password :")
		myPassword = ImGui.InputText("myPassword", myPassword, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		ImGui.Spacing()
		ImGui.Text("My Avatar :")
		currentSave.myAvatar =  ImGui.InputText("myAvatar", currentSave.myAvatar, 100, ImGuiInputTextFlags.AutoSelectAll)
		ImGui.Spacing()
		ImGui.Text("My Friend Tag :")
		myFriendTag =  ImGui.InputText("myFriendTag", myFriendTag, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		ImGui.Spacing()
		ImGui.Text(errormessage)
		
		if ImGui.Button("Create User") then 
			
			
			
			
			
			createUser()
			
		end
		
		if ImGui.Button("Launch Multiplayer") then 
			
			
			
			
			
			connectUser()
			
		end
		
		
		if ImGui.Button("Log Off") then 
			disconnectUser()
			
			lastFriendPos = {}
			Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
			
			MultiplayerOn = false
			
			friendIsSpaned = false
			
			if(file_exists("net/multi/player/token.json"))then
				
				os.remove("net/multi/player/token.json")
				
			end
			
			
		end
		
		if ImGui.Button("Close") then 
			
			multiWindowsOpen = false
			
		end
		
		ImGui.End()
		
	end
	
	
end


function WriteMultiAction(action)
	
	debugPrint(2,action.action)
	
	local file = assert(io.open("net/multi.json", "w"))
	local stringg = JSON:encode_pretty(action)
	--debugPrint(2,stringg)
	file:write(stringg)
	file:close()
end

function tokenFileExist()
	
	return file_exists("net/multi/player/token.json")
	
end

function tokenIsValidate()
	
	return file_exists("net/multi/player/connect.txt")
	
end

function createUser()
	
	local action = {}
	
	action.action = "createUser"
	
	action.password = myPassword
	action.tag = myTag
	action.avatar = currentSave.myAvatar
	action.faction =myFaction
	
	
	WriteMultiAction(action)
	
	waitforactionfailorsuccess(0.1,false,
		function()
			errormessage = "Player Created !"
			connectUser()
		end,
		function()
			errormessage = "Player already Exist !"
		end)
end

function syncPosition(pos,rot)
	
	
	if tokenIsValid == true then
		local action = {}
		--debugPrint(2,"syncpos")
		
		action.x = pos.x
		action.y = pos.y
		action.z = pos.z
		
		
		
		action.yaw = rot.yaw
		action.pitch = rot.pitch
		action.roll = rot.roll
		action.radius = 30
		action.avatar = currentSave.myAvatar
		
		if(Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer()))then
		
			if(inVehiculeTweak ~= nil or inVehiculeTweak ~= "")then
				action.avatar = inVehiculeTweak
			end
		
		end
		
		
		pcall(function()
			
			local stringg = JSON:encode_pretty(action)
			--debugPrint(2,stringg)
			local file = io.open("net/multi/mypos.json", "w")
			file:write(stringg)
			file:close()
			
		end)
		
		else
		
		local action = {}
		
		
		action.x = pos.x
		action.y = pos.y
		action.z = pos.z
		
		
		
		action.yaw = rot.yaw
		action.pitch = rot.pitch
		action.roll = rot.roll
		action.radius = 30
		action.password = nil
		
		
		pcall(function()
			local file = assert(io.open("net/multi/mypos.json", "w"))
			local stringg = JSON:encode_pretty(action)
			--debugPrint(2,stringg)
			file:write(stringg)
			file:close()
			
		end)
		
	end
	
end

function onlineMessageProcessing()
	
	
		for i=1,#CurrentOnlineMessage do
	
		 if CurrentOnlineMessage[i].State == 0 then
		
				local canAdd =  true
				
				
				
				local index = 0
				local count = 1
				if(#OnlineConversation.conversation > 0) then
					for y=1,#OnlineConversation.conversation do
						if(OnlineConversation.conversation[y] ~= nil and OnlineConversation.conversation[y].name == CurrentOnlineMessage[i].Sender) then
							index = y
						end
					end
				end
				
				if(index ~= 0) then
					debugPrint(2,"mark1")
					if(OnlineConversation.conversation.message ~= nil and #OnlineConversation.conversation.message > 0) then
						for y=1,#OnlineConversation.conversation.message do
							if(OnlineConversation.conversation.message[y].tag ==  "online_"..CurrentOnlineMessage[i].Sender.."_"..string.sub(CurrentOnlineMessage[i].CreationDate,1,16)) then
								canAdd =  false
							end
						end
					end
					
					if(canAdd == true) then
				
						debugPrint(2,"mark2")
						count = #OnlineConversation.conversation[index].message+1
						
						local mes = {}
						
						mes.tag = "online_"..CurrentOnlineMessage[i].Sender.."_"..string.sub(CurrentOnlineMessage[i].CreationDate,1,16)
						mes.text = CurrentOnlineMessage[i].Content
						mes.sender = 0
						mes.unlock = true
						mes.readed = false
						mes.choices = {}
						table.insert(OnlineConversation.conversation[index].message,mes)
						
						setScore(mes.tag,"unlocked",1)
					
					
					end
				
				else
					debugPrint(2,"mark3")
					local newconversation = {}
					newconversation.tag = "online_"..CurrentOnlineMessage[i].Sender.."_"..string.sub(CurrentOnlineMessage[i].CreationDate,1,16)
					newconversation.name = CurrentOnlineMessage[i].Sender
					newconversation.unlock = true
					
					newconversation.message = {}
					
					local mes = {}
					mes.tag = "online_"..CurrentOnlineMessage[i].Sender.."_"..count
					mes.text = CurrentOnlineMessage[i].Content
					mes.sender = 0
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					
					table.insert(newconversation.message,mes)
					
					table.insert(OnlineConversation.conversation,newconversation)
					
					setScore(newconversation.tag,"unlocked",1)
					
					setScore(mes.tag,"unlocked",1)
					
				end
			
			
			
		
			 
			 CurrentOnlineMessage[i].State = 1
			 
		 end
		end
		
		
		

end


function onlineInstanceMessageProcessing()
		local index = 0
		debugPrint(2,"onlin")
	
		if#OnlineConversation.conversation > 0 then
		for y=1,#OnlineConversation.conversation do
			if(OnlineConversation.conversation[y] ~= nil and OnlineConversation.conversation[y].name == "Instance") then
				index = y
				break
			end
		end
		end
		
		
		if(index ~= 0) then
			debugPrint(2,"index "..index)
			debugPrint(2,OnlineConversation.conversation[index].name)
			OnlineConversation.conversation[index] = {}
		end
		
		local newconversation = {}
		newconversation.tag = "online_instance"
		newconversation.name = "Instance"
		newconversation.unlock = true
		
		newconversation.message = {}
		
		
		
		
		
		for i=1,#CurrentOnlineInstanceMessage do
		
		
			
			debugPrint(2,CurrentOnlineInstanceMessage[i].Content)
					
					
					local mes = {}
					mes.tag = "online_instance_"..CurrentOnlineInstanceMessage[i].Sender.."_"..string.sub(CurrentOnlineInstanceMessage[i].CreationDate,1,16)
					mes.text = CurrentOnlineInstanceMessage[i].Content
					
						if(CurrentOnlineInstanceMessage[i].Sender == myTag)then
							mes.sender = 1
						else
							mes.sender = 0
						end
						
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					
					table.insert(newconversation.message,mes)
					
					setScore(mes.tag,"unlocked",1)
					
			end
			
			setScore(newconversation.tag,"unlocked",1)
			table.insert(OnlineConversation.conversation,newconversation)
			 
			 
			
			
			
			 
			
		 end

		
		
		
function talkTo(userName, content)
	
	
local actionlist = {}

local action = {}

action.name = "send_action_to_user"
action.tag = "lookat"
action.action = {}

local subaction = {}
subaction.name = "subtitle"
subaction.title = content
subaction.type = 1
subaction.target = "player"
subaction.speaker = myTag
subaction.duration = 2
table.insert(action.action,subaction)

table.insert(actionlist,action)
table.insert(actionlist,subaction)


runActionList(actionlist, myTag.."_multi_"..tostring(math.random(1,9999)), "interact",false,myTag,false)


end


function ShootTalk(content)
	
	local actionlist = {}

for i=1,#ActualPlayersList do
	
	local action = {}

	action.name = "send_action_to_user"
	action.tag = ActualPlayersList[i].pseudo
	action.action = {}

	local subaction = {}
	subaction.name = "npc_chat"
	subaction.title = content
	subaction.type = 1
	subaction.target = myTag
	subaction.speaker = myTag
	subaction.duration = 2

	table.insert(action.action,subaction)
	table.insert(actionlist,action)
	
	local waitaction = {}

	action.name = "wait_second"
	action.value = 0.5

	table.insert(actionlist,waitaction)
	


	
end

runActionList(actionlist, myTag.."_shoot_multi_"..tostring(math.random(1,9999)), "interact",false,myTag,false)

end


function testFriend(pos,rot)
	
	local action = {}
	
	action.x = pos.x-2
	action.y = pos.y-2
	action.z = pos.z
	
	action.yaw = rot.yaw
	action.pitch = rot.pitch
	action.roll = rot.roll
	
	action.friend = myTag
	action.tag = myFriendTag
	action.avatar = "Character.Claire"
	
	
	local file = assert(io.open("net/multi/mypos.json", "w"))
	local stringg = JSON:encode_pretty(action)
	--debugPrint(2,stringg)
	file:write(stringg)
	file:close()
	
	
end


function connectUser()
	local action = {}
	
	action.action = "connectUser"
	action.password = myPassword
	action.tag = myTag
	
	WriteMultiAction(action)
	
	waitforactionfailorsuccess(0.1,false,
		function()
			errormessage = "Player Connected !"
			openNetContract = false
			io.open("net/multienabled.txt","w"):close()
			MultiplayerOn = false
			NetServiceOn = true
			Game.GetPlayer():SetWarningMessage(getLang("multi_welcome"))
			tokenIsValid = tokenIsValidate()
			openNetContract = false
			
		
			OnlineConversation = nil
			
			
			
			OnlineConversation = {}
			OnlineConversation.tag = "online_conversation"
			OnlineConversation.unlock = true
			OnlineConversation.speaker = "Online"
			OnlineConversation.conversation = {}
			
			setScore(OnlineConversation.tag,"unlocked",1)
			
			
			
			
			
		end,
		function()
			errormessage = "Error during connection"
			tokenIsValid = false
			NetServiceOn =false
			MultiplayerOn = false
			disconnectUser()
			
		end)
end

function disconnectUser()
	
	local action = {}
	action.action = "disconnectUser"
	
	
	
	disconnectAllPlayers()
	
	WriteMultiAction(action)
	os.remove("net/multi/player/token.json")
	
	waitforactionfailorsuccess(0.1,false,
		function()
			errormessage = "Player Disconnected !"
			OnlineConversation = nil
			setScore("online_conversation","unlocked",0)
		end,
		function()
			errormessage = "Error during disconnect"
		end)
		
		
		
end



function getGuildfromDistrict(district,minimum)
	
	local factiontable = {}
	
	for k,v in pairs(ActualPlayerMultiData.guildscores) do
		
		if(ActualPlayerMultiData.guildscores[k][district] ~= nil and ActualPlayerMultiData.guildscores[k][district] >= minimum) then
			debugPrint(2,k)
		debugPrint(2,district)
		debugPrint(2,ActualPlayerMultiData.guildscores[k][district])
			local factionscore= {}
			factionscore.tag = k
			factionscore.score = ActualPlayerMultiData.guildscores[k][district]
			table.insert(factiontable,factionscore)
			
			
			
			
		end
		
		
		
	end
	
	table.sort(factiontable, function(a,b) return a.score > b.score end)
	
	return factiontable
	
end


function getFriendPos()

	--read myfriend.json actual players in range
	local fz = assert(io.open("net/multi/myfriend.json"))
	local liness = fz:read("*a")
	fz:close()

	if liness == "" or liness == "Not connected" or liness == nil then
		do return end
	end

	--If no players in file despawn all connected player and return
	
	
		ActualPlayerMultiData = json.decode(liness)
	
		CurrentOnlineInstanceMessage = ActualPlayerMultiData.instance_messages
		
		if ((#ActualPlayerMultiData.messages >0))then
			
			for i=1,#ActualPlayerMultiData.messages do 
				local canAdd = true
				
				for y=1,#CurrentOnlineMessage do 
					if(CurrentOnlineMessage[y].Id == ActualPlayerMultiData.messages[i].Id) then
					
					canAdd = false
					
					end
					
				end
				
				
				if(canAdd == true) then table.insert(CurrentOnlineMessage,ActualPlayerMultiData.messages[i]) debugPrint(2,"added") end
			end
			
			
			
			
		end
		
	if #ActualPlayerMultiData.currentPlaces > 0 then --if inside multi place
	
		if(currentMultiHouse ~= nil) then --if already inside
		
			if(tostring(currentMultiHouse.LastUpdateDate) ~= tostring(ActualPlayerMultiData.currentPlaces[1].LastUpdateDate)) then --if there is an update
			
				despawnItemFromMultiHouse() -- we delete exisiting item
				
				ItemOfHouseMultiSpawned = false
				
				currentMultiHouse = ActualPlayerMultiData.currentPlaces[1] --we update and place.lua will do the job
				print("update")
			end
			--we dont if not 
			else --if not already in
			ItemOfHouseMultiSpawned = false
			currentMultiHouse = ActualPlayerMultiData.currentPlaces[1] -- we set and place.lua will do the job
			print("set")
		end
	else -- if not we empty and place.lua will do the job for delete them
	
	if(currentMultiHouse~= nil) then
		currentMultiHouse = nil
		print("empty")
	end
	end
	
	
	if ActualPlayerMultiData.actions ~= nil and #ActualPlayerMultiData.actions > 0 and workerTable[myTag.."_multi_script"] == nil then
		runActionList(ActualPlayerMultiData.actions, myTag.."_multi_script", "interact",false,myTag,false)
	end
	
	CurrentInstance = ActualPlayerMultiData.instance
	CurrentGuild = ActualPlayerMultiData.currentGuild
	
	if #ActualPlayerMultiData.players == 0 then
		if previousConnectedPlayersList ~= nil and #previousConnectedPlayersList > 0 then
			disconnectAllPlayers()
		end
		
		do return end
	end
	
	ActualPlayersList = ActualPlayerMultiData.players
	
	ActualInstancePlayersList = ActualPlayerMultiData.instance_players
	
	ActualFriendList = ActualPlayerMultiData.friends
	
	if ActualPlayersList ~= nil and #ActualPlayersList > 0 then
		for i=1, #ActualPlayersList do 
			if table_has_value(previousConnectedPlayersList, ActualPlayersList[i]) then
			--for update a player position
				local obj = getEntityFromManager(ActualPlayersList[i].pseudo)
				--debugPrint(2,"object ID " .. tostring(obj.id))
				if obj.id ~= nil then
					local enti = Game.FindEntityByID(obj.id)
					
					--debugPrint(2,"object Entity" .. tostring(enti))
					
					if enti ~= nil then

						-- get previous player position
						PreviousPlayerPosition =  ReturnPlayerFromTable(previousConnectedPlayersList,ActualPlayersList[i].pseudo)
						
						
						
						
						--debugPrint(2,"Previous player position X : " .. tostring(PreviousPlayerPosition.x)..", " .. "Y : " .. tostring(PreviousPlayerPosition.y)..", " .. "Z : " .. tostring(PreviousPlayerPosition.z))
						--debugPrint(2,"New player position X : " .. tostring(ActualPlayersList[i].x)..", " .. "Y : " .. tostring(ActualPlayersList[i].y)..", " .. "Z : " .. tostring(ActualPlayersList[i].z))
						
						--move player and update previous position only if new position != previous position
						if(PreviousPlayerPosition.x ~= ActualPlayersList[i].x or PreviousPlayerPosition.y ~= ActualPlayersList[i].y or PreviousPlayerPosition.yaw ~= ActualPlayersList[i].yaw) then
							debugPrint(2,ActualPlayersList[i].avatar)
							debugPrint(2,PreviousPlayerPosition.avatar)
							if(PreviousPlayerPosition.avatar == ActualPlayersList[i].avatar) then
							
							
							local positionVec4 = {}
							positionVec4.x = ActualPlayersList[i].x
							positionVec4.y = ActualPlayersList[i].y
							positionVec4.z = ActualPlayersList[i].z
							positionVec4.w = 1
							
							local rotation = {}
							rotation.roll = ActualPlayersList[i].roll
							rotation.pitch = ActualPlayersList[i].pitch
							rotation.yaw = ActualPlayersList[i].yaw
							local carscale = 5
							if(PreviousPlayerPosition.x ~= ActualPlayersList[i].x or PreviousPlayerPosition.y ~= ActualPlayersList[i].y) then
								if ('string' == type(ActualPlayersList[i].avatar)) and string.match(ActualPlayersList[i].avatar, "Vehicle.") then
								
								
							--	if(mpvehicletick >= 5 ) then	
								
									local actionlist = {}
									
									local action = {}
									
									action.name = "vehicule_autodrive_activate"
									action.x = positionVec4.x
									action.y = positionVec4.y
									action.z = positionVec4.z
									action.tag = ActualPlayersList[i].pseudo
									action.isAV = false
									action.speed = 1.2
									action.pathfinding = false
									action.do_rotation = false
									
									table.insert(actionlist,action)
									
									local poscar = enti:GetWorldPosition()
									if(workerTable[ActualPlayersList[i].pseudo.."_multi_vehicle"] == nil and 
									(poscar.x ~= ActualPlayersList[i].x and (poscar.x > ActualPlayersList[i].x+carscale or poscar.x < ActualPlayersList[i].x-carscale )  )
									or (poscar.y ~= ActualPlayersList[i].y and (poscar.y > ActualPlayersList[i].y+carscale or poscar.y < ActualPlayersList[i].y-carscale)))  
									 then
										runActionList(actionlist, ActualPlayersList[i].pseudo.."_multi_vehicle", "interact",false,ActualPlayersList[i].pseudo,false)
										
									end 
									
									--teleportTo(enti, Vector4.new( positionVec4.x, positionVec4.y, positionVec4.z,1), rotation, false)
								
								
							--	end
								else
									
									
									MoveTo(enti, positionVec4, 1, "Sprint")
									
									--RotateEntityTo(enti, rotation.pitch, rotation.yaw, rotation.roll)

								end
							else
								if(PreviousPlayerPosition.yaw ~= ActualPlayersList[i].yaw and string.match(ActualPlayersList[i].avatar, "Vehicle.") and string.match(ActualPlayersList[i].avatar, "Vehicle.") == false) then
								
									
									teleportTo(enti, Vector4.new( positionVec4.x, positionVec4.y, positionVec4.z,1), rotation, false)
								end
							end
							
							--update previous player position
							
							PreviousPlayerPosition.x = ActualPlayersList[i].x
							PreviousPlayerPosition.y = ActualPlayersList[i].y
							PreviousPlayerPosition.z = ActualPlayersList[i].z
							
							PreviousPlayerPosition.yaw = ActualPlayersList[i].yaw
							PreviousPlayerPosition.pitch = ActualPlayersList[i].pitch
							PreviousPlayerPosition.roll = ActualPlayersList[i].roll
							PreviousPlayerPosition.avatar = ActualPlayersList[i].avatar
							else
							
							
							despawnOtherPlayer(previousConnectedPlayersList[i].pseudo)
							spawnOtherPlayer(ActualPlayersList[i].avatar, ActualPlayersList[i].pseudo, ActualPlayersList[i].x, ActualPlayersList[i].y ,ActualPlayersList[i].z,13)
							PreviousPlayerPosition.avatar = ActualPlayersList[i].avatar
							
						end
						end
					end	
				end
			else
			--When a player spawn
				table.insert(previousConnectedPlayersList, ActualPlayersList[i])
				table.insert(questMod.GroupManager["Multi"].entities,ActualPlayersList[i].pseudo)
				
				spawnOtherPlayer(ActualPlayersList[i].avatar, ActualPlayersList[i].pseudo, ActualPlayersList[i].x, ActualPlayersList[i].y ,ActualPlayersList[i].z,13)
			end
		end
		
			--Remove disconnected Player
		if #previousConnectedPlayersList > 0 then
			for i=1, #previousConnectedPlayersList do 
				if IfNotExistIntheList(ActualPlayersList,previousConnectedPlayersList[i]) then
					
					--despawnEntity(previousConnectedPlayersList[i].pseudo)
					
					despawnOtherPlayer(previousConnectedPlayersList[i].pseudo)
					table.remove(previousConnectedPlayersList,i)
				end
			end
		end
	end
	
	if(mpvehicletick >= 5) then
	mpvehicletick = 0
	end
	
end

function disconnectAllPlayers ()

	if(previousConnectedPlayersList == nil) then 
		do return end
	end 

    for i=1, #previousConnectedPlayersList do
		--despawnEntity(previousConnectedPlayersList[i].pseudo)
		despawnOtherPlayer(previousConnectedPlayersList[i].pseudo)
		table.remove(previousConnectedPlayersList,i)
	end
end


function table_has_value (tab, val)

	if tab == nil then 
	return false
	end 

    for index, value in ipairs(tab) do
        if value.pseudo == val.pseudo then
		
            return true
        end
    end

    return false
end





function IfNotExistIntheList (tab, val)
    for index, value in ipairs(tab) do
        if value.pseudo == val.pseudo then
            return false
        end
    end

    return true
end

function table_removeFirst(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then
      return table.remove(tbl, i)
    end
  end
end


function updatePlayerInTable(LastPlayerPosTable, player)
	
	if #LastPlayerPosTable > 0 then
	
		for i=1,#LastPlayerPosTable do
		
			if(LastPlayerPosTable[i].pseudo == player.pseudo) then
				LastPlayerPosTable[i] = player
			end
		
		end
	
	end
end

function ReturnPlayerFromTable(PlayerTable, pseudo)
	
	if #PlayerTable > 0 then
	
		for i=1,#PlayerTable do
		
			if(PlayerTable[i].pseudo == pseudo) then
				return PlayerTable[i]
			end
		
		end
	
	end
	
return nil
	
end


function spawnPlayers()
	if(#to_spawn > 0) then
	for i=1,#to_spawn do
	debugPrint(2,tostring(to_spawn[i].pseudo))
	debugPrint(2,tostring(to_spawn[i].finished))
	if(to_spawn[i].finished == "false")then
		to_spawn[i].finished = true
		spawnEntity(to_spawn[i].chara, to_spawn[i].pseudo, to_spawn[i].x, to_spawn[i].y ,to_spawn[i].z,13,false)
		debugPrint(2,"Player spawn")
		table.remove(to_spawn,i)
		
	end
	
	end
	
	
	local count = 0
	
	
	for i=1,#to_spawn do
		if(to_spawn[i].finished == true)then
			count = count+1
			
		end
	end
	
	if(count == #to_spawn) then
		to_spawn = {}
		debugPrint(2,"clean waited players spawn")
		canSpawn = true
	end
	
	
	
	end
	
end
