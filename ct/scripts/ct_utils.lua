function copyCTAttack(attackType, src, dst)
	if src.getChild("name") then
		dst.createChild("name","string").setValue(src.getChild("name").getValue());
	end
	if src.getChild("obbonus") then
		dst.creatChild("obbonus", "number").setValue(src.getChild("obbonus").getValue());
	end
	if src.getChild("dbbonus") then
		dst.createChild("dbbonus","number").setValue(src.getChild("dbbonus").getValue());
	end
	if src.getChild("fumble") then
		dst.createChild("fumble", "number").setValue(src.getChild("fumble").getValue());
	end
	if src.getChild("attacktable") then
		local attknode = dst.createChild("attacktable");
		if src.getChild("attacktable.name") then
			attknode.createChild("name","string").setValue(src.getChild("attacktable.name").getValue());
		end
		if src.getChild("attacktable.tableid") then
			attknode.createChild("tableid","string").setValue(src.getChild("attacktable.tableid").getValue());
		end
	end
	if src.getChild("modifiers") then
		local modnode = dst.createChild("modifiers");
		for k, mod in pairs(src.getChild("modifiers").getChildren()) do
			if mod.getChild("name") then
				modnode.createChild("name","string").setValue(mod.getChild("name").getValue());
			end
			if mod.getChild("value") then
				modnode.createChild("value","number").setValue(mod.getChild("value").getValue());
			end
		end
	end
	if src.getChild("size") then
		dst.createChild("size","number").setValue(src.getChild("size").getValue());
	end
	if attackType == Rules_Constants.AttackType.Missile then
		if src.getChild("reload") then
			dst.createChild("reload","number").setValue(src.getChild("reload").getValue());
		end
		if src.getChild("rnginc") then
			dst.createChild("rnginc", "number").setValue(src.getChild("rnginc").getValue());
		end
		if src.getChild("pbrng") then
			dst.createChild("pbrng", "number").setValue(src.getChild("pbrng").getValue());
		end
		if src.getChild("pbbonus") then
			dst.createChild("pbbonus", "number").setValue(src.getChild("pbbonus").getValue());
		end
	end
	if attackType == Rules_Constants.AttackType.Spell or attackType == Rules_Constants.AttackType.ElSpell then
		if src.getChild("basecost") then
			dst.createChild("basecost","number").setValue(src.getChild("basecost").getValue());
		end
		if src.getChild("totpp") then
			dst.createChild("totpp","number").setValue(src.getChild("totpp").getValue());
		end
		if src.getChild("rectime") then
			dst.createChild("rectime","number").setValue(src.getChild("rectime").getValue());
		end
		if src.getChild("scaleopts") then
			local optnode = dst.createChild("scaleopts");
			for k, opt in pairs(src.getChild("scaleopts").getChildren()) do
				if opt.getChild("name") then
					optnode.createChild("name","string").setValue(opt.getChild("name").getValue());
				end
				if opt.getChild("extraPP") then
					optnode.createChild("extraPP","number").setValue(opt.getChild("extraPP").getValue());
				end
			end
		end	
	end
end