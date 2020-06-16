-- Prevents premature access to uninitialised objects

initialised = false;

local panellist = {};

-- Global function to return Tracker Preferences

function getPref()
  local prefs = windowlist.getPreferences();
  local type = getFoF();
  if not prefs then
    return nil;
  end
  if getDatabaseNode().isOwner() then
    type="self";
  elseif type=="" then
    type="neutral"
  end
  return prefs[type];
end

-- Window initialisation

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  -- Health indicator
  --hits.getDatabaseNode().onUpdate = refreshHealthStatus;
  --damage.getDatabaseNode().onUpdate = refreshHealthStatus;
  refreshHealthStatus();
  -- Panels
  if #(CTManager.getPanels())==0 then
    CTManager.onInit();
  end
  for i,pnl in ipairs(CTManager.getPanels()) do
    local node = getDatabaseNode();
    if User.isHost() or (not pnl.gmonly) then
      -- add the panel window
      local win = panels.createWindowWithClass(pnl.windowclass,node.getNodeName());
      -- add the control icon
      local btn = createControl("panelbutton",pnl.name.."_button");
      btn.setAnchor("left","midanchor","right","relative",-1);
      btn.setTarget(win);
      btn.setIcon(pnl.icon);
      -- save the panel
      panellist[pnl.name] = win;
    end
  end
  local node = getDatabaseNode();
  local flg = true;
  for i,pnl in ipairs(defence_panel.getWindows()) do
	if pnl.getClass() == "combatpanel_defence" then
		flg = false;
	end
  end
  if flg then
	local win = defence_panel.createWindowWithClass("combatpanel_defence",node.getNodeName());
  end
  --panellist[pnl.name] = win;
  -- show GM-only items
  friendfoe.setVisible(User.isHost());
  identity.setVisible(User.isHost());
  turncomplete.setReadOnly(not User.isHost());
  -- React to changes in FoF
  if not User.isHost() then
    fof.getDatabaseNode().onUpdate = refresh;
  end
  -- Set visibility, read-only status and frames
  refresh();
  -- We are now ready to roll
  initialised = true;
end


-- targeting another entry

function setTarget(entrypath)
  for j,pnl in ipairs(panels.getWindows()) do
    if pnl.setTarget then
      pnl.setTarget(entrypath);
    end
  end
end

-- Quickness Info

function getQuicknessBonus()
	local bonus = 0;
	local node = getDatabaseNode();
	local link = node.getChild("link");
	local sourceType, sourceLink = link.getValue();
	local sourceNode = DB.findNode(sourceLink);
	if sourceNode then
		local nodeType = node.getChild("type").getValue();
		if nodeType == "pc" then
			if sourceNode.getChild("abilities.quickness.total") then
				bonus = sourceNode.getChild("abilities.quickness.total").getValue();
			end
		elseif nodeType == "npc" then
			if sourceNode.getChild("initmod") then
				bonus = sourceNode.getChild("initmod").getValue();
			end
			if bonus == 0 and sourceNode.getChild("aq") then
				local aq = {0,-25,-20,-10,0,10,20,30,40,50};
				bonus = aq[sourceNode.getChild("aq").getValue()];
			end
		end
	end
	return bonus;
end

function getQuicknessStat()
	local stat = 0;
	local node = getDatabaseNode();
	local link = node.getChild("link");
	local sourceType, sourceLink = link.getValue();
	local sourceNode = DB.findNode(sourceLink);
	if sourceNode then
		local nodeType = node.getChild("type").getValue();
		if nodeType == "pc" then
			if sourceNode.getChild("abilities.quickness.temp") then
				stat = sourceNode.getChild("abilities.quickness.temp").getValue();
			end
		end
	end
	return stat;
end

-- handling panel display

function setPanelDisplay(name, state)
  if panellist[name] then
    panellist[name].setDisplay(state);
  end
end

function getPanel(name)
  if panellist[name] then
    return panellist[name];
  end
  return nil;
end

function setPanelEnabled(name,state)
  if panellist[name] and panellist[name].setEnabled then
    panellist[name].setEnabled(state);
  end
  if self[name.."_button"] then
    self[name.."_button"].setVisible(state);
  end
end

function getTargetNode()
  return link.getTargetDatabaseNode();
end

