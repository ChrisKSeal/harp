function addShield(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();
  
  Utilities.copyShield(source,newnode);

  -- Default use (not equipped)
  newnode.createChild("isequipped","number").setValue(1);
  newnode.createChild("isFitted", "number").setValue(1); -- Default Armour is unfitted

  return newentry;
end

function onDrop(x, y, draginfo)
  if draginfo.isType("shortcut")  then
    local class = draginfo.getShortcutData();
    local source = draginfo.getDatabaseNode();
    if source and class == "shield" then
      addShield(source);
    end
    return true;
  end
end

function onInit()
  -- Set menus
  resetMenuItems();
  registerMenuItem("New Shield","insert",5);
end

function onMenuSelection(item)
  if item and item==5 then
    local win = createWindow();
    win.type.setState(1);
  end
end

