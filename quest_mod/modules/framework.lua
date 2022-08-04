debugPrint(2,"CyberScript: framework module loaded")
questMod.module = questMod.module +1


--Modpack and Mod
function GetModpackList()
	
		
		local action = {}
		
		action.action = "GetModpackList"
		action.parameter = ""
	
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			debugPrint(2,"OK...")
			
		
			debugPrint(2,#arrayDatapack3)
			arrayMyDatapack = {}
			arrayMyDatapack = readDatapackDownloaded()
			
			arrayDatapack3 = {}
			arrayDatapack3 = readDatapackStore()
			
		end)
		
	
	
end

function FetchData()
		
		fetcheddata = readFetchedData()
		
	
		
			local action = {}
			
			action.action = "FetchData"
			action.parameter = ""
			
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
				
				fetcheddata = readFetchedData()
				arrayDatapack3 = {}
				arrayDatapack3 = fetcheddata.datapack
				
			
				debugPrint(2,#arrayDatapack3)
				
				fetchdatatime = fetcheddata.updatetime
				currentbranch = fetcheddata.branch
				currentRole =  fetcheddata.role
				currentFaction =  fetcheddata.faction
				currentFactionRank =  fetcheddata.factionrank
				possiblecategory = {}
				
				corpoNews =  fetcheddata.corponews
				FillCorpo()
				
				for i=1,#fetcheddata.itemcat do
				table.insert(possiblecategory,fetcheddata.itemcat[i].parent)
				
				end
				
				
				
				CurrentServerModVersion = fetcheddata.modversion
				
				
				
			end)
		
		
		
	
	
end


function CompareListAndDelete()
	
	for i=1, #arrayMyDatapack do
	local mydatapck = arrayMyDatapack[i]
	local count = 0
	
	
		for y=1, #arrayDatapack3 do
			local serverdatapck = arrayDatapack3[y]
			
			if(mydatapck.tag == serverdatapck.tag) then
				count = 1
			end
		
	
		end
		
		
	if count == 0 then
		DeleteModpack(mydatapck.tag)
	end
	
	end
	
end


function DownloadModpack(datapackfile)
	
	
		local action = {}
		action.action = "DownloadModpack"
		action.parameter = datapackfile
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			
	
			CheckandUpdateDatapack()
			
			
			
			
			
		end)
	
	
end

function UpdateModpack(datapackfile,tag)
	
	
		local action = {}
		
		action.action = "UpdateModpack"
		action.parameter = datapackfile
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(10,"update")
			debugPrint(10,tag)
			
			CheckandUpdateDatapack()
	
			debugPrint(10,tag..getLang("framework_modpack_updated") ..arrayDatapack[tag].metadata.version)
			
		end)
	
	
end


function ZipMyDatapack()
	
		
		
		local action = {}
		
		action.action = "ZipMyDatapack"
		action.parameter = ""
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			canLoad = true
			
			
		end)
	
	
end


function DeleteModpack(tag)
	
	
		local action = {}
		
		action.action = "DeleteModpack"
		action.parameter = tag
		currentpack = tag
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			
		
			
			DeleteDatapackFromCache(tag)
			CheckandUpdateDatapack()
			LoadDataPackCache()
			
			arrayDatapack3 = {}
			arrayDatapack3 = readDatapackStore()
			
			
			debugPrint(10,tag..getLang("framework_modpack_deleted") ..tostring(arrayDatapack[tag]== nil))
			
			
			currentpack = ""
			
		end)
	
	
end



function GetModVersion()
	
	
		local action = {}
		
		action.action = "GetModVersion"
		action.parameter = ""
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			CurrentServerModVersion = {}
			CurrentServerModVersion = readCurrentServerModVersion()
			debugPrint(2,CurrentServerModVersion.version)
		
		end
		)
	
end



function UpdateMods()
	
	
		local action = {}
		
		action.action = "UpdateMods"
		action.parameter = ""
		
	
		db:close()
		db = nil
		io.open("net/dbclose.txt","w"):close()
		updateinprogress = true

		WriteAction(action)
		
		
		
		waitforactionfinished(1,false, function()
			
		local action = {}
		
		action.action = "GetModVersion"
		action.parameter = ""
		
		WriteAction(action)
	
		
		end)
		
		waitforactionfinished(1,false, function()
			
		
	
		
		end)
	
	
end



