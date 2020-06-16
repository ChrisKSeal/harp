function copyWeapon(src, dst)
	if src.getChild("ammunition_type") then
		dst.createChild("ammunition_type","number").setValue(src.getChild("ammunition_type").getValue());
	end
	if src.getChild("db_bonus") then
		dst.createChild("db_bonus","number").setValue(src.getChild("db_bonus").getValue());
	end
	if src.getChild("identified") then
		dst.createChild("identified","string").setValue(src.getChild("identified").getValue());
	end
	if src.getChild("int_insight") then
		dst.createChild("int_insight","number").setValue(src.getChild("int_insight").getValue());
	end
	if src.getChild("int_personality") then
		dst.createChild("int_personality","string").setValue(src.getChild("int_personality").getValue());
	end
	if src.getChild("int_presence") then
		dst.createChild("int_presence","number").setValue(src.getChild("int_presence").getValue());
	end
	if src.getChild("int_reasoning") then
		dst.createChild("int_reasoning","number").setValue(src.getChild("int_reasoning").getValue());
	end
	if src.getChild("int_selfdiscipline") then
		dst.createChild("int_selfdiscipline","number").setValue(src.getChild("int_selfdiscipline").getValue());
	end
	if src.getChild("int_willpower") then
		dst.createChild("int_willpower","number").setValue(src.getChild("int_willpower").getValue());
	end
	if src.getChild("isequipped") then
		dst.createChild("isequipped","number").setValue(src.getChild("isequipped").getValue());
	end
	if src.getChild("isidentified") then
		dst.createChild("isidentified","number").setValue(src.getChild("isidentified").getValue());
	end
	if src.getChild("isintelligent") then
		dst.createChild("isintelligent","number").setValue(src.getChild("isintelligent").getValue());
	end
	if src.getChild("item_charges") then
		dst.createChild("item_charges","number").setValue(src.getChild("item_charges").getValue());
	end
	if src.getChild("item_length") then
		dst.createChild("item_length","number").setValue(src.getChild("item_length").getValue());
	end
	if src.getChild("item_type") then
		dst.createChild("item_type","number").setValue(src.getChild("item_type").getValue());
	end
	if src.getChild("item_value") then
		dst.createChild("item_value","number").setValue(src.getChild("item_value").getValue());
	end
	if src.getChild("item_weight") then
		dst.createChild("item_weight","number").setValue(src.getChild("item_weight").getValue());
	else
		dst.createChild("item_weight","number").setvalue(0);
	end
	if src.getChild("multiple_attacks") then
		dst.createChild("multiple_attacks", "number").setValue(src.getChild("multiple_attacks").getValue());
	end
	if src.getChild("name") then
		dst.createChild("name","string").setValue(src.getChild("name").getValue());
	else
		dst.createChild("name","string");
	end
	if src.getChild("nonidentified") then
		dst.createChild("nonidentified","string").setValue(src.getChild("nonidentified").getValue());
	end
	if src.getChild("ob_bonus") then
		dst.createChild("ob_bonus", "number").setValue(src.getChild("ob_bonus").getValue());
	end
	if src.getChild("pp_adder") then
		dst.createChild("pp_adder", "number").setValue(src.getChild("pp_adder").getValue());
	end
	if src.getChild("primary_attack_table") then
		local attknode = dst.createChild("primary_attack_table");
		if src.getChild("primary_attack_table.name") then
			attknode.createChild("name","string").setValue(src.getChild("primary_attack_table.name").getValue());
		end
		if src.getChild("primary_attack_table.tableid") then
			attknode.createChild("tableid","string").setValue(src.getChild("primary_attack_table.tableid").getValue());
		end
	end
	if src.getChild("primary_category") then
		dst.createChild("primary_category", "number").setValue(src.getChild("primary_category").getValue());
	end
	if src.getChild("primary_fumble") then
		dst.createChild("primary_fumble", "number").setValue(src.getChild("primary_fumble").getValue());
	end
	if src.getChild("primary_point_blank") then
		dst.createChild("primary_point_blank", "number").setValue(src.getChild("primary_point_blank").getValue());
	end
	if src.getChild("primary_point_blank_bonus") then
		dst.createChild("primary_point_blank_bonus", "number").setValue(src.getChild("primary_point_blank_bonus").getValue());
	end
	if src.getChild("primary_range_inc") then
		dst.createChild("primary_range_inc", "number").setValue(src.getChild("primary_range_inc").getValue());
	end
	if src.getChild("primary_reload") then
		dst.createChild("primary_reload", "number").setValue(src.getChild("primary_reload").getValue());
	end
	if src.getChild("primary_size") then
		dst.createChild("primary_size", "number").setValue(src.getChild("primary_size").getValue());
	end
	if src.getChild("primary_skill") then
		dst.createChild("primary_skill","string").setValue(src.getChild("primary_skill").getValue());
	end		
	if src.getChild("secondary_attack_table") then
		local attknode = dst.createChild("secondary_attack_table");
		if src.getChild("secondary_attack_table.name") then
			attknode.createChild("name","string").setValue(src.getChild("secondary_attack_table.name").getValue());
		end
		if src.getChild("secondary_attack_table.tableid") then
			attknode.createChild("tableid","string").setValue(src.getChild("secondary_attack_table.tableid").getValue());
		end
	end
	if src.getChild("secondary_category") then
		dst.createChild("secondary_category", "number").setValue(src.getChild("secondary_category").getValue());
	end
	if src.getChild("secondary_fumble") then
		dst.createChild("secondary_fumble", "number").setValue(src.getChild("secondary_fumble").getValue());
	end
	if src.getChild("secondary_point_blank") then
		dst.createChild("secondary_point_blank", "number").setValue(src.getChild("secondary_point_blank").getValue());
	end
	if src.getChild("secondary_point_blank_bonus") then
		dst.createChild("secondary_point_blank_bonus", "number").setValue(src.getChild("secondary_point_blank_bonus").getValue());
	end
	if src.getChild("secondary_range_inc") then
		dst.createChild("secondary_range_inc", "number").setValue(src.getChild("secondary_range_inc").getValue());
	end
	if src.getChild("secondary_reload") then
		dst.createChild("secondary_reload", "number").setValue(src.getChild("secondary_reload").getValue());
	end
	if src.getChild("secondary_size") then
		dst.createChild("secondary_size", "number").setValue(src.getChild("secondary_size").getValue());
	end
	if src.getChild("secondary_skill") then
		dst.createChild("secondary_skill","string").setValue(src.getChild("secondary_skill").getValue());
	end
	if src.getChild("skillbonuses") then
		local bonnode = dst.createChild("skillbonuses");
		for k,skl in pairs(src.getChild("skillbonuses").getChildren()) do
			local curnode = bonnode.createChild(k);
			if skl.getChild("name") then
				curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
			end
			if skl.getChild("skill_bonus") then
				curnode.createChild("skill_bonus","number").setValue(skl.getChild("skill_bonus").getValue());
			end
		end
	end
	if src.getChild("spell_adder") then
		dst.createChild("spell_adder", "number").setValue(src.getChild("spell_adder").getValue());
	end
	if src.getChild("spells") then
		local splnode = dst.createChild("spells");
		if src.getChild("spells.charge") then
		local chgnode = splnode.createChild("charge");
			for k,skl in pairs(src.getChild("spells.charge").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("cost") then
					curnode.createChild("cost","number").setValue(skl.getChild("cost").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
			end
		local chgnode = splnode.createChild("daily");
			for k,skl in pairs(src.getChild("spells.daily").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
				if skl.getChild("uses_per_day") then
					curnode.createChild("uses_per_day","number").setValue(skl.getChild("uses_per_day").getValue());
				end
			end
		end
	end
	if src.getChild("true_value") then
		dst.createChild("true_value", "number").setValue(src.getChild("true_value").getValue());
	end
	return dst;
end

function copyDefence(src, dst)
	if src.getChild("db_bonus") then
		dst.createChild("db_bonus","number").setValue(src.getChild("db_bonus").getValue());
	end
	if src.getChild("identified") then
		dst.createChild("identified","string").setValue(src.getChild("identified").getValue());
	end
	if src.getChild("int_insight") then
		dst.createChild("int_insight","number").setValue(src.getChild("int_insight").getValue());
	end
	if src.getChild("int_personality") then
		dst.createChild("int_personality","string").setValue(src.getChild("int_personality").getValue());
	end
	if src.getChild("int_presence") then
		dst.createChild("int_presence","number").setValue(src.getChild("int_presence").getValue());
	end
	if src.getChild("int_reasoning") then
		dst.createChild("int_reasoning","number").setValue(src.getChild("int_reasoning").getValue());
	end
	if src.getChild("int_selfdiscipline") then
		dst.createChild("int_selfdiscipline","number").setValue(src.getChild("int_selfdiscipline").getValue());
	end
	if src.getChild("int_willpower") then
		dst.createChild("int_willpower","number").setValue(src.getChild("int_willpower").getValue());
	end
	if src.getChild("isequipped") then
		dst.createChild("isequipped","number").setValue(src.getChild("isequipped").getValue());
	end
	if src.getChild("isfitted") then
		dst.createChild("isfitted","number").setValue(src.getChild("isfitted").getValue());
	end
	if src.getChild("isidentified") then
		dst.createChild("isidentified","number").setValue(src.getChild("isidentified").getValue());
	end
	if src.getChild("isintelligent") then
		dst.createChild("isintelligent","number").setValue(src.getChild("isintelligent").getValue());
	end
	if src.getChild("item_abdomen_armour") then
		dst.createChild("item_abdomen_armour","number").setValue(src.getChild("item_abdomen_armour").getValue());
	end
	if src.getChild("item_arm_armour") then
		dst.createChild("item_arm_armour","number").setValue(src.getChild("item_arm_armour").getValue());
	end
	if src.getChild("item_cast_penalty") then
		dst.createChild("item_cast_penalty","number").setValue(src.getChild("item_cast_penalty").getValue());
	end
	if src.getChild("item_charges") then
		dst.createChild("item_charges","number").setValue(src.getChild("item_charges").getValue());
	end
	if src.getChild("item_db_base") then
		dst.createChild("item_db_base","number").setValue(src.getChild("item_db_base").getValue());
	end
	if src.getChild("item_fitted_max") then
		dst.createChild("item_fitted_max","number").setValue(src.getChild("item_fitted_max").getValue());
	end
	if src.getChild("item_fitted_min") then
		dst.createChild("item_fitted_min","number").setValue(src.getChild("item_fitted_min").getValue());
	end
	if src.getChild("item_foot_armour") then
		dst.createChild("item_foot_armour","number").setValue(src.getChild("item_foot_armour").getValue());
	end
	if src.getChild("item_groin_armour") then
		dst.createChild("item_groin_armour","number").setValue(src.getChild("item_groin_armour").getValue());
	end
	if src.getChild("item_hand_armour") then
		dst.createChild("item_hand_armour","number").setValue(src.getChild("item_hand_armour").getValue());
	end
	if src.getChild("item_head_armour") then
		dst.createChild("item_head_armour","number").setValue(src.getChild("item_head_armour").getValue());
	end
	if src.getChild("item_leg_armour") then
		dst.createChild("item_leg_armour","number").setValue(src.getChild("item_leg_armour").getValue());
	end
	if src.getChild("item_length") then
		dst.createChild("item_length","number").setValue(src.getChild("item_length").getValue());
	end
	if src.getChild("item_neck_armour") then
		dst.createChild("item_neck_armour","number").setValue(src.getChild("item_neck_armour").getValue());
	end
	if src.getChild("item_shield_trained") then
		dst.createChild("item_shield_trained","number").setValue(src.getChild("item_shield_trained").getValue());
	end
	if src.getChild("item_shield_untrained") then
		dst.createChild("item_shield_untrained","number").setValue(src.getChild("item_shield_untrained").getValue());
	end
	if src.getChild("item_shoulder_armour") then
		dst.createChild("item_shoulder_armour","number").setValue(src.getChild("item_shoulder_armour").getValue());
	end
	if src.getChild("item_torso_armour") then
		dst.createChild("item_torso_armour","number").setValue(src.getChild("item_torso_armour").getValue());
	end
	if src.getChild("item_type") then
		dst.createChild("item_type","number").setValue(src.getChild("item_type").getValue());
	end
	if src.getChild("item_unfitted_max") then
		dst.createChild("item_unfitted_max","number").setValue(src.getChild("item_unfitted_max").getValue());
	end
	if src.getChild("item_unfitted_min") then
		dst.createChild("item_unfitted_min","number").setValue(src.getChild("item_unfitted_min").getValue());
	end
	if src.getChild("item_value") then
		dst.createChild("item_value","number").setValue(src.getChild("item_value").getValue());
	end
	if src.getChild("item_weight") then
		dst.createChild("item_weight","number").setValue(src.getChild("item_weight").getValue());
	else
		dst.createChild("item_weight","number").setvalue(0);
	end
	if src.getChild("name") then
		dst.createChild("name","string").setValue(src.getChild("name").getValue());
	else
		dst.createChild("name","string");
	end
	if src.getChild("nonidentified") then
		dst.createChild("nonidentified","string").setValue(src.getChild("nonidentified").getValue());
	end
	if src.getChild("ob_bonus") then
		dst.createChild("ob_bonus", "number").setValue(src.getChild("ob_bonus").getValue());
	end
	if src.getChild("pp_adder") then
		dst.createChild("pp_adder", "number").setValue(src.getChild("pp_adder").getValue());
	end
	if src.getChild("skillbonuses") then
		local bonnode = dst.createChild("skillbonuses");
		for k,skl in pairs(src.getChild("skillbonuses").getChildren()) do
			local curnode = bonnode.createChild(k);
			if skl.getChild("name") then
				curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
			end
			if skl.getChild("skill_bonus") then
				curnode.createChild("skill_bonus","number").setValue(skl.getChild("skill_bonus").getValue());
			end
		end
	end
	if src.getChild("spell_adder") then
		dst.createChild("spell_adder", "number").setValue(src.getChild("spell_adder").getValue());
	end
	if src.getChild("spells") then
		local splnode = dst.createChild("spells");
		if src.getChild("spells.charge") then
		local chgnode = splnode.createChild("charge");
			for k,skl in pairs(src.getChild("spells.charge").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("cost") then
					curnode.createChild("cost","number").setValue(skl.getChild("cost").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
			end
		local chgnode = splnode.createChild("daily");
			for k,skl in pairs(src.getChild("spells.daily").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
				if skl.getChild("uses_per_day") then
					curnode.createChild("uses_per_day","number").setValue(skl.getChild("uses_per_day").getValue());
				end
			end
		end
	end
	if src.getChild("true_value") then
		dst.createChild("true_value", "number").setValue(src.getChild("true_value").getValue());
	end
	return dst;
end

function copyConsumable(src, dst)

end

function copyGeneralItem(src, dst)
	if src.getChild("db_bonus") then
		dst.createChild("db_bonus","number").setValue(src.getChild("db_bonus").getValue());
	end
	if src.getChild("identified") then
		dst.createChild("identified","string").setValue(src.getChild("identified").getValue());
	end
	if src.getChild("int_insight") then
		dst.createChild("int_insight","number").setValue(src.getChild("int_insight").getValue());
	end
	if src.getChild("int_personality") then
		dst.createChild("int_personality","string").setValue(src.getChild("int_personality").getValue());
	end
	if src.getChild("int_presence") then
		dst.createChild("int_presence","number").setValue(src.getChild("int_presence").getValue());
	end
	if src.getChild("int_reasoning") then
		dst.createChild("int_reasoning","number").setValue(src.getChild("int_reasoning").getValue());
	end
	if src.getChild("int_selfdiscipline") then
		dst.createChild("int_selfdiscipline","number").setValue(src.getChild("int_selfdiscipline").getValue());
	end
	if src.getChild("int_willpower") then
		dst.createChild("int_willpower","number").setValue(src.getChild("int_willpower").getValue());
	end
	if src.getChild("isequipped") then
		dst.createChild("isequipped","number").setValue(src.getChild("isequipped").getValue());
	end
	if src.getChild("isidentified") then
		dst.createChild("isidentified","number").setValue(src.getChild("isidentified").getValue());
	end
	if src.getChild("isintelligent") then
		dst.createChild("isintelligent","number").setValue(src.getChild("isintelligent").getValue());
	end
	if src.getChild("item_charges") then
		dst.createChild("item_charges","number").setValue(src.getChild("item_charges").getValue());
	end
	if src.getChild("item_length") then
		dst.createChild("item_length","number").setValue(src.getChild("item_length").getValue());
	end
	if src.getChild("item_type") then
		dst.createChild("item_type","number").setValue(src.getChild("item_type").getValue());
	end
	if src.getChild("item_value") then
		dst.createChild("item_value","number").setValue(src.getChild("item_value").getValue());
	end
	if src.getChild("item_weight") then
		dst.createChild("item_weight","number").setValue(src.getChild("item_weight").getValue());
	else
		dst.createChild("item_weight","number").setvalue(0);
	end
	if src.getChild("name") then
		dst.createChild("name","string").setValue(src.getChild("name").getValue());
	else
		dst.createChild("name","string");
	end
	if src.getChild("nonidentified") then
		dst.createChild("nonidentified","string").setValue(src.getChild("nonidentified").getValue());
	end
	if src.getChild("ob_bonus") then
		dst.createChild("ob_bonus", "number").setValue(src.getChild("ob_bonus").getValue());
	end
	if src.getChild("pp_adder") then
		dst.createChild("pp_adder", "number").setValue(src.getChild("pp_adder").getValue());
	end
	if src.getChild("skillbonuses") then
		local bonnode = dst.createChild("skillbonuses");
		for k,skl in pairs(src.getChild("skillbonuses").getChildren()) do
			local curnode = bonnode.createChild(k);
			if skl.getChild("name") then
				curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
			end
			if skl.getChild("skill_bonus") then
				curnode.createChild("skill_bonus","number").setValue(skl.getChild("skill_bonus").getValue());
			end
		end
	end
	if src.getChild("spell_adder") then
		dst.createChild("spell_adder", "number").setValue(src.getChild("spell_adder").getValue());
	end
	if src.getChild("spells") then
		local splnode = dst.createChild("spells");
		if src.getChild("spells.charge") then
		local chgnode = splnode.createChild("charge");
			for k,skl in pairs(src.getChild("spells.charge").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("cost") then
					curnode.createChild("cost","number").setValue(skl.getChild("cost").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
			end
		local chgnode = splnode.createChild("daily");
			for k,skl in pairs(src.getChild("spells.daily").getChildren()) do
				local curnode = chgnode.createChild(k);
				if skl.getChild("name") then
					curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
				end
				if skl.getChild("cast_bonus") then
					curnode.createChild("cast_bonus","number").setValue(skl.getChild("cast_bonus").getValue());
				end
				if skl.getChild("description") then
					curnode.createChild("description","string").setValue(skl.getChild("description").getValue());
				end
				if skl.getChild("duration") then
					curnode.createChild("duration","string").setValue(skl.getChild("duration").getValue());
				end
				if skl.getChild("locked") then
					curnode.createChild("locked","number").setValue(skl.getChild("locked").getValue());
				end
				if skl.getChild("range") then
					curnode.createChild("range","string").setValue(skl.getChild("range").getValue());
				end
				if skl.getChild("resistance_roll") then
					curnode.createChild("resistance_roll","number").setValue(skl.getChild("resistance_roll").getValue());
				end
				if skl.getChild("resolution_table") then
					local tabnode = curnode.createChild("resolution_table");
					if skl.getChild("resolution_table.name") then
						tabnode.createChild("name","string").setValue(skl.getChild("resolution_table.name").getValue());
					end
					if skl.getChild("resolution_table.tableid") then
						tabnode.createChild("tableid","string").setValue(skl.getChild("resolution_table.tableid").getValue());
					end
				end
				if skl.getChild("size") then
					curnode.createChild("size","number").setValue(skl.getChild("size").getValue());
				end
				if skl.getChild("spell_type") then
					curnode.createChild("spell_type","number").setValue(skl.getChild("spell_type").getValue());
				end
				if skl.getChild("sphere") then
					curnode.createChild("sphere","string").setValue(skl.getChild("sphere").getValue());
				end
				if skl.getChild("uses_per_day") then
					curnode.createChild("uses_per_day","number").setValue(skl.getChild("uses_per_day").getValue());
				end
			end
		end
	end
	if src.getChild("true_value") then
		dst.createChild("true_value", "number").setValue(src.getChild("true_value").getValue());
	end
end