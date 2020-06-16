-- Set Race
function SetRace(node, source)
	--[[ rr modifiers ]]
	    
		if source and source.getChild("statbonuses") then
		for k,mod in pairs(source.getChild("statbonuses").getChildren()) do
			node.createChild("abilities." .. k .. ".race","number").setValue(mod.getValue());
		end
	end
	
	--[[ rr modifiers ]]
	if source and source.getChild("resistances") then
		for k,mod in pairs(source.getChild("resistances").getChildren()) do
			node.createChild("resistance_rolls." .. k .. ".race","number").setValue(mod.getValue());
		end
	end
	
		node.createChild("race");
		node.createChild("resistance_rolls");
		node.createChild("resistance_rolls.magic");
		node.createChild("resistance_rolls.stamina");
		node.createChild("resistance_rolls.will");
		node.createChild("race.endurance","number").setValue(source.getChild("endurance").getValue());
		node.createChild("race.powerpoints","number").setValue(source.getChild("powerpoints").getValue());
		node.createChild("race.initiative","number").setValue(source.getChild("initiative").getValue());
		node.createChild("size","number").setValue(source.getChild("size").getValue());
end


-- PC Information
function CombinedStatBonus(node, stats)  -- Change for different rules
	local bonus = 0;
	local statList = Rules_Stats.StatList(stats);

	if node and #statList > 0 then
		for k, stat in pairs(statList) do
			bonus = bonus + StatBonus(node, stat.nodename);
		end
	end	

	return bonus;
end

function StatBonus(node, statnodename)
	local statnode = node.getChild("abilities." .. statnodename .. ".total");
	
	if statnode then
		return statnode.getValue();
	else
		return 0;
	end
end

-- Miscellaneous Characteristics
function Hits(node)
	return Endurance(node);
end

function Endurance(node)
	local bonus = 0;
	local skill = nil;
	local raceendurance = 25; -- if nothing from race data use the base value of 25
	
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Endurance" then
				skill = skl;
			end
		end
	end
	if node.getChild("race.endurance") then
		raceendurance = node.getChild("race.endurance").getValue();
	end
		
	if skill then
		bonus = skill.createChild("total","number").getValue() + raceendurance;
	end

	return bonus;
end

function PowerPoints(node)
	local bonus = 0;
	local skill = nil;
	local raceppts = 25; -- if nothing from race data use the base value of 25
		
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Power Point Development" then
				skill = skl;
			end
		end
	end
	if node.getChild("race.powerpoints") then
		raceppts = node.getChild("race.powerpoints").getValue();
	end
	if skill then
		bonus = skill.createChild("total","number").getValue() + raceppts;
	end
	
	return bonus;
end

function RRMagic(node)
	local bonus = 0;
	local skill = nil;
	local racerrmagic = 10; -- if nothing from race data use the base value of 25
		
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Resistance: Magic" then
				skill = skl;
			end
		end
	end
	if node.getChild("resistance_rolls.magic.race") then
		racerrmagic = node.getChild("resistance_rolls.magic.race").getValue();
	end
	if skill then
		bonus = skill.createChild("total","number").getValue() + racerrmagic;
	end
	
	return bonus;	
end

function RRStamina(node)
	local bonus = 0;
	local skill = nil;
	local racerrstamina = 10; -- if nothing from race data use the base value of 25
		
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Resistance: Stamina" then
				skill = skl;
			end
		end
	end
	if node.getChild("resistance_rolls.stamina.race") then
		racerrstamina = node.getChild("resistance_rolls.stamina.race").getValue();
	end
	if skill then
		bonus = skill.createChild("total","number").getValue() + racerrstamina;
	end
	
	return bonus;
end

function RRWill(node)
	local bonus = 0;
	local skill = nil;
	local racerrwill = 10; -- if nothing from race data use the base value of 25
		
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Resistance: Will" then
				skill = skl;
			end
		end
	end
	if node.getChild("resistance_rolls.will.race") then
		racerrwill = node.getChild("resistance_rolls.will.race").getValue();
	end
	if skill then
		bonus = skill.createChild("total","number").getValue() + racerrwill;
	end
	
	return bonus;
