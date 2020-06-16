-- Helper functions for items of all sorts

function buildSkillList()
	local skillList = {};
	for k,mod in pairs(Module.getModules()) do
		local node;
		node = DB.findNode("reference.skills.list@"..mod);
		if node then
			for k,skl in pairs(node.getChildren()) do
				if skl.getChild("name") then
					local skillname = skl.getChild("name").getValue();
					table.insert(skillList, skillname);	
				end
			end
		end
	end
	return skillList;
end

function buildSpellList()
	local skillList = {};
	for k,mod in pairs(Module.getModules()) do
		local node;
		node = DB.findNode("reference.spells.list@"..mod);
		if node then
			for k,skl in pairs(node.getChildren()) do
				if skl.getChild("name") then
					local skillname = skl.getChild("name").getValue();
					table.insert(skillList, skillname);	
				end
			end
		end
	end
	return skillList;
end
