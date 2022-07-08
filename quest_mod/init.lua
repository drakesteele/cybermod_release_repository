--[[
	
	_____           _                     __  __               _ 
	/ ____|         | |                   |  \/  |             | |
	| |       _   _  | |__     ___   _ __  | \  / |   ___     __| |
	| |      | | | | | '_ \   / _ \ | '__| | |\/| |  / _ \   / _` |
	| |____  | |_| | | |_) | |  __/ | |    | |  | | | (_) | | (_| |
    \_____|  \__, | |_.__/   \___| |_|    |_|  |_|  \___/   \__,_|
	__/ |                                               
	|___/                                                
	
	
	
	-- ------------------------------------------------------------------
	-- -------------------------------How It Works-------------------------------
	-- ------------------------------------------------------------------
	CyberMod By RedRockStudio
	
	
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

print("CyberMod Initialisation...")
function file_exists(filename)
	local f = io.open(filename,"r")
	if f then
		io.close(f)
		return true
	end
	return false
end
function debugPrint(level,value)
	if showLog and value >= debugPrintLevel then
		print(value)
	end		
end
function ModInitialisation()
	
	questMod = { 
		description = "CyberMod",
		version = "0.16000069",
		channel = "stable",
		changelog =""
		
	}
	
	
	
	--version of compiled cache
	cacheVersion = 2
	
	
	
	
	currentSave = {}
	currentSave.Score = {}
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
	questMod.debug = file_exists("debug.txt")
	
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
	CompiledDatapack = require('data/compiled_datapack')
	
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
		print("CyberMod WARNING : Authentication at boot failed, please connect from CyberMod Multiplayer Menu")
		
			
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
			print("CyberMod Session : data found, recover latest data")
			else
			nodata = true
			migrateFromDB()
			print("CyberMod Session : No session data found, migrate from DB")
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
	
	
	if not getUserSetting("currentController") then
		updateUserSetting("currentController", currentController) --initialized in var.lua
		else
		currentController = getUserSetting("currentController")
	end
	if not getUserSetting("enableLocation") then
		updateUserSetting("enableLocation", enableLocation) --initialized in var.lua
		else
		enableLocation = getUserSetting("enableLocation")
	end
	
	if not getUserSetting("showFactionAffinityHud") then
		updateUserSetting("showFactionAffinityHud", showFactionAffinityHud) --initialized in var.lua
		else
		showFactionAffinityHud = getUserSetting("showFactionAffinityHud")
	end
	
	enableLocation = getUserSetting("enableLocation")
	AmbushEnabled = getUserSetting("AmbushEnabled")
	AmbushMin = getUserSetting("AmbushMin")
	ScrollSpeed = getUserSetting("ScrollSpeed")
	ScriptedEntityAffinity = getUserSetting("ScriptedEntityAffinity")
	AmbushMax = getUserSetting("AmbushMax")
	GangWarsEnabled = getUserSetting("GangWarsEnabled")
	AlwaysShowDefaultWindows = getUserSetting("AlwaysShowDefaultWindows")
	AutoAmbush = getUserSetting("AutoAmbush")
	displayXYZset = getUserSetting("displayXYZ")
	AutoRefreshDatapack = getUserSetting("AutoRefreshDatapack")
	
	if not ScrollSpeed then
		ScrollSpeed = 0.002
		updateUserSetting("ScrollSpeed", ScrollSpeed)
	end
	if not ScriptedEntityAffinity then
		ScriptedEntityAffinity = 0
		updateUserSetting("ScriptedEntityAffinity", ScriptedEntityAffinity)
	end
	if not AmbushMin then
		AmbushMin = 300
		updateUserSetting("AmbushMin", AmbushMin)
		else
		AmbushMin = tonumber(AmbushMin)
	end
	AmbushMin = AmbushMin/60
	if not AlwaysShowDefaultWindows then
		AlwaysShowDefaultWindows = 1
		updateUserSetting("AlwaysShowDefaultWindows", AlwaysShowDefaultWindows)
	end
	if not AmbushEnabled then
		AmbushEnabled = 1
		updateUserSetting("AmbushEnabled", AmbushEnabled)
	end
	if not AutoAmbush then
		AutoAmbush = 1
		updateUserSetting("AutoAmbush", AutoAmbush)
	end
	if not displayXYZset then
		displayXYZset = 0
		updateUserSetting("displayXYZset", displayXYZset)
	end
	
	
	
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
	
	
	if not currentSave.arrayFactionDistrict then
		initGangDistrictScore()
	end
	


	if (currentSave.Score["faction_mox"] == nil or currentSave.Score["faction_mox"]["faction_tygerclaws"] == nil) then
		
		 initGangRelation()
	
	end
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

function setupCore() --Setup environnement (observer, overrider)
	
	if( file_exists("data/compiled_datapack.lua") == true ) then
		local file =io.open("data/compiled_datapack.lua")
		local size = file:seek("end")    -- get file size
		file:close()
		if size > 100 then
	
		print("CyberMod : Compiled datapacks Founded, Importing...")
		
		 
		arrayDatapack = CompiledDatapack
	
		
		if(arrayDatapack.CacheVersion ~= nil) then
		
		print("CyberMod : Compiled datapacks cache OK")
		
		
		end
		
		try {
				function()
					if(arrayDatapack == nil or arrayDatapack.CacheVersion== nil or arrayDatapack.modVersion== nil  or arrayDatapack.CacheVersion ~= cacheVersion or arrayDatapack.modVersion ~= questMod.version) then
		
						ImportDataPack()
						print("CyberMod : Version of compiled cache is outdated, generating an new...")
					else
						print("CyberMod : Cache is up to date")
					end
								
					
				end,
				catch {
					function(error)
						print('Error during Import datatpack init: (datapack :data/compiled_datapack.lua) '..error)
						spdlog.error(' during Import datatpack init: (file :data/compiled_datapack.lua) '..error)
						RecoverDatapack()
					end
				}
			}
		
		
		
		print("CyberMod : Compiled datapacks loaded")
		else
		print("CyberMod : Compiled datapacks corrupted, rebuilding...")
			ImportDataPack()
		end
	else
			ImportDataPack()
	end
	
	
	
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
function initCore() --Setup session, external observer and trigger mod core loading
	isGameLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()
	
	resetVar()
	

	
	if GetMod('nativeSettings') then nativeSettings =  GetMod("nativeSettings") else print("!!!!!!!!!!!!!!!!!!!!! CyberMod : No nativeSettings Mod detected, the mod will be broken !!!!!!!!!!!!!!!!!!!!! ") error("!!!!!!!!!!!!!!!!!!!!! CyberMod : No nativeSettings Mod detected, the mod will be broken !!!!!!!!!!!!!!!!!!!!! ") end
	
	
	if GetMod('AppearanceMenuMod') then 
		AMM =  GetMod("AppearanceMenuMod")
		if(AMM.API ~= nil) then
			AMMversion = AMM.API.version
		else
			AMM = nil
			print("CyberMod : AMM doesn't have the require version for work with CyberMod, some props and appearance will not be handled")
		end
	else 
		print("CyberMod : No AMM Mod detected, some props and appearance will not be handled")
	
	end
	
	
	if GetMod('ImmersiveFirstPerson') then GetMod('ImmersiveFirstPerson').api.Disable() print("CyberMod : ImmersiveFirstPerson Mod detected, CyberMod will disable it for avoid some conflicts") end
	
	
	if GetMod('CPStyling') then CPS =  GetMod("CPStyling"):New("questMod") else print("!!!!!!!!!!!!!!!!!!!!! CyberMod : No CPStyling Mod detected, the mod will be broken !!!!!!!!!!!!!!!!!!!!! ") error("!!!!!!!!!!!!!!!!!!!!! CyberMod : No CPStyling Mod detected, the mod will be broken !!!!!!!!!!!!!!!!!!!!! ") end
	
	
	if(nativeSettings ~= nil and nativeSettings.data["CMDT"] ~= nil  ) then
		nativeSettings.data["CMDT"].options = {}
		else
		nativeSettings.addTab("/CMDT", "CyberMod Datapack Manager") -- Add our mods tab (path, label)
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
	
	
	
	
	debugPrint(1,"Mod version "..questMod.version..questMod.channel)
	debugPrint(1,"CyberMod Initialisation...")
	
	
	
	
	
	
	
	
	
	

	questMod.EnemyManager = {}
	questMod.FriendManager = {}
	questMod.NPCManager = {}
	questMod.EntityManager = {}
	questMod.GroupManager = {}
	debugPrint(1,"reset questMod.NPCManager06")
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
	print("CyberMod Initialized")
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
					inScanner = GameUI.IsScanner()
					if(file_exists("success.txt"))then
						updatefinished = true
						updateinprogress = false
						debugPrint(1,"The Mod is updated, GO BACK TO MAIN MENU and reload CET")
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
					
					debugPrint(1,"INIT Core finished")
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

	
	--Targeted entity
	objLook = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(),false,false)
	if(objLook ~= nil) then
		if(objLook ~= nil) then
			tarName = objLook:ToString()
			if(string.match(tarName, "NPCPuppet"))then
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				targName = tostring(objLook:GetTweakDBDisplayName(true))
				openCompanion, gangscore, lookatgang = checkAttitudeByGangScore(objLook)
				
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
		
		openCompanion = false
		objLookIsVehicule = false
	end
	
	--house
	if(currentHouse ~= nil) then
		interactautohide = false
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
			 
			-- debugPrint(1,tostring(obj.id ~= nil))
			
			if isThiscar then
				AVisIn = true
				--debugPrint(1,"AV")
			
				CurrentAVEntity =  vehicule
				local fppComp = Game.GetPlayer():GetFPPCameraComponent()
				--fppComp:SetLocalPosition(Vector4:new(0.0, -12.0, 1.5, 1.0))
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
					local index =getIndexFromGroupManager("AV")
					debugPrint(1,#questMod.GroupManager[index].entities)
					for i=1, #questMod.GroupManager[index].entities do 
						local entityTag = questMod.GroupManager[index].entities[i]
						debugPrint(1,entityTag)
						local obj = getEntityFromManager(entityTag)
						local enti = Game.FindEntityByID(obj.id)
						if(enti ~= nil) then
							despawnEntity(entityTag)
						end
					end
					questMod.GroupManager[index].entities = {}	
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
				--debugPrint(1,"moveit")
				local newAngle = {}
				newAngle.yaw = AVyaw
				newAngle.roll = AVroll
				newAngle.pitch = AVPitch
				teleportTo(enti, enti:GetWorldPosition(), newAngle, false)
			end
		end
	end
	
	--Pause Menu and Ambush timer
	if(inMenu) then
		if(currentSubtitlesGameController ~= nil) then
			currentSubtitlesGameController:Cleanup()
		end
		
		
		if(ActiveMenu == "PauseMenu" ) then
			if(ExecPauseMenu == false) then
				ExecPauseMenu =  true
				
				CheckandUpdateDatapack()
				LoadDataPackCache()
				if cacheupdate == true then
				  exportCompiledDatapack('From Cache Update')
				  cacheupdate = false
				end
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
		
		
		local Ambu = getUserSetting("AmbushMin")	
		
		if(Ambu == nil) then
			Ambu = 300
		end
		
		local ambusec = Ambu*60
	
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
	if curPos ~= nil and healthbarwidget ~= nil and posWdiget ~= nil then
		if(enableLocation == true) then
				
				
				
				
				container:SetVisible(true)
				
				posWdiget:SetMargin(inkMargin.new({ top = 125, left = 3400}))
				posWdiget:SetText(vecToString(curPos))
				posWdiget:SetVisible(true)
				posWdiget:SetTintColor(gamecolor(0,255,255,1))
				
				
				if(AVisIn) then
					avspeedwidget:SetVisible(true)
					avspeedwidget:SetMargin(inkMargin.new({ top = 1825, left = locationWidgetLeft}))
					local speede = math.floor(AVspeed*10)
					avspeedwidget:SetText("Speed : "..tostring(speede).." m/s")
				else
					avspeedwidget:SetVisible(false)
				end
				
				if(currentDistricts2 ~= nil)then
					if(districtState == nil) then
						districtState = "loading"
					end	
					
					if(#currentDistricts2.districtLabels > 0) then
					
						local districttext = ""
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
						
						
						districtWidget:SetMargin(inkMargin.new({ top = 625, left = 3250}))
						districtWidget:SetText(districttext)
						districtWidget:SetVisible(true)
						
						else
						districtWidget:SetText("")
						subdistrictWidget:SetText("")
					end
					
					
					if currentHouse ~= nil then
					
						roomwidget:SetVisible(true)
						
						local test = "Place : "..currentHouse.name
						if(currentRoom ~= nil) then
							test = test.." ".." | Room : "..currentRoom.name
						end
						roomwidget:SetText(test)
						roomwidget:SetTintColor(gamecolor(255,255,255,1))
						roomwidget:SetMargin(inkMargin.new({ top = 675, left = 3250}))
						
						else
						roomwidget:SetVisible(false)
					end
				
					
					if(showFactionAffinityHud == true) then
							factionwidget:SetMargin(inkMargin.new({ top = 120, left = 2800}))
							factionwidget:SetVisible(true)
							factionwidget:RemoveAllChildren()
							
							
							if(#currentDistricts2.districtLabels > 0) then
								if(#currentDistricts2.districtLabels > 1) then
										local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
										for i=1,#gangs do
											local gang = getFactionByTag(gangs[i].tag)
											local top = (i*50)
											locationWidgetPlace_top = locationWidgetFactionDisctrict_top + (i*50) + 50
											
											local isleader = (i==1)
											
											displayGangScoreWidget(getScorebyTag(gangs[i].tag),gang.Name,factionwidget,top,isleader)
										end
									else
										local gangs = getGangfromDistrict(currentDistricts2.districtLabels[1],20)
										for i=1,#gangs do
											local gang = getFactionByTag(gangs[i].tag)
											local top =  (i*10)
											locationWidgetPlace_top = locationWidgetFactionDisctrict_top + (i*50) + 50
											
											local isleader = (i==1)
											
											displayGangScoreWidget(getScorebyTag(gangs[i].tag),gang.Name,factionwidget,top,isleader)
										
										end
								
								end
							else
							factionwidget:SetVisible(false)
							end
				
					else
					
						factionwidget:SetVisible(false)
					end
				
				
				if(ActualPlayerMultiData ~= nil and ActualPlayerMultiData.currentPlaces[1] ~= nil) then
				
					local test = "Multiplayer Place : "..ActualPlayerMultiData.currentPlaces[1].name
					placemultiwidget:SetText(test)
					placemultiwidget:SetTintColor(gamecolor(255,130,0,1))
					placemultiwidget:SetVisible(true)
					placemultiwidget:SetMargin(inkMargin.new({ top = 1725, left = locationWidgetLeft}))
					
					
					else
					
					placemultiwidget:SetVisible(false)
					
				end
				
			
				
				
				local state = "CyberMod Service : Disconnected"
				
				if(multiEnabled == false and multiReady == false) then
					
					state = "CyberMod Service : Disconnected"
					multistatewidget:SetTintColor(gamecolor(255,10,10,1))
					
					elseif (multiEnabled == true and multiReady == false) then
					
					state = "CyberMod Service : Connected"
					multistatewidget:SetTintColor(gamecolor(255,204,29,1))
					
					else
					
					state = "CyberMod Service : Multiplayer enabled"
					multistatewidget:SetTintColor(gamecolor(0,212,45,1))
				end
					
				multistatewidget:SetText(state)
				multistatewidget:SetVisible(true)
				multistatewidget:SetMargin(inkMargin.new({ top = 1775, left = locationWidgetLeft}))
				
				
				
				if(currentTimer ~= nil) then
					local texttimer = currentTimer.message.." : "..tostring(math.ceil((ticktimer/60))).." seconds"
					
					if(currentTimer.type == "remaning") then
						
						
						texttimer =  currentTimer.message.." : "..tostring(currentTimer.value - math.ceil((ticktimer/60))).." seconds"
					
						
					
					end
					
					timerwidget:SetFontSize(75)
					timerwidget:SetMargin(inkMargin.new({ top = 250, left = 1500}))
					timerwidget:SetText(texttimer)
					timerwidget:SetTintColor(gamecolor(255,170,0,1))
					timerwidget:SetVisible(true)
				else
					
					timerwidget:SetVisible(false)
				
				end
				
			else
				container:SetVisible(false)
			end
		else
				container:SetVisible(false)
		end
		
		
		if (multiReady == true) then
			--debugPrint(1,"syncpos")
			syncPosition(curPos,curRot)
			--testFriend(curPos,curRot)
			mpvehicletick = mpvehicletick + 1
			getFriendPos()
			spawnPlayers()
			-- if processingmessage == true then
			-- onlineMessageProcessing()
			-- onlineInstanceMessageProcessing()
			-- processingmessage = false
			-- end
			loadCustomMultiPlace()
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
			action.desc = "You got "..#CurrentOnlineMessage.." online messages."
			action.duration = 3
			local actionlist = {}
			table.insert(actionlist,action)
			runActionList(actionlist, "online_message", "interact",false,"nothing",false)
		end
		CurrentOnlineMessage = {}
		-- if myobs.currentOptions ~= nil  and myobs.id ~= nil and myobs.id < 1  then
		-- if  currentDialogHub ~= nil and lastHubId ~= currentDialogHub.hub.choiceHubs[1].id then
		-- --	createDialog(currentDialogHub.dial)
		-- --	debugPrint(1,"markdial04")
		-- --	lastHubId = currentDialogHub.hub.choiceHubs[1].id
		-- end
		-- end
		-- else
		-- if  myobs ~= nil and myobs.currentOptions == nil and myobs.id ~= nil and myobs.id > 1 then
		-- if  currentDialogHub ~= nil  and lastHubId ~= currentDialogHub.hub.choiceHubs[1].id then
		-- createDialog(currentDialogHub.dial)
		-- lastHubId = myobs.id
		-- else
		-- if candisplayInteract == true then
		-- createInteraction(true)
		-- end
		-- end
		-- else
		-- --if  currentDialogHub ~= nil and lastHubId ~= currentDialogHub.hub.choiceHubs[1].id then
		-- if  currentDialogHub ~= nil and myobs ~= nil and myobs.id ~= nil  and myobs.id > 0 then
		-- createDialog(currentDialogHub.dial)
		-- lastHubId = myobs.id
		-- elseif myobs == nil then
		-- createDialog(currentDialogHub.dial)
		-- lastHubId = myobs.id
		-- end
		-- end
		if activeMetroDisplay == true then
			MetroCurrentTime = MetroCurrentTime - 1
			debugPrint(1,MetroCurrentTime)
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
			Game.GetPlayer():SetWarningMessage("Some controllers are missing after CET reload, reload an save to fix it.")
			if(BraindanceGameController == nil)then
				print("CyberMod : BraindanceGameController is missing !")
			end
			if(TutorialPopupGameController == nil)then
				print("CyberMod : TutorialPopupGameController is missing !")
			end
			if(incomingCallGameController == nil)then
				print("CyberMod : incomingCallGameController is missing !")
			end
			if(currentShardNotificationController == nil)then
				print("CyberMod : currentShardNotificationController is missing !")
			end
			if(currentChattersGameController == nil)then
				print("CyberMod : currentChattersGameController is missing !")
			end
			
			if(MessengerGameController == nil)then
				print("CyberMod : MessengerGameController is missing !")
			end
			if(LinkController == nil)then
				print("CyberMod : LinkController is missing !")
			end
			
		end
	end
	if(tick % 18000 == 0) then
		SalaryIsPossible = true
	end
	

	end
function inGameInit() -- init some function after save loaded

	candrwMapPinFixer= false
	cancheckmission = true
	choiceHubData =  gameinteractionsvisInteractionChoiceHubData.new()
	choiceHubData.active =true 
	choiceHubData.flags = EVisualizerDefinitionFlags.Undefined
	choiceHubData.title = "possibleInteractList" --'Test Interaction Hub'
	spdlog.info("LoadUI01")
	loadUIsetting()
	-- for i=1, #mappinData do
	-- local point = mappinData[i]
	-- spdlog.error(tostring(point.worldPosition.x))
	-- end
	theme = CPS.theme
	color = CPS.color
	questMod.GroupManager = {}
	questMod.EntityManager = {}
	Game.SetTimeDilation(0)
	if(questMod.debug == true) then
		despawnAll()
	end
	doInitEvent()
	setScore("cinematic01","Score",0)
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
	
	

	debugPrint(1,"Yet Choom")
	draw = true
	
	if file_exists("net/multi/player/connect.txt") == false then
		Game.GetPlayer():SetWarningMessage("Authentication at mod boot failed, please connect from CyberMod Multiplayer Menu")
		else
		Game.GetPlayer():SetWarningMessage(lang.ImmersiveRoleplayModLoaded)
		
		
			openNetContract = false
			io.open("net/multienabled.txt","w"):close()
			multiReady = false
			multiEnabled = true
		
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
	print("CyberMod Script Engine Started")
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
			--or (ActiveMenu == "Hub")
			if questMod.debug then
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
		end
		
		if openNetContract then
			ContractWindows()
		end
		
		end
		if(openColorPicker) then
			colorPicker() 
		end
		if(onlineMessagePopup or (ActiveSubMenu == "Phone")) then
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
			debugPrint(1,tostring(multiName))
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
		if multiReady then
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
	debugPrint(1,"mappin deleted")
	despawnAll()
	resetVar()
	collectgarbage()
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

	local f = assert(io.open("data/db/vehicles.json"))
	local lines = f:read("*a")
	local encdo = lines
	local tableDis = {}
	tableDis =json.decode(lines)
	--debugPrint(1,"District Imported")
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
		print("CyberMod : Vehicles unlocked")	
		

	TweakDB:SetFlat("PreventionSystem.setup.totalEntitiesLimit", 50)
	
end)


-- -------------------------------HotKey------------------------------
registerHotkey("cycleCustomInteract", "Cycle Custom Interact", function()
	cycleInteract()
end
)
registerHotkey("onlineSendPopup", "Show Online Message Popup", function()
	if(multiEnabled and multiReady) then
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
registerHotkey("onlineSendMessage", "Send an Message to Current Selected Player", function()
	if(multiEnabled and multiReady) then
		MessageSenderController()
	end
end
)
registerHotkey("push", "push", function()
	objectDist = objectDist + 0.5
	debugPrint(1,objectDist)
end
)
registerHotkey("pull", "pull", function()
	objectDist = objectDist - 0.5
	debugPrint(1,objectDist)
end
)
registerHotkey("openRadioPopup", "Open Radio Popup", function()
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
registerHotkey("openRadioPopup", "Open Radio Popup", function()
	openRadio()
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
						debugPrint(1,"toto")
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
				debugPrint(1,"nope")
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
	debugPrint(1,stringg)
	file:write(stringg)
	file:close()
end
)

registerHotkey('radioPopup', 'Open Radio', function()
	openRadio()
end)
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