function refresh()
  -- database node represented by the entry (charsheet or NPC sheet)
  local targetnode = getTargetNode();
  -- database node holding the tracker entry
  local node = getDatabaseNode();
  -- display preferences object
  local pref = getPref();
  -- controls how frames/readonly works
  local fulledit = false;
  -- active panel for at, atmiss and db
  local activepanel = getPanel("active");

  -- Set Quickness bonus and stat for sorting
  if User.isHost() then
	quicknessBonus.setValue(getQuicknessBonus());
	quicknessStat.setValue(getQuicknessStat());
  end
  
  -- show/hide the button for toggling npc visibility
  shownpc.setVisible(false);
  if User.isHost() and getType()~="pc" then
    shownpc.setVisible(true);
  else
    shownpc.setVisible(false);
  end

  if User.isHost() then
    -- menus
    resetMenuItems();

    -- delete menu item
    registerMenuItem("Delete combatant","delete",4);

	-- Rest Menu
	registerMenuItem("Rest", "rest", 6);
	registerMenuItem("Rest 1 Hour. 1 hit and all exhaustion recovered.", "rest_1_hour", 6, 3);
	registerMenuItem("Rest 2 Hours. 2 hits and all exhaustion recovered.", "rest_2_hours", 6, 4);
	registerMenuItem("Rest 4 Hours. 4 hits and all exhaustion recovered.", "rest_4_hours", 6, 5);
	registerMenuItem("Rest 8 Hours. 8 hits, all exhaustion and PP recovered.", "rest_8_hours", 6, 6);
	registerMenuItem("Rest 12 Hours. 12 hits, all exhaustion and PP recovered.", "rest_12_hours", 6, 7);
	registerMenuItem("Rest 24 Hours. 24 hits, all exhaustion and PP recovered.", "rest_24_hours", 6, 8);
	registerMenuItem("Remove", "rest_remove", 6, 1);
	registerMenuItem("Remove all Hits", "rest_hits", 6, 1, 6);
	registerMenuItem("Remove all PP", "rest_pp", 6, 1, 7);
	registerMenuItem("Remove all Effects", "rest_effects", 6, 1, 8);
	registerMenuItem("Remove all Hits and PP", "rest_hits_pp", 6, 1, 1);
	registerMenuItem("Remove all Hits and Effects", "rest_hits_effects", 6, 1, 2);
	registerMenuItem("Remove all PP and Effects", "rest_pp_effects", 6, 1, 3);
	registerMenuItem("Remove all Hits, PP and Effects", "rest_hits_pp_effects", 6, 1, 4);
	
    -- link visibility and target object
    if getType()=="pc" then
      -- charsheet link for the pc
      link.setVisible(true);
    elseif getType()=="npc" and targetnode then
      -- charsheet link for the npc
      link.setVisible(true);
      -- identification menu item
      registerMenuItem("Toggle identification","toggleid",8);
    else
      link.setVisible(false);
      -- identification menu item
      registerMenuItem("Toggle identification","toggleid",8);
    end
  end
  
  -- show selected data/icons to client sessions
  initiative.setVisible(User.isHost() or (pref and pref.showInit and pref.showInit==Preferences.Yes));
  initLabel.setVisible(User.isHost() or (pref and pref.showInit and pref.showInit==Preferences.Yes));
  initdiceholder.showHide();
  activitypercent.setVisible(User.isHost() or (pref and pref.showActPct and pref.showActPct==Preferences.Yes));
  activitypercentLabel.setVisible(User.isHost() or (pref and pref.showActPct and pref.showActPct==Preferences.Yes));
  ppmax.setVisible(User.isHost() or (pref and pref.showPPMax and pref.showPPMax==Preferences.Yes));
  ppmaxLabel.setVisible(User.isHost() or (pref and pref.showPPMax and pref.showPPMax==Preferences.Yes));
  ppcurrent.setVisible(User.isHost() or (pref and pref.showPPCurrent and pref.showPPCurrent==Preferences.Yes));
  ppcurrentLabel.setVisible(PreferenceManager.load(Preferences.CharPPUsedPref) == Preferences.No and (User.isHost() or (pref and pref.showPPCurrent and pref.showPPCurrent==Preferences.Yes)));
  ppusedLabel.setVisible(PreferenceManager.load(Preferences.CharPPUsedPref) == Preferences.Yes and (User.isHost() or (pref and pref.showPPCurrent and pref.showPPCurrent==Preferences.Yes)));
  hits.setVisible(User.isHost() or (pref and pref.showHits and pref.showHits==Preferences.Yes));
  hitsLabel.setVisible(User.isHost() or (pref and pref.showHits and pref.showHits==Preferences.Yes));
  damage.setVisible(User.isHost() or (pref and pref.showDamage and pref.showDamage==Preferences.Yes));
  damageLabel.setVisible(User.isHost() or (pref and pref.showDamage and pref.showDamage==Preferences.Yes));
  healthstatus.setVisible(User.isHost() or (pref and pref.showStatus and pref.showStatus==Preferences.Yes));

  -- set field status (links etc)
  if User.isHost() then
    -- Linked fields
    if getType()=="pc" and targetnode then
      -- set database node owner
      local owner = targetnode.getOwner();
      if owner then
        getDatabaseNode().addHolder(owner, true);
      end
      -- set the linked fields
      name.setLink(targetnode.createChild("name","string"));
	  if activepanel then
		activepanel.at.setLink(targetnode.createChild("at","number"));
		activepanel.atmiss.setLink(targetnode.createChild("atmiss","number"));
		activepanel.db.setLink(targetnode.createChild("db","number"));
		activepanel.movemaneuver.setLink(targetnode.createChild("mmpenalty","number"));
		activepanel.move.setLink(targetnode.createChild("bmr.total","number"));
		activepanel.exhaustionmax.setLink(targetnode.createChild("abilities.constitution.temp","number"));
		activepanel.exhaustioncurrent.setLink(targetnode.createChild("exhaustion","number"));
		for k,pnl in pairs(activepanel.attacks.getWindows()) do
			if targetnode.getChild("weapons") then
				for j,src in pairs(targetnode.getChild("weapons").getChildren()) do
					if src.getChild("name") and pnl.name.getValue() == src.getChild("name").getValue() then
						pnl.name.setLink(src.getChild("name"));
						pnl.ob.setLink(src.getChild("ob"));
					end
				end
			end
		end
      end
	  ppmax.setLink(targetnode.createChild("maxpower","number"));
	  ppcurrent.setLink(targetnode.createChild("power","number"));
	  hits.setLink(targetnode.createChild("hits","number"));
      damage.setLink(targetnode.createChild("damage","number"));
    else
      -- clear the linked fields
      name.setLink(nil);
      if activepanel then
		activepanel.at.setLink(nil);
		activepanel.atmiss.setLink(nil);
		activepanel.db.setLink(nil);
		activepanel.movemaneuver.setLink(nil);
		activepanel.move.setLink(nil);
		activepanel.exhaustionmax.setLink(nil);
		activepanel.exhaustioncurrent.setLink(nil);
	  end
      ppmax.setLink(nil);
      ppcurrent.setLink(nil);
      hits.setLink(nil);
      damage.setLink(nil);
    end
    -- readonly, frames
    if getType()~="pc" then
      fulledit = true;
    end
    -- Token
    if tokenrefnode.getValue() and tokenrefid.getValue() then
      local prototype = token.getPrototype();
      local imageinstance = token.populateFromImageNode(tokenrefnode.getValue(), tokenrefid.getValue());
      if imageinstance then
        token.acquireReference(imageinstance);
      else
        token.setPrototype(prototype);
      end
    end
    -- FoF
    friendfoe.setState(getFoF());
    token.updateUnderlay();
  else -- Client tracker entries
    -- show/hide panel buttons
    setPanelEnabled("active", pref and pref.showActive  and pref.showActive==Preferences.Yes);
    setPanelEnabled("effects",pref and pref.showEffects and pref.showEffects==Preferences.Yes);
  end
  
  -- readonly, frames
  if fulledit then
    name.setFrame("textline",0,1,0,0);
    name.setReadOnly(false);
	if activepanel then
		activepanel.at.setFrame("textline",0,1,0,0);
		activepanel.at.setReadOnly(false);
		activepanel.atmiss.setFrame("textline",0,1,0,0);
		activepanel.atmiss.setReadOnly(false);
		activepanel.db.setFrame("textline",0,1,0,0);
		activepanel.db.setReadOnly(false);
		activepanel.movemaneuver.setFrame(nil);
		activepanel.movemaneuver.setReadOnly(true);
		activepanel.move.setFrame(nil);
		activepanel.move.setReadOnly(true);
		activepanel.exhaustionmax.setFrame("textline",0,1,0,0);
		activepanel.exhaustionmax.setReadOnly(false);
		activepanel.exhaustioncurrent.setFrame("textline",0,1,0,0);
		activepanel.exhaustioncurrent.setReadOnly(false);
	end
    ppmax.setFrame("textline",0,1,0,0);
    ppmax.setReadOnly(false);
    ppcurrent.setFrame("textline",0,1,0,0);
    ppcurrent.setReadOnly(false);
    hits.setFrame("textline",0,1,0,0);
    hits.setReadOnly(false);
    damage.setFrame("textline",0,1,0,0);
    damage.setReadOnly(false);
    initiative.setFrame("textline",0,1,0,0);
    initiative.setReadOnly(false);
  else
    name.setFrame(nil);
    name.setReadOnly(true);
	if activepanel then
		activepanel.at.setFrame(nil);
		activepanel.at.setReadOnly(true);
		activepanel.atmiss.setFrame(nil);
		activepanel.atmiss.setReadOnly(true);
		activepanel.db.setFrame(nil);
		activepanel.db.setReadOnly(true);
		activepanel.movemaneuver.setFrame(nil);
		activepanel.movemaneuver.setReadOnly(true);
		activepanel.move.setFrame(nil);
		activepanel.move.setReadOnly(true);
		activepanel.exhaustionmax.setFrame(nil);
		activepanel.exhaustionmax.setReadOnly(true);
		activepanel.exhaustioncurrent.setFrame(nil);
		activepanel.exhaustioncurrent.setReadOnly(true);
		for k,pnl in pairs(activepanel.attacks.getWindows()) do
			pnl.name.setFrame(nil);
			pnl.name.setReadOnly(true);
			pnl.ob.setFrame(nil);
			pnl.ob.setReadOnly(true);
			local pnlNode = pnl.getDatabaseNode();
			if pnlNode then
				if pnlNode.getChild("attacktable.tableid") then
					if pnlNode.getChild("attacktable.tableid").getValue() == "CLT-08" or  -- Martial Arts Sweeps and Throws
								pnlNode.getChild("attacktable.tableid").getValue() == "CLT-09" then
						pnl.name.setFrame("textline",0,1,0,0);
						pnl.name.setReadOnly(false);
						pnl.ob.setFrame("textline",0,1,0,0);
						pnl.ob.setReadOnly(false);
					end
				end
			end
		end
	end
    ppmax.setFrame(nil);
    ppmax.setReadOnly(true);
    hits.setFrame(nil);
    hits.setReadOnly(true);
    -- editable fields for the owner
    if getDatabaseNode().isOwner() then
      ppcurrent.setFrame("textline",0,1,0,0);
      ppcurrent.setReadOnly(false);
      damage.setFrame("textline",0,1,0,0);
      damage.setReadOnly(false);
      initiative.setFrame("textline",0,1,0,0);
      initiative.setReadOnly(false);
	  if activepanel then
		  activepanel.exhaustioncurrent.setFrame("textline",0,1,0,0);
		  activepanel.exhaustioncurrent.setReadOnly(false);
	  end
    else
      ppcurrent.setFrame(nil);
      ppcurrent.setReadOnly(true);
      damage.setFrame(nil);
      damage.setReadOnly(true);
      initiative.setFrame(nil);
      initiative.setReadOnly(true);
	  if activepanel then
		  activepanel.exhaustioncurrent.setFrame(nil);
		  activepanel.exhaustioncurrent.setReadOnly(true);
	  end
    end
  end

  -- Identified status
  setIdentified(isIdentified());

