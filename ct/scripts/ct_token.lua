querywidget = nil;

local ref = nil;

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  querywidget = addBitmapWidget("indicator_query");
end

-- token targeting

function refTargeted()
  local ids = ref.getTargetingIdentities();
  setTargets(ids);
end

local targets = {};

function setTargets(idlist)
  local targetpath = window.getDatabaseNode().getNodeName();
  for id,data in pairs(targets) do
    data.stale = true;
  end
  for i,id in ipairs(idlist) do
    if targets[id] then
      -- already targeting this token, mark as fresh
      targets[id].stale = false;
    else
      -- not yet targeting this token, add it to the list
      targets[id] = {stale=false};
      -- set the target
      CTManager.setTarget(id,targetpath,ref);
    end
  end
  for id,data in pairs(targets) do
    if data.stale then
      -- clear the target
      targets[id] = nil;
      CTManager.setTarget(id,"",nil);
    end
  end
end

-- other stuff

function refDeleted()
	CTManager.removeTokenFromTargets(ref.getId());
	ref = nil;
end

function setActive(status)
  if ref then
    ref.setActive(status);
  end
end

function setName(name)
  if ref then
    ref.setName(name);
  end
end

function updateUnderlay()
  if ref and User.isHost() then
    ref.removeAllUnderlays();
    if window.getFoF() == "friend" then
      ref.addUnderlay(0.5, "2f00ff00");
    elseif window.getFoF() == "foe" then
      ref.addUnderlay(0.5, "2fff0000");
    elseif window.getFoF() == "neutral" then
      ref.addUnderlay(0.5, "2fffff00");
    end
  end
end

function updateVisibility()
  if ref then
    if window.shownpc.getState() or window.getType() == "pc" then
      ref.setVisible(true);
    else
      ref.setVisible(false);
    end
  end
end

function acquireReference(dropref)
  if dropref then
    -- applies to all sessions:
    if ref and ref ~= dropref then
      ref.delete();
    end
    ref = dropref;
    ref.onDelete = refDeleted;
    scale = ref.getScale();

    -- for Host sessions only:
    if User.isHost() then
      ref.onTargetUpdate = refTargeted;
      ref.setActivable(true);
      ref.setTargetable(true);
      if window.getType() ~= "pc" then
        ref.setVisible(false);
        ref.setModifiable(false);
      end
      ref.setActive(window.active.getState());
      ref.setName(window.label.getValue());
      updateUnderlay();
      updateVisibility();
      -- update the stored reference data
      window.tokenrefnode.setValue(ref.getContainerNode().getNodeName());
      window.tokenrefid.setValue(ref.getId());
    end
    
    return true;
  end
end

function onDrop(x, y, draginfo)
  if User.isHost() and draginfo.isType("token") then
    local prototype, dropref = draginfo.getTokenData();
    setPrototype(prototype);
    return acquireReference(dropref);
  else
    return window.onDrop(x, y, draginfo);
  end
end

function onDragEnd(draginfo)
  if User.isHost() then
    local prototype, dropref = draginfo.getTokenData();
    return acquireReference(dropref);
  end
end

function onClickDown(button, x, y)
  if User.isHost() then
    return true;
  end
end

function onClickRelease(button, x, y)
  if ref and User.isHost() then
    if button == 1 then
      if ref.isActive() then
        ref.setActive(false);
      else
        ref.setActive(true);
      end
    else
      ref.setScale(1.0)
      scale = 0;
      if scaleWidget then
        scaleWidget.setVisible(false);
      end
    end
  end
  
  return true;
end

function onWheel(notches)
  if ref and User.isHost() then
    if not scaleWidget then    
      scaleWidget = addTextWidget("sheetlabelsmall", "0");
      scaleWidget.setFrame("tempmodmini", 4, 1, 6, 3);
      scaleWidget.setPosition("topright", -2, 2);
    end
  
    if Input.isControlPressed() then
      scale = math.floor(scale + notches);
      if scale < 1 then
        scale = 1;
      end
    else
      scale = scale + notches*0.1;
  
      if scale < 0.1 then
        scale = 0.1;
      end
    end
    
    if scale == 1 then
      ref.setScale(1.0);
      scaleWidget.setVisible(false);
    else
      ref.setScale(scale);
      scaleWidget.setVisible(true);
      scaleWidget.setText(scale);
    end
  end
    
  return true;
end