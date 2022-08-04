debugPrint(3,"CyberScript: UI module loaded")
questMod.module = questMod.module + 1

---Misc Function---
function showInputHint(key, text, prio, holdAnimation, tag)
	
	local hold = holdAnimation or false
	
	local evt = UpdateInputHintEvent.new()
	
	local data = InputHintData.new()
	data.action = key
	data.source = "CyberScript"
	data.
	localizedLabel = text
	data.enableHoldAnimation = hold
	data.sortingPriority  = prio or 1
	evt = UpdateInputHintEvent.new()
	evt.data = data
	evt.show = true
	evt.targetHintContainer = "GameplayInputHelper"
	Game.GetUISystem():QueueEvent(evt)
	table.insert(currentInputHintList, {tag = tag, key = key})
end

function hideCustomHints(tag)
	
	local evt = DeleteInputHintBySourceEvent.new()
	evt.source = "CyberScript"
	evt.targetHintContainer = "GameplayInputHelper"
	Game.GetUISystem():QueueEvent(evt)
end

function openanpage(page)
	irpmenu.main = false
	irpmenu.contact = false
	irpmenu.fixer = false
	irpmenu.service = false
	irpmenu.social = false
	irpmenu.address = false
	irpmenu.radio = false
	irpmenu.tools = false
	irpmenu.multi = false
	irpmenu.editor = false
	irpmenu[page] = true
end

function getcurrentpage()
	
	local page = "main"
	for k,v in pairs(irpmenu) do
		
		if v then
			page = k
		end
	end
	return page
end

function loadUIsetting()
	
	local scr_w, scr_h = GetDisplayResolution()
	locationWindowsX = locationWindowsX or getUserSetting("locationWindowsX")
	locationWindowsY = locationWindowsY or getUserSetting("locationWindowsY")
	
	if locationWindowsX > scr_w or locationWindowsY > scr_h then
		locationWindowsX = 35
		locationWindowsY = 355
	end
end

function makeNativeSettings()
	
	nativeSettings.addTab("/CM", getLang("ui_setting_main")) -- Add our mods tab (path, label)
	if (ScriptedEntityAffinity == nil or
	AutoAmbush == nil or
	AmbushEnabled== nil or
	AmbushMin== nil or
	enableLocation== nil or
	showFactionAffinityHud== nil or
	displayXYZset== nil or
	InfiniteDoubleJump==nil or
	DisableFallDamage==nil or
	Player_Sprint_Multiplier==nil or
	Player_Run_Multiplier==nil or
	Jump_Height==nil or
	Double_Jump_Height==nil) then
	local obj = {}
	
	obj.AutoAmbush = tostring(AutoAmbush)
	obj.AmbushEnabled = tostring(AutoAmbush)
	obj.ScriptedEntityAffinity = tostring(ScriptedEntityAffinity)
	obj.enableLocation = tostring(enableLocation)
	obj.showFactionAffinityHud = tostring(showFactionAffinityHud)
	obj.displayXYZset = tostring(displayXYZset)
	obj.InfiniteDoubleJump = tostring(InfiniteDoubleJump)
	obj.DisableFallDamage = tostring(DisableFallDamage)
	obj.Player_Sprint_Multiplier = tostring(Player_Sprint_Multiplier)
	obj.Player_Run_Multiplier = tostring(Player_Run_Multiplier)
	obj.Jump_Height = tostring(Jump_Height)
	obj.Double_Jump_Height = tostring(Double_Jump_Height)
	
	spdlog.error(dump(obj))
	
	
	nativeSettings.addSubcategory("/CM/gameplay", "Ooops there is an mising setting in CyberScript Setting !")
	nativeSettings.addSubcategory("/CM/gameplay01", "Try rebuild the cache and reload the mod/save/game !")
	nativeSettings.addSubcategory("/CM/gameplay02", "Send quest_mod.log to discord Admin on Cyberscript Discord !")
	
	
		
	
 
	nativeSettings.addButton("/CM/gameplay02", "Reset the mod", "Will totaly delete downloaded datapack, cache and latest session", "Reset the mod", 45, function()
	
	if file_exists("data/sessions/latest.txt") then
		os.remove("data/sessions/latest.txt")
	end
	
	for k,v in arrayDatapack do
			if(k ~="default") then
			DeleteModpack(k)
			end
	end
	
	local reader = dir("data/cache")
	
	for i=1, #reader do 
		if(tostring(reader[i].type) ~= "directory" and reader[i].name ~= "placeholder") then
			
				os.remove('data/cache/'..reader[i].name)
	
	
			
			
		end
	end
	
	
 	ImportDataPack()
	LoadDataPackCache()
	debugPrint(2, getLang("ui_setting_actions_rebuild_done"))
 	
 end)
 
 
	
	
	else
	local status, result =  pcall(function()
	nativeSettings.addSubcategory("/CM/gameplay", getLang("ui_setting_gameplay")) -- Optional: Add a subcategory (path, label), you can add as many as you want
	
	settingsTables["gamepad"] =  
	nativeSettings.addSwitch("/CM/gameplay",  getLang("ui_setting_gameplay_controller"),  getLang("ui_setting_gameplay_controller"), currentController == "gamepad", false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		currentController = state == false and "mouse" or "gamepad"
		updateUserSetting("currentController", state)
	end)
	
	
	settingsTables["radio"] = 
	nativeSettings.addRangeInt("/CM/gameplay",  getLang("ui_setting_gameplay_radio"),  getLang("ui_setting_gameplay_radio"), 0, 100, 1, currentRadioVolume, currentRadioVolume, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		currentRadioVolume = value
	end)
	
	
	nativeSettings.addRangeFloat("/CM/gameplay", getLang("ui_setting_gameplay_scroll"),  getLang("ui_setting_gameplay_scroll"), 0.001, 0.1, 0.001, "%.3f", ScrollSpeed, ScrollSpeed, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		pcall(function() 
		ScrollSpeed = tonumber(string.format("%.3f", value))
		updateUserSetting("ScrollSpeed", ScrollSpeed)
		end)
	end)
	
	
	
	nativeSettings.addSubcategory("/CM/script", "Script Engine Settings")
	
	nativeSettings.addSwitch("/CM/script", getLang("Scripted Entity Affinity"), getLang("Gang Affinity affect Scripted Entities From Script Engine"), ScriptedEntityAffinity, ScriptedEntityAffinity, function(state) -- path, label, desc, currentValue, defaultValue, callback
		ScriptedEntityAffinity = state
		updateUserSetting("ScriptedEntityAffinity", ScriptedEntityAffinity)
	end)
	
	nativeSettings.addSwitch("/CM/script", getLang("AutoAmbushToggle"), getLang("AutoAmbushToggle"), AutoAmbush, true, function(state) -- path, label, desc, currentValue, defaultValue, callback
		AutoAmbush = state
		updateUserSetting("AutoAmbush", AutoAmbush)
	end)
	
	nativeSettings.addSwitch("/CM/script", getLang("EnableDisableAmbush"), getLang("EnableDisableAmbush"), AmbushEnabled, true, function(state) -- path, label, desc, currentValue, defaultValue, callback
		AmbushEnabled = state
		updateUserSetting("AmbushEnabled", AmbushEnabled)
	end)
	
	nativeSettings.addRangeInt("/CM/script", getLang("SetAmbushMinTime"), getLang("SetAmbushMinTime"), 1, 120, 1, AmbushMin, 5, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		AmbushMin = value
		updateUserSetting("AmbushMin", value)
	end)
	
	
	nativeSettings.addSubcategory("/CM/hud",getLang("ui_setting_display"))
	
	nativeSettings.addSwitch("/CM/hud", getLang("ui_setting_display_hud"), getLang("ui_setting_display_hud"), enableLocation, true, function(state) -- path, label, desc, currentValue, defaultValue, callback
		enableLocation = state
		updateUserSetting("enableLocation", state)
	end)
	
	nativeSettings.addSwitch("/CM/hud", getLang("ui_setting_display_hud_gang"), getLang("ui_setting_display_hud_gang"), showFactionAffinityHud, true, function(state) -- path, label, desc, currentValue, defaultValue, callback
		showFactionAffinityHud = state
		updateUserSetting("showFactionAffinityHud", state)
	end)
	
	nativeSettings.addSwitch("/CM/hud", getLang("ui_setting_display_hud_xyz"), getLang("ui_setting_display_hud_xyz"), displayXYZset, false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		displayXYZset = state
		updateUserSetting("displayXYZ", displayXYZset)
	end)
	
	
	
	
	nativeSettings.addSubcategory("/CM/actions",getLang("ui_setting_actions"))
	
	nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_untrackquest"), getLang("ui_setting_actions_untrackquest"),"Untrack", 45, function()
 	Game.untrack()
 	
 end)
	
	nativeSettings.addButton("/CM/actions",  getLang("ui_setting_actions_resetquest"),  getLang("ui_setting_actions_resetquest"), "Reset CM Quest", 45, function()
 		if currentQuest then
			closeQuest(currentQuest)
		end
 	
 end)
 
	nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_cleanthemess"), getLang("ui_setting_actions_cleanthemess"), "Clean the mess", 45, function()
 		
		despawnAll()
		workerTable = {}
 	
 end)
	
	nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_recalculateaffinity"), getLang("ui_setting_actions_recalculateaffinity_msg"),"Recalculate", 45, function()
		
		
		for k,v in pairs(arrayFaction) do
			setScore(k, "Score", 0)
		end
	
		
		for i=1, #arrayPnjDb do
			setScore(arrayPnjDb[i].Names, "Score", 0)
			
		end
		
		
		GangAffinityCalculator()
 
 end)
 
 nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_cleareaffinity"), getLang("ui_setting_actions_recalculateaffinity_msg"),"Clear", 45, function()
		for k,v in pairs(arrayFaction) do
			setScore("Affinity",k, 0)
		end
		for i=1, #arrayPnjDb do
			setScore("Affinity",arrayPnjDb[i].Names, 0)
		end
	
 	
 end)
	nativeSettings.addSwitch("/CM/actions", getLang("ui_setting_actions_auto_refresh"), getLang("ui_setting_actions_auto_refresh"), AutoRefreshDatapack, AutoRefreshDatapack, function(state) -- path, label, desc, currentValue, defaultValue, callback
		AutoRefreshDatapack = state
		updateUserSetting("AutoRefreshDatapack", AutoRefreshDatapack)
	end)
	
	nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_refresh"), getLang("ui_setting_actions_refresh"), "Refresh", 45, function()
	CheckandUpdateDatapack()
	LoadDataPackCache()
	debugPrint(2,"CyberScript : Datapack Cache refreshed")
 	
 end)
 
	nativeSettings.addButton("/CM/actions", getLang("ui_setting_actions_rebuild"), getLang("ui_setting_actions_rebuild"), "Rebuild", 45, function()
	
	local reader = dir("data/cache")
	
	for i=1, #reader do 
		if(tostring(reader[i].type) ~= "directory" and reader[i].name ~= "placeholder") then
			
				os.remove('data/cache/'..reader[i].name)
	
	
			
			
		end
	end
	
	
 	ImportDataPack()
	LoadDataPackCache()
	debugPrint(2, getLang("ui_setting_actions_rebuild_done"))
 	
 end)
 
 nativeSettings.addButton("/CM/actions", "Reset the mod", "Will totaly delete download datapack, cache and latest session", "Reset the mod", 45, function()
	
	if file_exists("data/sessions/latest.txt") then
		os.remove("data/sessions/latest.txt")
	end
	
	for k,v in arrayDatapack do
	
			if(k ~="default") then
			debugPrint(10,k)
			DeleteModpack(k)
			end
	end
	
	local reader = dir("data/cache")
	
	for i=1, #reader do 
		if(tostring(reader[i].type) ~= "directory" and reader[i].name ~= "placeholder") then
			
				os.remove('data/cache/'..reader[i].name)
	
	
			
			
		end
	end
	
	
 	ImportDataPack()
	LoadDataPackCache()
	debugPrint(2, getLang("ui_setting_actions_rebuild_done"))
 	
 end)
 
 
 
	nativeSettings.addTab("/CMCHEAT", getLang("ui_setting_cheat")) -- Add our mods tab (path, label)
	
	nativeSettings.addSubcategory("/CMCHEAT/player", getLang("ui_setting_cheat")) -- Optional: Add a subcategory (path, label), you can add as many as you want
	
	nativeSettings.addSwitch("/CMCHEAT/player",  getLang("ui_setting_cheat_infinite_doublejump"),  getLang("ui_setting_cheat_infinite_doublejump"), InfiniteDoubleJump, false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		InfiniteDoubleJump = state
		updateUserSetting("InfiniteDoubleJump", InfiniteDoubleJump)
	end)
	
	nativeSettings.addSwitch("/CMCHEAT/player",  getLang("ui_setting_cheat_disable_fall_damage"),  getLang("ui_setting_cheat_disable_fall_damage"), DisableFallDamage, false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		DisableFallDamage = state
		updateUserSetting("DisableFallDamage", DisableFallDamage)
	end)
	
	nativeSettings.addRangeFloat("/CMCHEAT/player", getLang("ui_setting_cheat_player_sprint"),  getLang("ui_setting_cheat_player_sprint"), 1, 10, 0.1, "%.1f", Player_Sprint_Multiplier, 1, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		pcall(function() 
		Player_Sprint_Multiplier = tonumber(string.format("%.1f", value))
		updateUserSetting("Player_Sprint_Multiplier", Player_Sprint_Multiplier)
		TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Sprint_inline1.value", 6.5 * Player_Sprint_Multiplier)
		TweakDB:Update("PlayerLocomotion.player_locomotion_data_Sprint_inline1.value")
		
		-- local newMod = gameConstantStatModifierData.new()
		-- newMod.statType = 619
		-- newMod.modifierType = 2
		-- newMod.value = Player_Sprint_Multiplier
		
		-- Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(),newmod)
		
		end)
	end)
	
	nativeSettings.addRangeFloat("/CMCHEAT/player", getLang("ui_setting_cheat_player_run"),  getLang("ui_setting_cheat_player_run"), 1, 10, 0.1, "%.1f", Player_Run_Multiplier, 1, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		pcall(function() 
		Player_Run_Multiplier = tonumber(string.format("%.1f", value))
		updateUserSetting("Player_Run_Multiplier", Player_Run_Multiplier)
		TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_Stand_inline1.value", 3.5 * Player_Run_Multiplier)
		TweakDB:Update("PlayerLocomotion.player_locomotion_data_Stand_inline1.value")
		
		-- local newMod = gameConstantStatModifierData.new()
		-- newMod.statType = 619
		-- newMod.modifierType = 2
		-- newMod.value = Player_Run_Multiplier
		
		-- Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(),newmod)
		end)
	end)

	
	nativeSettings.addRangeFloat("/CMCHEAT/player", getLang("ui_setting_cheat_jump_height"),  getLang("ui_setting_cheat_jump_height"), 1, 10, 0.1, "%.1f", Jump_Height, 1, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		pcall(function() 
		Jump_Height = tonumber(string.format("%.1f", value))
		updateUserSetting("Jump_Height", Jump_Height)
		TweakDB:SetFlat("PlayerLocomotion.JumpJumpHeightModifier.value", 1 * Jump_Height)
		TweakDB:Update("PlayerLocomotion.JumpJumpHeightModifier.value")
		
		-- local newMod = gameConstantStatModifierData.new()
		-- newMod.statType = 596
		-- newMod.modifierType = 2
		-- newMod.value = Jump_Height
		
		-- Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(),newmod)
		
		end)
	end)
	
	nativeSettings.addRangeFloat("/CMCHEAT/player", getLang("ui_setting_cheat_doublejump_height"),  getLang("ui_setting_cheat_doublejump_height"), 1, 10, 0.1, "%.1f", Double_Jump_Height, 1, function(value) -- path, label, desc, min, max, step, currentValue, defaultValue, callback
		pcall(function() 
		Double_Jump_Height = tonumber(string.format("%.1f", value))
		updateUserSetting("Double_Jump_Height", Double_Jump_Height)
		TweakDB:SetFlat("PlayerLocomotion.DoubleJumpJumpHeightModifier.value", 2.6 * Double_Jump_Height)
		TweakDB:Update("PlayerLocomotion.DoubleJumpJumpHeightModifier.value")
		
		-- local newMod = gameConstantStatModifierData.new()
		-- newMod.statType = 596
		-- newMod.modifierType = 2
		-- newMod.value = Jump_Height
		
		-- Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(),newmod)
		end)
	end)

	
	nativeSettings.addSwitch("/CMCHEAT/player",  getLang("ui_setting_cheat_debug_options"),  getLang("ui_setting_cheat_debug_options"), debugOptions, false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		debugOptions = state
		
	end)
	
	nativeSettings.addSwitch("/CMCHEAT/player",  getLang("ui_setting_cheat_debug_log"),  getLang("ui_setting_cheat_debug_log"), debugLog, false, function(state) -- path, label, desc, currentValue, defaultValue, callback
		debugLog = state
		
	end)
	
	
	end)
	
	if status == false then
		
		
		
			spdlog.error(result)
			
			nativeSettings.addSubcategory("/CM/gameplay", "Ooops there is an error in CyberScript Setting !")
	nativeSettings.addSubcategory("/CM/gameplay01", "Try rebuild the cache and reload the mod/save/game !")
	nativeSettings.addSubcategory("/CM/gameplay02", "Send quest_mod.log to discord Admin on Cyberscript Discord !")
	
	
		
	
 
	nativeSettings.addButton("/CM/gameplay02", "Reset the mod", "Will totaly delete download datapack, cache and latest session", "Reset the mod", 45, function()
	
	if file_exists("data/sessions/latest.txt") then
		os.remove("data/sessions/latest.txt")
	end
	
	for k,v in arrayDatapack do
			if(k ~="default") then
			DeleteModpack(k)
			end
	end
	
	local reader = dir("data/cache")
	
	for i=1, #reader do 
		if(tostring(reader[i].type) ~= "directory" and reader[i].name ~= "placeholder") then
			
				os.remove('data/cache/'..reader[i].name)
	
	
			
			
		end
	end
	
	
 	ImportDataPack()
	LoadDataPackCache()
	debugPrint(2, getLang("ui_setting_actions_rebuild_done"))
 	
 end)
		end
	
	
	end
	end


---IMGUI UI---
function newWindows()
	
	if not ImGui.Begin(getLang("ui_menu")) then return end
	ImGui.SetNextWindowPos(800, 800, ImGuiCond.Appearing) -- set window position x, y
	ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
	ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
	ImGui.SetWindowFontScale(menufont)
	ImGui.BeginChild("around", menuFrameX, menuFrameY)
	
	if getcurrentpage() ~= "main" then
		
		if ImGui.Button(getLang("back"), menuBTNX*2, menuBTNY) then
			
			if getcurrentpage() == "service" then
				openHelpMenu = false
				elseif getcurrentpage() == "editor" then
				resetEditorObject()
				openEditor = false
				elseif getcurrentpage() == "multi" then
				openNetContract = false
				
			end
			openanpage("main")
		end
		ImGui.Spacing()
	end
	
	if getcurrentpage() == "main" then
		ImGui.BeginChild("line2", menuRowX, menuRowY)
		
		if nativesettingEnabled == false then
			
			if ImGui.Button(getLang("tools"), menuBTNX, menuBTNY) then
				openanpage("tools")
			end
		end
		
		if ImGui.Button(getLang("ui_menu_online"), menuBTNX, menuBTNY) then
			openanpage("multi")
		end
		ImGui.SameLine()
		
		if ImGui.Button(getLang("editor"), menuBTNX, menuBTNY) then
			openanpage("editor")
		end
		ImGui.EndChild()
		elseif getcurrentpage() == "editor" then
		openEditor = true
		elseif getcurrentpage() == "multi" then
		openNetContract = true
	end
	ImGui.EndChild()