end

function refreshHealthStatus()
  local node = getDatabaseNode();
  local hitsval = node.createChild("hits","number").getValue() + 0.0;
  local woundval = node.createChild("damage","number").getValue() + 0.0;
  local remval = hitsval - woundval;
  local status = 1;
  local icon = nil;
  local tooltip = "Healthy (100% hits remaining)";
  -- if we have hits, what is the current fraction remaining
  if hitsval>0 then
    status = remval/hitsval;
  end
  -- choose the right icon
  if status <= 0 then
    icon = "health_dead";
	tooltip = "Unconscious or Dead (0% hits remaining)";
	node.createChild("phases","string").setValue("");
  elseif status < 0.25 then
    icon = "health_vpoor";
	tooltip = "Critical Damage (1-24% hits remaining)";
  elseif status < 0.5 then
    icon = "health_poor";
	tooltip = "Severe Damage (25-49% hits remaining)";
  elseif status < 0.75 then
    icon = "health_medium";
	tooltip = "Medium Damage (50-74% hits remaining)";
  elseif status < 1 then
    icon = "health_good";
	tooltip = "Light Damage (75-99% hits remaining)";
  end
  -- set the health widget
  healthstatus.setIcon(icon);
  healthstatus.setTooltipText(tooltip);
end

function isIdentified()
  return (identified.getValue()~=0);
