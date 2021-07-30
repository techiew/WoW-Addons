
SLASH_EMOTESYNC1 = "/esync"
SLASH_EMOTESYNC2 = "/emotesync"

local loaded = false
local esyncPrefix = "EmoteSync"

-- Handle slash commands
SlashCmdList["EMOTESYNC"] = function(msg)
	if not loaded then return end
	
	msg = string.lower(msg)
				
	if msg == "" then
		print("|c002F2F2A---------------------------------------------|r")
		print("|c002F2F2A*|r   |c00FCED33EmoteSync Commands:|r")
		print("|c002F2F2A*|r   |c00FCED33/esync 0|r - Disable the addon.")
		print("|c002F2F2A*|r   |c00FCED33/esync 1|r - Enable the addon.")
		print("|c002F2F2A*|r   |c00FCED33/esync [EMOTE]|r - Replace [EMOTE] with the desired emote, for example: '/esync dance'.")
		print("|c002F2F2A*|r   |c00FCED33/esync msg|r - Disable the login message.")
		return
	end
			
	if msg == "0" then
		ESYNC_ENABLED = 0
		print("EmoteSync is now disabled.")
		return
	end
	
	if msg == "1" then
		ESYNC_ENABLED = 1
		print("EmoteSync is now enabled.")
		return
	end
	
	if msg == "msg" then
	
		if ESYNC_MSG == 0 then
			ESYNC_MSG = 1
			print("The login message will show.")
		else
			ESYNC_MSG = 0
			print("The login message will no longer show.")
		end
		
		return
	end
	
	if msg == "enabled" then
		print("'enabled' is set to: " .. ESYNC_ENABLED)
		return
	end
	
	local chatChannel = "NONE"
	if UnitInParty("player") then chatChannel = "PARTY" end
	if UnitInRaid("player") ~= nil then chatChannel = "RAID" end
	if UnitInBattleground("player") ~= nil and UnitInParty("player") then chatChannel = "PARTY" end

	if chatChannel == "NONE" then 
		print("You need to be in a party/raid to sync emotes!")
		return 
	end
	
	local targetName = UnitName("target")
	if targetName == nil then targetName = "None" end
	
	C_ChatInfo.SendAddonMessage(esyncPrefix, string.upper(msg) .. "-" .. targetName, chatChannel)
end

-- Set up our frame
local frame = CreateFrame("Frame", "EmoteSyncFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_ADDON")

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)
			
	if event == "ADDON_LOADED" then
		local arg1 = ...
		
		if arg1 == "EmoteSync" then
			
			if ESYNC_ENABLED == nil then
				ESYNC_ENABLED = 1
			end
					
			if ESYNC_MSG == nil then
				ESYNC_MSG = 1
			end
			
			if ESYNC_MSG == 1 then
				print("|c002F2F2A*|r   |c00FCED33EmoteSync loaded.|r")
				print("|c002F2F2A*|r   |c00FCED33Type /esync to see commands.|r")
			end
					
			C_ChatInfo.RegisterAddonMessagePrefix(esyncPrefix)
			
			loaded = true
		end
		
	end
	
	if event == "CHAT_MSG_ADDON" then
		local prefix, text = ...
		
		if ESYNC_ENABLED == 0 then return end
		
		if prefix == esyncPrefix then
			local emote, targetName = "None"
			local i, j = string.find(text, '-')
			emote = string.sub(text, 0, j - 1)
			targetName = string.sub(text, j + 1, string.len(text))
	
			DoEmote(emote, targetName)
		end
		
	end
	
end)