function GeMissionList()
	
	
		local action = {}
		
		action.action = "GeMissionList"
		action.parameter = ""
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMission = {}
			arrayMission = readFile("net/missionlist.json",false)
			
		
			
			arrayMymissions = {}
			arrayMymissions = readFile("net/mymissions.json",false)
			
		end)
	
	
end


function DownloadMission(tag)
	
	
		local action = {}
		
		action.action = "DownloadMission"
		action.parameter = tag
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMission = {}
			arrayMission = readFile("net/missionlist.json",false)
			
		
			
			arrayMymissions = {}
			arrayMymissions = readFile("net/mymissions.json",false)
			openDatapackManager = false
			canLoad = true
			LoadDataPack()
		end)
	
	
end


function DeleteMission(tag)
	
		arrayMymissions = {}
		arrayMymissions = readFile("net/mymissions.json",false)
		local index = nil
		for i=1,#arrayMymissions do 
		
			if(arrayMymissions[i] == tag) then
			index = i
			end
		
		end
		
		if(index ~= nil) then
		table.remove(arrayMymissions,index)
		end
		
		local file2 = assert(io.open("net/mymissions.json", "w"))
		local stringg2 = JSON:encode_pretty(arrayMymissions)
		debugPrint(2,stringg2)
		file2:write(stringg2)
		file2:close()
	
		os.remove("json/datapack/downloadedmission/mission/"..tag..".json")
		finishwaiting(false)
		os.remove("successaction.txt")
	
end


function setUserVersion()
	
	local action = {}
		
	action.action = "userversion"
	action.parameter = ""
	
	WriteAction(action)
	
	
	
end



function readFetchedData()
	
	
	
	local fz = assert(io.open("net/fetcheddata.json"))
	
	local liness = fz:read("*a")
	
	local tableDiss = {}
	
	if(liness ~= "") then
	local encdso = liness
	
	
	tableDiss = trydecodeJSOn(encdso, fz ,"net/fetcheddata.json")
	
	
	fz:close()
	
	
	end
	
	
	
	
	

	
	return tableDiss
	
	
end



function readDatapackStore()
	
	
	
	local fz = assert(io.open("net/modpacklist.json"))
	
	local liness = fz:read("*a")
	
	local tableDiss = {}
	
	if(liness ~= "") then
	local encdso = liness
	
	
	tableDiss = trydecodeJSOn(encdso, fz ,"net/modpacklist.json")
	
	
	fz:close()
	
	
	end
	
	
	
	
	

	
	return tableDiss
	
	
end



function readCurrentServerModVersion()
	

	if( file_exists("net/currentModVersion.json")) then
	local f = assert(io.open("net/currentModVersion.json"))
	
	lines = f:read("*a")
	local tableDis = {}
	
	if(lines ~= "") then
	
	local encdo = lines
	
	tableDis = trydecodeJSOn(encdo, f ,"net/currentModVersion.json")
	
	end
	
	
	
	
	
	
	
	

	f:close()
	os.remove("net/currentModVersion.json")
	return tableDis
	else
	
	local tableDis = {}
	tableDis.channel = currentbranch
	tableDis.version = "unknown"
	tableDis.changelog = "Unable to get the server version, try again."
	
	return tableDis

	end
	
end


function readDatapackDownloaded()
	

	
	local f = assert(io.open("net/downloadedDatapack.json"))
	
	lines = f:read("*a")
	local tableDis = {}
	
	if(lines ~= "") then
	local encdo = lines
	
	tableDis =trydecodeJSOn(encdo, f ,"net/downloadedDatapack.json")
	
	end
	
	
	
	
	
	
	
	

	f:close()
	return tableDis
	
	
end


function isDatapackDownloaded(tag)
	
	local result = false
	
	if( arrayDatapack[tag] ~= nil) then result = true end
	
	
	return result
	
end

function isMissionDownloaded(tag)
	
	local result = false

	for i=1,#arrayMymissions do
	
		if(arrayMymissions[i] == tag) then
		result = true
		end
		
		
	
	end
	
	return result
	
end


function CurrentDownloadedVersion(tag)
	
	local result = 0

	if( arrayDatapack[tag] ~= nil and arrayDatapack[tag].metadata ~= nil) then result = arrayDatapack[tag].metadata.version end
	
	return result
	
end