end

function setIdentified(status)
  if User.isHost() then
    token.querywidget.setVisible(not status);
    if status then
      identified.setValue(1);
      glance.setVisible(false);
      nameLabel.setVisible(false);
      name.setAnchor("left","token","right","absolute",1);
      name.setAnchoredWidth(215);
    else
      identified.setValue(0);
      name.setAnchor("left","token","right","absolute",116);
      name.setAnchoredWidth(100);
      glance.setVisible(true);
      nameLabel.setVisible(true);
    end
  else
    token.querywidget.setVisible(false);
    nameLabel.setVisible(false);
    glance.setVisible(false);
    name.setVisible(false);
    label.setVisible(true);
  end
  if getType()=="pc" then
	idnum.setVisible(false);
	idnumLabel.setVisible(false);
  end
end

function onMenuSelection(item, subitem, subsubitem)
  if item then
    if item==4 then
      local myNode = getDatabaseNode().getNodeName();
      -- remove this combatant as a target from any other entry
      for i,ent in ipairs(windowlist.getWindows()) do
        local active = ent.getPanel("active");
        if active then
          for j,win in ipairs(active.attacks.getWindows()) do
            if win.getDatabaseNode().getChild("targetnode").getValue()==myNode then
              win.setTarget(nil);
            end
          end
          for j,win in ipairs(active.defences.getWindows()) do
            if win.getDatabaseNode().getChild("targetnode").getValue()==myNode then
              win.setTarget(nil);
            end
          end
        end
      end
      -- delete the record
      delete();
      return true;
    elseif item==8 then
      setIdentified(not isIdentified());
	-- Rest Menu
	elseif item==6 then
		if subitem == 3 then
			restHours(1);
		elseif subitem == 4 then
			restHours(2);
		elseif subitem == 5 then
			restHours(4);
		elseif subitem == 6 then
			restHours(8);
		elseif subitem == 7 then
			restHours(12);
		elseif subitem == 8 then
			restHours(24);
		elseif subitem == 1 then
			if subsubitem == 6 then
				restRemoveHits();
			elseif subsubitem == 7 then
				restRemovePP();
			elseif subsubitem == 8 then
				restRemoveEffects();
			elseif subsubitem == 1 then
				restRemoveHits();
				restRemovePP();
			elseif subsubitem == 2 then
				restRemoveHits();
				restRemoveEffects();
			elseif subsubitem == 3 then
				restRemovePP();
				restRemoveEffects();
			elseif subsubitem == 4 then
				restRemoveHits();
				restRemovePP();
				restRemoveEffects();
			end
		end		
    end
  end
