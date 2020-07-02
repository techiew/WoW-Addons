
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
	
	if BE_ANNOUNCE_BIGGEST == 0 then return end
	
	local chatChannel = "NONE"
	if UnitInParty("player") then chatChannel = "PARTY" end
	if UnitInRaid("player") ~= nil then chatChannel = "NONE" end
	if UnitInBattleground("player") ~= nil and UnitInParty("player") then chatChannel = "PARTY" end
	
	local versusText = "PVE"
	local critText = " "
	
	if isPVP then versusText = "PVP" end
	if isCrit then critText = " crit " end
	
	if BE_ANNOUNCE_BIGGEST == 1 then
		print(subj("[BiggestExecute] NEW " .. versusText .. " EXECUTE RECORD: ") .. desc(dmg) .. subj(critText .. "damage!"))
		return
	end
	
	if chatChannel == "NONE" then
		print(subj("[BiggestExecute] NEW " .. versusText .. " EXECUTE RECORD: ") .. desc(dmg) .. subj(critText .. "damage!"))
	else
		SendChatMessage("[BiggestExecute] NEW " .. versusText .. " EXECUTE RECORD: " .. dmg .. critText .. "damage!", chatChannel)
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
		print(subj("[BiggestExecute] My biggest execute" .. critText .. "in " .. versusText .. " is ") .. desc(dmg) .. subj(" against ") .. desc(victim) .. subj("."))
	else
		SendChatMessage("[BiggestExecute] My biggest execute" .. critText .. "in " .. versusText .. " is " .. dmg .. " against " .. victim .. ".", chatChannel)
	end
	
end

SLASH_BIGGESTEXECUTE1 = "/big"
SLASH_BIGGESTEXECUTE2 = "/biggestexecute"

-- Handle slash commands
SlashCmdList["BIGGESTEXECUTE"] = function(cmd)
		
	if cmd == "pve" then
		ShowStats(BE_BIGGEST_PVE, BE_BIGGEST_PVE_VICTIM, false, false, false)
		ShowStats(BE_BIGGEST_PVE_CRIT, BE_BIGGEST_PVE_CRIT_VICTIM, true, false, false)
		return
	end
	
	if cmd == "pvp" then
		ShowStats(BE_BIGGEST_PVP, BE_BIGGEST_PVP_VICTIM, false, true, false)
		ShowStats(BE_BIGGEST_PVP_CRIT, BE_BIGGEST_PVP_CRIT_VICTIM, true, true, false)
		return
	end
	
	if cmd == "parse pve" then
		ShowStats(BE_BIGGEST_PVE, BE_BIGGEST_PVE_VICTIM, false, false, true)
		return
	end
	
	if cmd == "parse pve crit" then
		ShowStats(BE_BIGGEST_PVE_CRIT, BE_BIGGEST_PVE_CRIT_VICTIM, true, false, true)
		return
	end
	
	if cmd == "parse pvp" then
		ShowStats(BE_BIGGEST_PVP, BE_BIGGEST_PVP_VICTIM, false, true, true)
		return
	end
	
	if cmd == "parse pvp crit" then
		ShowStats(BE_BIGGEST_PVP_CRIT, BE_BIGGEST_PVP_CRIT_VICTIM, true, true, true)
		return
	end
	
	if cmd == "0" then
		BE_ANNOUNCE_BIGGEST = 0
		print("You will no longer announce execute damage records.")
		return
	end
	
	if cmd == "1" then
		BE_ANNOUNCE_BIGGEST = 1
		print("You will only announce execute damage records to yourself.")
		return
	end
	
	if cmd == "2" then
		BE_ANNOUNCE_BIGGEST = 2
		print("You will announce execute damage records to yourself or party members (does not announce in raids).")
		return
	end
	
	if cmd == "msg" then
	
		if BE_LOGIN_MSG == 0 then
			BE_LOGIN_MSG = 1
			print("Login message enabled.")
		else
			BE_LOGIN_MSG = 0
			print("Login message disabled.")
		end
		
		return
	end
	
	print(line)
	print(pre .. header("BiggestExecute Commands:"))
	print(pre .. subj("/big pve") .. sep .. desc("Show PvE records."))
	print(pre .. subj("/big pvp") .. sep .. desc("Show PvP records."))
	print(pre .. subj("/big parse pve") .. sep .. desc("Parse PvE record to chat. Add 'crit' to parse biggest crit."))
	print(pre .. subj("/big parse pvp") .. sep .. desc("Parse PvP record to chat. Add 'crit' to parse biggest crit."))
	print(pre .. subj("/big 0/1/2") .. sep .. desc("0 = Disable announcing records. 1 = Announce only to yourself. 2 = Announce to your party and to yourself."))
	print(pre .. subj("/big msg") .. sep .. desc("Disables the login message."))
