function Drag(draginfo, talent, nodepath)
	-- copy talent name and path
	draginfo.setDescription(talent);
	draginfo.setStringData(nodepath);
	return true;
end

function TalentCost(TalentName)
  for k,mod in pairs(Module.getModules()) do
    local node;
    -- Skills
    node = DB.findNode("reference.talentlist.talents.list@"..mod);
    if node then
      for k,skl in pairs(node.getChildren()) do
        if skl.getChild("name") and skl.getChild("name").getValue()==SkillName then
          if skl.getChild("cost") then
            return skl.getChild("cost").getValue();
          end
        end
      end
    end
  end
  -- not found
  return ""
end
