debugPrint(3,"CyberScript: netcontract module loaded")
--print("CyberScript: netcontract module loaded")
questMod.module = questMod.module +1

processing = "processing..."

function openNetPage(page)
	

netontracthub.register = false
netontracthub.login = false


netontracthub[page] = true
	
end

function loadData()
	
	CurrentServerModVersion.version = questMod.version
			
				
				Cron.After(2, function()
				
				processing = "Get Datapack list (1/8)"
						GetModpackList()
						
						
				
				
				Cron.After(2, function()
					
					processing = "Get Branch(2/8)"
					GetBranch()
				
				
				
				
					Cron.After(2, function()
						processing = "Get Role(3/8)"
						GetRole()
						
							Cron.After(2, function()
							processing = "Get Faction(4/8)"
							GetFaction()
							
								Cron.After(2, function()
									processing = "Get UserData(5/8)"
									GetPossibleBranch()
									
									Cron.After(2, function()
										processing = "Get FactionRank(6/8)"
										GetFactionRank()
											Cron.After(2, function()
											
													processing = "Get Item Categories(7/8)"
													GetItemCat()
												
											
													Cron.After(2, function()
													processing = "Get Last Server Mod Version(8/8)"
													
													GetModVersion()
													
														mainwait = false
														processing = "processing"
													end)
											end)
									end)
									
								end)
							
							
						end)
						end)
						
					end)
				end)
	
end



function getNetCurrentPage()
	
	local page = "main"
	
	for k,v in pairs(netontracthub) do
		
		if(v == true) then
			page = k
		end
	end
	
	
	return page
end

function ContractWindows()
	tokenIsValid = tokenIsValidate()
	
	
		
		
		
		
		
		
	
	
	CPS:setThemeBegin()
	CPS.colorBegin("WindowBg", {"14170C" , 1 })
	
	if ImGui.Begin("Online Service") then
		ImGui.SetNextWindowPos(50,50, ImGuiCond.Appearing) -- set window position x, y
		ImGui.SetNextWindowSize(300, 600, ImGuiCond.Appearing) -- set window size w, h
		ImGui.SetWindowSize(1200, 400)
		
		
		
		ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 10)
		ImGui.PushStyleColor(ImGuiCol.Border, 0x8ffefd01)
		
		
		
		
			ImGui.SameLine()
		
		if(netontracthub.main )then
			if ImGui.Button("Log Off") then 
			
			disconnectUser()
			MultiplayerOn = false
			
			
			
			friendIsSpaned = false
			lastFriendPos = {}
			Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
			
			netontracthub.login = true
			netontracthub.register = false
			netontracthub.main = false
			
			openNetContract = false
			firstload = true
			firstloadMission = true
			firstloadMarket = true
			initfinish = false
			
			
			
			
			
			
		end
			
			if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
			CPS.styleBegin("TabRounding", 0)
			
			MultiTabs()
			
			CPS.styleEnd(1)
			ImGui.EndTabBar()
		end
		end
		ImGui.SameLine()
		
		
		
		if(netontracthub.login)then
			ImGui.SetWindowFontScale(1)
		
			
			if ImGui.Button("Register page") then
			
			openNetPage("register")
			
			
			end
			
			ImGui.Spacing()
				
			ImGui.Text("Login :")
			myTag = ImGui.InputText("##Login", myTag, 100, ImGuiInputTextFlags.None)
			
			ImGui.Text("Password :")
			myPassword = ImGui.InputText("##Password", myPassword, 100, passwordView)
			ImGui.SameLine()
			if ImGui.Button("Show/Hide") then
				
				if(passwordView == ImGuiInputTextFlags.Password) then
					passwordView = ImGuiInputTextFlags.None
				else
					passwordView = ImGuiInputTextFlags.Password
				end
			
			
			end
			
			ImGui.Spacing()
			
			ImGui.Spacing()
			
			
			
			if ImGui.Button(getLang("keystone_connect_btn")) then
				
				
				local file = assert(io.open("net/userLogin.txt", "w"))
				local obj = {}
				obj.login = myTag
				obj.password = myPassword
				local stringg = JSON:encode_pretty(obj)
	
				file:write(stringg)
				file:close()
			
				
			
				
				mainwait = true
				connectUser()
			
			
				
				
				--loadData()
				
				
				waitingDownloaded(false,10)
						
			
			
			end
			
			ImGui.Spacing()
			
			ImGui.Text(getLang("keystone_connect_msg"))
			
			ImGui.Spacing()
			
			ImGui.Text(errormessage)
			
			end
			
			
			
			
			
			
			
			if(netontracthub.register)then
			
			
			ImGui.SetWindowFontScale(1)
			
			if ImGui.Button("Login page") then
		
			openNetPage("login")
			
			
			end
			
			ImGui.Spacing()
			
			ImGui.Text("Login :")
			myTag = ImGui.InputText("myTag", myTag, 100, ImGuiInputTextFlags.AutoSelectAll)
			
			ImGui.Text("Password :")
			myPassword = ImGui.InputText("myPassword", myPassword, 100, ImGuiInputTextFlags.Password)
			ImGui.SameLine()
			if ImGui.Button("Show/Hide") then
				
				if(passwordView == ImGuiInputTextFlags.Password) then
					passwordView = ImGuiInputTextFlags.None
				else
					passwordView = ImGuiInputTextFlags.Password
				end
			
			
			end
			
			ImGui.Spacing()
			
			
			if ImGui.BeginCombo("Faction",  myFaction) then -- Remove the ## if you'd like for the title to display above combo box
							
						
							
					for i,v in ipairs(possibleFaction) do
			
						if ImGui.Selectable(v, (myFaction== v)) then
							
							
							myFaction = v
							
							
							ImGui.SetItemDefaultFocus()
						end
						
						
					end
					
					
							
				ImGui.EndCombo()
			end
			
			ImGui.Spacing()
			
			
			if(myTag ~= "" and myPassword ~= "") then
				if ImGui.Button("Create account and connect") then
				
				 createUser()
				
				
				end
			end
			
			
			ImGui.Spacing()
			
			
			
			
			
			
			ImGui.Spacing()
			ImGui.Text(errormessage)
			
			
			end
			
		end
		
		ImGui.End()
		
		CPS.colorEnd(1)
		CPS:setThemeEnd()
	
