--[[
	
	
	
	_____      _               _____           _       _   
	/ ____|    | |             / ____|         (_)     | |  
	| |    _   _| |__   ___ _ _| (___   ___ _ __ _ _ __ | |_ 
	| |   | | | | '_ \ / _ \ '__\___ \ / __| '__| | '_ \| __|
	| |___| |_| | |_) |  __/ |  ____) | (__| |  | | |_) | |_ 
	\_____\__, |_.__/ \___|_| |_____/ \___|_|  |_| .__/ \__|
	__/ |                                 | |        
	|___/                                  |_|        
	
	
	
	
	-- ------------------------------------------------------------------
	-- -------------------------------How It Works-------------------------------
	-- ------------------------------------------------------------------
	CyberScript By RedRockStudio
	
	
	How the mod works :
	
	An player import scripts at JSON format. At mod init, we read theses Json and turn them into lua tables. 
	
	an script ususally contains 
	-Trigger and trigger requirement : when and how the script should be performed
	-Actions list : what the script do.
	
	at every OnUpdate, the mod will check the available script that can be perform by checking trigger and requirement
	
	when trigger and requirement are meet, the Script Execution Engine (SEE) will store the action list in an thread and will perform it at next OnUpdate.
	
	At every On refresh, the mod will call refresh() function that contains 2 functions stored in scripting.lua :
	CompileCachedThread()
	ScriptExecutionEngine()
	
	theses functions manage the Script Execution Engine (SEE) that will actions list from scripting.lua.
	
	Depending of the executed action, the thread can have several sub thread or make an new other thread.
	
]]--

-- -------------------------------------------------------------------------------------
-----------------------------Init and Imperative functions------------------------------
-- -------------------------------------------------------------------------------------

print("CyberScript Initialisation...")

logTable = {}
logLevel = 1
logFilter = ""
debugLog = false


function file_exists(filename)
	local f = io.open(filename,"r")
	if f then
		io.close(f)
		return true
	end
	return false
end


function logme(level,msg) 
	
	local obj = {}
	obj.date = os.date('*t')
	obj.datestring = "["..obj.date.year.."-"..obj.date.month.."-"..obj.date.day.."  "..obj.date.hour.." : "..obj.date.min .." : "..obj.date.sec.."]"
	obj.msg = tostring(msg)
	obj.level = level
	
	if(level == 1) then
	print(obj.msg)
	
	
	end

if logrecordlevel == nil or (logrecordlevel ~= nil and level <= logrecordlevel )then
	table.insert(logTable,obj)
	spdlog.error(obj.msg)
	end 
	end


logme(2,"Start Mod")
function debugPrint(level,value)
	 logme(level,value) 
	
end
function ModInitialisation()
	
	questMod = { 
		description = "CyberScript",
		version = "0.16000069",
		channel = "stable",
		changelog =""
		
	}
	
	
	
	--version of compiled cache
	cacheVersion = 2
	
	
	
	
	currentSave = {}
	currentSave.Score = {}
	currentSave.Score["Affinity"] = {}
	currentSave.Variable = {}
	currentSave.arrayPlayerData = {}
	currentSave.arrayAffinity = {}
	currentSave.arrayQuestStatut = {}
	currentSave.arrayFactionScore = {}
	currentSave.arrayUserSetting = {}
	currentSave.arrayHouseStatut = {}
	currentSave.arrayHousing = {}
	currentSave.arrayPlayerItems = {}
	currentSave.savedStates = {}
	currentSave.arrayFactionDistrict = nil
	currentSave.arrayFactionRelation = nil
	currentSave.garage = {}
	currentSave.arrayHUD = {}
	
	if file_exists("quest_mod.log") then
		io.open("quest_mod.log", "w")
	end
	
	JSON = require("external/json") --not require a verification because it's not mine ^^
	
	
	questMod.var = require('modules/var')
	resetVar()
	
	
	
	questMod.sound = require('modules/sound')
	questMod.db       = require("modules/db")
	questMod.modpack   = require("modules/modpack")
	questMod.npc      = require("modules/npc")
	questMod.utils    = require("modules/utils")
	questMod.place    = require("modules/place")
	questMod.relation = require("modules/relation")
	questMod.gang     = require("modules/gang")
	questMod.quest   = require("modules/quest")
	questMod.location   = require("modules/location")
	questMod.framework = require('modules/framework')
	questMod.netcontract = require('modules/netcontract')
	questMod.housing = require('modules/housing')
	questMod.taxi = require('modules/taxi')
	questMod.saves = require('modules/saves')
	questMod.multi = require('modules/multi')
	questMod.AV = require('modules/av')
	questMod.editor = require('modules/editor')
	questMod.see = require('modules/see')
	questMod.scripting = require('modules/scripting')
	questMod.observer = require('modules/observer')
	questMod.ui = require('modules/ui')
	
	
	--external library
	QuestManager = require('external/QuestManager')
	QuestJournalUI = require('external/QuestJournalUI')
	QuestTrackerUI = require('external/QuestTrackerUI')
	GameUI = require('external/GameUI')
	TargetingHelper = require('external/TargetingHelper')
	AIControl = require('external/AIControl')
	GameHUD = require('external/GameHUD')
	GameSettings = require('external/GameSettings')
	IGE = require('external/ImGuiExtension')
	Cron = require('external/Cron')
	Ref = require('external/Ref')
	EventProxy = require('external/EventProxy')
	UIPopupsManager = require('external/UIPopupsManager')
	UIScroller = require('external/UIScroller')
	UIButton = require('external/UIButton')
	GameSession = require('external/GameSession')
	CPStyling =  require('external/cpstyling')
	CPS =  CPStyling:New()
	
	
	
	CompiledDatapack = {}
	
	local reader = dir("data/cache")
	for i=1, #reader do 
		if(tostring(reader[i].type) ~= "directory" and reader[i].name ~= "placeholder") then
			
			
			local file =io.open('data/cache/'..reader[i].name)
			local size = file:seek("end")    -- get file size
			file:close()
			
			if size > 100 and size < 10000000 then
				
				CompiledDatapack[reader[i].name] = require('data/cache/'..reader[i].name)
				
				else
				
				local msg = " is too big. The cache file will not be loaded.."
				
				if(size < 100) then
					
					local msg = "is too small. The cache file will not be loaded.."
					
				end
				
				debugPrint(2,"Size of the cache "..reader[i].name..msg)
				
			end
			
			
			
			
		end
	end
	
	-- File Checking for Init
	if file_exists("desc.json") then
		local f = io.open("desc.json")
		lines = f:read("*a")
		if lines ~= "" then
			local json = json.decode(lines)
			questMod.version = json.version
			questMod.channel = json.channel
			questMod.changelog = json.changelog
		end
		f:close()
	end
	
	
	if file_exists("net/fetcheddata.json") then
		
		fetcheddata = readFetchedData()
		
	end
	
	
	if file_exists("net/multienabled.txt") then
		os.remove("multienabled.txt")
	end
	if not file_exists("net/modpacklist.json") then
		io.open("net/modpacklist.json", "w"):close()
	end
	if not file_exists("net/downloadedDatapack.json") then
		io.open("net/downloadedDatapack.json", "w"):close()
	end
	
	if file_exists("net/multi/player/connect.txt") == false then
		debugPrint(1,"CyberScript WARNING : Authentication at boot failed, please connect from CyberScript Multiplayer Menu")
		
		
	end
	if file_exists("net/multi/player/faction.txt") then
		local f = io.open("net/multi/player/faction.txt")
		lines = f:read("*a")
		if lines ~= "" then
			currentFaction = lines
		end
		f:close()
	end
	if file_exists("net/multi/player/factionrank.txt") then
		local f = io.open("net/multi/player/factionrank.txt")
		lines = f:read("*a")
		if lines ~= "" then
			currentFactionRank = lines
		end
		f:close()
	end
	
	--Theme and lang import
	havelang = ImportLanguage()
	havetheme = ImportTheme()
	