end

function GetBMRFromHeight(height)
	words={}
	local stride = 0;
	local sep = "'";
	for str in string.gmatch(height, "([^"..sep.."]+)") do
		table.insert(words, str);
	end
	sep ='"';
	if table.getn(words) > 1 then
		for ind, str in ipairs(words) do
			if ind == 1 then
				stride = stride + (tonumber(str) * 12);
			else
				if tonumber(str) == nil then
					str = str:sub(1,-2);
				end
				stride = stride + tonumber(str);
			end
		end
	else
		for ind, str in ipairs(words) do
			if tonumber(str) == nil then
				str = str:sub(1,-2);
			end
			stride = stride + tonumber(str);
		end
	end
	local bmr
	if stride > 99 then
		bmr = 15
	elseif stride >= 94 and stride <= 99 then
		bmr = 14
	elseif stride >= 88 and stride <= 93 then
		bmr = 13
	elseif stride >= 82 and stride <= 87 then
		bmr = 12
	elseif stride >= 76 and stride <= 81 then
		bmr = 11
	elseif stride >= 70 and stride <= 75 then
		bmr = 10
	elseif stride >= 64 and stride <= 69 then
		bmr = 9
	elseif stride >= 58 and stride <= 63 then
		bmr = 8
	elseif stride >= 52 and stride <= 57 then
		bmr = 7
	elseif stride >= 46 and stride <= 51 then
		bmr = 6
	elseif stride >= 40 and stride <= 45 then
		bmr = 5
	elseif stride >= 34 and stride <= 39 then
		bmr = 4
	elseif stride >= 28 and stride <= 33 then
		bmr = 3
	elseif stride >= 22 and stride <= 27 then
		bmr = 2
	else
		bmr = 1
	end
	return bmr;
end

function SetBaseMoveRate(node)
	local bmr = 0;
	local height = "5'0" .. '"';
	if node.getChild("appearance") then
		apnode = node.getChild("appearance");
		if apnode.getChild("height") then
			height = apnode.getChild("height").getValue();
		end
	end
	local stride = GetBMRFromHeight(height);
	node.createChild("bmr.race", "number").setValue(stride);
end

function MMPenalty(node)
	local mmpen = 0;
	if node.getChild("harnessmanpenalty")  then
		mmpen = node.getChild("harnessmanpenalty").getValue();
	end
	mmpen = -1*mmpen;
	return mmpen;
end

function AdrenalDefence(node)
	local bonus = 0;
	local adSkill = nil;
	
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local fullname = skl.createChild("fullname","string").getValue();
			if fullname == "Adrenal Defence" then
				adSkill = skl;
			end
		end
	end
	if adSkill then
		bonus = adSkill.createChild("total","number").getValue();
	end

	return bonus;
end

function DBStatNode(node)
	return node.getChild("abilities.quickness.total");
end
function DBStatBonus(node)
	return DBStatNode(node).getValue() * 3;
end

function BMRStatNode(node)
	return node.getChild("abilities.quickness.temp");
end
function BMRStatBonus(node)
	local quick = BMRStatNode(node).getValue();
	local bonus
	if quick > 101 then
		bonus = 7;
	elseif quick == 101 then
		bonus = 6;
	elseif quick == 100 then
		bonus = 5;
	elseif quick >= 98 and quick <= 99 then
		bonus = 4;
	elseif quick >= 95 and quick <= 97 then
		bonus = 3;
	elseif quick >= 90 and quick <= 94 then
		bonus = 2;
	elseif quick >= 75 and quick <= 89 then
		bonus = 1;
	elseif quick >= 25 and quick <= 74 then
		bonus = 0;
	elseif quick >= 10 and quick <= 24 then
		bonus = -1;
	elseif quick >= 5 and quick <= 9 then
		bonus = -2;
	elseif quick >= 3 and quick <= 4 then
		bonus = -3;
	elseif quick == 2 then
		bonus = -4;
	else
		bonus = -5;
	end
	return bonus;
