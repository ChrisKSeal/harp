
-- Get Stat List
function List()
	local statList = {};
	
	--[[ Development Stats ]]
	--[[ Other Stats ]]
	table.insert(statList, {name = "constitution", label = "Co", order = 1});
	table.insert(statList, {name = "agility", label = "Ag", order = 2});
	table.insert(statList, {name = "selfdiscipline", label = "Sd", order = 3});
	table.insert(statList, {name = "reasoning", label = "Re", order = 4});
	table.insert(statList, {name = "strength", label = "St", order = 5});
	table.insert(statList, {name = "quickness", label = "Qu", order = 6});
	table.insert(statList, {name = "presence", label = "Pr", order = 7});
	table.insert(statList, {name = "insight", label = "In", order = 8});

	return statList;
end

-- Roll and Drag
function Roll(nodepath)
	local customData = Rules_CustomData.Stat(nodepath);
	if customData then
		ChatManager.throwDice("dice", {"d100","d10"}, 0, "", customData);
	end
end

function Drag(dragData, stat, nodepath)
	dragData.setDescription(stat .. " Roll");
	dragData.setType("Hotkey:StatRoll");
	dragData.setStringData(nodepath); 
	dragData.setDieList({"d100","d10"});
	return true;
end

--[[ parse a statlist like Ag/Ag/St and return the list ]]
function split(s,sep)
  local result = {};
  local i,j = string.find(s,sep,1,true);
  if s=="" then
    return result;
  end
  while i do
    table.insert(result,string.sub(s,1,i-1));
    s = string.sub(s,j+1);
    i,j = string.find(s,sep,1,true);
  end
  table.insert(result,s);
  return result;
end

function StatList(stats)
	local newStatList = {};
	local statList = split(stats, "/");
	for i,stat in ipairs(statList) do
		statEntry = StatEntryFromAbbr(stat);
		if statEntry then
			table.insert(newStatList, statEntry);
		end  
	end
	return newStatList;
end

function StatEntryFromAbbr(stat)
	local statEntry = {};
	stat = string.lower(stat);
	
	if stat == "ag" then
		statEntry = {name = "Agility", nodename = "agility", abbr = "Ag" };
	elseif stat == "co" then
		statEntry = {name = "Constitution", nodename = "constitution", abbr = "Co" };
	elseif stat == "in" then
		statEntry = {name = "Insight", nodename = "insight", abbr = "In" };
	elseif stat == "pr" then
		statEntry = {name = "Presence", nodename = "presence", abbr = "Pr" };
	elseif stat == "qu" then
		statEntry = {name = "Quickness", nodename = "quickness", abbr = "Qu" };
	elseif stat == "re" then
		statEntry = {name = "Reasoning", nodename = "reasoning", abbr = "Re" };
	elseif stat == "sd" then
		statEntry = {name = "Self Discipline", nodename = "selfdiscipline", abbr = "Sd" };
	elseif stat == "st" then
		statEntry = {name = "Strength", nodename = "strength", abbr = "St" };
	else
		statEntry = nil;
	end

	return statEntry;
end

-- Stat Bonuses
function Bonus(val)
	if val >= 105 then
		return 15;
	elseif val >= 104 then
		return 14;
	elseif val >= 103 then
		return 13;
	elseif val >= 102 then
		return 12;
	elseif val >= 101 then
		return 11;
	elseif val >= 96 then
		return 10;
	elseif val >= 91 then
		return 9;
	elseif val >= 86 then
		return 8;
	elseif val >= 81 then
		return 7;
	elseif val >= 76 then
		return 6;
	elseif val >= 71 then
		return 5;
	elseif val >= 66 then
		return 4;
	elseif val >= 61 then
		return 3;
	elseif val >= 56 then
		return 2;
	elseif val >= 51 then
		return 1;
	elseif val >= 46 then
		return 0;
	elseif val >= 41 then
		return -2;
	elseif val >= 36 then
		return -4;
	elseif val >= 31 then
		return -6;
	elseif val >= 26 then
		return -8;
	elseif val >= 21 then
		return -10;
	elseif val >= 16 then
		return -12;
	elseif val >= 11 then
		return -14;
	elseif val >= 6 then
		return -16;
	else
		return -18;
	end
end