end
function SaveLoading()
	
	arrayVehicles = initVehicles()
	unlockVehicles(initVehicles())
	arrayDistricts = initDistrict()
	arrayFastTravel = initFastTravel()
	arrayGameSounds = initGameSounds()
	arrayAttitudeGroup = initAttitudeGroup()
	
	
	if #currentSave.arrayAffinity == 0 then
		reloadCET = false
		if file_exists("data/sessions/latest.txt") then
			nodata = false
			GameSession.readLatest()
			debugPrint(2,"CyberScript Session : data found, recover latest data")
			else
			nodata = true
			migrateFromDB()
			debugPrint(2,"CyberScript Session : No session data found, migrate from DB")
		end
	end
	
	for i,v in ipairs(arrayPnjDb) do
		if currentSave.myAvatar ~= nil and currentSave.myAvatar == v.TweakIDs then
			Avatarindex = i
		end
		table.insert(tweakdbtable,v.TweakIDs)
	end
	
	
	if GameIsLoaded == true and #currentSave.arrayAffinity > 0 then
		loadUIsetting()
	end
	
	if #currentSave.garage > 0 then
		for i=1, #currentSave.garage do
			Game.GetVehicleSystem():EnablePlayerVehicle(currentSave.garage[i].path, true, false)
		end
	end
	
	if(currentSave.arrayUserSetting[1] ~= nil) then -- convert old setting to new
		
		local arrayUserSetting2 = {}
		
		for i,v in ipairs(currentSave.arrayUserSetting) do
			
			arrayUserSetting2[currentSave.arrayUserSetting[i].Tag] = currentSave.arrayUserSetting[i].Value
			
			
		end
		
		currentSave.arrayUserSetting = arrayUserSetting2
		
		
		
		debugPrint(2,getLang("init_renew_setting"))
		
	end
	
	
	ScrollSpeed = getUserSettingWithDefault("ScrollSpeed",ScrollSpeed)
	ScriptedEntityAffinity = getUserSettingWithDefault("ScriptedEntityAffinity",ScriptedEntityAffinity)
	AmbushMin = getUserSettingWithDefault("AmbushMin",AmbushMin)
	AlwaysShowDefaultWindows = getUserSettingWithDefault("AlwaysShowDefaultWindows",AlwaysShowDefaultWindows)
	AmbushEnabled = getUserSettingWithDefault("AmbushEnabled",AmbushEnabled)
	AutoAmbush = getUserSettingWithDefault("AutoAmbush",AutoAmbush)
	displayXYZset = getUserSettingWithDefault("displayXYZ",displayXYZset)
	currentController = getUserSettingWithDefault("currentController",currentController)
	enableLocation = getUserSettingWithDefault("enableLocation",enableLocation)
	showFactionAffinityHud = getUserSettingWithDefault("showFactionAffinityHud",showFactionAffinityHud)
	AmbushMax = getUserSettingWithDefault("AmbushMax",AmbushMax)
	GangWarsEnabled = getUserSettingWithDefault("GangWarsEnabled",GangWarsEnabled)
	AutoRefreshDatapack = getUserSettingWithDefault("AutoRefreshDatapack",AutoRefreshDatapack)
	logrecordlevel = getUserSettingWithDefault("logrecordlevel",logrecordlevel)
	
	InfiniteDoubleJump =  getUserSettingWithDefault("InfiniteDoubleJump",InfiniteDoubleJump)
	DisableFallDamage =  getUserSettingWithDefault("DisableFallDamage",DisableFallDamage)
	Player_Sprint_Multiplier = getUserSettingWithDefault("Player_Sprint_Multiplier",Player_Sprint_Multiplier)
	Player_Run_Multiplier = getUserSettingWithDefault("Player_Run_Multiplier",Player_Run_Multiplier)
	Jump_Height = getUserSettingWithDefault("Jump_Height",Jump_Height)
	Double_Jump_Height = getUserSettingWithDefault("Double_Jump_Height",Double_Jump_Height)
	
	
	
	
	SetFlatFromSetting()
	
	GetScriptableSystemsContainer = Game.GetScriptableSystemsContainer()
	FastTravelSystem = GetScriptableSystemsContainer:Get('FastTravelSystem')
	FastTravelPoints = FastTravelSystem:GetFastTravelPoints()
	local mappinData = Game.GetMappinSystem():GetMappins(gamemappinsMappinTargetType.Map)
	
	mappedFastTravelPoint = {}
	for i=1, #FastTravelPoints do
		local point = FastTravelPoints[i]
		local position = ""
		local obj = {}
		for i=1, #mappinData do
			local pointmp = mappinData[i]
			if(pointmp.id.value  == point.mappinID.value) then
				--position = .."X : "..tostring(pointmp.worldPosition.x) .." Y : ".. tostring(pointmp.worldPosition.x) .." Z : ".. tostring(pointmp.worldPosition.x) 
				obj.position = pointmp.worldPosition
			end
		end
		obj.name = Game.GetLocalizedText(point:GetPointDisplayName())
		obj.markerref = GameDump(point:GetMarkerRef())
		obj.markerrefdata = point:GetMarkerRef()
		table.insert(mappedFastTravelPoint,obj)
	end
	
	
	
	
	
	if currentSave.Score["faction_mox"] == nil or currentSave.Score["faction_mox"]["district_westbrook"] == nil  then
		initGangDistrictScore()
	end
	
	
	
	if (currentSave.Score["faction_mox"] == nil or currentSave.Score["faction_mox"]["faction_tygerclaws"] == nil) then
		
		initGangRelation()
		
	end
	
	
	migrateFromOldScore()
	
	if (currentSave.Variable["player"] == nil) then
		
		currentSave.Variable["player"]= {}
		
	end
	
	if (currentSave.Variable["player"]["current_gang"] == nil) then
		
		currentSave.Variable["player"]["current_gang"] = "faction_mox"
		
	end
	
	
	makeNativeSettings()
	
end
-- ----------------------------------------------------------------------
-------------------------------Var Loading-------------------------------
-- ---------------------------------------------------------------------------¸



-- ---------------------------------------------------------------------------
-- -------------------------------MAIN Function-------------------------------
-- ---------------------------------------------------------------------------