end

function loadHUD()
	
		displayHUD = {}
		
		for k,v in pairs(arrayHUD) do
			local hud = v.hud
			if(hud.type == "container") then
				displayHUD[k] = inkCanvas.new()
				displayHUD[k]:SetName(CName.new(hud.tag))
				displayHUD[k]:SetAnchor(inkEAnchor.Fill)
				displayHUD[k]:Reparent(rootContainer, -1)
				debugPrint(10,"create "..hud.tag)
			
			end
		end
		
		
		for k,v in pairs(arrayHUD) do
			local hud = v.hud
			if(hud.type == "container") then
				if(hud.container == nil or hud.container == "default" or  hud.container == "") then
					displayHUD[k]:Reparent(rootContainer, -1)
				else
					displayHUD[k]:Reparent(displayHUD[hud.container], -1)
				end
				
			
			end
		end
		
		for k,v in pairs(arrayHUD) do
			local hud = v.hud
			if(hud.type == "widget") then
				displayHUD[k] = inkText.new()
				displayHUD[k]:SetName(CName.new(hud.tag))
				displayHUD[k]:SetMargin(inkMargin.new({ top = hud.margin.top, left = hud.margin.left}))
				displayHUD[k]:SetFontFamily(hud.fontfamily)
				displayHUD[k]:SetFontStyle(hud.fontstyle)
				displayHUD[k]:SetFontSize(hud.fontsize)
				displayHUD[k]:SetTintColor(gamecolor(hud.color.red,hud.color.green,hud.color.blue,1))
				displayHUD[k]:SetVisible(hud.visible)
				displayHUD[k]:SetHorizontalAlignment(textHorizontalAlignment.Center)
				displayHUD[k]:SetVerticalAlignment(textVerticalAlignment.Center)
				
				if(hud.container == nil or hud.container == "default" or hud.container == "") then
					displayHUD[k]:Reparent(container, -1)
				else
					displayHUD[k]:Reparent(displayHUD[hud.container], -1)
				end
				debugPrint(10,"create "..hud.tag)
			end
		
		end
	
end

