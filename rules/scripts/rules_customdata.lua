function Prepare(draginfo)
    local nodepath = draginfo.getStringData();
    -- clear the string data (it will be used to hold the roll narrative in the chat window)
    draginfo.setStringData("");

	if draginfo.isType("Hotkey:SkillRoll") then
		custData = Skill(nodepath);
	elseif draginfo.isType("Hotkey:NPCSkillRoll") then
		custData = NPCSkill(nodepath);
	elseif draginfo.isType("Hotkey:StatRoll") then
		custData = Stat(nodepath);
	elseif draginfo.isType("Hotkey:StatGainRoll") then
		custData = StatGain(nodepath);
	elseif draginfo.isType("Hotkey:StatGenWithMinRoll") then
		custData = StatGenWithMin(nodepath);
	elseif draginfo.isType("Hotkey:StatGenNoMinRoll") then
		custData = StatGenNoMin(nodepath);
	elseif draginfo.isType("Hotkey:RR") then
		custData = ResistanceRoll(nodepath);
	elseif draginfo.isType("Hotkey:SCR") then
		custData = SpellCastingRoll(nodepath);
	elseif draginfo.isType("dice") then
		custData = draginfo.getCustomData();
	else
		return;
	end

    draginfo.setCustomData(custData);
	return draginfo, custData;
end

function DiceLanded(customData, dielist)
	local nodeName = customData.nodeName;
	local node = DB.findNode(nodeName);
	local dieTotal = 0;
	for i,v in ipairs(dielist) do
		dieTotal = dieTotal + v.result;
	end
	if customData.diceLanded == "StatGainRoll" then
		if node then
			node.getChild("statgainroll").setValue(dieTotal);
		end
	end
	if customData.diceLanded == "StatGenWithMinRoll" then
		if node then
			local minRoll;
			if Preferences.CharAssistMinStatGenRollPref then
				minRoll = PreferenceManager.load(Preferences.CharAssistMinStatGenRollPref);
				if not minRoll then
					minRoll = 20;
				end
			end
			if dieTotal < minRoll then
				local customData = StatGenWithMin(node.getNodeName(), dieTotal, minRoll);
				if customData then
					ChatManager.throwDice("dice", {"d100","d10"}, 0, "", customData);
				end
			else
				node.setValue(dieTotal);
			end
		end
	end
	if customData.diceLanded == "StatGenNoMinRoll" then
		if node then
			node.setValue(dieTotal);
		end
	end
	return customData.name;
end

--[[ ###################
--
-- The Skill() function creates a customData object with the following format
-- 
--  { dieType = Rules_Constants.DieType.OpenEnded,
--    actorName = "Toadwart",
--    actorNodeName = "charsheet.id-00004",
--    modifiers =
--    { 1 = {description = "Skill bonus", value = 55},
--      2 = {description = "Armor penalty", value = -40},
--      3 = {description = "Wounded more than 25%", value = -10}
--    },
--    name = "Horse Riding",
--    revealDice = true,
--    tableType = Rules_Constants.TableType.Other,
--    tableID = Rules_Constants.ManeuverTableDefaultTableId,
--    type = Rules_Constants.DataType.DieRoll
--  }
--]]
function Skill(skillNodePath, actorNode, skillName, skillType)
	local node;
	local customData = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};
	local factor = 0;
	local mmpen = 0;

	if skillNodePath then
		node = DB.findNode(skillNodePath);
	end
	
	if not node and not actorNode then
		return customData;
	end

	-- skill type
	if not skillType then
		skillType = node.createChild("type","number").getValue();
	end
	
	--if skillType ~= Rules_Constants.SkillType.Skill and skillType ~= Rules_Constants.SkillType.Spell then
	--	return customData;
	--end
	
	-- character node and name
	if not actorNode then
		actorNode = node.getParent().getParent();
	end
	customData.actorNodeName = actorNode.getNodeName();
	customData.actorName = actorNode.createChild("name","string").getValue();

	-- table id
	customData.tableID = "SkillTab"; -- General Maneuver Table 
	
	customData.revealDice = Utilities.getRevealDice();
	customData.dieType = Rules_Constants.DieType.HighOpenEnded;
	
	if not skillName and node then
		skillName = node.createChild("name","string").getValue();
		local skillSpecialization = node.createChild("specialization","string").getValue();
		if skillSpecialization and string.len(skillSpecialization) > 0 then
			skillName = skillName .. " [" .. skillSpecialization .. "]";
		end
	end
	customData.name = skillName;

	-- modifiers
	Rules_Modifiers.SkillBonus(customData.modifiers, node);
	Rules_Modifiers.SkillManeuver(customData.modifiers, node, actorNode);
	Rules_Modifiers.Effects(customData.modifiers, actorNode, skillName);

	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);
	
	-- done
	return customData;