end


-- Set up our frame.
local frame = CreateFrame("Frame", "BiggestExecuteFrame")

local localizedClass, englishClass, classIndex = UnitClass("player");

-- Only bother loading this addon on warrior characters.
if englishClass == "WARRIOR" then
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- Handle events
frame:SetScript("OnEvent", function(self, event, ...)	

	-- Set default values when the addon loads
	if event == "ADDON_LOADED" then
		local arg1 = ...
	
		if arg1 == "BiggestExecute" then
			
			if BE_BIGGEST_PVE == nil then
				BE_BIGGEST_PVE = 0
			end
			
			if BE_BIGGEST_PVE_VICTIM == nil then
				BE_BIGGEST_PVE_VICTIM = "None"
			end
			
			if BE_BIGGEST_PVP == nil then
				BE_BIGGEST_PVP = 0
			end
			
			if BE_BIGGEST_PVP_VICTIM == nil then
				BE_BIGGEST_PVP_VICTIM = "None"
			end
			
			if BE_BIGGEST_PVE_CRIT == nil then
				BE_BIGGEST_PVE_CRIT = 0
			end
			
			if BE_BIGGEST_PVE_CRIT_VICTIM == nil then
				BE_BIGGEST_PVE_CRIT_VICTIM = "None"
			end
			
			if BE_BIGGEST_PVP_CRIT == nil then
				BE_BIGGEST_PVP_CRIT = 0
			end
			
			if BE_BIGGEST_PVP_CRIT_VICTIM == nil then
				BE_BIGGEST_PVP_CRIT_VICTIM = "None"
			end
			
			if BE_ANNOUNCE_BIGGEST == nil then
				BE_ANNOUNCE_BIGGEST = 2
			end
			
			if BE_LOGIN_MSG == nil then
				BE_LOGIN_MSG = 1
			end
			
			if BE_LOGIN_MSG == 1 then
				print(pre .. subj("BiggestExecute loaded."))
				print(pre .. subj("Type /big to see commands."))
			end
			
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
				
		local localName, rank, icon, castTime, 
			minRange, maxRange, spellId = GetSpellInfo(5308)
				
		if spellName ~= localName then return end
		
		if type(spellDamage) == "string" then return end
		
		if UnitIsPlayer("target") then
		
			if critical then
				
				if spellDamage > BE_BIGGEST_PVP_CRIT then
					AnnounceBiggestExecute(spellDamage, true, true)
					BE_BIGGEST_PVP_CRIT = spellDamage
					BE_BIGGEST_PVP_CRIT_VICTIM = UnitName("target")
				end
				
			else
			
				if spellDamage > BE_BIGGEST_PVP then
					AnnounceBiggestExecute(spellDamage, false, true)
					BE_BIGGEST_PVP = spellDamage
					BE_BIGGEST_PVP_VICTIM = UnitName("target")
				end
				
			end
			
		else
		
			if critical then
				
				if spellDamage > BE_BIGGEST_PVE_CRIT then
					AnnounceBiggestExecute(spellDamage, true, false)
					BE_BIGGEST_PVE_CRIT = spellDamage
					BE_BIGGEST_PVE_CRIT_VICTIM = UnitName("target")
				end
				
			else
			
				if spellDamage > BE_BIGGEST_PVE then
					AnnounceBiggestExecute(spellDamage, false, false)
					BE_BIGGEST_PVE = spellDamage
					BE_BIGGEST_PVE_VICTIM = UnitName("target")
				end
				
			end
		
		end
		
	end
		
end)