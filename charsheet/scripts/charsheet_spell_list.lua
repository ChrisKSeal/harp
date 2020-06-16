function addSpell(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();
  
  Utilities.copySpell(source,newnode);

  return newentry;
end

function onDrop(x, y, draginfo)
  if draginfo.isType("shortcut")  then
    local class = draginfo.getShortcutData();
    local source = draginfo.getDatabaseNode();
    if source and class == "spell" then
      addSpell(source);
    end
    return true;
  end
end

function onInit()
  -- Set menus
  resetMenuItems();
  registerMenuItem("New Spell","insert",5);
end

function onMenuSelection(item)
  if item and item==5 then
    local win = createWindow();
  end
end