function LocalNeedUpdate(tag)
	
	local localvesrion = 0
	
	local serverversion = 0
	
	localvesrion = arrayDatapack[tag].metadata.version
	
	for i=1,#arrayDatapack3 do
	
		if(arrayDatapack3[i].tag == tag) then
		serverversion = arrayDatapack3[i].version
		
		end
		
		
	
	end
	
	
	
	
	
	local result = (localvesrion ~= serverversion)
	
	
	
	
	return result
	
end



function GetDatapackOnlineVersion(tag)
	
	local result = 0

	for i=1,#arrayDatapack3 do
	
		if(arrayDatapack3[i].tag == tag) then
			result = arrayDatapack3[i].version
		
		end
		
		
	
	end
	
	return result
	
end

--User
function sendMessage(usertag,content)
	
	
		local action = {}
		action.action = "sendMessage"
		action.parameter = usertag.."||".."\""..content.."\""
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			if(#OnlineConversation.conversation > 0) then
			
				local index = 0
				local count = 1
				
				for y=1,#OnlineConversation.conversation do
					if(OnlineConversation.conversation[y].name == usertag and #OnlineConversation.conversation[y].message > 0) then
						index = y
						count = #OnlineConversation.conversation[y].message
					end
				end
				
				if(index ~= 0) then
					
					count = count+1
					
					local mes = {}
					
					mes.tag = "online_"..usertag.."_"..count.."_r"
					mes.text = content
					mes.sender = 1
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					table.insert(OnlineConversation.conversation[index],mes)
					
					setScore(mes.tag,"unlocked",1)
					
					
				
				
				else
					
					local newconversation = {}
					newconversation.tag = "online_"..usertag
					newconversation.name = usertag
					newconversation.unlock = true
					
					newconversation.message = {}
					
					local mes = {}
					mes.tag = "online_"..usertag.."_0000".."_r"
					mes.text = content
					mes.sender = 1
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					
					table.insert(newconversation.message,mes)
					
					table.insert(OnlineConversation.conversation,newconversation)
					
					setScore(newconversation.tag,"unlocked",1)
					
					setScore(mes.tag,"unlocked",1)
					
				end
			
			
			else
				
					local newconversation = {}
					newconversation.tag = "online_"..CurrentOnlineMessage[i].Sender
					newconversation.name = CurrentOnlineMessage[i].Sender
					newconversation.unlock = true
					
					newconversation.message = {}
					
					local mes = {}
					mes.tag = "online_"..CurrentOnlineMessage[i].Sender.."_1"
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
			
		end)
	
	
end

function sendMessageFriend(usertag,content)
	
	
		local action = {}
		action.action = "sendMessageFriend"
		action.parameter = usertag.."||".."\""..content.."\""
		debugPrint(2,action.parameter)
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			
			
				local index = 0
				local count = 1
				if(#OnlineConversation.conversation > 0) then
				for y=1,#OnlineConversation.conversation do
					if(OnlineConversation.conversation[y].name == usertag and #OnlineConversation.conversation[y].message > 0) then
						index = y
						count = #OnlineConversation.conversation[y].message
					end
				end
				end
				
				if(index ~= 0) then
					
					
					debugPrint(2,"send1")
					count = count+1
					local mes = {}
						
					mes.tag = "online_"..usertag.."_"..count.."_r"
					mes.text = content
					mes.sender = 1
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					table.insert(OnlineConversation.conversation[index].message,mes)
					
					setScore(mes.tag,"unlocked",1)
					
					
				
				
				else
					debugPrint(2,"send2")
					local newconversation = {}
					newconversation.tag = "online_"..usertag.."_0000".."_r"
					newconversation.name = usertag
					newconversation.unlock = true
					
					newconversation.message = {}
					
					local mes = {}
					mes.tag = "online_"..usertag.."_"..0000
					mes.text = content
					mes.sender = 1
					mes.unlock = true
					mes.readed = false
					mes.choices = {}
					
					table.insert(newconversation.message,mes)
					
					table.insert(OnlineConversation.conversation,newconversation)
					
					setScore(newconversation.tag,"unlocked",1)
					
					setScore(mes.tag,"unlocked",1)
					
				end
			
			
			
			
		end)
	
	
end

function sendMessageInstance(content)
	
	
		local action = {}
		action.action = "sendMessageInstance"
		action.parameter = "\""..content.."\""
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			
			
		end)
	
	
end

function MessageSenderController()
	onlineMessagePopup = false
local typeofreceiver = 0 
	--0 friend
	--1 instance user
	--2 intance
	
	


	for i=1,#ActualPlayerMultiData.friends do
		
		if(ActualPlayerMultiData.friends[i] == onlineReceiver) then
		typeofreceiver = 0
		end
		
	end


	for i=1,#ActualPlayerMultiData.instance_players do
		
		if(ActualPlayerMultiData.instance_players[i] == onlineReceiver) then
		typeofreceiver = 1
		end
		
	end

	
	if("Instance" == onlineReceiver) then
	typeofreceiver = 2
	end
	


	if(typeofreceiver == 0) then
		
		 sendMessageFriend(onlineReceiver,onlineMessageContent)

	elseif (typeofreceiver == 1) then

		sendMessage(onlineReceiver,onlineMessageContent)

		
	elseif (typeofreceiver == 2) then

		sendMessageInstance(onlineMessageContent)

	end
	
	
	 UIPopupsManager.ClosePopup()
	local actionlist = {}
				
				
		local action = {}
		
		
		
		
		action = {}
		
		action.name = "wait_second"
		action.value = 2
		
		table.insert(actionlist,action)
		
		action = {}
		
		action.name = "phone_notification"
		action.title = "CyberScript Instance"
		action.duration = 4
		action.desc = "Instance Message"
		action.conversation = "online"
		
		
		table.insert(actionlist,action)
		
		onlineMessagePopupFirstUse = true
		runActionList(actionlist, "send_message_"..onlineReceiver, "interact",false,"nothing",true)
	
end

function sendActionstoUser(usertag,actionlist)
	
	
		local action = {}
		action.action = "sendActionstoUser"
		action.parameter = usertag.."||"..JSON:encode(actionlist)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end


function AddFriend()
		local action = {}
		
		action.action = "AddFriend"
		
		
		
		
		action.parameter = selectedUser.pseudo
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function BlockFriend()
		local action = {}
		
		action.action = "BlockFriend"
		
		
		
		
		action.parameter = selectedUser.pseudo
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function DeleteFriend()
		local action = {}
		
		action.action = "DeleteFriend"
		
		
		
		
		action.parameter = selectedUser.pseudo
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function UnblockFriend()
		local action = {}
		
		action.action = "UnblockFriend"
		
		
		
		
		action.parameter = selectedUser.pseudo
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end






--Guild
function createGuild()
	local obj = {}
		obj.Title = CreateGuild.Title
		obj.FactionTag = CreateGuild.FactionTag
	
		local action = {}
		action.action = "createGuild"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function updateGuild()
		local obj = UpdateGuild
		
		local action = {}
		action.action = "updateGuild"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function joinGuild(usertag, instanceid)
		local obj = {}
		obj.user = usertag
		obj.guildId = instanceid
	
		local action = {}
		action.action = "joinGuild"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function leaveGuild(usertag)
	
	
		local action = {}
		action.action = "leaveGuild"
		action.parameter = ""
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function acceptGuild(usertag)
	
	
		local action = {}
		action.action = "leaveGuild"
		action.parameter = usertag
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function refuseGuild(usertag)
	
	
		local action = {}
		action.action = "refuseGuild"
		action.parameter = usertag
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function removeGuild(usertag)
	
	
		local action = {}
		action.action = "removeGuild"
		action.parameter = usertag
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end




--Instance

function setInstanceScore(usertag,score,value)
		
		local obj = {}
		obj.score = score
		obj.value = value
		obj.instance = CurrentInstance.Id
		
		local action = {}
		action.action = "setInstanceScore"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function operateInstanceScore(usertag,score,value)
	
		local obj = {}
		obj.score = score
		obj.value = value
		obj.instance = CurrentInstance.Id
	
		local action = {}
		action.action = "operateInstanceScore"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function deleteInstanceScore(usertag,score)
	
		local obj = {}
		obj.score = score
		obj.instance = CurrentInstance.Id
	
		local action = {}
		action.action = "deleteInstanceScore"
		action.parameter = JSON:encode(obj)
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end



function GetInstances()
	
	
		local action = {}
		
		action.action = "GetInstances"
		action.parameter = ""
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayInstanceList = {}
			arrayInstanceList =  readFile("net/currentInstance.json",false)
			debugPrint(2,"OK")
		
		end)
	
	
