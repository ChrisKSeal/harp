function setState(s)
  state = s;
  activewidget.setVisible(state);
  window.token.setActive(state);
  window.setPanelDisplay("active",state);
end

function getState()
  return state;
end

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  activewidget = addBitmapWidget(activeicon[1]);
  activewidget.setVisible(false);
  state = false;
end

function onClickDown(button, x, y)
  return true;
end

function onClickRelease(button, x, y)
  if not state and User.isHost() then
    window.windowlist.requestActivation(window);
  end
end

function onDragStart(button, x, y, draginfo)
  draginfo.setType("combattrackeractivation");
  draginfo.setIcon(activeicon[1]);

  activewidget.setVisible(false);

  return true;
end

function onDragEnd(draginfo)
  if state and User.isHost() then
    activewidget.setVisible(true);
  end
end

function onDrop(x, y, draginfo)
  if draginfo.isType("combattrackeractivation") and User.isHost() then
    window.windowlist.requestActivation(window);
  end
end