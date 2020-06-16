function isBlank()
  if description.getValue()~="" then
    return false;
  end
  if penalty.getValue()~=0 then
    return false;
  end
  if duration.getValue()~=0 then
    return false;
  end
  if bleeding.getValue()~=0 then
    return false;
  end
  if stunned.getValue()~=0 then
    return false;
  end
  return true;
end

function isSummary()
  return (summary.getValue()~=0);
end

function setSummary(state)
  if state then
    description.setFrame(nil);
    description.setReadOnly(true);
    penalty.setFrame(nil);
    penalty.setReadOnly(true);
    duration.setFrame(nil);
    duration.setReadOnly(true);
    bleeding.setFrame(nil);
    bleeding.setReadOnly(true);
    stunned.setFrame(nil);
    stunned.setReadOnly(true);
    summary.setValue(1);
    resetMenuItems();
  else
    summary.setValue(0);
    if getDatabaseNode().isOwner() then
      registerMenuItem("Delete effect","delete",6);
    end
  end
  windowlist.applyFilter();
end

function onMenuSelection(item)
  if not getDatabaseNode().isOwner() then
    return true;
  end
  if item and not isSummary() then
    if item==6 then
      local win = windowlist.getNextWindow(self);
      if not win then
        win = windowlist.getPrevWindow(self);
      end
      if win then
        local len = string.len(win.description.getValue());
        win.description.setFocus();
        win.description.setCursorPosition(len+1);
        win.description.setSelectionPosition(len+1);
      end
      getDatabaseNode().delete();
    end
  end
  return true;
end

function deleteDown()
  if not getDatabaseNode().isOwner() or isSummary() then
    return true;
  end
  if #(windowlist.getWindows()) > 1 and description.getValue()=="" then
    local win = windowlist.getNextWindow(self);
    if not win then
      win = windowlist.getPrevWindow(self);
    end
    if win then
      local len = string.len(win.description.getValue());
      win.description.setFocus();
      win.description.setCursorPosition(len+1);
      win.description.setSelectionPosition(len+1);
    end
    getDatabaseNode().delete();
  end
  return true;
end

function deleteUp()
  if not getDatabaseNode().isOwner() or isSummary() then
    return true;
  end
  if #(windowlist.getWindows()) > 1 and description.getValue()=="" then
    local win = windowlist.getPrevWindow(self);
    if not win then
      win = windowlist.getNextWindow(self);
    end
    if win then
      local len = string.len(win.description.getValue());
      win.description.setFocus();
      win.description.setCursorPosition(len+1);
      win.description.setSelectionPosition(len+1);
    end
    getDatabaseNode().delete();
  end
  return true;
end

function testNew()
  if not windowlist.window.getDatabaseNode().isOwner() then
    return true;
  end
  if description.getValue()~="" then
    local win = windowlist.createWindow();
    windowlist.setExpanded(true);
    win.description.setFocus();
  end
end

function onDrop(...)
  return windowlist.onDrop(...);
end
