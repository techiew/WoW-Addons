
local loaded = false

-- These variables and functions are used for print formatting.
local line = "|c002F2F2A---------------------------------------------|r"
local pre = "|c002F2F2A*|r   "
local sep = " |c00FFFFFF-|r "

local function header(text)
	return "|c00D11717" .. text .. "|r"
end

local function subj(text)
	return "|c00D11717" .. text .. "|r"
end

local function desc(text)
	return "|c00FFFFFF" .. text .. "|r"
end
--

local function AnnounceBiggestExecute(dmg, isCrit, isPVP)
	
	if ANNOUNCE_BIGGEST == 0 then return end
	
	local chatChannel = "NONE"
	if UnitInParty("player") then chatChannel = "PARTY" end
	if UnitInRaid("player") ~= nil then chatChannel = "NONE" end
	if UnitInBattleground("player") ~= nil and UnitInParty("player") then chatChannel = "PARTY" end
	
	local versusText = "PVE"
	local critText = " "
	
	if isPVP then versusText = "PVP" end
	if isCrit then critText = " crit " end
	
	if ANNOUNCE_BIGGEST == 1 then
		print(subj("NEW " .. versusText .. " EXECUTE RECORD: ") .. desc(dmg) .. subj(critText .. "damage!"))
		return
	end
	
	if chatChannel == "NONE" then
		print(subj("NEW " .. versusText .. " EXECUTE RECORD: ") .. desc(dmg) .. subj(critText .. "damage!"))
	else
		SendChatMessage("NEW " .. versusText .. " EXECUTE RECORD: " .. dmg .. critText .. "damage!", chatChannel)
	end
	
end

local function ShowStats(dmg, victim, isCrit, isPVP, doParse)
	local chatChannel = "NONE"
	if UnitInParty("player") then chatChannel = "PARTY" end
	if UnitInRaid("player") ~= nil then chatChannel = "RAID" end
	if UnitInBattleground("player") ~= nil and UnitInParty("player") then chatChannel = "PARTY" end
	
	if chatChannel == "NONE" and doParse == true then 
		print("You're not in a party or raid.")
		return
	end
	
	local versusText = "PvE"
	local critText = " "
	
	if isPVP then versusText = "PvP" end
	if isCrit then critText = " crit " end
	
	if chatChannel == "NONE" or doParse == false then
		print(subj("My biggest execute" .. critText .. "in " .. versusText .. " is ") .. desc(dmg) .. subj(" against ") .. desc(victim) .. subj("."))
	else
		SendChatMessage("[BiggestExecute] My biggest execute" .. critText .. "in " .. versusText .. " is " .. dmg .. " against " .. victim .. ".", chatChannel)
	end
	
end

SLASH_BIGGESTEXECUTE1 = "/big"

-- Handle slash commands
SlashCmdList["BIGGESTEXECUTE"] = function(cmd)

	if not loaded then return end
	
	if cmd == "" then
		print(line)
		print(pre .. header("BiggestExecute Commands"))
		print(pre .. subj("/big pve") .. sep .. desc("Show PvE records."))
		print(pre .. subj("/big pvp") .. sep .. desc("Show PvP records."))
		print(pre .. subj("/big parse pve") .. sep .. desc("Parse PvE record to chat. Add 'crit' to parse biggest crit."))
		print(pre .. subj("/big parse pvp") .. sep .. desc("Parse PvP record to chat. Add 'crit' to parse biggest crit."))
		print(pre .. subj("/big 0/1/2") .. sep .. desc("0 = Disable announcing records. 1 = Announce only to yourself. 2 = Announce to your party/raid or to yourself."))
		print(pre .. subj("/big msg") .. sep .. desc("Disables the login message."))
	end
	
	if cmd == "pve" then
		ShowStats(BIGGEST_PVE, BIGGEST_PVE_VICTIM, false, false, false)
		ShowStats(BIGGEST_PVE_CRIT, BIGGEST_PVE_CRIT_VICTIM, true, false, false)
	end
	
	if cmd == "pvp" then
		ShowStats(BIGGEST_PVP, BIGGEST_PVP_VICTIM, false, true, false)
		ShowStats(BIGGEST_PVP_CRIT, BIGGEST_PVP_CRIT_VICTIM, true, true, false)
	end
	
	if cmd == "parse pve" then
		ShowStats(BIGGEST_PVE, BIGGEST_PVE_VICTIM, false, false, true)
	end
	
	if cmd == "parse pve crit" then
		ShowStats(BIGGEST_PVE_CRIT, BIGGEST_PVE_CRIT_VICTIM, true, false, true)
	end
	
	if cmd == "parse pvp" then
		ShowStats(BIGGEST_PVP, BIGGEST_PVP_VICTIM, false, true, true)
	end
	
	if cmd == "parse pvp crit" then
		ShowStats(BIGGEST_PVP_CRIT, BIGGEST_PVP_CRIT_VICTIM, true, true, true)
	end
	
	if cmd == "0" then
		ANNOUNCE_BIGGEST = 0
		print("You will no longer announce execute damage records.")
	end
	
	if cmd == "1" then
		ANNOUNCE_BIGGEST = 1
		print("You will only announce execute damage records to yourself.")
	end
	
	if cmd == "2" then
		ANNOUNCE_BIGGEST = 2
		print("You will announce execute damage records to yourself or party members (does not announce in raids).")
	end
	
	if cmd == "msg" then
	
		if LOGIN_MSG == 0 then
			LOGIN_MSG = 1
			print("Login message enabled.")
		else
			LOGIN_MSG = 0
			print("Login message disabled.")
		end
		
	end
	