function setupCore() --Setup environnement (DatapackLoading, observer, overrider)
	
	DatapackLoading()
	
	MasterVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MasterVolume")
	UIPopupsManager.Inititalize()
	playerDeltaPos = Vector4.new(0, 0, 0, 1)
	screenWidth, screenHight = GetDisplayResolution()
	windowPos = ((screenWidth / 4) *3) - 43
	targetS = Game.GetTargetingSystem()
	tp = Game.GetTeleportationFacility()
	SfxVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "SfxVolume")
	playerDeltaPos = Vector4.new(0, 0, 0, 1)
	screenWidth, screenHight = GetDisplayResolution()
	windowPos = ((screenWidth / 4) *3) - 43
	targetS = Game.GetTargetingSystem()
	tp = Game.GetTeleportationFacility()
	SfxVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "SfxVolume")
	DialogueVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "DialogueVolume")
	MusicVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MusicVolume")
	CarRadioVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "CarRadioVolume")
	SoundManager.MasterVolume = MasterVolume:GetValue()
	SoundManager.SfxVolume = SfxVolume:GetValue()
	SoundManager.DialogueVolume = DialogueVolume:GetValue()
	SoundManager.MusicVolume = MusicVolume:GetValue()
	SoundManager.CarRadioVolume = CarRadioVolume:GetValue()
	SetOverrider()
	SetObserver()
	eventCatcher = sampleStyleManagerGameController.new()
	GameUI.Listen(function(state)
		
		if(state.submenu == "Stats") then
		end
		if(state.isMenu) then
			inMenu = true
			ActiveMenu = state.menu
			ActiveSubMenu = state.submenu 
			else
			inMenu = false
			ActiveMenu = nil
			ActiveSubMenu = nil
			AffinityPopupisShow = false
		end
	end)
	if(ModIsLoaded) then
		reloadDB()
		GameSession.StoreInDir('data/sessions')
		GameSession.Persist(currentSave, true)
		GameSession.OnLoad(function() 
			reloadDB()
			for k,v in pairs(mappinManager) do
				deleteMappinByTag(k)
			end
			isdead = false
			if(#currentSave.arrayAffinity > 0) then
				GameIsLoaded = true
				reloadCET = false
			end
			initCore()
			
		end) 
		initCore()
		
		CName.add("Available Quests")
	end
end
function DatapackLoading() --handle the loading and creation of cache for datapack in json/datapack
	
	local reader = dir("data/cache")
	
	--if there is existing cache
	if( #reader > 0 ) then
		debugPrint(2,getLang("compilefound"))
		
		
		
		
		local haveerror = false
		
		arrayDatapack = {}
		
		
		local directories = {}
		
		
		--we load the directories from json/datapack
		local reader = dir("json/datapack")
		for i=1, #reader do 
			if(tostring(reader[i].type) == "directory") then
				
				table.insert(directories,reader[i].name)
			end
		end
		
		
		--for each directories
		for i,u in ipairs(directories) do
			
			-- we check if there is an existing cache
			local v = CompiledDatapack[u..".lua"]
			
			
			try {
				function()
					
					--if datapack cache is not good or doesn't exist, we create an new cache and added it to arrayDatapack
					if(v == nil or v.cachedata == nil or v.cachedata.CacheVersion== nil or v.cachedata.modVersion== nil  or v.cachedata.CacheVersion ~= cacheVersion or v.cachedata.modVersion ~= questMod.version) then
						if(file_exists("json/datapack/"..u.."/desc.json") == true) then
							ImportDataPackFolder(u)
							exportCompiledDatapackFolder(u,"Created Cache")
							debugPrint(2,u.." "..getLang("compileoutdated"))
							
						end
						
						else
						--if datapack cache is good, we added it to arrayDatapack from the compiled lua cache
						debugPrint(2,u.." "..getLang("compileuptodate"))
						arrayDatapack[u] = v
					end
					
					
					--if the desc.json doesnt exist
					if(file_exists("json/datapack/"..u.."/desc.json") == false) then
						
						
						--if there is no desc json but an cache,
						if(file_exists('data/cache/'..u..'.lua') == true) then
							--we delete the cache (means no datapack in the datapack folder)
							os.remove('data/cache/'..u..'.lua')
							debugPrint(2,u.." datapack no longer exist, deleting cache...")
							
						end
						
					end
					
					
					
					
					
					
				end,
				catch {
					function(error)
						debugPrint(1,getLang("datatpackimporterror").."("..u..")"..error)
					
						
						haveerror = true
					end
				}
			}
			
			
			
			
			
		end
		
		--if an error occur, we only load the default datapack
		if(haveerror == true) then
			
			RecoverDatapack()
			
		end
		
		debugPrint(1,getLang("compileloaded"))
		
		else
		--if there is no cache, we create an new cache for each directories in json/datapack
		ImportDataPack()
	end
	
	
	
end
function initCore() --Setup session, external observer and trigger mod core loading
	isGameLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()
	
	resetVar()
	
	
	
	if GetMod('nativeSettings') then nativeSettings =  GetMod("nativeSettings") else debugPrint(1,getLang("nonattivesetting")) error(getLang("nonattivesetting")) end
	
	
	if GetMod('AppearanceMenuMod') then 
		AMM =  GetMod("AppearanceMenuMod")
		if(AMM.API ~= nil) then
			AMMversion = AMM.API.version
			else
			AMM = nil
			debugPrint(1,getLang("ammoutdated"))
		end
		else 
		debugPrint(1,getLang("ammnotfound"))
		
	end
	
	
	if GetMod('ImmersiveFirstPerson') then GetMod('ImmersiveFirstPerson').api.Disable() debugPrint(1,getLang("immersivepersonenabled")) end
	
	
	
	if(nativeSettings ~= nil and nativeSettings.data["CMDT"] ~= nil  ) then
		nativeSettings.data["CMDT"].options = {}
		else
		nativeSettings.addTab("/CMDT", "CyberScript Datapack Manager") -- Add our mods tab (path, label)
		nativeSettings.data["CMDT"].options = {}
	end
	
	
	
	
	
	if file_exists("net/userLogin.txt") then
		local f = io.open("net/userLogin.txt")
		local lines = f:read("*a")
		if lines ~= "" then
			pcall(function ()
				local obj = json.decode(lines)
				myTag = obj.login
				myPassword = obj.password
			end)
		end
		f:close()
	end
	
	Avatarindex = 1
	tweakdbtable = {}
	
	
	
	
	debugPrint(2,"CyberScript version "..questMod.version..questMod.channel)
	debugPrint(1,"CyberScript Initialisation...")
	
	
	
	
	
	
	
	
	
	
	
	questMod.EnemyManager = {}
	questMod.FriendManager = {}
	questMod.NPCManager = {}
	questMod.EntityManager = {}
	questMod.GroupManager = {}
	
	testVehicule = {}
	currentdialogQuestList = {}
	currentdialogOptionList = {}
	arrayInteractEnable = {}
	-- --INIT VAR
	bgcolor = "5df6ff"
	draw = false
	next_ambush = 0
	nexttimer_ambush = 300
	setkillAggro = false
	setPassive = false
	enemy_count = 0
	currentMissionId = 0
	haveMission = false
	canTakeContract = false
	npcSpawned = false
	npcStarSpawn = false
	enemySpawned = false
	setStarFriend = false
	currentHostileFaction = ""
	getArrow = false
	isInHouse = false
	candrwMapPinFixer= true
	fixerCanSpawn = true
	nash_have_speak = false
	
	
	
	
	
	CheckandUpdateDatapack()
	LoadDataPackCache()
	SaveLoading()
	initEditor()
	
	debugPrint(1,getLang("CyberScriptinit"))
	tick = 0
end
function refresh(delta) -- update event (include thread refresh action and QuestThreadManager)
	isGameLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()
	if(ModIsLoaded) then
		if isGameLoaded  then
			if Game.GetPlayer() and initFinished and (GameUI.IsLoading() == false) then
				tick = tick +1
				local firstLaunch = tick
				Cron.Update(delta)
				if(tick > 60)then
					if(tick >= 61 and tick <= 62 and draw == false)then
						
						inGameInit()
						
					end
				
					if(file_exists("success.txt"))then
						updatefinished = true
						updateinprogress = false
						
						os.remove("success.txt")
					end
					
					QuestThreadManager()
					if(autoScript == true) then
						CompileCachedThread()
						ScriptExecutionEngine()
					end
					if(updateinprogress == false and updatefinished == false and reloadCET == false) then
						mainThread()
					end
					else
					draw = false
				end
				else
				if Game.GetPlayer() and initFinished == false then
					
					if(nativeSettings ~= nil) then
						nativesettingEnabled = true
					end
					eventCatcher = sampleStyleManagerGameController.new()
					
					
					initFinished = true
					draw = true
				end	
			end
		end
	end
end
function mainThread()-- update event when mod is ready and in game (main thread for execution)
	local objective = Game.GetJournalManager():GetTrackedEntry()
	if (AutoAmbush == 1 and objective ~= nil) then --AutoAmbush (disable ambush event when MainQuest or SideQuest is active)
		-- MainQuest = 0,
		-- SideQuest = 1,
		-- MinorQuest = 2,
		-- StreetStory = 3,
		-- Contract = 4,
		-- VehicleQuest = 5
		
		local phase = Game.GetJournalManager():GetParentEntry(objective)
		local quest = Game.GetJournalManager():GetParentEntry(phase)
		
		if(string.match(tostring(quest:GetType()), "MainQuest") or string.match(tostring(quest:GetType()), "SideQuest"))then
			if(AmbushEnabled ~= 0)then
				AmbushEnabled = 0
				updateUserSetting("AmbushEnabled",AmbushEnabled)
			end
			else
			if(AmbushEnabled ~= 1)then
				AmbushEnabled = 1
				updateUserSetting("AmbushEnabled",AmbushEnabled)
			end
		end
	end
	inScanner = GameUI.IsScanner()
	player = Game.GetPlayer()
	currentTime = getGameTime()
	curPos = player:GetWorldPosition()
	next_ambush = next_ambush + 1	
	loadCustomPlace()
	itemMover()
	curRot = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
	districtBG = IRPtheme.districtFriendly
	districtState = lang.Friendly
	getCurrentDistrict2()
	
	if(currentDistricts2 ~= nil)then
		
		setVariable("current_district","tag", currentDistricts2.Tag)
		
		
		if(districtState == nil) then
			districtState = "loading"
			
		end	
		
		local disstate = isHostileDistrict()
		setVariable("current_district","state",disstate)
		
		if(disstate == 0) then 
			
			setVariable("current_district","stateName",getLang("Friendly"))
			districtState = getLang("Friendly")
		
		end
		
		if(disstate == 1) then 
		
			setVariable("current_district","stateName",getLang("Neutral"))
			districtState = getLang("Neutral")
		
		end
		
		if(disstate == 2) then 
		
			setVariable("current_district","stateName",getLang("Hostile"))
			districtState = getLang("Hostile")
		
		end
		
		
		
		
		local districttext = ""
		if(currentDistricts2.districtLabels ~=nil and #currentDistricts2.districtLabels > 0) then
			
			if(currentDistricts2.districtLabels ~=nil and #currentDistricts2.districtLabels > 1) then
				
				setVariable("current_district","subdistrict_enum", currentDistricts2.districtLabels[2])
				else
				setVariable("current_district","subdistrict_enum", "")
			end
			
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i == 1 then
					if(#currentDistricts2.districtLabels == 1) then
						
						
						districttext = districttext.."  |  "..test.." ("..districtState..")"
						else
						
						districttext = districttext..test
						
					end
					else
					districttext = districttext.."  |  "..test.." ("..districtState..")"
				end
			end
			
			setVariable("current_district","districttext",districttext)
			
			else
			setVariable("current_district","tag", "")
			setVariable("current_district","districttext","")
			setVariable("current_district","subdistrict_enum", "")
			setVariable("current_district","state","")
			setVariable("current_district","stateName","")
			
		end
		
		
		else
		setVariable("current_district","tag", "")
		setVariable("current_district","districttext","")
		setVariable("current_district","subdistrict_enum", "")
		setVariable("current_district","state","")
		setVariable("current_district","stateName","")
		
	end
	
	
	
	setVariable("player_position","x",ftos(curPos.x))
	setVariable("player_position","y",ftos(curPos.y))
	setVariable("player_position","z",ftos(curPos.z))
	
	setVariable("player_rotation","yaw",ftos(curRot.yaw))
	setVariable("player_rotation","pitch",ftos(curRot.pitch))
	setVariable("player_rotation","roll",ftos(curRot.roll))
	
	
	
	--Targeted entity
	objLook = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(),false,false)
	if(objLook ~= nil) then
		if(objLook ~= nil) then
			tarName = objLook:ToString()
			--	debugPrint(10,tostring(objLook:GetHighLevelStateFromBlackboard()))
			if(string.match(tarName, "NPCPuppet"))then
				-- objLook:MarkAsQuest(true)
				-- debugPrint(10,GameDump(objLook:GetCurrentOutline()))
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				targName = tostring(objLook:GetTweakDBDisplayName(true))
				openCompanion, gangscore, lookatgang = checkAttitudeByGangScore(objLook)
				
				
				
				
				local obj = getEntityFromManagerById(objLook:GetEntityID())
				
				if(obj.id ~= nil) then
					
					if obj.isquest == nil then obj.isquest = false end
						
					objLook:MarkAsQuest(obj.isquest)
					
					else
					
					if questMod.EntityManager["lookatnpc"].isquest == nil then questMod.EntityManager["lookatnpc"].isquest = false end
					questMod.EntityManager["lookatnpc"].id = nil
					
					questMod.EntityManager["lookatnpc"].id = objLook:GetEntityID()
					objLook:MarkAsQuest(questMod.EntityManager["lookatnpc"].isquest)
				
					
				end
				
			
				
				
				
				-- end
			end
			objLookIsVehicule = objLook:IsVehicle()
			local obj = getEntityFromManagerById(objLook:GetEntityID())
			if(obj.id ~= nil) then
				if(obj.isMP ~=nil and obj.isMP == true)then
					multiName = obj.tag
					if(inMenu == false)then
						onlineReceiver = obj.tag
					end
					else
					multiName = ""
					if(inMenu == false)then
						onlineReceiver = ""
					end
				end
			end
			else
			
			openCompanion = false
			objLookIsVehicule = false
		end
		else
		multiName = ""
		
		
		
		questMod.EntityManager["lookatnpc"].id = nil
		questMod.EntityManager["lookatnpc"].tweak = "None"
		currentScannerItem = nil
		
		openCompanion = false
		objLookIsVehicule = false
	end
	
	--house
	if(currentHouse ~= nil) then
		interactautohide = false
		setVariable("current_place","tag",currentHouse.tag)
		setVariable("current_place","name",currentHouse.name)
		if(currentRoom ~= nil) then
			
			setVariable("current_place","room_tag",currentRoom.tag)
			setVariable("current_place","room_name",currentRoom.name)
			else
			setVariable("current_place","room_tag","")
			setVariable("current_place","room_name","")
			
		end
		else
		setVariable("current_place","tag","")
		setVariable("current_place","name","")
		setVariable("current_place","room_tag","")
		setVariable("current_place","room_name","")
	end
	
	if(ActualPlayerMultiData ~= nil and ActualPlayerMultiData.currentPlaces[1] ~= nil) then
		
		
		setVariable("current_multi_place","tag",ActualPlayerMultiData.currentPlaces[1].name)			
		else
		
		setVariable("current_multi_place","tag","")
		
		
	end
	
	--Quest
	if(currentSave.arrayPlayerData.CurrentQuest ~= nil) then
		haveMission = true
		canTakeContract = false
	end
	
	--Vehicle
	local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
	if (inVehicule) then
		
		local vehicule = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
		if(vehicule ~= nil) then
			local obj = getEntityFromManagerById(vehicule:GetEntityID())
			inVehiculeTweak = ""
			for i=1,#arrayVehicles do
				if(tostring(TweakDBID.new(arrayVehicles[i])) == tostring(vehicule:GetRecordID())) then
					inVehiculeTweak = arrayVehicles[i]
				end
			end
			
			local isThiscar = (obj.id ~= nil and obj.isAV == true)
			
			
			
			if isThiscar then
				AVisIn = true
			
				
				CurrentAVEntity =  vehicule
				local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			
				local bool = false
				bool = IsPlaying("env")
				if(bool == false) then
					local sound = getSoundByNameNamespace("av_engine.mp3","av")
					if(sound ~= nil) then
						local path = questMod.soundpath..sound.path
						PlaySound(sound.name,path,"env",100)
					end
				end
			end
		end
		else
		inVehiculeTweak = ""
	end
	
	--AV
	if(AVinput.exit ~= nil and AVinput.exit == true) then
		if AVisIn == true and inVehicule == true then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			fppComp:SetLocalPosition(Vector4:new(0.0, 0.0, 0.0, 1.0))
			Stop("env")
			if(AVseat ~= nil) then
				UnsetSeat("player",false, AVseat)
				AVseat = nil
				Cron.After(1, function()
					
					debugPrint(10,#questMod.GroupManager["AV"].entities)
					for i=1, #questMod.GroupManager["AV"].entities do 
						local entityTag = questMod.GroupManager["AV"].entities[i]
						debugPrint(10,entityTag)
						local obj = getEntityFromManager(entityTag)
						local enti = Game.FindEntityByID(obj.id)
						if(enti ~= nil) then
							despawnEntity(entityTag)
						end
					end
					questMod.GroupManager["AV"].entities = {}	
					CurrentAVEntity = nil
					AVisIn = false
					AVinput.exit = false							
				end)
				else
				CurrentAVEntity = nil
				AVisIn = false
				AVinput.exit = false		
			end
		end
	end
	if (AVinput.isMoving == true and AVisIn and AVinput.keyPressed == true ) then
		
		fly(AVinput.currentDirections, 0)
		elseif (AVinput.isMoving == true and AVinput.keyPressed == false and AVisIn) then
		if AVspeed > 0.3 then
			AVspeed = AVspeed - 0.05
			if AVinput.lastInput ~= "" then
				debugPrint(1,AVinput.lastInput)
				if AVinput.lastInput == "forward" then
					AVinput.currentDirections.forward = true
					fly(AVinput.currentDirections, 0)
				end
				if AVinput.lastInput == "backwards" then
					AVinput.currentDirections.backwards = true
					fly(AVinput.currentDirections, 0)
				end
				else
				AVinput.isMoving = false
				AVinput.keyPressed = false
				AVinput.currentDirections.backwards = false
				AVinput.currentDirections.forward = false
				AVinput.lastInput = ""
			end
			else
			AVinput.isMoving = false
			AVinput.keyPressed = false
			AVinput.currentDirections.backwards = false
			AVinput.currentDirections.forward = false
			AVinput.lastInput = ""
			local group =getGroupfromManager("AV")
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local isplayer = false
				if entityTag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					
					local newAngle = {}
					newAngle.yaw = AVyaw
					newAngle.roll = AVroll
					newAngle.pitch = AVPitch
					teleportTo(enti, enti:GetWorldPosition(), newAngle, false)
				end
			end
		end
		elseif(AVisIn) then
		AVinput.isMoving = false
		AVinput.currentDirections.backwards = false
		AVinput.currentDirections.forward = false
		AVinput.lastInput = ""
		local group =getGroupfromManager("AV")
		for i=1, #group.entities do 
			local entityTag = group.entities[i]
			local isplayer = false
			if entityTag == "player" then
				isplayer = true
			end
			local obj = getEntityFromManager(entityTag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				
				local newAngle = {}
				newAngle.yaw = AVyaw
				newAngle.roll = AVroll
				newAngle.pitch = AVPitch
				teleportTo(enti, enti:GetWorldPosition(), newAngle, false)
			end
		end
		
		local speede = math.floor(AVspeed*10)
		setScore("av","speed",speede)
	end
	
	--Pause Menu and Ambush timer
	if(inMenu) then
		if(currentSubtitlesGameController ~= nil) then
			currentSubtitlesGameController:Cleanup()
		end
		
		
		if(ActiveMenu == "PauseMenu" ) then
			if(ExecPauseMenu == false and getUserSetting("AutoRefreshDatapack") == true) then
				ExecPauseMenu =  true
				
				CheckandUpdateDatapack()
				LoadDataPackCache()
				
			end
			else
			if(ExecPauseMenu == true) then
				ExecPauseMenu =  false
			end
		end
		else
		if(ExecPauseMenu == true) then
			ExecPauseMenu =  false
		end
		
		
		for k,v in pairs(arrayBoundedEntity) do
			
			
			
			local obj = getEntityFromManager(k)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				
				local anchorobj = getEntityFromManager(v.anchor)
				local anchorenti = Game.FindEntityByID(anchorobj.id)
				if(anchorenti ~= nil) then
					
					local position = anchorenti:GetWorldPosition()
					
					local qat = anchorenti:GetWorldOrientation()
					local rotation = GetSingleton('Quaternion'):ToEulerAngles(qat)
					
					if(v.copyrotation == false) then
						
						qat = enti:GetWorldOrientation()
						rotation = GetSingleton('Quaternion'):ToEulerAngles(qat)
						
					end
					
					
					
					
					
					local isplayer = false
					if k == "player" then
						isplayer = true
					end
					
					position.x = position.x + v.x
					position.y = position.y + v.y
					position.z = position.z + v.z
					
					rotation.yaw = rotation.yaw + v.yaw
					rotation.pitch = rotation.pitch + v.pitch
					rotation.roll = rotation.roll + v.roll
					
					if(
						(
							arrayBoundedEntity[k].lastposition.x ~= position.x or
							arrayBoundedEntity[k].lastposition.y ~= position.y or 
							arrayBoundedEntity[k].lastposition.z  ~= position.z
						) 
						or
						(
							v.copyrotation == true and (
								
								arrayBoundedEntity[k].lastorientation.yaw ~= rotation.yaw or
								arrayBoundedEntity[k].lastorientation.pitch ~= rotation.pitch or 
								arrayBoundedEntity[k].lastorientation.roll  ~= rotation.roll
							)
						)
						
						
					) then
					
					
					arrayBoundedEntity[k].lastposition.x = position.x
					arrayBoundedEntity[k].lastposition.y = position.y
					arrayBoundedEntity[k].lastposition.z = position.z
					
					
					
					arrayBoundedEntity[k].lastorientation.yaw = rotation.yaw
					arrayBoundedEntity[k].lastorientation.pitch = rotation.pitch
					arrayBoundedEntity[k].lastorientation.roll = rotation.roll
					
					
					
					if(v.isitem == true) then
						local item = {}
						
						enti:GetEntity():Destroy()
						
						local transform = Game.GetPlayer():GetWorldTransform()
						transform:SetPosition(position)
						transform:SetOrientationEuler(rotation)
						questMod.EntityManager[k].id = exEntitySpawner.Spawn(obj.tweak, transform)
						
						else
						
						teleportTo(objlook, position, rotation, isplayer)
					end
					
					
					
					end
					
					
				end
				
				else
				
				--arrayBoundedEntity[k] = nil
				
			end
			
			
		end
		
		
		
		local ambusec = AmbushMin*60*60
		
		if (tick % ambusec == 0) then --every X second
			checkAmbush()
			
		end
	end
	
	--Record Location
	
	
	--Dialog check
	if(currentDialogHub ~= nil) then
		
		local blackboardDefs = Game.GetAllBlackboardDefs()
		local interactionBB = Game.GetBlackboardSystem():Get(blackboardDefs.UIInteractions)
		interactionBB:SetVariant(blackboardDefs.UIInteractions.DialogChoiceHubs, ToVariant(currentDialogHub.hub), true)
		isdialogactivehub = true
		
	end
	
	--Timer
	if(currentTimer ~= nil) then
		
		ticktimer = ticktimer +1
		local texttimer = currentTimer.message.." : "..tostring(math.ceil((ticktimer/60))).." seconds"
		
		if(currentTimer.type == "remaning") then
			
			
			texttimer =  currentTimer.message.." : "..tostring(currentTimer.value - math.ceil((ticktimer/60))).." seconds"
			
			
			
		end
		
		setVariable("current_timer","text",texttimer)
		
		else
		setVariable("current_timer","text","")
	end
	
	--Star Manager
	if cancheckmission then
		--StarEventManager()
	end
	
	--Freeze camera action
	-- if freezeCamera then
	
	-- Game.GetPlayer():GetFPPCameraComponent().pitchMin = pitch - 0.01 -- Use pitchMin/Max to set pitch, needs to have a small difference between Min and Max
	-- Game.GetPlayer():GetFPPCameraComponent().pitchMax = pitch
	-- Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition() , EulerAngles.new(0,0,yaw)) -- Set yaw when teleporting
	-- end
	
	--Timers 
	if (tick % 5 == 0) then --every 0.5 second
		
		
		
		
		
		if (MultiplayerOn == true) then
			
			syncPosition(curPos,curRot)
			
			mpvehicletick = mpvehicletick + 1
			getFriendPos()
			spawnPlayers()
			
			loadCustomMultiPlace()
		end
		
		
		if curPos ~= nil and rootContainer ~= nil and displayHUD["posWidget"] ~= nil then
			if(enableLocation == true) then
				
				
				
				
				
				
				
				
				for k,v in pairs(arrayHUD) do
					if(v.hud.type == "widget" or v.hud.type == "container") then
						if(v.hud.context ~= nil) then
							
							if(isArray(v.hud.context))then
								for i,cont in ipairs(v.hud.context) do
									
									if(checkTriggerRequirement(cont.requirement,cont.trigger))then
										for key,prop in pairs(cont.prop) do
											local path =  splitDot(key, ".")
											setValueToTablePath(v.hud, path, GeneratefromContext(prop))
											
										end
									end
								end
								else
								if(checkTriggerRequirement(v.hud.context.requirement,v.hud.context.trigger))then
									for key,prop in pairs(v.hud.context.prop) do
										local path =  splitDot(key, ".")
										setValueToTablePath(v.hud, path, GeneratefromContext(prop))
											
									end
								end
							end
							
						end
					end
					if(v.hud.type == "widget" and displayHUD[k] ~= nil) then
						displayHUD[k]:SetText(v.hud.text)
						displayHUD[k]:SetFontFamily(v.hud.fontfamily)
						displayHUD[k]:SetFontStyle(v.hud.fontstyle)
						displayHUD[k]:SetFontSize(v.hud.fontsize)
						displayHUD[k]:SetTintColor(gamecolor(v.hud.color.red,v.hud.color.green,v.hud.color.blue,1))
						displayHUD[k]:SetMargin(inkMargin.new({ top = v.hud.margin.top, left = v.hud.margin.left}))
						displayHUD[k]:SetVisible(v.hud.visible)
						
					end
					
					if(v.hud.type == "container" and displayHUD[k] ~= nil) then
						
						displayHUD[k]:SetMargin(inkMargin.new({ top = v.hud.margin.top, left = v.hud.margin.left}))
						displayHUD[k]:SetVisible(v.hud.visible)
						
						
					end
					
					
				end
				
				for k,v in pairs(arrayHUD) do
					
					if(v.hud.type == "theme" and displayHUD[v.hud.target] ~= nil) then
						
						if(v.hud.context ~= nil) then
							
							if(isArray(v.hud.context))then
								for i,cont in ipairs(v.hud.context) do
									
									if(checkTriggerRequirement(cont.requirement,cont.trigger))then
										for key,prop in pairs(cont.prop) do
											
											local path =  splitDot(key, ".")
											setValueToTablePath(v.hud, path, GeneratefromContext(prop))
										
										end
									end
								end
								else
								if(checkTriggerRequirement(v.hud.context.requirement,v.hud.context.trigger))then
									for key,prop in pairs(v.hud.context.prop) do
										local path =  splitDot(key, ".")
										setValueToTablePath(v.hud, path, GeneratefromContext(prop))
											
										
									end
								end
							end
							
						end
					
						if(v.hud.fontfamily ~= nil) then displayHUD[v.hud.target]:SetFontFamily(v.hud.fontfamily) end
						if(v.hud.fontstyle ~= nil) then displayHUD[v.hud.target]:SetFontStyle(v.hud.fontstyle) end
						if(v.hud.fontsize ~= nil) then displayHUD[v.hud.target]:SetFontSize(v.hud.fontsize) end
						if(v.hud.color ~= nil) then displayHUD[v.hud.target]:SetTintColor(gamecolor(v.hud.color.red,v.hud.color.green,v.hud.color.blue,1)) end
						if(v.hud.margin ~= nil) then displayHUD[v.hud.target]:SetMargin(inkMargin.new({ top = v.hud.margin.top, left = v.hud.margin.left})) end
						
						
					end
					
					
				end
				
				
				if(currentDistricts2 ~= nil)then
					
					
					
					
					
					
					if(showFactionAffinityHud == true) then
						
						displayHUD["factionwidget"]:RemoveAllChildren()
						
						
						if(#currentDistricts2.districtLabels > 0) then
							local gangslist = {}
							if(#currentDistricts2.districtLabels > 1) then
								local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
								for i=1,#gangs do
									if(getScoreKey("Affinity",gangs[i].tag) ~= nil) then
										table.insert(gangslist,gangs[i])
									end
								end
								else
								local gangs = getGangfromDistrict(currentDistricts2.districtLabels[1],20)
								for i=1,#gangs do
									if(getScoreKey("Affinity",gangs[i].tag) ~= nil) then
										table.insert(gangslist,gangs[i])
										
									end
								end
								
							end
							
							for i,v in ipairs(gangslist) do
								
								
								local gang = getFactionByTag(v.tag)
								local top = (i*50)
								locationWidgetPlace_top = locationWidgetFactionDisctrict_top + (i*50) + 50
								
								local isleader = (i==1)
								
								displayGangScoreWidget(getScoreKey("Affinity",v.tag),gang.Name,displayHUD["factionwidget"],top,isleader)
								
								
							end
							
							
							
							
							
						end
						
						
					end
					
					
					
				end
				
				
				if rootContainer ~= nil then
				
				rootContainer:SetVisible(true)
				end
				
				
				
				
				
				
				
				
				else
				if rootContainer ~= nil then
				
				rootContainer:SetVisible(false)
				end
			end
			
		end	
		
		
	end
	if (tick % 100 == 0) then --every 1 second
		if(lastTargetKilled ~= nil)then
			lastTargetKilled = nil
		end
	end
	
	if (tick % 60 == 0) then --every 1 second
		getTriggeredActions()
		doTriggeredEvent()	
		
	
		onlineMessageProcessing()
		if #CurrentOnlineMessage > 0 then
			local action = {}
			action.name = "phone_notification"
			action.title = "Online"
			action.desc = getLang("multi_phone_notification_01")..#CurrentOnlineMessage..getLang("multi_phone_notification_02")
			action.duration = 3
			local actionlist = {}
			table.insert(actionlist,action)
			runActionList(actionlist, "online_message", "interact",false,"nothing",false)
		end
		CurrentOnlineMessage = {}
		
		if activeMetroDisplay == true then
			MetroCurrentTime = MetroCurrentTime - 1
			debugPrint(10,MetroCurrentTime)
			if MetroCurrentTime <= 0 then
				activeMetroDisplay = false
			end
		end
		--checkNPC()
		checkFixer()
		
	end
	if (tick % 120 == 0) then --every 0.5 second
		playRadio()
	end
	if (tick % 180 == 0) then --every 3 second
		getOsTimeHHmm()
		checkNPC()
		if(npcStarSpawn) then
			if(timerDespawn ~= nil) then
				local currentime = getGameTime()
				if(currentime.day > timerDespawn.day or currentime.hour > timerDespawn.hour) then
					despawnEntity("current_star")
					timerDespawn = nil
					npcStarSpawn = nil
				end
			end
		end
	end
	if (tick % 3600 == 0) then --every 3 second
		if(BraindanceGameController == nil or TutorialPopupGameController== nil or incomingCallGameController==nil or currentChattersGameController==nil or currentSubtitlesGameController == nil or MessengerGameController==nil or LinkController==nil) then
			Game.GetPlayer():SetWarningMessage(getLang("missingcontroller"))
			if(BraindanceGameController == nil)then
				debugPrint(1,"CyberScript : BraindanceGameController is missing !")
			end
			if(TutorialPopupGameController == nil)then
				debugPrint(1,"CyberScript : TutorialPopupGameController is missing !")
			end
			if(incomingCallGameController == nil)then
				debugPrint(1,"CyberScript : incomingCallGameController is missing !")
			end
			if(currentShardNotificationController == nil)then
				debugPrint(1,"CyberScript : currentShardNotificationController is missing !")
			end
			if(currentChattersGameController == nil)then
				debugPrint(1,"CyberScript : currentChattersGameController is missing !")
			end
			
			if(MessengerGameController == nil)then
				debugPrint(1,"CyberScript : MessengerGameController is missing !")
			end
			if(LinkController == nil)then
				debugPrint(1,"CyberScript : LinkController is missing !")
			end
			
		end
	end
	if(tick % 18000 == 0) then
		SalaryIsPossible = true
	end
	
	
end
function inGameInit() -- init some function after save loaded
	loadHUD()
	candrwMapPinFixer= false
	cancheckmission = true
	choiceHubData =  gameinteractionsvisInteractionChoiceHubData.new()
	choiceHubData.active =true 
	choiceHubData.flags = EVisualizerDefinitionFlags.Undefined
	choiceHubData.title = "possibleInteractList" --'Test Interaction Hub'
	spdlog.info("LoadUI01")
	loadUIsetting()
	
	theme = CPS.theme
	color = CPS.color
	questMod.GroupManager = {}
	questMod.EntityManager = {}
	Game.SetTimeDilation(0)
	
	doInitEvent()
	setScore("cinematic01","Score",0)
	
	
	local entity = {}
	entity.id = Game.GetPlayer():GetEntityID()
	entity.tag = "player"
	entity.tweak = "player"
	questMod.EntityManager[entity.tag] = entity
	local entity1 = {}
	entity1.id = 0
	entity1.tag = "selection1"
	entity1.tweak = "selection1"
	questMod.EntityManager[entity1.tag] = entity1
	local entity2 = {}
	entity2.id = 0
	entity2.tag = "selection2"
	entity2.tweak = "selection2" 
	questMod.EntityManager[entity2.tag] = entity2
	local entity3 = {}
	entity3.id = 0
	entity3.tag = "selection3"
	entity3.tweak = "selection3"
	questMod.EntityManager[entity3.tag] = entity3
	local entity4 = {}
	entity4.id = 0
	entity4.tag = "selection4"
	entity4.tweak = "selection4"
	questMod.EntityManager[entity4.tag] = entity4
	local entity5 = {}
	entity5.id = 0
	entity5.tag = "selection5"
	entity5.tweak = "selection5"
	questMod.EntityManager[entity5.tag] = entity5
	
	
	
	debugPrint(10,"Yet Choom")
	draw = true
	
	if file_exists("net/multi/player/connect.txt") == false then
		Game.GetPlayer():SetWarningMessage(getLang("authfailed"))
		else
		Game.GetPlayer():SetWarningMessage(getLang("ImmersiveRoleplayModLoaded"))
		
		
		openNetContract = false
		io.open("net/multienabled.txt","w"):close()
		MultiplayerOn = false
		NetServiceOn = true
		
		tokenIsValid = tokenIsValidate()
		openNetContract = false
		
		
		OnlineConversation = nil
		
		
		
		OnlineConversation = {}
		OnlineConversation.tag = "online_conversation"
		OnlineConversation.unlock = true
		OnlineConversation.speaker = "Online"
		OnlineConversation.conversation = {}
		
		setScore(OnlineConversation.tag,"unlocked",1)
	end
	
	despawnAll()
	--createInteraction(true)
	local blackboardDefs = Game.GetAllBlackboardDefs()
	local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
	blackboardPSM:SetInt(blackboardDefs.PlayerStateMachine.SceneTier, 1, true) -- GameplayTier.Tier1_FullGameplay 
	Game.SetTimeDilation(0)
	debugPrint(1,getLang("seestarted"))
end
function windowsManager() -- manage and toggle UI windows
	if(updatefinished == true) then --update Finished windows
		draw = false
		CPS:setThemeBegin()
		if ImGui.Begin(lang.UpdateFinished) then
			ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
			ImGui.SetNextWindowSize(310, 0	, ImGuiCond.Appearing) -- set window size w, h
			ImGui.SetWindowSize(300, 150)
			ImGui.SetWindowPos(800, 900)
			ImGui.Text(lang.UpdateSuccessful)
			ImGui.Text(lang.ReloadCET)
		end
		ImGui.End()
		CPS:setThemeEnd()
	end
	if(updateinprogress == true) then --update in progress windows
		draw = false
		CPS:setThemeBegin()
		if ImGui.Begin(lang.UpdateInProgress) then
			ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
			ImGui.SetNextWindowSize(310, 0	, ImGuiCond.Appearing) -- set window size w, h
			ImGui.SetWindowSize(300, 150)
			ImGui.SetWindowPos(800, 900)
			ImGui.Text(lang.UpdateInProgressMsg01)
			ImGui.Text(lang.UpdateInProgressMsg02)
			ImGui.Text(lang.UpdateInProgressMsg03)
			ImGui.Text(lang.UpdateInProgressMsg04)
		end
		ImGui.End()
		CPS:setThemeEnd()
	end
	if draw and  initFinished then--others windows
		ImageFrame()
		if ImGui.BeginPopupModal("locationdesc2", true) then
			ImGui.SetWindowPos(800, 600)
			local DropdownOptions = {"Kill ", "Escort", "Explore", "Ambush", "CustomPlace","Metro"}
			local DropdownSelected = ""
			ImGui.Text("This location file is for : ")
			ImGui.Text(DropdownOptions[currentreason])
			if ImGui.Button("Valid and close") then
				pathtick = 0
				savelocation.isFor = currentreason
				closeSaveLocation()
				ImGui.CloseCurrentPopup()
				saveLocationEnabled = false	
			end
			ImGui.EndPopup()
		end
		
		
		
		
		if(overlayOpen ) then
			if debugLog == true then
				frameworklog()
			end	
			if debugOptions == true then
				debugWindows()
			end	
			newWindows()
			
			if(openEditor) then
				editorWindows()
				openOption =  false
				if(openEditTrigger) then
					TriggerEditWindows()	
				end
				if(openEditActionTrigger) then
					TriggerActionEditWindows()	
				end
				if(openTriggerItem) then
					SubTriggerEditWindows()	
				end
				if(openControlsEditor) then
					ControlsEditWindows()	
				end
				if openNewTrigger then
					TriggerNewWindows()
				end
				if(openEditAction) then
					ActionEditWindows()	
				end
				if openEditSubAction then
					ActionSubEditWindows()
				end
				if openNewAction then
					ActionNewWindows()
				end
				if openNewRoom then
					RoomNewWindows()
				end
				if openEditRoom then
					RoomEditWindows()
				end
				if(openEditOptions) then
					OptionsEditWindows()	
				end
				if(editor_json_view) then
					openJson()	
				end
				if openNewOptions then
					OptionsNewWindows()
				end
				if openNewObjective then
					ObjectiveNewWindows()
				end
				if openEditObjective then
					ObjectiveEditWindows()
				end
				if openNewConversation then
					ConversationNewWindows()
				end
				if openEditConversation then
					ConversationEditWindows()
				end
				if openNewMessage then
					MessageNewWindows()
				end
				if openEditMessage then
					MessageEditWindows()
				end
				if openNewChoice then
					ChoiceNewWindows()
				end
				if openEditChoice then
					ChoiceEditWindows()
				end
				if openEditItems then
					EditItemsWindows()
				end
				if openNewItems then
					NewItemsWindows()
				end
				if openEditSceneStep then
					SceneStepEditWindows()
				end
				if openNewSceneStep then
					SceneStepNewWindows()
				end
				if openEditHousingTemplate then
					
					EditTemplatePositionWindows()
				end
				
				
			end
			
			if openNetContract then
				ContractWindows()
			end
			
		end
		if(openColorPicker) then
			colorPicker() 
		end
		if((onlineMessagePopup or (ActiveSubMenu == "Phone")) and MultiplayerOn == true) then
			if(onlineReceiver == nil) then
				onlineReceiver = "Instance"
			end
			onlineMessagePopup =  true
			SendMessage()
		end
		if(onlineInstanceCreation) then
			if(CreateInstance.title == nil)then
				CreateInstance.title = ""
				CreateInstance.privacy = 0
				CreateInstance.isreadonly = false
				CreateInstance.nsfw = false
				CreateInstance.password = "nothing"
				defaultprivacy = "Public"
			end
			Multi_InstanceCreate()
		end
		if(onlineGuildCreation) then
			if(CreateGuild.Title == nil)then
				CreateGuild.Title = ""
				CreateGuild.FactionTag = "faction_mox"
			end
			Multi_GuildCreate()
		end		
		if(onlineInstanceUpdate) then
			if(UpdateInstance.title == nil)then
				UpdateInstance.id = CurrentInstance.Id
				UpdateInstance.creationDate = "2022-01-07T14:22:40.710Z"
				UpdateInstance.lastUpdateDate = "2022-01-07T14:22:40.710Z"
				UpdateInstance.title = CurrentInstance.Title
				UpdateInstance.private = 0
				UpdateInstance.readOnly = false
				UpdateInstance.nsfw = false
				UpdateInstance.password = ""
				UpdateInstance.state = 0
				defaultprivacy = "Public"
			end
			Multi_InstanceEdit()
		end
		if(onlineGuildUpdate and currentGuild ~= nil) then
			if(UpdateGuild.Title == nil)then
				
				UpdateGuild.Id = currentGuild.Id
				UpdateGuild.Title = currentGuild.Title
				UpdateGuild.Description = currentGuild.Description
				UpdateGuild.Owner = currentGuild.Owner
				UpdateGuild.FactionTag = currentGuild.FactionTag
				UpdateGuild.LastUpdateDate = currentGuild.LastUpdateDate
				UpdateGuild.CreationDate = currentGuild.CreationDate
				UpdateGuild.Score = currentGuild.Score
			end
			Multi_GuildEdit()
		end		
		
		if(onlineInstancePlaceCreation) then
			Multi_InstanceCreatePlace()
		end
		if(onlineShootMessage) then
			ShootMessage()
		end
		if(multiName ~= "") then
			debugPrint(10,tostring(multiName))
			WhisperMessage()
		end
		
		if isFadeIn then
			fadeinwindows()
		end
		if openEditItemsMulti and selectedItemMulti ~= nil then
			Multi_EditItemsWindows()
		end
		if enableEntitySelection then
			entitySelection()
		end
		if MultiplayerOn then
			MultiNicknameWindows()
		end
		if openInterface then
			WindowsItem()
		end
	end
end
function shutdownManager() -- setup some function at shutdown
	
	CheckandUpdateDatapack()
	UIPopupsManager.ClosePopup()
	for k,v in pairs(mappinManager) do
		deleteMappinByTag(k)
	end
	debugPrint(10,"mappin deleted")
	
	despawnAll()
	resetVar()
	
	
			
	
	
	logme(2,"End Mod")
	-- for i,v in ipairs(logTable) do
		
		-- logf:write("[Level:"..v.level.."]"..v.datestring..":"..v.msg.."\n")
	-- end
	
	
	
--	logf:close()
	collectgarbage()
end
function TweakManager() -- Load vehicles and change some TweakDB
	
	local f = assert(io.open("data/db/vehicles.json"))
	local lines = f:read("*a")
	local encdo = lines
	local tableDis = {}
	tableDis =json.decode(lines)
	
	f:close()
	
	local unlockableVehicles = TweakDB:GetFlat(TweakDBID.new('	'))
	
	for _, vehiclePath in ipairs(tableDis) do
		
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
	debugPrint(2,getLang("vehicleunlocked"))	
	
	TweakDB:SetFlat("PreventionSystem.setup.totalEntitiesLimit", npcpreventionlimit)
	SetFlatFromSetting()
end


function SetFlatFromSetting()
	
	
	TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Sprint_inline1.value", 6.5 * Player_Sprint_Multiplier)
	TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_inline1.value", 3.5 * Player_Run_Multiplier)
	TweakDB:SetFlat("PlayerLocomotion.JumpJumpHeightModifier.value", 1 * Jump_Height)
	TweakDB:SetFlat("PlayerLocomotion.DoubleJumpJumpHeightModifier.value", 2.6 * Double_Jump_Height)
end
-- ------------------------------------------------------------------
-- -------------------------------Event-------------------------------
-- ------------------------------------------------------------------

registerForEvent("onInit", function()
	ModInitialisation()
	setupCore()
end)
registerForEvent('onDraw', function()
	windowsManager()
end)
registerForEvent("onUpdate", function(delta)
	if saveLocationEnabled then
		savePath(recordRotation,recordRelative)
	end
	if playLocationEnabled then
		playPath()
		playtick = playtick+1
	end
	refresh(delta)
end)
registerForEvent("onShutdown", function()
	shutdownManager()
end)
registerForEvent("onOverlayOpen", function()
	overlayOpen = true
end)
registerForEvent("onOverlayClose", function()
	overlayOpen = false
end)
registerForEvent("onTweak", function()
	
	TweakManager()
	
end)


-- -------------------------------HotKey------------------------------
registerHotkey("cycleCustomInteract", "Cycle Custom Interact", function()
	cycleInteract()
end
)
registerHotkey("onlineSendPopup", "Cycle Custom Interact", function()
	if(NetServiceOn and MultiplayerOn) then
		if onlineMessagePopup then
			onlineMessagePopup = false
			else
			onlineMessagePopup = true
		end
		else
		onlineMessagePopup = false
	end
end
)
registerHotkey("onlineSendMessage", "Cycle Custom Interact", function()
	if(NetServiceOn and MultiplayerOn) then
		MessageSenderController()
	end
end
)
registerHotkey("push", "push", function()
	objectDist = objectDist + 0.5
	debugPrint(10,objectDist)
end
)
registerHotkey("pull", "pull", function()
	objectDist = objectDist - 0.5
	debugPrint(10,objectDist)
end
)
registerHotkey("openRadioPopup", "Cycle Custom Interact", function()
	openRadio()
end
)
registerHotkey("selectcurrentInteractGroup1", "Select 1 Interact Group", function()
	currentInteractGroupIndex = 1
	cycleInteractgroup()
end
)
registerHotkey("selectcurrentInteractGroup2", "Select 2 Interact Group", function()
	currentInteractGroupIndex = 2
	cycleInteractgroup()
end
)
registerHotkey("selectcurrentInteractGroup3", "Select 3 Interact Group", function()
	currentInteractGroupIndex = 3
	cycleInteractgroup()
end
)
registerHotkey("selectcurrentInteractGroup4", "Select 4 Interact Group", function()
	currentInteractGroupIndex = 4
	cycleInteractgroup()
end
)
registerHotkey("selectcurrentInteractGroup5", "Select 5 Interact Group", function()
	currentInteractGroupIndex = 5
	cycleInteractgroup()
end
)

registerHotkey("housingXp", "Housing : X+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true				
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.x = objpos.x + 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingXm", "Housing : X-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true							
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.x = objpos.x - 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingYp", "Housing : Y+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.y = objpos.y + 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingYm", "Housing : Y-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.y = objpos.y - 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingZp", "Housing : Z+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.z = objpos.z + 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingZm", "Housing : Z-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				objpos.z = objpos.z - 0.05
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingRollp", "Housing : Roll+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				angle.roll = angle.roll + 5
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingRollm", "Housing : Roll-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				angle.roll = angle.roll - 5
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingPitchp", "Housing : Pitch+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				angle.pitch = angle.pitch +5
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingPitchm", "Housing : Pitch-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				angle.pitch = angle.pitch -5
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingYawp", "Housing : Yaw+", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = entity:GetWorldPosition()
				local worldpos = Game.GetPlayer():GetWorldTransform()
				local qat = entity:GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				angle.yaw = angle.yaw + 5
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingYawm", "Housing : Yaw-", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.yaw = angle.yaw - 5 
					updateItemPosition(selectedItem, objpos, angle, true)
					cetkeyused = false
				end
			end
		end
	end
end)
registerHotkey("housingMovetoPlayer", "Housing : Move To Player", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				local objpos = Game.GetPlayer():GetWorldPosition()
				local qat = Game.GetPlayer():GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
				cetkeyused = false
			end
		end
	end
end)
registerHotkey("housingRemove", "Housing : Remove", function()
	if(cetkeyused == false)then
		if(selectedItem ~= nil) then
			local entity = Game.FindEntityByID(selectedItem.entityId)
			if(entity ~= nil) then		
				cetkeyused = true			
				for i =1, #currentSave.arrayPlayerItems do
					local mitem = currentSave.arrayPlayerItems[i]
					if(mitem.Tag == selectedItem.Tag) then
						Game.FindEntityByID(selectedItem.entityId):GetEntity():Destroy()
						debugPrint(10,"toto")
						updatePlayerItemsQuantity(mitem,1)
						deleteHousing(selectedItem.Id)
						local index = getItemEntityIndexFromManager(selectedItem.entityId)
						--despawnItem(selectedItem.Id)
						table.remove(currentItemSpawned,index)
						Cron.After(1, function()
							selectedItem = nil
						end)
					end
				end
				cetkeyused = false
				else
				debugPrint(10,"nope")
			end
		end				
	end
end)
registerHotkey("housingcycleplaced", "Housing : Cycle Through placed items", function()
	selectedItem = nil
	if(selectedItem == nil) then
		selectedItem = currentItemSpawned[currentselectedItemIndex]
		Game.GetPlayer():SetWarningMessage("Current Selected Item : "..currentItemSpawned[currentselectedItemIndex].Title)
		currentselectedItemIndex = currentselectedItemIndex+1
		if(currentselectedItemIndex > #currentItemSpawned) then
			currentselectedItemIndex = 1
		end
	end
end)
registerHotkey("hideCustomInteract", "Hide Custom Interact", function()
	hideInteract()
end
)
registerHotkey("ChangeControllermode", "Change Controller mode (mouse/gamepad)", function()
	if(currentController == "gamepad") then
		currentController = "mouse"
		else
		currentController = "gamepad"
	end
	Game.GetPlayer():SetWarningMessage("Current Controller mode : "..currentController)
end
)
registerHotkey("saveLocationInput", "Save location to file in json/report", function()
	savelocation = {}
	savelocation.locations = {}
	savelocation.desc = "location_"..math.random(0,59656518543133)
	savelocation.isFor = ""
	savelocation.tag = desc
	local location = {}
	local inVehicule = false
	inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
	location.x = curPos.x
	location.y = curPos.y
	location.z = curPos.z
	local qat = Game.GetPlayer():GetWorldOrientation()
	local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
	location.pitch = angle.pitch
	location.roll = angle.roll
	location.yaw = angle.yaw
	location.inVehicule = inVehicule
	location.Tag = currentDistricts2.Tag
	if currentDistricts2 ~= nil and #currentDistricts2.districtLabels >0 then
		for i, currentDistricts2 in ipairs(currentDistricts2.districtLabels) do
			if i == 1 then
				location.district = currentDistricts2
				else
				location.subdistrict = currentDistricts2
			end
		end
	end
	table.insert(savelocation.locations,location)
	local file = io.open("json/report/"..savelocation.desc..".json", "w")
	local stringg = JSON:encode_pretty(savelocation)
	debugPrint(10,stringg)
	file:write(stringg)
	file:close()
end
)


registerHotkey("toogleview", 'Toggle View', function()
	if lastView == nil or lastView == 1 then--Normal View
		local fppComp = Game.GetPlayer():GetFPPCameraComponent()
		fppComp:SetLocalPosition(Vector4:new(0.0, 0.0, 0.0, 1.0))
		local isFemale = GetPlayerGender()
		if isFemale == "_Female" then gender = 'Wa' else gender = 'Ma' end
		local headItem = string.format("Items.CharacterCustomization%sHead", gender)
		local ts = Game.GetTransactionSystem()
		local gameItemID = GetSingleton('gameItemID')
		local tdbid = TweakDBID.new(headItem)
		local itemID = gameItemID:FromTDBID(tdbid)
		if(AVisIn == false) then
			Game.EquipItemOnPlayer(headItem, "TppHead")
		end
		lastView = 2
		elseif lastView == 2 then -- 3rd Person View near
		local fppComp = Game.GetPlayer():GetFPPCameraComponent()
		fppComp:SetLocalPosition(Vector4:new(0.0, -3.0, 0, 1.0))
		local isFemale = GetPlayerGender()
		if isFemale == "_Female" then gender = 'Wa' else gender = 'Ma' end
		local headItem = string.format("Items.CharacterCustomization%sHead", gender)
		local ts = Game.GetTransactionSystem()
		local gameItemID = GetSingleton('gameItemID')
		local tdbid = TweakDBID.new(headItem)
		local itemID = gameItemID:FromTDBID(tdbid)
		if(AVisIn == false) then
			Game.AddToInventory(headItem, 1)
			Game.EquipItemOnPlayer(headItem, "TppHead")
		end
		lastView = 3
		elseif lastView == 3 then -- 3rd Person View far
		local fppComp = Game.GetPlayer():GetFPPCameraComponent()
		fppComp:SetLocalPosition(Vector4:new(0.0, -12.0, 1.5, 1.0))
		local isFemale = GetPlayerGender()
		if isFemale == "_Female" then gender = 'Wa' else gender = 'Ma' end
		local headItem = string.format("Items.CharacterCustomization%sHead", gender)
		local ts = Game.GetTransactionSystem()
		local gameItemID = GetSingleton('gameItemID')
		local tdbid = TweakDBID.new(headItem)
		local itemID = gameItemID:FromTDBID(tdbid)
		if(AVisIn == false) then
			Game.EquipItemOnPlayer(headItem, "TppHead")
		end
		lastView = 4
		elseif lastView == 4 then -- 3rd Person View very far
		local fppComp = Game.GetPlayer():GetFPPCameraComponent()
		fppComp:SetLocalPosition(Vector4:new(0.0, -22.0, 5.5, 1.0))
		local isFemale = GetPlayerGender()
		if isFemale == "_Female" then gender = 'Wa' else gender = 'Ma' end
		local headItem = string.format("Items.CharacterCustomization%sHead", gender)
		local ts = Game.GetTransactionSystem()
		local gameItemID = GetSingleton('gameItemID')
		local tdbid = TweakDBID.new(headItem)
		local itemID = gameItemID:FromTDBID(tdbid)
		if(AVisIn == false) then
			Game.EquipItemOnPlayer(headItem, "TppHead")
		end
		lastView = 1
	end
end)
