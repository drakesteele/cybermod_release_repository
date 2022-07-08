debugPrint(3,"CyberMod: observer module loaded")
questMod.module = questMod.module +1

---Observer and Overrider---
function SetOverrider()

	Override("MessengerGameController","PopulateData", function(this) 
		local data = MessengerUtils.GetContactDataArray(this.journalManager,true,true,this.activeData)
		-- for i=1,#data do
		-- spdlog.info(GameDump(data[i].data))
		-- end
		if(multiReady and OnlineConversation ~= nil) then
			onlineInstanceMessageProcessing()
			local phoneConversation = OnlineConversation
			spdlog.error(JSON:encode_pretty(phoneConversation))
			if(getScoreKey(phoneConversation.tag,"unlocked") == nil or getScoreKey(phoneConversation.tag,"unlocked") == 1) then
				if phoneConversation.hash == nil then
					OnlineConversation.hash = 0 - tonumber("1308"..math.random(1,999))
					
					phoneConversation.hash = OnlineConversation.hash
				end
				local itemData = ContactData.new()
				itemData.id = phoneConversation.tag
				itemData.localizedName  = phoneConversation.speaker
				itemData.avatarID = TweakDBID.new("Character.Judy")
				itemData.questRelated  =  false
				local unreadcount = 0
				itemData.unreadMessages  = {}
				if(#phoneConversation.conversation > 0) then
					for z=1,#phoneConversation.conversation do
						if(phoneConversation.conversation[z].message ~= nil and #phoneConversation.conversation[z].message > 0) then
							for y=1,#phoneConversation.conversation[z].message do
								if(phoneConversation.conversation[z].message[y].readed == false and (getScoreKey(phoneConversation.conversation[z].message[y].tag,"unlocked") == nil or getScoreKey(phoneConversation.conversation[z].message[y].tag,"unlocked") == 1)) then
									unreadcount = unreadcount + 1
									table.insert(itemData.unreadMessages ,unreadcount)
									itemData.playerCanReply   =  true
								end
							end
						end
					end
				end
				itemData.hasMessages   =  true
				itemData.unreadMessegeCount  = unreadcount
				itemData.playerIsLastSender   =  false
				itemData.lastMesssagePreview  =  "Cyberpunk Multiverse"
				itemData.threadsCount  = #phoneConversation.conversation
				itemData.timeStamp = Game.GetTimeSystem():GetGameTime()
				itemData.hash = phoneConversation.hash
				local contactVirtualListData =  VirutalNestedListData.new()
				contactVirtualListData.level =  phoneConversation.hash
				contactVirtualListData.widgetType = 0
				contactVirtualListData.isHeader = true
				contactVirtualListData.data = itemData
				contactVirtualListData.collapsable = true
				contactVirtualListData.forceToTopWithinLevel  = true
				table.insert(data,contactVirtualListData)
				for z=1,#phoneConversation.conversation do
					unreadcount = 0
					itemData.unreadMessages  = {}
					local conversation = phoneConversation.conversation[z]
					if(getScoreKey(conversation.tag,"unlocked") == nil or getScoreKey(conversation.tag,"unlocked") == 1) then
						if(conversation.message ~= nil and #conversation.message > 0) then
							for y=1,#conversation.message do
								if(conversation.message[y].readed == false and (getScoreKey(conversation.message[y].tag,"unlocked") == nil or getScoreKey(conversation.message[y].tag,"unlocked") == 1)) then
									unreadcount = unreadcount + 1
									table.insert(itemData.unreadMessages ,unreadcount)
									itemData.playerCanReply   =  true
								end
							end
						end
						local itemData = ContactData.new()
						itemData.id = conversation.tag
						itemData.localizedName  = conversation.name
						itemData.avatarID = TweakDBID.new("Character.Judy")
						itemData.questRelated  =  false
						itemData.hasMessages   =  true
						itemData.unreadMessegeCount  = unreadcount
						itemData.playerIsLastSender   =  false
						itemData.lastMesssagePreview  =  "Cyberpunk Multiverse"
						OnlineConversation.conversation[z].hash =0 - tonumber(tostring(phoneConversation.hash)..math.random(1,100))
						conversation.hash = OnlineConversation.conversation[z].hash
						
						itemData.threadsCount  = 0
						itemData.timeStamp = Game.GetTimeSystem():GetGameTime()
						itemData.hash = conversation.hash
						local contactVirtualListData =  VirutalNestedListData.new()
						contactVirtualListData.level = phoneConversation.hash
						contactVirtualListData.widgetType = 1
						contactVirtualListData.isHeader = false
						contactVirtualListData.data = itemData
						contactVirtualListData.collapsable = false
						table.insert(data,contactVirtualListData)
					end
				end
			end
		end
		for k,v in pairs(arrayPhoneConversation) do
			local phoneConversation = v.conv
			debugPrint(1,phoneConversation.tag)
			if(getScoreKey(phoneConversation.tag,"unlocked") == nil or getScoreKey(phoneConversation.tag,"unlocked") == 1) then
				if phoneConversation.hash == nil then
					arrayPhoneConversation[k].conv.hash = 0 - tonumber("1308"..math.random(1,999))
					
					phoneConversation.hash = arrayPhoneConversation[k].conv.hash
				end
				local itemData = ContactData.new()
				itemData.id = phoneConversation.tag
				itemData.localizedName  = phoneConversation.speaker
				itemData.avatarID = TweakDBID.new("Character.Judy")
				itemData.questRelated  =  false
				local unreadcount = 0
				itemData.unreadMessages  = {}
				for z=1,#phoneConversation.conversation do
					if(phoneConversation.conversation[z].message ~= nil and #phoneConversation.conversation[z].message >0) then
						for y=1,#phoneConversation.conversation[z].message do
							if(phoneConversation.conversation[z].message[y].readed == false and (getScoreKey(phoneConversation.conversation[z].message[y].tag,"unlocked") == nil or getScoreKey(phoneConversation.conversation[z].message[y].tag,"unlocked") == 1)) then
								unreadcount = unreadcount + 1
								table.insert(itemData.unreadMessages ,unreadcount)
								itemData.playerCanReply   =  true
							end
						end
					end
				end
				itemData.hasMessages   =  true
				itemData.unreadMessegeCount  = unreadcount
				itemData.playerIsLastSender   =  false
				itemData.lastMesssagePreview  =  "Cyberpunk Multiverse"
				itemData.threadsCount  = #phoneConversation.conversation
				itemData.timeStamp = Game.GetTimeSystem():GetGameTime()
				itemData.hash = phoneConversation.hash
				local contactVirtualListData =  VirutalNestedListData.new()
				contactVirtualListData.level =  phoneConversation.hash
				contactVirtualListData.widgetType = 0
				contactVirtualListData.isHeader = true
				contactVirtualListData.data = itemData
				contactVirtualListData.collapsable = true
				table.insert(data,contactVirtualListData)
				for z=1,#phoneConversation.conversation do
					unreadcount = 0
					itemData.unreadMessages  = {}
					local conversation = phoneConversation.conversation[z]
					if(getScoreKey(conversation.tag,"unlocked") == nil or getScoreKey(conversation.tag,"unlocked") == 1) then
						if(conversation.message ~= nil and #conversation.message>0) then
							for y=1,#conversation.message do
								if(conversation.message[y].readed == false and (getScoreKey(conversation.message[y].tag,"unlocked") == nil or getScoreKey(conversation.message[y].tag,"unlocked") == 1)) then
									unreadcount = unreadcount + 1
									table.insert(itemData.unreadMessages ,unreadcount)
									itemData.playerCanReply   =  true
								end
							end
						end
						local itemData = ContactData.new()
						itemData.id = conversation.tag
						itemData.localizedName  = conversation.name
						itemData.avatarID = TweakDBID.new("Character.Judy")
						itemData.questRelated  =  false
						itemData.hasMessages   =  true
						itemData.unreadMessegeCount  = unreadcount
						itemData.playerIsLastSender   =  false
						itemData.lastMesssagePreview  =  "Cyberpunk Multiverse"
						arrayPhoneConversation[k].conv.conversation[z].hash =0 - tonumber(tostring(phoneConversation.hash)..math.random(1,100))
						conversation.hash = arrayPhoneConversation[k].conv.conversation[z].hash
						
						itemData.threadsCount  = 0
						itemData.timeStamp = Game.GetTimeSystem():GetGameTime()
						itemData.hash = conversation.hash
						local contactVirtualListData =  VirutalNestedListData.new()
						contactVirtualListData.level = phoneConversation.hash
						contactVirtualListData.widgetType = 1
						contactVirtualListData.isHeader = false
						contactVirtualListData.data = itemData
						contactVirtualListData.collapsable = false
						table.insert(data,contactVirtualListData)
					end
				end
			end
		end
		this.listController:SetData(data, true)
	end)

	Override('PlayerPuppet', 'OnLookAtObjectChangedEvent', function(this)
		this.isAimingAtFriendly = false
		this.isAimingAtChild = false
	end)

	Override('NcartTimetableControllerPS', 'UpdateCurrentTimeToDepart', function(self)
		if(activeMetroDisplay == true) then
			self.currentTimeToDepart = MetroCurrentTime
			--NewMetroTime = 0
			--debugPrint(1,MetroCurrentTime)
			else
			self.currentTimeToDepart = self.currentTimeToDepart  - self.ncartTimetableSetup.uiUpdateFrequency
			if self.currentTimeToDepart < 0 then
				self:ResetTimeToDepart()
			end
		end
	end)

	Override('PhoneDialerGameController','CallSelectedContact',function(this, wrappedMethod)
	
	local callRequest = nil
	local item = this.listController:GetSelectedItem()
	local contactData = item:GetContactData()
	
		if IsDefined(contactData) and contactData.lastMesssagePreview ~= "cybermod" then
		
				return wrappedMethod()
			
		end
	end
	)

	Override("PhoneDialerGameController", "PopulateData", function(this)
		local contactDataArray = this.journalManager:GetContactDataArray(false)
		------printdump(contactDataArray))
		if(#contactList > 0) then
			for i = 1, #contactList do
				local itemData = ContactData.new()
				itemData.id = contactList[i].id
				itemData.localizedName  = contactList[i].name
				itemData.avatarID = TweakDBID.new(contactList[i].avatarID)
				itemData.questRelated  =  false
				itemData.hasMessages   =  true
				itemData.unreadMessegeCount  = 13
				itemData.unreadMessages  = {}
				itemData.playerCanReply   =  false
				itemData.playerIsLastSender   =  false
				itemData.lastMesssagePreview  =  "cybermod"
				itemData.threadsCount  = 0
				itemData.timeStamp = Game.GetTimeSystem():GetGameTime()
				itemData.hash  = 0
				table.insert(contactDataArray,itemData)
			end
		end
		-- for i = 1,#contactDataArray do
		------printGameDump(contactDataArray[i]))
		-- end
		--table.sort(contactDataArray)
		this.dataView:EnableSorting();
		this.dataSource:Reset(contactDataArray);
		this.dataView:DisableSorting();
		this.firstInit = true;
		--	----printGameDump(_.dataView))
	end)

	Override("ShardsMenuGameController", "PopulateData", function(this)
		local counter = 0
		local groupData
		local groupVirtualListData
		local i
		local items
		local level
		local success = false
		local newEntries
		local tagsFilter = {}
		local toti = {}
		local data = {}
		groupData = ShardEntryData.new()
		groupData.title = "CyberMod"
		groupData.activeDataSync = this.activeData
		groupData.counter = 9999
		groupData.isNew = this.hasNewCryptedEntries
		groupData.newEntries = newEntries
		groupVirtualListData = VirutalNestedListData.new()
		groupVirtualListData.level = 9999
		groupVirtualListData.widgetType = 1
		groupVirtualListData.isHeader = true
		groupVirtualListData.data = groupData
		groupVirtualListData.forceToTopWithinLevel  = true
		table.insert(data, groupVirtualListData)
		local datatemp = CodexUtils.GetShardsDataArray(this.journalManager,this.activeData)
		table.insert(tagsFilter, CName("HideInBackpackUI"))
		items = this.InventoryManager:GetPlayerItemsByType(gamedataItemType.Gen_Misc, tagsFilter)
		counter = 0
		level = #data+1
		this.hasNewCryptedEntries = false
		i = 1
		local textAffinity = "Affinity"
		for i = 1,#arrayPnjDb  do
			local score = getScoreKey(arrayPnjDb[i].Names,"Score")
			if score ~= nil and score > 1 then
				textAffinity = textAffinity.."\n "..arrayPnjDb[i].Names.." : "..score
			end
		end
		local shardData =  ShardEntryData.new()
		shardData.title = "CM : NPC Affinity"
		shardData.description = textAffinity
		shardData.activeDataSync = this.activeData
		shardData.counter = counter
		shardData.isNew = true
		shardData.imageId = datatemp[i].imageId
		shardData.hash = -9998
		shardData.activeDataSync = this.activeData
		shardData.isCrypted = false
		shardData.itemID = datatemp[i].itemID
		table.insert(shardData.newEntries, shardData.hash)
		local shardVirtualListData = VirutalNestedListData.new()
		groupVirtualListData.level = 9999
		shardVirtualListData.widgetType = 0
		shardVirtualListData.isHeader = false
		shardVirtualListData.data = shardData
		table.insert(data, shardVirtualListData)
		textAffinity = "Gang Affinity"
		for k,v in pairs(arrayFaction) do
			local score = getScorebyTag(k)
			if score ~= nil then
				textAffinity = textAffinity.."\n "..arrayFaction[k].faction.Name.." : "..score
			end
		end
		local shardData =  ShardEntryData.new()
		shardData.title = "CM : Gang Affinity"
		shardData.description = textAffinity
		shardData.activeDataSync = this.activeData
		shardData.counter = counter
		shardData.isNew = true
		shardData.imageId = datatemp[i].imageId
		shardData.hash = -9999
		shardData.activeDataSync = this.activeData
		shardData.isCrypted = false
		shardData.itemID = datatemp[i].itemID
		table.insert(shardData.newEntries, shardData.hash)
		local shardVirtualListData = VirutalNestedListData.new()
		groupVirtualListData.level = 9999
		shardVirtualListData.widgetType = 0
		shardVirtualListData.isHeader = false
		shardVirtualListData.data = shardData
		table.insert(data, shardVirtualListData)
		for i = 1,#arrayHelp do
			local shard = arrayHelp[i]
			local description = ""
			for y=1,#shard.section do
				description = description..shard.section[y].."\n"
			end
			local shardData =  ShardEntryData.new()
			shardData.title = "CM Wiki : "..getLang(shard.title)
			shardData.description = description
			shardData.activeDataSync = this.activeData
			shardData.counter = counter
			shardData.isNew = false
			shardData.imageId = datatemp[2].imageId
			shardData.hash = -(i+8000)
			shardData.activeDataSync = this.activeData
			shardData.isCrypted = false
			shardData.itemID = datatemp[1].imageId
			table.insert(shardData.newEntries, shardData.hash)
			local shardVirtualListData = VirutalNestedListData.new()
			groupVirtualListData.level = 9999
			shardVirtualListData.widgetType = 0
			shardVirtualListData.isHeader = false
			shardVirtualListData.data = shardData
			table.insert(data, shardVirtualListData)
		end
		for i = 1,#arrayShard do
			local shard = arrayShard[i]
			if((getScoreKey(shard.tag,"Score") == nil and shard.locked == false) or getScoreKey(shard.tag,"Score") == 0) then
				local shardData =  ShardEntryData.new()
				shardData.title = "CM : "..shard.title
				shardData.description = shard.description
				shardData.activeDataSync = this.activeData
				shardData.counter = counter
				shardData.isNew = shard.new
				shardData.imageId = datatemp[1].imageId
				shardData.hash = -i
				shardData.activeDataSync = this.activeData
				shardData.isCrypted = shard.crypted
				shardData.itemID = datatemp[1].itemID
				table.insert(shardData.newEntries, shardData.hash)
				local shardVirtualListData = VirutalNestedListData.new()
				groupVirtualListData.level = 9999
				shardVirtualListData.widgetType = 0
				shardVirtualListData.isHeader = false
				shardVirtualListData.data = shardData
				table.insert(data, shardVirtualListData)
			end
		end
		while i < #items+1 do
			--	  if this.ProcessItem(items[i], data, level, newEntries) then
			--counter = counte + 1
			--	  end
			success,toti = this:ProcessItem(items[i], level, newEntries)
			------printtostring(success))
			if success == true then
				counter = counter + 1
			end	
			i = i +1
		end
		if counter >= 1 then
			groupData = ShardEntryData.new()
			groupData.title = GetLocalizedText("Story-base-gameplay-static_data-database-scanning-scanning-quest_clue_template_04_localizedDescription")
			groupData.activeDataSync = this.activeData
			groupData.counter = counter
			groupData.isNew = this.hasNewCryptedEntries
			groupData.newEntries = newEntries
			groupVirtualListData = VirutalNestedListData.new()
			groupVirtualListData.level = level
			groupVirtualListData.widgetType = 1
			groupVirtualListData.isHeader = true
			groupVirtualListData.data = groupData
			table.insert(data, groupVirtualListData)
		end
		for i=1,#datatemp do
			datatemp[i].level = i+1
			table.insert(data,datatemp[i])
		end
		local datatemp2 = data
		data = {}
		local count = 0
		for i = 1,#datatemp2 do
			if(datatemp2[i].isHeader == true ) then
				count = count +1
				datatemp2[i].level = count
				else
				datatemp2[i].level = count
			end
			table.insert(data,datatemp2[i])
		end
		if #data <= 0 then
			this:ShowNodataWarning()
			else 
			this:HideNodataWarning()
			this.listController:SetData(data, true, true)
		end
		
		this:RefreshButtonHints()
	end)
	
	Override('WorldMapMenuGameController','OnGangListItemSpawned', function(self,gangWidget,userData) 
	
	end)
	
	Override('WorldMapMenuGameController','OnSelectedDistrictChanged', function(self,oldDistrict,newDistrict) 
		self:ShowGangsInfo(newDistrict)
	end)
	
	Override('WorldMapGangItemController','SetData', function(self,affiliationRecord) 
	
		if(CurrentGang ~= nil) then
	
			
				inkTextRef.SetText(self.factionNameText, CurrentGang)
				inkImageRef.SetTexturePart(self.factionIconImage, CName(CurrentGangLogo))
			
		end
	end)
	
	Override('ComputerMainLayoutWidgetController', 'InitializeMenuButtons', function(this, gameController, widgetsData,wrappedMethod)
		wrappedMethod(gameController,widgetsData)
		if(currentHouse ~= nil) then
			local test = this
			local gameCon = gameController
			local wid = widget
			
			local widget = SComputerMenuButtonWidgetPackage.new()
			widget.libraryID = widgetsData[2].libraryID 
			widget.widgetTweakDBID = widgetsData[2].widgetTweakDBID 
			widget.widget = widgetsData[2].widget 
			widget.widgetName = widgetsData[2].widgetName 
			widget.placement = widgetsData[2].placement 
			widget.isValid = widgetsData[2].isValid 
			widget.displayName = widgetsData[2].displayName 
			widget.ownerID = widgetsData[2].ownerID 
			widget.ownerIDClassName = widgetsData[2].ownerIDClassName 
			widget.customData = widgetsData[2].customData 
			widget.isWidgetInactive = widgetsData[2].isWidgetInactive 
			widget.widgetState = widgetsData[2].widgetState 
			widget.iconID = widgetsData[2].iconID 
			widget.bckgroundTextureID = widgetsData[2].bckgroundTextureID 
			widget.iconTextureID = widgetsData[2].iconTextureID 
			widget.textData = widgetsData[2].textData 
			widget.counter = widgetsData[2].counter 
			widget.displayName = "CyberMod"
			widget.widgetName = "CyberMod"
			local widgeto = this:CreateMenuButtonWidget(gameController, inkWidgetRef.Get(this.menuButtonList), widget);
			this:AddMenuButtonWidget(widgeto, widget, gameController)
			this:InitializeMenuButtonWidget(gameController, widgeto, widget)
		end
	end)
	
	Override('ComputerMainLayoutWidgetController', 'ShowInternet', function(this, startingPage,wrappedMethod)
		if(startingPage == "CyberMod") then
			this:GetWindowContainer():SetVisible(true)
			Keystone_Load()
			else
			wrappedMethod(startingPage)
		end
	end)
	
	Override('ComputerInkGameController', 'ShowMenuByName', function(this, elementName, wrappedMethod)
		if(elementName == "CyberMod") then
			local internetData = (this:GetOwner():GetDevicePS()):GetInternetData()
			this:GetMainLayoutController():ShowInternet("CyberMod")
			this:RequestMainMenuButtonWidgetsUpdate()
			else
			wrappedMethod(elementName)
		end
	end)
	
	Override('BrowserController', 'TryGetWebsiteData', function(this, address, wrappedMethod)
		if(address == "CyberMod") then
			return wrappedMethod("NETdir://ncity.pub")
			else
			return wrappedMethod(address)
		end
	end)
	
	Override('WorldMapMenuGameController', 'ShowGangsInfo', function(self,district)
		
			local zoomlevel = self:GetCurrentZoom()
			debugPrint(1,zoomlevel)
			
			if(currentMapDistrictView ~= gameuiEWorldMapDistrictView.None or zoomlevel > 7000) then
		
			local districtRecord = nil
			
			if(currentMapDistrictView == gameuiEWorldMapDistrictView.Districts or currentMapDistrictView == nil or mapSubDistrict == nil) then
				
				districtRecord =  MappinUtils.GetDistrictRecord(district)
				inkWidgetRef.SetVisible(self.subdistrictNameText, false)
				
			else
				districtRecord =  MappinUtils.GetDistrictRecord(mapSubDistrict)
				inkWidgetRef.SetVisible(self.subdistrictNameText, true)
				
			end
			
			local enum = "Badlands"
			
			if(districtRecord ~= nil and districtRecord:EnumName() ~= nil and districtRecord:EnumName() ~= "" and districtRecord:EnumName() ~= "Null") then
				enum = districtRecord:EnumName()
			end
			
			
			
			inkCompoundRef.RemoveAllChildren(self.gangsList)
			
			inkWidgetRef.SetVisible(self.gangsInfoContainer, true)
			
			local mydistrict = nil
			 
			
			if(currentMapDistrictView == gameuiEWorldMapDistrictView.Districts or currentMapDistrictView == nil or enum == "Badlands") then
	
				local dis =getDistrictfromEnum(enum)
				if(dis == nil) then
				mydistrict = enum
				else
				mydistrict = dis.Tag
				end
				
				else
				mydistrict = enum
			end
			
		
			
			if(mydistrict ~= nil) then
			if(multiReady and ActualPlayerMultiData.guildscores ~= nil) then
					local guilds = getGuildfromDistrict(mydistrict,-5)
					if(#guilds > 0) then
						for i=1,#guilds do 
						
							local gangWidget = self:SpawnFromLocal(inkWidgetRef.Get(self.gangsList), CName("GangListItem"))
							local gangController = gangWidget:GetController()
							
							CurrentGang =  guilds[i].tag.." ("..guilds[i].score..")"
							CurrentGangLogo = "logo_netwatch"
							
							
							gangController:SetData(gamedataAffiliation_Record.new())
						end
					end
			
			else
			
			
			
				local gangs = {}
				gangs = getGangfromDistrict(mydistrict,20)
				if(#gangs > 0) then
					for i=1,#gangs do 
						
						local gangWidget = self:SpawnFromLocal(inkWidgetRef.Get(self.gangsList), CName("GangListItem"))
						local gangController = gangWidget:GetController()
						local gang = getFactionByTag(gangs[i].tag)
						
						if(gang ~= nil) then
						CurrentGang = gang.Name.." ("..gangs[i].score..")"
						CurrentGangLogo = gang.Logo
						
							
						gangController:SetData(gamedataAffiliation_Record.new())
						else
						spdlog.error("can't get gang for tag "..gangs[i].tag.." for district "..mydistrict)
						end
					end
				end
				
				
				end
			end
			
			else
			
			inkWidgetRef.SetVisible(self.gangsInfoContainer, false)
			
			
			end
	end)

end

function SetObserver()
	QuestJournalUI.Initialize()
	
	QuestTrackerUI.Initialize()
	
	ObserveAfter('VehiclesManagerListItemController', 'OnDataChanged', function(this,value)
	
	
	if(tostring(this.vehicleData.displayName) == "None")then
		inkTextRef.SetText(this.label, tostring(NameToString(this.vehicleData.data.name)));
	end
	
	end)
	
	ObserveAfter('VehiclesManagerListItemController', 'OnSelected', function(this,itemController,discreteNav)
	
	
	if(tostring(this.vehicleData.displayName) == "None")then
		inkTextRef.SetText(this.label, tostring(NameToString(this.vehicleData.data.name)));
	end
	
	end)
	
	ObserveAfter('IncomingCallGameController', 'OnInitialize', function(this)
	incomingCallGameController = this
	end)
	
	ObserveAfter('IncomingCallGameController', 'GetIncomingContact', function(this)
	incomingCallGameController = this
	end)
	
	ObserveAfter('IncomingCallGameController', 'OnPhoneCall', function(this)
	incomingCallGameController = this
	end)
	
	ObserveAfter('TutorialPopupGameController', 'OnInitialize', function(this)
		TutorialPopupGameController = this
		
	end)
	
	ObserveAfter('TutorialPopupGameController', 'OnPlayerAttach', function(this,playerPuppet)
		TutorialPopupGameController = this
	
	end)
	
	ObserveBefore('WorldMapMenuGameController', 'GetDistrictAnimation', function(this,view ,show)
		debugPrint(1,tostring(view))
		
	end)
	
	ObserveAfter('WorldMapMenuGameController', 'GetDistrictAnimation', function(this,view ,show)
		debugPrint(1,tostring(view))
		if(show == true or view == gameuiEWorldMapDistrictView.None) then
		
			
			currentMapDistrictView = view
		
			
		end
		
		if(view == gameuiEWorldMapDistrictView.None) then
			
				inkWidgetRef.SetVisible(this.gangsInfoContainer, false)
				
		end
		
		this:ShowGangsInfo(mapDistrict)
	end)
	
	ObserveAfter('TrackQuestNotificationAction', 'TrackFirstObjective', function(this,questEntry)
	

	if(questEntry ~= nil or questEntry.id == nil or questEntry.id == "")then
		
		local quest = getQuestByTag(questEntry.districtID)
					
						
		if(quest ~= nil and getScoreKey(quest.tag,"Score") <= 3 and currentQuest == nil ) then
			
			--untrackQuest()
		
			
		
			
			local objective = QuestManager.GetFirstObjectiveEntry(quest.tag)
			

			
			
			if QuestManager.IsKnownQuest(quest.tag) then
				if QuestManager.IsQuestComplete(quest.tag) then
					
					return
				end
			
				QuestManager.MarkQuestAsVisited(quest.tag)
				QuestManager.MarkQuestAsActive(quest.tag)
				QuestManager.MarkObjectiveAsActive(objective.id)
				
				
				QuestManager.TrackObjective(objective.id,true)
			end
		
		end
	end
	end)
	
	ObserveAfter('WorldMapMenuGameController', 'OnUpdateHoveredDistricts', function(this,district,subdistrict)
		
		if(subdistrict ~= gamedataDistrict.Invalid) then
			mapSubDistrict = subdistrict
			else
			mapSubDistrict = nil
		end
		
		mapDistrict = district
		
		
		if(currentMapDistrictView == gameuiEWorldMapDistrictView.Districts or currentMapDistrictView == nil or subdistrict == gamedataDistrict.Invalid) then
				
				
				inkWidgetRef.SetVisible(this.subdistrictNameText, false)
				
			else
				
				inkWidgetRef.SetVisible(this.subdistrictNameText, true)
				
		end
		
	end)
	
	ObserveAfter('WorldMapMenuGameController', 'OnSelectedDistrictChanged', function(this,oldDistrict,newDistrict)
		
		
		
		
		if(currentMapDistrictView == gameuiEWorldMapDistrictView.Districts or currentMapDistrictView == nil or newDistrict == gamedataDistrict.Invalid) then
				
				
				inkWidgetRef.SetVisible(this.subdistrictNameText, false)
				
			else
				
				inkWidgetRef.SetVisible(this.subdistrictNameText, true)
				
		end
		
		if(currentMapDistrictView == gameuiEWorldMapDistrictView.Districts or currentMapDistrictView == nil ) then
				
				
				mapSubDistrict = nil
				
			else
				
				mapSubDistrict = newDistrict
				this:ShowGangsInfo(mapDistrict)
				
		end
		
	
	end)
	
	ObserveAfter('WorldMapMenuGameController', 'OnZoomLevelChanged', function(this,oldLevel,newLevel)
		
		
		local zoomlevel = this:GetCurrentZoom()
		
			
		if( zoomlevel < 7000) then
		
		inkWidgetRef.SetVisible(this.gangsInfoContainer, false)
		end
	
	end)
	
	ObserveBefore('WorldMapMenuGameController', 'OnSetUserData', function(this,userData )
		setNewFixersPoint()
		setCustomLocationPoint() 
	
	end)
	Observe("SettingsMainGameController", "RequestClose", function (_, _, target) -- Check if activated button is the custom mods button
		
		if(AutoRefreshDatapack == true) then
			LoadDataPackCache()
		end
	end)

	Observe('PlayerPuppet', 'OnGameAttached', function(this)
		startListeners(this)
	end)

	Observe('JournalNotificationQueue','OnMenuUpdate', function(self)
		----debugPrint(1,"obs2")
		JournalNotificationQueue = self
	end)

	Observe('BaseWorldMapMappinController', 'SelectMappin', function(self)
		if(self.mappin ~= nil) then
			SelectedMappinMetro = nil
			SelectedScriptMappin = nil
			SelectedMappinHouse = nil
			ActivecustomMappin = nil
			local mappinType = self.mappin:GetVariant()
			local wordpos = self.mappin:GetWorldPosition()
			ActivecustomMappin = self.mappin
			if mappinType == gamedataMappinVariant.FastTravelVariant then
				ActiveFastTravelMappin = {}
				ActiveFastTravelMappin.markerRef = self.mappin:GetPointData():GetMarkerRef()
				ActiveFastTravelMappin.position = self.mappin:GetWorldPosition()
			end
			if(
				mappinType == gamedataMappinVariant.ApartmentVariant or
				mappinType == gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant or
				mappinType == gamedataMappinVariant.ServicePointFoodVariant or
				mappinType == gamedataMappinVariant.ServicePointBarVariant or
				mappinType == gamedataMappinVariant.ServicePointJunkVariant) then
			local haveFounded = false
			-- local test = {}
			-- table.insert(test,arrayHouse["playerhouse01"])
			for _,v in pairs(arrayHouse) do 
				if(math.floor(v.house.posX) == math.floor(wordpos.x) and math.floor(v.house.posY) == math.floor(wordpos.y) and math.floor(v.house.posZ) == math.floor(wordpos.z)) then
					SelectedMappinHouse = v.house
					haveFounded = true
				end
			end
			else
			if(mappinType == gamedataMappinVariant.Zzz01_CarForPurchaseVariant) then
				--debugPrint(1,"Metro ?")
				local haveFounded = false
				for k,v in pairs(arrayNode) do 
					local mappin = v.node
					if(mappin.sort == "metro") then
						if(math.floor(mappin.GameplayX) == math.floor(wordpos.x) and math.floor(mappin.GameplayY) == math.floor(wordpos.y) and math.floor(mappin.GameplayZ) == math.floor(wordpos.z)) then
							SelectedMappinMetro = mappin
							haveFounded = true
							--debugPrint(1,"Mine")
							break
						end
					end
				end
				else
				local haveFounded = false
				for _,v in pairs(mappinManager) do 
					local mappin = v
					if(math.floor(mappin.position.x) == math.floor(wordpos.x) and math.floor(mappin.position.y) == math.floor(wordpos.y) and math.floor(mappin.position.z) == math.floor(wordpos.z)) then
						SelectedScriptMappin = mappin
						break
					end
				end
			end
			end
		end
	end)
	
	--region CyberMod Estates

	ObserveAfter('BrowserController', 'OnPageSpawned', function(this, widget, userData)
		if(this.defaultDevicePage == "CyberMod") then
			inkTextRef.SetText(this.addressText, "NETdir://cybermod.mod");
		end
		if(CurrentAddress == "NETdir://ezestates.web/renovations" and BrowserCustomPlace ~= nil) then
			inkTextRef.SetText(this.addressText, "NETdir://ezestates.web/cybermod/estates")
		end
	end)

	ObserveAfter('BrowserController', 'LoadWebPage', function(self,address)
		CurrentAddress = address
		debugPrint(1,CurrentAddress)
		-- Cron.NextTick(function()
		if(CurrentAddress ~= "NETdir://ezestates.web/renovations") then
			BrowserCustomPlace = nil
		end
		debugPrint(1,BrowserCustomPlace)
		-- end)
	end)

	ObserveAfter('WebPage', 'OnInitialize', function(self)
		LinkController = self
	end)
	
	ObserveAfter('WebPage', 'FillPageFromJournal', function(self,page,journalManager)
		if(CurrentAddress == "NETdir://ezestates.web/for_rent") then
			LinkController = inkWidgetRef.GetController(self.textList[1])
			local root = self.textList[1].widget.parentWidget.parentWidget
			debugPrint(1,"obs6")
			debugPrint(1,tostring(GameDump(root)))
			root:SetVisible(true)
			local texts = page:GetTexts()
			debugPrint(1,"obs6")
			local buttonData = {
				name = StringToName("testButton"),
				text = "CyberMod Estates",
				value = 1,
				tag =  "testButton"
			}
			local fontsize = uifont
			local black = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
			local yellow = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
			local buttonComponent = UIButton.Create(buttonData.name, buttonData.text,50, self.textList[1].widget.parentWidget:GetSize().X,  self.textList[1].widget.parentWidget:GetSize().Y,{top=600,left=475},yellow,black)
			buttonComponent:Reparent(root, -1)
			buttonComponent:RegisterCallback('OnRelease', function(_, evt)
				if(self.textList ~= nil) then
					local linkController = LinkController
					if linkController ~= nil then
						linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
						self.lastClickedLinkAddress = linkController:GetLinkAddress()
						self:CallCustomCallback("OnLinkPressed")
						CurrentAddress = "NETdir://ezestates.web/renovations"
						BrowserCustomPlace = "main"
						else 
						debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
					end
				end  
				evt:Handle()
			end)
			local root2 = self.imageList[4].widget.parentWidget.parentWidget.parentWidget.parentWidget
			debugPrint(1,tostring(GameDump(root2)))
			root2:SetVisible(true)
			local nightcity01 = self.textList[11].widget
			nightcity01:SetVisible(false)
			local nightcity02 = self.textList[11].widget.parentWidget
			nightcity02:SetVisible(false)
		end
		if(CurrentAddress == "NETdir://ezestates.web/renovations" and BrowserCustomPlace ~= nil) then
			LinkController = inkWidgetRef.GetController(self.textList[1])
			local root = self.textList[1].widget.parentWidget.parentWidget
			debugPrint(1,tostring(GameDump(root)))
			local texts = page:GetTexts()
			debugPrint(1,"obs6")
			local buttonData = {
				name = StringToName("testButton"),
				text = "CyberMod Estates",
				value = 1,
				tag =  "testButton"
			}
			local fontsize = uifont
			local black = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
			local yellow = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
			local buttonComponent = UIButton.Create(buttonData.name, buttonData.text,50, self.textList[1].widget.parentWidget:GetSize().X,  self.textList[1].widget.parentWidget:GetSize().Y,{top=600,left=475},yellow,black)
			buttonComponent:Reparent(root, -1)
			buttonComponent:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					self:CallCustomCallback("OnLinkPressed")
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "main"
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
				end
				evt:Handle()
			end)
			local anquestion = self.textList[15].widget.parentWidget
			local anquestion_margin = anquestion:GetMargin()
			anquestion_margin.top = anquestion_margin.top+250
			anquestion:SetMargin(anquestion_margin)
			local anquestion_height = anquestion:GetHeight()
			anquestion_height = anquestion_height-150
			anquestion:SetHeight(anquestion_height)
			local texts = page:GetTexts()
			local textcolor = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
			local bgcolor = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
			self.textList[2].widget:SetTintColor(bgcolor)
			self.textList[2].widget.parentWidget:SetTintColor(bgcolor)
			self.imageList[2].widget:SetTintColor(textcolor)
			local itemcontainer = self.textList[3].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local itemcontainer = self.textList[4].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local itemcontainer = self.textList[5].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local itemcontainer = self.textList[6].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local itemcontainer = self.textList[7].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local itemcontainer = self.textList[8].widget.parentWidget.parentWidget.parentWidget
			itemcontainer:SetVisible(false)
			local anquestionPics = self.textList[15].widget
			anquestionPics:SetText("An Bug ? An Suggestions ?")
			anquestionPics:SetFontSize(35)
			local contactUs = self.textList[16].widget
			contactUs:SetText("Go to CyberMod Discord for Help !")
			contactUs:SetFontSize(35)
		end
		if(CurrentAddress == "NETdir://ezestates.web/renovations" and BrowserCustomPlace == "main") then
			local texts = page:GetTexts()
			debugPrint(1,"obs6")
			local fontsize = uifont
			local black = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
			local yellow = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
			local textList = #self.textList
			local root2 = self.textList[4].widget.parentWidget.parentWidget.parentWidget.parentWidget.parentWidget
			local heigh = 100
			local width = 2800
			local fontsize = uifont
			local black = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
			local yellow = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
			local leftm = 500
			local btn_house = UIButton.Create("btn_house", "Our Houses",50, width, heigh ,{top=150,left=leftm},black,yellow)
			btn_house:Reparent(root2, 0)
			btn_house:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "house"
					self:CallCustomCallback("OnLinkPressed")
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[3])) + "]")
				end
				evt:Handle()
			end)
			local btn_bar = UIButton.Create("btn_bar", "Our bars",50, width, heigh ,{top=150,left=leftm},black,yellow)
			btn_bar:Reparent(root2, 1)
			btn_bar:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "bar"
					self:CallCustomCallback("OnLinkPressed")
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
				end
				evt:Handle()
			end)
			local btn_nightclub = UIButton.Create("btn_nightclub", "Our nightclubs",50, width, heigh ,{top=150,left=leftm},black,yellow)
			btn_nightclub:Reparent(root2, 2)
			btn_nightclub:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "nightclub"
					self:CallCustomCallback("OnLinkPressed")
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
				end
				evt:Handle()
			end)
			local btn_shops = UIButton.Create("btn_shops", "Our Shops",50, width, heigh ,{top=150,left=leftm},black,yellow)
			btn_shops:Reparent(root2, 4)
			btn_shops:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "shopping"
					self:CallCustomCallback("OnLinkPressed")
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
				end
				evt:Handle()
			end)
			local btn_restaurant = UIButton.Create("btn_restaurant", "Our restaurants",50, width, heigh ,{top=150,left=leftm},black,yellow)
			btn_restaurant:Reparent(root2, 3)
			btn_restaurant:RegisterCallback('OnRelease', function(_, evt)
				local linkController = LinkController
				if linkController ~= nil then
					linkController:SetLinkAddress("NETdir://ezestates.web/renovations")
					self.lastClickedLinkAddress = linkController:GetLinkAddress()
					CurrentAddress = "NETdir://ezestates.web/renovations"
					BrowserCustomPlace = "restaurant"
					self:CallCustomCallback("OnLinkPressed")
					else 
					debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
				end
				evt:Handle()
			end)
		end
		if(CurrentAddress == "NETdir://ezestates.web/renovations" and BrowserCustomPlace ~= nil and BrowserCustomPlace ~= "main") then
			-- local textList = #self.textList
			-- debugPrint(1,"textList "..textList)
			--Hide current Items
			local textink = self.textList[4].widget
			local textcontainer = self.textList[4].widget.parentWidget
			local buttonink = self.textList[4].widget.parentWidget.parentWidget
			local itemcontainer = self.textList[4].widget.parentWidget.parentWidget.parentWidget
			local rowcontainer = self.textList[4].widget.parentWidget.parentWidget.parentWidget.parentWidget
			local verticalarea = self.textList[4].widget.parentWidget.parentWidget.parentWidget.parentWidget.parentWidget
			local scrollarea = self.textList[4].widget.parentWidget.parentWidget.parentWidget.parentWidget.parentWidget.parentWidget
			local tempcount = 0
			local temparrayHouse = {}
			local obj = {}
			local housetype = 0
			if(BrowserCustomPlace == "house") then
				housetype = 0
			end
			if(BrowserCustomPlace == "bar") then
				housetype = 1
			end
			if(BrowserCustomPlace == "nightclub") then
				housetype = 2
			end
			if(BrowserCustomPlace == "restaurant") then
				housetype = 3
			end
			if(BrowserCustomPlace == "shopping") then
				housetype = 4
			end
			for k,v in pairs(arrayHouse) do 
				if(v.house.type == housetype) then
					if(#obj < 2) then
						table.insert(obj,v.house)
						else
						table.insert(temparrayHouse,obj)
						obj = {}
						table.insert(obj,v.house)
					end
				end
			end
			debugPrint(1,"House count :"..#temparrayHouse)
			local marginleft = 50
			local topleft = 0
			for i=1,#temparrayHouse do 
				local rowcontainerhouse = inkHorizontalPanelWidget.new()
				rowcontainerhouse:SetName(CName.new("rowcontainer_house_"..i))
				rowcontainerhouse:SetSize(Vector2.new({ X = 2120, Y = 500 }))
				rowcontainerhouse:SetMargin(inkMargin.new({ top = 50, bottom = 50 }))
				rowcontainerhouse:Reparent(verticalarea)
				-- local rowcontainerhouse = inkCanvasWidget.new()
				-- rowcontainerhouse:SetName(CName.new("rowcontainer_house_"..i))
				-- rowcontainerhouse:SetSize(Vector2.new({ X = 2120, Y = 500 }))
				-- rowcontainerhouse:SetMargin(inkMargin.new({ top = 50, bottom = 50 }))
				-- rowcontainerhouse:SetMargin(inkMargin.new({ bottom = 50 }))
				-- rowcontainerhouse:Reparent(verticalarea)
				for y=1,#temparrayHouse[i] do
					local house = temparrayHouse[i][y]
					local score = getScoreKey(house.tag,"Score")
					if(house.isbuyable == true and (score == nil or score == 0)) then
						local canvas = inkCanvasWidget.new()
						canvas:SetName(CName.new("canvas_house_"..house.tag))
						canvas:SetSize(Vector2.new({ X = 874, Y = 491 }))
						canvas:SetMargin(inkMargin.new({ bottom = 50 }))
						canvas:Reparent(rowcontainerhouse)
						local bg = inkImage.new()
						bg:SetName(CName.new("bg_house_"..house.tag))
						bg:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
						bg:SetTexturePart('cell_bg')
						bg:SetTintColor(HDRColor.new({ Red = 0.054902, Green = 0.054902, Blue = 0.090196, Alpha = 1.0 }))
						bg:SetOpacity(0.8)
						bg:SetAnchor(inkEAnchor.Fill)
						bg.useNineSliceScale = true
						bg.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
						bg:SetInteractive(false)
						bg:Reparent(canvas, -1)
						local fill = inkImage.new()
						fill:SetName("fill_house_"..house.tag)
						fill:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
						fill:SetTexturePart('cell_bg')
						fill:SetTintColor(HDRColor.new({ Red = 1.1761, Green = 0.3809, Blue = 0.3476, Alpha = 1.0 }))
						fill:SetOpacity(0.0)
						fill:SetAnchor(inkEAnchor.Fill)
						fill.useNineSliceScale = true
						fill.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
						fill:SetInteractive(false)
						fill:Reparent(canvas, -1)
						local frame = inkImage.new()
						frame:SetName("frame_house_"..house.tag)
						frame:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas'))
						frame:SetTexturePart('cell_fg')
						frame:SetTintColor(HDRColor.new({ Red = 0.368627, Green = 0.964706, Blue = 1.0, Alpha = 1.0 }))
						frame:SetOpacity(0.3)
						frame:SetAnchor(inkEAnchor.Fill)
						frame.useNineSliceScale = true
						frame.nineSliceScale = inkMargin.new({ left = 0.0, top = 0.0, right = 10.0, bottom = 0.0 })
						frame:SetInteractive(false)
						frame:Reparent(canvas, -1)
						local textinkhousename = inkText.new()
						textinkhousename:SetName(CName.new("text_house_"..house.tag.."_Name"))
						textinkhousename:SetText("Name : "..house.name)
						textinkhousename:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
						textinkhousename:SetFontStyle('Medium')
						textinkhousename:SetFontSize(35)
						textinkhousename:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
						textinkhousename:SetHorizontalAlignment(textHorizontalAlignment.Center)
						textinkhousename:SetVerticalAlignment(textVerticalAlignment.Center)
						textinkhousename:SetMargin(inkMargin.new({ left = 50, top = 0 }))
						textinkhousename:Reparent(canvas,-1)
						local textinkhouseprice = inkText.new()
						textinkhouseprice:SetName(CName.new("text_house_"..house.tag.."_price"))
						textinkhouseprice:SetText("Price : "..house.price.." €$")
						textinkhouseprice:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
						textinkhouseprice:SetFontStyle('Medium')
						textinkhouseprice:SetFontSize(35)
						textinkhouseprice:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
						textinkhouseprice:SetHorizontalAlignment(textHorizontalAlignment.Center)
						textinkhouseprice:SetVerticalAlignment(textVerticalAlignment.Center)
						textinkhouseprice:SetMargin(inkMargin.new({ left = 50, top = 50 }))
						textinkhouseprice:Reparent(canvas,-1)
						local textinkhousedesc = inkText.new()
						textinkhousedesc:SetName(CName.new("text_house_"..house.tag.."_desc"))
						if(house.desc == nil) then
							textinkhousedesc:SetText("No description about this place. Come back later !")
							else
							local splitContentRequ = splitByChunk(house.desc,50)
							local result = ""
							for i,v in ipairs(splitContentRequ) do
								result = result..v.."\n"
							end
							textinkhousedesc:SetText(result)
						end
						textinkhousedesc:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
						textinkhousedesc:SetFontStyle('Medium')
						textinkhousedesc:SetFontSize(35)
						textinkhousedesc:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
						textinkhousedesc:SetHorizontalAlignment(textHorizontalAlignment.Center)
						textinkhousedesc:SetVerticalAlignment(textVerticalAlignment.Center)
						textinkhousedesc:SetMargin(inkMargin.new({ left = 50, top = 100 }))
						textinkhousedesc:Reparent(canvas,-1)
						local buttonData = {
							name = "text_house_"..house.tag.."_buy",
							text = "Buy",
							value = 1,
							tag =  "text_house_"..house.tag.."_buy"
						}
						local fontsize = uifont
						local blackbgcolor = Color.ToHDRColorDirect(Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 1.0 }))
						local goldtextcolor = Color.ToHDRColorDirect(Color.new({ Red = 255, Green = 220, Blue = 16, Alpha = 1.0 }))
						local buy_btn= UIButton.Create(buttonData.name, buttonData.text,50, 300, 100,{top=420,left=650},blackbgcolor,goldtextcolor)
						buy_btn:Reparent(canvas, -1)
						buy_btn:RegisterCallback('OnRelease', function(_, evt)
							local onenter_action = {}
							local action = {}
							action.name = "buyHouse"
							action.tag = house.tag
							table.insert(onenter_action,action)
							local action = {}
							action.name = "notify"
							action.value = "Place Buyed !"
							table.insert(onenter_action,action)
							local action = {}
							action.name = "set_mappin"
							action.position = "custom_place"
							action.position_tag = house.tag
							action.position_house_way = "default"
							action.tag =  house.tag
							action.typemap = "Zzz05_ApartmentToPurchaseVariant"
							action.wall =  true
							action.active =  false
							action.x = 0
							action.y = 0
							action.z = 0
							table.insert(onenter_action,action)
							runActionList(onenter_action, "test_onenter", "interact",false,"nothing",false)
							local linkController = LinkController
							if linkController ~= nil then
								linkController:SetLinkAddress("NETdir://ezestates.web/for_rent")
								self.lastClickedLinkAddress = linkController:GetLinkAddress()
								CurrentAddress = "NETdir://ezestates.web/for_rent"
								BrowserCustomPlace = nil
								self:CallCustomCallback("OnLinkPressed")
								else 
								debugPrint(1,"Missing LinkController for a widget [" + NameToString(inkWidgetRef.GetName(self.textList[1])) + "]")
							end
							evt:Handle()
						end)
					end
				end
			end
		end
	end)
	
	--endregion CyberMod Estates
	ObserveAfter('WorldMapTooltipController', 'SetData', function(self,data,menu)
	local mappinVariant = nil
		
		if( data.mappin ~= nil) then
		
		mappinVariant = data.mappin:GetVariant()
		
		end
		if(SelectedScriptMappin ~= nil) then
			if(mappinVariant ~= nil and mappinVariant == gamedataMappinVariant.FixerVariant) then
			inkTextRef.SetText(self.gigBarCompletedText, "")
			inkTextRef.SetText(self.gigBarTotalText, "")
			
			inkImageRef.SetVisible(self.icon, false)
			
			inkWidgetRef.SetVisible(self.descText, true)
			inkWidgetRef.SetVisible(self.fixerPanel, true)
		end
		else
		inkWidgetRef.SetVisible(self.icon, true)
		end
	end)
	
	ObserveAfter('WorldMapTooltipContainer', 'SetData', function(self,target,data,menu)
		
		local displayXYZ = getUserSetting("displayXYZ")
		local mappinVariant = nil
		
		if( data.mappin ~= nil) then
		
		mappinVariant = data.mappin:GetVariant()
		
		end
		
		if(SelectedMappinHouse ~= nil or SelectedMappinMetro ~= nil or SelectedScriptMappin ~= nil) then
			inkWidgetRef.SetVisible(self.defaultTooltipController.descText, true)
			if(SelectedMappinHouse ~= nil) then
				inkTextRef.SetText(self.defaultTooltipController.titleText, SelectedMappinHouse.name)
				local desc = getLang("bebought")..tostring(SelectedMappinHouse.isbuyable)
				desc = desc.."\n"..getLang("price")..tostring(SelectedMappinHouse.price)
				desc = desc.."\n"..getLang("canhavebusiness")..tostring(SelectedMappinHouse.isrentable)
				desc = desc.."\n"..getLang("defaultsalary")..tostring(SelectedMappinHouse.rent)
				desc = desc.."\n"..getLang("prestige")..tostring(SelectedMappinHouse.coef)
				local position = ActivecustomMappin:GetWorldPosition()
				local postext = "\n X :"..math.floor(position.x).." \n Y: "..math.floor(position.y).." \n Z: "..math.floor(position.z)
				if(displayXYZ ~= nil and displayXYZ == 1) then
					inkTextRef.SetText(self.defaultTooltipController.descText, desc..postext)
					else
					inkTextRef.SetText(self.defaultTooltipController.descText, desc)
				end
				SelectedMappinHouse = nil
				elseif(SelectedMappinMetro ~= nil) then
				inkTextRef.SetText(self.titleText, getLang("metro_station")..SelectedMappinMetro.name)
				local desc = getLang("metro_available")
				local position = ActivecustomMappin:GetWorldPosition()
				local postext = "\n X :"..math.floor(position.x).." \n Y: "..math.floor(position.y).." \n Z: "..math.floor(position.z)
				if(displayXYZ ~= nil and displayXYZ == 1) then
					inkTextRef.SetText(self.defaultTooltipController.descText, desc..postext)
					else
					inkTextRef.SetText(self.defaultTooltipController.descText, desc)
				end
				SelectedMappinMetro = nil
				elseif(SelectedScriptMappin ~= nil) then
				
				inkTextRef.SetText(self.defaultTooltipController.titleText, getLang(SelectedScriptMappin.title))
				local position = ActivecustomMappin:GetWorldPosition()
				local postext = "\n X :"..math.floor(position.x).." \n Y: "..math.floor(position.y).." \n Z: "..math.floor(position.z)
				if(displayXYZ ~= nil and displayXYZ == 1) then
					inkTextRef.SetText(self.defaultTooltipController.descText, getLang(SelectedScriptMappin.desc)..postext)
					else
					inkTextRef.SetText(self.defaultTooltipController.descText, getLang(SelectedScriptMappin.desc))
				end
				
				SelectedScriptMappin = nil
			end
			else
			if(ActivecustomMappin ~= nil) then
				local position = ActivecustomMappin:GetWorldPosition()
				local postext = "\n X :"..math.floor(position.x).." \n Y: "..math.floor(position.y).." \n Z: "..math.floor(position.z)
				if(displayXYZ ~= nil and displayXYZ == 1) then
					inkWidgetRef.SetVisible(self.defaultTooltipController.descText, true)
					inkTextRef.SetText(self.defaultTooltipController.descText,  self.defaultTooltipController.descText:GetText()..postext)
				end
			end
		end
	end)

	Observe('WorldMapMenuGameController', 'UntrackCustomPositionMappin', function(self)
		ActivecustomMappin = nil
		--debugPrint(1,"obs3")
	end)

	ObserveAfter('BraindanceGameController','OnInitialize', function(self)
	
		BraindanceGameController = self
		local root = self.rootWidget.parentWidget 
		
		
		
		root:SetVisible(true)
		
		
		
		container = inkCanvas.new()
		container:SetName(CName.new("pos_container"))
		container:SetAnchor(inkEAnchor.Fill)
		container:Reparent(root, -1)
		
		posWdiget = inkText.new()
		posWdiget:SetName(CName.new("posWdiget"))
		posWdiget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		posWdiget:SetFontStyle('Medium')
		posWdiget:SetFontSize(22)
		posWdiget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		posWdiget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		posWdiget:SetVerticalAlignment(textVerticalAlignment.Center)
		posWdiget:Reparent(container, -1)
		
		districtWidget = inkText.new()
		districtWidget:SetName(CName.new("districtWidget"))
		districtWidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		districtWidget:SetFontStyle('Medium')
		districtWidget:SetFontSize(25)
		districtWidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		districtWidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		districtWidget:SetVerticalAlignment(textVerticalAlignment.Center)
		districtWidget:Reparent(container, -1)
		
		subdistrictWidget = inkText.new()
		subdistrictWidget:SetName(CName.new("districtWidget"))
		subdistrictWidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		subdistrictWidget:SetFontStyle('Medium')
		subdistrictWidget:SetFontSize(25)
		subdistrictWidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		subdistrictWidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		subdistrictWidget:SetVerticalAlignment(textVerticalAlignment.Center)
		subdistrictWidget:Reparent(container, -1)
		
				
		roomwidget = inkText.new()
		roomwidget:SetName(CName.new("roomwidget"))
		roomwidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		roomwidget:SetFontStyle('Medium')
		roomwidget:SetFontSize(25)
		roomwidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		roomwidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		roomwidget:SetVerticalAlignment(textVerticalAlignment.Center)
		roomwidget:Reparent(container, -1)
		
		placemultiwidget = inkText.new()
		placemultiwidget:SetName(CName.new("placemultiwidget"))
		placemultiwidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		placemultiwidget:SetFontStyle('Medium')
		placemultiwidget:SetFontSize(25)
		placemultiwidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		placemultiwidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		placemultiwidget:SetVerticalAlignment(textVerticalAlignment.Center)
		placemultiwidget:Reparent(container, -1)
		
		multistatewidget = inkText.new()
		multistatewidget:SetName(CName.new("multistatewidget"))
		multistatewidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		multistatewidget:SetFontStyle('Medium')
		multistatewidget:SetFontSize(25)
		multistatewidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		multistatewidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		multistatewidget:SetVerticalAlignment(textVerticalAlignment.Center)
		multistatewidget:Reparent(container, -1)
		
		timerwidget = inkText.new()
		timerwidget:SetName(CName.new("timerwidget"))
		timerwidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		timerwidget:SetFontStyle('Medium')
		timerwidget:SetFontSize(25)
		timerwidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		timerwidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		timerwidget:SetVerticalAlignment(textVerticalAlignment.Center)
		timerwidget:Reparent(container, -1)
		
		factionwidget = inkCanvas.new()
		factionwidget:SetName(CName.new("factionwidget"))
		
		factionwidget:SetAnchor(inkEAnchor.Fill)
		
		factionwidget:Reparent(container, -1)
		
		
		factiontitle = inkText.new()
		factiontitle:SetName(CName.new("factiontitle"))
		factiontitle:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		factiontitle:SetFontStyle('Medium')
		factiontitle:SetFontSize(25)
		factiontitle:SetText("Faction : ")
		factiontitle:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		factiontitle:SetHorizontalAlignment(textHorizontalAlignment.Center)
		factiontitle:SetVerticalAlignment(textVerticalAlignment.Center)
		factiontitle:Reparent(factionwidget, -1)
		
		avspeedwidget = inkText.new()
		avspeedwidget:SetName(CName.new("avspeedwidget"))
		avspeedwidget:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
		avspeedwidget:SetFontStyle('Medium')
		avspeedwidget:SetFontSize(35)
		avspeedwidget:SetText("Speed : 0 m/s")
		avspeedwidget:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
		avspeedwidget:SetHorizontalAlignment(textHorizontalAlignment.Center)
		avspeedwidget:SetVerticalAlignment(textVerticalAlignment.Center)
		avspeedwidget:Reparent(container, -1)
		
		
		if(healthbarwidget == nil) then
			healthbarwidget = root
		end
	end)

	Observe('QuestTrackerGameController', 'OnInitialize', function()
		--debugPrint(1,"obs7")
		if not isGameLoaded then
			--debugPrint(1,'Game Session Started')
			isGameLoaded = true
			draw = true
		end
	end)

	Observe('QuestTrackerGameController', 'OnUninitialize', function()
		--debugPrint(1,"obs8")
		if Game.GetPlayer() == nil then
			--debugPrint(1,'Game Session Ended')
			workerTable = {}
			despawnAll()
			isGameLoaded = false
			draw = false
		end
	end)

	Observe('interactionWidgetGameController', 'OnInitialize', function(self)
		--debugPrint(1,"obs8")
		Cron.NextTick(function()
			myobs = self
			--debugPrint(1,"new interact hub")
		end)
	end)

	ObserveAfter('ChattersGameController','OnInitialize', function(self) 
		--debugPrint(1,"obs99")
		
			currentChattersGameController = self
			--debugPrint(1,"Chat Sub Controller Init")
		
	end)
	
	ObserveAfter('ChattersGameController','OnPlayerAttach', function(self,playerGameObject) 
		--debugPrint(1,"obs99")
		
			currentChattersGameController = self
			--debugPrint(1,"Chat Sub Controller Init")
	end)

	ObserveAfter('SubtitlesGameController','OnInitialize', function(self) 
		currentSubtitlesGameController = self
	end)
	
	
	Observe('interactionWidgetGameController', 'OnItemSpawned', function(self)
		--debugPrint(1,"obs8")
		if(myobs == nil) then
			Cron.NextTick(function()
				myobs = self
				debugPrint(1,"new interact hub")
			end)
		end
	end)

	Observe('ChattersGameController','SetupLine', function(self) 
		if(currentChattersGameController == nil) then
			--debugPrint(1,"obs99")
			Cron.NextTick(function()
				currentChattersGameController = self
				debugPrint(1,"Chat Sub Controller Init")
			end)
		end
	end)

	Observe('SubtitlesGameController','SetupLine', function(self) 
		--debugPrint(1,"obs999")
		if(currentSubtitlesGameController == nil) then
			Cron.NextTick(function()
				currentSubtitlesGameController = self
				debugPrint(1,"Sub Controller Init")
			end)
		end
	end)

	Observe('BaseSubtitlesGameController','OnUninitialize', function(self) 
		--debugPrint(1,"obs988")
		currentChattersGameController = nil
		currentSubtitlesGameController = nil
	end)

	
	Observe('NPCPuppet', 'SendAfterDeathOrDefeatEvent', function(target)
		if target ~= nil and target.shouldDie and ((target.myKiller ~= nil and target.myKiller:GetEntityID().hash == Game.GetPlayer():GetEntityID().hash) or target.wasJustKilledOrDefeated) then
		
		lastTargetKilled = target
		print("last killed target")
			
		else
		  lastTargetKilled = nil
		end
	end)
	
	
	
	
	
	
	
	
	
	Observe('MessengerGameController','OnContactActivated', function(self,evt) 
			debugPrint(1,"MessengerGameController.OnContactActivated")
		debugPrint(1,GameDump(evt))
		--if(currentSubtController == nil) then
		currentPhoneConversation = nil
		if (messageprocessing == false) then
			messageprocessing = true
			debugPrint(1,tostring(evt.type))
			if (string.find(tostring(evt.entryHash), "1308")and evt.type == MessengerContactType.Thread) then
				for k,v in pairs(arrayPhoneConversation) do
					local phoneConversation = v.conv
					for z=1,#phoneConversation.conversation do
						local conversation = phoneConversation.conversation[z]
						if(conversation.hash == evt.entryHash)then
							currentPhoneConversation = phoneConversation.conversation[z]
							currentPhoneConversation.currentchoices = {}
							currentPhoneConversation.loaded = 0
							onlineReceiver = nil
							local test = gameJournalPhoneMessage.new()
							self.dialogController:ShowThread(test)
						end
					end
				end
				if(multiReady and OnlineConversation ~= nil) then
					for z=1,#OnlineConversation.conversation do
						local conversation = OnlineConversation.conversation[z]
						if(conversation.hash == evt.entryHash)then
							currentPhoneConversation = OnlineConversation.conversation[z]
							currentPhoneConversation.currentchoices = {}
							currentPhoneConversation.loaded = 0
							onlineReceiver = OnlineConversation.conversation[z].name
							local test = gameJournalPhoneMessage.new()
							self.dialogController:ShowThread(test)
						end
					end
				end
				else
				currentPhoneConversation = nil
				onlineReceiver = nil
			end
			messageprocessing = false
		end
	end)
	
	ObserveAfter('MessengerDialogViewController','SetVisited', function(this, records) 
		debugPrint(1,"MessengerDialogViewController.SetVisited")
		local messages = this.messages
		local choices = this.replyOptions
		MessengerGameController = this
	
		if(currentPhoneConversation ~= nil) then
		
				debugPrint(1,currentPhoneConversation.loaded)
			currentPhoneConversation.loaded = currentPhoneConversation.loaded + 1
			if(currentPhoneConversation ~= nil and currentPhoneConversation.loaded >= 1) then
				currentPhoneConversation.loaded = 0
			
				
					
				for i=1,#currentPhoneConversation.message do
					local msgexist = false
					local sms = currentPhoneConversation.message[i]
					if( getScoreKey(sms.tag,"unlocked") == 1) then
						if(sms.unlocknext ~= nil and sms.unlocknext ~= "") then
							setScore(sms.unlocknext,"unlocked",1)
						end
						local test = gameJournalPhoneMessage.new()
						test.sender = sms.sender
						test.text = getLang(sms.text)
						test.delay = -9999
						test.id = sms.tag
						for y=1,#messages do
							if(test.id == messages[y].id) then
								msgexist = true
							end
						end
						if(msgexist == false) then
							table.insert(messages,test)
						end
						if(#sms.choices > 0) then
							if(getScoreKey(sms.tag,"unlocked") == 1) then
								for z=1,#sms.choices do
									local reply = sms.choices[z]
									debugPrint(1,reply.tag)
									if(getScoreKey(reply.tag,"unlocked") == 0 and checkTriggerRequirement(reply.requirement,reply.trigger)) then
										local test2 = gameJournalPhoneMessage.new()
										test2.sender = 1
										test2.text = getLang(reply.text)
										test2.delay = -9999
										test2.id = reply.tag
										reply.parent = sms.tag
										table.insert(currentPhoneConversation.currentchoices,reply)
										table.insert(choices,test2)
									end
								end
							end
						end
						--	----print#this.messages)
					end
				end
				this.messages = messages
				this.replyOptions = choices
			end
		end
	end)
	
	ObserveAfter('MessengerDialogViewController','AttachJournalManager', function(this, journalManager) 
		
		MessengerGameController = this
	
		
	end)
	
	ObserveAfter('MessengerDialogViewController','OnInitialize', function(this) 
		
		MessengerGameController = this
	
		
	end)

	ObserveAfter('PhoneMessagePopupGameController', 'SetupData', function(this)
				debugPrint(1,"PhoneMessagePopupGameController.SetupData")
		if (currentPhoneDialogPopup ~= nil and MessengerGameController ~= nil) then
			
			this.dialogViewController = MessengerGameController
			inkTextRef.SetText(this.title, currentPhoneDialogPopup.id)
			
			
			this.dialogViewController:ShowThread(currentPhoneDialogPopup)
		end
		
	end)

	Observe('MessengerDialogViewController', 'ShowThread', function(self,thread)
		debugPrint(1,"MessengerDialogViewController.ShowThread")
		if(thread == nil) then
			local message = {}
			table.insert(message,currentPhoneDialogPopup)
			self.messages = message
		end
	end)
	
	Observe('MessengerDialogViewController', 'ShowDialog', function(self,contact)
		debugPrint(1,"MessengerDialogViewController.ShowThread")
		if(contact == nil) then
			local message = {}
			table.insert(message,currentPhoneDialogPopup)
			self.messages = message
		end
	end)
	
	Observe('MessengerDialogViewController', 'UpdateData', function(self,animateLastMessage)
		debugPrint(1,"MessengerDialogViewController.UpdateData")
	
		if(contact == nil) then
			local message = {}
			table.insert(message,currentPhoneDialogPopup)
			self.messages = message
			
			local message = {}
			table.insert(message,currentPhoneDialogPopup)
			self.messages = message
		end
	end)

	Observe('MessangerItemRenderer', 'GetData', function(self)
			print("MessangerItemRenderer.GetData")
		local choicepress = false
		if(currentPhoneConversation ~= nil) then
			for i = 1, #currentPhoneConversation.currentchoices do
				print(currentPhoneConversation.currentchoices[i].text)
				print(self.labelPathRef:GetText())
				
				
				if(tostring(getLang(currentPhoneConversation.currentchoices[i].text)) == tostring(self.labelPathRef:GetText())) then
					setScore(currentPhoneConversation.currentchoices[i].tag,"unlocked",2)
					if(currentPhoneConversation.currentchoices[i].unlocknext ~= nil and currentPhoneConversation.currentchoices[i].unlocknext ~= "") then
						setScore(currentPhoneConversation.currentchoices[i].unlocknext,"unlocked",1)
					end
					if(#currentPhoneConversation.currentchoices[i].action > 0) then
						runActionList(currentPhoneConversation.currentchoices[i].action, currentPhoneConversation.currentchoices[i].tag, "interact",false,"nothing",currentPhoneConversation.currentchoices[i].action_bypassmenu_execution)
					end
					choicepress = true
					
					if choicepress == true then
						for i = 1, #currentPhoneConversation.currentchoices do
							setScore(currentPhoneConversation.currentchoices[i].tag,"unlocked",2)
						end
						MessengerGameController:UpdateData()
						
						break
					end
				end
			end
			
		end
	end)
	
	Observe('MessangerReplyItemRenderer', 'OnDataChanged', function(self,value)
		print("MessangerReplyItemRenderer.OnDataChanged")
	end)

	Observe('MessangerItemRenderer', 'OnJournalEntryUpdated', function(self,entry,extraData)
		debugPrint(1,"MessangerItemRenderer.OnJournalEntryUpdated")
		--	----printmessage.id)
		spdlog.error(GameDump(entry))
		Cron.NextTick(function()
			local message = entry
			local txt = ""
			local typo =  1
			--	----print"test")
			--	----printmessage.id.."titi")
			if(message.delay == -9999) then
				for i=1,#currentPhoneConversation.message do
					local sms = currentPhoneConversation.message[i]
					if( getScoreKey(sms.tag,"unlocked") == 1) then
						if(sms.tag == message.id) then
							txt = getLang(sms.text)
							if(sms.sender == 0) then
								typo = MessageViewType.Received 
								else
								typo = MessageViewType.Sent
							end
							self:SetMessageView(txt, typo, "")
							if(sms.action ~= nil and #sms.action > 0) then
								runActionList(sms.action, sms.tag, "interact",false,"nothing",sms.action_bypassmenu_execution)
							end
						end
						if(#sms.choices > 0) then
							for z=1,#sms.choices do
								if(getScoreKey(sms.choices[z].tag,"unlocked") == 0 and checkTriggerRequirement(sms.choices[z].requirement,sms.choices[z].trigger)) then
									debugPrint(1,getScoreKey(sms.choices[z].tag,"unlocked"))
									debugPrint(1,sms.choices[z].tag)
									
									
									if(sms.choices[z].tag == message.id) then
										txt = sms.choices[z].text
										txt = getLang(txt)
										
										self:SetMessageView(txt, typo, "")
										--	self:SetMessageView(sms.choices[z].text, typo, "")
										inkTextRef.SetText(self.fluffText, sms.choices[z].tag)
										inkTextRef.SetText(self.labelPathRef, txt)
										--				inkTextRef.SetText(this.m_fluffText, "CHKSUM_" + IntToString(contact.hash));
									end
								end
							end
						end
					end
				end
			end
		end)
	end)


	Observe('MessangerReplyItemRenderer', 'OnJournalEntryUpdated', function(self,entry,extraData)
		print("MessangerReplyItemRenderer.OnJournalEntryUpdated")
		--	----printmessage.id)
		spdlog.error(GameDump(entry))
		Cron.NextTick(function()
			local message = entry
			local txt = ""
			local typo =  1
		
		
			--	----print"test")
			--	----printmessage.id.."titi")
			if(message.delay == -9999) then
				for i=1,#currentPhoneConversation.message do
					local sms = currentPhoneConversation.message[i]
					if( getScoreKey(sms.tag,"unlocked") == 1) then
						if(sms.tag == message.id) then
							txt = getLang(sms.text)
							if(sms.sender == 0) then
								typo = MessageViewType.Received 
								else
								typo = MessageViewType.Sent
							end
							self:SetMessageView(txt, typo, "")
						end
						if(#sms.choices > 0) then
							for z=1,#sms.choices do
								if(getScoreKey(sms.choices[z].tag,"unlocked") == 0 and checkTriggerRequirement(sms.choices[z].requirement,sms.choices[z].trigger)) then
									debugPrint(1,getScoreKey(sms.choices[z].tag,"unlocked"))
									debugPrint(1,sms.choices[z].tag)
									
									
									if(sms.choices[z].tag == message.id) then
										txt = sms.choices[z].text
										txt = getLang(txt)
										
									
									
										inkTextRef.SetText(self.labelPathRef, txt)
										--				inkTextRef.SetText(this.m_fluffText, "CHKSUM_" + IntToString(contact.hash));
									end
								end
							end
						end
					end
				end
			end
		end)
	end)















	Observe('MenuScenario_HubMenu', 'OnSelectMenuItem', function(_, menuItemData)
		------print"toto"..menuItemData.menuData.label)
		--debugPrint(1,"obs17")
	end)

	ObserveAfter('PhoneDialerGameController','CallSelectedContact', function(this)
		-- let item: ref<PhoneContactItemVirtualController> = this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController;
		-- let contactData: ref<ContactData> = item.GetContactData();
		-- if IsDefined(contactData) {
		-- callRequest = new questTriggerCallRequest();
		-- callRequest.addressee = StringToName(contactData.id);
		local item = this.listController:GetSelectedItem()
		local contactData = item:GetContactData()
		--		--debugPrint(1,"found "..contactData.id)
		if(#contactList > 0) then
			for i = 1, #contactList do
				----printcontactData.id)
				if(contactList[i].id == contactData.id) then
					if(contactList[i].phonetype == "NPC") then
							
							
							
							currentNPC = findPhonedNPCByName(contactList[i].truename)
							
							if(currentNPC ~= nil) then
								
								local actionlist = {}
								local action = {}
								action.title = {}
								
								
								local title = "Hey V !"
								
								table.insert(action.title,title)
								
								local title = "V."
								
								table.insert(action.title,title)
								
								local title = "I was thinking about you, I let you imagine why."
								
								table.insert(action.title,title)
								
								local title = "V, Perfect time to call !"
								
								table.insert(action.title,title)
								
								local title = "V ! Do you need something ?"
								
								table.insert(action.title,title)
								
								local title = "V ! Are you ok ?"
								
								table.insert(action.title,title)
								
								local title = "V !"
								
								table.insert(action.title,title)
								
								action.name = "random_subtitle"
								action.speaker = contactList[i].truename
								
								action.type = 1
								action.target = "player"
								action.duration = 3
								
								table.insert(actionlist,action)
								
								
								
								action = {}
								
								
								
								action.title = "How are you ?"
								
								
								action.name = "subtitle"
								action.speaker = contactList[i].truename
								
								action.type = 1
								action.target = "player"
								action.duration = 3
								
								table.insert(actionlist,action)
								
							
								action = {}
							
								action.name = "speak_npc"
								action.way = "phone"
								action.speaker = "current_phone_npc"
								
						
								table.insert(actionlist,action)
								
								
						
								runActionList(actionlist,"call_"..contactData.id,"phone",false,"player")
								
							else
							
								print("can't find currentNPC ".. contactList[i].truename)
								Game.GetPlayer():SetWarningMessage("Unknow Contact")
							end
							
					end
					if(contactList[i].phonetype == "Service") then
						local interact = arrayInteract[contactList[i].id].interact
						runActionList(interact.action,interact.tag,"interact",false,"player")
					end
					if(contactList[i].phonetype == "Fixer") then
						local phoned = getFixerByTag(contactData.id)
						if(phoned ~= nil) then
							phonedFixer = true
							phoneAnimFixer = true
							currentfixer = phoned
							
							local actionlist = {}
							local action = {}
							
							action.name = "hacking_notification"
							action.title =  "Downloading latest quests into your journal..."
							action.title = getLang("download_quest_from_01")..phoned.Name..getLang("download_quest_from_02")
							action.duration = 3
							
							table.insert(actionlist,action)
							
							
						
						end
					end
				end
			end
		end
		
		this:CloseContactList()


	end)
	
	ObserveAfter('PhoneSystem','OnTriggerCall', function(this, request)
		debugPrint(1,"called")
		debugPrint(1,GameDump(request))
		
		local contactName = request.addressee
		debugPrint(1,"IsNameValid "..tostring(IsNameValid(contactName)))
		if IsNameValid(contactName) == false then
		debugPrint(1,"stopcall")
		this.ToggleContacts(true)
		this.TriggerCall(questPhoneCallMode.Undefined, this.LastCallInformation.isAudioCall, this.LastCallInformation.contactName, this.LastCallInformation.isPlayerCalling, questPhoneCallPhase.EndCall, this.LastCallInformation.isPlayerTriggered, this.LastCallInformation.isRejectable)
		end
	
	end)

	ObserveAfter('PhoneSystem','OnUsePhone', function(this, request)
		debugPrint(1,"usephone")
		debugPrint(1,GameDump(request))
		
		
	
	end)

	Observe('PhoneDialerGameController', 'Show', function(_,contactsList)
		refreshContact()
		openPhone = true
	end)

	Observe('PhoneDialerGameController', 'Hide', function()
		openPhone = false
	end)

	Observe('VehicleRadioPopupGameController', 'VirtualListReady', function(self)
		----debugPrint(1,#self.dataSource:GetArray())
		-- 1. Remove stations that are not supported by the radio device
		-- 2. Select currently playing station
		local radio = RadioListItemData.new()
		radio.record = gamedataRadioStation_Record.new()
		for k,v in pairs(arrayRadio) do
			self.dataSource:AppendItem(radio)
		end
		----debugPrint(1,#self.dataSource:GetArray())
		local stationIndexLimit = Game.EnumValueFromName('ERadioStationList', 'NONE')
		for _, stationItem in ipairs(self.dataSource:GetArray()) do
			---@type RadioStation_Record
			local stationRecord = stationItem.record
			local stationIndex = stationRecord:Index()
			if(stationRecord:DisplayName() == "") then
			end
			-- if(stationRecord.tag ~= nil) then
			-- --debugPrint(1,stationRecord.tag)
			-- --debugPrint(1,stationRecord.tag)
			-- end
		end
		self.dataSource:Reset(self.dataSource:GetArray())
	end)

	Observe('VehicleSummonWidgetGameController', 'OnVehicleSummonStateChanged', function(state,value ) 
	
		local vehicleSummonDef = Game.GetAllBlackboardDefs().VehicleSummonData
		local vehicleSummonBB = Game.GetBlackboardSystem():Get(vehicleSummonDef)
		vehicleEntId = vehicleSummonBB:GetEntityID(vehicleSummonDef.SummonedVehicleEntityID)
		----printGameDump(vehicleSummonBB))
		----printdump(vehicleSummonBB))
		local vehi = Game.FindEntityByID(vehicleEntId)
		--local vehicleRecordID = vehicleSummonBB:GetRecordID()
		
		if(calledfromgarage == true) then
			for i=1,#currentSave.garage do
				----printtostring(mygarage[i].asAV))
			
				if(TweakDBID.new(currentSave.garage[i].path).hash == vehi:GetRecordID().hash and currentSave.garage[i].asAV == true) then
					--debugPrint(1,"garage")
					local obj = getEntityFromManager(currentSave.garage[i].tag)
					--	 despawnEntity(currentSave.garage[i].tag)
					-- obj = getEntityFromManager(currentSave.garage[i].tag)
					if(obj.id == nil) then
						--debugPrint(1,"spaaaaaaaace")
						local entity = {}
						entity.id = vehicleEntId
						entity.tag = currentSave.garage[i].tag
						entity.tweak = currentSave.garage[i].path
						entity.takenSeat = {}
						entity.isAV = currentSave.garage[i].asAV
						local veh = Game.FindEntityByID(vehicleEntId)
						entity.availableSeat = GetSeats(veh)
						--entity.availableSeat = {}
						entity.driver = {}
						table.insert(questMod.EntityManager,entity)
					
						if(entity.isAV == true) then
							local group =getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,"addedAV"..entity.tag)
							table.insert(group.entities,entity.tag)
							
							if(currentSave.garage[i].fakeAV ~= nil and currentSave.garage[i].fakeAV == true) then
								
								local parentpos = vehi:GetWorldPosition()
								spawnVehicleV2("Vehicle.v_sportbike1_yaiba_kusanagi","","fake_av", parentpos.x, parentpos.y ,parentpos.z,99,3,true,false,false,false, 0)
								table.insert(group.entities,"fake_av")
							end
							
							
							local script = {}
							local action = {}
							
							if(currentSave.garage[i].fakeAV ~= nil and currentSave.garage[i].fakeAV == true) then
								action = {}
								action.name = "wait_second"
								action.value = 3
								table.insert(script,action)
								
								action = {}
								action.name = "entity_set_seat"
								action.tag = "player"
								action.vehicle = "fake_av"
								action.seat = "seat_front_left"
								table.insert(script,action)
								
								action = {}
								action.name = "change_custom_condition"
								action.value = "av_cockpit"
								action.score = 0
								
								action = {}
								action.name = "change_camera_position"
								action.x = 0
								action.y = -15
								action.z = 2
								
								
								table.insert(script,action)
								
							else
								action = {}
								action.name = "vehicle_change_doors"
								action.value = "open"
								action.tag = entity.tag
								table.insert(script,action)
								
							end
							
						
							runActionList(script, entity.tag, "interact",false,"engine",false)
						end
						else
						obj.id = vehicleEntId
					end
				end
			end
		end
	end)

	Observe('PopupsManager', 'OnPlayerAttach', function(self)
		radiopopup = self
	end)

	Observe('PopupsManager', 'OnPlayerDetach', function()
		radiopopup = nil
	end)

	Observe('RadioStationListItemController', 'OnDataChanged', function(self,value)
		-- --debugPrint(1,"this is it 2")
		-- -- --debugPrint(1,GameDump(self.label))
		-- if(self.stationData.record == nil) then
		-- --debugPrint(1,"mark2")
		-- Cron.NextTick(function()
		-- local radioToPut = nil
		-- for i=1,#testRadio do
		-- if(testRadio[i].enabled == false) then
		-- radioToPut = testRadio[i]
		-- break
		-- end
		-- end
		-- inkTextRef.SetText(self.label, radioToPut.name)
		-- --debugPrint(1,"test")
		-- end)
		-- end
		----debugPrint(1,Dump(value))
	end)

	Observe('RadioStationListItemController', 'Activate', function(self)
		if currentRadio ~= nil then
			self.quickSlotsManager:SendRadioEvent(false, false, -1)
		end
		-- --debugPrint(1,"this is it 2")
		-- -- --debugPrint(1,GameDump(self.label))
		-- if(self.stationData.record == nil) then
		-- --debugPrint(1,"mark2")
		-- Cron.NextTick(function()
		-- local radioToPut = nil
		-- for i=1,#testRadio do
		-- if(testRadio[i].enabled == false) then
		-- radioToPut = testRadio[i]
		-- break
		-- end
		-- end
		-- inkTextRef.SetText(self.label, radioToPut.name)
		-- --debugPrint(1,"test")
		-- end)
		-- end
		----debugPrint(1,Dump(value))
	end)

	Observe('VehicleRadioPopupGameController', 'OnScrollChanged', function(self)
		for k,v in pairs(arrayRadio) do
			arrayRadio[k].enabled = false
		end
		
	end)

	ObserveBefore('RadioStationListItemController', 'OnSelected', function(self,itemController,discreteNav)
		
		if(self.stationData.record:DisplayName() == nil or self.stationData.record:DisplayName() == "") then
			
				local radioToPut = nil
				for k,v in pairs(arrayRadio) do
					
					if(self.label:GetText() == nil or self.label:GetText() == "") then
						if(arrayRadio[k].enabled == false ) then
							currentRadio = arrayRadio[k]
							
							inkTextRef.SetText(self.label, arrayRadio[k].radio.name)
							arrayRadio[k].enabled = true
							break
						end
						else
						if(arrayRadio[k].radio.name == self.label:GetText() ) then
							currentRadio = arrayRadio[k]
							
							break
						end
					end
				end
			
			else
			currentRadio = nil
			Stop("music")
			
		end
	end)

	Observe('VehicleRadioPopupGameController', 'OnClose', function()
		for k,v in pairs(arrayRadio) do
			arrayRadio[k].enabled = false
		end
		popupActive = false
	end)

	Observe('PlayerPuppet', 'OnDeath', function()
		isdead = true
	end)

	
	
	Override('DialogChoiceLogicController', 'UpdateView', function(self,wrappedMethod)
		
							
			if(currentDialogHub ~= nil and self.ActiveTextRef ~= nil) then
			
				local isphoneDialog = currentDialogHub.dial.speaker.way == "phone"
				
				self.isPhoneLockActive = false
				inkWidgetRef.SetVisible(self.phoneIcon, false)
				inkWidgetRef.SetVisible(self.InputView.TopArrowRef, (self.InputView.CurrentNum ~= 0 or self.InputView.HasAbove))
				inkWidgetRef.SetVisible(self.InputView.BotArrowRef, (self.InputView.CurrentNum ~= (self.InputView.AllItemsNum - 1) or self.InputView.HasBelow))
			
				local dialogoption = currentDialogHub.dial.options[currentDialogHub.index]
				
					if(dialogoption.Description == self.ActiveTextRef:GetText()) then
					
					
					
					
					
					inkWidgetRef.SetVisible(self.VerticalLineWidget, false)
					self.InputView:SetVisible(true)
					self.isSelected = true
						
					if(dialogoption.style == nil) then
					
						self.ActiveTextRef.widget:SetTintColor(gamecolor(0,0,0,1))
						self.InActiveTextRef.widget:SetTintColor(gamecolor(0,0,0,1))
						
						
						self.SelectedBg:SetTintColor(gamecolor(0,255,255,1))
					
					else
					
						local fontcolor = dialogoption.style.textcolor
						
						self.ActiveTextRef.widget:SetTintColor(gamecolorStyle(fontcolor))
						self.InActiveTextRef.widget:SetTintColor(gamecolorStyle(fontcolor))
						
						self.SelectedBg:SetTintColor(gamecolorStyle(dialogoption.style.bgcolor))
					
					
					end
						
						
						
						
						local captionParts = {}
						
						
						
					
						
						
						inkWidgetRef.SetOpacity(self.ActiveTextRef, 1)
						inkWidgetRef.SetOpacity(self.InActiveTextRef, 1)
						self.SelectedBg:SetOpacity(0.6)
						
						
      
  
						
					else
						
						
						inkWidgetRef.SetVisible(self.VerticalLineWidget, true)
						self.InputView:SetVisible(false)
						
						
					
						self.isSelected = true
						
						
						if(dialogoption.style == nil) then
					
						self.ActiveTextRef.widget:SetTintColor(gamecolor(0,255,255,1))
						self.InActiveTextRef.widget:SetTintColor(gamecolor(0,255,255,1))
						self.VerticalLineWidget.widget:SetTintColor(gamecolor(0,255,255,1))
						
						
					
						else
					
						local fontcolor = dialogoption.style.font
						
						self.ActiveTextRef.widget:SetTintColor(gamecolorStyle(fontcolor))
						self.InActiveTextRef.widget:SetTintColor(gamecolorStyle(fontcolor))
						self.VerticalLineWidget.widget:SetTintColor(gamecolorStyle(fontcolor))
						
						
					
					
						end
						
						
						
						self.SelectedBg:SetTintColor(gamecolor(0,0,0,0))
						
						inkWidgetRef.SetOpacity(self.ActiveTextRef, 1)
						inkWidgetRef.SetOpacity(self.InActiveTextRef,0)
						self.SelectedBg:SetOpacity(0.0)
						
						
					end
				
			else
				
				return wrappedMethod()
				
			end
			
				
	
	end)
	
	
	Observe('CaptionImageIconsLogicController', 'OnInitialize',function(self,backgroundColor,iconColor)
	
	
	end)
		
	Observe('PlayerPuppet', 'OnAction',function(_,action)
		actionName = Game.NameToString(action:GetName(action))
		actionType = action:GetType(action).value
		actionValue = action:GetValue(action)
		
		if actionName == "PhoneInteract" and actionType == "BUTTON_RELEASED" and currentPhoneCall ~= nil   then 
			runActionList(currentPhoneCall.answer_action,"phone_call","interact",false,"player")
			incomingCallGameController:GetRootWidget():SetVisible(false)
			currentPhoneCall = nil
			StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), "GameplayRestriction.FistFight")
		end
		
		if actionName == "PhoneReject" and actionType == "BUTTON_HOLD_COMPLETE" and currentPhoneCall ~= nil   then 
			runActionList(currentPhoneCall.rejected_action,"phone_call","interact",false,"player")
			incomingCallGameController:GetRootWidget():SetVisible(false)
			currentPhoneCall = nil
			StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), "GameplayRestriction.FistFight")
		end
		
		
		if actionName == "popup_moveLeft" and actionType == "REPEAT" and currentController == "gamepad"   then 
			hideInteract()
			--debugPrint(1,"tosto")
		end
		if actionName == "dpad_left" and actionType == "BUTTON_PRESSED"  and currentController == "gamepad" and inputInAction == false and currentHelp == nil  then 
			inputInAction = true
			--debugPrint(1,"toto")
			cycleInteract()
		end
		
		if currentHelp ~= nil and (actionName == "cancel" and actionType == "BUTTON_RELEASED" and currentController == "gamepad") or ((actionName == "activate_secondary" or actionName == "proceed_popup") and actionType == "BUTTON_RELEASED" and currentController ~= "gamepad")then
		 
		 local actionlisth = {}
		 local actionh = {}
		if(currentHelpIndex+1 >= #currentHelp.section)then
		      UIPopupsManager.ClosePopup()
		      currentHelp = nil
		      currentHelpIndex = 1
		else
		 actionh.name = "previous_help"
		 table.insert(actionlisth,actionh)
		 
		 actionh = {}
		 actionh =currentHelp.action
		 actionh.name = "open_help"
		 actionh.tag = currentHelp.tag
		 table.insert(actionlisth,actionh)
		 
		  runActionList(actionlisth,currentHelp.tag,"interact",true,"player")
		end		
		end
	  
		if currentHelp ~= nil and (actionName == "close_tutorial" and actionType == "BUTTON_RELEASED" and currentController == "gamepad") or ((actionName == "activate" or actionName == "close_tutorial") and actionType == "BUTTON_RELEASED" and currentController ~= "gamepad") then
		 
		 local actionlisth = {}
		 local actionh = {}
		 
		print(currentHelpIndex+1) print(#currentHelp.section)
		 
		if(currentHelpIndex+1 >= #currentHelp.section)then
		      UIPopupsManager.ClosePopup()
		      currentHelp = nil
		      currentHelpIndex = 1
		else
			actionh.name = "next_help"
		 table.insert(actionlisth,actionh)
		 actionh = {}
		 actionh =currentHelp.action
		 actionh.name = "open_help"
		 actionh.tag = currentHelp.tag
		 table.insert(actionlisth,actionh)
		 
		  runActionList(actionlisth,currentHelp.tag,"interact",true,"player")
		end		
		  end
		
		
		if(actionType == "BUTTON_RELEASED" and (string.find(tostring(actionName), "hoiceScrollUp") or string.find(tostring(actionName), "hoiceScrollDown") or string.find(tostring(actionName), "up_button") or string.find(tostring(actionName), "down_button") or string.find(tostring(actionName), "hoice1") or string.find(tostring(actionName), "hoice2") or string.find(tostring(actionName), "hoice3") or string.find(tostring(actionName), "hoice4")))then 
			----printactionName)+
			-- --debugPrint(1,actionName)
			-- --debugPrint(1,actionType)
			local inputHitted = false
			if(isdialogactivehub == true ) then
			
				local inputIndex = 0
				
				if(string.find(tostring(actionName), "hoice1_Release")and actionType == "BUTTON_RELEASED") then
					ClickOnDialog(currentDialogHub.dial.options[currentDialogHub.index],currentDialogHub.dial.speaker.value,currentDialogHub.dial.speaker.way)
					
			
				end
				
				
				
				
				if((string.find(tostring(actionName), "hoiceScrollUp") or string.find(tostring(actionName), "up_button"))and actionType == "BUTTON_RELEASED") then
				
							
					if(currentDialogHub.index == nil) then
						currentDialogHub.index = 1
					end
					currentDialogHub.index = currentDialogHub.index-1
					----debugPrint(1,"currentDialogHub.index "..currentDialogHub.index )
					if(currentDialogHub.index < 1) then
						currentDialogHub.index = #currentDialogHub.dial.options
					end
					
					Game.GetBlackboardSystem():Get(Game.GetAllBlackboardDefs().UIInteractions):SetInt(Game.GetAllBlackboardDefs().UIInteractions.SelectedIndex, currentDialogHub.index, true)
				end
				
				
				
				
				if((string.find(tostring(actionName), "hoiceScrollDown") or string.find(tostring(actionName), "down_button"))and actionType == "BUTTON_RELEASED") then
					if(currentDialogHub.index == nil) then
						currentDialogHub.index = 1
					end
					
			
					currentDialogHub.index = currentDialogHub.index+1
				
					if(currentDialogHub.index >  #currentDialogHub.dial.options) then
						currentDialogHub.index =  1
					end
					
					Game.GetBlackboardSystem():Get(Game.GetAllBlackboardDefs().UIInteractions):SetInt(Game.GetAllBlackboardDefs().UIInteractions.SelectedIndex, currentDialogHub.index, true)
					
				end
				
				
				
				
				
				
				if currentDialogHub~= nil and currentDialogHub.dial ~= nil then
					if(inputIndex >  #currentDialogHub.dial.options) then
						inputIndex = #currentDialogHub.dial.options
					end
					if(#currentDialogHub.dial.options == 0 or currentDialogHub.dial.options == nil) then
						currentDialogHub.dial.options = {}
						local option = {}
						option.Description = getLang("talk_later")
						option.action = {}
						option.trigger = {}
						option.trigger.auto = {}
						option.trigger.auto.name = "auto"
						option.requirement = {}
						option.input = 1
						local requirem = {}
						
						table.insert(requirem,"auto")
						table.insert(option.requirement,requirem)
						table.insert(currentDialogHub.dial.options,option)
					end
					-- if(currentDialogHub ~= nil) then
					-- for i = 1, #currentDialogHub.dial.options do
					-- if(currentDialogHub ~= nil and currentDialogHub.dial.options[i].input == inputIndex) then
					-- --	----print"input choice detexted")
					-- --	----printcurrentDialogHub.dial.options[i].Description)
					-- end
					-- end
					-- end
				end
			end
			if(isdialogactivehub == false and candisplayInteract == true) then
				--		----print"event detexted")
				local inputIndex = 0
				if(actionName == "Choice1") then
					inputIndex = 1
				end
				if(actionName == "Choice2") then
					inputIndex = 2
				end
				if(actionName == "Choice3") then
					inputIndex = 3
				end
				if(actionName == "Choice4") then
					inputIndex = 4
				end
				--	----printinputIndex)
				--	----print#possibleInteractDisplay[currentPossibleInteractChunkIndex])
				if(possibleInteractDisplay[currentPossibleInteractChunkIndex] ~= nil) then
					for i = 1, #possibleInteractDisplay[currentPossibleInteractChunkIndex] do
						--	----print"expected input for "..possibleInteractDisplay[currentPossibleInteractChunkIndex][i].name.." : "..possibleInteractDisplay[currentPossibleInteractChunkIndex][i].input)
						if(inputIndex == i) then
							runActionList(possibleInteractDisplay[currentPossibleInteractChunkIndex][i].action,possibleInteractDisplay[currentPossibleInteractChunkIndex][i].tag,"interact",false,"player")
							if(currentHouse == nil or (currentHouse ~= nil and interactautohide == true)) then
								currentPossibleInteractChunkIndex = 0
								debugPrint(1,"lol")
								createInteraction(false)
								candisplayInteract = false
							end
						end
					end
				end
			end
		end
		
		
		
		if #currentInputHintList > 0 then
			for i = 1, #currentInputHintList do
				if(currentInputHintList[i].key == actionName and actionType == "BUTTON_RELEASED") then
					local inter = arrayInteract[currentInputHintList[i].tag].interact
					runActionList(inter.action,inter.tag,"interact",false,"player")
				end
			end
		end
		if (AVisIn == true) then
			AVinput.keyPressed = false
			--back/forward

			if  actionName == 'world_map_menu_move_vertical' or actionName == 'left_stick_y'then
				if actionType == 'BUTTON_HOLD_PROGRESS' or (actionType == 'AXIS_CHANGE' and actionValue > 0) then
					AVinput.currentDirections.forward = true
					AVinput.currentDirections.backwards = false
					elseif actionType == 'BUTTON_HOLD_PROGRESS' or (actionType == 'AXIS_CHANGE' and actionValue < 0) then
					AVinput.currentDirections.backwards = true
					AVinput.currentDirections.forward = false
					if(AVspeed > 1 and AVinput.lastInput == "forward") then
						AVspeed = 0.3
					end
					elseif actionType == 'BUTTON_RELEASED' or (actionType == 'AXIS_CHANGE' and actionValue == 0) then
					AVinput.currentDirections.backwards = false
					AVinput.currentDirections.forward = false
				end
				--left/right - rollleft/rollright	
				elseif actionName == 'world_map_menu_move_horizontal' or actionName == 'left_stick_x'  then
				if (actionType == 'AXIS_CHANGE' and actionValue == -1) or (actionType == 'BUTTON_HOLD_PROGRESS' or actionValue < -0.6)then
					AVinput.currentDirections.right = true
					AVinput.currentDirections.rollleft = true
					AVinput.currentDirections.left = false
					AVinput.currentDirections.rollleft = false
					elseif (actionType == 'AXIS_CHANGE' and actionValue == 1) or (actionType == 'BUTTON_HOLD_PROGRESS' or actionValue > 0.6) then
					AVinput.currentDirections.left = true
					AVinput.currentDirections.rollright = true
					AVinput.currentDirections.right = false
					AVinput.currentDirections.rollright = false
					------print"Working mate right")
					elseif (actionType == 'AXIS_CHANGE' and actionValue == 0) or (actionType == 'BUTTON_RELEASED' and (actionValue < 0.6 and actionValue > -0.6)) then
					AVinput.currentDirections.right = false
					AVinput.currentDirections.left = false
					AVinput.currentDirections.rollleft = false
					AVinput.currentDirections.rollright = false
					------print"Stop Working mate")
				end
				--up down
				elseif actionName == 'ToggleSprint' or actionName == 'ToggleVehCamera' or actionName == 'left_trigger'then
				if actionType == 'BUTTON_PRESSED' or (actionType == 'AXIS_CHANGE' and actionValue > 0) then
					AVinput.currentDirections.down = true
					AVinput.currentDirections.up = false
					elseif actionType == 'BUTTON_RELEASED' or (actionType == 'AXIS_CHANGE' and actionValue == 0) then
					AVinput.currentDirections.down = false
				end
				elseif actionName == 'UI_Skip' or actionName == 'right_trigger'then
				if actionType == 'BUTTON_PRESSED' or (actionType == 'AXIS_CHANGE' and actionValue ==1) then
					AVinput.currentDirections.up = true
					AVinput.currentDirections.down = false
					elseif actionType == 'BUTTON_RELEASED' or (actionType == 'AXIS_CHANGE' and actionValue < 1) then
					AVinput.currentDirections.up = false
				end
				elseif actionName == 'Exit' then
				if actionType == 'BUTTON_PRESSED'then
					AVinput.exit = true
				end
			end
			AVinput.keyPressed = false
			for key, v in pairs(AVinput.currentDirections) do
				if v == true then
					------printkey)
					AVinput.isMoving = true
					AVinput.keyPressed = true
					if(key == "forward" or key == "backwards") then
						AVinput.lastInput = key
					end
					--------printkey)
				end
			end
		end
	end)
	
	ObserveAfter('ShardNotificationController', 'OnInitialize', function(self)
	currentShardNotificationController = self
	end)
	
	ObserveAfter('ShardNotificationController', 'OnPlayerAttach', function(self,playerPuppet)
	currentShardNotificationController = self
	end)
	
	Observe('ShardNotificationController', 'SetButtonHints', function(self)
		
		if not UIPopupsManager.IsOwnPopup(self) then
			return
		end
		currentShardNotificationController = self
		if(currentInterface ~= nil) then
			currentevt = {}
			currentscroll = {}
			inkTextRef.SetText(self.titleRef, currentInterface.title)
			local rootWidget = self:GetRootCompoundWidget()
			---@type inkImage
			local titleIcon = rootWidget:GetWidgetByPathName(StringToName('container/Panel/vertical_organizer/topBar/icon'))
			titleIcon:SetTintColor(inkWidgetRef.GetTintColor(self.titleRef))
			titleIcon:SetAtlasResource(ResRef.FromName('base\\gameplay\\gui\\fullscreen\\hub_menu\\hub_atlas.inkatlas'))
			titleIcon:SetTexturePart('ico_journal')
			local contentArea = rootWidget:GetWidgetByPathName(StringToName('container/Panel/vertical_organizer/contentArea'))
			local demoArea = inkCanvas.new()
			demoArea:SetName(CName.new("demo"))
			demoArea:SetAnchor(inkEAnchor.Fill)
			demoArea:Reparent(contentArea, -1)
			local leftmargin = 540
			local topmargin = -uimargintop
			local labelcount  = 0
			local havebutton = false
			local buttoncount = 0
			local havetext = false
			local fontsize = uifont
			local width = 400
			local height = 100
			for i=1,#currentInterface.controls do
				if(checkTriggerRequirement(currentInterface.controls[i]["requirement"],currentInterface.controls[i]["trigger"])) then
					havetext = true
					if(currentInterface.controls[i].margin == nil ) then
						currentInterface.controls[i].margin = {}
					end
					if(currentInterface.controls[i].style == nil ) then
						currentInterface.controls[i].style = {}
					end
					
					local bgcolor = HDRColor.new({ Red = 0.054902, Green = 0.054902, Blue = 0.090196, Alpha = 1.0 })
					
					local textcolor = HDRColor.new({ Red = 1.1761, Green = 0.3809, Blue = 0.3476, Alpha = 1.0 })
					
					if(currentInterface.controls[i].bgcolor ~= nil and currentInterface.controls[i].bgcolor.red ~= nil ) then
						bgcolor = gamecolorStyle(currentInterface.controls[i].bgcolor)
					end
					
					if(currentInterface.controls[i].textcolor ~= nil and currentInterface.controls[i].textcolor.red ~= nil ) then
						textcolor = gamecolorStyle(currentInterface.controls[i].textcolor)
					end
					
					if(currentInterface.controls[i].style.fontsize ~= nil and currentInterface.controls[i].style.fontsize ~= "") then
						fontsize = currentInterface.controls[i].style.fontsize
					end
					if(currentInterface.controls[i].style.width ~= nil and currentInterface.controls[i].style.width ~= "") then
						width = currentInterface.controls[i].style.width
					end
					if(currentInterface.controls[i].style.height ~= nil and currentInterface.controls[i].style.height ~= "") then
						height = currentInterface.controls[i].style.height
					end
					if(currentInterface.controls[i].type == "label") then
						
						if(currentInterface.controls[i].textcolor == nil or (currentInterface.controls[i].textcolor ~= nil and currentInterface.controls[i].textcolor.red == nil)) then
						textcolor = HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 })
						end
						
						labelcount = labelcount +1
						topmargin = topmargin+uimargintop
						local texttoDisplay = ""
						if(currentInterface.controls[i].style.fontsize ~= nil and currentInterface.controls[i].style.fontsize ~= "") then
							fontsize = currentInterface.controls[i].style.fontsize
						end
						if(currentInterface.controls[i].value.type == "text") then
							texttoDisplay = currentInterface.controls[i].value.value
							elseif(currentInterface.controls[i].value.type == "score") then
							local score = getScoreKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
							if(score== nil) then
								score = 0
							end
							texttoDisplay = score 
							elseif(currentInterface.controls[i].value.type == "multi_score") then
							if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.scores ~= nil and #ActualPlayerMultiData.scores ~= 0) then
								local score = ActualPlayerMultiData.scores[currentInterface.controls[i].value.tag]
								if(score== nil) then
									score = 0
								end
							end
							texttoDisplay = score 
							elseif(currentInterface.controls[i].value.type == "variable") then
							local variable = getVariableKey(currentInterface.controls[i].value.tag,currentInterface.controls[i].value.key)
							if(variable== nil) then
								variable = ""
							end
							texttoDisplay = variable
						end
						local descText = inkText.new()
						descText:SetName(CName.new(currentInterface.controls[i].tag))
						descText:SetText(texttoDisplay)
						descText:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
						descText:SetFontStyle('Medium')
						descText:SetFontSize(fontsize)
						descText:SetTintColor(textcolor)
						descText:SetHorizontalAlignment(textHorizontalAlignment.Center)
						descText:SetVerticalAlignment(textVerticalAlignment.Center)
						descText:SetMargin(inkMargin.new(currentInterface.controls[i].margin))
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							descText:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							descText:Reparent(parent.ink, -1)
						end
						local obj = {}
						obj.ink = descText
						obj.tag = currentInterface.controls[i].tag
						obj.type = "label"
						table.insert(currentevt,obj)
					end
					if(currentInterface.controls[i].type == "image") then
						local stickerTweakId = currentInterface.controls[i].tweak
						local stickerRecord = TDB.GetPhotoModeStickerRecord(stickerTweakId)
						if(stickerRecord ~= nil) then
							local selectionImage = inkImage.new()
							selectionImage:SetName(CName.new(currentInterface.controls[i].tag))
							selectionImage:SetMargin(inkMargin.new(currentInterface.controls[i].margin))
							selectionImage:SetFitToContent(true)
							selectionImage:SetAtlasResource(stickerRecord:AtlasName())
							selectionImage:SetTexturePart(stickerRecord:ImagePartName())
							selectionImage:SetScale(Vector2.new({ X = 0.5, Y = 0.5 }))
							selectionImage:SetRenderTransformPivot(Vector2.new({ X = 0.0, Y = 0.0 }))
							if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
								selectionImage:Reparent(demoArea, -1)
								else
								local parent = getInkWidget(currentInterface.controls[i].parent)
								selectionImage:Reparent(parent.ink, -1)
							end
							local obj = {}
							obj.ink = selectionImage
							obj.tag = currentInterface.controls[i].tag
							obj.type = "image"
							table.insert(currentevt,obj)
						end
					end
					if(currentInterface.controls[i].type == "button") then
						havebutton = true
						buttoncount = buttoncount + 1
						topmargin = topmargin+uimargintop
						local buttonData = {
							name = StringToName(currentInterface.controls[i].tag),
							text = currentInterface.controls[i].title,
							value = i,
							tag =  currentInterface.controls[i].tag,
							action = currentInterface.controls[i].action
						}
						local fontsize = uifont
						local buttonComponent = UIButton.Create(buttonData.name, buttonData.text,fontsize, currentInterface.controls[i].style.width, currentInterface.controls[i].style.height,currentInterface.controls[i].margin,bgcolor,textcolor)
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							buttonComponent:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							buttonComponent:Reparent(parent.ink, -1)
						end
						buttonComponent:RegisterCallback('OnRelease', function(button, evt)
							if evt:IsAction('click') then
								if(currentInterface ~= nil) then
									runActionList(currentInterface.controls[i].action, currentInterface.controls[i].tag, "interact",false,"nothing",false)
								end
								evt:Handle()
							end
						end)
						buttonComponent:RegisterCallback('OnEnter', function(_, evt)
							if(currentInterface ~= nil) then
								if(currentInterface.controls[i].onenter_action ~= nil and #currentInterface.controls[i].onenter_action > 0) then
									runActionList(currentInterface.controls[i].onenter_action, currentInterface.controls[i].tag.."_onenter", "interact",false,"nothing",false)
								end
							end
							evt:Handle()
						end)
						buttonComponent:RegisterCallback('OnLeave', function(_, evt)
							if(currentInterface ~= nil) then
								if(currentInterface.controls[i].onleave_action ~= nil and #currentInterface.controls[i].onleave_action > 0) then
									runActionList(currentInterface.controls[i].onleave_action, currentInterface.controls[i].tag.."_onleave", "interact",false,"nothing",false)
								end
							end
							evt:Handle()
						end)
						local obj = {}
						obj.ink = buttonComponent
						obj.tag = currentInterface.controls[i].tag
						obj.type = "button"
						table.insert(currentevt,obj)
						--debugPrint(1,"button")
					end
					if(currentInterface.controls[i].type == "linebreak") then
						labelcount = labelcount +1
						topmargin = topmargin+uimargintop
						local texttoDisplay = ""
						local descText = inkText.new()
						descText:SetName(CName.new("linebreak_"..i))
						descText:SetText(texttoDisplay)
						descText:SetFontFamily('base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily')
						descText:SetFontStyle('Medium')
						descText:SetFontSize(35)
						descText:SetTintColor(HDRColor.new({ Red = 0.113725, Green = 0.929412, Blue = 0.513726, Alpha = 1.0 }))
						descText:SetHorizontalAlignment(textHorizontalAlignment.Center)
						descText:SetVerticalAlignment(textVerticalAlignment.Center)
						descText:SetMargin(inkMargin.new({ left = leftmargin, top = topmargin }))
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							descText:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							descText:Reparent(parent.ink, -1)
						end
					end
					if(currentInterface.controls[i].type == "scrollarea") then
						local areawidth = width
						local areaheight = height
						local scrollComponent 
						local scrollPanel
						local scrollContent 
						scrollComponent = UIScroller.Create(currentInterface.controls[i].tag)
						scrollPanel = scrollComponent:GetRootWidget()
						scrollPanel:SetAnchor(inkEAnchor.TopLeft)
						scrollPanel:SetMargin(inkMargin.new({ left = 40.0 ,top=60}))
						scrollPanel:SetSize(Vector2.new({ X = currentInterface.controls[i].style.width, Y = currentInterface.controls[i].style.height }))
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							scrollPanel:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							debugPrint(1,GameDump(parent))
							scrollPanel:Reparent(parent.ink, -1)
						end
						scrollContent = scrollComponent:GetContentWidget()
						Cron.NextTick(function()
							scrollComponent:UpdateContent(true)
						end)
						local obj = {}
						obj.ink = scrollComponent
						obj.tag = currentInterface.controls[i].tag
						obj.type = "scrollarea"
						table.insert(currentevt,obj)
					end
					if(currentInterface.controls[i].type == "area") then
						local area = inkCanvas.new()
						area:SetName(StringToName(currentInterface.controls[i].tag))
						area:SetAnchor(inkEAnchor.Fill)
						area:SetSize(Vector2.new({ X = currentInterface.controls[i].style.width, Y = currentInterface.controls[i].style.height }))
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							area:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							area:Reparent(parent.ink, -1)
						end
						local obj = {}
						obj.ink = area
						obj.tag = currentInterface.controls[i].tag
						obj.type = "area"
						table.insert(currentevt,obj)
					end
					if(currentInterface.controls[i].type == "vertical_area") then
						local buttonList = inkVerticalPanel.new()
						buttonList:SetName(StringToName(currentInterface.controls[i].tag))
						buttonList:SetPadding(inkMargin.new({ left = 32.0, top = 20.0, right = 32.0 }))
						buttonList:SetChildMargin(inkMargin.new({ top = 8.0, bottom = 8.0 }))
						buttonList:SetFitToContent(true)
						if(currentInterface.controls[i].parent == nil or currentInterface.controls[i].parent == "")then
							buttonList:Reparent(demoArea, -1)
							else
							local parent = getInkWidget(currentInterface.controls[i].parent)
							if(parent.type == "scrollarea") then
								local scrollContent = parent.ink:GetContentWidget()
								buttonList:Reparent(scrollContent, -1)
								else
								buttonList:Reparent(parent.ink, -1)
							end
						end
						local obj = {}
						obj.ink = buttonList
						obj.tag = currentInterface.controls[i].tag
						obj.type = "vertical_area"
						table.insert(currentevt,obj)
					end
				end
			end
		end
	end)
	
	Observe('ShardNotificationController', 'Close', function(self)
		buttonsData = {}
		if UIPopupsManager.IsOwnPopup(self) then
			UIPopupsManager.ClosePopup()
		end
	end)
	
	Observe('gameuiInGameMenuGameController', 'OnHandleMenuInput', function(self)
		popupManager = self
	end)

	Observe('gameuiInGameMenuGameController', 'SpawnMenuInstanceEvent', function(self) -- Get Controller to spawn popup
		popupManager = self
	end)
	
	Observe('PopupsManager', 'ShowPhoneMessage', function(self)
		
		
			if self.phoneMessageData ~= nil and self.phoneMessageData.journalEntry == nil then
		
			else
			if self.phoneMessageData ~= nil and self.phoneMessageData.journalEntry ~= nil then
			spdlog.error(GameDump(self.phoneMessageData))
			end
		end
	
	
	end)
	
	Observe('PopupsManager', 'OnMessagePopupUseCloseRequest', function(self)
		
		if(currentPhoneConversation ~= nil) then
			currentPhoneConversation = nil
		end
	
	
	end)
	
	
	
	
	end
---Observer and Overrider---

---Misc Function---
function startListeners(player)
	player:UnregisterInputListener(player, 'QuickMelee')
	player:UnregisterInputListener(player, 'CameraAim')
	player:UnregisterInputListener(player, 'DeviceAttack')
	player:RegisterInputListener(player, 'QuickMelee')
	player:RegisterInputListener(player, 'CameraAim')
	player:RegisterInputListener(player, 'DeviceAttack')
end
---Misc Function---