end




function HomeModpackTabs()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("Datapack") then
		
		if ImGui.Button("Reload List", 1000, 0) then
			GetModpackList()
			
			waitingDownloaded(false,0.5)
			
			
		end
		
		-- ImGui.SameLine()
		
		
		-- if ImGui.Button("Datapack Manager", 500, 0) then
			
			
			-- openDatapackManager = true
			
			
		-- end
		
		
		
		ImGui.BeginChild("Datapack", 1200, 700)
			CPS.colorBegin("Text", "FFFFFF")
			CPS.colorBegin("Button",{"941005",1})
			
			local counter = 0
			if waiting == false and mainwait == false then
				if arrayDatapack3 ~= nil then
					for i = 1,#arrayDatapack3  do
						
						local datapack = arrayDatapack3[i]
						if((datapack.isdebug == true and questMod.debug == true) or datapack.isdebug == false) then
							counter = counter +1
							
							
							
							ImGui.BeginChild("Datapack"..i, 300, 200)
							
							
								ImGui.SetWindowFontScale(1)
								--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
								
								ImGui.TextColored(0.36, 0.96, 1, 1, "Name : "..datapack.name)--content
								
								
								ImGui.Spacing()
								
								ImGui.TextColored(0.36, 0.96, 1, 1, "Description : "..datapack.desc)--content
								local tab1hov = ImGui.IsItemHovered()
								if tab1hov then
									CPS:CPToolTip1Begin(260, 220)
									ImGui.TextColored(0.79, 0.40, 0.29, 1, "Description")
									ImGui.Spacing()
									CPS.colorBegin("Text", "00fdc4")
									ImGui.TextWrapped(datapack.desc)
									CPS.colorEnd(1)
									
									CPS:CPToolTip1End()
								end
								ImGui.Spacing()
								
								ImGui.TextColored(0.36, 0.96, 1, 1, "Author : "..datapack.author)--content
								
								ImGui.Spacing()
								
								ImGui.TextColored(0.36, 0.96, 1, 1, "Version : "..datapack.version)--content
								
								ImGui.Spacing()
								
								if(datapack.requirement ~= nil) then
									
									CPS.colorBegin("Text", "e60800")
									ImGui.TextWrapped("Require IRP version : "..datapack.requirement)
									CPS.colorEnd(1)
									ImGui.Spacing()
								end
								
								ImGui.TextColored(0.36, 0.96, 1, 1, "Branch : "..datapack.branch)--content
								
								if(datapack.faction ~= nil) then 
									CPS.colorBegin("Text", "e6b000")
									ImGui.TextWrapped("Exclusive to your faction !")
									CPS.colorEnd(1)
								
								end
								
								ImGui.Spacing()
								if(isDatapackDownloaded(datapack.tag)) then
									
									local localversion = CurrentDownloadedVersion(datapack.tag)
									
									ImGui.TextColored(0.36, 0.96, 1, 1,"Downloaded version : ".. localversion)--content
									
									ImGui.Spacing()
									if(localversion ~= datapack.version) then
										
										if ImGui.Button("Update", 300, 0) then
											UpdateModpack(datapack)
											waitingDownloaded(false,5)
										end
										ImGui.Spacing()
										
									end
									
									if(datapack.isessential == false and datapack.isdebug == false) then
										if ImGui.Button("Delete", 300, 0) then
											DeleteModpack(datapack.tag)
											waitingDownloaded(true,5)
										end
										else
										if ImGui.Button("Can't be deleted", 300, 0) then
											
										end
									end
									else
									
									if(datapack.isdownloadable == true or datapack.isdownloadable ==  nil or ((datapack.requirement ~= nil and questMod.version == datapack.requirement) or datapack.requirement == nil)) then
										
										if ImGui.Button("Download", 300, 0) then
											DownloadModpack(datapack)
											
											waitingDownloaded(true,10)
											
											
										end
										
										else
										
										if ImGui.Button("Need to update IRP first", 300, 0) then
											
										end
										
									end
									
								end
							
							
							ImGui.EndChild()
							
							if(counter < 3) then
								ImGui.SameLine()
								else
								ImGui.Spacing()
								counter = 0
							end
							
						end
					end
				end
				
				else
				
				
				ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
				
			end
			
			CPS.colorEnd(1)
			CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
