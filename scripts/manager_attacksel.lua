function isWeapon(node, name)
	local flag=false;
	if node.getChild("weapons") then
		for k, wpn in pairs(node.getChild("weapons").getChildren()) do
			if wpn.getChild("name") then
				if name == wpn.createChild("name").getValue() then
					flag=true;
				end
			end
		end 
	end
	return flag;
end

function isRanged(weaponclass)
	local retval = false;
	if weaponclass > 6 and weaponclass < 13 then
		retval = true;
	elseif weaponclass > 17 then
		retval = true;
	else
		retval = false;
	end
	return retval;
end

function getWeapon(weaponNode)
	local weaponTab = {};
	if weaponNode.getChild("multiattack") then
			weaponTab.multiattack = weaponNode.getChild("multiattack").getValue();
		end
		weaponTab.name = weaponNode.getChild("name").getValue();
		if weaponNode.getChild("class") then
			weaponTab.class = weaponNode.getChild("class").getValue();
		end
		if weaponNode.getChild("dbbonus") then
			weaponTab.dbbonus = weaponNode.getChild("dbbonus").getValue();
		end
		if weaponNode.getChild("obbonus") then
			weaponTab.obbonus = weaponNode.getChild("obbonus").getValue();
		end
		if weaponNode.getChild("associatedskill1") then
			weaponTab.skill1 = weaponNode.getChild("associatedskill1").getValue();
		end
		if weaponNode.getChild("attacktable") then
			if weaponNode.getChild("attacktable.name") then
				weaponTab.table = weaponNode.getChild("attacktable.name").getValue();
				weaponTab.tableid = weaponNode.getChild("attacktable.tableid").getValue();
			end
		end
		if weaponNode.getChild("category1") then
			weaponTab.category1 = weaponNode.getChild("category1").getValue();
		end
		if weaponNode.getChild("fumble1") then
			weaponTab.fumble1 = weaponNode.getChild("fumble1").getValue();
		end
		if weaponNode.getChild("ob1") then
			weaponTab.ob1 = weaponNode.getChild("ob1").getValue();
		end
		if weaponNode.getChild("size1") then
			weaponTab.size1 = weaponNode.getChild("size1").getValue();
		end
		if weaponNode.getChild("pbbonus1") then
			weaponTab.pbbonus1 = weaponNode.getChild("pbbonus1").getValue();
		end
		if weaponNode.getChild("pbrng1") then
			weaponTab.pbrng1 = weaponNode.getChild("pbrng1").getValue();
		end
		if weaponNode.getChild("rnginc1") then
			weaponTab.rnginc1 = weaponNode.getChild("rnginc1").getValue();
		end
		if weaponNode.getChild("reload1") then
			weaponTab.reload1 = weaponNode.getChild("reload1").getValue();
		end
		if weaponTab.multiattack == 1 then
			if weaponNode.getChild("associatedskill2") then
				weaponTab.skill2 = weaponNode.getChild("associatedskill2").getValue();
			end
			if weaponNode.getChild("attacktable2.name") then
				weaponTab.table2 = weaponNode.getChild("attacktable2.name").getValue();
				weaponTab.tableid2 = weaponNode.getChild("attacktable2.tableid").getValue();
			end
			if weaponNode.getChild("category2") then
				weaponTab.category2 = weaponNode.getChild("category2").getValue();
			end
			if weaponNode.getChild("fumble2") then
				weaponTab.fumble2 = weaponNode.getChild("fumble2").getValue();
			end
			if weaponNode.getChild("ob2") then
				weaponTab.ob2 = weaponNode.getChild("ob2").getValue();
			end
			if weaponNode.getChild("size2") then
				weaponTab.size2 = weaponNode.getChild("size2").getValue();
			end
			if weaponNode.getChild("pbbonus2") then
				weaponTab.pbbonus2 = weaponNode.getChild("pbbonus2").getValue();
			end
			if weaponNode.getChild("pbrng2") then
				weaponTab.pbrng2 = weaponNode.getChild("pbrng2").getValue();
			end
			if weaponNode.getChild("rnginc2") then
				weaponTab.rnginc2 = weaponNode.getChild("rnginc2").getValue();
			end
			if weaponNode.getChild("reload2") then
				weaponTab.reload2 = weaponNode.getChild("reload2").getValue();
			end
		end
	return weaponTab;
end