end

--[[ ###################
--
-- The NPCSkill() function creates a customData object with the following format
-- 
--  { dieType = Rules_Constants.DieType.OpenEnded,
--    actorName = "Toadwart",
--    actorNodeName = "charsheet.id-00004",
--    modifiers =
--    { 1 = {description = "Skill bonus", value = 55},
--      2 = {description = "Armor penalty", value = -40},
--      3 = {description = "Wounded more than 25%", value = -10}
--    },
--    name = "Horse Riding",
--    revealDice = true,
--    tableType = Rules_Constants.TableType.Other,
--    tableID = Rules_Constants.ManeuverTableDefaultTableId,
--    type = Rules_Constants.DataType.DieRoll
--  }
--]]
function NPCSkill(skillNodePath)
	local node;
	local customData = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};
	local factor = 0;
	local mmpen = 0;

	if skillNodePath then
		node = DB.findNode(skillNodePath);
	end

	if not node then
		return customData;
	end

	-- character node and name
	actorNode = node.getParent().getParent();
	customData.actorNodeName = actorNode.getNodeName();
	customData.actorName = actorNode.createChild("name","string").getValue();

	-- determine skill type to see if the Movement Manuever table should be used
	local class, refNodeName = node.getChild("open").getValue();
	if refNodeName and refNodeName ~= "" then
		refSkillNode = DB.findNode(refNodeName);
		if refSkillNode then			
			skillType = refSkillNode.getChild("type").getValue();
		end
	end
	if skillType == Rules_Constants.SkillType.MoveManeuver then
		customData.tableID = Rules_Constants.ManeuverTableDefaultTableId;
	else
		customData.tableID = ""; -- no table lookup for static maneuvers
	end
	
	customData.revealDice = Utilities.getRevealDice();
	customData.dieType = Rules_Constants.DieType.OpenEnded;
	
	skillName = node.createChild("name","string").getValue();
	customData.name = skillName;

	-- modifiers
	Rules_Modifiers.NPCSkillBonus(customData.modifiers, node);
	Rules_Modifiers.Hits(customData.modifiers, actorNode, skillName);
	Rules_Modifiers.Fatigue(customData.modifiers, actorNode);
	Rules_Modifiers.Effects(customData.modifiers, actorNode, skillName);

	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);
	
	-- done
	return customData;
end

--[[ ###################
--
-- The Stat() function creates a customData object with the following format
-- 
--  { dieType = Rules_Constants.DieType.OpenEnded,
--    actorName = "Toadwart",
--    actorNodeName = "charsheet.id-00004",
--    modifiers =
--    { 1 = {description = "St bonus", value = 20},
--    },
--    name = "St Roll",
--    revealDice = true,
--    tableType = Rules_Constants.TableType.Other,
--    tableID = "",
--    type = Rules_Constants.DataType.DieRoll
--  }
--]]
function Stat(nodepath)
	local node = DB.findNode(nodepath);
	local customData = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};
	local actorNode;
	
	if not node then
		return customData;
	end
	actorNode = node.getParent().getParent();
	
	-- hide or reveal dice?
	customData.revealDice = Utilities.getRevealDice();
	
	-- character node and name
	customData.actorNodeName = actorNode.getNodeName();
	customData.actorName = actorNode.getChild("name").getValue();
	
	-- actual values
	customData.tableID = "";
	customData.dieType = Rules_Constants.DieType.OpenEnded;
	customData.name = node.getChild("label").getValue() .. " Roll";
	
	-- standard modifiers
	Rules_Modifiers.StatModifier(customData.modifiers, node);

	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);
	-- done
	return customData;