end


function MyDatapack()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("MyDatapack") then
		
		if ImGui.Button("Reload List", 500, 0) then
			GetModpackList()
			
				waitingDownloaded(false,0.5)
			
			
		end
		
		ImGui.SameLine()
		
		
		if ImGui.Button("Datapack Manager", 500, 0) then
			
			
			openDatapackManager = true
			
			
		end
		
		
		
		ImGui.BeginChild("MyDatapack", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		
		local counter = 0
		if waiting == false and mainwait == false then
			if arrayMyDatapack ~= nil then
				for i = 1,#arrayMyDatapack  do
					counter = counter +1
					
					
					
					ImGui.BeginChild("MyDatapack"..i, 300, 200)
					local datapack = arrayMyDatapack[i]
					
					ImGui.SetWindowFontScale(1)
					--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Name : "..datapack.name)--content
					
					
					ImGui.Spacing()
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Description : "..datapack.desc)--content
					
					ImGui.Spacing()
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Author : "..datapack.author)--content
					
					ImGui.Spacing()
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Version : "..datapack.version)--content
					
					ImGui.Spacing()
					
					if(isDatapackDownloaded(datapack.tag)) then
						
						
						
						
						
						ImGui.Spacing()
						if(LocalNeedUpdate(datapack.tag)) then
							
							if ImGui.Button("Update", 300, 0) then
								UpdateModpack(datapack.file)
								waitingDownloaded(false,10)
							end
							ImGui.Spacing()
							
						end
						
						if(datapack.isessential == false and datapack.isdebug == false) then
							if ImGui.Button("Delete", 300, 0) then
								DeleteModpack(datapack.tag)
								waitingDownloaded(true,2)
							end
							else
							if ImGui.Button("Can't be deleted", 300, 0) then
								
							end
						end
						
						
					end
					
					
					ImGui.EndChild()
					
					if(counter < 3) then
						ImGui.SameLine()
						else
						ImGui.Spacing()
						counter = 0
					end
					
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
end


function Market()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("Market") then
		
		
		
		
		
		ImGui.BeginChild("Market", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		
		
		
		
		local counter = 0
		if waiting == false and mainwait == false then
			if ImGui.Button("Load Market", 1200, 0) then
				GetScores()
			end
			
			local money = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(TweakDBID.new("Items.money")))
			ImGui.Spacing()
			ImGui.Text("Your Money : "..money)
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			if arrayMarket ~= nil and #arrayMarket > 0 then
				for i = 1,#arrayMarket  do
					
					local score = arrayMarket[i]
					if(score ~= nil) then
						counter = counter +1
						
						
						
						ImGui.BeginChild("Scores"..i, 300, 150)
						
						
						ImGui.SetWindowFontScale(1)
						--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Title : "..score.title)--content
						
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Price : "..score.price)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Inflate : "..score.inflate)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Quantity : "..score.quantity)--content
						
						ImGui.Spacing()
						
						
						
						if(score.quantity > 0) then
						
							if(checkStackableItemAmount("Items.money",score.price)) then
								if ImGui.Button("Buy", 300, 0) then
									waiting = true
									BuyScore(score.tag)
									
								--	setScore(score.tag,"Quantity",score.statut)
									local player = Game.GetPlayer()
									local ts = Game.GetTransactionSystem()
									local tid = TweakDBID.new("Items.money")
									local itemid = ItemID.new(tid)
									local amount = tonumber(score.price)
									
									
									
									local result = ts:RemoveItem(player, itemid, amount)
								end
							end
							
						end
						
					
						 
						if(score.userQuantity ~= nil and score.statut ~= 0) then
							ImGui.Spacing()
							
							ImGui.TextColored(0.36, 0.96, 1, 1, "Buyed Quantity : "..score.userQuantity)--content
						end
						
						if(score.userQuantity ~= nil and score.statut ~= 0 and score.userQuantity ~= nil and score.userQuantity > 0) then
							if ImGui.Button("Sell", 300, 0) then
								waiting = true
								SellScore(score.tag)
								
								
								
								
							
								local player = Game.GetPlayer()
								local ts = Game.GetTransactionSystem()
								local tid = TweakDBID.new("Items.money")
								local itemid = ItemID.new(tid)
								local amount = tonumber(score.price)
								
								
								
								local result = ts:GiveItem(player, itemid, amount)
								
								-- if myscore == 0 then
									-- setScore(score.tag,"Score",score.defaultStatut)
								-- end
							end
							
						end
						
						ImGui.EndChild()
						
						if(counter < 3) then
							ImGui.SameLine()
							else
							ImGui.Spacing()
							counter = 0
						end
						
					end
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
	
