
function Roll(nodepath)
	local customData = Rules_CustomData.SpellCastingRoll(nodepath);
	if customData then
		ChatManager.throwDice("dice", {"d100","d10"}, 0, "", customData);
	end
end

function Drag(dragData, nodepath)
	dragData.setDescription("Spell Casting Roll");
	dragData.setType("Hotkey:SCR");
	dragData.setStringData(nodepath); 
	dragData.setDieList({"d100","d10"});
	return true;
end

function calcTotalExtraPPs(node)
    local pen = 0;
	if node.getChild("armourpen") then
		pen = pen + node.createChild("armourpen").getValue();
	end
	if node.getChild("ppadder") then
		pen = pen - node.createChild("ppadder").getValue();
	end
	if node.getChild("spellopts") then
		for k, opt in pairs(node.getChild("spellopts").getChildren()) do
			if opt.getChild("extraPP") then
				pen = pen + opt.createChild("extraPP").getValue();
			end
		end
	end
	return pen;
end

function calcTotalPPs(node)
	local cost = node.getChild("base_cost").getValue();
	local pen = calcTotalExtraPPs(node);
	return cost+pen;
end

function calcRounds(ppcost)
	-- should refactor to account for non personal mana rates
	local recharge = 5; -- personal mana is 5/rnd
	return math.ceil(ppcost/recharge);
end

function calcSpeedPen(nominal,actual)
	local diff = nominal - actual;
	if diff == 0 then
		return 0;
	elseif diff < 0 then
		return diff*10;
	else
		if diff > 6 then
			diff = 6;
		end
		return diff*5;
	end
end

function calcOverspendPen(ppextras)
	return -5*ppextras;
end