end


-- Set up our frame.
local frame = CreateFrame("Frame", "BiggestExecuteFrame")

-- Only bother loading this addon on warrior characters.
if UnitClass("player") == "Warrior" then
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)	

	-- Set default values when the addon loads
	if event == "ADDON_LOADED" then
		local arg1 = ...
	
		if arg1 == "BiggestExecute" then
			
			if BIGGEST_PVE == nil then
				BIGGEST_PVE = 0
			end
			
			if BIGGEST_PVE_VICTIM == nil then
				BIGGEST_PVE_VICTIM = "None"
			end
			
			if BIGGEST_PVP == nil then
				BIGGEST_PVP = 0
			end
			
			if BIGGEST_PVP_VICTIM == nil then
				BIGGEST_PVP_VICTIM = "None"
			end
			
			if BIGGEST_PVE_CRIT == nil then
				BIGGEST_PVE_CRIT = 0
			end
			
			if BIGGEST_PVE_CRIT_VICTIM == nil then
				BIGGEST_PVE_CRIT_VICTIM = "None"
			end
			
			if BIGGEST_PVP_CRIT == nil then
				BIGGEST_PVP_CRIT = 0
			end
			
			if BIGGEST_PVP_CRIT_VICTIM == nil then
				BIGGEST_PVP_CRIT_VICTIM = "None"
			end
			
			if ANNOUNCE_BIGGEST == nil then
				ANNOUNCE_BIGGEST = 2
			end
			
			if LOGIN_MSG == nil then
				LOGIN_MSG = 1
			end
			
			if LOGIN_MSG == 1 then
				print(pre .. subj("BiggestExecute loaded."))
				print(pre .. subj("Type /big to see commands."))
			end
			
			loaded = true
		end
		
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local arg1, combatEvent, arg3, arg4, 
			sourceName, arg6, arg7, arg8, 
			arg9, arg10, arg11, arg12, 
			spellName, arg14, spellDamage, arg16,
			arg17, arg18, arg19, arg20, 
			critical = CombatLogGetCurrentEventInfo()
				
		if sourceName ~= UnitName("player") then return end
				
		if spellName ~= "Execute" then return end
		
		if type(spellDamage) == "string" then return end
		
		if UnitIsPlayer("target") then
		
			if critical then
				
				if spellDamage > BIGGEST_PVP_CRIT then
					AnnounceBiggestExecute(spellDamage, true, true)
					BIGGEST_PVP_CRIT = spellDamage
					BIGGEST_PVP_CRIT_VICTIM = UnitName("target")
				end
				
			else
			
				if spellDamage > BIGGEST_PVP then
					AnnounceBiggestExecute(spellDamage, false, true)
					BIGGEST_PVP = spellDamage
					BIGGEST_PVP_VICTIM = UnitName("target")
				end
				
			end
			
		else
		
			if critical then
				
				if spellDamage > BIGGEST_PVE_CRIT then
					AnnounceBiggestExecute(spellDamage, true, false)
					BIGGEST_PVE_CRIT = spellDamage
					BIGGEST_PVE_CRIT_VICTIM = UnitName("target")
				end
				
			else
			
				if spellDamage > BIGGEST_PVE then
					AnnounceBiggestExecute(spellDamage, false, false)
					BIGGEST_PVE = spellDamage
					BIGGEST_PVE_VICTIM = UnitName("target")
				end
				
			end
		
		end
		
	end
		
end)