end

function MultiTabs()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	if waiting == false and mainwait == false then
	
	if ImGui.BeginTabItem("Online Settings") then
		
		ImGui.Text("Statut : ")
		ImGui.SameLine()
		ImGui.Text(tostring(MultiplayerOn))
		ImGui.Spacing()
		
		ImGui.Text("Your Corpo : ")
		ImGui.SameLine()
		ImGui.Text(currentFaction.."(Rank : "..currentFactionRank.." )")
		ImGui.Spacing()
		ImGui.Text("Cannot be changed on your own, contact an admin for ask an change.")
		
		if(currentSave.myAvatarName == nil) then
		
		currentSave.myAvatarName = currentSave.myAvatar
		
		end
		
		if ImGui.BeginCombo("Avatar",  currentSave.myAvatarName) then -- Remove the ## if you'd like for the title to display above combo box
						
					
						
				for i,v in ipairs(arrayPnjDb) do
		
					if ImGui.Selectable(v.Names, (currentSave.myAvatar == v.TweakIDs)) then
						
						
						currentSave.myAvatar = v.TweakIDs
						currentSave.myAvatarName = v.Names
						
						
						ImGui.SetItemDefaultFocus()
					end
					
					
				end
				
				
						
			ImGui.EndCombo()
		end
		ImGui.SameLine()
		if ImGui.Button("Save Avatar") then 
				
			updatePlayerSkin()
			
			
			
			
		end
		
		if currentRole ~= "User" then
			if ImGui.BeginCombo("Branch",  currentbranch) then -- Remove the ## if you'd like for the title to display above combo box
							
						
							
				for i,v in ipairs(possiblebranch) do
		
					if ImGui.Selectable(v, (currentbranch == v)) then
						
						
						currentbranch= v
						
						
						ImGui.SetItemDefaultFocus()
					end
					
					
				end
					
					
					
							
				ImGui.EndCombo()
			end
			ImGui.SameLine()
			if ImGui.Button("Save branch") then 
				
			SaveBranch()
			
			
			
			
			end
			
		end
		
		
		if(MultiplayerOn) then
		if ImGui.Button("Log out from Multiplayer") then 
			
			lastFriendPos = {}
			Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
			
			MultiplayerOn = false
			
			
			friendIsSpaned = false
			
			
			
		end
		
		else
		
		if ImGui.Button("Log in to Multiplayer") then 
			
			lastFriendPos = {}
			Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
			
			friendIsSpaned = false
			
		
			
			
			MultiplayerOn = true
			
			
			
			
			
		end
		
		end
		
		
	
		
		
		
		
		ImGui.EndTabItem()
	end
	
	else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
	
