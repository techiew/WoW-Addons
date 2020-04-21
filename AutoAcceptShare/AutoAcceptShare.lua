
SLASH_AAS1 = "/aas"
SLASH_AAS2 = "/autoacceptshare"

-- Handle slash commands
SlashCmdList["AAS"] = function(msg)
	
	if msg == "0" then
		AAS_ENABLED = 0
		print("AutoAcceptShare is now disabled.")
		return
	end
	
	if msg == "1" then
		AAS_ENABLED = 1
		print("AutoAcceptShare is now enabled.")
		return
	end
	
	if msg == "enabled" then
		print("'enabled' is set to: " .. AAS_ENABLED)
		return
	end
	
	print("|c002F2F2A---------------------------------------------|r")
	print("|c002F2F2A*|r   |c00FCED33AutoAcceptShare Commands:|r")
	print("|c002F2F2A*|r   |c00FCED33/aas 0|r - Disables the addon.")
	print("|c002F2F2A*|r   |c00FCED33/aas 1|r - Enables the addon.")
end

local function OnQuestFrameShow(self)
	local questGiverName = QuestFrameNpcNameText:GetText()
	
	if AAS_ENABLED == 0 then return end
	
	if questGiverName == nil then return end
	
	if UnitIsPlayer(questGiverName) == false then return end
	
	if UnitInParty(questGiverName) or UnitInRaid(questGiverName) ~= nil then
		AcceptQuest()
	end
	
end

-- Set up our frame
local frame = CreateFrame("Frame", "AutoAcceptShareFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("QUEST_ACCEPT_CONFIRM")

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)
			
	if event == "ADDON_LOADED" then
		local addon = ...
		
		if addon == "AutoAcceptShare" then
			
			if AAS_ENABLED == nil then
				AAS_ENABLED = 1
			end
				
			QuestFrame:SetScript("OnShow", OnQuestFrameShow)	
		end
		
	end
	
	if event == "QUEST_ACCEPT_CONFIRM" then
		if AAS_ENABLED == 0 then return end
		
		if StaticPopup_Visible("QUEST_ACCEPT") then
			StaticPopup_Hide("QUEST_ACCEPT")
		end
		
		ConfirmAcceptQuest()
	end
			
end)
