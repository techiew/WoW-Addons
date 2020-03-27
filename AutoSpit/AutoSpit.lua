
SLASH_AUTOSPIT1 = "/autospit"

local loaded = false

-- Handle slash commands
SlashCmdList["AUTOSPIT"] = function(msg)
	
	if not loaded then return end
	
	if msg == "" then
		print("Number of people spat on: " .. NUM_PEOPLE_SPAT_ON)
	end
	
end

-- Set up our frame
local frame = CreateFrame("Frame", "AutoSpitFrame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("ADDON_LOADED")

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)	

	if event == "ADDON_LOADED" then
		local arg1 = ...
		
		if arg1 == "AutoSpit" then
		
			if NUM_PEOPLE_SPAT_ON == nil then
				NUM_PEOPLE_SPAT_ON = 0
			end
			
			loaded = true
		end

	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local arg1, combatEvent, arg3, arg4, 
			arg5, arg6, arg7, arg8, destName, 
			destFlags = CombatLogGetCurrentEventInfo()
		
		if combatEvent ~= "UNIT_DIED" then return end
			
		if type(destName) ~= "string" then return end
			
		-- We need to use the destFlags bit field to get information about the player who died,
		-- because the "Unit" commands (UnitName, UnitIsPlayer, etc.) provided by Blizzard will
		-- simply not work on enemy players (or players not in our raid/party) unless they are 
		-- specifically targeted by us and we use for example UnitName("target") or likewise.
		-- Source: https://books.google.no/books?id=rAmNCqpmunIC&pg=PA254&lpg=PA254&dq=wow+api+combatlog_object&source=bl&ots=e0s4eMaIUx&sig=ACfU3U1-sRDUYMBRAbB7ndGr2YCoF2gQ7A&hl=en&sa=X&ved=2ahUKEwjrk7H7zrHoAhWWHHcKHdn6AygQ6AEwAHoECAoQAQ#v=onepage&q=wow%20api%20combatlog_object&f=false
		-- In case the link doesn't work, the link links to page 254 in the book:
		-- "Beginning Lua with World of Warcraft Add-ons" by Paul Emmerich in the "Unit Flags" section.
		if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= COMBATLOG_OBJECT_TYPE_PLAYER then return end
		
		if bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= COMBATLOG_OBJECT_REACTION_HOSTILE then return end
		
		local name = "None"
		local i, j = string.find(destName, '-')
		
		if i == nil then 
			name = destName
		else
			name = string.sub(destName, 0, j - 1)
		end

		DoEmote("SPIT", name)
		NUM_PEOPLE_SPAT_ON = NUM_PEOPLE_SPAT_ON + 1
	end
	
end)