function dragTalent(button, x, y, draginfo)
	return Rules_Talents.Drag(draginfo, name.getValue(), getDatabaseNode().getNodeName());
end

local initialised = false;

function refresh()
	if not initialised then
		return;
	end
	--[[ Get the bonus from all applicable stats ]]
	local charNode = getDatabaseNode().getParent().getParent();
	--name.update();
	shortname.update();
	setMenus();
end

function onInit()
	if super and super.onInit then
		super.onInit();
	end

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
		registerMenuItem("Unlock Talent","unlock",8);
	else
		-- lock skill menu item
		registerMenuItem("Lock Talent","lock",8);
		-- delete menu item
		registerMenuItem("Delete Talent","delete",6);
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

function testDelete()
	local win = windowlist.getPrevWindow(self);
	if name.getValue()~="" then
		return;
	end
	if #(windowlist.getWindows())==1 then
		return;
	end
	if not win then
		win = windowlist.getNextWindow(self);
	end
	win.name.setFocus();
	getDatabaseNode().delete();
end

function testNew()
	local win = windowlist.getNextWindow(self);
	if name.getValue()=="" then
		return;
	end
	if not win then
		win = windowlist.createWindow();
	end
	win.name.setFocus();
	refresh();
end