end



function connectInstance(instanceid,password)
		local action = {}
		debugPrint(2,instanceid.."||"..password)
		action.action = "connectInstance"
		action.parameter = instanceid.."||"..password
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
		
		end)
	
	
end

function createInstance()
		local action = {}
		debugPrint(2,selectedInstance.."||"..selectedInstancePassword)
		action.action = "createInstance"
		action.parameter = "&privacy="..CreateInstance.privacy.."&isreadonly="..tostring(CreateInstance.isreadonly).."&nsfw="..tostring(CreateInstance.nsfw).."&password="..CreateInstance.password.."&Title="..CreateInstance.title
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			onlineInstanceCreation = false
			CreateInstance = {}
		end)
	
	
end

function updateInstance()
		local action = {}
		
		action.action = "updateInstance"
		
		UpdateInstance.Owner = myTag
		
		
		action.parameter = JSON:encode(UpdateInstance)
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			onlineInstanceUpdate = false
			UpdateInstance = {}
		end)
	
	
end

function createInstancePlace()
		local action = {}
		
		action.action = "createInstancePlace"
		action.parameter = JSON:encode(CreateInstancePlace)
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			onlineInstanceCreation = false
			CreateInstancePlace = {}
		end)
	
	
end



function banUserFromInstance()
		local action = {}
		
		action.action = "banUserFromInstance"
		
		local obj = {}
		
		obj.user = selectedUser.pseudo
		obj.instance = CurrentInstance.Id
		
	
		action.parameter = JSON:encode(obj)
		
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function unBanUserFromInstance()
		local action = {}
		
		action.action = "unBanUserFromInstance"
		
		local obj = {}
		
		obj.user = selectedUser.pseudo
		obj.instance = CurrentInstance.Id
		
	
		action.parameter = JSON:encode(obj)
		
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end

