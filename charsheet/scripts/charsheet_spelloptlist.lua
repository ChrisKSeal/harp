function addScaleOpt(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();

  return newentry;
end

function onInit()
  -- Set menus
  resetMenuItems();
  registerMenuItem("New Scaling Option","insert",5);
end

function onMenuSelection(item)
  if item and item==5 then
    local win = createWindow();
    win.ismultiple.setState(1);
  end
end

