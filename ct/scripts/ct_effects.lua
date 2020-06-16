-- A reference to the summary effects window
local summary = nil;

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  -- create the summary line
  getSummary();
  -- catch any changes to the individual effects entries
  if User.isHost() then
	getDatabaseNode().onChildUpdate = summarise;
	summarise();
  end
end

function summarise()
  local p=0;
  local d=0;
  local b=0;
  local mp=0;
  local pa=0;
  local s=0;
  local cp=0;
  for i,eff in ipairs(getWindows()) do
    eff.resetMenuItems();
    if not eff.isSummary() then
      -- delete menu option
      if eff.getDatabaseNode().isOwner() then
        eff.registerMenuItem("Delete effect","delete",6);
      end
      -- cumulative items
      p = p + eff.penalty.getValue();
      b = b + eff.bleeding.getValue();
      s = s + eff.stunned.getValue();
      -- maximum values
      d = math.max(d, eff.duration.getValue());
    end
  end
  if not summary then
    getSummary();
  end
  if summary then
	if summary.penalty then
		summary.penalty.setValue(p);
		summary.bleeding.setValue(b);
		summary.duration.setValue(d);
		summary.stunned.setValue(s);
	end
  end
end

function onMenuSelection(item)
  if item then
    if item==5 then
      createWindow();
      setExpanded(true);
      return true;
    end
  end
end

function removeAllEffects()
	-- Remove old summary
	summary.close();
	summary = nil;

	-- Remove effects
	local node = getDatabaseNode();
	for i,effectNode in pairs(node.getChildren()) do
		effectNode.delete();
	end

	-- Recreate the summary
	getSummary();
end

function getSummary()
  if not summary and User.isHost() then
    -- create summary effects entry
    local smynode = window.getDatabaseNode().createChild("effectssummary");
    summary = createWindow(smynode);
    summary.description.setValue(" Summary of effects:");
    summary.setSummary(true);
  end
  return summary;
end

function getNewEffect()
  for i,win in ipairs(getWindows()) do
    if win.isBlank() and not win.isSummary() then
      return win;
    end
  end
  return createWindow();
end

function checkForBlanks()
	if #(getWindows()) > 1 then
		for k, eff in ipairs(getWindows()) do
			if not eff.description then
				eff.getDatabaseNode().delete();
			end
		end
	end
end

function checkForEmpty()
  if not disablecheck and getDatabaseNode().isOwner() and #(getWindows())<2 then
    if #(getWindows())==0 then
      local w = createWindow();
      applyFilter();
    elseif getWindows()[1].isSummary() then
      local w = createWindow();
      applyFilter();
    end
  end
end

function isMulti()
  return (#getWindows()>2);
end

function isExpanded()
  return window.expandeffects.getState();
end

function setExpanded(state)
  window.expandeffects.setState(state);
  -- applyFilter is invoked by the expandeffects onValueChanged event handler
end

function onFilter(win)
  if win then
    if isMulti() and not isExpanded() then
      return win.isSummary();
    else
      return not win.isSummary();
    end
  end
end

function onListRearranged(changed)
  window.expandeffects.setVisible(isMulti());
  checkForEmpty();
  checkForBlanks();
  applyFilter();
end

function clearAndDisableCheck()
  disablecheck = true;
  closeAll();
end

function enableCheck()
  disablecheck = false;
end

function progressEffects()
  local dos = true;
  for k, v in ipairs(getWindows()) do
    if not v.isSummary() then
      dos = progressEffect(v, dos);
    end
  end
end

function progressEffect(eff, dos)
  local d = eff.duration.getValue();
  local b = eff.bleeding.getValue();
  local s = eff.stunned.getValue();
  local p = eff.penalty.getValue();
  local act = false;
  local entry = window.windowlist.window;

  if d>0 then
    d = d - 1;
    eff.duration.setValue(d);
    if d==0 then
      local msg = {};
      msg.text = "'" .. eff.description.getValue() .. "' on " .. entry.name.getValue() .. ": penalty expired";
      msg.font = "systemfont";
      msg.icon = "indicator_effect";
      ChatManager.addMessage(msg);
      act = true;
      eff.penalty.setValue(0);
	  p = 0;
    end
  end
  -- bleeding
  if b~=0 then
    entry.damage.setValue(entry.damage.getValue()+b);
  end
  -- stun effects
  if dos and s>0 then
    s = s - 1;
    eff.stunned.setValue(s);
    dos = false;
    if s==0 then
      local msg = {};
      msg.text = "'" .. eff.description.getValue() .. "' on " .. entry.name.getValue() .. ": stun expired";
      msg.font = "systemfont";
      msg.icon = "indicator_effect";
      ChatManager.addMessage(msg);
      act = true;
    end
  end
  
  -- delete the wound (all aspects have expired)?
  if (PreferenceManager.load(Preferences.ClearEffectsPref)~=Preferences.No) then
    if d==0 and s==0 and b==0 and p==0 and act then
      eff.getDatabaseNode().delete();
    end
  end
  return dos;
end

function onDrop(...)
  return window.onDrop(...);
end
