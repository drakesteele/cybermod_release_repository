debugPrint(3,"CyberScript: taxi module loaded")
questMod.module = questMod.module +1

function taxiWindows()

	
	if inTaxiWindows == true then
		
	

		if ImGui.Begin("Delamain Taxi") then
			ImGui.SetNextWindowPos(800, 750, ImGuiCond.Appearing) -- set window position x, y
			ImGui.SetNextWindowPos(800, 400, ImGuiCond.FirstUseEver) -- set window position x, y
			ImGui.SetNextWindowSize(300, 500, ImGuiCond.Appearing) -- set window size w, h
			ImGui.SetWindowSize(300, 500)
			
			if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
				CPS.styleBegin("TabRounding", 0)
				
				
				
				
				
				
				if ImGui.BeginTabItem("Greeting V, Where do you want to go ?") then
					
					CPS.colorBegin("Button", "54c8ff")
					CPS.colorBegin("Text", "FFCA33")
					
					if(currentSelectedGameNode == nil) then
						
						if #FastTravelPoints > 0 then
							for i=1, #FastTravelPoints do 
								local point = FastTravelPoints[i]
								
								
								
									
									CPS.colorBegin("Text", "ff5145")-- get color from styles.lua
									CPS.colorBegin("Button", { 48, 234, 247 ,0})  
									pointName = point:GetPointDisplayName()

									if ImGui.Button(Game.GetLocalizedText(pointName)) then 
										
										currentSelectedGameNode = nil
										currentSelectedGameNode = point:GetMarkerRef()
										startTaxiDriving()
										inTaxiWindows = false
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
				CPS.styleEnd(1)
				ImGui.EndTabBar()
				end
				ImGui.End()
				
			end
		
		

		
		
		
		
	end
	
end

function startTaxiDriving()
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			local entity = Game.GetPlayer()
			
			positionVec4 = getForwardPosition(entity,3)
			
			
			local ambush = false
			
			
			spawnEntity("Vehicle.v_standard2_villefort_cortes_delamain", "taxi_delamain", positionVec4.x, positionVec4.y ,positionVec4.z,88,ambush)
			
			Cron.After(1, function()
				
				SetSeat("player", "taxi_delamain", true, "seat_back_left")
			
			waitPlayerInTaxi(5, function()
				if(checkStackableItemAmount("Items.money",50)) then
									
									
				local player = Game.GetPlayer()
				local ts = Game.GetTransactionSystem()
				local tid = TweakDBID.new("Items.money")
				local itemid = ItemID.new(tid)
				local amount = tonumber(500)
				
				
				
				local result = ts:RemoveItem(player, itemid, amount)
				VehicleGoToGameNode("taxi_delamain", currentSelectedGameNode, 150, false, false)
				currentSelectedGameNode = nil
				lastcurpos = curPos
					Cron.After(20, function()
						if(lastcurpos == curPos) then 
							UnsetSeat("player",false, "seat_back_left")
								Cron.After(2, function()
		
									
									despawnEntity("taxi_delamain")
									
									
									questMod.EntityManager["taxi_delamain"] = nil
									lastcurpos = nil
									Game.GetPlayer():SetWarningMessage("Destination is too far !")
								end)
						else
						
						taxiIsArrived(10, function()
								UnsetSeat("player",false, "seat_back_left")
								Cron.After(2, function()
		
	
									despawnEntity("taxi_delamain")
									questMod.EntityManager["taxi_delamain"] = nil
									lastcurpos = nil
								end)
								
						
						end)
						end
						end)
					
					
				else
				currentSelectedGameNode = nil
					Game.GetPlayer():SetWarningMessage("Not enough Money !")
					UnsetSeat("player",false, "seat_back_left")
								Cron.After(2, function()
		
	
									despawnEntity("taxi_delamain")
									questMod.EntityManager["taxi_delamain"] = nil
									lastcurpos = nil
								end)
				end				
				
				
								
			end)
			end)
			
	
end

function waitPlayerInTaxi(timer,functionprint)
	
	Cron.After(timer, function()
		
	
		if (isDelamainDrived == true and inMenu == false) then
			
			
			functionprint()	
			else
			
			
			waitPlayerInTaxi(timer,functionprint)
		end
	end)
	
end

function waitForCustomMappin(timer,functionprint)
	
	Cron.After(timer, function()
		
	
		if (ActivecustomMappin ~= nil and inMenu == false) then
			
			debugPrint(1,"mappin ok")
			functionprint()	
			else
			debugPrint(1,"not in av")
			
			waitForCustomMappin(timer,functionprint)
		end
	end)
	
end

function waitPlayerNotInTaxi(timer,functionprint)
	
	Cron.After(timer, function()
		
	
		if (isDelamainDrived == false and inMenu == false) then
			
			debugPrint(1,"not in taxi")
			functionprint()	
			else
			
			
			waitPlayerNotInTaxi(timer,functionprint)
		end
	end)
	
end

function taxiIsArrived(timer,functionprint)
	
	Cron.After(timer, function()
	
		if (curPos.x == lastcurpos.x and curPos.y == lastcurpos.y) then
			
			--debugPrint(1,"arrived")
			functionprint()	
			
			else
			lastcurpos = curPos
			--debugPrint(1,"not arrived")
			taxiIsArrived(timer,functionprint)
		end
	end)
	
end