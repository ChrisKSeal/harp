
function rebuild()
	if disableaction then
		return;
	end
	disableaction = true;
	-- Set menus
	resetMenuItems();
	registerMenuItem("Create Bound Spell","insert",5);
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