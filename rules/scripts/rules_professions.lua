
-- Get Profession List
function List()
	local professionList = {}; 
	local node;
	for i, module in ipairs(Module.getModules()) do
		node = DB.findNode("reference.professions@" .. module);
		if node then
			for j, prof in pairs(node.getChildren()) do
				table.insert(professionList, prof.getChild("name").getValue());
			end
		end
	end
	return professionList;
end