function kickUserFromInstance()
		local action = {}
		
		action.action = "kickUserFromInstance"
		
		local obj = {}
		
		obj.user = selectedUser.pseudo
		obj.instance = CurrentInstance.Id
		
	
		action.parameter = JSON:encode(obj)
		
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			
		end)
	
	
end



function UpdateItem(tag, x, y, z, roll, pitch ,yaw )
		local action = {}
		
		action.action = "UpdateItem"
		
		local objt = {}
		objt.tag = tag
		objt.x = x
		objt.y = y
		objt.z = z
		objt.roll = roll
		objt.pitch = pitch
		objt.yaw = yaw
		action.parameter = JSON:encode(objt)
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			selectedItemMulti = nil
			if(currentMultiHouse ~= nil) then
			despawnItemFromMultiHouse()
			Cron.After(0.5, function()
			--spawnItemFromHouseMultiTag()
			end)
			end
		end)
	
	
end

function SetItem(tag, x, y, z, roll, pitch ,yaw )
		local action = {}
		
		action.action = "SetItem"
		local objt = {}
		objt.tag = tag
		objt.housetag = ActualPlayerMultiData.currentPlaces[1].tag
		objt.x = x
		objt.y = y
		objt.z = z
		objt.roll = roll
		objt.pitch = pitch
		objt.yaw = yaw
		action.parameter = JSON:encode(objt)
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			selectedItemMulti = nil
			if(currentMultiHouse ~= nil) then
			despawnItemFromMultiHouse()
			Cron.After(0.5, function()
			--spawnItemFromHouseMultiTag()
			end)
			end
			
		end)
	
	
end

function SetItemList(itemlist )
		local action = {}
		
		action.action = "SetItemList"
		action.parameter = JSON:encode(itemlist)
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			selectedItemMulti = nil
			if(currentMultiHouse ~= nil) then
			despawnItemFromMultiHouse()
				Cron.After(0.5, function()
			--spawnItemFromHouseMultiTag()
			end)
			end
			
		end)
	
	
end

function DeleteAllItem(houseTag )
	if(#ActualPlayerMultiData.currentPlaces > 0) then
		local action = {}
		
		action.action = "DeleteAllItem"
		action.parameter = ActualPlayerMultiData.currentPlaces[1].tag
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			selectedItemMulti = nil
			if(currentMultiHouse ~= nil) then
			despawnItemFromMultiHouse()
				Cron.After(0.5, function()
			----spawnItemFromHouseMultiTag()
			end)
			end
			
		end)
	
	end
end

function DeleteItem(tag )
		local action = {}
		
		action.action = "DeleteItem"
		
		action.parameter = tag
		debugPrint(2,dump(action))
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			selectedItemMulti = nil
			if(currentMultiHouse ~= nil) then
			despawnItemFromMultiHouse()
				Cron.After(0.5, function()
			--spawnItemFromHouseMultiTag()
			end)
			end
			
		end)
	
	
