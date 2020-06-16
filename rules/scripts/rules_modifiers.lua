function BaseSpellCasting(modifiers, actorNode)
	local castnode = nil;
	local tmp = 0.
	if actorNode.getChild("current_attack") then
		castnode = actorNode.getChild("current_attack");
		tmp = castnode.createChild("skill_bonus").getValue();
		table.insert(modifiers, {description="Skill Bonus", value=tmp});
		tmp = castnode.createChild("total_cost").getValue() - castnode.createChild("base_cost").getValue();
		if tmp > 0 then
			table.insert(modifiers, {description="Extra PPs", value=-5*tmp});
		end
		tmp = Rules_Spells.calcSpeedPen(castnode.createChild("cast_time").getValue(),castnode.createChild("rec_time").getValue());
		table.insert(modifiers, {description="Casting Time", value=tmp});
	end
end

function Effects(modifiers, actorNode, skillName)
	local ctNode = CTManager.getCombatantCTNode(actorNode);

	if ctNode then
		local stunRounds = 0;
		local bleedingAmount = 0;
		local sdMod = 0;
		local stunMod = -50;
		local bleedingMod = 0;
		local effectsMod = 0;
		local effectsDesc;

		-- Get Effects Durations
		if ctNode.getChild("effects") then
			for k, eff in pairs(ctNode.getChild("effects").getChildren()) do
				if eff.getChild("penalty") and eff.getChild("description") then
					local pen = eff.getChild("penalty").getValue();
					local desc = eff.getChild("description").getValue();
					if pen~=0 then
						table.insert(modifiers, {description=desc, value=pen});
					end
				end
				stunRounds = stunRounds + eff.getChild("stunned").getValue();
			end
		end
		
		-- Get Self Discipline Bonus
		if actorNode.getChild("abilities.selfdiscipline.total") then
			sdMod = actorNode.getChild("abilities.selfdiscipline.total").getValue();
			if sdMod < 0 then
				sdMod = 0;
			end
		end
		
		-- Get Stun and Bleeding Modifiers by Skill Name
		if skillName then
			if string.find(skillName, "Speed") or string.find(skillName, "Strength") then
				stunMod = -30;
				bleedingMod = -10 * bleedingAmount;
			elseif string.find(skillName, "Hide") then
				stunMod = 0;
			elseif string.find(skillName, "Disarm Traps") then
				bleedingMod = -5 * bleedingAmount;
			elseif string.find(skillName, "Pick Locks") then
				bleedingMod = -5 * bleedingAmount;
			elseif string.find(skillName, "Perception") then
				stunMod = -30;
				bleedingMod = -5 * bleedingAmount;
			else
				bleedingMod = -10 * bleedingAmount;
			end
		end
		
		-- Get Stun and Must Parry information
		if stunRounds > 0 then
			effectsMod = stunMod + sdMod;
			effectsDesc = "Stun";
		end
		
		if effectsMod > 0 then
			effectsMod = 0;
		end
		
		if stunRounds  > 0 then
			table.insert(modifiers, {description=effectsDesc, value=effectsMod});
		end
		
		if bleedingAmount > 0 and bleedingMod > 0 then
			table.insert(modifiers, {description="Bleeding", value=bleedingMod});
		end
	end
end 

function TargetDefense(modifiers, attackerNode, targetNode, ismissile)
  local result;
  local myNodeName = attackerNode.getNodeName();
  local noparry = false;
  local parryat = 0;
  
  if not targetNode then
    return 0;
  end
  -- check if unable to parry
  for k,eff in pairs(targetNode.createChild("effects").getChildren()) do
    if eff.createChild("cantParry","number").getValue()~=0 or eff.createChild("down","number").getValue()~=0 then
      noparry = true;
    end
  end
  -- general defence bonus
  result = targetNode.createChild("db","number").getValue();
  table.insert(modifiers, {description="DB - Defense bonus", value=-result, gmonly=true});

  -- find defence entries
  for k,def in pairs(targetNode.createChild("defences").getChildren()) do
    if def.createChild("targetnode","string").getValue()==myNodeName or (def.getChild("targetall") and def.createChild("targetall","number").getValue()==1) then
	  result = 0;
      if noparry and def.getChild("type") and def.getChild("type").getValue()~=7 then -- 7 is a Shield
        -- this is a weapon, but the defender is unable to parry, so don't include it in the DB
      elseif def.getChild("type") and def.getChild("type").getValue()~=7 then
        -- this is a weapon, so adjust for any parry penalty
        local parry = 0;
        if ismissile then
          parry = def.createChild("missilebonus","number").getValue() + parryat;
        else
          parry = def.createChild("meleebonus","number").getValue() + parryat;
        end
        if parry > 0 then
          result = result + parry;
        end
	  else
		if ismissile then
			result = result + def.createChild("missilebonus","number").getValue();
		else
			result = result + def.createChild("meleebonus","number").getValue();
        end
	  end
	  if result > 0 then
		local defName = def.getChild("name").getValue();
		table.insert(modifiers, {description="DB - " .. defName, value=-result, gmonly=true});
	  end
    end
  end
  
  -- done
  return;