function ImageFrame()
	
	for k,v in pairs(currentLoadedTexture) do
	
	ImGui.SetWindowFontScale(2)
	CPS.colorBegin("WindowBg", {v.bgcolor , v.bgopacity})
	CPS.colorBegin("Text", {v.titlecolor , v.titleopacity})
	CPS.colorBegin("Border", {v.bordercolor , v.borderopacity})
	
	CPS.colorBegin("TextDisabled", {"000000" , 0})
	CPS.colorBegin("FrameBg", {"000000" , 0})
	CPS.colorBegin("TitleBg", {"000000" , 0})
	
	CPS.colorBegin("TitleBgActive", {"000000" , 0})
	CPS.colorBegin("Header", {"000000" , 0})
	CPS.colorBegin("ScrollbarBg", {"000000" , 0})
	
	CPS.colorBegin("ScrollbarGrab", {"000000" , 0})
	CPS.colorBegin("ScrollbarGrabHovered", {"000000" , 0})
	CPS.colorBegin("ScrollbarGrabActive", {"000000" , 0})
	
	if ImGui.Begin(v.title) then 
	
	local windowWidth = 220
	local screenWidth, screenHeight = GetDisplayResolution()
	local screenRatioX, screenRatioY = screenWidth / 1920, screenHeight / 1200
	
	
	local posx = v.size.x +v.position.x
	ImGui.SetWindowSize(v.size.x, v.size.y)
	
	ImGui.SetWindowPos(  v.position.x * screenRatioX, v.position.y * screenRatioY)
	
	
	ImGui.Image(v.texture)

	
	ImGui.End()
	ImGui.SetWindowFontScale(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	end
	
	
	end
	
end

function debugWindows()
	
	if CPS == nil then return end
	CPS:setThemeBegin()
	
	if not ImGui.Begin("Debug Windows") then
		CPS:setThemeEnd()
		return
	end
	ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
	ImGui.SetNextWindowSize(300, 800, ImGuiCond.Appearing) -- set window size w, h
	
	if not ImGui.BeginTabBar("AdressTabs", ImGuiTabBarFlags.NoTooltip) then
		ImGui.End()
		CPS:setThemeEnd()
		return
	end
	
	
	
	CPS.styleBegin("TabRounding", 0)
	
	if ImGui.BeginTabItem("Command") then
		local status, result =  pcall(function()
			ImGui.TextColored(0.79, 0.40, 0.29, 1, "Enable Console : "..tostring(showLog))
			if CPS:CPButton("Toggle Console Log") then
				showLog = not showLog
			end
			ImGui.TextColored(0.79, 0.40, 0.29, 1, "tick is .."..tostring(tick))
			ImGui.TextColored(0.79, 0.40, 0.29, 1, "Current Controller is .."..tostring(currentController))
			charatabledebug = {}
			
			if CPS:CPButton("TP to Custom MapPin") then
				
				if(ActivecustomMappin ~= nil) then
					
					local pos = ActivecustomMappin:GetWorldPosition()
					Game.TeleportPlayerToPosition(pos.x,pos.y,pos.z)
				end
			end
			pox = ImGui.InputInt("X", pox)
			poy = ImGui.InputInt("Y", poy)
			poz = ImGui.InputInt("Z", poz)
			
			if CPS:CPButton("TP to XYZ") then
				Game.TeleportPlayerToPosition(pox,poy,poz)
			end
			
			local chara = ImGui.InputText("chara", "", 100, ImGuiInputTextFlags.AutoSelectAll)
			ImGui.Text("Selected Character :"..chara)
			
			if CPS:CPButton("Spawn Character") then
				
				local positionVec4 = Game.GetPlayer():GetWorldPosition()
				
				local entity = nil
				entity = Game.GetPlayer()
				positionVec4.x = positionVec4.x + 2
				positionVec4.y = positionVec4.y + 2
				
				local tag = "debug_"..tostring(math.random(0,999999)) --asigned but never used
				spawnEntity(chara, tag, positionVec4.x, positionVec4.y, positionVec4.z, 97, false, false, false)
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Finish game quest") then
				
				local jm = Game.GetJournalManager()
				
				local te = jm:GetTrackedEntry()
				
				local qe = jm:GetParentEntry(jm:GetParentEntry(te))
				
				local qeh = jm:GetEntryHash(qe)
				jm:ChangeEntryStateByHash(qeh, "Succeeded", "Notify")
				debugPrint(6,"Current game active quest ended")
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Close DB (need reload mod after this)") then
				db:close()
				db = nil
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Keystone Net Window") then
				openNetContract = true
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Toggle Invincible") then
				
				if not isGodMod then
					Game.GetGodModeSystem():EnableOverride(Game.GetPlayer():GetEntityID(), "Invulnerable", CName.new("SecondHeart"))
					else
					Game.GetGodModeSystem():DisableOverride(Game.GetPlayer():GetEntityID(), CName.new("SecondHeart"))
				end
			end
			
			if CPS:CPButton("Despawn All") then
				workerTable = {}
				despawnAll()
			end
			ImGui.Spacing()
			for k,v  in pairs(arrayFaction) do
				
				if CPS:CPButton("Increase "..arrayFaction[k].faction.Name.." Affinity by 5") then
					addFactionScoreByTagScore(k, 5)
					
				end
				
				if CPS:CPButton("Decrease "..arrayFaction[k].faction.Name.." Affinity by 5") then
					addFactionScoreByTagScore(k, -5)
					
				end
			end
			ImGui.Spacing()
			
			if ImGui.BeginCombo("##minpc", npcchara) then -- Remove the ## if you'd like for the title to display above combo box
										
										
										
				for i=1, #arrayListCharacter do
					
					if ImGui.Selectable(arrayListCharacter[i], (arrayListCharacter[i] == npcchara)) then
						
						npcchara = arrayListCharacter[i]
						ImGui.SetItemDefaultFocus()
					end
					
				end
				
				ImGui.EndCombo()
			end
			ImGui.Spacing()
			if CPS:CPButton("Increase "..npcchara.." Affinity by 1") then
					addAffinityScoreByNPCId(npcchara)
					
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Reset All Affinity") then
				for k,v in pairs(arrayFaction) do
					updateFactionScore(k, 0)
					reloadDB()
				end
				
				for i=1,#arrayPnjDb do
					local pnj = arrayPnjDb[i]
					if(currentSave.Score["Affinity"][pnj.Names] ~= nil) then
						
						currentSave.Score["Affinity"][pnj.Names] = nil
						
					end
				end
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Spawn Ambush") then
				checkAmbush()
			end
			
			
			ImGui.Spacing()
			for i=1, #arrayPhoneNPC do
				
				if CPS:CPButton("Increase "..arrayPhoneNPC[i].Names.." Affinity by 1") then
					addAffinityScoreByNPCId(arrayPhoneNPC[i].Names)
					reloadDB()
				end
				
				if CPS:CPButton("Decrease "..arrayPhoneNPC[i].Names.." Affinity by 1") then
					addAffinityScoreByNPCIdScore(arrayPhoneNPC[i].Names,-1)
					reloadDB()
				end
			end
			ImGui.Spacing()
			
			if CPS:CPButton("Reload DB") then
				reloadDB()
			end
			
			if CPS:CPButton("Reload datapack") then
				ImportMissionPack()
				loadMissionPack()
			end
			
			if CPS:CPButton("Get mission by trigger") then
				getMissionByTrigger()
				debugPrint(6,"enabled mission"..#possibleQuest)
			end
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			
			if CPS:CPButton("showFaction")  then
				for k,v in pairs(arrayFaction)do
					debugPrint(6,k)
				end
			end
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			inputquest = ImGui.InputText("quest", inputquest, 100, ImGuiInputTextFlags.AutoSelectAll)
			ImGui.Text("Selected Quest :"..inputquest)
			
			if CPS:CPButton("Start Mission") then
				setScore(inputquest, "Score", 0)
			end
			ImGui.Spacing()
			
			if CPS:CPButton("reset debug quest") then
				updateQuestStatut(inputquest, 0)
			end
			
			if CPS:CPButton("check quest conditions") then
				
				local qu = getQuestByTag(inputquest)
				debugPrint(6,testTriggerRequirement(qu.trigger_condition_requirement,qu.trigger_condition))
				debugPrint(6,testTriggerRequirement(qu.start_condition_requirement,qu.start_condition))
				debugPrint(6,testTriggerRequirement(qu.end_condition_requirement,qu.end_condition))
				debugPrint(6,testTriggerRequirement(qu.failure_condition_requirement,qu.failure_condition))
			end
			ImGui.Spacing()
			-- inputkey = ImGui.InputText("Score/Variable Key", inputkey, 100, ImGuiInputTextFlags.AutoSelectAll)
			-- ImGui.Spacing()
			-- inputscore = ImGui.InputText("Score Tag", inputscore, 100, ImGuiInputTextFlags.AutoSelectAll)
			-- ImGui.Text("For the Score :"..inputscore.." for the key "..inputkey.." the value is "..tonullstring(getScoreKey(inputscore,inputkey)))
			-- ImGui.Text("For the Score :"..inputscore.." for the default score the value is "..tonullstring(getScoreKey(inputscore,"Score")))
			-- ImGui.Spacing()
			-- inputvariable = ImGui.InputText("Variable Tag", inputvariable, 100, ImGuiInputTextFlags.AutoSelectAll)
			-- ImGui.Text("For the Variable :"..inputvariable.." for the key "..inputkey.." the value is "..tonullstring(getVariableKey(inputvariable,inputkey)))
		 end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	if ImGui.BeginTabItem("Entity Inspector") then
		local status, result =  pcall(function()
		if objLook ~= nil then
			ImGui.Indent()
			
			local entity = objLook
			-- Functions
			IGE.DrawNodeTree("GetEntityID", "entEntityID", entity:GetEntityID(), 
			function(entEntityID) entEntityIDDraw(entEntityID) end)
			
			if ImGui.Button("Destroy") then
				entity:Dispose()
			end
			
			
			if entity:IsPlayer() then
				IGE.DisplayObjectArray("GetPlayerCurrentWorkspotTags", "CName", entity:GetPlayerCurrentWorkspotTags(),
				function(key, value) CNameDraw("Tag", value) end)
			end
			
			if entity:IsVehicle() then
				ImGui.Text("Entity is an vehicle")
				ImGui.Spacing()
				ImGui.Text("Available Seats Slot: ")
				
				local seatstable = GetSeats(entity)
				
				if #seatstable > 0 then
					for i=1, #seatstable do 
						ImGui.Text(seatstable[i])
						ImGui.Spacing()
					end
				end
				else
				ImGui.Text("Entity is not an vehicule")
				ImGui.Spacing()
			end
			
			local obj = getEntityFromManagerById(entity:GetEntityID())
			
			if obj.id ~= nil then
				ImGui.Text("This entity has been registered as Entity in CyberScript with tag "..obj.tag)
				ImGui.Spacing()
				
				ImGui.Text("This entity has been registered as AV ?"..tostring(obj.isAV))
				ImGui.Spacing()
				if ImGui.Button("dump") then
					debugPrint(10,tostring(dump(obj)))
				end
				local group = getEntityGroupfromEntityTag(obj.tag)
				
				if group ~= nil then
					ImGui.Text("This entity has been registered in the Group "..group.tag)
				end
			end
		
			CNameDraw("GetCurrentAppearanceName", entity:GetCurrentAppearanceName())
			CNameDraw("GetCurrentContext", entity:GetCurrentContext())
			CNameDraw("GetDisplayName", entity:GetDisplayName())
			
			IGE.DisplayVector4("GetWorldPosition", entity:GetWorldPosition())
			IGE.ObjectToText("GetWorldOrientation", entity:GetWorldOrientation())
			IGE.DisplayVector4("GetWorldForward", entity:GetWorldForward())
			
			IGE.DisplayVector4("GetWorldRight", entity:GetWorldRight())
			IGE.DisplayVector4("GetWorldUp", entity:GetWorldUp())
			IGE.ObjectToText("GetWorldYaw", entity:GetWorldYaw())
			-- IGE.ObjectToText("IsAttached", entity:IsAttached()) -- Good way to tell if object has been deleted!
			-- IGE.ObjectToText("IsControlledByAnotherClient", entity:IsControlledByAnotherClient())
			-- IGE.ObjectToText("IsControlledByAnyPeer", entity:IsControlledByAnyPeer())
			-- IGE.ObjectToText("IsControlledBylocalPeer", entity:IsControlledBylocalPeer())
			-- IGE.ObjectToText("ShouldEnableRemoteLayer", entity:ShouldEnableRemoteLayer())
			-- IGE.ObjectToText("HasDirectActionsActive", entity:HasDirectActionsActive())
			-- IGE.ObjectToText("CanRevealRemoteActionsWheel", entity:CanRevealRemoteActionsWheel())
			-- IGE.ObjectToText("ShouldRegisterToHUD", entity:ShouldRegisterToHUD())
			-- IGE.ObjectToText("GetIsIconic", entity:GetIsIconic())
			-- IGE.ObjectToText("GetContentScale", entity:GetContentScale())
			-- IGE.ObjectToText("IsExplosive", entity:IsExplosive())
			-- IGE.ObjectToText("IsFastTravelPoint", entity:IsFastTravelPoint())
			-- IGE.ObjectToText("HasAnySlaveDevices", entity:HasAnySlaveDevices())
			-- IGE.ObjectToText("IsBodyDisposalPossible", entity:IsBodyDisposalPossible())
			-- IGE.ObjectToText("IsReplicated", entity:IsReplicated())
			
			
			ImGui.Unindent()
			
			
			posstep =  ImGui.DragFloat("##post", posstep, 0.1, 0.1, 10, "%.3f Position Step")
			rotstep =  ImGui.DragFloat("##rost", rotstep, 0.1, 0.1, 10, "%.3f Rotation Step")
			
			
			
			moveX =  ImGui.DragFloat("##x", moveX, posstep, -9999, 9999, "%.3f X")
			
			

			moveY = ImGui.DragFloat("##y", moveY, posstep, -9999, 9999, "%.3f Y")
			
			
			moveZ = ImGui.DragFloat("##z", moveZ, posstep, -9999, 9999, "%.3f Z")
			
			
			moveYaw =  ImGui.DragFloat("##yaw", moveYaw, rotstep, -9999, 9999, "%.3f YAW")
			
			
			movePitch = ImGui.DragFloat("##pitch", movePitch, rotstep, -9999, 9999, "%.3f PITCH")
			
			
			moveRoll = ImGui.DragFloat("##roll", moveRoll, rotstep, -9999, 9999, "%.3f ROLL")
			
			
			
			
			
			
				
			if ImGui.Button("change position", 300, 0) then
				local positu =  entity:GetWorldPosition()
				local qat = entity:GetWorldOrientation()
				local angless = GetSingleton('Quaternion'):ToEulerAngles(qat)
				positu.x = positu.x + moveX
				positu.y = positu.y + moveY
				positu.z = positu.z + moveZ
				
				
				local cmd = NewObject('handle:AITeleportCommand')
				
				cmd.doNavTest = false
				cmd.rotation = angless
				cmd.position = positu 
				
				
				executeCmd(entity, cmd)
		
			end
			
			if ImGui.Button("change angle", 300, 0) then
				local qat = entity:GetWorldOrientation()
				local angless = GetSingleton('Quaternion'):ToEulerAngles(qat)
				
				angless.yaw = angless.yaw + moveYaw
				angless.pitch = angless.pitch + movePitch
				angless.roll = angless.roll + moveRoll
				
				local cmd = NewObject('handle:AITeleportCommand')
				
				cmd.doNavTest = false
				cmd.rotation = angless
				cmd.position = entity:GetWorldPosition() 
				
				
				executeCmd(entity, cmd)
			
			
			end
				
				
			
		end
		
		end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	if ImGui.BeginTabItem("Current Threads") then
		
		if CPS:CPButton("Toggle automatic thread running") then
			autoScript = not autoScript
		end
		ImGui.Text("Automatic Mode : "..tostring(autoScript))
		
		if CPS:CPButton("Reset pending actions (Script)") then
			workerTable = {}
			despawnAll()
		end
		ImGui.Spacing()
		ImGui.Spacing()
		
		if CPS:CPButton("Manual script Step") then
			CompileCachedThread()
			ScriptExecutionEngine()
		end
		
		local status, result =  pcall(function()
			for k,v in pairs(workerTable) do 
				
				if ImGui.TreeNode(k) then
					
					local index = workerTable[k]["index"]
					
					local list = workerTable[k]["action"]
					
					local parent = workerTable[k]["parent"]
					
					local source = workerTable[k]["source"]
					
					local pending = workerTable[k]["pending"]
					
					local started = workerTable[k]["started"]
					
					local disabled = workerTable[k]["disabled"]
					
					local quest = workerTable[k]["quest"]
					
					local executortag = workerTable[k]["executortag"]
					ImGui.Text("index : "..index)
					ImGui.Text("list : "..#list)
					ImGui.Text("parent : "..parent)
					ImGui.Text("source : "..source)
					ImGui.Text("pending : "..tostring(pending))
					ImGui.Text("started : "..tostring(started))
					ImGui.Text("disabled : "..tostring(disabled))
					
					if quest ~= nil then
						ImGui.Text("quest : "..tostring(quest))
					end
					ImGui.Text("Executor Tag : "..executortag)
					if(list[index] ~= nil) then
					ImGui.Text("Current Action : "..list[index].name)
					end
					ImGui.TreePop()
				end
			end
		end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	if ImGui.BeginTabItem("Dev Playground") then
		
		local status, result =  pcall(function()
		if ImGui.Button("Stance Cover") then
			changeStance("test",1)
		end
		
		if ImGui.Button("Stance Crouch") then
			changeStance("test",2)
		end
		
		if ImGui.Button("Stance Stand") then
			changeStance("test",3)
		end
		
		if ImGui.Button("Stance Swim") then
			changeStance("test",4)
		end
		
		if ImGui.Button("Stance Vehicle") then
			changeStance("test",5)
		end
		
		if ImGui.Button("Stance VehicleWindows") then
			changeStance("test",6)
		end
		
		end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	if ImGui.BeginTabItem("Mod Data") then
		local status, result =  pcall(function()
		ImGui.Text("Group : ")
		for k,v in pairs(questMod.GroupManager) do
			
			local group = v
			ImGui.Text("Tag : "..group.tag)

			ImGui.Text("Entities : "..#group.entities)
			ImGui.Separator()
		end
		ImGui.Separator()
		ImGui.Text("Entities")
		for k,v in pairs(questMod.EntityManager) do
			
			local enti = v
			ImGui.Text("Tag : "..enti.tag)
			
			ImGui.Text("Tweak : "..tostring(enti.tweak))
			ImGui.Text("NPC : "..tostring(enti.id))
		end
		ImGui.Text("Items Spawned")
		for i=1, #currentItemSpawned do
			
			local enti = currentItemSpawned[i]
			debugPrint(6,dump(enti))
			ImGui.Text("Tag : "..enti.Tag)
			ImGui.Text("Id : "..tostring(enti.entityId))
		end
		ImGui.Text("Setting")
		for k,v in pairs(currentSave.arrayUserSetting) do
			
			local enti = v
			ImGui.Text("Tag : "..k)
			ImGui.Text("Value : "..tostring(v))
		end
		
		if currentQuest ~= nil then
			ImGui.Text("Current Quest")
			ImGui.Text("title : "..currentQuest.title)
			ImGui.Text("tag : "..currentQuest.tag)
			ImGui.Text("recommandedlevel : "..tostring(currentQuest.recommandedlevel))
			ImGui.Text("questtype : "..tostring(currentQuest.questtype))
			ImGui.Text("statut : "..tostring(getScoreKey(currentQuest.tag,"Score")))
			for i=1, #currentQuest.objectives do
				
				local objectif = currentQuest.objectives[i]
				ImGui.Text("title : "..objectif.title)
				ImGui.Text("tag : "..objectif.tag)
				ImGui.Text("state : "..tostring(QuestManager.GetObjectiveState(objectif.tag).state))
				ImGui.Text("isoptionnal : "..tostring(currentQuest.isoptionnal))
			end
		end
		ImGui.Separator()
		ImGui.Text("Interact Group : ")
		if(currentInteractGroup ~= nil and #currentInteractGroup > 0) then
			for i=1,#currentInteractGroup do
				ImGui.Text(currentInteractGroup[i])
			end
		end
		
		if CPS:CPButton("Refresh Interact Group")  then
			
			getInteractGroup()
		end
		
		ImGui.Separator()
		ImGui.Text("possibleInteract : "..#possibleInteract)
		ImGui.Text("possibleInteractDisplay : "..#possibleInteractDisplay)
		ImGui.Separator()
		
		if CPS:CPButton("print currentsave data")  then
			
			local sessionFile = io.open('currentsave.txt', 'w')
			sessionFile:write(dump(currentSave))
			sessionFile:close()
		end
		
		
		if CPS:CPButton("print arrayDatapack data")  then
			
			local sessionFile = io.open('arrayDatapack.lua', 'w')
			sessionFile:write(dump(arrayDatapack))
			sessionFile:close()
		end
		
		
	end)
	
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	if ImGui.BeginTabItem("Current Quest") then
		local status, result = pcall(function()
			
			if currentQuest ~= nil then
				ImGui.Text("title : "..currentQuest.title)
				ImGui.Text("content : "..currentQuest.content)
				ImGui.Text("tag : "..currentQuest.tag)
				ImGui.Text("recommandedlevel : "..currentQuest.recommandedlevel)
				ImGui.Text("questtype : "..currentQuest.questtype)
				ImGui.Text("district : "..currentQuest.district)
				ImGui.Text("isNPCD : "..tostring(currentQuest.isNPCD))
				ImGui.Text("recurrent : "..tostring(currentQuest.recurrent))
				ImGui.Text("State : "..tostring(getScoreKey(currentQuest.tag,"Score")))
				for k,v in pairs(currentQuest.trigger_condition) do
					ImGui.Text(v.name)
				end
				
				if ImGui.TreeNode("trigger_action") then
					for i=1, #currentQuest.trigger_action do
						ImGui.Text(currentQuest.trigger_action[i].name)
					end
					ImGui.TreePop()
				end
				
				if ImGui.TreeNode("objectives") then
					for i=1, #currentQuest.objectives do
						
						local objective = currentQuest.objectives[i]
						
						if ImGui.TreeNode(objective.title.." ( "..objective.tag.." )") then
							ImGui.Text("state : "..tostring(QuestManager.GetObjectiveState(objective.tag).state))
							ImGui.Text("isoptionnal : "..tostring(objective.isoptionnal))
							ImGui.Text("isActive : "..tostring(QuestManager.GetObjectiveState(objective.tag).isActive))
							ImGui.Text("isComplete : "..tostring(QuestManager.GetObjectiveState(objective.tag).isComplete))
							ImGui.Text("isTracked : "..tostring(QuestManager.GetObjectiveState(objective.tag).isTracked))
							ImGui.TreePop()
						end
					end
					ImGui.TreePop()
				end
				else
				ImGui.Text("No current Quest")
			end
		end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	
	if ImGui.BeginTabItem("Current Bounty") then
		local status, result = pcall(function()
			
			if currentScannerItem ~= nil then
				ImGui.Text("primaryname : "..currentScannerItem.primaryname)
				ImGui.Text("secondaryname : "..currentScannerItem.secondaryname)
				ImGui.Text("entityname : "..currentScannerItem.entityname)
				ImGui.Text("level : "..tostring(currentScannerItem.level))
				ImGui.Text("rarity : "..tostring(currentScannerItem.rarity))
				ImGui.Text("attitude : "..tostring(currentScannerItem.attitude))
				
				if currentScannerItem.bounty ~= nil then
				
				ImGui.Text("reward : "..tostring(currentScannerItem.bounty.reward))
				ImGui.Text("streetreward : "..tostring(currentScannerItem.bounty.streetreward))
				ImGui.Text("danger : "..tostring(currentScannerItem.bounty.danger))
				ImGui.Text("issuedby : "..tostring(currentScannerItem.bounty.issuedby))
				
				
				for i,v in ipairs(currentScannerItem.bounty.transgressions) do
					ImGui.Text(v)
				end
				
				for i,v in ipairs(currentScannerItem.bounty.customtransgressions) do
					ImGui.Text(v)
				end
			end
				
				else
				ImGui.Text("No current Bounty")
			end
		end)
		
		if status == false then
		
		
			debugPrint(10,result)
			spdlog.error(result)
		end
		
		ImGui.EndTabItem()
	end
	
	
	CPS.styleEnd(1)
	ImGui.EndTabBar()
	ImGui.End()
	CPS:setThemeEnd()
end


function frameworklog()
	
	if CPS == nil then return end
	CPS:setThemeBegin()
	ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
	ImGui.SetNextWindowSize(1600, 800, ImGuiCond.Appearing) -- set window size w, h
	
	if ImGui.Begin("CyberScript Log Windows") then
		
	
	
	
	
	
	logLevel = ImGui.InputInt(getLang("Log Level"), logLevel, 1,10, ImGuiInputTextFlags.None)
	ImGui.Spacing()
	logFilter = ImGui.InputText(getLang("Log Filter"), logFilter, 100, ImGuiInputTextFlags.AutoSelectAll)
	ImGui.Spacing()
	if ImGui.Button("Clear log and log file") then
		logTable = {}
		logf:close()
		io.open("cyberscript.log", "w"):close()
		logf = io.open("cyberscript.log", "a")
	end
	ImGui.Spacing()
	ImGui.Separator()
	ImGui.Spacing()
	
	
	ImGui.BeginChild("log", 1500, 600)
	
		for i,v in ipairs(logTable) do
			if(v.level <= logLevel and (logFilter == nil or logFilter == "" or (logFilter ~= nil and logFilter ~= "" and string.match(v.msg, logFilter)))) then
				ImGui.Text("[Level:"..v.level.."]"..v.datestring..":"..v.msg)
			end
		end
		
	ImGui.EndChild()
		
	
	
	
	
	
	
	end
	
	
	ImGui.End()
	CPS:setThemeEnd()
end

function fadeinwindows()
	
	local screenWidth, screenHeight = GetDisplayResolution()
	CPS.colorBegin("WindowBg", {"000000" , opacity})
	
	if ImGui.Begin(fademessage) then
		ImGui.SetNextWindowSize(screenWidth, screenHeight, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(screenWidth+5, screenHeight+5)
		ImGui.SetWindowPos(-5, -5)
	end
	CPS.colorEnd(1)
	ImGui.End()
end

function entitySelection()
	CPS:setThemeBegin()
	
	if not ImGui.Begin(lang.Selection) then
		CPS:setThemeEnd()
		return
	end
	ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
	ImGui.SetNextWindowSize(310, 0	, ImGuiCond.Appearing) -- set window size w, h
	ImGui.SetWindowSize(300, 150)
	ImGui.SetWindowPos(800, 900)
	
	if objLook then
		CPS.colorBegin("Text", IRPtheme.EntitySelectionWindows)
		ImGui.TextWrapped(objLook:ToString())
		CPS.colorEnd(1)
	end
	
	if CPS:CPButton(lang.ChoosethisOne) then
		
		if entitySelectionIsVehicule == objLook:IsVehicle() then
			
			if selectionSlot >= 1 and selectionSlot <= 5 then
				
				local obj = getEntityFromManager("selection" .. tostring(selectionSlot))
				obj.id = objLook:GetEntityID()
				debugPrint(6,"targeted !!")
			end
			selectedEntity = true
			enableEntitySelection = false
			entitySelectionIsVehicule = false
		end
	end
	ImGui.End()
	CPS:setThemeEnd()
end

function MultiNicknameWindows()
	CPS.colorBegin("WindowBg",{"000000", 0.005})
	CPS.colorBegin("TitleBg",{"000000", 0.0})
	CPS.colorBegin("TitleBgActive", {"000000" , 0.0})
	CPS.colorBegin("Border", {"000000", 0.0})
	CPS.colorBegin("Text", {"000000", 0.0})
	
	if ImGui.Begin("multi", ImGuiWindowFlags.NoSavedSettings) then
		ImGui.SetNextWindowPos(900, 500, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(310, 0, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(300, 300)
		ImGui.SetWindowPos(900, 250)
		ImGui.SetWindowFontScale(2)
		ImGui.Spacing()
		ImGui.Spacing()
		CPS.colorBegin("Text", IRPtheme.MultiNicknameWindowsText) -- get color from styles.lua
		CPS.colorBegin("Button", {48, 234, 247 ,0}) -- get color from styles.lua
		
		if ImGui.Button(multiName) then
			--why do i exist
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.SetWindowFontScale(1)
	end
	ImGui.End()
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
	CPS.colorEnd(1)
end

function displaySetting(setting, libelle)
	
	if setting == 1 then
		colorclass = IRPtheme.EnabledColor
		state = lang.Enabled
		else
		colorclass = IRPtheme.DisabledColor
		state = lang.Disabled
	end
	CPS.colorBegin("Text", colorclass)
	ImGui.TextWrapped(libelle.." : "..state)
	CPS.colorEnd(1)
end

function SendMessage()
	
	if onlineReceiver ~= nil and ImGui.Begin(getLang("ui_multi_msg_tellto")..onlineReceiver) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		if(onlineMessagePopupFirstUse == true) then
			ImGui.SetKeyboardFocusHere()
			onlineMessagePopupFirstUse = false
		end
		onlineMessageContent =  ImGui.InputText("##onlineMessageContent", onlineMessageContent, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		if ImGui.Button(getLang("ui_multi_msg_send")) then
			MessageSenderController()
			onlineMessagePopup = false
			onlineMessagePopupFirstUse = true
		end
		
		if ImGui.Button(getLang("ui_multi_msg_close")) then
			onlineMessagePopup = false
			onlineMessagePopupFirstUse = true
		end	
	end
end

function WhisperMessage()
	
	if multiName ~= nil and ImGui.Begin(getLang("ui_multi_msg_talkto")..multiName) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		if(onlineMessagePopupFirstUse == true) then
			ImGui.SetKeyboardFocusHere()
			onlineMessagePopupFirstUse = false
		end
		onlineMessageContent =  ImGui.InputText("##onlineMessageContent", onlineMessageContent, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		if ImGui.Button(getLang("ui_multi_msg_send")) then
			talkTo(multiName, onlineMessageContent)
			onlineMessageContent = ""
		end
	end
end

function ShootMessage()
	
	if ImGui.Begin(getLang("ui_multi_msg_shooto")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		if(onlineMessagePopupFirstUse == true) then
			ImGui.SetKeyboardFocusHere()
			onlineMessagePopupFirstUse = false
		end
		onlineMessageContent =  ImGui.InputText("##onlineMessageContent", onlineMessageContent, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		if ImGui.Button(getLang("ui_multi_msg_send")) then
			ShootTalk(onlineMessageContent)
			onlineMessageContent = ""
			onlineShootMessage =  false
		end
		
		if ImGui.Button(getLang("ui_multi_msg_close")) then
			
			onlineMessageContent = ""
			onlineShootMessage =  false
		end
	end
end

function InstancePassword()
	
	if onlineReceiver ~= nil and ImGui.Begin(getLang("ui_multi_instance_password")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		ImGui.Text(getLang("ui_multi_instance_password_msg"))
		ImGui.SetKeyboardFocusHere()
		selectedInstancePassword =  ImGui.InputText("##password", selectedInstancePassword, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		if ImGui.Button("Save") then
			onlinePasswordPopup = false
		end
	end
end

function Multi_InstanceCreate()
	
	if ImGui.Begin(getLang("ui_multi_instance_create")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		
		CreateInstance.title =  ImGui.InputText(getLang("ui_multi_instance_edit_title"), CreateInstance.title, 100, ImGuiInputTextFlags.AutoSelectAll)
		CreateInstance.isreadonly =ImGui.Checkbox(getLang("ui_multi_instance_edit_isreadonly"), CreateInstance.isreadonly)
		CreateInstance.nsfw =ImGui.Checkbox(getLang("ui_multi_instance_edit_nsfw"), CreateInstance.nsfw)
		
		if ImGui.BeginCombo(getLang("ui_multi_instance_edit_privacy"), defaultprivacy) then -- Remove the ## if you'd like for the title to display above combo box
			for i,v in ipairs(instancePrivacy) do
				
				if ImGui.Selectable(v, (CreateInstance.privacy == i)) then
					CreateInstance.privacy = i
					defaultprivacy = v
					ImGui.SetItemDefaultFocus()
				end
			end
			ImGui.EndCombo()
		end
		
		if(CreateInstance.privacy == 2) then
			CreateInstance.password =  ImGui.InputText(getLang("ui_multi_instance_edit_password"), CreateInstance.password, 100, ImGuiInputTextFlags.AutoSelectAll)
			else
			CreateInstance.password =  "nothing"
		end
		
		if ImGui.Button(getLang("ui_multi_instance_edit_valid")) then
			createInstance()
		end
		
		if ImGui.Button(getLang("ui_multi_instance_edit_close")) then
			onlineInstanceCreation = false
		end		
	end
end

function Multi_InstanceEdit()
	
	if ImGui.Begin(getLang("ui_multi_instance_edit")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		
		UpdateInstance.title =  ImGui.InputText(getLang("ui_multi_instance_edit_title"), UpdateInstance.title, 100, ImGuiInputTextFlags.AutoSelectAll)
		UpdateInstance.readOnly =ImGui.Checkbox(getLang("ui_multi_instance_edit_isreadonly"), UpdateInstance.readOnly)
		UpdateInstance.nsfw =ImGui.Checkbox(getLang("ui_multi_instance_edit_nsfw"), UpdateInstance.nsfw)
		
		if ImGui.BeginCombo(getLang("ui_multi_instance_edit_privacy"), defaultprivacy) then -- Remove the ## if you'd like for the title to display above combo box
			for i,v in ipairs(instancePrivacy) do
				
				if ImGui.Selectable(v, (UpdateInstance.private == i)) then
					UpdateInstance.private = i
					defaultprivacy = v
					ImGui.SetItemDefaultFocus()
				end
			end
			ImGui.EndCombo()
		end
		
		if(UpdateInstance.privacy == 2) then
			UpdateInstance.password =  ImGui.InputText(getLang("ui_multi_instance_edit_password"), UpdateInstance.password, 100, ImGuiInputTextFlags.AutoSelectAll)
			else
			UpdateInstance.password =  "nothing"
		end
		
		if ImGui.Button(getLang("ui_multi_instance_edit_valid")) then
			updateInstance()
		end
		
		if ImGui.Button(getLang("ui_multi_instance_edit_close")) then
			onlineInstanceUpdate = false
		end	
	end
end

function Multi_InstanceCreatePlace()
	
	if ImGui.Begin(getLang("ui_multi_instance_place_creation")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowFontScale(1)
		
		if(CreateInstancePlace.name == nil)then
			CreateInstancePlace.Id = 0
			CreateInstancePlace.instanceId = CurrentInstance.Id
			CreateInstancePlace.SpawnRange = 0
			CreateInstancePlace.LastUpdateDate = "2022-01-07T14:22:40.710Z"
			CreateInstancePlace.name = ""
			CreateInstancePlace.tag = ""
			CreateInstancePlace.posX = 0
			CreateInstancePlace.posY = 0
			CreateInstancePlace.posZ = 0
			CreateInstancePlace.range = 0
			CreateInstancePlace.Zrange = 0
			CreateInstancePlace.EnterX = 0
			CreateInstancePlace.EnterY = 0
			CreateInstancePlace.EnterZ = 0
			CreateInstancePlace.ExitX = 0
			CreateInstancePlace.ExitY = 0
			CreateInstancePlace.ExitZ = 0
			CreateInstancePlace.type = 0
			CreateInstancePlace.coef = 0
			CreateInstancePlace.isbuyable = true
			CreateInstancePlace.price = 0
			CreateInstancePlace.isrentable = false
			CreateInstancePlace.rent = 0
			CreateInstancePlace["rooms"] = {}
		end
		CreateInstancePlace.name = ImGui.InputText(getLang("ui_multi_instance_place_creation_name"), CreateInstancePlace.name, 100, ImGuiInputTextFlags.AutoSelectAll)
		CreateInstancePlace.tag = ImGui.InputText(getLang("ui_multi_instance_place_creation_tag"), CreateInstancePlace.tag, 100, ImGuiInputTextFlags.AutoSelectAll)
		CreateInstancePlace.posX = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_x"), CreateInstancePlace.posX, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		CreateInstancePlace.posY = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_y"), CreateInstancePlace.posY, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		CreateInstancePlace.posZ = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_z"), CreateInstancePlace.posZ, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		ImGui.Spacing()
		
		if ImGui.Button(getLang("ui_multi_instance_place_creation_copy"), 300, 0) then
			
			local vec4 = Game.GetPlayer():GetWorldPosition()
			CreateInstancePlace.posX = vec4.x
			CreateInstancePlace.posY = vec4.y
			CreateInstancePlace.posZ = vec4.z
		end
		ImGui.Spacing()
		CreateInstancePlace.range = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_range"), CreateInstancePlace.range, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		CreateInstancePlace.Zrange = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_zrange"), CreateInstancePlace.Zrange, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		CreateInstancePlace.SpawnRange = ImGui.InputFloat(getLang("ui_multi_instance_place_creation_spawnrange"), CreateInstancePlace.SpawnRange, 1, 10, "%.1f", ImGuiInputTextFlags.None)
		
		if(CreateInstancePlace.tag ~= "" or CreateInstancePlace.tag ~= nil) then
			
			if ImGui.Button(getLang("ui_multi_instance_place_creation_save")) then
				createInstancePlace()
				onlineInstancePlaceCreation = false
			end
			else
			ImGui.Text(getLang("ui_multi_instance_place_creation_msg"))
		end
		
		if ImGui.Button(getLang("ui_multi_instance_place_creation_close")) then
			onlineInstancePlaceCreation = false
		end
	end
end

function Multi_EditItemsWindows()
	CPS:setThemeBegin()
	ImGui.SetNextWindowPos(200, 150, ImGuiCond.Appearing) -- set window position x, y
	ImGui.SetNextWindowSize(500, 500, ImGuiCond.Appearing) -- set window size w, h
	ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 8)
	ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 7)
	
	if ImGui.Begin(getLang("ui_multi_instance_place_items")) then
		posstep =  ImGui.DragFloat("##post", posstep, 0.1, 0.1, 10, "%.3f Position Step")
		rotstep =  ImGui.DragFloat("##rost", rotstep, 0.1, 0.1, 10, "%.3f Rotation Step")
		selectedItemMulti.X,change =  ImGui.DragFloat("##x", selectedItemMulti.X, posstep, -9999, 9999, "%.3f X")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		selectedItemMulti.Y,change = ImGui.DragFloat("##y", selectedItemMulti.Y, posstep, -9999, 9999, "%.3f Y")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		selectedItemMulti.Z,change = ImGui.DragFloat("##z", selectedItemMulti.Z, posstep, -9999, 9999, "%.3f Z")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		selectedItemMulti.Yaw,change =  ImGui.DragFloat("##yaw", selectedItemMulti.Yaw, rotstep, -9999, 9999, "%.3f YAW")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		selectedItemMulti.Pitch,change = ImGui.DragFloat("##pitch", selectedItemMulti.Pitch, rotstep, -9999, 9999, "%.3f PITCH")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		selectedItemMulti.Roll,change = ImGui.DragFloat("##roll", selectedItemMulti.Roll, rotstep, -9999, 9999, "%.3f ROLL")
		
		if change then
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		
		if ImGui.Button(getLang("ui_multi_instance_place_creation_copy"), 300, 0) then
			
			local vec4 = Game.GetPlayer():GetWorldPosition()
			selectedItemMulti.X = vec4.x
			selectedItemMulti.Y = vec4.y
			selectedItemMulti.Z = vec4.z
			
			local poss = Vector4.new( selectedItemMulti.X, selectedItemMulti.Y,  selectedItemMulti.Z,1)
			
			local angless = EulerAngles.new(selectedItemMulti.Roll, selectedItemMulti.Pitch,  selectedItemMulti.Yaw)
			updateItemPositionMulti(selectedItemMulti, poss, angless, true)
		end
		
		if(selectedItemMulti.Tag ~= nil) then
			
			if ImGui.Button(getLang("ui_menu_delete"), 300, 0) then
				
				if selectedItemMulti ~= nil then
					
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					
					if(entity ~= nil) then
						Game.FindEntityByID(selectedItemMulti.entityId):GetEntity():Destroy()
						debugPrint(6,"toto")
						updatePlayerItemsQuantity(selectedItemMulti,1)
						deleteHousing(selectedItemMulti.Id)
						DeleteItem(selectedItemMulti.Tag)
						
						local index = getItemEntityIndexFromManager(selectedItemMulti.entityId)
						--despawnItem(selectedItemMulti.Id)
						table.remove(currentItemMultiSpawned,index)
						Cron.After(1, function()
							selectedItemMulti = nil
							selectedItemMultiBackup = nil
						end)
						else
						debugPrint(6,"nope")
					end
				end
				openEditItemsMulti = false
			end
			
			if ImGui.Button(getLang("ui_multi_instance_edit_valid"), 300, 0) then
				UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
				selectedItemMultiBackup = selectedItemMulti
				openEditItemsMulti = false
			end
			
			if ImGui.Button(getLang("ui_multi_instance_edit_close"), 300, 0) then
				
				local poss = Vector4.new( selectedItemMultiBackup.X, selectedItemMultiBackup.Y,  selectedItemMultiBackup.Z,1)
				
				local angless = EulerAngles.new(selectedItemMultiBackup.Roll, selectedItemMultiBackup.Pitch,  selectedItemMultiBackup.Yaw)
				updateItemPositionMulti(selectedItemMulti, poss, angless, true)
				openEditItemsMulti = false
			end
		end
	end
	ImGui.PopStyleVar(2)
	ImGui.End()
	CPS:setThemeEnd()
end

function Multi_GuildCreate()
	
	if ImGui.Begin(getLang("ui_multi_instance_guild_create")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		
		CreateGuild.Title =  ImGui.InputText(getLang("ui_multi_instance_create_title"), CreateGuild.Title, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		
		if ImGui.BeginCombo(getLang("ui_multi_instance_guild_faction"), defaultfaction) then
			
			
			for k,v in pairs(arrayFaction) do
				
				if ImGui.Selectable(v.faction.Name, (defaultfaction  == k)) then
					CreateGuild.FactionTag  = k
					defaultfaction = v.Name
					ImGui.SetItemDefaultFocus()
				end
				
				
			end
			
			ImGui.EndCombo()
		end
		
		
		
		
		if ImGui.Button(getLang("ui_multi_instance_create_valid")) then
			createGuild()
		end
		
		if ImGui.Button(getLang("ui_multi_instance_create_close")) then
			onlineGuildCreation = false
		end		
	end
end

function Multi_GuildEdit()
	
	if ImGui.Begin(getLang("ui_multi_instance_guild_update")) then
		ImGui.SetNextWindowPos(800,800, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(menuWindowsX, menuWindowsY, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(menuWindowsX, menuWindowsY)
		ImGui.SetWindowFontScale(menufont)
		
		
		UpdateGuild.Title =  ImGui.InputText(getLang("ui_multi_instance_create_title"), UpdateGuild.Title, 100, ImGuiInputTextFlags.AutoSelectAll)
		UpdateGuild.Description =  ImGui.InputText(getLang("ui_multi_instance_guild_update_desc"), UpdateGuild.Description, 100, ImGuiInputTextFlags.AutoSelectAll)
		
		if ImGui.BeginCombo(getLang("ui_multi_instance_guild_faction"), defaultfaction) then
			
			
			for k,v in pairs(arrayFaction) do
				
				if ImGui.Selectable(v.faction.Name, (defaultfaction  == k)) then
					UpdateGuild.FactionTag  = k
					defaultfaction = v.Name
					ImGui.SetItemDefaultFocus()
				end
				
				
			end
			
			ImGui.EndCombo()
		end
		
		
		
		
		if ImGui.Button(getLang("ui_multi_instance_edit_valid")) then
			updateGuild()
		end
		
		if ImGui.Button(getLang("ui_multi_instance_edit_close")) then
			onlineGuildCreation = false
		end		
	end
end


---Native UI---
function HousingWindows()
	-- debugPrint(6,tostring(currentHouse ~= nil))
	-- debugPrint(6,tostring(isInHouse))
	
	if currentHouse ~= nil and isInHouse and #currentSave.arrayPlayerItems > 0 and inEditMode == true then
		
		if ImGui.Begin("My House") then
			ImGui.SetNextWindowPos(800, 750, ImGuiCond.Appearing) -- set window position x, y
			ImGui.SetNextWindowPos(800, 400, ImGuiCond.FirstUseEver) -- set window position x, y
			ImGui.SetNextWindowSize(300, 500, ImGuiCond.Appearing) -- set window size w, h
			ImGui.SetWindowSize(300, 500)
			
			if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
				CPS.styleBegin("TabRounding", 0)
				
				if ImGui.BeginTabItem("Buyed Items") then
					CPS.colorBegin("Button", IRPtheme.HousingWindowsButton)
					CPS.colorBegin("Text", IRPtheme.HousingWindowsText)
					
					if #currentSave.arrayPlayerItems > 0 then
						for i=1, #currentSave.arrayPlayerItems do 
							
							local mitems = currentSave.arrayPlayerItems[i]
							
							if mitems.Quantity > 0 then
								CPS.colorBegin("Text", "ff5145")-- get color from styles.lua
								CPS.colorBegin("Button", { 48, 234, 247 ,0})  -- get color from styles.lua
								
								if ImGui.Button("Place "..mitems.Title.." Here ("..mitems.Quantity..")") then
									
									local pos = Game.GetPlayer():GetWorldPosition()
									
									local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
									
									local spawnedItem = {}
									debugPrint(6,pos.x)
									spawnedItem.Tag = mitems.Tag
									spawnedItem.HouseTag = currentHouse.tag
									spawnedItem.ItemPath = mitems.Path
									spawnedItem.X = pos.x
									spawnedItem.Y = pos.y
									spawnedItem.Z = pos.z
									spawnedItem.Yaw = angles.yaw
									spawnedItem.Pitch = angles.pitch
									spawnedItem.Roll = angles.roll
									spawnedItem.Title = mitems.Title
									saveHousing(spawnedItem)
									
									local housing = getHousing(spawnedItem.Tag,spawnedItem.X,spawnedItem.Y,spawnedItem.Z)
									spawnedItem.Id = housing.Id
									updatePlayerItemsQuantity(mitems,-1)
									spawnedItem.entityId = spawnItem(spawnedItem, pos, angles)
									table.insert(currentItemSpawned,spawnedItem)
								end
								CPS.colorEnd(1)
								CPS.colorEnd(1)
							end
						end
					end
					CPS.colorEnd(1)
					CPS.colorEnd(1)
					ImGui.EndTabItem()
				end
				
				if ImGui.BeginTabItem("Placed Items") then
					CPS.colorBegin("Button", IRPtheme.HousingWindowsPlacingItemButton)
					CPS.colorBegin("Text", IRPtheme.HousingWindowsPlacingItemText)
					
					if selectedItem == nil then
						
						if #currentItemSpawned > 0 then
							for i=1, #currentItemSpawned do 
								
								local mitems = currentItemSpawned[i]
								
								if not (selectedItem ~= nil and selectedItem.Id == mitems.Id) then
									
									if ImGui.Button("Select "..mitems.Title.."("..mitems.Id..")") then
										selectedItem = nil
										selectedItem = mitems
									end
								end
							end
						end
					end
					
					if selectedItem ~= nil then
						ImGui.TextWrapped("Selected : "..selectedItem.Title.."("..selectedItem.Id..")")
						ImGui.Spacing()
						ImGui.Spacing()
						
						if ImGui.Button("X+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.x = objpos.x + 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("X-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.x = objpos.x - 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Y+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.y = objpos.y + 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Y-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.y = objpos.y - 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Z+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.z = objpos.z + 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Z-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							objpos.z = objpos.z - 0.05
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						
						if ImGui.Button("Yaw+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.yaw = angle.yaw + 5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Yaw-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.yaw = angle.yaw + -5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Pitch+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.pitch = angle.pitch + 5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Pitch-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.pitch = angle.pitch + -5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Roll+") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.roll = angle.roll + 5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						ImGui.SameLine()
						
						if ImGui.Button("Roll-") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = entity:GetWorldPosition()
							
							local worldpos = Game.GetPlayer():GetWorldTransform()
							
							local qat = entity:GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							angle.roll = angle.roll + -5
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						
						if ImGui.Button("Move to Player") then
							
							local entity = Game.FindEntityByID(selectedItem.entityId)
							
							local objpos = Game.GetPlayer():GetWorldPosition()
							
							local qat = Game.GetPlayer():GetWorldOrientation()
							
							local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
							updateItemPosition(selectedItem, objpos, angle, true)
						end
						
						if ImGui.Button("Remove") then
							
							if Game.FindEntityByID(selectedItem.entityId) then
								for i=1, #currentSave.arrayPlayerItems do
									
									local mitem = currentSave.arrayPlayerItems[i]
									
									if mitem.Tag == selectedItem.Tag then
										Game.FindEntityByID(selectedItem.entityId):GetEntity():Destroy()
										debugPrint(6,"toto")
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
								else
								debugPrint(6,"nope")
							end
						end
						ImGui.Spacing()
						ImGui.Spacing()
						
						if ImGui.Button("Unselect "..selectedItem.Title.."("..selectedItem.Id..")") then
							selectedItem = nil
						end
					end
					CPS.colorEnd(1)
					CPS.colorEnd(1)
					ImGui.EndTabItem()
				end
				CPS.styleEnd(1)
				ImGui.EndTabBar()
			end
			ImGui.End()
		end
	end
end

function BuyedItemsUI()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_buyed_items")
	ui.tag = "buyed_items_ui"
	ui.controls = {}
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"buyed_items_ui_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	area = {}
	area.type = "vertical_area"
	area.tag =	"buyed_items_ui_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "buyed_items_ui_scroll"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	if(#currentSave.arrayPlayerItems > 0 ) then
		for i = 1, #currentSave.arrayPlayerItems do 
			
			local mitems = currentSave.arrayPlayerItems[i]
			
			if(mitems.Quantity > 0) then
				
				local buttons = {}
				buttons.type = "button"
				buttons.title = "Place "..mitems.Title.." Here ("..mitems.Quantity..")"
				buttons.tag =mitems.Tag.."_button_"..i
				buttons.width = 1000
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.margin = {}
				buttons.style = {}
				buttons.margin.top = 15
				buttons.style.fontsize = 35
				buttons.style.width = 1450
				buttons.style.height = 100
				buttons.parent = "buyed_items_ui_varea"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				
				local spawn_item = {}
				spawn_item.name = "spawn_buyed_item" 
				spawn_item.tag = mitems.Tag
				table.insert(buttons.action,spawn_item)
				spawn_item = {}
				spawn_item.name = "grab_select_item" 
				table.insert(buttons.action,spawn_item)
				
				local close_action = {}
				close_action.name = "close_interface" 
				table.insert(buttons.action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function BuyedItemsUIMulti()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_multi_buyed_items")
	ui.tag = "buyed_items_ui_multi"
	ui.controls = {}
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"buyed_items_ui_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	area = {}
	area.type = "vertical_area"
	area.tag =	"buyed_items_ui_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "buyed_items_ui_scroll"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	if(#currentSave.arrayPlayerItems > 0 ) then
		for i = 1, #currentSave.arrayPlayerItems do 
			
			local mitems = currentSave.arrayPlayerItems[i]
			
			if(mitems.Quantity > 0) then
				
				local buttons = {}
				buttons.type = "button"
				buttons.title = "Place "..mitems.Title.." Here ("..mitems.Quantity..")"
				buttons.tag =mitems.Tag.."_button_"..i
				buttons.width = 1000
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.margin = {}
				buttons.style = {}
				buttons.margin.top = 15
				buttons.style.fontsize = 35
				buttons.style.width = 1450
				buttons.style.height = 100
				buttons.parent = "buyed_items_ui_varea"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				
				local spawn_item = {}
				spawn_item.name = "spawn_buyed_item_multi" 
				spawn_item.tag = mitems.Tag
				table.insert(buttons.action,spawn_item)
				spawn_item = {}
				spawn_item.name = "grab_select_item_multi" 
				table.insert(buttons.action,spawn_item)
				
				local close_action = {}
				close_action.name = "close_interface" 
				table.insert(buttons.action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function ActivatedGroup()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_datapack_choice")
	ui.tag = "datapack_current"
	ui.controls = {}
	
	if(#currentInteractGroup > 0 ) then
		
		local label = {}
		label.type = "label"
		label.tag ="selected_group_lbl"
		label.trigger = {}
		label.trigger.auto = {}
		label.trigger.auto.name = "auto"
		label.margin = {}
		label.style = {}
		label.margin.top = 15
		label.style.fontsize = 35
		label.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(label.requirement,requirement)
		label.value = {}
		label.value.type = "text"
		label.value.value =  "Selected : "..currentInteractGroup[currentInteractGroupIndex]
		table.insert(ui.controls,label)
		
		local area = {}
		area.type = "scrollarea"
		area.tag =	"datapack_current_scroll"
		area.trigger = {}
		area.trigger.auto = {}
		area.trigger.auto.name = "auto"
		area.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(area.requirement,requirement)
		area.action = {}
		area.margin = {}
		area.style = {}
		area.margin.top = 15
		area.style.fontsize = 30
		area.style.width = 1500
		area.style.height = 700
		table.insert(ui.controls,area)
		area = {}
		area.type = "vertical_area"
		area.tag =	"datapack_current_varea"
		area.trigger = {}
		area.trigger.auto = {}
		area.trigger.auto.name = "auto"
		area.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(area.requirement,requirement)
		area.action = {}
		area.margin = {}
		area.style = {}
		area.margin.top = 15
		area.parent = "datapack_current_scroll"
		area.style.fontsize = 30
		area.style.width = 1500
		area.style.height = 350
		table.insert(ui.controls,area)
		for i = 1, #currentInteractGroup do 
			
		
			local buttons = {}
			buttons.type = "button"
			buttons.title = "Choose "..currentInteractGroup[i]
			buttons.tag =currentInteractGroup[i].."_button_"..i
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.parent = "datapack_current_varea"
			buttons.style.fontsize = 35
			buttons.style.width = 1450
			buttons.style.height = 100
			
			local spawn_item = {}
			spawn_item.name = "set_datapack_group" 
			spawn_item.value = i
			table.insert(buttons.action,spawn_item)
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			table.insert(ui.controls,buttons)
		end
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function PlacedItemsUI()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_manage_placed_item")
	ui.tag = "placed_items_ui"
	ui.controls = {}
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"placed_items_ui_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	area = {}
	area.type = "vertical_area"
	area.tag =	"placed_items_ui_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "placed_items_ui_scroll"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	if(#currentItemSpawned > 0 ) then
		
		if selectedItem ~= nil then
			
			local label = {}
			label.type = "label"
			label.tag ="selected_item_lbl"
			label.trigger = {}
			label.trigger.auto = {}
			label.trigger.auto.name = "auto"
			label.margin = {}
			label.style = {}
			label.margin.top = 15
			label.style.fontsize = 35
			label.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(label.requirement,requirement)
			label.value = {}
			label.value.type = "text"
			label.value.value =  "Selected : "..selectedItem.Title.."("..selectedItem.Id..")"
			table.insert(ui.controls,label)
		end
		for i = 1, #currentItemSpawned do 
			
			local mitems = currentItemSpawned[i]
			
			local buttons = {}
			buttons.type = "button"
			buttons.title = "Select "..mitems.Title.."("..mitems.Id..")"
			buttons.tag =mitems.Tag.."_button_"..i
			buttons.margin = {}
			buttons.style = {}
			buttons.margin.top = 15
			buttons.style.fontsize = 35
			buttons.style.width = 1000
			buttons.style.height = 100
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			
			local spawn_item = {}
			spawn_item.name = "select_item" 
			spawn_item.value = mitems.Id
			table.insert(buttons.action,spawn_item)
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			table.insert(ui.controls,buttons)
		end
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = "Unselect item"
		buttons.tag ="unselect_button"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.margin = {}
		buttons.style = {}
		buttons.parent = "placed_items_ui_varea"
		buttons.style.fontsize = 35
		buttons.style.width = 1450
		buttons.style.height = 100
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		
		local spawn_item = {}
		spawn_item.name = "unselect_item" 
		table.insert(buttons.action,spawn_item)
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function PlacedItemsUIMulti()
	currentInterface = nil
	
	local ui = {}
	ui.title =  getLang("ui_multi_manage_placed_item")
	ui.tag = "placed_items_ui_multi"
	ui.controls = {}
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"placed_items_ui_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	area = {}
	area.type = "vertical_area"
	area.tag =	"placed_items_ui_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "placed_items_ui_scroll"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	if(#currentItemMultiSpawned > 0 ) then
		
		if selectedItemMulti ~= nil then
			
			local label = {}
			label.type = "label"
			label.tag ="selected_item_lbl"
			label.trigger = {}
			label.trigger.auto = {}
			label.trigger.auto.name = "auto"
			label.margin = {}
			label.style = {}
			label.margin.top = 15
			label.style.fontsize = 35
			label.parent = "placed_items_ui_varea"
			label.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(label.requirement,requirement)
			label.value = {}
			label.value.type = "text"
			label.value.value =  "Selected : "..selectedItemMulti.Title.."("..selectedItemMulti.Id..")"
			table.insert(ui.controls,label)
		end
		for i = 1, #currentItemMultiSpawned do 
			
			local mitems = currentItemMultiSpawned[i]
			
			local buttons = {}
			buttons.type = "button"
			buttons.title = "Select "..mitems.Title.."("..mitems.Id..")"
			buttons.tag =mitems.Tag.."_button_"..i
			buttons.margin = {}
			buttons.style = {}
			buttons.margin.top = 15
			buttons.style.fontsize = 35
			buttons.style.width = 1000
			buttons.style.height = 100
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.parent = "placed_items_ui_varea"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			
			local spawn_item = {}
			spawn_item.name = "select_item_multi" 
			spawn_item.value = mitems.Id
			table.insert(buttons.action,spawn_item)
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			table.insert(ui.controls,buttons)
		end
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = "Unselect item"
		buttons.tag ="unselect_button"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.margin = {}
		buttons.style = {}
		buttons.parent = "placed_items_ui_varea"
		buttons.style.fontsize = 35
		buttons.style.width = 1450
		buttons.style.height = 100
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		
		local spawn_item = {}
		spawn_item.name = "unselect_item_multi" 
		table.insert(buttons.action,spawn_item)
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Keystone_Load()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_loading")
	ui.tag = "keystone_load"
	ui.controls = {}
	
	local label = {}
	label.type = "label"
	label.tag ="processing"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 15
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  "Loading..."
	table.insert(ui.controls,label)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local action = {}
		
		local actif = {}
		actif.name = "if"
		actif.trigger ={}
		actif.trigger.name = "player_is_connected"
		actif.if_action = {}
		actif.else_action = {}
		-- act = {}
		-- act.name = "wait_second"
		-- act.value = 4
		-- table.insert(action,act)
		
		local act = {}
		act = {}
	
		act = {}
		act.name = "wait_second"
		act.value = 2
		table.insert( actif.if_action,act)
		
		local act = {}
		
		if(fetcheddata ~= nil) then
		
			local timestamp = (fetcheddata.updatetime+5)-fetcheddata.updatetime
			
			if(timestamp>5) then
			
				act.name = "fetch_data"
				table.insert( actif.if_action,act)
				
				act = {}
				act.name = "change_interface_label_text"
				act.tag = "processing"
				act.value = "Get Data  (3 seconds remaning)"
				table.insert( actif.if_action,act)
				
				act = {}
				act.name = "wait_for_framework" 
				table.insert( actif.if_action,act)
				
				act = {}
			end
			else
			act.name = "fetch_data"
				table.insert( actif.if_action,act)
				
				act = {}
				act.name = "change_interface_label_text"
				act.tag = "processing"
				act.value = "Get Data  (3 seconds remaning)"
				table.insert( actif.if_action,act)
				
				act = {}
				act.name = "wait_for_framework" 
				table.insert( actif.if_action,act)
				
				act = {}
			
		end
		
		act.name = "wait_second"
		act.value = 1
		table.insert( actif.if_action,act)
		
		act = {}
		act.name = "close_interface"
		table.insert( actif.if_action,act)
		act = {}
		act.name = "open_keystone_main"
		table.insert( actif.if_action,act)
		act = {}
		act.name = "change_interface_label_text"
		act.tag = "processing"
		act.value = "You are not connected, close this windows, open CET, go to multiplayer menu and click on Connect. \n If you still stuck on this windows, after checking that EXE framework is running in background, reload the mod or the game."
		table.insert( actif.else_action,act)
		table.insert(action,actif)
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		runActionList(action, "keystone_load", "interact",false,"nothing",true)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_Warning()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_update_title")
	ui.tag = "keystone_warning"
	ui.controls = {}
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_update_msg")
	buttons.tag =	"keystone_upd_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 0
	buttons.margin.left = 1250
	buttons.style.fontsize = 30
	buttons.style.width = 300
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local label = {}
	label.type = "label"
	label.tag ="processing"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.left = 350
	label.margin.top = -50
	label.style.fontsize = 40
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  getLang("ui_multi_manage_placed_item")
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_main_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 350
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 500
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_main_buttonlist_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_main_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local label = {}
	label.type = "label"
	label.tag ="selected_item_lb2"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.parent = "keystone_main_buttonlist_area"
	label.margin = {}
	label.style = {}
	label.margin.top = 15
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  CurrentServerModVersion.changelog
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = "Update !"
	buttons.tag =	"keystone_upd_btn_02"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.parent = ""
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.margin.left = 850
	buttons.margin.top = 800
	buttons.style = {}
	buttons.style.fontsize = 30
	buttons.style.width = 1500
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "update_mod" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_Changelog()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_changelog_title")
	ui.tag = "keystone_changleog"
	ui.controls = {}
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_upd_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 0
	buttons.margin.left = 1250
	buttons.style.fontsize = 30
	buttons.style.width = 300
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_main_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 350
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 500
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_main_buttonlist_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_main_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local label = {}
	label.type = "label"
	label.tag ="selected_item_lb2"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.parent = "keystone_main_buttonlist_area"
	label.margin = {}
	label.style = {}
	label.margin.top = 15
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  questMod.changelog
	table.insert(ui.controls,label)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_Main()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_main_title")
	ui.tag = "keystone_main"
	ui.controls = {}
	
	local label = {}
	label.type = "label"
	label.tag ="selected_item_lbl"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 15
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  "CyberScript : local version :"..questMod.version.." Server version :"..CurrentServerModVersion.version
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_main_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 50
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_main_buttonlist_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_main_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1600
	area.style.height = 350
	table.insert(ui.controls,area)
	
	if(CurrentServerModVersion.version ~= "unknown" and CurrentServerModVersion.version ~= "0.16000069") then
		
		if(CurrentServerModVersion.version ~= "unknown" and CurrentServerModVersion.version ~= "0.16000069" and checkVersionNumber(questMod.version,CurrentServerModVersion.version))then
			
			local buttons = {}
			buttons.type = "button"
			buttons.title = getLang("ui_keystone_main_update_available")
			buttons.tag =	"keystone_main_btn_00"
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.parent = "keystone_main_buttonlist_area"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.style.fontsize = 30
			buttons.style.width = 1500
			buttons.style.height = 100
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			close_action = {}
			close_action.name = "open_keystone_update_warning" 
			table.insert(buttons.action,close_action)
			table.insert(ui.controls,buttons)
		end
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_datapack")
		buttons.tag =	"keystone_main_btn_01"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_datapack_main" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_downloaded_datapack")
		buttons.tag =	"keystone_main_btn_mydatapack"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_datapack_mine" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_corpowars")
		buttons.tag =	"keystone_main_btn_02"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "change_interface_label_text"
		close_action.tag = "loadinglb"
		close_action.value = "Fetching data..."
		table.insert(buttons.action,close_action)
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_corpowars" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_stocks")
		buttons.tag =	"keystone_main_btn_03"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "change_interface_label_text"
		close_action.tag = "loadinglb"
		close_action.value = "Fetching data..."
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "refresh_market" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "wait_for_framework" 
		table.insert(buttons.action,action)
		close_action = {}
		close_action.name = "wait_second"
		close_action.value = 1
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_stock" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_items")
		buttons.tag =	"keystone_main_btn_04"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "change_interface_label_text"
		close_action.tag = "loadinglb"
		close_action.value = "Fetching data..."
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "get_itemlist" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "wait_for_framework" 
		table.insert(buttons.action,action)
		close_action = {}
		close_action.name = "wait_second" 
		close_action.value =  1
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_item_category" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_multiinfos")
		buttons.tag =	"keystone_main_btn_05"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_multiinfo" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_changelog")
		buttons.tag =	"keystone_main_btn_06"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_changelog" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
		else
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_main_error")
		buttons.tag =	"keystone_main_btn_01"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.parent = "keystone_main_buttonlist_area"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
	end
	
	local action = {}
	
	
	
	local act = {}
	act.name = "fetch_data"
	table.insert( action,act)
	act = {}
	act.name = "wait_for_framework" 
	table.insert(action,act)
	act = {}
	act.name = "wait_second"
	act.value = 1
	table.insert( action,act)
	act = {}
	act.name = "close_interface"
	table.insert( action,act)
	act = {}
	act.name = "open_keystone_main"
	table.insert( action,act)	
	
	RefreshButton("Fetching Data...","nothing","open_keystone_main",ui,4,action)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_corpoWars()
	currentInterface = nil
	
	local ui = {}
	
	local descc = ""
	for i = 1,#corpoNews  do
		
		local news = corpoNews[i]
		
		if(news ~= nil) then
			descc = descc.."\n"..corpoNews[i]
		end
	end
	ui.title = getLang("ui_keystone_corpo_title")
	ui.tag = "keystone_corpo"
	ui.controls = {}
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 0
	buttons.margin.left = 1250
	buttons.style.fontsize = 30
	buttons.style.width = 300
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_corpo_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_corpo_text_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_corpo_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local label = {}
	label.type = "label"
	label.tag ="selected_group_lbl"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 0
	label.margin.left = 0
	label.style.fontsize = 35
	label.parent = "keystone_corpo_text_area"
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  descc
	table.insert(ui.controls,label)
	
	local actionlist = {}
	
	local action = {}
	action.name = "wait_second"
	action.value = 1
	table.insert(actionlist,action)
	RefreshButton(getLang("ui_keystone_refresh"),"refresh_news","open_keystone_corpowars",ui, 3,actionlist)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_MultiInfo()
	currentInterface = nil
	
	local ui = {}
	
	local descc = getLang("ui_keystone_multiinfos_msg01")..tostring(NetServiceOn)
	descc = descc.."\n"..getLang("ui_keystone_multiinfos_msg02")..tostring(MultiplayerOn)
	descc = descc.."\n"..getLang("ui_keystone_multiinfos_msg03")..tostring(currentFaction.."("..getLang("ui_keystone_multiinfos_msg04")..currentFactionRank.." )")
	descc = descc.."\n"..getLang("ui_keystone_multiinfos_msg05")
	ui.title = getLang("ui_keystone_multiinfos_title")
	ui.tag = "keystone_multi"
	ui.controls = {}
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 0
	buttons.margin.left = 1250
	buttons.style.fontsize = 30
	buttons.style.width = 300
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_corpo_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_corpo_text_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_corpo_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local label = {}
	label.type = "label"
	label.tag ="selected_group_lbl"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 0
	label.margin.left = 0
	label.style.fontsize = 35
	label.parent = "keystone_corpo_text_area"
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  descc
	table.insert(ui.controls,label)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_stock()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_stocks_title")
	ui.tag = "keystone_stock"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "label"
	label.tag ="keystone_stock_money"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 10
	label.margin.right = 10
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	
	local money = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(TweakDBID.new("Items.money")))
	label.value.value = getLang("ui_keystone_stocks_msg01")..money
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "linebreak"
	label.tag ="keystone_stock_lbk01"
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="keystone_stock_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 15
	buttons.margin.left = 1400
	buttons.style.fontsize = 30
	buttons.style.width = 350
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_stock_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_stock_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_stock_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	
	if arrayMarket ~= nil and #arrayMarket > 0 then
		for i = 1,#arrayMarket  do
			
			local score = arrayMarket[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.title
				buttons.tag =	score.tag
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="keystone_stock_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_stock" 
				close_action.value = arrayMarket[i]
				table.insert(buttons.onenter_action,close_action)
				
				local descc = score.title
				descc= descc.."\n"..getLang("ui_keystone_stocks_msg02")..score.price.."\n"..getLang("ui_keystone_stocks_msg03")..score.inflate.."\n"..getLang("ui_keystone_stocks_msg04")..score.quantity
				
				if(score.userQuantity ~= nil and score.statut ~= 0) then
					descc = descc.."\n"..getLang("ui_keystone_stocks_msg05")..score.userQuantity
				end
				close_action = {}
				close_action.name = "change_interface_label_text" 
				close_action.tag = "keystone_stock_desc" 
				close_action.value = descc
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_stocks_buy")
	buttons.tag =	"keystone_stock_btn_buy"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action.name = "change_interface_label_text"
	action.tag = "loadinglb"
	action.value = "LOADING..."
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "buy_score" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "remove_money_current_stock" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "clean_current_stock" 
	table.insert(buttons.action,action)
	
	
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "open_keystone_stock"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_stocks_sell")
	buttons.tag =	"keystone_stock_btn_sell"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 750
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action.name = "change_interface_label_text"
	action.tag = "loadinglb"
	action.value = "LOADING..."
	table.insert(buttons.action,action)
	

	
	
	action = {}
	action.name = "sell_score" 
	table.insert(buttons.action,action)
	
	
	

	
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	
	
	
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "give_money_current_stock" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "clean_current_stock" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	
	action = {}
	action.name = "open_keystone_stock"
	table.insert(buttons.action,action)
	
	table.insert(ui.controls,buttons)
	
	
	RefreshButton(getLang("ui_keystone_refresh"),"refresh_market","open_keystone_stock",ui)
	
	if(#arrayMarket > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Keystone_item_category()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_items_category_title")
	ui.tag = "keystone_item_cateogry"
	ui.controls = {}
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 0
	buttons.margin.left = 1250
	buttons.style.fontsize = 30
	buttons.style.width = 300
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_itemcat_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_itemcat_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_itemcat_scroll_area"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 350
	table.insert(ui.controls,area)
	for i=1, #possiblecategory do
		
		local buttons = {}
		buttons.type = "button"
		buttons.title = possiblecategory[i]
		buttons.tag =	possiblecategory[i]
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.onenter_action = {}
		buttons.onleave_action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.parent="keystone_itemcat_varea"
		-- buttons.margin.top = 10
		-- buttons.margin.left = 350
		buttons.style.fontsize = 30
		buttons.style.width = 1500
		buttons.style.height = 100
		
		local close_action = {}
		close_action.name = "close_interface" 
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "set_selected_item_category" 
		close_action.value =  possiblecategory[i]
		table.insert(buttons.action,close_action)
		close_action = {}
		close_action.name = "open_keystone_item" 
		table.insert(buttons.action,close_action)
		table.insert(ui.controls,buttons)
	end
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function Keystone_item()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_items_title")
	ui.tag = "keystone_item"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "label"
	label.tag ="keystone_item_money"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 10
	label.margin.right = 10
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	
	local money = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(TweakDBID.new("Items.money")))
	label.value.value = getLang("ui_keystone_items_msg01")..money
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="keystone_item_cart"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 500
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = getLang("ui_keystone_items_msg02")..CartPrice
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="keystone_item_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_items_backcat")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 15
	buttons.margin.left = 1400
	buttons.style.fontsize = 30
	buttons.style.width = 350
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_item_category" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_stock_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_item_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_stock_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	
	if arrayMarketItem ~= nil and #arrayMarketItem > 0 then
		for i = 1,#arrayMarketItem  do
			
			local items = arrayMarketItem[i]
			
			if(items ~= nil) then
				
				if(items ~= nil) then
					
					local ismatch = false
					
					if (Keystone_currentSelectedItemCategory ~= nil and (Keystone_currentSelectedItemCategory ~= "" and string.match(string.lower(items.parentCategory), string.lower(Keystone_currentSelectedItemCategory)))) then
						
						if (string.match(string.lower(items.Tag), string.lower(Keystone_currentSelectedItemCategory)) 
							or string.match(string.lower(items.Title), string.lower(Keystone_currentSelectedItemCategory)) 
							or string.match(string.lower(items.parentCategory), string.lower(Keystone_currentSelectedItemCategory)) 
							or string.match(string.lower(items.childCategory), string.lower(Keystone_currentSelectedItemCategory)) 
						or string.match(string.lower(items.flag), string.lower(Keystone_currentSelectedItemCategory))) then
						ismatch = true
						end
					end
					
					if(ismatch == true) then
						
						local buttons = {}
						buttons.type = "button"
						buttons.title = items.Title
						buttons.tag =	items.Tag
						buttons.trigger = {}
						buttons.trigger.auto = {}
						buttons.trigger.auto.name = "auto"
						buttons.requirement = {}
						
						local requirement = {}
						table.insert(requirement,"auto")
						table.insert(buttons.requirement,requirement)
						buttons.action = {}
						buttons.onenter_action = {}
						buttons.onleave_action = {}
						buttons.margin = {}
						buttons.style = {}
						buttons.parent="keystone_item_varea"
						-- buttons.margin.top = 10
						-- buttons.margin.left = 350
						buttons.style.fontsize = 30
						buttons.style.width = 700
						buttons.style.height = 100
						
						local close_action = {}
						close_action = {}
						close_action.name = "set_selected_item" 
						close_action.value = arrayMarketItem[i]
						table.insert(buttons.onenter_action,close_action)
						
						local descc = items.Title
						descc= descc.."\n"..getLang("ui_keystone_items_msg03")..items.parentCategory
						descc= descc.."\n"..getLang("ui_keystone_items_msg04")..items.childCategory
						descc= descc.."\n"..getLang("ui_keystone_items_msg05")..items.flag
						descc= descc.."\n"..getLang("ui_keystone_items_msg06")..items.Price
						descc= descc.."\n"..getLang("ui_keystone_items_msg07")..items.Inflate
						descc= descc.."\n"..getLang("ui_keystone_items_msg08")..items.Quantity
						
						local playerItems = getPlayerItemsbyTag(items.Tag)
						
						if(playerItems ~= nil) then
							descc = descc.."\n"..getLang("ui_keystone_items_msg09")..playerItems.Quantity
						end
						close_action = {}
						close_action.name = "change_interface_label_text" 
						close_action.tag = "keystone_item_desc" 
						close_action.value = descc
						table.insert(buttons.onenter_action,close_action)
						table.insert(ui.controls,buttons)
					end
				end
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_items_msg10")
	buttons.tag =	"keystone_item_btn_addcart"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1075
	buttons.style.fontsize = 35
	buttons.style.width = 350
	buttons.style.height = 100
	
	local action = {}
	action.name = "add_to_cart" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "change_interface_cart" 
	action.tag = "keystone_item_cart"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_items_msg11")
	buttons.tag =	"keystone_item_btn_addcart"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1425
	buttons.style.fontsize = 35
	buttons.style.width = 350
	buttons.style.height = 100
	
	local action = {}
	action.name = "remove_to_cart" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "change_interface_cart" 
	action.tag = "keystone_item_cart"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = "Buy Cart"
	buttons.tag =	"keystone_item_btn_addcart"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 750
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local  action = {}
	action.name = "change_interface_label_text"
	action.tag = "loadinglb"
	action.value = "LOADING..."
	table.insert(buttons.action,action)
	action = {}
	action.name = "buy_cart" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 2
	table.insert(buttons.action,action)
	action = {}
	action.name = "close_interface"
	table.insert(buttons.action,action)
	action = {}
	action.name = "open_keystone_item" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	RefreshButton(getLang("ui_keystone_refresh"),"refresh_item_market","open_keystone_item",ui)
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
end

function RefreshButton(title,action,redirectui, ui, count,actionlist)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = title
	buttons.tag =	"keystone_main_btn_refresh"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.parent = ""
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.margin.top = -120
	buttons.margin.left = 1250
	buttons.style = {}
	buttons.style.fontsize = 20
	buttons.style.width = 500
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "change_interface_label_text"
	close_action.tag = "loadinglb"
	close_action.value = "LOADING..."
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = action 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	
	if(count == nil) then
		count = 2
	end
	close_action = {}
	close_action.name = "wait_second"
	close_action.value = count
	table.insert(buttons.action,close_action)
	
	if(actionlist ~= nil) then
		for i=1,#actionlist do
			table.insert(buttons.action,actionlist[i])
		end
	end
	close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = redirectui
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
end




function Keystone_Datapack()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_datapack")
	ui.tag = "keystone_datapack"
	ui.controls = {}
	
	local label = {}
	label.type = "label"
	label.tag ="keystone_label_datapack_title"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 10
	label.margin.right = 10
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = getLang("ui_keystone_datapack_msg01")
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "linebreak"
	label.tag ="keystone_label_datapack_kb"
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="keystone_label_datapack_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 25
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 15
	buttons.margin.left = 1400
	buttons.style.fontsize = 30
	buttons.style.width = 350
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_datapack_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_datapack_buttonlist_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_datapack_scroll_area"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	for i = 1,#arrayDatapack3  do
		
		local datapack = arrayDatapack3[i]
		
		if (DatapackChecker(datapack)) then
			buttons = {}
			buttons.type = "button"
			buttons.title = datapack.name
			buttons.tag =	datapack.tag
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.onenter_action = {}
			buttons.onleave_action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.parent="keystone_datapack_buttonlist_area"
			-- buttons.margin.top = 10
			-- buttons.margin.left = 350
			buttons.style.fontsize = 30
			buttons.style.width = 700
			buttons.style.height = 100
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			close_action = {}
			close_action.name = "set_selected_keystone_datapack" 
			close_action.value = arrayDatapack3[i]
			table.insert(buttons.action,close_action)
			close_action = {}
			close_action.name = "open_datapack_detail_ui" 
			close_action.redirect = false
			table.insert(buttons.action,close_action)
			
			local descc = ""
			
			local desctab = splitByChunk(datapack.desc, 50)
			
			local resultstr = ""
			for y=1,#desctab do
				descc = descc.."\n"..desctab[y]
			end
			descc= descc.."\n"..getLang("ui_keystone_datapack_msg02")..datapack.author.."\n"..getLang("ui_keystone_datapack_msg03")..datapack.version
			
			if(isDatapackDownloaded(datapack.tag)) then
				
				local 
				localversion = CurrentDownloadedVersion(datapack.tag)
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg04")..localversion
				
				debugPrint(10,localversion)
				debugPrint(10,datapack.version)
				
				if(localversion~=datapack.version and checkVersionNumber(localversion,datapack.version) == true) then
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg05")
				buttons.title = datapack.name..getLang("ui_keystone_datapack_msg06")
				end
			end
			
			if(datapack.requirement ~= nil) then
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg07")..datapack.requirement
			end
			
			
			
			
			if(datapack.flags ~= nil and #datapack.flags > 0)then
			
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg08")
			
				for i,v in ipairs(datapack.flags) do
				
				descc = descc.."\n"..v
				
				end
			
			end
			
			
			if(datapack.faction ~= nil) then
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg09")
			end
			close_action = {}
			close_action.name = "change_interface_label_text" 
			close_action.tag = "keystone_label_datapack_desc" 
			close_action.value = descc
			table.insert(buttons.onenter_action,close_action)
			table.insert(ui.controls,buttons)
		end
	end
	RefreshButton(getLang("ui_keystone_refresh"),"get_datapacklist","open_keystone_datapack_main",ui)
	
	if(#arrayDatapack3 > 0 ) then
		
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Keystone_myDatapack()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_mydatapack")
	ui.tag = "keystone_mydatapack"
	ui.controls = {}
	
	local label = {}
	label.type = "label"
	label.tag ="keystone_label_datapack_title"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 10
	label.margin.right = 10
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = getLang("ui_keystone_datapack_msg01")
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "linebreak"
	label.tag ="keystone_label_datapack_kb"
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="keystone_label_datapack_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 25
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local buttons = {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_backmenu")
	buttons.tag =	"keystone_main_btn_01"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 15
	buttons.margin.left = 1400
	buttons.style.fontsize = 30
	buttons.style.width = 350
	buttons.style.height = 100
	
	local close_action = {}
	close_action.name = "close_interface" 
	table.insert(buttons.action,close_action)
	close_action = {}
	close_action.name = "open_keystone_main" 
	table.insert(buttons.action,close_action)
	table.insert(ui.controls,buttons)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"keystone_datapack_scroll_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 700
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"keystone_datapack_buttonlist_area"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "keystone_datapack_scroll_area"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	for k,v in pairs(arrayDatapack)  do
		
		local datapack = v
			
		if('table' == type(v)) then
			buttons = {}
			buttons.type = "button"
			buttons.title = datapack.metadata.name
			buttons.tag =	datapack.metadata.tag
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.onenter_action = {}
			buttons.onleave_action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.parent="keystone_datapack_buttonlist_area"
			-- buttons.margin.top = 10
			-- buttons.margin.left = 350
			buttons.style.fontsize = 30
			buttons.style.width = 700
			buttons.style.height = 100
			
			local close_action = {}
			close_action.name = "close_interface" 
			table.insert(buttons.action,close_action)
			close_action = {}
			close_action.name = "set_selected_keystone_datapack" 
			close_action.value = v.metadata
			table.insert(buttons.action,close_action)
			close_action = {}
			close_action.name = "open_datapack_detail_ui" 
			close_action.redirect = true
			table.insert(buttons.action,close_action)
			
			local descc = ""
			
			local desctab = splitByChunk(datapack.metadata.desc, 50)
			
			local resultstr = ""
			for y=1,#desctab do
				descc = descc.."\n"..desctab[y]
			end
			
			local serverversion = 0
				
			serverversion = GetDatapackOnlineVersion(datapack.metadata.tag)
			descc= descc.."\n"..getLang("ui_keystone_datapack_msg02")..datapack.metadata.author.."\n"..getLang("ui_keystone_datapack_msg03")..serverversion
			
			
				
				local localversion = datapack.metadata.version
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg04")..localversion
				
				
				
				
			
				
				
				if(serverversion == 0) then
				
					serverversion = localversion
					descc = descc.."\n"..getLang("ui_keystone_datapack_msg10")
				end
				
				
				if(localversion~=serverversion and checkVersionNumber(localversion,serverversion) == true) then
					descc = descc.."\n"..getLang("ui_keystone_datapack_msg05")
					buttons.title = datapack.metadata.name..getLang("ui_keystone_datapack_msg06")
				end
				
				
			
			
			if(datapack.requirement ~= nil) then
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg07")..datapack.metadata.requirement
			end
			
			if(datapack.metadata.flags ~= nil and #datapack.metadata.flags > 0)then
			
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg08")
			
				for i,v in ipairs(datapack.metadata.flags) do
				
				descc = descc.."\n"..v
				
				end
			
			end
			
			if(datapack.metadata.faction ~= nil) then
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg09")
			end
			close_action = {}
			close_action.name = "change_interface_label_text" 
			close_action.tag = "keystone_label_datapack_desc" 
			close_action.value = descc
			table.insert(buttons.onenter_action,close_action)
			table.insert(ui.controls,buttons)
			end
	end
	RefreshButton(getLang("ui_keystone_refresh"),"get_datapacklist","open_keystone_datapack_mine",ui)
	
	
		
	currentInterface = ui
	
	if UIPopupsManager.IsReady() then
		
		local notificationData = inkGameNotificationData.new()
		notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
		notificationData.queueName = 'modal_popup'
		notificationData.isBlocking = true
		notificationData.useCursor = true
		UIPopupsManager.ShowPopup(notificationData)
		else
		Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
	end
	
end

function Keystone_Datapack_details(redirect)
	
	if(Keystone_currentSelectedDatapack ~= nil) then
		currentInterface = nil
		
		local ui = {}
		ui.title = getLang("ui_keystone_datapack_detail")
		ui.tag = "keystone_datapack_detail"
		ui.controls = {}
		
		local label = {}
		label.type = "label"
		label.tag ="keystone_label_datapack_detail_title"
		label.trigger = {}
		label.trigger.auto = {}
		label.trigger.auto.name = "auto"
		label.margin = {}
		label.style = {}
		label.margin.top = 5
		label.style.fontsize = 35
		label.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(label.requirement,requirement)
		label.value = {}
		label.value.type = "text"
		label.value.value = Keystone_currentSelectedDatapack.name
		table.insert(ui.controls,label)
		
		local label = {}
		label.type = "linebreak"
		label.tag ="keystone_label_datapack_kb"
		table.insert(ui.controls,label)
		label = {}
		label.type = "label"
		label.tag ="keystone_label_datapack_desc"
		label.trigger = {}
		label.trigger.auto = {}
		label.trigger.auto.name = "auto"
		label.margin = {}
		label.style = {}
		label.margin.top = 25
		label.margin.left = 900
		label.style.fontsize = 35
		label.requirement = {}
		requirement = {}
		table.insert(requirement,"auto")
		table.insert(label.requirement,requirement)
		label.value = {}
		label.value.type = "text"
		
		local descc = ""
		
		local desctab = splitByChunk(Keystone_currentSelectedDatapack.desc, 50)
		
		local resultstr = ""
		for y=1,#desctab do
		
		
			descc = descc.."\n"..desctab[y]
		end
		
		local serverversion = 0
				
		serverversion = GetDatapackOnlineVersion(Keystone_currentSelectedDatapack.tag)
		local localversion = CurrentDownloadedVersion(Keystone_currentSelectedDatapack.tag)
		
		descc= descc.."\n"..getLang("ui_keystone_datapack_msg02")..Keystone_currentSelectedDatapack.author.."\n"..getLang("ui_keystone_datapack_msg03")..serverversion
	
		if(isDatapackDownloaded(Keystone_currentSelectedDatapack.tag)) then
			
			
			descc = descc.."\n"..getLang("ui_keystone_datapack_msg04")..localversion
			
		
			
			if(serverversion == 0) then
			
			serverversion = localversion
			descc = descc.."\n"..getLang("ui_keystone_datapack_msg10")
			end
			
				
			if(localversion~=serverversion and checkVersionNumber(localversion,serverversion) == true) then
			
			
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg05")
			
			end
			
			
		end
		
		if(Keystone_currentSelectedDatapack.requirement ~= nil) then
			descc = descc.."\n"..getLang("ui_keystone_datapack_msg07")..Keystone_currentSelectedDatapack.requirement
		end
		
		if(Keystone_currentSelectedDatapack.flags ~= nil and #Keystone_currentSelectedDatapack.flags > 0)then
			
				descc = descc.."\n"..getLang("ui_keystone_datapack_msg08")
			
				for i,v in ipairs(Keystone_currentSelectedDatapack.flags) do
				
				descc = descc.."\n"..v
				
				end
			
		end
		
		if(Keystone_currentSelectedDatapack.faction ~= nil) then
			descc = descc.."\n"..getLang("ui_keystone_datapack_msg09")
		end
		label.value.value = descc
		table.insert(ui.controls,label)
		
		local buttons= {}
		
		if(isDatapackDownloaded(Keystone_currentSelectedDatapack.tag)) then
			
			
			if(localversion~=serverversion and checkVersionNumber(localversion,serverversion) == true) then
			buttons = {}
			buttons.type = "button"
			buttons.title = "Update"
			buttons.tag =	"keystone_detail_btn_update"
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.margin.top = 100
			buttons.margin.left = 360
			buttons.style.fontsize = 35
			buttons.style.width = 700
			buttons.style.height = 100
			
			local action = {}
			action.name = "change_interface_label_text"
			action.tag = "loading"
			action.value = "Loading..."
			table.insert(buttons.action,action)
			action = {}
			action.name = "change_interface_label_text" 
			action.tag = "keystone_label_datapack_detail_title" 
			action.value = "Updating Mod..."
			table.insert(buttons.action,action)
			action = {}
			action.name = "update_datapack" 
			action.value = Keystone_currentSelectedDatapack.file
			action.tag = Keystone_currentSelectedDatapack.tag
			table.insert(buttons.action,action)
			action = {}
			action.name = "wait_for_framework" 
			table.insert(buttons.action,action)
			action = {}
			action.name = "wait_second" 
			action.value = 2
			table.insert(buttons.action,action)
			action = {}
			action.name = "close_interface" 
			table.insert(buttons.action,action)
			if(redirect == true) then
			action = {}
			action.name = "open_keystone_datapack_mine"
			table.insert(buttons.action,action)
			else
			action = {}
			action.name = "open_keystone_datapack_main"
			table.insert(buttons.action,action)
			end
			table.insert(ui.controls,buttons)
			end
			
			if(table_contains(Keystone_currentSelectedDatapack.flags,"essential",false) == false and table_contains(Keystone_currentSelectedDatapack.flags,"debug",false) == false) then
				buttons = {}
				buttons.type = "button"
				buttons.title = "Delete"
				buttons.tag =	"keystone_detail_btn_delete"
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.margin.top = 210
				buttons.margin.left = 360
				buttons.style.fontsize = 35
				buttons.style.width = 700
				buttons.style.height = 100
				
				local action = {}
				action.name = "change_interface_label_text"
				action.tag = "loading"
				action.value = "Loading..."
				table.insert(buttons.action,action)
				action = {}
				action.name = "change_interface_label_text" 
				action.tag = "keystone_label_datapack_detail_title" 
				action.value = "Deleting Mod..."
				table.insert(buttons.action,action)
				action = {}
				action.name = "delete_datapack" 
				action.tag = Keystone_currentSelectedDatapack.tag
				table.insert(buttons.action,action)
				action = {}
				action.name = "wait_for_framework" 
				table.insert(buttons.action,action)
				action = {}
				action.name = "wait_second" 
				action.value = 1
				table.insert(buttons.action,action)
				action = {}
				action.name = "close_interface" 
				table.insert(buttons.action,action)
				action = {}
				action.name = "open_keystone_datapack_main"
				table.insert(buttons.action,action)
				table.insert(ui.controls,buttons)
			end
			else
			
			if(Keystone_currentSelectedDatapack.isdownloadable == true or Keystone_currentSelectedDatapack.isdownloadable ==  nil or  DatapackChecker(Keystone_currentSelectedDatapack) == true) then
				buttons = {}
				buttons.type = "button"
				buttons.title = "Download"
				buttons.tag =	"keystone_detail_btn_download"
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.margin.top = 100
				buttons.margin.left = 360
				buttons.style.fontsize = 35
				buttons.style.width = 700
				buttons.style.height = 100
				
				local action = {}
				action.name = "change_interface_label_text"
				action.tag = "loading"
				action.value = "Loading..."
				table.insert(buttons.action,action)
				action = {}
				action.name = "change_interface_label_text" 
				action.tag = "keystone_label_datapack_detail_title" 
				action.value = "Downloading Mod..."
				table.insert(buttons.action,action)
				action = {}
				action.name = "download_datapack" 
				action.value = Keystone_currentSelectedDatapack.file
				action.tag = Keystone_currentSelectedDatapack.tag
				table.insert(buttons.action,action)
				action = {}
				action.name = "wait_for_framework" 
				table.insert(buttons.action,action)
				action = {}
				action.name = "wait_second" 
				action.value = 3
				table.insert(buttons.action,action)
				action = {}
				action.name = "close_interface" 
				table.insert(buttons.action,action)
				if(redirect == true) then
				action = {}
				action.name = "open_keystone_datapack_mine"
				table.insert(buttons.action,action)
				else
				action = {}
				action.name = "open_keystone_datapack_main"
				table.insert(buttons.action,action)
				end
				table.insert(ui.controls,buttons)
				-- else
				-- buttons = {}
				-- buttons.type = "button"
				-- buttons.title = getLang("ui_multi_manage_placed_item")
				-- buttons.tag =	"keystone_detail_btn_download_nope"
				-- buttons.trigger = {}
				-- buttons.trigger.auto = {}
				-- buttons.trigger.auto.name = "auto"
				-- buttons.requirement = {}
				
				-- local requirement = {}
				-- table.insert(requirement,"auto")
				-- table.insert(buttons.requirement,requirement)
				-- buttons.action = {}
				-- buttons.margin = {}
				-- buttons.style = {}
				-- buttons.margin.top = 100
				-- buttons.margin.left = 360
				-- buttons.style.fontsize = 35
				-- buttons.style.width = 700
				-- buttons.style.height = 100
			end
		end
		buttons = {}
		buttons.type = "button"
		buttons.title = getLang("ui_keystone_datapack_msg12")
		buttons.tag =	"keystone_detail_btn_back"
		buttons.trigger = {}
		buttons.trigger.auto = {}
		buttons.trigger.auto.name = "auto"
		buttons.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(buttons.requirement,requirement)
		buttons.action = {}
		buttons.margin = {}
		buttons.style = {}
		buttons.margin.top = 15
		buttons.margin.left = 1250
		buttons.style.fontsize = 25
		buttons.style.width = 700
		buttons.style.height = 70
		
		local action = {}
		action.name = "close_interface" 
		table.insert(buttons.action,action)
		
		if(redirect == true) then
		action = {}
		action.name = "open_keystone_datapack_mine"
		table.insert(buttons.action,action)
		else
		action = {}
		action.name = "open_keystone_datapack_main"
		table.insert(buttons.action,action)
		end
		
		label = {}
		label.type = "label"
		label.tag ="loading"
		label.trigger = {}
		label.trigger.auto = {}
		label.trigger.auto.name = "auto"
		label.margin = {}
		label.style = {}
		label.margin.top = 350
		label.margin.left = 700
		label.style.fontsize = 65
		label.requirement = {}
		
		local requirement = {}
		table.insert(requirement,"auto")
		table.insert(label.requirement,requirement)
		label.value = {}
		label.value.type = "text"
		label.value.value =  ""
		table.insert(ui.controls,label)
		table.insert(ui.controls,buttons)
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_InstanceList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_instance")
	ui.tag = "multi_instance_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""

	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local count = 15
	
	if arrayInstanceList ~= nil and #arrayInstanceList > 0 then
		for i = 1,#arrayInstanceList  do
			
			local score = arrayInstanceList[i]
			
			if(score ~= nil and (score.isNSFW == nil or (GameSettings.Get("/gameplay/misc/CensorNudity") == true and score.isNSFW == false) or GameSettings.Get("/gameplay/misc/CensorNudity") == false)) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.title
				buttons.tag =	"instance_"..score.id
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_instance" 
				close_action.value = score.id
				table.insert(buttons.onenter_action,close_action)
				
				local descc = score.title
				descc= descc..
				"\n"..getLang("ui_keystone_instance_msg01")..score.connectedPlayer..
				"\n"..getLang("ui_keystone_instance_msg02")..score.owner..
				"\n"..getLang("ui_keystone_instance_msg03")..tostring(score.readOnly)
				
				
				if(score.isNSFW == true) then
				
				
				descc= descc..
				"\n"..getLang("ui_keystone_instance_msg04")..
				"\n"..getLang("ui_keystone_instance_msg05")..
				"\n"..getLang("ui_keystone_instance_msg06")..
				"\n"..getLang("ui_keystone_instance_msg07")..
				"\n"..getLang("ui_keystone_instance_msg08")
				
				label.style.fontsize = 25
				end
				
				if(score.private == 1) then
					descc = descc.."\n"..getLang("ui_keystone_instance_msg09")
				end
				
				if(score.private == 2) then
					descc = descc.."\n"..getLang("ui_keystone_instance_msg10")
				end
				
				if(score.private == 3) then
					descc = descc.."\n"..getLang("ui_keystone_instance_msg11")
				end
				
				if(score.private == 4) then
					descc = descc.."\n"..getLang("ui_keystone_instance_msg12")
				end
				
				close_action = {}
				close_action.name = "change_interface_label_text" 
				close_action.tag = "multi_instance_desc" 
				close_action.value = descc
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	table.insert(ui.controls,label)
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_msg14")
	buttons.tag =	"multi_instance_btn_connect"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "connect_instance" 
	action.value =  selectedInstance
	action.password = selectedInstancePassword
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 2
	table.insert(buttons.action,action)
	action = {}
	action.name = "notify_instance"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_msg13")
	buttons.tag =	"multi_instance_btn_password"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "open_instance_password_popup" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_GuildList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_guild")
	ui.tag = "multi_guild_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local count = 15
	
	if ActualPlayerMultiData.guilds ~= nil and #ActualPlayerMultiData.guilds > 0 then
		for i = 1,#ActualPlayerMultiData.guilds  do
			
			local score = ActualPlayerMultiData.guilds[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.Title
				buttons.tag =	"guild_"..score.Id
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_guild" 
				close_action.value = score.Id
				table.insert(buttons.onenter_action,close_action)
				
				local descc = score.Title
				descc= descc..
				"\n"..getLang("ui_keystone_guild_msg01")..tostring(score.Description)..
				"\n"..getLang("ui_keystone_guild_msg02")..score.TotalMember..
				"\n"..getLang("ui_keystone_guild_msg03")..score.Owner
				close_action = {}
				close_action.name = "change_interface_label_text" 
				close_action.tag = "multi_instance_desc" 
				close_action.value = descc
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title =getLang("ui_keystone_guild_msg04")
	buttons.tag =	"multi_instance_btn_join"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "join_guild" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	action = {}
	action.name = "notify"
	action.value = getLang("ui_keystone_guild_msg05")
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_guild_msg06")
	buttons.tag =	"multi_instance_btn_leave"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "leave_guild" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	action = {}
	action.name = "notify"
	action.value = getLang("ui_keystone_guild_msg07")
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_guild_msg08")
	buttons.tag =	"multi_instance_btn_create"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 750
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action.name = "open_guild_creation" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	RefreshButton(getLang("ui_keystone_refresh"),"get_instance_list","open_instance_list",ui)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_GuildPendingList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_guild_management_pending")
	ui.tag = "multi_guild_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local count = 15
	
	if ActualPlayerMultiData.guildPending ~= nil and #ActualPlayerMultiData.guildPending > 0 then
		for i = 1,#ActualPlayerMultiData.guildPending  do
			
			local score = ActualPlayerMultiData.guildPending[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.userName
				buttons.tag =	"guild_"..score.userName
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_guild_user" 
				close_action.value = score.userName
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_guild_management_pending_msg01")
	buttons.tag =	"multi_instance_btn_join"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "accept_to_guild" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_guild_management_pending_msg02")
	buttons.tag =	"multi_instance_btn_leave"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 600
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "refuse_to_guild" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_GuildUserList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_guild_management")
	ui.tag = "multi_guild_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local count = 15
	
	if ActualPlayerMultiData.guildUsers ~= nil and #ActualPlayerMultiData.guildUsers > 0 then
		for i = 1,#ActualPlayerMultiData.guildUsers  do
			
			local score = ActualPlayerMultiData.guildUsers[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score
				buttons.tag =	"guild_"..score
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_guild_user" 
				close_action.value = score
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_guild_management_msg04")
	buttons.tag =	"multi_instance_btn_remove"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "remove_to_guild" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_AvatarList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_avatar")
	ui.tag = "multi_avatar_list"
	ui.controls = {}
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="selected_group_lbl"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 15
	label.style.fontsize = 35
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  "Selected : "..currentSave.myAvatar
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 1500
	area.style.height = 750
	table.insert(ui.controls,area)
	
	local count = 15
	
	if tweakdbtable ~= nil and #tweakdbtable > 0 then
		for i = 1,#tweakdbtable  do
			
			local score = tweakdbtable[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score
				buttons.tag =	"avatar_"..i
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 25
				buttons.style.width = 1450
				buttons.style.height = 100
				
				local action = {}
				action = {}
				action.name = "change_avatar" 
				action.value = score
				table.insert(buttons.action,action)
				action = {}
				action.name = "close_interface" 
				table.insert(buttons.action,action)
				action = {}
				action.name = "reset_scroll_speed" 
				table.insert(buttons.action,action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	if(#tweakdbtable > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_InstanceUserList()
	currentInterface = nil
	
	local ui = {}
	ui.title =getLang("ui_keystone_instance_user")
	ui.tag = "multi_instance_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	
	if ActualPlayersList ~= nil and #ActualPlayersList > 0 then
		for i = 1,#ActualPlayersList  do
			debugPrint(6,dump(ActualPlayersList))
			
			local score = ActualPlayersList[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.pseudo
				buttons.tag =	"instance_"..score.pseudo
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_user" 
				close_action.value = score
				table.insert(buttons.onenter_action,close_action)
				
				local descc = getLang("ui_keystone_instance_user_msg01")..score.pseudo
				descc= descc..
				"\n"..getLang("ui_keystone_instance_user_msg02")..tostring(score.avatar)..
				"\n".."X : "..tostring(score.x)..
				"\n".."Y : "..tostring(score.y)..
				"\n".."Z : "..tostring(score.z)
				close_action = {}
				close_action.name = "change_interface_label_text" 
				close_action.tag = "multi_instance_desc" 
				close_action.value = descc
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg03")
	buttons.tag =	"multi_instance_btn_tp"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 150
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "tp_to_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg04")
	buttons.tag =	"multi_instance_btn_connect"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 550
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "add_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title =getLang("ui_keystone_friend_delete")
	buttons.tag =	"multi_instance_btn_delete"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 250
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "delete_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg09")
	buttons.tag =	"multi_instance_btn_block"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 350
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action = {}
	action.name = "block_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title =getLang("ui_keystone_instance_user_msg07")
	buttons.tag =	"multi_instance_btn_unblock"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "unblock_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg08")
	buttons.tag =	"multi_instance_btn_msg"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 750
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action = {}
	action.name = "close_interface"
	table.insert(buttons.action,action)
	action = {}
	action.name = "open_menu" 
	action.value = "phone"
	table.insert(buttons.action,action)
	action = {}
	action.name = "toggle_message_popup" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_InstanceOwnerUserList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_instance_owner")
	ui.tag = "multi_instance_owner_player_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	
	if ActualPlayersList ~= nil and #ActualPlayersList > 0 then
		for i = 1,#ActualPlayersList  do
		
			
			local score = ActualPlayersList[i]
			
			if(score ~= nil) then
				buttons = {}
				buttons.type = "button"
				buttons.title = score.pseudo
				buttons.tag =	"instance_"..score.pseudo
				buttons.trigger = {}
				buttons.trigger.auto = {}
				buttons.trigger.auto.name = "auto"
				buttons.requirement = {}
				
				local requirement = {}
				table.insert(requirement,"auto")
				table.insert(buttons.requirement,requirement)
				buttons.action = {}
				buttons.onenter_action = {}
				buttons.onleave_action = {}
				buttons.margin = {}
				buttons.style = {}
				buttons.parent="multi_instance_varea"
				-- buttons.margin.top = 10
				-- buttons.margin.left = 350
				buttons.style.fontsize = 30
				buttons.style.width = 700
				buttons.style.height = 100
				
				local close_action = {}
				close_action = {}
				close_action.name = "select_user" 
				close_action.value = score
				table.insert(buttons.onenter_action,close_action)
				
				local descc = getLang("ui_keystone_instance_user_msg01")..score.pseudo
				descc= descc..
				"\n"..getLang("ui_keystone_instance_user_msg02")..tostring(score.avatar)..
				"\n".."X : "..tostring(score.x)..
				"\n".."Y : "..tostring(score.y)..
				"\n".."Z : "..tostring(score.z)
				close_action = {}
				close_action.name = "change_interface_label_text" 
				close_action.tag = "multi_instance_desc" 
				close_action.value = descc
				table.insert(buttons.onenter_action,close_action)
				table.insert(ui.controls,buttons)
			end
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg03")
	buttons.tag =	"multi_instance_btn_tp"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 150
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "tp_to_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_owner_msg01")
	buttons.tag =	"multi_instance_btn_kick"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 550
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "kick_instance_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg09")
	buttons.tag =	"multi_instance_btn_block"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 250
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "block_instance_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg07")
	buttons.tag =	"multi_instance_btn_unblock"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 450
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "unblock_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_instance_user_msg08")
	buttons.tag =	"multi_instance_btn_msg"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 750
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action = {}
	action.name = "close_interface"
	table.insert(buttons.action,action)
	action = {}
	action.name = "open_menu" 
	action.value = "phone"
	table.insert(buttons.action,action)
	action = {}
	action.name = "toggle_message_popup" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(#arrayInstanceList > 0 ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end

function Multi_FriendList()
	currentInterface = nil
	
	local ui = {}
	ui.title = getLang("ui_keystone_friend")
	ui.tag = "multi_instance_list"
	ui.controls = {}
	
	local descc = ""
	
	local label = {}
	label.type = "linebreak"
	label.tag ="multi_instance_lbk01"
	table.insert(ui.controls,label)
	
	local label = {}
	label.type = "label"
	label.tag ="loadinglb"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 350
	label.margin.left = 500
	label.style.fontsize = 65
	label.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value =  ""
	table.insert(ui.controls,label)
	label = {}
	label.type = "label"
	label.tag ="multi_instance_desc"
	label.trigger = {}
	label.trigger.auto = {}
	label.trigger.auto.name = "auto"
	label.margin = {}
	label.style = {}
	label.margin.top = 75
	label.margin.left = 900
	label.style.fontsize = 35
	label.requirement = {}
	requirement = {}
	table.insert(requirement,"auto")
	table.insert(label.requirement,requirement)
	label.value = {}
	label.value.type = "text"
	label.value.value = ""
	table.insert(ui.controls,label)
	
	local area = {}
	area.type = "scrollarea"
	area.tag =	"multi_instance_scroll"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local area = {}
	area.type = "vertical_area"
	area.tag =	"multi_instance_varea"
	area.trigger = {}
	area.trigger.auto = {}
	area.trigger.auto.name = "auto"
	area.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(area.requirement,requirement)
	area.action = {}
	area.margin = {}
	area.style = {}
	area.margin.top = 15
	area.parent = "multi_instance_scroll"
	area.style.fontsize = 30
	area.style.width = 800
	area.style.height = 350
	table.insert(ui.controls,area)
	
	local count = 15
	for k,v in pairs(ActualFriendList)  do
		
		local score = {}
		score.name=k
		score.data=v
		debugPrint(6,dump(score))
		
		if(score ~= nil) then
			buttons = {}
			buttons.type = "button"
			buttons.title = score.name
			buttons.tag =	"instance_"..score.name
			buttons.trigger = {}
			buttons.trigger.auto = {}
			buttons.trigger.auto.name = "auto"
			buttons.requirement = {}
			
			local requirement = {}
			table.insert(requirement,"auto")
			table.insert(buttons.requirement,requirement)
			buttons.action = {}
			buttons.onenter_action = {}
			buttons.onleave_action = {}
			buttons.margin = {}
			buttons.style = {}
			buttons.parent="multi_instance_varea"
			-- buttons.margin.top = 10
			-- buttons.margin.left = 350
			buttons.style.fontsize = 30
			buttons.style.width = 700
			buttons.style.height = 100
			
			local close_action = {}
			close_action = {}
			close_action.name = "select_friend" 
			close_action.value = score
			table.insert(buttons.onenter_action,close_action)
			
			local descc = getLang("ui_keystone_instance_user_msg01")..score.name
			close_action = {}
			close_action.name = "change_interface_label_text" 
			close_action.tag = "multi_instance_desc" 
			close_action.value = descc
			table.insert(buttons.onenter_action,close_action)
			table.insert(ui.controls,buttons)
		end
	end
	
	local buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_friend_join")
	buttons.tag =	"multi_instance_btn_tp"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 150
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "select_instance" 
	action.value = selectedFriend.data["instanceId"]
	table.insert(buttons.action,action)
	action = {}
	action.name = "connect_instance"
	table.insert(buttons.action,action)
	action = {}
	action.name = "close_interface" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_for_framework" 
	table.insert(buttons.action,action)
	action = {}
	action.name = "wait_second" 
	action.value = 1
	table.insert(buttons.action,action)
	action = {}
	action.name = "notify_instance"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_friend_delete")
	buttons.tag =	"multi_instance_btn_delete"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 250
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action.name = "delete_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title = getLang("ui_keystone_friend_block")
	buttons.tag =	"multi_instance_btn_block"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 350
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action = {}
	action.name = "block_user" 
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	buttons= {}
	buttons.type = "button"
	buttons.title =getLang("ui_keystone_instance_user_msg08")
	buttons.tag =	"multi_instance_btn_msg"
	buttons.trigger = {}
	buttons.trigger.auto = {}
	buttons.trigger.auto.name = "auto"
	buttons.requirement = {}
	
	local requirement = {}
	table.insert(requirement,"auto")
	table.insert(buttons.requirement,requirement)
	buttons.action = {}
	buttons.margin = {}
	buttons.style = {}
	buttons.margin.top = 550
	buttons.margin.left = 1250
	buttons.style.fontsize = 35
	buttons.style.width = 700
	buttons.style.height = 100
	
	local action = {}
	action = {}
	action = {}
	action.name = "close_interface"
	table.insert(buttons.action,action)
	action = {}
	action.name = "open_menu" 
	action.value = "phone"
	table.insert(buttons.action,action)
	action = {}
	action.name = "toggle_message_popup"
	table.insert(buttons.action,action)
	table.insert(ui.controls,buttons)
	
	if(ActualPlayersList ~= nil ) then
		currentInterface = ui
		
		if UIPopupsManager.IsReady() then
			
			local notificationData = inkGameNotificationData.new()
			notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
			notificationData.queueName = 'modal_popup'
			notificationData.isBlocking = true
			notificationData.useCursor = true
			UIPopupsManager.ShowPopup(notificationData)
			else
			Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
		end
	end
end



--interact--
function cycleInteract()
	--inputcount = inputcount +1
	
	currentInteractGroupIndex = currentInteractGroupIndex or 1

	debugPrint(6,"possibleInteractDisplay"..#possibleInteractDisplay)
	-- debugPrint(6,"currentInteractGroupIndex"..currentInteractGroupIndex)
	-- debugPrint(6,"currentInteractGroup"..currentInteractGroup[currentInteractGroupIndex])
	-- debugPrint(6,actionValue)

	if currentPossibleInteractChunkIndex == 0 then
		-- currentPossibleInteractChunkIndex = 1
		candisplayInteract = true
	end

	if candisplayInteract then
		currentPossibleInteractChunkIndex = currentPossibleInteractChunkIndex + 1

		getTriggeredActionsDisplay()

		debugPrint(6,"tyau")
		createInteraction(true)
	end

	if currentPossibleInteractChunkIndex > #possibleInteractDisplay then
		-- currentInteractGroupIndex = currentInteractGroupIndex + 1
		currentPossibleInteractChunkIndex = 0

		-- if(currentInteractGroupIndex > #currentInteractGroup) then
			-- currentInteractGroupIndex = 1
		-- end

		-- Game.GetPlayer():SetWarningMessage(getLang("current_interact_group")..currentInteractGroup[currentInteractGroupIndex])
	end

	if myobs.currentOptions then
		if myobs.id < 1 then
			if currentDialogHub then
				-- createInteraction(false)
				createDialog(currentDialogHub.dial)
				isdialogactivehub = true
			end
		else
			--createInteraction(true)
			isdialogactivehub = false
			debugPrint(6,"tyu")
		end
	else
		createInteraction(true)
		isdialogactivehub = false
		debugPrint(6,"tyuss")
	end

	inputInAction = false
end

function cycleInteractgroup()
	inputcount = inputcount +1

	debugPrint(6,"possibleInteractDisplay"..#possibleInteractDisplay)
	-- debugPrint(6,actionValue)

	if currentPossibleInteractChunkIndex == 0 then
		-- currentPossibleInteractChunkIndex = 1
		candisplayInteract = true
	end

	if candisplayInteract then
		currentPossibleInteractChunkIndex = currentPossibleInteractChunkIndex + 1

		getTriggeredActionsDisplay()

		createInteraction(true)
	end

	if currentPossibleInteractChunkIndex > #possibleInteractDisplay then
		currentPossibleInteractChunkIndex = 0

		if  currentInteractGroupIndex > #currentInteractGroup then
			currentInteractGroupIndex = 1
		end

		Game.GetPlayer():SetWarningMessage(getLang("current_interact_group")..currentInteractGroup[currentInteractGroupIndex])
	end

	if myobs.currentOptions ~= nil then
		if myobs.id < 1 then
			if currentDialogHub then
				-- createInteraction(false)
				createDialog(currentDialogHub.dial)
				isdialogactivehub = true
			end
		else
			--createInteraction(true)
			isdialogactivehub = false
		end
	else
		createInteraction(true)
		isdialogactivehub = false
	end
end

function hideInteract()
	if candisplayInteract then
		currentPossibleInteractChunkIndex = 0

		createInteraction(false)
		candisplayInteract = false
	end
end



---Radio---
function playRadio()
	
	if(currentRadio ~= nil and currentRadio.radio ~= nil) then
		
		if currentRadio.radio.tracks ~= nil and #currentRadio.radio.tracks > 0  then
			
			local canplay = true
			
			if(currentRadio.radio.only_in_car == true) then
				canplay = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
				else
				canplay = true
			end
			
			if(currentRadio.isplaying == nil and IsPlaying("music") == true) then
				Stop("music")
			end
			
			
			if(canplay and (IsPlaying("music") == false))then
				
				local index = math.random(1,#currentRadio.radio.tracks)
				
				local song = currentRadio.radio.tracks[index]
				currentRadio.isplaying = true
				
				local actionlist = {}
				
				local action = {}
				action = {}
				action.name = "play_sound_file"
				action.value = song.file
				action.datapack = currentRadio.namespace
				action.volume = currentRadioVolume
				action.channel = "music"
				table.insert(actionlist,action)
				runActionList(actionlist, "play_radio_radio_"..currentRadio.radio.tag, "interact",false,"nothing",true)
				else
				
				if(currentRadio.radio.only_in_car == true) then
					
					local iscar = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
					
					if(iscar == false) then
						
						Stop("music")
					end
				end
			end
		end
	end
end

function openRadio()
	if radiopopup and not popupActive then
		popupActive = true
		radiopopup:SpawnVehicleRadioPopup()
	end
end

function playRandomfromRadio()
	
	if currentRadio.tracks ~= nil and #currentRadio.tracks > 0 then
		
		if(IsPlaying("music") == false) then
			
			local canplay = true
			
			if(autoplayincar) then
				canplay = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
			end
			
			if(canplay)then
				
				local index = math.random(1,#currentRadio.tracks)
				
				local song = currentRadio.tracks[index]
				
				if(shuffleall) then
					local numitems = 0 -- find the size of the table
					
					for k,v in pairs(arrayRadio) do
						numitems = numitems + 1
					end

					local randval = math.random(1, numitems) -- get a random point

					local randentry
					local count = 0
					
					for k,v in pairs(arrayRadio) do
						count = count + 1
						if(count == randentry) then
							currentRadio = v.radio
							break
						end
					end
					
					index = math.random(1,#currentRadio.tracks)
					song = currentRadio.tracks[index]
				end
				
				local sound = getSoundByNameNamespace(song.file,currentRadio.namespace)
				
				if(sound ~= nil) then
					
					local path = questMod.soundpath..sound.path
					debugPrint(6,path..sound.name)
					PlaySound(sound.name,path,"music",currentRadioVolume)
					
					local message = SimpleScreenMessage.new()
					message.message = "Currently Playing : "..sound.name.." From Radio "..currentRadio.name
					message.isShown = true
					
					local blackboardDefs = Game.GetAllBlackboardDefs()
					
					local blackboardUI = Game.GetBlackboardSystem():Get(blackboardDefs.UI_Notifications)
					blackboardUI:SetVariant(
						blackboardDefs.UI_Notifications.OnscreenMessage,
						ToVariant(message),
						true
					)
				end
			end
			else
			
			if(autoplayincar) then
				
				local iscar = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
				
				if(iscar == false) then
					debugPrint(6,"stop music")
					Stop("music")
				end
			end
		end
	end
end

function RadioWindows()
	CPS.colorBegin("Button", IRPtheme.PhoneRadioButton)
	CPS.colorBegin("Text", IRPtheme.PhoneRadioText)
	
	if ImGui.BeginTabItem("Radio") then
		
		if ImGui.BeginTabBar("RadioTabs", ImGuiTabBarFlags.NoTooltip) then
			CPS.styleBegin("TabRounding", 0)
			for k,v in pairs(arrayRadio) do
				
				local radio = v.radio
				
				if ImGui.BeginTabItem(radio.name) then
					autoplayRadio = ImGui.Checkbox("AutoPlay", autoplayRadio)
					ImGui.SameLine()
					autoplayincar = ImGui.Checkbox("In Car Only ?", autoplayincar)
					ImGui.SameLine()
					shuffleall = ImGui.Checkbox("Shuffle All", shuffleall)
					ImGui.SameLine()
					
					if ImGui.Button("Pause/Resume", 100, 0) then
						
						if(pausemusic == false) then
							pausemusic = true
							Pause("music")
							else
							pausemusic = false
							Resume("music")
						end
					end
					ImGui.SameLine()
					
					if ImGui.Button("Stop", 100, 0) then
						Stop("music")
						currentRadio = {}
					end
					ImGui.SameLine()
					ImGui.PushItemWidth(150)  
					currentRadioVolume, used = ImGui.SliderInt("Volume", currentRadioVolume, 0, 100, "%d")
					for y = 1, #radio.tracks do
						
						local song = radio.tracks[y]
						
						if ImGui.Button(song.name, 300, 0) then
							currentRadio = radio
							
							local sound = getSoundByNameNamespace(song.file,currentRadio.namespace)
							
							if(sound ~= nil) then
								
								local path = questMod.soundpath..sound.path
								debugPrint(6,path..sound.name)
								PlaySound(sound.name,path,"music",currentRadioVolume)
							end
						end
					end
					ImGui.EndTabItem()
				end
			end
			CPS.styleEnd(1)
			ImGui.EndTabBar()
		end
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)
	CPS.colorEnd(1)
end


---UI factory---
function WindowsItem()
	
	if(currentInterface["values"] == nil) then
		currentInterface["values"] = {}
	end
	
	if ImGui.Begin(currentInterface.title) then
		ImGui.SetNextWindowPos(currentInterface.x, currentInterface.y, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowPos(currentInterface.x, currentInterface.y, ImGuiCond.FirstUseEver) -- set window position x, y
		ImGui.SetNextWindowSize(currentInterface.width, currentInterface.heigh, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(currentInterface.width, currentInterface.heigh)
		
		if ImGui.Button(lang.Close) then
			openInterface = false
		end
		ImGui.Spacing()
		ImGui.Spacing()
		ImGui.Spacing()
		windowsFactory()
		ImGui.End()
	end
end

function windowsFactory()
	for i=1,#currentInterface.controls do
		
		if(currentInterface.controls[i].type == "sameline") then
			ImGui.SameLine()
		end
		
		if(currentInterface.controls[i].type == "linebreak") then
			ImGui.Separator()
		end
		
		if(currentInterface.controls[i].type ~= "sameline" and currentInterface.controls[i].type ~= "linebreak") then
			
			if(checkTriggerRequirement(currentInterface.controls[i]["requirement"],currentInterface.controls[i]["trigger"])) then
				
				if(currentInterface.controls[i].type == "text") then
					
					if(currentInterface.controls[i].value.type == "text") then
						currentInterface["values"][currentInterface.controls[i].tag] = ImGui.InputText(currentInterface.controls[i].title, currentInterface["values"][currentInterface.controls[i].tag], 100, ImGuiInputTextFlags.AutoSelectAll)
						elseif(currentInterface.controls[i].value.type == "variable") then
						
						local variable = getVariableKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
						
						if(variable== nil) then
							variable = ""
						end
						currentInterface["values"][currentInterface.controls[i].tag] = ImGui.InputText(currentInterface.controls[i].title, variable, 100, ImGuiInputTextFlags.AutoSelectAll)
					end
				end
				
				if(currentInterface.controls[i].type == "label") then
					
					if(currentInterface.controls[i].value.type == "text") then
						ImGui.TextWrapped(currentInterface.controls[i].value.value)
						elseif(currentInterface.controls[i].value.type == "score") then
						
						local score = getScoreKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
						
						if(score== nil) then
							score = 0
						end
						ImGui.TextWrapped(score)
						elseif(currentInterface.controls[i].value.type == "variable") then
						
						local variable = getVariableKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
						
						if(variable== nil) then
							variable = ""
						end
						ImGui.TextWrapped(variable)
					end
				end
				
				if(currentInterface.controls[i].type == "number") then
					
					if(currentInterface.controls[i].value.type == "text") then
						currentInterface["values"][currentInterface.controls[i].tag] = ImGui.InputFloat(currentInterface.controls[i].title, currentInterface.controls[i].value, 1, 10, "%.1f", ImGuiInputTextFlags.None)
						elseif(currentInterface.controls[i].value.type == "score") then
						
						local score = getScoreKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
						
						if(score== nil) then
							score = 0
						end
						currentInterface["values"][currentInterface.controls[i].tag] = ImGui.InputFloat(currentInterface.controls[i].title, score, 1, 10, "%.1f", ImGuiInputTextFlags.None)
					end
				end
				
				if(currentInterface.controls[i].type == "button") then
					
					if ImGui.Button(currentInterface.controls[i].title) then
					end
				end
			end
		end
	end
end

function createButton(name, text, fontsize,width,height)
	
	local button = inkCanvas.new()
	button:SetName(name)
	button:SetSize(width, height)
	button:SetAnchorPoint(Vector2.new({ X = 0.5, Y = 0.5 }))
	button:SetInteractive(true)
	
	local bg = inkImage.new()
	bg:SetName('bg')
	bg:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
	bg:SetTexturePart('cell_bg')
	bg:SetTintColor(HDRColor.new({ Red = 0.054902, Green = 0.054902, Blue = 0.090196, Alpha = 1.0 }))
	bg:SetOpacity(0.8)
	bg:SetAnchor(inkEAnchor.Fill)
	bg.useNineSliceScale = true
	bg.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
	bg:Reparent(button, -1)
	
	local fill = inkImage.new()
	fill:SetName('fill')
	fill:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
	fill:SetTexturePart('cell_bg')
	fill:SetTintColor(HDRColor.new({ Red = 1.1761, Green = 0.3809, Blue = 0.3476, Alpha = 1.0 }))
	fill:SetOpacity(0.0)
	fill:SetAnchor(inkEAnchor.Fill)
	fill.useNineSliceScale = true
	fill.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
	fill:Reparent(button, -1)
	
	local frame = inkImage.new()
	frame:SetName('frame')
	frame:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
	frame:SetTexturePart('cell_fg')
	frame:SetTintColor(HDRColor.new({ Red = 0.368627, Green = 0.964706, Blue = 1.0, Alpha = 1.0 }))
	frame:SetOpacity(0.3)
	frame:SetAnchor(inkEAnchor.Fill)
	frame.useNineSliceScale = true
	frame.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
	frame:Reparent(button, -1)
	
	local label = inkText.new()
	label:SetName('label')
	label:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
	label:SetFontStyle('Medium')
	label:SetFontSize(fontsize)
	label:SetLetterCase(textLetterCase.UpperCase)
	label:SetTintColor(HDRColor.new({ Red = 1.1761, Green = 0.3809, Blue = 0.3476, Alpha = 1.0 }))
	label:SetAnchor(inkEAnchor.Fill)
	label:SetHorizontalAlignment(textHorizontalAlignment.Center)
	label:SetVerticalAlignment(textVerticalAlignment.Center)
	label:SetText(text)
	label:Reparent(button, -1)
	return button
end



---Native Interaction---
function createInteractionChoice(action, title)
	
	local choiceData =  InteractionChoiceData.new()
	choiceData.
	localizedName = title
	choiceData.inputAction = action
	
	local choiceType = ChoiceTypeWrapper.new()
	choiceData.type = choiceType
	return choiceData
end

function createInteractionHub(active)
	
	if(choiceHubData == nil) then
		choiceHubData =  gameinteractionsvisInteractionChoiceHubData.new()
		choiceHubData.active =true 
		choiceHubData.flags = EVisualizerDefinitionFlags.Undefined
		choiceHubData.title = "possibleInteractList" --'Test Interaction Hub'
	end
	choiceHubData.active = active
	
	local choices = {}
	possibleInteractdisplayUI = {}
	-- table.insert(choices, createInteraction('Choice1', 'Blow up the sky'))
	
	if(active == true) then
		
		if(#loadInteract > 0) then
			for z=1,#loadInteract do 
				local interact = arrayInteract[loadInteract[z]].interact
					if(interact.type == nil or interact.type == "interact") then
					
						if(interact.context ~= nil) then
								
							if(isArray(interact.context))then
								for i,v in ipairs(interact.context) do
									
									if(checkTriggerRequirement(v.requirement,v.trigger))then
										for k,u in pairs(v.prop) do
											local path =  splitDot(k, ".")
											setValueToTablePath(interact, path, GeneratefromContext(u))
											
										
										end
									end
								end
								else
								if(checkTriggerRequirement(interact.context.requirement,interact.context.trigger))then
									for k,u in pairs(action.context.prop) do
										
									
										local path =  splitDot(k, ".")
										setValueToTablePath(interact, path, GeneratefromContext(u))
											
									end
								end
							end
							
						end
					
					
						table.insert(choices, createInteractionChoice('Choice'..z, getLang(interact.name)))
					end
				end
		else
		
			if possibleInteractDisplay ~= nil and currentPossibleInteractChunkIndex ~= nil and #possibleInteractDisplay > 0  and possibleInteractDisplay[currentPossibleInteractChunkIndex] ~= nil then
				for z=1,#possibleInteractDisplay[currentPossibleInteractChunkIndex] do 
				
					local interact = possibleInteractDisplay[currentPossibleInteractChunkIndex][z]
					
					if(interact.context ~= nil) then
								
							if(isArray(interact.context))then
								for i,v in ipairs(interact.context) do
									
									if(checkTriggerRequirement(v.requirement,v.trigger))then
										for k,u in pairs(v.prop) do
											
												local path =  splitDot(k, ".")
										setValueToTablePath(interact, path, GeneratefromContext(u))
										end
									end
								end
								else
								if(checkTriggerRequirement(interact.context.requirement,interact.context.trigger))then
									for k,u in pairs(action.context.prop) do
										
											local path =  splitDot(k, ".")
										setValueToTablePath(interact, path, GeneratefromContext(u))
									end
								end
							end
							
						end
					
					if(interact.type == nil or interact.type == "interact") then
						interact.input = z
						table.insert(choices, createInteractionChoice('Choice'..z, getLang(interact.name)))
					else
						showInputHint(interact.key, getLang(interact.name), 1, interact.hold, interact.tag)
					end
				end
				
			end
		end
		else
		choiceHubData.id = 0 - math.random(50,1000)
	end
	choiceHubData.choices = choices
end




function prepareVisualizersInfo(hub)
	
	local visualizersInfo = VisualizersInfo.new()
	visualizersInfo.activeVisId = hub.id
	visualizersInfo.visIds = { hub.id }
	return visualizersInfo
end

function createInteraction(active)
	
	local blackboardDefs = Game.GetAllBlackboardDefs()
	
	local interactionBB = Game.GetBlackboardSystem():Get(blackboardDefs.UIInteractions)
	
	local value = FromVariant(interactionBB:GetVariant(blackboardDefs.UIInteractions.InteractionChoiceHub))
	createInteractionHub(active)
	
	local interactionHub = choiceHubData
	
	local visualizersInfo = prepareVisualizersInfo(interactionHub)
	interactionBB:SetVariant(blackboardDefs.UIInteractions.InteractionChoiceHub, ToVariant(interactionHub), true)
	interactionBB:SetVariant(blackboardDefs.UIInteractions.VisualizersInfo, ToVariant(visualizersInfo), true)
end


---Native Dialog---
function createDialog(dialog)
	isdialogactivehub = true
	candisplayInteract = false
	createInteraction(false)
	
	local dialogHub = createDialogHub(dialog,true)
	currentDialogHub = {}
	currentDialogHub.hub= {}
	currentDialogHub.dial = {}
	currentDialogHub.index = 1
	currentDialogHub.hub = dialogHub
	currentDialogHub.dial = dialog
	
	local blackboardDefs = Game.GetAllBlackboardDefs()
	
	local interactionBB = Game.GetBlackboardSystem():Get(blackboardDefs.UIInteractions)
	interactionBB:SetVariant(blackboardDefs.UIInteractions.DialogChoiceHubs, ToVariant(dialogHub), true)
	isdialogactivehub = true
	
	if(playerisstopped == false) then
		StatusEffectHelper.ApplyStatusEffect(Game.GetPlayer(), "GameplayRestriction.FistFight")
		playerisstopped = true
	end
end

function createDialogHub(dialogIIRP,active)
	
	local choiceHubDataDial =  gameinteractionsvisDialogChoiceHubs.new()
	
	local choiceHubs = {}
	
	if(active == true) then
		table.insert(choiceHubs ,createDialogTitle(dialogIIRP,active))
	end
	choiceHubDataDial.choiceHubs = choiceHubs
	return choiceHubDataDial
end

function createDialogTitle(dialogIIRP,active)
	
	local dialog =  gameinteractionsvisListChoiceHubData.new()
	dialog.id = 0 - math.random(50,1000)
	
	if(active == true) then
		dialog.activityState =Enum.new('gameinteractionsvisEVisualizerActivityState', 'Active')
		else
		dialog.activityState =Enum.new('gameinteractionsvisEVisualizerActivityState', 'None')
	end
	dialog.flags = Enum.new('gameinteractionsvisEVisualizerDefinitionFlags', 'HeadlineSelection')
	dialog.isPhoneLockActive = true
	dialog.title =  getDialogOwner(dialogIIRP.speaker.value)
	dialog.hubPriority  = 0
	dialog.activityState  =  Enum.new('gameinteractionsvisEVisualizerActivityState', 'Active')
	
	local choices = {}
	for i = 1, #dialogIIRP.options do
		
		local option = dialogIIRP.options[i]
		dialogIIRP.options[i].input = i
		table.insert(choices, creatDialogChoice('Choice'..i, getLang(option.Description)))
	end
	dialog.choices = choices
	return dialog
end


function getDialogOwner(speaker)
	
	local result = speaker
	
	if(speaker == "any") then
		if(currentNPC ~= nil) then
			result = currentNPC.Names
		elseif(currentStar ~= nil) then
			result = currentStar.Names
		else
			result = speaker
		end
	end
	
	return result
	
end

function creatDialogChoice(action, title)
	
	local choiceData =  gameinteractionsvisListChoiceData.new()
	choiceData.
	localizedName = getLang(title)
	choiceData.inputAction = action
	
	local choiceType = ChoiceTypeWrapper.new()
	choiceType:SetType(choiceType,Enum.new('gameinteractionsChoiceType', 'Inactive'))
	choiceData.type = choiceType
	return choiceData
end

function removeDialog()
	
	local blackboardDefs = Game.GetAllBlackboardDefs()
	
	local interactionBB = Game.GetBlackboardSystem():Get(blackboardDefs.UIInteractions)
	interactionBB:SetVariant(blackboardDefs.UIInteractions.DialogChoiceHubs, ToVariant(gameinteractionsvisDialogChoiceHubs.new()), true)
	
	if(playerisstopped == true) then
		StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), "GameplayRestriction.FistFight")
		playerisstopped = false
	end
end
