function getBaseDB(hdstate, nkstate, shstate, trstate, arstate, abstate, hnstate, gnstate, lgstate, ftstate)
	local DB = 0;
	if hdstate == 1 then
		DB = DB + 0;
	else
		DB = DB + hdstate;
	end
	if nkstate == 1 then
		DB = DB + 0;
	else
		DB = DB + nkstate;
	end
	if shstate == 1 then
		DB = DB + 0;
	else
		DB = DB + shstate;
	end
	if trstate == 1 then
		DB = DB + 0;
	else
		DB = DB + trstate;
	end
	if arstate == 1 then
		DB = DB + 0;
	else
		DB = DB + arstate;
	end
	if abstate == 1 then
		DB = DB + 0;
	else
		DB = DB + abstate;
	end
	if hnstate == 1 then
		DB = DB + 0;
	else
		DB = DB + hnstate;
	end
	if gnstate == 1 then
		DB = DB + 0;
	else
		DB = DB + gnstate;
	end
	if lgstate == 1 then
		DB = DB + 0;
	else
		DB = DB + lgstate;
	end
	if ftstate == 1 then
		DB = DB + 0;
	else
		DB = DB + ftstate;
	end
	return DB;
end

function setMaxHeadArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_head_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxNeckArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_neck_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxShoulderArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_shoulder_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxArmArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_arm_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxHandArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_hand_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxTorsoArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_torso_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxAbdomenArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_abdomen_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxGroinArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_groin_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxLegArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_leg_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function setMaxFootArmour(node)
	local maxtype = 1;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("item_foot_armour","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 0 then
					tmp = 1
				end
				if tmp > maxtype then
					maxtype = tmp;
				end
			end
		end
	end
	return maxtype;
end

function getDBBonus(node)
	local totalbonus = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("db_bonus","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 1 then
					totalbonus = totalbonus + tmp;
				end
			end
		end
	end
	totalbonus = math.floor(totalbonus+0.5)
	return totalbonus;
end

function getKnownDBBonus(node)
	local totalbonus = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local tmp = skl.createChild("db_bonus","number").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				local known = skl.createChild("isidentified","number").getValue();
				if flg == 1 then
					if known == 1 then
						totalbonus = totalbonus + tmp;
					end
				end
			end
		end
	end
	totalbonus = math.floor(totalbonus+0.5)
	return totalbonus;
end

function getPenalty(node)
	local totpenalty = 0;
	local penalty = 0;
	local armourskill = 0;
	if node.getChild("skills") then
		for k,skl in pairs(node.getChild("skills").getChildren()) do
			local name = skl.createChild("name","string").getValue();
			if name == "Armour" then
				armourskill = skl.createChild("total","number").getValue();
			end
		end
	end
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			penalty = 0;
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local fitflg = skl.createChild("isfitted","number").getValue();
				if fitflg == 1 then
					local fitmaxmp = skl.createChild("item_fitted_max","number").getValue();
					local fitminmp = skl.createChild("item_fitted_min","number").getValue();
					penalty = fitmaxmp + armourskill;
					if penalty > fitminmp then
						penalty = fitminmp;
					end
				else
					local ufmaxmp = skl.createChild("item_unfitted_max","number").getValue();
					local ufminmp = skl.createChild("item_unfitted_min","number").getValue();
					penalty = ufmaxmp + armourskill;
					if penalty > ufminmp then
						penalty = ufminmp;
					end
				end
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 1 then
					totpenalty = totpenalty + penalty;
				end
			end
		end
	end
	totpenalty = math.floor(totpenalty+0.5)
	return totpenalty;
end

function getCastPenalty(node)
	local totpenalty = 0;
	local penalty = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			penalty = 0;
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				penalty = skl.createChild("item_cast_penalty").getValue();
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 1 then
					totpenalty = totpenalty + penalty;
				end
			end
		end
	end
  totpenalty = math.floor(totpenalty+0.5)
  return totpenalty;
end

function quicknessDB(node)
  local quickness = 0;
  local quick =0;
  local penalty = getPenalty(node);
  local stat = nil;
  if node.getChild("abilities") then
    for k,skl in pairs(node.getChild("abilities").getChildren()) do
      local name = skl.createChild("label","string").getValue();
		if name == "Qu" then
			stat = skl;
		end
    end
	quick = stat.createChild("total","number").getValue()
  end
  quickness = 2*quick + penalty;
  if quickness < 0 then
	quickness = 0;
  end
  return quickness;
end

function checkShieldTraining(node)
  local flg = 0;
  if node.getChild("talents") then
    for k,skl in pairs(node.getChild("talents").getChildren()) do
	  local name = skl.createChild("name","string").getValue();
	  if name == "Shield Training" then
		flg = 1;
	  end
	end
  end
  if flg == 1 then
	return true;
  else
	return false;
  end		
end

function getShieldDB(node)
	local trained = checkShieldTraining(node);
	local maxDB = 0;
	local base = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				if flg == 1 then
					if trained then
						base = skl.createChild("item_shield_trained","number").getValue();
					else
						base = skl.createChild("item_shield_untrained","number").getValue();
					end
					if base > maxDB then
						maxDB = base;
					end
				end
			end
		end
	end
	return maxDB;
end

function getUnknownMagicDB(node)
	local bonus = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic ~= 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
		if node.getChild("combat.weapons") then
			for k,skl in pairs(node.getChild("combat.weapons").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic ~= 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
		if node.getChild("items.general") then
			for k,skl in pairs(node.getChild("items.general").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic ~= 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
	end
	return bonus;
end

function getKnownMagicDB(node)
	local bonus = 0;
	if node.getChild("combat") then
		if node.getChild("combat.defences") then
			for k,skl in pairs(node.getChild("combat.defences").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic == 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
		if node.getChild("combat.weapons") then
			for k,skl in pairs(node.getChild("combat.weapons").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic == 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
	end
	if node.getChild("items") then
		if node.getChild("items.general") then
			for k,skl in pairs(node.getChild("items.general").getChildren()) do
				local flg = skl.createChild("isequipped","number").getValue();
				local magic = skl.createChild("isidentified","number").getValue();
				local db_bonus = skl.createChild("db_bonus","number").getValue();
				if flg == 1 then
					if magic == 1 then
						bonus = bonus + db_bonus;
					end
				end
			end
		end
	end
	return bonus;
end