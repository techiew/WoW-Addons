
SLASH_AAR1 = "/aar"
SLASH_AAR2 = "/autoacceptres"

-- Handle slash commands
SlashCmdList["AAR"] = function(msg)
		
	if msg == "0" then
		AAR_ENABLED = 0
		print("AutoAcceptRes is now disabled.")
		return
	end
	
	if msg == "1" then
		AAR_ENABLED = 1
		print("AutoAcceptRes is now enabled.")
		return
	end
	
	if msg == "combat 0" then
		AAR_ACCEPT_IN_COMBAT = 0
		print("You won't auto-accept resses while the resurrector is in combat.")
		return
	end
	
	if msg == "combat 1" then
		AAR_ACCEPT_IN_COMBAT = 1
		print("You will auto-accept resses even if the resurrector is in combat.")
		return
	end
	
	if msg == "enabled" then
		print("'enabled' is set to: " .. AAR_ENABLED)
		return
	end
	
	if msg == "combat" then
		print("'combat' is set to: " .. AAR_ACCEPT_IN_COMBAT)
		return
	end

	print("|c002F2F2A---------------------------------------------|r")
	print("|c002F2F2A*|r   |c00FCED33AutoAcceptRes Commands:|r")
	print("|c002F2F2A*|r   |c00FCED33/aar 0|r - Disables the addon.")
	print("|c002F2F2A*|r   |c00FCED33/aar 1|r - Enables the addon.")
	print("|c002F2F2A*|r   |c00FCED33/aar combat 0|r - To not auto-accept resses while the resurrector is in combat.")
	print("|c002F2F2A*|r   |c00FCED33/aar combat 1|r - To auto-accept resses while the resurrector is in combat.")
end

-- Instance-specific items that would be removed by accepting as a ghost
local instanceSpecificItems = {
    23857, -- Legacy of the Mountain King (Karazhan)
    23864, -- Torment of the Worgen (Karazhan)
    23865, -- Wrath of the Titans (Karazhan)
    23862, -- Redemption of the Fallen (Karazhan)
    24494, -- Tears of the Goddess (CoT: Hyjal)
}
local function FindInstanceSpecificItem()
    for _,itemId in ipairs(instanceSpecificItems) do
        if GetItemCount(itemId) > 0 then
            return itemId
        end
    end
end

-- Set up our frame
local frame = CreateFrame("Frame", "AutoAcceptResFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("RESURRECT_REQUEST")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("PLAYER_ALIVE")

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)
			
	if event == "ADDON_LOADED" then
		local arg1 = ...
		
		if arg1 == "AutoAcceptRes" then
			
			if AAR_ENABLED == nil then
				AAR_ENABLED = 1
			end
			
			if AAR_ACCEPT_IN_COMBAT == nil then
				AAR_ACCEPT_IN_COMBAT = 0
			end
					
		end
		
	end
		
	if event == "RESURRECT_REQUEST" then
		local playerName = ...
		
		if AAR_ENABLED ~= 1 then return end
		
		if GetCorpseRecoveryDelay() > 0 then
			print("Could not auto-accept res because you are on resurrect delay.")
			return
		end
        
        if UnitIsGhost("player") then
            local foundItem = FindInstanceSpecificItem()
            if foundItem then
                local _, itemLink = GetItemInfo(foundItem)
                if not itemLink then
                    itemLink = ("[unknown item #%d]"):format(foundItem)
                end
                print(("Did not auto-accept res because you would lose %s upon accepting."):format(itemLink))
                return
            end
        end
          

		if AAR_ACCEPT_IN_COMBAT == 1 then
			AcceptResurrect()
		elseif UnitInParty(playerName) or UnitInRaid(playerName) ~= nil then
		
			if UnitAffectingCombat(playerName) == false then
				AcceptResurrect()
			else
				print("Did not auto-accept res because the resurrector is in combat. Type '/aar combat 1' to ignore this.")
			end
		
		else
			print("Did not auto-accept res because the resser is not in your party. Type '/aar combat 1' to auto-accept resses from anyone.")
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
