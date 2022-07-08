debugPrint(3,"CyberMod: Custom Place module loaded")
questMod.module = questMod.module +1

-- 0 : house
-- 1 : bar
-- 2 : nightclub
-- 3 : restaurant
-- 4 : shopping
-- 5 : special



--enum type room action
-- 0 : drink
-- 1 : eat
-- 2 : do

--enum type interact 
-- 0 : Nothing
-- 1 : Change Time
-- 2 : Change Stat
-- 3 : Mod Stat
-- 100 : Launch Quest
-- 200 : Launch Dialog


-- house statut
-- 0 or nil : not buyed
-- 1 : buy
-- 2 : rent

function loadCustomMultiPlace()
	
	
		

	if(curPos ~= nil and ActualPlayerMultiData ~= nil and  ActualPlayerMultiData.currentPlaces[1] ~= nil and check3DPos(curPos,ActualPlayerMultiData.currentPlaces[1].posX,ActualPlayerMultiData.currentPlaces[1].posY, ActualPlayerMultiData.currentPlaces[1].posZ,ActualPlayerMultiData.currentPlaces[1].range, ActualPlayerMultiData.currentPlaces[1].Zrange))then
		
		currentMultiHouse = ActualPlayerMultiData.currentPlaces[1]
		
		
	else
			
		if ItemOfHouseMultiSpawned == true then
			despawnItemFromMultiHouse()
			debugPrint(1,"tot2222")
			ItemOfHouseMultiSpawned = false
		end
		
		isInMultiHouse = false
		currentMultiHouse = nil
		selectedItemMulti = nil
		
	end
	
	
	
	
	if(currentMultiHouse ~= nil) then
		
			spawnItemFromHouseMultiTag()
			
			
			
			
			
			isInMultiHouse = true
			
			
			
			
			if(currentMultiHouse.type == 0) then
				Game.ChangeZoneIndicatorSafe()
			end
			
			
				
				
				
			
			
		else
			
			if ItemOfHouseMultiSpawned == true then
			debugPrint(1,"tot22")
				despawnItemFromMultiHouse()
				ItemOfHouseMultiSpawned = false
			end
			
			isInMultiHouse = false
			currentMultiHouse = nil
			selectedItemMulti = nil
		end
		
		
	
end

function loadCustomPlace()
	
	for k,v  in pairs(arrayHouse) do
		
		
		if(curPos ~= nil and currentHouse == nil and check3DPos(curPos,v.house.posX,v.house.posY, v.house.posZ,v.house.range, v.house.Zrange))then
			
			if(checkTriggerRequirement(v.house.requirement,v.house.trigger)) then
				currentHouse = v.house
				
				
				
				
				
				else
				
				if ItemOfHouseSpawned == true then
					despawnItemFromHouse()
					ItemOfHouseSpawned = false
				end
				
				isInHouse = false
				currentHouse = nil
				selectedItem = nil
			end
			
		end
	end
	
	
	
	if(currentHouse ~= nil) then
		
		if(checkTriggerRequirement(currentHouse.requirement,currentHouse.trigger) and check3DPos(curPos,currentHouse.posX,currentHouse.posY, currentHouse.posZ,currentHouse.range, currentHouse.Zrange) ) then
			
			if ItemOfHouseSpawned == false  then
				spawnItemFromHouseTag(currentHouse.tag)
				ItemOfHouseSpawned = true
			end
			
			
			if(currentHouse.action ~= nil and #currentHouse.action >0) then
				
				
				runActionList(currentHouse.action,currentHouse.tag,"interact",false,currentHouse.tag,false)
			end
			
			isInHouse = true
			
			
			
			
			if(currentHouse.type == 0) then
				Game.ChangeZoneIndicatorSafe()
			end
			
			currentRoom = nil
				for y = 1, #currentHouse.rooms do 
					if(check3DPos(curPos,currentHouse.rooms[y].posX,currentHouse.rooms[y].posY,currentHouse.rooms[y].posZ,currentHouse.rooms[y].range,currentHouse.rooms[y].Zrange) )then
						if(checkTriggerRequirement(currentHouse.rooms[y].requirement,currentHouse.rooms[y].trigger)) then
							currentRoom = currentHouse.rooms[y]
							if(currentRoom.action ~= nil and #currentRoom.action >0) then
								
							
								runActionList(currentRoom.action,currentRoom.tag,"interact",false,currentHouse.tag)
							end
							
							--getTriggeredActions()
						end
						
						
						
						
					end
					
					
					
					
					
					
				end
				
				
				
				
				
			
			
		else
			
			if ItemOfHouseSpawned == true then
				despawnItemFromHouse()
				ItemOfHouseSpawned = false
			end
			
			isInHouse = false
			currentHouse = nil
			selectedItem = nil
		end
		
		
	end
end

function setCustomLocationPoint() 
	
	if(arrayHouse ~= nil) then
	for _,h in pairs(arrayHouse) do
		
		
		
	
		variantType = "FixerVariant"
		
		if h.house.type == 0 then --house
			variantType = "ApartmentVariant"
			elseif h.house.type == 1 then--bar
			variantType = "ServicePointBarVariant"
			elseif h.house.type == 2 then--nightclub
			variantType = "ServicePointBarVariant"
			elseif h.house.type == 3 then--restaurant
			variantType = "ServicePointFoodVariant"
			elseif h.house.type == 4 then--shopping
			variantType = "ServicePointJunkVariant"
		end
		
		local score = getScoreKey(h.house.tag,"Score")
		
		
		
			if(h.house.type == 0 and score == 0) then
				variantType = "Zzz05_ApartmentToPurchaseVariant "
			
			end
			
			if(mappinManager[h.house.tag] == nil) then
		
			registerMappin( h.house.posX, h.house.posY, h.house.posZ, h.house.tag ,variantType,true,false,nil,nil)
			end
		
		
	end
	end
	
	
	if(arrayNode ~= nil) then
	for k,v in pairs(arrayNode)  do
	
	local node = v.node
		if(node.sort == "metro") then
		
			if(mappinManager[node.tag] == nil) then
		
				registerMappin(node.GameplayX, node.GameplayY, node.GameplayZ, node.tag ,"Zzz01_CarForPurchaseVariant",true,false,nil,nil)
			end
			
			
		end
							
	end
	end
	
end


