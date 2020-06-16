
function SpecializationList(skillName)
	local specializationList = {};
	local skillNode, specNode;
		
	for k, module in ipairs(Module.getModules()) do
		skillNode = DB.findNode("reference.skills.list@" .. module);
		if skillNode then
			for k, skill in pairs(skillNode.getChildren()) do
				if skill.getChild("name").getValue() == skillName then
					if skill.getChild("specializationlist") then
						for l, specialization in pairs(skill.getChild("specializationlist").getChildren()) do
							table.insert(specializationList, specialization.getChild("name").getValue());
						end
					end
				end
			end
		end
	end

	return specializationList;
end

function RankBonus(rank)
		-- HARP has only standard progression
		if rank < 1 then
			return -25;
		elseif rank < 11 then 
			return 5 * rank; 	
		elseif rank < 21 then
			return 2 * (rank - 10) + 50;
		else
			return (rank - 20) + 70;
		end
end

-- Roll and Drag
function Roll(skillType, nodepath)
	-- only allow rolls for static and moving maneuvers
		local customData = Rules_CustomData.Skill(nodepath);
		local node = DB.findNode(nodepath);
		local gmonly = 0;
		if node then
			if node.getChild("gmonlyskill") then
				gmonly = node.getChild("gmonlyskill").getValue();
			end
		end
		-- invoke the maneuver roll
		local getType = "Hotkey:SkillRoll";
		if customData then
			if gmonly == 1 then
			    customData.revealDice = false;
				if customData.modifiers then
					stringMods = StringManager.convertModifiersToString(customData.modifiers);
				end
				print("Sending to the Tower: " .. stringMods);
				local dicestr = StringManager.convertDiceToString({"d100","d10"});
				--local dicester = "0d10+1d100"
				--ChatManager.sendSpecialMessage(ChatManager.SPECIAL_MSGTYPE_DICETOWER, {getType, node.getChild("name").getValue(), dicestr, customData.dieType, customData.tableID, nodepath, stringMods});
				
			end
			ChatManager.throwDice("dice",{"d100","d10"},0,"",customData);
		end
end

function Drag(draginfo, skillType, skill, nodepath)
	-- only allow rolls for static and moving maneuvers
		draginfo.setDescription(skill);
		-- the hotkey info
		draginfo.setType("Hotkey:SkillRoll");
		draginfo.setStringData(nodepath);
		draginfo.setDieList({"d100","d10"});
	return true;
end



