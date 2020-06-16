local categories = {};
local dropnode = nil;

function getSource()
	local src = dropnode;
	dropnode = nil;
	return src;
end

function isGrouped()
	local node = window.getDatabaseNode().createChild("grouped","number");
	return (node.getValue()~=0);
end

function setGrouped(state)
	local node = window.getDatabaseNode().createChild("grouped","number");
	if state then
		node.setValue(1);
	else
		node.setValue(0);
	end
	rebuild();
end

function getSkill(name)
	for i,skl in ipairs(getWindows()) do
		if skl.fullname and skl.fullname.getValue()==name then
			return skl;
		end
	end
	return nil;
end

local disableaction = false;

function rebuild()
	if disableaction then
		return;
	end
	disableaction = true;
	-- Close all category headings
	for k,catwin in pairs(categories) do
		catwin.close();
	end
	categories = {};
	-- Set menus
	resetMenuItems();
	registerMenuItem("Create Skill","insert",5);
	if isGrouped() then
		registerMenuItem("Ungroup","ungroup",4);
	else
		registerMenuItem("Group","group",4);
	end
	-- Create new category headings?
	if isGrouped() then
		for k,v in ipairs(getWindows()) do
			if v.getCategory then
				local category = v.getCategory();
				if not categories[category] then
					-- Create category header
					local win = createWindowWithClass("charsheet_skillcategory");
					win.name.setValue(category);
					categories[category] = win;
				end
			end
		end
	end
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
		win.group.setValue(5);
	elseif item and item==4 then
		setGrouped(not isGrouped());
	end
end

function onSortCompare(w1, w2)
	local category1, category2;
	local iscategory1, iscategory2;
	-- 'normal' case
	if not isGrouped() then
		return super.sortCompare(w1, w2);
	end
	-- Get window properties
	if w1.getClass() == "charsheet_skillcategory" then
		category1 = w1.name.getValue();
		iscategory1 = true;
	else
		if w1.getCategory then
			category1 = w1.getCategory();
		end
		iscategory1 = false;
	end
	if w2.getClass() == "charsheet_skillcategory" then
		category2 = w2.name.getValue();
		iscategory2 = true;
	else
		if w2.getCategory then
			category2 = w2.getCategory();
		end
		iscategory2 = false;
	end
	if category1 == category2 then
		if iscategory1 then
			return false;
		elseif iscategory2 then
			return true;
		else
			return super.sortCompare(w1, w2);
		end
	else
		return category1 > category2;
	end
end

function onListRearranged(changed)
	-- Only rebuild if the skills aren't grouped - avoids constant rebuild loop.
	if  not isGrouped() then
		rebuild();
	end
end