end

function TargetStunned(modifiers, target)
	local stunned = false;
	
	for k, eff in pairs(target.getChild("effects").getChildren()) do
		if eff.getChild("stunned") then
			if eff.getChild("stunned").getValue() > 0 then
				stunned = true;
			end
		end
		if eff.getChild("cantParry") then
			if eff.getChild("cantParry").getValue() > 0 then
				stunned = true;
			end
		end
	end	

	if stunned then 
		table.insert(modifiers, {description="Defender Stunned", value=20});
	end
end

function AttackBonus(modifiers, node)
	table.insert(modifiers, {description="Attack bonus", value=node.getChild("attack").getValue()});
end

function SpellCastingRoll(modifiers, node, actorNode)
	table.insert(modifiers, {description=node.getChild("name").getValue(), value=0});
	table.insert(modifiers, {description="List Ranks", value=node.getChild("maxlevel").getValue()});
	table.insert(modifiers, {description="Realm Stat", value=Rules_PC.RealmStatBonus(actorNode)});

	local listtype = string.lower(node.getChild("type").getValue());
	if string.find(listtype, "base") then
		table.insert(modifiers, {description="Base List", value=5});
	elseif string.find(listtype, "closed") then
		table.insert(modifiers, {description="Closed List", value=-5});
	elseif string.find(listtype, "open") then
		table.insert(modifiers, {description="Open List", value=0});
	else
		table.insert(modifiers, {description="UNKNOWN List", value=-10});
	end
  
	local maxpp = actorNode.getChild("maxpower").getValue();
	local usedpp = actorNode.getChild("power").getValue();
	if maxpp and usedpp and (usedpp/maxpp > 0.5) then
		table.insert(modifiers, {description="PP Usage", value=-10});
	end 

	local atHelm = actorNode.getChild("atHelm").getValue();
	local realm = actorNode.getChild("realm").getValue();
	if realm == "Channeling" then
		if atHelm == 3 then
			table.insert(modifiers, {description="Medium Helmet", value=-10});
		elseif atHelm == 4 then
			table.insert(modifiers, {description="Heavy Helmet", value=-20});
		end
	elseif realm == "Essence" then
		if atHelm == 2 then
			table.insert(modifiers, {description="Light Helmet", value=-10});
		elseif atHelm == 3 then
			table.insert(modifiers, {description="Medium Helmet", value=-20});
		elseif atHelm == 4 then
			table.insert(modifiers, {description="Heavy Helmet", value=-30});
		end
	else
		if atHelm == 2 then
			table.insert(modifiers, {description="Light Helmet", value=-25});
		elseif atHelm == 3 then
			table.insert(modifiers, {description="Medium Helmet", value=-50});
		elseif atHelm == 4 then
			table.insert(modifiers, {description="Heavy Helmet", value=-75});
		end
	end	
end

function BodyDevelopment(modifiers, actorNode)
	local BodyDevelopment = 0;
	
	if actorNode.getChild("skills") then
		for k,skl in pairs(actorNode.getChild("skills").getChildren()) do
			local baseskill = skl.createChild("baseskill","string").getValue();
			if baseskill == "Body Development" then
				skill = skl;
			end
		end
	end
	if skill then
		BodyDevelopment = skill.createChild("total","number").getValue();
	end
	
	if BodyDevelopment ~= 0 then
		table.insert(modifiers, {description="Body Development", value=BodyDevelopment});
	end
end


function RRModifier(modifiers, node)
	table.insert(modifiers, {description=node.getChild("label").getValue() .. " Bonus", value=node.getChild("total").getValue()});
end

function StatModifier(modifiers, node)
	table.insert(modifiers, {description=node.getChild("label").getValue() .. " Bonus", value=node.getChild("total").getValue()});
end

function SkillBonus(modifiers, node)
	if node then
		table.insert(modifiers, {description="Skill bonus", value=node.createChild("total","number").getValue()});
	end
end

function NPCSkillBonus(modifiers, node)
	if node then
		table.insert(modifiers, {description="Skill bonus", value=node.createChild("bonus","number").getValue()});
	end
end

function SkillManeuver(modifiers, node, actorNode)
	local factor = 0;
	if node then
		-- get Armor Factor if available, if not use the default multiplier of 1
		if node.createChild("armorfactor","number").getValue()>0 then
			factor = node.createChild("armorfactor","number").getValue();
		end
	end
	Debug.chat(factor);
	-- adjust MM rolls for armor penalties and the Moving in <Armor Type> skill
	mmpen = Rules_PC.MMPenalty(actorNode);
	Debug.chat(mmpen);

	if mmpen < 0 and factor > 0 then
		if factor == 1 then
			table.insert(modifiers, {description="Armor penalty", value=mmpen});
		else
			table.insert(modifiers, {description="Armor penalty (x"..factor..")", value=mmpen*factor});
		end
	end
	
	-- check NPC MN Bonus
	if actorNode.getChild("mnbonus") then
		table.insert(modifiers, {description="MN bonus", value=actorNode.getChild("mnbonus").getValue()});
	end

end


