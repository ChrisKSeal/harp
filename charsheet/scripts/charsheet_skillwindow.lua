function getCategory()
	local skilltype = group.getValue();
	if group.getValue()~=0 then
		local grpstring = "";
		local cat = group.getValue();
		if cat == 1 then
		  grpstring = "Artistic";
		elseif cat ==2 then
		  grpstring = "Athletic";
		elseif cat ==3 then
		  grpstring = "Combat";
		elseif cat ==4 then
		  grpstring = "Concentration";
		elseif cat ==5 then
		  grpstring = "General";
		elseif cat ==6 then
		  grpstring = "Influence";
		elseif cat ==7 then
		  grpstring = "Mystical Arts";
		elseif cat ==8 then
		  grpstring = "Outdoor";
		elseif cat ==9 then
		  grpstring = "Physical";
		elseif cat ==10 then
		  grpstring = "Spells";
		elseif cat ==11 then
		  grpstring = "Subterfuge";
		end
		return grpstring;
	end
end

function rollSkill()
Debug.chat(group.getValue());
Debug.chat(getDatabaseNode().getNodeName());
	Rules_Skills.Roll(group.getValue(), getDatabaseNode().getNodeName());
	
end

function dragSkill(button, x, y, draginfo)
	return Rules_Skills.Drag(draginfo, group.getValue(), name.getValue(), getDatabaseNode().getNodeName());
end

local initialised = false;

function refresh()
	local rnk = rank.getValue();
	--[[ Don't proceed if the window isn't fully initialised ]]
	if not initialised then
		return;
	end
	--[[ Get the bonus from all applicable stats ]]
	local charNode = getDatabaseNode().getParent().getParent();
	statbonus.setValue(Rules_PC.CombinedStatBonus(charNode, stats.getValue()));
	--[[ Set the rank bonus, if needed ]]
		local rkbn = getRankBonus(rnk);
		rankbonus.setReadOnly(true);
		rankbonus.setFrame(nil);
		total.setReadOnly(true);
		total.setFrame(nil);
		rankbonus.setValue(rkbn);
		total.setValue(rkbn + statbonus.getValue() + level.getValue() +
					   item.getValue() + special.getValue() + misc.getValue());

	shortname.update();
	setMenus();
end

function getRankBonus(rank)
	return Rules_Skills.RankBonus(rank);
end

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	name.getDatabaseNode().onUpdate = refresh;
	--specialization.getDatabaseNode().onUpdate = refresh;
	stats.getDatabaseNode().onUpdate = refresh;
	rank.getDatabaseNode().onUpdate = refresh;
	item.getDatabaseNode().onUpdate = refresh;
	special.getDatabaseNode().onUpdate = refresh;
	misc.getDatabaseNode().onUpdate = refresh;
	windowlist.window.getDatabaseNode().getChild(".abilities").onChildUpdate = refresh;

	-- done
	initialised = true;
	refresh();
end
          
function setLocked(state)
	if state then
		locked.setValue(1);
	else
		locked.setValue(0);
	end
end

function setMenus()
	resetMenuItems();
	if isLocked() then
		-- unlock skill menu item
		registerMenuItem("Unlock skill","unlock",8);
	else
		-- lock skill menu item
		registerMenuItem("Lock skill","lock",8);
		-- delete menu item
		registerMenuItem("Delete Skill","delete",6);
	end
end

function isLocked()
	return (locked.getValue()~=0);
end

function onMenuSelection(item)
	if item then
		if item==8 then
			setLocked(not isLocked());
		elseif item==6 then
			getDatabaseNode().delete();
		end
	end
end

function parseShortName()
	--[[ extract the stats and the skill name and specialization from the shortname control]]
	local s = shortname.getValue();
	local locParenStart = string.find(s,"(",1,true);
	local locBracketStart = string.find(s, "[", 1, true);

	local nm = "";
	local spec = "";
	local sts = "";

	--[[ extract the stats from the skill name ]]
	if locParenStart and locParenStart > 0 then
		local locParenEnd = string.find(s,")",locParenStart+1,true);
		if locParenEnd and locParenEnd > 0 then
			sts = string.sub(s,locParenStart+1,locParenEnd-1);
		else
			sts = string.sub(s,locParenStart+1);
		end
		nm = string.gsub(string.sub(s,1,locParenStart-1),"%s+$","");
	else
		nm = s;
		sts = "";
	end

	--[[ extract the skill specialization from the skill name ]]
	if locBracketStart and locBracketStart > 0 then
		local locBracketEnd = string.find(s,"]",locBracketStart+1,true);
		if locBracketEnd and locBracketEnd > 0 then
			spec = string.sub(s,locBracketStart+1,locBracketEnd-1);
		else
			spec = string.sub(s,locBracketStart+1);
		end
		nm = string.gsub(string.sub(s,1,locBracketStart-1),"%s+$","");
	else
		nm = s;
		spec = "";
	end

	--[[ update the name, specialization and stat fields, if needed ]]
	if name.getValue()~=nm then
		name.setValue(nm);
	end
	if specialization.getValue()~=nm then
		specialization.setValue(nm);
	end
	if stats.getValue()~=sts then
		stats.setValue(sts);
	end
	
	--[[ done ]]
	return;
end

function testDelete()
	local win = windowlist.getPrevWindow(self);
	if shortname.getValue()~="" then
		return;
	end
	if #(windowlist.getWindows())==1 then
		return;
	end
	if not win then
		win = windowlist.getNextWindow(self);
	end
	win.shortname.setFocus();
	getDatabaseNode().delete();
end

function testNew()
	local win = windowlist.getNextWindow(self);
	if shortname.getValue()=="" then
		return;
	end
	if not win then
		win = windowlist.createWindow();
	end
	win.shortname.setFocus();
end
