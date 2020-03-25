
SLASH_ARC1 = "/arc"

local loaded = false

-- Handle slash commands
SlashCmdList["ARC"] = function(msg)
	
	if not loaded then return end
	
	if msg == "" then
		print("* AutoResClassic")
		print("* /arc combat 0 - To not auto-accept resses while resurrector is in combat")
		print("* /arc combat 1 - To auto-accept resses while resurrector is in combat.")
	end
	
	if msg == "combat 0" then
		ARC_ACCEPT_IN_COMBAT = 0
		print("You won't auto-accept resses while the resurrector is in combat.")
	end
	
	if msg == "combat 1" then
		ARC_ACCEPT_IN_COMBAT = 1
		print("You will auto-accept resses even if the resurrector is in combat.")
	end
	
	if msg == "combat" then
		print("combat: " .. ARC_ACCEPT_IN_COMBAT)
	end

end

-- Set up our frame
local frame = CreateFrame("Frame", "AutoResClassicFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("RESURRECT_REQUEST")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("PLAYER_ALIVE")

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)
			
	if event == "ADDON_LOADED" then
		local arg1 = ...
		
		if arg1 == "AutoResClassic" then
			
			if ARC_ACCEPT_IN_COMBAT == nil then
				ARC_ACCEPT_IN_COMBAT = 0
			end
			
			loaded = true
		end
		
	end
		
	if event == "RESURRECT_REQUEST" then
		playerName = ...
		
		if ARC_ACCEPT_IN_COMBAT == 1 then
			AcceptResurrect()
			
		elseif UnitInParty(playerName) or UnitInRaid(playerName) ~= nil then
		
			if UnitAffectingCombat(playerName) == false then
				AcceptResurrect()
			else
				print("Did not auto-accept res because the resurrector is in combat.")
			end
		
		else
			print("Did not auto-accept res because the resurrector is not in your party. Type '/arc combat 1' to auto-accept resses from anyone.")
		end
		
	end
	
	if event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE" then
	
		if StaticPopup_Visible("RESURRECT") then
			StaticPopup_Hide("RESURRECT")
		end
		
		if StaticPopup_Visible("RESURRECT_NO_TIMER") then
			StaticPopup_Hide("RESURRECT_NO_TIMER")
		end
		
		if StaticPopup_Visible("RESURRECT_NO_SICKNESS") then
			StaticPopup_Hide("RESURRECT_NO_SICKNESS")
		end
		
	end
	
end)
