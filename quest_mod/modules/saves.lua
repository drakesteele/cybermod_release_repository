debugPrint(3,"CyberMod: saves module loaded")
questMod.module = questMod.module +1



function migrateFromDB()
reloadDB()

currentSave.arrayPlayerData = arrayPlayerData
currentSave.arrayAffinity = arrayAffinity
currentSave.arrayQuestStatut = arrayQuestStatut
currentSave.arrayFactionScore = arrayFactionScore
currentSave.arrayUserSetting = arrayUserSetting
currentSave.arrayHouseStatut = arrayHouseStatut
currentSave.arrayPlayerItems = arrayPlayerItems


print(#arrayAffinity)

for i=1,#arrayAffinity do
	local item = arrayAffinity[i]
	local pnj = getNPCById(item.NpcId)
	currentSave.Score[pnj.Names] = {}
	currentSave.Score[pnj.Names]["Score"] = item.Score
	
end


for i=1,#arrayQuestStatut do
	local item = arrayQuestStatut[i]
	
	currentSave.Score[item.Tag] = {}
	currentSave.Score[item.Tag]["Score"] = item.Score
	currentSave.Score[item.Tag]["Quantity"] = item.Quantity
	
end

for i=1,#arrayFactionScore do
	local item = arrayFactionScore[i]
	
	currentSave.Score[item.Tag] = {}
	currentSave.Score[item.Tag]["Score"] = item.Score
	
end


for i=1,#arrayHouseStatut do
	local item = arrayHouseStatut[i]
	
	currentSave.Score[item.Tag] = {}
	currentSave.Score[item.Tag]["Score"] = item.Statut
	currentSave.Score[item.Tag]["Quantity"] = item.Score
	
end



	
end

function initGangDistrictScore()
	
	if (currentSave.arrayFactionDistrict == nil) then
	
	currentSave.arrayFactionDistrict = {}
	end
	
for k,v in pairs(arrayFaction) do
	
	if(arrayFaction[k].faction.haveterritory == nil or arrayFaction[k].faction.haveterritory == true) then 
	
	if(currentSave.arrayFactionDistrict[k] == nil) then
	
	currentSave.arrayFactionDistrict[k] = {}
	
	
	end
	
	
	for j=1,#arrayDistricts do 
	
	
		local isOwner = false
		
		if(arrayFaction[k].faction.DistrictTag == arrayDistricts[j].Tag) then
		
		currentSave.arrayFactionDistrict[k][arrayDistricts[j].Tag] = 100
		 isOwner = true
		else
		
		currentSave.arrayFactionDistrict[k][arrayDistricts[j].Tag] = 0
		
		end
		
		if(#arrayDistricts[j].SubDistrict > 0) then
			for z=1,#arrayDistricts[j].SubDistrict do
				
				if(isOwner) then
				currentSave.arrayFactionDistrict[k][arrayDistricts[j].SubDistrict[z]] = 100
			
				else
				
				currentSave.arrayFactionDistrict[k][arrayDistricts[j].SubDistrict[z]] = 0
				
				end
			end
		end
		
		
	end
	
	end
end


end

function initGangRelation()
	
	
	
for k,v in pairs(arrayFaction) do
	
	
	
	if(currentSave.Score[k] == nil) then
	
		currentSave.Score[k] = {}
	
	
	end
	
	
	for x,y in pairs(arrayFaction) do
	
		local isrival = false
		for i=1, #v.faction.Rivals do
		
			if(v.faction.Rivals[i] == x) then
			isrival = true
			break
			end
		end
		
		if(isrival == true) then
			currentSave.Score[k][x] = -100
			else
			currentSave.Score[k][x] = 0
		end
	
	end
end
	
	
end






function updateUserSetting(tag,value)
	
	local newdata = true
	
	for i=1,#currentSave.arrayUserSetting do
	
		if(currentSave.arrayUserSetting[i].Tag == tag) then
			currentSave.arrayUserSetting[i].Value = value
			debugPrint(1,"Updated "..tag.." : "..tostring(value))
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Value = value
		table.insert(currentSave.arrayUserSetting, data)
		debugPrint(1,"Added "..tag.." : "..tostring(value))
	end
	
	
end




function saveHousing(item)
	item.Id = item.HouseTag.."_"..item.Tag.."_"..tostring(math.random(1,99999))
	
	local exist = false
	for i=1,#currentSave.arrayHousing do
	
		if(currentSave.arrayHousing[i].Id == item.Id) then
			exist = true
		end
	
	end
	
	if(exist == true) then
	
		item.Id = item.HouseTag.."_"..item.Tag.."_"..tostring(math.random(1,99999)).."_A"
	
	else
	
	table.insert(currentSave.arrayHousing, item)
	end
	
	
	
	
	
end

function deleteHousing(id)
	local index = nil
	
	for i=1,#currentSave.arrayHousing do
	
		if(currentSave.arrayHousing[i].Id == id) then
			index = i
		end
	
	end
	
	if(index ~= nil) then
		table.remove(currentSave.arrayHousing, index)
	
	end
	
end


function updateHousing(item)
	
	debugPrint(1,item.Id)
	local res = false 
	for i=1,#currentSave.arrayHousing do
	
		if(currentSave.arrayHousing[i].Id == item.Id) then
			currentSave.arrayHousing[i].X = item.X
			currentSave.arrayHousing[i].Y = item.Y
			currentSave.arrayHousing[i].Z = item.Z
			currentSave.arrayHousing[i].Yaw = item.Yaw
			currentSave.arrayHousing[i].Pitch = item.Pitch
			currentSave.arrayHousing[i].Roll = item.Roll
			
			res = true
		end
	
	end
	return res
	
end

function getHousing(tag,x,y,z)
	
	for i = 1, #currentSave.arrayHousing do
	
	local item = currentSave.arrayHousing[i]
		debugPrint(1,item.Tag)
		debugPrint(1,tag)
		
		debugPrint(1,item.X)
		debugPrint(1,x)
		
		debugPrint(1,item.Y)
		debugPrint(1,y)
		
		debugPrint(1,item.Z)
		debugPrint(1,z)
	if(tostring(item.X) == tostring(x) and tostring(item.Y) == tostring(y) and tostring(item.Z) == tostring(z) and tostring(item.Tag) == tostring(tag)) then
		debugPrint(1,item.Tag)
		return item
	
	end
	
	end
end

function updatePlayerItemsQuantity(item,quantity)
	
	
	
	local tag = item.tag or item.Tag
	local title = item.title or item.Title
	local path = item.path or item.Path
	
	local newdata = true
	
	for i=1,#currentSave.arrayPlayerItems do
	
		if(currentSave.arrayPlayerItems[i].Tag == tag) then
			currentSave.arrayPlayerItems[i].Quantity = currentSave.arrayPlayerItems[i].Quantity + quantity
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Title = title
		data.Path = path
		data.Quantity = quantity
		table.insert(currentSave.arrayPlayerItems, data)
	
	end
	
	
end





function addAffinityScoreByNPCId(tag)
	
	
		local scores = getScoreKey(tag,"Score")
		if(scores == nil) then scores = 0 end
	
		scores = scores +1
		setScore(tag,"Score",scores)
	
end

function addAffinityScoreByNPCIdScore(tag,changescore)
	
	local scores = getScoreKey(tag,"Score")
		if(scores == nil) then scores = 0 end
	
		scores = scores +changescore
		setScore(tag,"Score",scores)
	
	
end

function getNPCCallableByAffinity()
	
	contactList = {}
	arrayPhoneNPC = {}


	
	for i=1,#arrayPnjDb do
	
			local score = getScoreKey(arrayPnjDb[i].Names,"Score")
			
			if(score ~= nil) then
				local quest = {}
				quest.ID= arrayPnjDb[i].ID
				quest.TweakIDs= arrayPnjDb[i].TweakIDs
				quest.Names= arrayPnjDb[i].Names
				quest.Score = score
				table.insert(arrayPhoneNPC, quest)
				
				if(score >= 5)then
					local contactdata = {}
					contactdata.name =   "CM Affinity : "..arrayPnjDb[i].Names
					contactdata.id =   "cm_"..arrayPnjDb[i].Names
					contactdata.avatarID = arrayPnjDb[i].TweakIDs
					contactdata.phonetype = "NPC"
					contactdata.truename =  arrayPnjDb[i].Names
					
					table.insert(contactList,contactdata)
				end
				
			end
			
	
		
	
	end
	
	
	for k,v in pairs(arrayInteract) do 
							
	
			if(v.interact.display == "phone_service")then
			
				local contactdata = {}
				contactdata.name =  "CM Service : "..v.interact.name
				contactdata.id =  v.interact.tag
				contactdata.avatarID = "Character.Delamain"
				contactdata.phonetype = "Service"
				
				table.insert(contactList,contactdata)
				
			end
		
		
		

	end
	
	
	for k,v in pairs(arrayFixer) do
			
			if getScorebyTag(arrayFixer[k].fixer.Faction) > 50 then 
				
				
			
				local contactdata = {}
				contactdata.name =  "CM Fixer : Download Quest from "..arrayFixer[k].fixer.Name
				contactdata.id =  k
				contactdata.avatarID = arrayFixer[k].fixer.NPCId
				contactdata.phonetype = "Fixer"
				
				table.insert(contactList,contactdata)
			
			
				
			end
			
			
			
		end
	
	
	
end
	



function updateQuestStatut(tag,statut)
	
	local newdata = true
	
	for i=1,#currentSave.arrayQuestStatut do
	
		if(currentSave.arrayQuestStatut[i].Tag == tag) then
			currentSave.arrayQuestStatut[i].Statut = statut
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Statut = statut
		data.Quantity = nil
		table.insert(currentSave.arrayQuestStatut, data)
	
	end
	
	
end	




function updateQuestQuantity(tag,quantity)
	
	local newdata = true
	
	for i=1,#currentSave.arrayQuestStatut do
	
		if(currentSave.arrayQuestStatut[i].Tag == tag) then
			currentSave.arrayQuestStatut[i].Quantity = quantity
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Statut = 0
		data.Quantity = Quantity
		table.insert(currentSave.arrayQuestStatut, data)
	
	end
	
	
end	

function AddQuestQuantity(tag,quantity)
	
	local newdata = true
	
	for i=1,#currentSave.arrayQuestStatut do
	
		if(currentSave.arrayQuestStatut[i].Tag == tag) then
			currentSave.arrayQuestStatut[i].Quantity = currentSave.arrayQuestStatut[i].Quantity+quantity
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Statut = 0
		data.Quantity = Quantity
		table.insert(currentSave.arrayQuestStatut, data)
	
	end
	
	
end

function RemoveQuestQuantity(tag,quantity)
	
	local newdata = true
	
	for i=1,#currentSave.arrayQuestStatut do
	
		if(currentSave.arrayQuestStatut[i].Tag == tag) then
			currentSave.arrayQuestStatut[i].Quantity = currentSave.arrayQuestStatut[i].Quantity-quantity
			newdata = false
		end
	
	end
	
	if(newdata == true) then
	
		local data = {}
		data.Tag = tag
		data.Statut = 0
		data.Quantity = 0-Quantity
		table.insert(currentSave.arrayQuestStatut, data)
	
	end
	
	
end
	

	
	
function updateFactionScore(tag,score)
	
	
	local scores = getScoreKey(tag,"Score")
	if(scores == nil) then scores = 0 end
	
	scores = score
	setScore(tag,"Score",scores)

	
	
end	
	
function addFactionScoreByTagScore(tag,score)
	
	local scores = getScoreKey(tag,"Score")
	if(scores == nil) then scores = 0 end
	
	scores = scores + score
	setScore(tag,"Score",scores)

	
	
end	
	
	

function setFactionRelation(factiontag,otherfactiontag,score)
	
	
	local scores = getScoreKey(factiontag,otherfactiontag)
	if(scores == nil) then scores = 0 end
	
	scores = score
	
	setScore(factiontag,otherfactiontag,scores)

	
	
end	

function addFactionRelation(factiontag,otherfactiontag,score)
	
	
	local scores = getScoreKey(factiontag,otherfactiontag)
	if(scores == nil) then scores = 0 end
	
	scores = scores + score
	
	setScore(factiontag,otherfactiontag,scores)

	
	
end	

function getFactionRelation(factiontag,otherfactiontag)
	local score = currentSave.Score[factiontag][otherfactiontag]
	
	if(score ~= nil) then
	
	return score
	else
	return 0
	end
	
	
end	


function updateHouseStatut(tag,statut)
	
	
	setScore(tag,"Score",statut)
	
	
	
end		
	
function updateHouseScore(tag,score)
	
	setScore(tag,"Quantity",score)
	
	
end		
	

	
	
	
	
	
	
function setScore(tag,key,score)
	
	
	if(type(score) == "number") then
	
		if(currentSave.Score[tag] == nil) then
		
		
		currentSave.Score[tag] = {}
		currentSave.Score[tag][key] = 0
		
		end 
		
		currentSave.Score[tag][key] = score

	end
end

function getScoreKey(tag,key)
	local score = currentSave.Score[tag]
	
	if(score ~= nil) then
	
	return currentSave.Score[tag][key]
	else
	return 0
	end
	
	
end

function getScore(tag)
	
	return currentSave.Score[tag]
		
	
end




function setVariable(tag,key,score)
	if(type(score) == "string") then
		if(currentSave.Score[tag] == nil) then
		
		currentSave.Variable[tag] = {}
		
		end
		
		currentSave.Variable[tag][key] = score
	end
	
	if(type(score) == "boolean") then
		if(currentSave.Score[tag] == nil) then
		
		currentSave.Variable[tag] = {}
		
		end
		
		currentSave.Variable[tag][key] = tostring(score)
	end
end

function getVariableKey(tag,key)
	local score = currentSave.Variable[tag]
	
	if(score ~= nil) then
	
	return currentSave.Variable[tag][key]
	else
	return ""
	end
	
	
end

function getVariable(tag)
	
	return currentSave.Variable[tag]
		
	
end