end


--[[ ###################
--
-- The ResistanceRoll() function creates a customData object with the following format
-- 
--  { dieType = Rules_Constants.DieType.OpenEnded,
--    actorName = "Toadwart",
--    actorNodeName = "charsheet.id-00004",
--    modifiers =
--    { 1 = {description = "RR bonus", value = 20},
--    },
--    name = "Essence RR",
--    revealDice = true,
--    tableType = Rules_Constants.TableType.Other,
--    tableID = Rules_Constants.RRTableID,
--    type = Rules_Constants.DataType.DieRoll
--  }
--]]
function ResistanceRoll(nodepath)
	local node = DB.findNode(nodepath);
	local customData = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};
	local actorNode;
	
	if not node then
		return customData;
	end
	
	actorNode = node.getParent().getParent();
	
	-- hide or reveal dice?
	customData.revealDice = Utilities.getRevealDice();
	
	-- character node and name
	customData.actorNodeName = actorNode.getNodeName();
	customData.actorName = actorNode.getChild("name").getValue();
	
	-- table id
	customData.tableID = ""; --Rules_Constants.RRTableID;
	
	-- actual values
	customData.dieType = Rules_Constants.DieType.OpenEnded;
	customData.name = node.getChild("label").getValue() .. " RR";
	
	-- modifiers
	Rules_Modifiers.RRModifier(customData.modifiers, node);
	
	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);
	-- done
	print(customData.tableType);
	return customData;
end


--[[ ###################
--
-- The SpellCastingRoll() function creates a customData object with the following format
-- 
--  { dieType = Rules_Constants.DieType.OpenEnded,
--    actorName = "Toadwart",
--    actorNodeName = "charsheet.id-00004",
--    modifiers =
--    { 1 = {description = "St bonus", value = 20},
--    },
--    name = "St Roll",
--    revealDice = true,
--    tableType = Rules_Constants.TableType.Other,
--    tableID = "",
--    type = Rules_Constants.DataType.DieRoll
--  }
--]]
function BaseSpellCastingRoll(nodepath, tableid, size, rollType)
	local node = DB.findNode(nodepath);
	local customData = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};
	local actorNode;
	if not node then
		return customData;
	end
	
	actorNode = node.getParent();
	
	-- hide or reveal dice?
	customData.revealDice = Utilities.getRevealDice();

	-- character node and name
	customData.actorNodeName = actorNode.getNodeName();
	customData.actorName = actorNode.getChild("name").getValue();
	-- actual values
	customData.tableID = tableid;
	customData.size = size;
	customData.rollType = rollType;
	customData.dieType = Rules_Constants.DieType.HighOpenEnded;
	customData.name = "Spell Casting Roll";
	-- modifiers
	Rules_Modifiers.BaseSpellCasting(customData.modifiers, actorNode);
  
	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);
	-- done
	return customData;
end