end

function ItemMarket()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("Item Market") then
		
		
		
		
		
		ImGui.BeginChild("Item Market", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		
		
		
		
		local counter = 0
		if waiting == false and mainwait == false then
		local money = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(TweakDBID.new("Items.money")))
		ImGui.Spacing()
		ImGui.Text("Your Money : "..money)
		
		ImGui.SameLine()
		ImGui.Text("Cart Total : "..CartPrice)
		ImGui.Spacing()
			if ImGui.Button("Load Item Market", 600, 0) then
				GetItems()
			end
			ImGui.SameLine()
			
			
			query, selected = ImGui.InputTextWithHint("", "Search", query, 100)
			
			if ImGui.BeginCombo("Category",  querycat) then -- Remove the ## if you'd like for the title to display above combo box
				
						
							
					for i,v in ipairs(possiblecategory) do
			
						if ImGui.Selectable(v, (querycat== v)) then
							
							
							querycat = v
							
							
							ImGui.SetItemDefaultFocus()
						end
						
						
					end
					
					
							
				ImGui.EndCombo()
			end
			
			ImGui.Spacing()
			
			if ImGui.Button("Buy my cart ("..tostring(#ItemsCart)..")", 600, 0) then
			
				if(checkStackableItemAmount("Items.money",CartPrice)) then
				
					local itemCartTagList = {}
					waiting = true
					
					for i = 1,#ItemsCart do
					
						local items = ItemsCart[i]
						table.insert(itemCartTagList,items.Tag)
						
						
						
						updatePlayerItemsQuantity(items,1)
						
						local player = Game.GetPlayer()
						local ts = Game.GetTransactionSystem()
						local tid = TweakDBID.new("Items.money")
						local itemid = ItemID.new(tid)
						local amount = tonumber(items.Price)
						
						
						
						local result = ts:RemoveItem(player, itemid, amount)
						
						
						
						
					end
					
					
					BuyItemsCart(itemCartTagList)
						
					ItemsCart = {}
					
					CartPrice = 0	
				end	
			end
			
			
			if arrayMarketItem ~= nil then
				for i = 1,#arrayMarketItem  do
					
					local items = arrayMarketItem[i]
					
					if( querycat == "" and (query == nil or query == "" )) then
						if(items ~= nil) then
						counter = counter +1
						
						
						
						ImGui.BeginChild("Items"..i, 300, 250)
						
						
						ImGui.SetWindowFontScale(1)
						--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Title : "..items.Title)--content
						
						
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Category : "..items.parentCategory)--content
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Sub Category : "..items.childCategory)--content
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Flag: "..items.flag)--content
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Price : "..items.Price)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Inflate : "..items.Inflate)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Quantity : "..items.Quantity)--content
						
						ImGui.Spacing()
						
						
						
						if(items.Quantity > 0 and checkStackableItemAmount("Items.money",(CartPrice+items.Price))) then
							if ImGui.Button("Add to Cart", 300, 0) then
								
										table.insert(ItemsCart,items)
										CartPrice = CartPrice + items.Price
								
							end
						else
						
							if ImGui.Button("Not enough Money", 300, 0) then
								
										
								
							end
						
						end
						
						
						if(getItemCountInCart(items.Tag) > 0) then
							if ImGui.Button("Remove from Cart", 300, 0) then
								removeItemInCart(items.Tag)
							end
							
						end
						
						local playerItems = getPlayerItemsbyTag(items.Tag)
						
						if(playerItems ~= nil) then
							ImGui.Spacing()
							
							ImGui.TextColored(0.36, 0.96, 1, 1, "Buyed Quantity : "..playerItems.Quantity)--content
						end
						
						if(playerItems ~= nil and playerItems.Quantity > 0) then
							if ImGui.Button("Sell", 300, 0) then
								waiting = true
								SellScore(items.Tag)
								playerItems = getPlayerItemsbyTag(items.Tag)
								
								
								updatePlayerItemsQuantity(items,-1)
								
								local player = Game.GetPlayer()
								local ts = Game.GetTransactionSystem()
								local tid = TweakDBID.new("Items.money")
								local itemid = ItemID.new(tid)
								local amount = tonumber(items.Price)
								
								
								
								local result = ts:GiveItem(player, itemid, amount)
								
								
							end
							
						end
						
						ImGui.EndChild()
						
						if(counter < 3) then
							ImGui.SameLine()
							else
							ImGui.Spacing()
							counter = 0
						end
						
						end
					
					else
						
						
						
						if(items ~= nil) then
						local ismatch = false
						if (querycat == "" or (querycat ~= "" and string.match(string.lower(items.parentCategory), string.lower(querycat)))) then
						
						if (string.match(string.lower(items.Tag), string.lower(query)) 
							or string.match(string.lower(items.Title), string.lower(query)) 
							or string.match(string.lower(items.parentCategory), string.lower(query)) 
							
							or string.match(string.lower(items.childCategory), string.lower(query)) 
							or string.match(string.lower(items.flag), string.lower(query))) then
						
							
							ismatch = true
							end
						end
						
						if(ismatch == true) then
						counter = counter +1
						
						
						
						ImGui.BeginChild("Items"..i, 300, 250)
						
						
						ImGui.SetWindowFontScale(1)
						--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Title : "..items.Title)--content
						
						
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Category : "..items.parentCategory)--content
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Sub Category : "..items.childCategory)--content
						ImGui.Spacing()
						ImGui.TextColored(0.36, 0.96, 1, 1, "Flag: "..items.flag)--content
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Price : "..items.Price)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Inflate : "..items.Inflate)--content
						
						ImGui.Spacing()
						
						ImGui.TextColored(0.36, 0.96, 1, 1, "Quantity : "..items.Quantity)--content
						
						ImGui.Spacing()
						
						
						
						if(items.Quantity > 0 and checkStackableItemAmount("Items.money",(CartPrice+items.Price))) then
							-- if ImGui.Button("Buy", 300, 0) then
								-- if(checkStackableItemAmount("Items.money",items.Price)) then
									-- waiting = true
									-- BuyItems(items.Tag)
									
									-- updatePlayerItemsQuantity(items,1)
									
									-- local player = Game.GetPlayer()
									-- local ts = Game.GetTransactionSystem()
									-- local tid = TweakDBID.new("Items.money")
									-- local itemid = ItemID.new(tid)
									-- local amount = tonumber(items.Price)
									
									
									
									-- local result = ts:RemoveItem(player, itemid, amount)
								-- end
							-- end
							
							if ImGui.Button("Add to Cart", 300, 0) then
								
										table.insert(ItemsCart,items)
										CartPrice = CartPrice + items.Price
								
							end
							
						end
						
						local playerItems = getPlayerItemsbyTag(items.Tag)
						
						if(playerItems ~= nil) then
							ImGui.Spacing()
							
							ImGui.TextColored(0.36, 0.96, 1, 1, "Buyed Quantity : "..playerItems.Quantity)--content
						end
						
						if(playerItems ~= nil and playerItems.Quantity > 0) then
							if ImGui.Button("Sell", 300, 0) then
								waiting = true
								SellScore(items.Tag)
								playerItems = getPlayerItemsbyTag(items.Tag)
								
								
								updatePlayerItemsQuantity(items,-1)
								
								local player = Game.GetPlayer()
								local ts = Game.GetTransactionSystem()
								local tid = TweakDBID.new("Items.money")
								local itemid = ItemID.new(tid)
								local amount = tonumber(items.Price)
								
								
								
								local result = ts:GiveItem(player, itemid, amount)
								
								
							end
							
						end
						
						ImGui.EndChild()
						
						if(counter < 3) then
							ImGui.SameLine()
							else
							ImGui.Spacing()
							counter = 0
						end
						
						end
						end
					end
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
end


