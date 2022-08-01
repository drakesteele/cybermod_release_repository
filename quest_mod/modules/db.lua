debugPrint(3,"CyberScript: db module loaded")
questMod.module = questMod.module +1


function Migrate()
	local queries = {}
	debugPrint(1,"Starting Migration")
	if( file_exists("json/db/migration.json") ) then
		
		debugPrint(1,"migration file is founded")
		local f = io.open("json/db/migration.json")
		lines = f:read("*a")
		if(lines ~= "") then
		
			debugPrint(1,json.decode(lines))
			queries = json.decode(lines)
			
			
			else
			
			debugPrint(1,"migration file is empty")
		end
		f:close()
		
		
	end 
	if(#queries > 0) then
	for i=1,#queries do
		debugPrint(1,queries[i])
		res = assert (db:execute(queries[i]))
		readDBOutput(res)
	end
	debugPrint(1,"Migration finished")
	end
end



function initAffinity()
	local obj = {}
	
	return obj
end

function initCharacters()
	local obj = {}
	
	return obj
end

function initFactionScore()
	local obj = {}
	
	return obj
end

function initHouseStatut()
	local obj = {}
	
	return obj
end

function initHousing()
	local obj = {}
	
	return obj
end

function initItems()
	local obj = {}
	
	return obj
end

function initPlayerData()
	local obj = {}
	obj.Id = {}
	obj.LastEscortQuest = {}
	obj.LastKillQuest = {}
	obj.LastExploreQuest = {}
	obj.CurrentQuest = {}
	obj.MappinID = {}
	
	obj.SixthStreet_score = {}
	obj.valentinos_score = {}
	obj.tygerClaws_score = {}
	obj.maelstrom_score = {}
	obj.voodooBoys_score = {}
	obj.animals_score = {}
	obj.mox_score = {}
	obj.ncpd_score = {}
	obj.scavenger_score = {}
	obj.wraith_score = {}
	obj.aldecados_score = {}
	return obj
end

function initPlayerItems()
	local obj = {}
	
	return obj
end

function initQuestStatut()
	
	local obj = {}
	
	return obj
	
end

function initSettingData()
	local obj = {}
	obj.Id = 1
	obj.AmbushEnabled = 1
	obj.AmbushMax = 30000
	obj.AmbushMin = 15000
	obj.GangWarsEnabled = 1
	obj.EscortRangeDetectionArea = 30
	obj.DefaultRangeDetectionArea = 10
	obj.FixerRangeDetectionArea = 5
	obj.ModVersion = 0
	obj.FirstLaunch = 0
	return obj
end

function initUserSetting()
	local obj = {}
	return obj
	
end

function loadUserSetting(arrayUseqrSetting)
	local stat = string.format("SELECT * FROM UserSetting")

	for row in db:nrows(stat) do
		local querys = {}
		
		arrayUseqrSetting[row.Tag] = row.Value
		
	
		
		
		
	end
	return arrayUseqrSetting
	
	
end

function loadAffinity(arrayAffinity)
	local stat = string.format("SELECT * FROM Affinity JOIN Characters ON ID = NpcId")
	
	for row in db:nrows(stat) do
		
		local affinity = {}
		affinity.NpcId= row.NpcId
		affinity.Score= row.Score
		affinity.Names= row.Names
		--debugPrint(1,affinity.NpcId)
		--debugPrint(1,affinity.Score)
		--debugPrint(1,affinity.Names)
		
		table.insert(arrayAffinity, affinity)
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	--debugPrint(1,"load affinity")
	
end

function loadCharacters(arrayPnjDb)
	local stat = string.format("SELECT * FROM Characters")
	
	for row in db:nrows(stat) do
		local quest = {}
		quest.ID= row.ID
		quest.TweakIDs= row.TweakIDs
		quest.Names= row.Names
		table.insert(arrayPnjDb, quest)
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	
end

function loadFactionScore(arrayFactionScore)
	local stat = string.format("SELECT * FROM FactionScore")
	
	for row in db:nrows(stat) do
		
		local faction = {}
		faction.Tag= row.Tag
		faction.Score= row.Score
		
		table.insert(arrayFactionScore, faction)
		
		
		
	end
	
end

function loadQuestStatut(arrayQuestStatut)
	local stat = string.format("SELECT * FROM QuestStatut")

	for row in db:nrows(stat) do
		local query = {}
		query.Tag= row.Tag
		query.Statut= row.Statut
		query.Quantity = row.Quantity
		
		table.insert(arrayQuestStatut, query)
		
		
		
	end
	
end

function loadHouseStatut(arrayHouseStatut)
	local stat = string.format("SELECT * FROM HouseStatut")
	
	for row in db:nrows(stat) do
		
		local houseShop = {}
		houseShop.Tag= row.Tag
		houseShop.Statut= row.Statut
		houseShop.Score= row.Score
		
		table.insert(arrayHouseStatut, houseShop)
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	
end

function loadFriend(tag)
	local stat = string.format("SELECT * FROM Multiplayer WHERE tag='"..tag.."'")
	
	local player = nil
	for row in db:nrows(stat) do
		
		if(row ~= nil) then
		player = {}
		player.tag= row.tag
		player.x= row.x
		player.y= row.y
		player.z= row.z
		player.roll= row.roll
		player.pitch= row.pitch
		player.yaw= row.yaw
		player.avatar= row.avatar
		
		
		end
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	
	return player
	
end

function SavePlayerPos(item)
	local stat = string.format("SELECT COUNT(*) AS `rowmax` FROM Multiplayer WHERE tag='player'")
	--debugPrint(1,stat)
	for row in db:nrows(stat) do
		
		count = row.rowmax
		if count == nil then
			count=0
		end
		
	end
	
	
	
	if(count > 0) then
		stat = string.format([[UPDATE Multiplayer SET x="%s",y="%s",z="%s",yaw="%s",pitch="%s",roll="%s",avatar="%s",friend="%s" WHERE tag='player']],item.x,item.y,item.z,item.yaw,item.pitch,item.roll,item.avatar,item.friend)
		--debugPrint(1,stat)
		res = assert (db:execute(stat))
		
		else
		
		stat = string.format([[INSERT INTO Multiplayer VALUES ("player","%s","%s","%s","%s","%s","%s","%s","%s",1,1,"test")]],item.x,item.y,item.z,item.yaw,item.pitch,item.roll,item.avatar,item.friend)
		--debugPrint(1,stat)
		res = assert (db:execute(stat))
		
	end
	
	if(res ==5) then
	readDBOutput(res)
	end
	
	
end

function loadPlayerItems(arrayPlayerItems)
	local stat = string.format("SELECT * FROM PlayerHouseItems")
	
	for row in db:nrows(stat) do
		
		local houseShop = {}
		
		houseShop.Tag= row.Tag
		houseShop.Title= row.Title
		houseShop.Path= row.Path
		houseShop.Quantity= row.Quantity
		
		
		table.insert(arrayPlayerItems, houseShop)
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	
end

function loadItems(arrayItems)
	local stat = string.format("SELECT * FROM Items")
	
	for row in db:nrows(stat) do
		local item = {}
		item.Id= row.Id
		item.TweakId= row.TweakId
		item.Name= row.Name
		table.insert(arrayItems, item)
		
		-- ----debugPrint(1,arrayQuest[row.Id].Id) 
		
	end
	
end

function loadPlayerData(arrayPlayerData)
	local stat = string.format("SELECT * FROM Player WHERE Id = 1")
	
	for row in db:nrows(stat) do
		arrayPlayerData.Id = row.Id
		arrayPlayerData.CurrentQuest = row.CurrentQuest
		arrayPlayerData.CurrentQuestStatut = row.CurrentQuestStatut
	end
	--debugPrint(1,arrayPlayerData.CurrentQuest)
	
end

function updatePlayerData(arrayPlayerDatas)
	
	res = assert (db:execute(string.format([[
		UPDATE Player
		SET 
		CurrentQuest="%s",
		CurrentQuestStatut="%s"
		WHERE Id=1
	]], 
	
	arrayPlayerDatas.CurrentQuest,
	arrayPlayerDatas.CurrentQuestStatut
	)
	))
	
	debugPrint(1,"UpdateDATAPlayer")
	
	readDBOutput(res)
	return res
	
end

function loadSettingData(arraySettingDatas)
	local stat = string.format("SELECT * FROM Setting WHERE Id = 1")
	
	for row in db:nrows(stat) do
		arraySettingDatas.Id = row.Id
		arraySettingDatas.AmbushEnabled = row.AmbushEnabled
		arraySettingDatas.AmbushMax = row.AmbushMax
		arraySettingDatas.AmbushMin = row.AmbushMin
		arraySettingDatas.GangWarsEnabled = row.GangWarsEnabled
		arraySettingDatas.EscortRangeDetectionArea = row.EscortRangeDetectionArea
		arraySettingDatas.DefaultRangeDetectionArea = row.DefaultRangeDetectionArea
		arraySettingDatas.FixerRangeDetectionArea = row.FixerRangeDetectionArea
		arraySettingDatas.ModVersion = row.ModVersion
		arraySettingDatas.FirstLaunch = row.FirstLaunch
	end
	
	
end

function updateSettingData(arraySettingDatas)
	
	res = assert (db:execute(string.format([[
		UPDATE Setting
		SET 
		AmbushEnabled="%s",
		AmbushMax="%s",
		AmbushMin="%s",
		GangWarsEnabled="%s",
		EscortRangeDetectionArea="%s",
		DefaultRangeDetectionArea="%s",
		FixerRangeDetectionArea="%s",
		ModVersion = "%s",
		FirstLaunch = "%s"
		WHERE Id=1
	]], 
	arraySettingDatas.AmbushEnabled,
	arraySettingDatas.AmbushMax,
	arraySettingDatas.AmbushMin,
	arraySettingDatas.GangWarsEnabled,
	arraySettingDatas.EscortRangeDetectionArea,
	
	arraySettingDatas.DefaultRangeDetectionArea,
	arraySettingDatas.FixerRangeDetectionArea,
	arraySettingDatas.ModVersion,
	arraySettingDatas.FirstLaunch
	
	)
	))
	--debugPrint(1,res)
	--debugPrint(1,"Update Setting Data")
	
	readDBOutput(res)
	arraySettingData = initSettingData()
	loadSettingData(arraySettingData)
	return res
	
end

function readDBOutput(res)
	
	if(res == 0) then
		
		debugPrint(1,"DB saved")
		
		else
		debugPrint(1,"Error in DB : "..res)
		error("db error code " .. res)
		error (db:errmsg())
		db:interrupt()
	end
	
	
end

function resetDB(arrayPlayerDatas)
	
	query = "DELETE FROM Affinity;"
	res = assert (db:execute(query))
	--debugPrint(1,"Delete Affinity"..res)
	
	query = "DELETE FROM FactionScore;"
	res = assert (db:execute(query))
	--debugPrint(1,"Delete FactionScore"..res)
	
	query = "DELETE FROM QuestStatut;"
	res = assert (db:execute(query))
	--debugPrint(1,"Delete QuestStatut"..res)
	
	query = "DELETE FROM HouseStatut;"
	res = assert (db:execute(query))
	--debugPrint(1,"Delete HouseStatut"..res)
	
	arrayPlayerDatas.CurrentQuest = nil
	
	
	updatePlayerData(arrayPlayerDatas)
	
	reloadDB()
	
	debugPrint(1,"Database have been reset")
	
end

function reloadDB()
	
	--arrayQuest = initQuest()
	
	arrayPlayerData = initPlayerData()
	arrayPnjDb = initCharacters()
	arrayItems = initItems()
	arraySettingData = initSettingData()
	
	arrayAffinity = initAffinity()
	arrayQuestStatut = initQuestStatut()
	arrayFactionScore = initFactionScore()
	arrayUserSetting = initUserSetting()
	
	arrayHouseStatut = initHouseStatut()
	
	arrayPlayerItems = initPlayerItems()
	
	loadAffinity(arrayAffinity)
	loadFactionScore(arrayFactionScore)
	loadCharacters(arrayPnjDb)
	
	loadItems(arrayItems)
	loadPlayerData(arrayPlayerData)
	loadQuestStatut(arrayQuestStatut)
	loadSettingData(arraySettingData)
	--arrayUserSetting = loadUserSetting(arrayUserSetting)
	
	loadHouseStatut(arrayHouseStatut)
	--loadHousing(arrayHousing)
	loadPlayerItems(arrayPlayerItems)
	
	arrayPhoneNPC = {}
	
	print("reloadbd")
	
	nexttimer_ambush =  math.random(arraySettingData.AmbushMin,arraySettingData.AmbushMax)
	
	
end