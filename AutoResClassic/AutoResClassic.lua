
SLASH_ARC1 = "/arc"
SLASH_ARC2 = "/autoresclassic"

-- Handle slash commands
SlashCmdList["ARC"] = function(msg)
		
	if msg == "0" then
		ARC_ENABLED = 0
		print("AutoResClassic is now disabled.")
		return
	end
	
	if msg == "1" then
		ARC_ENABLED = 1
		print("AutoResClassic is now enabled.")
		return
	end
	
	if msg == "combat 0" then
		ARC_ACCEPT_IN_COMBAT = 0
		print("You won't auto-accept resses while the resurrector is in combat.")
		return
	end
	
	if msg == "combat 1" then
		ARC_ACCEPT_IN_COMBAT = 1
		print("You will auto-accept resses even if the resurrector is in combat.")
		return
	end
	
	if msg == "enabled" then
		print("'enabled' is set to: " .. ARC_ENABLED)
		return
	end
	
	if msg == "combat" then
		print("'combat' is set to: " .. ARC_ACCEPT_IN_COMBAT)
		return
	end

	print("|c002F2F2A---------------------------------------------|r")
	print("|c002F2F2A*|r   |c00FCED33AutoResClassic Commands:|r")
	print("|c002F2F2A*|r   |c00FCED33/arc 0|r - Disables the addon.")
	print("|c002F2F2A*|r   |c00FCED33/arc 1|r - Enables the addon.")
	print("|c002F2F2A*|r   |c00FCED33/arc combat 0|r - To not auto-accept resses while the resurrector is in combat.")
	print("|c002F2F2A*|r   |c00FCED33/arc combat 1|r - To auto-accept resses while the resurrector is in combat.")
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
			
			if ARC_ENABLED == nil then
				ARC_ENABLED = 1
			end
			
			if ARC_ACCEPT_IN_COMBAT == nil then
				ARC_ACCEPT_IN_COMBAT = 0
			end
					
		end
		
	end
		
	if event == "RESURRECT_REQUEST" then
		playerName = ...
		
		if ARC_ENABLED ~= 1 then return end
		
		if ARC_ACCEPT_IN_COMBAT == 1 then
			AcceptResurrect()
		elseif UnitInParty(playerName) or UnitInRaid(playerName) ~= nil then
		
			if UnitAffectingCombat(playerName) == false then
				AcceptResurrect()
			else
				print("Did not auto-accept res because the resurrector is in combat.")
			end
		
		else
			print("Did not auto-accept res because the resser is not in your party. Type '/arc combat 1' to auto-accept resses from anyone.")
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
