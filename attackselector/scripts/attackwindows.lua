function onInit()
	if super and super.onInit then
		super.onInit();
	end
	window.primary_weapon.setVisible(false);
	window.primary_weapon.setEnabled(false);
	window.primary_weapon_label.setVisible(false);
	window.secondary_weapon.setVisible(false);
	window.secondary_weapon.setEnabled(false);
	window.secondary_weapon_label.setVisible(false);
	window.combat_error.setEnabled(false);
	window.combat_error.setVisible(false);
end
				
function setMeleeWeapon()
	Debug.chat("Setting Weapons");
	local node = DB.findNode(window.attacknode.getValue()).getParent().getParent();
	Debug.chat(node);
	local weaponTab = AttackManager.getWeapon(node);
	Debug.chat(weaponTab);
	Debug.chat(AttackManager.isWeapon(node, name));
	--if AttackManager.isWeapon(node, name) then
	if weaponTab ~= {} then
		Debug.chat("Non-zero weaponTab");
		setValue(weaponTab.name);
		local rng1Flg = AttackManager.isRanged(weaponTab.category1); 
		window.cast_button.setVisible(false);
		window.cast_button.setEnabled(false);
		if weaponTab.multiattack == 1 then
			window.primary_weapon.setVisible(true);
			window.primary_weapon.setEnabled(true);
			window.primary_weapon_label.setVisible(true);
			window.secondary_weapon.setVisible(true);
			window.secondary_weapon.setEnabled(true);
			window.secondary_weapon_label.setVisible(true);
			if window.primary_weapon.getState() then
				if rng1Flg then
					window.charge_distance_label.setVisible(false);
					window.charge_distance.setVisible(false);
					window.charge_distance.setEnabled(false);
					window.pb_bonus.setValue(weaponTab.pbbonus1);
					window.pb_range.setValue(weaponTab.pbrng1);
					window.range_inc.setValue(weaponTab.rnginc1);
					window.reload.setValue(weaponTab.reload1);
				end
				window.primary_weapon.setState(true);
				window.associated_skill.setValue(weaponTab.skill1);
				window.fumble.setValue(weaponTab.fumble1);
				window.skill_bonus.setValue(weaponTab.ob1);
				window.size.setState(weaponTab.size1);
				window.meleeLabel.setVisible(not rng1Flg);
				window.meleeLabel.setEnabled(not rng1Flg);
				window.rangedLabel.setVisible(rng1Flg);
				window.rangedLabel.setEnabled(rng1Flg);
				window.combat_action.setVisible(not rng1Flg);
				window.combat_action.setEnabled(not rng1Flg);
				window.combat_action_label.setVisible(not rng1Flg);
				window.combat_action_label.setEnabled(not rng1Flg);
				window.combat_action_dropdown.setVisible(not rng1Flg);
				window.combat_action_dropdown.setEnabled(not rng1Flg);
				window.weapon_class.setState(weaponTab.category1);
				window.pb_bonus.setVisible(rng1Flg);
				window.pb_bonus.setEnabled(rng1Flg);
				window.pb_bonus_label.setVisible(rng1Flg);
				window.pb_range.setVisible(rng1Flg);
				window.pb_range.setEnabled(rng1Flg);
				window.pb_label.setVisible(rng1Flg);
				window.range_inc.setVisible(rng1Flg);
				window.range_inc.setEnabled(rng1Flg);
				window.range_inc_label.setVisible(rng1Flg);
				window.reload_label.setVisible(rng1Flg);
				window.reload.setVisible(rng1Flg);
				window.reload.setEnabled(rng1Flg);
				window.table.setValue(weaponTab.tableid,weaponTab.table)
			else
				local rng2Flg = AttackManager.isRanged(weaponTab.category2); 
				if rng2Flg then
					window.charge_distance_label.setVisible(false);
					window.charge_distance.setVisible(false);
					window.charge_distance.setEnabled(false);
					window.pb_bonus.setValue(weaponTab.pbbonus2);
					window.pb_range.setValue(weaponTab.pbrng2);
					window.range_inc.setValue(weaponTab.rnginc2);
					window.reload.setValue(weaponTab.reload2);
				end
				window.primary_weapon.setState(false);
				window.associated_skill.setValue(weaponTab.skill2);
				window.skill_bonus.setValue(weaponTab.ob2);
				window.fumble.setValue(weaponTab.fumble2);
				window.size.setState(weaponTab.size2);
				window.meleeLabel.setVisible(not rng2Flg);
				window.meleeLabel.setEnabled(not rng2Flg);
				window.rangedLabel.setVisible(rng2Flg);
				window.rangedLabel.setEnabled(rng2Flg);
				window.combat_action.setVisible(not rng2Flg);
				window.combat_action.setEnabled(not rng2Flg);
				window.combat_action_label.setVisible(not rng2Flg);
				window.combat_action_label.setEnabled(not rng2Flg);
				window.combat_action_dropdown.setVisible(not rng2Flg);
				window.combat_action_dropdown.setEnabled(not rng2Flg);
				window.weapon_class.setState(weaponTab.category2);
				window.pb_bonus.setVisible(rng2Flg);
				window.pb_bonus.setEnabled(rng2Flg);
				window.pb_bonus_label.setVisible(rng2Flg);
				window.pb_range.setVisible(rng2Flg);
				window.pb_range.setEnabled(rng2Flg);
				window.pb_label.setVisible(rng2Flg);
				window.range_inc.setVisible(rng2Flg);
				window.range_inc.setEnabled(rng2Flg);
				window.range_inc_label.setVisible(rng2Flg);
				window.reload_label.setVisible(rng2Flg);
				window.reload.setVisible(rng2Flg);
				window.reload.setEnabled(rng2Flg);
				window.table.setValue(weaponTab.tableid2,weaponTab.table2)
			end
		else
			window.primary_weapon.setVisible(false);
			window.primary_weapon.setEnabled(false);
			window.primary_weapon_label.setVisible(false);
			window.secondary_weapon.setVisible(false);
			window.secondary_weapon.setEnabled(false);
			window.secondary_weapon_label.setVisible(false);
			window.primary_weapon.setState(true);
			window.associated_skill.setValue(weaponTab.skill1);
			window.skill_bonus.setValue(weaponTab.ob1);
			window.fumble.setValue(weaponTab.fumble1);
			window.size.setState(weaponTab.size1);
			window.meleeLabel.setVisible(not rng1Flg);
			window.meleeLabel.setEnabled(not rng1Flg);
			window.rangedLabel.setVisible(rng1Flg);
			window.rangedLabel.setEnabled(rng1Flg);
			window.combat_action.setVisible(not rng1Flg);
			window.combat_action.setEnabled(not rng1Flg);
			window.combat_action_label.setVisible(not rng1Flg);
			window.combat_action_label.setEnabled(not rng1Flg);
			window.combat_action_dropdown.setVisible(not rng1Flg);
			window.combat_action_dropdown.setEnabled(not rng1Flg);
			window.weapon_class.setState(weaponTab.category1);
			window.pb_bonus.setVisible(rng1Flg);
			window.pb_bonus.setEnabled(rng1Flg);
			window.pb_bonus_label.setVisible(rng1Flg);
			window.pb_range.setVisible(rng1Flg);
			window.pb_range.setEnabled(rng1Flg);
			window.pb_label.setVisible(rng1Flg);
			window.range_inc.setVisible(rng1Flg);
			window.range_inc.setEnabled(rng1Flg);
			window.range_inc_label.setVisible(rng1Flg);
			window.reload_label.setVisible(rng1Flg);
			window.reload.setVisible(rng1Flg);
			window.reload.setEnabled(rng1Flg);
			window.table.setValue(weaponTab.tableid,weaponTab.table)
		end
		window.spellLabel.setVisible(false);
		window.spellLabel.setEnabled(false);
		window.base_cost.setEnabled(false);
		window.base_cost.setVisible(false);
		window.base_cost_label.setVisible(false);
		window.ob_label.setVisible(true);
		window.ob_bonus.setVisible(true);
		window.ob_bonus.setValue(weaponTab.obbonus);
		window.db_label.setVisible(true);
		window.db_bonus.setVisible(true);
		window.db_bonus.setValue(weaponTab.dbbonus);
		window.weapon_class.setVisible(true);
		window.weapon_class_label.setVisible(true);
		window.pp_add.setVisible(false);
		window.pp_add.setEnabled(false);
		window.pp_add_label.setVisible(false);
		window.opts_cost_label.setVisible(false);
		window.opts_name_label.setVisible(false);
		window.opts_times_label.setVisible(false);
		window.opts_used_label.setVisible(false);
		window.scaleopts.setVisible(false);
		window.total_cost.setVisible(false);
		window.total_cost.setEnabled(false);
		window.total_cost_label.setVisible(false);
		window.rec_time.setVisible(false);
		window.rec_time.setEnabled(false);
		window.rec_time_label.setVisible(false);
		window.cast_time.setVisible(false);
		window.cast_time.setEnabled(false);
		window.cast_time_label.setVisible(false);
	end
	--end