function CorpoWarsNews()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("Corpo Wars Network") then
		
		
		
		
		
		ImGui.BeginChild("Corpo Wars Network", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		
		
		
		
		local counter = 0
		if waiting == false and mainwait == false then
			if ImGui.Button("Refresh News", 1200, 0) then
				GetCorpoNews()
				
			end
			
		
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			if #corpoNews > 0 then
			
			
				local arasaka = getMarketScoreByTag("arasaka_action")
				
				local militech = getMarketScoreByTag("militech_action")
				
				local kangtao = getMarketScoreByTag("kangtao_action")
			
				
				ImGui.TextColored(0.36, 0.96, 1, 1, arasaka.title.." : " ..arasaka.price.."  ")--content
						
						
				ImGui.SameLine()
				
				ImGui.TextColored(0.36, 0.96, 1, 1, militech.title.." : " ..militech.price.."  ")--content
				
				ImGui.SameLine()
				
				ImGui.TextColored(0.36, 0.96, 1, 1, kangtao.title.." : " ..kangtao.price.."  ")--content
						
				
				
				ImGui.Spacing()
				ImGui.Spacing()
				ImGui.Spacing()
			
				
			
			
			
				for i = 1,#corpoNews  do
					
					local news = corpoNews[i]
					if(news ~= nil) then
						
						ImGui.TextColored(0.36, 0.96, 1, 1, news)--content
						ImGui.Spacing()
						
						
						
					end
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
	
end


function removeItemInCart(tag) 
	
	local continue = true
	local result = false
	local index = nil
	
	
	for i=1,#ItemsCart do
	
		if(ItemsCart[i].tag == tag and continue == true) then
		
			index = i
			continue = false
		
		end
	
	end
	
	if(index ~= nil) then
	
	table.remove(ItemsCart,index)
	result = true
	end
	
	return result
	
	
	
end

function waitingDownloaded(bool,timer)
	waiting = true
	--openDatapackManager = bool
	
end

function finishwaiting(bool)

	openDatapackManager = bool
		waiting = false
		initfinish = true

end

function MissionHomeTabs()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("Mission") then
		
		if ImGui.Button("Reload List", 500, 0) then
			GeMissionList()
			
			waitingDownloaded(false,1)
			
			
		end
		
		ImGui.SameLine()
		
		
		if ImGui.Button("Datapack Manager", 500, 0) then
			
			
			openDatapackManager = true
			
			
		end
		
		
		
		ImGui.BeginChild("Mission", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		
		local counter = 0
		if waiting == false and mainwait == false then
			if arrayMission ~= nil then
				for i = 1,#arrayMission  do
					
					local mission = arrayMission[i]
					
					counter = counter +1
					
					
					
					ImGui.BeginChild("Mission"..i, 300, 200)
					
					
					ImGui.SetWindowFontScale(1)
					--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Name : "..mission.title)--content
					
					
					ImGui.Spacing()
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Description : "..mission.content)--content
					local tab1hov = ImGui.IsItemHovered()
						if tab1hov then
							CPS:CPToolTip1Begin(260, 220)
							ImGui.TextColored(0.79, 0.40, 0.29, 1, "Description")
							ImGui.Spacing()
							CPS.colorBegin("Text", "00fdc4")
							ImGui.TextWrapped(mission.content)
							CPS.colorEnd(1)
							
							CPS:CPToolTip1End()
						end
					
					if(isMissionDownloaded(mission.tag)) then
						
						
						
						
						if ImGui.Button("Delete", 300, 0) then
							waiting = true
							DeleteMission(mission.tag)

						end
						
						
						else
						
						
						if ImGui.Button("Download", 300, 0) then
						waiting = true
							DownloadMission(mission.tag)
							
							
							
							
						end
						
						
						
					end
					
					
					ImGui.EndChild()
					
					if(counter < 3) then
						ImGui.SameLine()
						else
						ImGui.Spacing()
						counter = 0
					end
					
					
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
end


function MyMissions()
	ImGui.SetWindowFontScale(1)
	CPS.colorBegin("Button", "0ebff1")
	CPS.colorBegin("Text", "FFFFFF")
	
	
	if ImGui.BeginTabItem("MyMission") then
		
		if ImGui.Button("Reload List", 500, 0) then
			GetModpackList()
			
			waitingDownloaded(false,5)
			
			
		end
		
		ImGui.SameLine()
		
		
		if ImGui.Button("Datapack Manager", 500, 0) then
			
			
			openDatapackManager = true
			
			
		end
		
		
		
		ImGui.BeginChild("MyDatapack", 1200, 700)
		CPS.colorBegin("Text", "FFFFFF")
		CPS.colorBegin("Button",{"941005",1})
		debugPrint(1,"arrayMymissions"..#arrayMymissions)
		local counter = 0
		if waiting == false and mainwait == false then
			if arrayMymissions ~= nil then
				for i = 1,#arrayMymissions  do
					counter = counter +1
					
					
					
					ImGui.BeginChild("MyMission"..i, 300, 200)
					local mtag = arrayMymissions[i]
					local mission = getQuestByTag(mtag)
					ImGui.SetWindowFontScale(1)
					--if CPS:CPButton(arrayPhoneNPC[i].Names, 485, 0) then
					
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Name : "..mission.title)--content
					
					
					ImGui.Spacing()
					
					ImGui.TextColored(0.36, 0.96, 1, 1, "Description : "..mission.content)--content
					local tab1hov = ImGui.IsItemHovered()
						if tab1hov then
							CPS:CPToolTip1Begin(260, 220)
							ImGui.TextColored(0.79, 0.40, 0.29, 1, "Description")
							ImGui.Spacing()
							CPS.colorBegin("Text", "00fdc4")
							ImGui.TextWrapped(mission.content)
							CPS.colorEnd(1)
							
							CPS:CPToolTip1End()
						end
					if ImGui.Button("Delete", 300, 0) then
						waiting = true
						DeleteMission(mission.tag)
						
					end
					
					
					
					ImGui.EndChild()
					
					if(counter < 3) then
						ImGui.SameLine()
						else
						ImGui.Spacing()
						counter = 0
					end
					
				end
			end
			
			else
			
			
			ImGui.TextColored(0.36, 0.96, 1, 1, processing)--content
			
		end
		CPS.colorEnd(1)
		CPS.colorEnd(1)
		ImGui.EndChild()
		
		
		
		ImGui.EndTabItem()
	end
	CPS.colorEnd(1)	
	CPS.colorEnd(1)	
end