end

function EncumbranceStatNode(node)
	return node.getChild("abilities.strength.total");
end

function EncumbranceStatBonus(node)
	local Bonus = EncumbranceStatNode(node).getValue();
	if Bonus > 0 then
		return (Bonus);
	else
		return 0;
	end
end

-- Skills
function SkillList(node)
	local skillList = {};
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local skillname = "";
			if skl.getChild("name") then
				skillname = skl.getChild("name").getValue();
			end
			if skl.getChild("specialization") then
			  if skl.getChild("specialization").getValue() ~= "" then
				skillname = skillname .. "[" .. skl.getChild("specialization").getValue() .. "]";
			  end
			end
			table.insert(skillList, skillname);	
		end
	end

	return skillList;
end

function SkillTotal(node, skill)
	local total = nil;
	local specloc = string.find(skill, "[", 1, true);
	local skillname;
	local specializationname = nil;
	if specloc then
		skillname = string.sub(skill, 1, specloc - 1);
		specializationname = string.sub(skill, specloc + 1, -2);
	else
		skillname = skill;
	end
	if node then
		if node.getChild("skills") then
			for k,skl in pairs(node.getChild("skills").getChildren()) do
				if skl.getChild("name") and string.lower(skl.getChild("name").getValue()) == string.lower(skillname) then
					--if (specializationname == nil and (skl.getChild("specialization").getValue() == nil or skl.getChild("specialization").getValue() == "")) then
					--	total = skl.getChild("total").getValue();
					--elseif skl.getChild("specialization") and specializationname and string.lower(skl.getChild("specialization").getValue()) == string.lower(specializationname) then
					    total = skl.getChild("total").getValue();
					--end
				end				
			end
		else
		end
	else 
	end
	return total;
end

function SkillTotalChanged(node, skillName, skillname, skillTotal)
	-- Update Hits and Max PP
	if skillname == "Body Development" then
		if PreferenceManager.load(Preferences.CharCalcHitsPref) == Preferences.Yes then
			node.getChild("hits").setValue(Hits(node));
		end
	elseif skillname == "Power Development" then
		if PreferenceManager.load(Preferences.CharCalcPPPref) == Preferences.Yes then
			node.getChild("maxpower").setValue(PowerPoints(node));
		end
	end
	-- Update Weapon OB
	if node.getChild("weapons") then
		for k, wpn in pairs(node.getChild("weapons").getChildren()) do
			if wpn.getChild("associatedskill") then
				if wpn.getChild("associatedskill").getValue() == skillName then
					if wpn.getChild("ob") then
						wpn.getChild("ob").setValue(skillTotal);
					end
				end
			end			
		end
	end
end

function IsProfessionalSkill(node, name)
	local bProfessionalSkill = false;
	
	if node.getChild("profession") then
		local profession = node.getChild("profession").getValue();
		bProfessionalSkill = Rules_Professions.IsProfessionalSkill(profession, name);
	end		
	return bProfessionalSkill;
end

-- Spells
function ListSpellCastingRoll(node, listranks, listtype)
	local statbonus = Rules_PC.RealmStatBonus(node);
	local listtypebonus = 0;
	
	if string.find(string.lower(listtype),"base") then
		listtypebonus = 5;
	elseif string.find(string.lower(listtype),"closed") then
		listtypebonus = -5;
	end
	
	return listranks + statbonus + listtypebonus;
end

function SpellList(node)
	local spellList = {};
	if node.getChild("spells") then
		for k,skl in pairs(node.getChild("spells").getChildren()) do
			local spellname = "";
			if skl.getChild("name") then
				spellname = skl.getChild("name").getValue();
			end
			table.insert(spellList, spellname);	
		end
	end

	return spellList;
end