function Attack(node, targetID)
	local target = DB.findNode(targetID);
	local attackerNode = node.getParent().getParent();
	local customData = {type=Rules_Constants.DataType.DieRoll};
	local armorType;
	local atBonus = 0;
	local isMissile = false;
	local weaponType;
	local damage;
	local attacksize = 5;
	
	customData.modifiers = {};
	customData.tableType = Rules_Constants.TableType.Attack;
	-- unable to attack if there is no target
	if targetID=="" or not target then
		-- send a message to the chat box
		ChatManager.addMessage({font="systemfont",text="No target selected"});
		return nil;
	end

	customData.maxResultLevel = node.createChild("max_level","number").getValue();
  
	-- hide or reveal dice?
	customData.revealDice = Utilities.getRevealDice();
	-- protagonists
	customData.attackerName = attackerNode.getChild("label").getValue();
	customData.attackerNodeName = attackerNode.getNodeName();
	if target and targetID ~= "" then
		customData.defenderName = target.getChild("label").getValue();
		customData.defenderNodeName = target.getNodeName();
	
	end
	customData.fumbleValue = node.createChild("fumble","number").getValue();
	customData.name = node.createChild("name","string").getValue();
	customData.size = node.createChild("size","number").getValue();
	customData.name = customData.name .. " vs " .. customData.defenderName;

	if node.getChild("attacktable") then
		if node.getChild("attacktable").getChild("tableid") then
			customData.tableID = node.getChild("attacktable").getChild("tableid").getValue();
		else
			customData.tableID = "";
		end
	else
		customData.tableID = "";	
	end

	if customData.tableID=="" then
		-- send a message to the chat box
		ChatManager.addMessage({font="systemfont",text="Attack table missing"});
		return nil;
	end
	if customData.tableID == Rules_Constants.BaseSpellAttackTableID then
		customData.dieType = Rules_Constants.DieType.Closed;
	else
		customData.dieType = Rules_Constants.DieType.HighOpenEnded;
	end

	-- track activity type
	weaponType = node.createChild("wpnclass","number").getValue();
	if weaponType > 4 then
		local range = node.createChild("rng","number").getValue();
		local rangeinc = node.createChild("rnginc","number").getValue();
		local pbrange = node.createChild("pbrange","number").getValue();
		local pbbonus = node.createChild("pbbonus","number").getValue();
		if range < 0 then
			range = 0;
		end
		if range == 0 then
			table.insert(customData.modifiers, {description="Ranged weapon in melee", value=-100});
		elseif range <= pbrange then
			table.insert(customData.modifiers, {description="Point blank range", value=pbbonus});
		else
			local increments = math.ceil(range/rangeinc);
			local penalty = 0;
			if increments < 7 then
				penalty = (increments-1)*-10;
			else
				penalty = (2^(increments-6)) * -50;
			end
			table.insert(customData.modifiers, {description="Range modifier", value=penalty});
		end
	end
	
  
	-- modifiers
	Rules_Modifiers.AttackBonus(customData.modifiers, node);
	if customData.tableID ~= Rules_Constants.BaseSpellAttackTableID then
		if target and targetID ~= "" then
			Rules_Modifiers.TargetDefense(customData.modifiers, attackerNode, target, isMissile);
			Rules_Modifiers.TargetStunned(customData.modifiers, target);
		end
	end
	Rules_Modifiers.Effects(customData.modifiers, attackerNode);
	
	-- add items in the modifier stack
	Utilities.AddModifierStack(customData.modifiers);

	-- set actor node for PC-generated events
	if attackerNode.getChild("type").getValue() == "pc" then
		local actorClass, actorNodeName = attackerNode.getChild("link").getValue();
		customData.actorNodeName = actorNodeName;
		customData.actorName = attackerName;
		local actorNode = DB.findNode(actorNodeName);
	end
	
	customData.attackDBNodeName = "";
	customData.attackDBNodeClass = "";
	if node.getChild("open") then
		local classname, nodeid = node.getChild("open").getValue();
		local attackNode = DB.findNode(nodeid);
		if attackNode then
			customData.attackDBNodeName = attackNode.getNodeName();
			customData.attackDBNodeClass = classname;                 -- class is "weapon", "spell" or "item"
		end
	end

	-- adjust for alternate criticals 
 	local critTableType = node.createChild("primaryCrit","string").getValue();
	local critTableID = nil;
	local critTableName = nil;
	local altCritMod = 0;
	if critTableType == "Alt Crit" then
		if node.getChild("altcrit.tableid") and node.getChild("altcrit.name") and node.getChild("altcritmod") then
			critTableID = node.getChild("altcrit.tableid").getValue();
			critTableName = node.getChild("altcrit.name").getValue();
			altCritMod = node.getChild("altcritmod").getValue();
		end
	end
	if critTableID and critTableName then
		customData.critTableID = critTableID;
		customData.critTableName = critTableName;
		table.insert(customData.modifiers, {description="Alternate Crit Mod", value=altCritMod});
	end
	return customData;
end
