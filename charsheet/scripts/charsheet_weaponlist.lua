function addWeapon(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();
  
  Utilities.copyWeapon(source,newnode);

  -- Default use (not equipped)
  newnode.createChild("isequipped","number").setValue(1);

  return newentry;
end

function onDrop(x, y, draginfo)
  if draginfo.isType("shortcut")  then
    local class = draginfo.getShortcutData();
    local source = draginfo.getDatabaseNode();
    if source and class == "weapon" then
      addWeapon(source);
    end
    return true;
  end
end

function onInit()
  -- Set menus
  resetMenuItems();
  registerMenuItem("New Weapon","insert",5);
end

function onMenuSelection(item)
  if item and item==5 then
    local win = createWindow();
  end
end