end
				
function setSpell()
	Debug.chat("Setting Spells");
	local node = DB.findNode(window.attacknode.getValue());
	window.fumble.setValue(5);
	window.cast_button.setVisible(true);
	window.cast_button.setEnabled(true);
	window.ctbutton.setEnabled(true);
					local charnode = window.getDatabaseNode().getParent();
					local name = getValue();
					window.scaleopts.clear();
					if charnode.getChild("spells") then
						for k, spl in pairs(charnode.getChild("spells").getChildren()) do
							local testname = spl.createChild("name").getValue();
							if testname == name then
								local basecost = spl.createChild("ppcost").getValue();
								window.base_cost.setValue(basecost);
								local class = spl.createChild("class").getValue();
								if class == 1 then
									window.spellLabel.setValue("Utility Spell");
								elseif class == 2 then
									window.spellLabel.setValue("Attack Spell");
								else
									window.spellLabel.setValue("Elemental Attack Spell");
								end
								window.table.setValue(spl.createChild("spelltable.tableid").getValue(),spl.createChild("spelltable.name").getValue());
								window.size.setState(spl.createChild("size").getValue());
								if spl.getChild("scaleopts") then
									for l, opt in pairs(spl.getChild("scaleopts").getChildren()) do
										window.scaleopts.addScaleOpt(opt);
									end
								end
							
								local skillname = spl.createChild("associatedskill").getValue();
								if charnode.getChild("skills") then
									for l, skl in pairs(charnode.getChild("skills").getChildren()) do
										local testskillname = skl.createChild("name").getValue();
										if testskillname == skillname then
											window.skill_bonus.setValue(skl.createChild("total").getValue());
											window.associated_skill.setValue(skillname);
										end
									end
								end
							end
						end
					end
					window.primary_weapon.setVisible(false);
					window.primary_weapon.setEnabled(false);
					window.primary_weapon_label.setVisible(false);
					window.secondary_weapon.setVisible(false);
					window.secondary_weapon.setEnabled(false);
					window.secondary_weapon_label.setVisible(false);
					window.primary_weapon.setState(true);
					window.spellLabel.setVisible(true);
					window.spellLabel.setEnabled(true);
					window.meleeLabel.setVisible(false);
					window.meleeLabel.setEnabled(false);
					window.rangedLabel.setVisible(false);
					window.rangedLabel.setEnabled(false);
					window.combat_action.setVisible(false);
					window.combat_action.setEnabled(false);
					window.combat_action_label.setVisible(false);
					window.combat_action_label.setEnabled(false);
					window.combat_action_dropdown.setVisible(false);
					window.combat_action_dropdown.setEnabled(false);
					window.ob_label.setVisible(false);
					window.ob_bonus.setVisible(false);
					window.ob_bonus.setEnabled(false);
					window.db_label.setVisible(false);
					window.db_bonus.setVisible(false);
					window.db_bonus.setEnabled(false);
					window.charge_distance_label.setVisible(false);
					window.charge_distance.setVisible(false);
					window.charge_distance.setEnabled(false);
					window.weapon_class.setVisible(false);
					window.weapon_class_label.setVisible(false);
					window.base_cost.setEnabled(true);
					window.base_cost.setVisible(true);
					window.base_cost_label.setVisible(true);
					window.pp_add.setVisible(true);
					window.pp_add.setEnabled(true);
					window.pp_add_label.setVisible(true);
					window.opts_cost_label.setVisible(true);
					window.opts_name_label.setVisible(true);
					window.opts_times_label.setVisible(true);
					window.opts_used_label.setVisible(true);
					window.scaleopts.setVisible(true);
					window.total_cost.setVisible(true);
					window.total_cost.setEnabled(true);
					window.total_cost_label.setVisible(true);
					window.rec_time.setVisible(true);
					window.rec_time.setEnabled(true);
					window.rec_time_label.setVisible(true);
					window.cast_time.setVisible(true);
					window.cast_time.setEnabled(true);
					window.cast_time_label.setVisible(true);
					window.pb_bonus.setVisible(false);
					window.pb_bonus.setEnabled(false);
					window.pb_bonus_label.setVisible(false);
					window.pb_range.setVisible(false);
					window.pb_range.setEnabled(false);
					window.pb_label.setVisible(false);
					window.range_inc.setVisible(false);
					window.range_inc.setEnabled(false);
					window.range_inc_label.setVisible(false);
					window.reload_label.setVisible(false);
					window.reload.setVisible(false);
					window.reload.setEnabled(false);
				end
					 
function update()
Debug.chat("Update function");
	local node = window.getDatabaseNode().getParent();
	Debug.chat(node);
	local name = DB.findNode(window.attacknode.getValue()).getChild("name").getValue();
	Debug.chat(name);
	setValue(name);
	Debug.chat(AttackManager.isWeapon(node, name));
	if AttackManager.isWeapon(node, name) then
		setMeleeWeapon();
		window.attackorspell.setValue(1);
	else
		setSpell();
		window.attackorspell.setValue(0); 
	end
	window.armour_penalty.refresh();
end