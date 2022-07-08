

local currentObjectiveId = 0

local QuestTrackerUI = {}


function QuestTrackerUI.Reset()
	currentObjectiveId = 0
end
	

function QuestTrackerUI.Initialize()
	---@param self QuestTrackerGameController
	Observe('QuestTrackerGameController', 'OnTrackedEntryChanges', function(self)
		QuestManager.UntrackObjective()
		currentObjectiveId = 0
		
	end)
	
	Observe('QuestTrackerGameController', 'UpdateTrackerData', function(self)
		
		QuestTrackerGameController = self
	end)

	---@param self QuestTrackerGameController
	Override('QuestTrackerGameController', 'OnMenuUpdate', function(self, value)
		
		if QuestManager.IsTrackingObjective() then
		
			--print('QuestTrackerGameController', 'CustomTrack')
			-- print('QuestTrackerGameController')
			-- print(currentObjectiveId)
		--	if not QuestManager.IsTrackedObjective(currentObjectiveId) then
				
				local trackedQuestId = QuestManager.GetTrackedQuestId()
				local trackedQuestDef = QuestManager.GetQuest(trackedQuestId)
				local trackedObjectiveId = QuestManager.GetTrackedObjectiveId()
				
				self.root:SetVisible(true)

				inkTextRef.SetText(self.QuestTitle, trackedQuestDef.title)
				inkCompoundRef.RemoveAllChildren(self.ObjectiveContainer)

				for _, objectiveDef in ipairs(trackedQuestDef.objectives) do
					local objectiveState = QuestManager.GetObjectiveState(objectiveDef.id)
						
					if not objectiveState.isComplete and (objectiveState.state == gameJournalEntryState.Active or objectiveState.state == gameJournalEntryState.Failed)then
						local objectiveEntry = QuestManager.GetObjectiveEntry(objectiveDef.id)
						local objectiveWidget = self:SpawnFromLocal(inkWidgetRef.Get(self.ObjectiveContainer), "Objective")

						---@type QuestTrackerObjectiveLogicController
						local objectiveController = objectiveWidget:GetController()
						objectiveController:SetData(objectiveDef.title, objectiveDef.id == trackedObjectiveId, objectiveDef.isOptional, 0, 0, objectiveEntry,true)
						local quest = getQuestByTag(trackedQuestId)
					
						
						if(quest ~= nil and getScoreKey(quest.tag,"Score") <= 3 and currentQuest == nil ) then
							
							--untrackQuest()
							
							startQuest(quest)
						
						end
					end
				end

				currentObjectiveId = trackedObjectiveId
				
			
			
		elseif currentObjectiveId ~= 0 then
				self.root:SetVisible(false)
				currentObjectiveId = 0
				--print("remove")
		else
			self:UpdateTrackerData()
			--print('QuestTrackerGameController2')
		end
	end)
end

return QuestTrackerUI