end

function rollInit(ctNode)
	local link;
	local type;
	local name;
	local bonus = 0;
	if ctNode then
		link = ctNode.getChild("link");
		type = ctNode.getChild("type").getValue();
		name = ctNode.getChild("label").getValue();
		if name == "" then
			name = ctNode.getChild("name").getValue();
		end
		local sourceType, sourceLink = link.getValue();
		local sourceNode = DB.findNode(sourceLink);
		if sourceNode then
			if type == "pc" then
				if sourceNode.getChild("inittotal") then
					bonus = sourceNode.getChild("inittotal").getValue();
				end
			elseif type == "npc" then
				if sourceNode.getChild("initmod") then
					bonus = sourceNode.getChild("initmod").getValue();
				end
				if bonus == 0 and sourceNode.getChild("aq") then
					local aq = {0,-25,-20,-10,0,10,20,30,40,50};
					bonus = aq[sourceNode.getChild("aq").getValue()];
				end
			end
			if bonus then
				bonus = bonus + ModifierStack.getSum();
			else
				bonus = ModifierStack.getSum();
			end
			ModifierStack.reset();
			if User.isHost() then
				ctNode.getChild("initiative").setValue(math.random(10) + bonus);
			else
				local customData = {type=Rules_Constants.DataType.DieRoll,modifiers={}};
				customData.dielist = {"d10"};
				customData.dieType = "dice";
				customData.numberData = bonus;
				customData.stringData = "Initiative: " .. name;
				customData.ctNodeInit = ctNode;
				ChatManager.throwDice("dice", {"d10"}, bonus, "Initiative: " .. name, customData);
			end	
		end
	end