end


function deleteInstancePlace()
		local action = {}
		
		action.action = "deleteInstancePlace"
		action.parameter = ActualPlayerMultiData.currentPlaces[1].tag
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			debugPrint(2,"OK")
			onlineInstanceCreation = false
			CreateInstancePlace = {}
		end)
	
	
end

--MP


function connectMultiplayer(instanceid, password)
	
	lastFriendPos = {}
			
	connectInstance(instanceid, password)
	
	MultiplayerOn = true
		
		
	OnlineConversation = nil
	
	
	
	OnlineConversation = {}
	OnlineConversation.tag = "online_conversation"
	OnlineConversation.unlock = true
	OnlineConversation.speaker = "Online"
	OnlineConversation.conversation = {}
	
	setScore(OnlineConversation.tag,"unlocked",1)
	Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
	
	friendIsSpaned = false
	
end


function editServerScoreUser(score, value)
	
	
		local action = {}
		action.action = "editServerScoreUser"
		action.parameter = score.."||"..value
		
		WriteAction(action)
		
			waitforactionfinished(0.1,false, function()
			
			debugPrint(2,"OK")
			
		end)
	
	
end


function updatePlayerSkin()
	
	local action = {}
		
	action.action = "updatePlayerSkin"
	action.parameter = currentSave.myAvatar
	
	WriteAction(action)
	
	
	
end



function HelpFaction()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "HelpFaction"
			action.parameter = ""
			
			WriteAction(action)
			
			
		end
	
end


function GetRole()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "GetRole"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfailorsuccess(0.1,false, function()
			tokenIsValid = true
			
			currentRole =  readUserInput()
			
		
		end, function()
			
			tokenIsValid = false
		
			end)
		
			
		end
	
end


function GetBranch()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "GetBranch"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			currentbranch =  readUserInput()
		
		end)
			
		end
	
end

function GetItemCat()
	
		
			local action = {}
			
			action.action = "GetItemCat"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			possiblecategory = {}
			
			
			local tables = json.decode(readUserInput())
			
			for i=1,#tables do
			table.insert(possiblecategory,tables[i].parent)
			
			end
			
		
		end)
			
		
	
end


function SaveBranch()
	
		if(tokenIsValid == true) then
		
		
		
			local action = {}
			
			action.action = "SaveBranch"
			action.parameter = currentbranch
			
			
			WriteAction(action)
			CurrentServerModVersion.version = questMod.version
			
			Cron.After(1, function()
			
			 GetModVersion()
			 
			 
				Cron.After(1, function()
				
				 GetModpackList()
				 
					Cron.After(1, function()
			
						GetBranch()
				
						
					end)
			
				end)
			
			end)
			
			
			
		end
	
end

function GetPossibleBranch()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "GetPossibleBranch"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			possiblebranch =  json.decode(readUserInput())
		
		end)
			
		end
	
end


function GetCorpoNews()
	
		
			local action = {}
			
			action.action = "GetCorpoNews"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			corpoNews =  json.decode(readUserInput())
			FillCorpo()
		
		end)
			
		
	
end


function GetFaction()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "GetFaction"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			currentFaction =  readUserInput()
			local file = assert(io.open("net/multi/player/faction.txt", "w"))
			
			file:write(currentFaction)
			file:close()
		
		end)
			
		end
	
end

function GetFactionRank()
	
		if(tokenIsValid == true) then
			local action = {}
			
			action.action = "GetFactionRank"
			action.parameter = ""
			
			WriteAction(action)
			
			waitforactionfinished(0.1,false, function()
			
			currentFactionRank =  readUserInput()
			local file = assert(io.open("net/multi/player/factionrank.txt", "w"))
			
			file:write(currentFactionRank)
			file:close()
		
		end)
			
		end
	
end


--Scores

function GetScores()
	
	
		local action = {}
		
		action.action = "GetScores"
		action.parameter = ""
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMarket = {}
			arrayMarket =  readFile("net/currentMarket.json",false)
			debugPrint(2,"OK")
		
		end)
	
	
end

function BuyScore(tag)
	
	
		local action = {}
		
		action.action = "BuyScore"
		
		action.parameter = tag
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMarket = {}
			arrayMarket =  readFile("net/currentMarket.json",false)
			
		
		end)
	
	
