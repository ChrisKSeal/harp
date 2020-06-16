local categories = {};

local disableaction = false;

function rebuild()
	if disableaction then
		return;
	end
	disableaction = true;
	-- Set menus
	resetMenuItems();
	registerMenuItem("Create talent","insert",5);
	-- Resort
	applySort();
	-- done
	disableaction = false;
end

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	rebuild();
end

function onMenuSelection(item)
	if item and item==5 then
		local win = createWindow();
	end
end

function onSortCompare(w1, w2)
	return super.sortCompare(w1, w2);
end

function parseShortName()
	--[[ extract the stats and the skill name and specialization from the shortname control]]
	local s = shortname.getValue();
	local nm = "";
	nm = s;
	
		--[[ update the name, specialization and stat fields, if needed ]]
	if name.getValue()~=nm then
		name.setValue(nm);
	end
	--[[ done ]]
	return;
end