end


function delete()
  local last = windowlist.getPrevWindow(window);
  if last and last.name then
    last.name.setFocus();
  end
  CTManager.removeTokenFromTargets(tokenrefid.getValue());
  getDatabaseNode().delete();
end

function isFiltered()
  local result = User.isHost() or getType()=="pc" or shownpc.getState();
  return result;
end

-- Manage sub-windows

function setSpacerState()
  if not spacer then
    -- not yet initialised
    return;
  end
  if #(panels.getWindows())~=0 then
    spacer.setVisible(true);
  else
    spacer.setVisible(false);
  end
end

-- FoF state

function getFoF()
  return fof.getValue();
end

-- Name 

function setName(v)
  name.setValue(v);
end

function getName()
  return name.getValue();
end

-- Type 

function setType(v)
  type.setValue(v);
  refresh();
end

function getType()
  return type.getValue();
end

-- Activity state

function isActive()
  return active.getState();
end

function setActive(state)
  active.setState(state);
  
  if state and getType() == "pc" then
    -- Turn notification
    local msg = {};
    msg.text = getName();
    msg.font = "narratorfont";
    msg.icon = "indicator_flag";
    
    ChatManager.deliverMessage(msg);
    
    if  PreferenceManager.load(Preferences.RingBellPref) == Preferences.Yes then
		local usernode = link.getTargetDatabaseNode()
		if usernode then
			local ownerid = User.getIdentityOwner(usernode.getName());
			if ownerid then
				User.ringBell(ownerid);
			end
		end
	end
  end
  
  setPanelDisplay("active",state);
end

function addWoundEffects(woundEffects, description)
  local newEntry = nil;
  local newEntryDBNode = nil;
  local pnl = getPanel("effects");
  -- hits
  if woundEffects.Hits then
    damage.setValue(damage.getValue() + woundEffects.Hits);
  end
  -- various wound effects
  if not pnl then
    return;
  end
  if woundEffects.Penalty then
    newEntry = pnl.effects.getNewEffect();
    newEntryDBNode = newEntry.getDatabaseNode();
    newEntryDBNode.getChild("penalty").setValue(woundEffects.Penalty);
  end
  if woundEffects.PenaltyRounds then
    if not newEntry then
      newEntry = pnl.effects.getNewEffect();
      newEntryDBNode = newEntry.getDatabaseNode();
    end
    newEntryDBNode.getChild("duration").setValue(woundEffects.PenaltyRounds);
  end
  if woundEffects.Bleeding then
    if not newEntry then
      newEntry = pnl.effects.getNewEffect();
      newEntryDBNode = newEntry.getDatabaseNode();
    end
    newEntryDBNode.getChild("bleeding").setValue(woundEffects.Bleeding);
  end
  if woundEffects.MustParry then
    if not newEntry then
      newEntry = pnl.effects.getNewEffect();
      newEntryDBNode = newEntry.getDatabaseNode();
    end
    newEntryDBNode.getChild("mustParry").setValue(woundEffects.MustParry);
  end
  if woundEffects.Stun then
	local stun = woundEffects.Stun;
	if woundEffects.NoParry then
		stun = stun - woundEffects.NoParry;
	end
	if stun > 0 then
		if not newEntry then
		  newEntry = pnl.effects.getNewEffect();
		  newEntryDBNode = newEntry.getDatabaseNode();
		end
		newEntryDBNode.getChild("stunned").setValue(stun);
	end
  end
  if woundEffects.NoParry then
    if not newEntry then
      newEntry = pnl.effects.getNewEffect();
      newEntryDBNode = newEntry.getDatabaseNode();
    end
    newEntryDBNode.getChild("cantParry").setValue(woundEffects.NoParry);
  end
  if woundEffects.ParryPenalty then
    if not newEntry then
      newEntry = pnl.effects.getNewEffect();
      newEntryDBNode = newEntry.getDatabaseNode();
    end
    newEntryDBNode.getChild("parryAt").setValue(woundEffects.ParryPenalty);
  end

  -- Check if Description should be sent to the Chat Window
  if PreferenceManager.load(Preferences.SendEffectsToChat) == Preferences.Yes then
	local msg = {font = "msgfont", icon = "indicator_effect", mode = "chat"};
	if isIdentified() then
		msg.text = getName() .. ": " .. description;
	else
		msg.text = glance.getValue() .. ": " .. description;
	end
	Comm.deliverChatMessage(msg);	
  end
  
  -- only set a description if there is a wound effect
  if newEntryDBNode and description~="" then
    newEntryDBNode.getChild("description").setValue(description);
    if not pnl.isDisplayed() then
      pnl.toggleForceDisplay();
      pnl.setDisplay(true);
    end
  end