end

function SellScore(tag)
	
	
		local action = {}
		
		action.action = "SellScore"
		action.parameter = tag
		
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			
			arrayMarket = {}
			arrayMarket =  readFile("net/currentMarket.json",false)
			
			
		
		end)
	
	
end


function IsScoreBuyed(tag)
	
	local result = false

	for i=1,#arrayMyDatapack do
	
		if(arrayMyDatapack[i].tag == tag) then
		result = true
		end
		
		
	
	end
	
	return result
	
end

function isScore(tag)
	
	local result = false

	for i=1,#arrayMyDatapack do
	
		if(arrayMyDatapack[i].tag == tag) then
		result = true
		end
		
		
	
	end
	
	return result
	
end




--Items

function GetItems()
	
	
		local action = {}
		
		action.action = "GetItems"
		action.parameter = ""
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			a = {}
			arrayMarketItem =  readFile("net/currentItemsMarket.json",false)
			debugPrint(2,"OK")
		
		end)
	
	
end

function BuyItems(tag)
	
	
		local action = {}
		
		action.action = "BuyItems"
		action.parameter = tag
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMarketItem = {}
			arrayMarketItem =  readFile("net/currentItemsMarket.json",false)
		
			
		end)
	
	
end


function BuyItemsCart(tagtable)
	
		local taglist = ""
		
		for i=1,#tagtable do
		
		taglist = taglist..tagtable[i]..";"
		
		end
		
		local action = {}
		
		action.action = "BuyItemsCart"
		action.parameter = taglist
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			
			arrayMarketItem = {}
			arrayMarketItem =  readFile("net/currentItemsMarket.json",false)
		
			
		end)
	
	
end

function SellItems(tag)
	
		local action = {}
		
		action.action = "SellItems"
		action.parameter = tag
		
		WriteAction(action)
		
		waitforactionfinished(0.1,false, function()
			local score = getScore(tag,"Quantity")
			
			if(score == nil) then
				score = 0
				setScore(tag,"Score",score)
			end
			score = score - 1
			setScore(tag,"Quantity",score)
			
			arrayMarketItem = {}
			arrayMarketItem =  readFile("net/currentItemsMarket.json",false)
			
			
		
		end)
	
	
end




--Misc

function readUserInput()
	local encdo = ""

	
local f = io.open("net/userInput.txt")
	
	lines = f:read("*a")
	
	
	if(lines ~= "") then
		encdo = lines
	
	
	
	end
	
	debugPrint(2,encdo)
	
	
	
	
	
	

	f:close()
	--os.remove("net/userInput.txt")
	return encdo
	
	
end


function readFile(filepath, todelete)
	local tableDis = {}
	if(file_exists(filepath)) then

	
		local f = assert(io.open(filepath))
		
		lines = f:read("*a")
		
		
		if(lines ~= "") then
		local encdo = lines
		
		tableDis = trydecodeJSOn(encdo, f, filepath)
		
		end
		
		
		
		
		
		
		
		

		f:close()
		
		if(todelete)then
			os.remove(filepath)
		end
	end
	return tableDis
	
	
end


function waitforactionfinished(timer,bool,functionprint)
	
	waiting = true
	Cron.After(timer, function()
		if (file_exists("successaction.txt")) then
			
			finishwaiting(bool)
			waiting = false
			os.remove("successaction.txt")
			functionprint()
			debugPrint(2,"OK")
		else
			
		
			waitforactionfinished(timer,bool,functionprint)
		end
		end)
	
end

function waitforactionfailorsuccess(timer,bool,functionprint, failfunctionprint)
	
	waiting = true
	Cron.After(timer, function()
		if (file_exists("successaction.txt")) then
			
			finishwaiting(bool)
			os.remove("successaction.txt")
				functionprint()
				debugPrint(2,"OK")
				waiting = false
		else
			if (file_exists("failaction.txt")) then
				
				finishwaiting(bool)
				os.remove("failaction.txt")
				failfunctionprint()
				debugPrint(2,"NOK")
				waiting = false
				
			else
				
				
				waitforactionfailorsuccess(timer,bool,functionprint,failfunctionprint)
			end
		
		end
		end)
	
end

function WriteAction(action)
	


			
		
		local file = assert(io.open("net/action.json", "w"))
		local stringg = JSON:encode_pretty(action)
	
		file:write(stringg)
		file:close()
		
			
		
		
		
	
	
end
