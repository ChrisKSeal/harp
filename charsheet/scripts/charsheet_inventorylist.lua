function addDefence(source, charnode)
	local combatnode = charnode.createChild("combat").createChild("defences").createChild();
  
	ItemManager.copyDefence(source,combatnode);
	
	local newentry = createWindow();
	local newnode = newentry.getDatabaseNode();
	
	newnode.createChild("name", "string").setValue(combatnode.getChild("name").getValue());
	newnode.createChild("item_class", "string").setValue("item_defence");
	newnode.createChild("item_link", "string").setValue(DB.getPath(combatnode));
	newnode.createChild("weight","number").setValue(combatnode.getChild("item_weight").getValue());

	return newentry;
end

function addWeapon(source, charnode)
	local combatnode = charnode.createChild("combat").createChild("weapons").createChild();
  
	ItemManager.copyWeapon(source,combatnode);
	
	local newentry = createWindow();
	local newnode = newentry.getDatabaseNode();
	
	newnode.createChild("name", "string").setValue(combatnode.getChild("name").getValue());
	newnode.createChild("item_class", "string").setValue("item_weapon");
	newnode.createChild("item_link", "string").setValue(DB.getPath(combatnode));
	newnode.createChild("weight","number").setValue(combatnode.getChild("item_weight").getValue());

	return newentry;
end

function addConsumable(source, charnode)
	local combatnode = charnode.createChild("items").createChild("consumables").createChild();
  
	ItemManager.copyConsumable(source,combatnode);
	
	local newentry = createWindow();
	local newnode = newentry.getDatabaseNode();
	
	newnode.createChild("name", "string").setValue(combatnode.getChild("name").getValue());
	newnode.createChild("item_class", "string").setValue("item_consumable");
	newnode.createChild("item_link", "string").setValue(DB.getPath(combatnode));
	newnode.createChild("weight","number").setValue(combatnode.getChild("item_weight").getValue());

	return newentry;
end

function addGeneralItem(source, charnode)
	local combatnode = charnode.createChild("items").createChild("general").createChild();
  
	ItemManager.copyGeneralItem(source,combatnode);
	
	local newentry = createWindow();
	local newnode = newentry.getDatabaseNode();
	
	newnode.createChild("name", "string").setValue(combatnode.getChild("name").getValue());
	newnode.createChild("item_class", "string").setValue("item_general");
	newnode.createChild("item_link", "string").setValue(DB.getPath(combatnode));
	newnode.createChild("weight","number").setValue(combatnode.getChild("item_weight").getValue());

	return newentry;
end

function onDrop(x, y, draginfo)
	local charnode = getDatabaseNode().getParent().getParent();
	if draginfo.isType("shortcut")  then
		local class = draginfo.getShortcutData();
		local source = draginfo.getDatabaseNode();
		if source and class == "item_weapon" then
			addWeapon(source, charnode);
		end
		if source and class == "item_defence" then
			addDefence(source, charnode);
		end
		if source and class == "item_consumable" then
			addConsumable(source, charnode);
		end
		if source and class == "item_general" then
			addGeneralItem(source, charnode);
		end
		return true;
	end
end

function onInit()
  -- Set menus
  resetMenuItems();
  registerMenuItem("New item","insert",5);
end

function onMenuSelection(item)
	if item and item==5 then
		local charnode = getDatabaseNode().getParent().getParent();
		newItem(charnode);
	end
end

function newItem(charnode)
	local inventorynode = charnode.createChild("items").createChild("general").createChild();
	
	local win = createWindow();
	local newnode = win.getDatabaseNode();
	newnode.createChild("item_class","string").setValue("item_general");
	newnode.createChild("item_link","string").setValue(DB.getPath(inventorynode));
	return win;
end