end

local currentDragInfo = nil;

function onDrop(x, y, draginfo)
	local customData;
	
	-- locate and process the custom data
	customData = draginfo.getCustomData();
	-- Handle Attack Rolls Dropped on Combat Tracker Entries
	if customData then
		if customData.tableType == "Attack" and currentDragInfo ~= draginfo then
			currentDragInfo = draginfo;
			attackerNode = DB.findNode(customData.attackerNodeName);
			if attackerNode then
				tokenRefNode = attackerNode.getChild("tokenrefnode").getValue();
				tokenRefID = attackerNode.getChild("tokenrefid").getValue();
				defenderNode = getDatabaseNode();
				oldDefenderNodeName = customData.defenderNodeName;
				customData.defenderNodeName = defenderNode.getNodeName();
				customData.defenderName = defenderNode.getChild("label").getValue();
				if oldDefenderNodeName ~= customData.defenderNodeName then
					attackNode = DB.findNode(customData.attackDBNodeName);
					customData = Rules_CustomData.Attack(attackNode, customData.defenderNodeName);
				end
				armorType = defenderNode.getChild("at").getValue();
				if armorType<1 or armorType>20 then
					-- send a message to the chat box
					ChatManager.addMessage({font="systemfont",text="Target armor type is out of range (should be 1-20)"});
					return;
				else
					customData.armorType = armorType;
				end

				if User.isHost() then
					tracker = Interface.findWindow("combattracker","combattracker");
				else
					tracker = Interface.findWindow("combattracker_client","combattracker");
				end
				if not tracker then
					return;
				end
			
				for i,entry in ipairs(tracker.list.getWindows()) do
					if entry.tokenrefnode.getValue() == tokenRefNode and entry.tokenrefid.getValue() == tokenRefID then
						-- Update token target
						attackerToken = Token.getToken(tokenRefNode, tokenRefID);
						defenderToken = Token.getToken(tokenrefnode.getValue(), tokenrefid.getValue());
						attackerToken.setTarget(true, defenderToken);

						-- Update Combat Tracker attacks and defenses for Attacker 
						for i, att in ipairs(entry.getPanel("active").attacks.getWindows()) do
							att.setTargetFromToken(defenderNode);
						end
						for i, def in ipairs(entry.getPanel("active").defences.getWindows()) do
							if not def.targetall or (def.targetall and not def.targetall.getState()) then
								def.setTargetFromToken(defenderNode);
							end
						end
					end
				end
				ChatManager.throwDice("dice",{"d10","d100"},0,"",customData);
			end
		end
	end

	-- only applies to the GM
	if not User.isHost() then
		return;
	end
	
	-- only recognise dropped strings or Attack Effects
	if (not draginfo) or (not draginfo.isType(Rules_Constants.DataType.AttackEffects)) then
		return;
	end
	if customData then
		if draginfo.getDescription() and draginfo.getDescription()~="" then
			addWoundEffects(customData, draginfo.getDescription());
		end
		-- indicate that we have processed this event
		return true;
	end
end

-- Rest Functions
function restHours(hours)
	local currentDamage = damage.getValue();
	if currentDamage < hours then
		currentDamage = 0;
	else
		currentDamage = currentDamage - hours;
	end
	damage.setValue(currentDamage);

	local activePanel = getPanel("active");
	if activePanel then
		activePanel.exhaustioncurrent.setValue(0);
	end
	
	if hours >= 8 then
		restRemovePP();
	end
end

function restRemoveHits()
	damage.setValue(0);
end

function restRemovePP()
	if PreferenceManager.load(Preferences.CharPPUsedPref) == Preferences.No then
		ppcurrent.setValue(ppmax.getValue());
	else
		ppcurrent.setValue(0);
	end
end

function restRemoveEffects()
	local effectsPanel = getPanel("effects");
	if effectsPanel then
		effectsPanel.effects.removeAllEffects();
	end
end
