local npcCount = 0;
local allPhases = "1";
local phasesVisible = false;

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  allPhases = getAllPhases();
  phasesVisible = getPhasesVisible();
  if User.isHost() then
    Interface.onHotkeyActivated = onHotkey;
    registerMenuItem("New combatant","insert",3);
    if #getWindows() == 0 then
      createWindow();
    end
  end
  -- Restore token info
  for i,win in ipairs(getWindows()) do
    local tokenrefnode = win.getDatabaseNode().createChild("tokenrefnode","string").getValue();
    local tokenrefid = win.getDatabaseNode().createChild("tokenrefid","string").getValue();
    if tokenrefnode~="" and tokenrefid~="" then
      local imageinstance = win.token.populateFromImageNode(tokenrefnode, tokenrefid);
      if imageinstance then
        win.token.acquireReference(imageinstance);
      end
    end
    win.token.updateUnderlay();
	-- Show/Hide Phases Field
	--win.getPanel("active").phases.setVisible(phasesVisible);
	--win.getPanel("active").phasesLabel.setVisible(phasesVisible);
  end
  -- link combatants via attacks/defenses
  patchTargets();
end

function onClose()
  if not User.isHost() then
    return;
  end
  -- Save token info
  for i,win in ipairs(getWindows()) do
    if win.token.ref and win.token.ref.getContainerNode() then
      win.getDatabaseNode().createChild("tokenrefnode","string").setValue(win.token.ref.getContainerNode().getNodeName());
      win.getDatabaseNode().createChild("tokenrefid","string").setValue(win.token.ref.getId());
    end
  end
end

function onMenuSelection(item)
  if item then
    if item==3 then
      local win = createWindow();
	  local activepanel = win.getPanel("active");
	  if activepanel then
		activepanel.at.setValue(1);
	  end
      -- update menus etc
      win.refresh();
      return true;
    end
  end
end

function onHotkey(draginfo)
  if draginfo.isType("combattrackernextactor") then
    nextActor();
    return true;
  end
  if draginfo.isType("combattrackernextround") then
    nextRound();
    return true;
  end
end

function onSortCompare(w1, w2)
  -- order by initiative
  if not w1.initiative then
    return true;
  end
  if not w2.initiative then
    return false;
  end
  if w1.initiative.getValue() == w2.initiative.getValue() then
	local qb1 = w1.quicknessBonus.getValue();
	local qb2 = w2.quicknessBonus.getValue();
	if qb1 == qb2 then
		return w1.quicknessStat.getValue() < w2.quicknessStat.getValue();
	else
		return qb1 < qb2;
	end
  else
	return w1.initiative.getValue() < w2.initiative.getValue();
  end
end

function onFilter(w)
  return w.isFiltered();
end

function addPc(source, token)
  local newentry = createWindow();
  local owner = source.getOwner();
  
  newentry.setType("pc");
  
  -- Name
  newentry.name.setLink(source.getChild("name"));
  newentry.name.setReadOnly(true);
  newentry.name.setFrame(nil);
  newentry.setIdentified(true);
  newentry.shownpc.setState(true);
  newentry.shownpc.setVisible(false);
  
  -- Shortcut
  newentry.link.setValue("charsheet", source.getNodeName());
  newentry.link.setVisible(true);
  
  -- Token
  if token then
    newentry.token.setPrototype(token);
  end
  
  -- Linked fields
  newentry.ppmax.setLink(source.getChild("maxpower"));
  newentry.ppmax.setReadOnly(true);
  newentry.ppmax.setFrame(nil);
  newentry.ppcurrent.setLink(source.getChild("power"));
  newentry.hits.setLink(source.getChild("hits"));
  newentry.hits.setReadOnly(true);
  newentry.hits.setFrame(nil);
  newentry.damage.setLink(source.getChild("damage"));
  
  -- basic fields
  newentry.glance.setValue(source.getChild("name").getValue());
  
  -- Populate the panels
  for k,pnl in pairs(newentry.panels.getWindows()) do
    pnl.populate(source);
  end
  
  -- Active Panel Linked Fields
  local activepanel = newentry.getPanel("active");
  if activepanel then
	  activepanel.at.setLink(source.getChild("at"));
	  activepanel.at.setReadOnly(true);
	  activepanel.at.setFrame(nil);
	  activepanel.atmiss.setLink(source.getChild("atmiss"));
	  activepanel.atmiss.setReadOnly(true);
	  activepanel.atmiss.setFrame(nil);
	  activepanel.db.setLink(source.getChild("db"));
	  activepanel.db.setReadOnly(true);
	  activepanel.db.setFrame(nil);
	  activepanel.movemaneuver.setLink(source.getChild("mmpenalty"));
	  activepanel.movemaneuver.setReadOnly(true);
	  activepanel.movemaneuver.setFrame(nil);
	  if source.getChild("bmr") then
		  activepanel.move.setLink(source.getChild("bmr").getChild("total"));
		  activepanel.move.setReadOnly(true);
		  activepanel.move.setFrame(nil);
	  end
	  activepanel.exhaustionmax.setLink(source.getChild("abilities.constitution.temp"));
	  activepanel.exhaustionmax.setReadOnly(true);
	  activepanel.exhaustionmax.setFrame(nil);
	  activepanel.exhaustioncurrent.setLink(source.getChild("exhaustion"));
	  activepanel.exhaustioncurrent.setReadOnly(true);
	  activepanel.exhaustioncurrent.setFrame(nil);
	  activepanel.phases.setValue(allPhases);
	  -- Link Weapon OB fields to Character Sheet
	  for k,pnl in pairs(activepanel.attacks.getWindows()) do
		if source.getChild("weapons") then
			for j,src in pairs(source.getChild("weapons").getChildren()) do
				if pnl.name.getValue() == src.getChild("name").getValue() then
					pnl.name.setLink(src.getChild("name"));
					pnl.name.setReadOnly(true);
					pnl.name.setFrame(nil);
					pnl.ob.setLink(src.getChild("ob"));
					pnl.ob.setReadOnly(true);
					pnl.ob.setFrame(nil);
				end
			end
		end
	  end
  end
  
  -- Ownership
  if owner then
    newentry.getDatabaseNode().addHolder(owner, true);
  end
  
  -- FoF
  newentry.friendfoe.setState("friend");
  
  -- Menus etc
  newentry.refresh();

  -- Done
  return newentry;
end

function addNpc(source)
  local newentry = createWindow();
  local npcNumber = 0;
  newentry.setType("npc");

  if PreferenceManager.load(Preferences.AutoNumberNPCsPref) == Preferences.AutoNumberNPCs.Append then
	npcCount = npcCount + 1;
	npcNumber = npcCount;
  elseif PreferenceManager.load(Preferences.AutoNumberNPCsPref) == Preferences.AutoNumberNPCs.Random then
	npcNumber = math.random(99);
	local count = 1;
	while not CTManager.isValidID(npcNumber) do
		npcNumber = math.random(99);
		npcNumber = npcNumber + (100 * math.floor(count/10));
		count = count + 1;
	end
  end
  
  -- Name
  local npcName;
  if source.getChild("name") then
	npcName = source.getChild("name").getValue();
	if npcNumber > 0 then
		npcName = npcName .. " " .. npcNumber;
	end
    newentry.name.setValue(npcName);
  end

  if source.getChild("glance") and string.len(source.getChild("glance").getValue()) > 0 then
	local npcGlance = source.getChild("glance").getValue();
	if npcNumber > 0 then
		npcGlance = npcGlance .. " " .. npcNumber;
	end
    newentry.glance.setValue(npcGlance);
  else
	  if source.getChild("name") 
				and PreferenceManager.load(Preferences.FillNPCFirstGlancePref) == Preferences.Yes then
			newentry.glance.setValue(npcName);
	  end
  end
  newentry.idnum.setValue(npcNumber);
  
  newentry.setIdentified(false);
  newentry.shownpc.setState(false);
  
  -- Shortcut
  newentry.link.setValue("npc", source.getNodeName());
  newentry.link.setVisible(true);
  
  -- Token
  if source.getChild("token") then
    newentry.token.setPrototype(source.getChild("token").getValue());
  end
  
  -- basic fields
  if source.getChild("hits") then
    newentry.hits.setValue(source.getChild("hits").getValue());
  end
  if source.getChild("damage") then
    newentry.damage.setValue(source.getChild("damage").getValue());
  end

  -- Populate the panels
  for k,pnl in pairs(newentry.panels.getWindows()) do
    pnl.populate(source);
  end

  -- Active Panel Fields
  local activepanel = newentry.getPanel("active");
  if activepanel then
	  if source.getChild("at") then
		activepanel.at.setValue(source.getChild("at").getValue());
	  end
	  if source.getChild("atmiss") then
		activepanel.atmiss.setValue(source.getChild("atmiss").getValue());
	  elseif activepanel.at.getValue() > 5 then
		local atval = activepanel.at.getValue();
		if atval==6 then
		  activepanel.atmiss.setValue(-5);
		elseif atval==10 or atval==14 or atval==18 then
		  activepanel.atmiss.setValue(-10);
		elseif atval==7 or atval==8 then
		  activepanel.atmiss.setValue(-15);
		elseif atval==11 or atval==15 or atval==16 then
		  activepanel.atmiss.setValue(-20);
		elseif atval==12 or atval==19 then
		  activepanel.atmiss.setValue(-30);
		elseif atval==20 then
		  activepanel.atmiss.setValue(-40);
		end
	  end
	  if source.getChild("db") then
		activepanel.db.setValue(source.getChild("db").getValue());
	  end
	  if source.getChild("mnbonus") then
		activepanel.movemaneuver.setValue(source.getChild("mnbonus").getValue());
  	    activepanel.movemaneuver.setReadOnly(true);
		activepanel.movemaneuver.setFrame(nil);
	  end
	  if source.getChild("baserate") then
		activepanel.move.setValue(source.getChild("baserate").getValue());
		activepanel.move.setReadOnly(true);
		activepanel.move.setFrame(nil);
	  end
	  activepanel.phases.setValue(allPhases);
  end
	  
  -- FoF
  newentry.friendfoe.setState("foe");
  
  -- Roll NPC Initiative?
  if PreferenceManager.load(Preferences.RollNPCInitPref) == Preferences.Yes then
	newentry.rollInit(newentry.getDatabaseNode());
  end

  -- Menus etc
  newentry.refresh();

  -- Done
  return newentry;
end

function addBattle(source)
	-- Parameter validation
	if not source then
		return nil;
	end

	-- Cycle through the NPC list, and add them to the tracker
	local nodeList = source.getChild("npclist");
	if nodeList then
		for _, vNPCItem in pairs(nodeList.getChildren()) do

			local nodeNPC = nil;
			local _, sRecord = DB.getValue(vNPCItem, "link", "", "");
			if sRecord ~= "" then
				nodeNPC = DB.findNode(sRecord);
			end
			local sName = DB.getValue(vNPCItem, "name", "");

			if nodeNPC then
				local aPlacement = {};
				local nodePlacementList = vNPCItem.getChild("maplink");
				for _, vPlacement in pairs(nodePlacementList.getChildren()) do
					local rPlacement = {};
					local _, sRecord = DB.getValue(vPlacement, "imagelink", "", "");
					rPlacement.imagelink = sRecord;
					rPlacement.imagex = DB.getValue(vPlacement, "imagex", 0);
					rPlacement.imagey = DB.getValue(vPlacement, "imagey", 0);
					table.insert(aPlacement, rPlacement);
				end
				
				local nCount = DB.getValue(vNPCItem, "count", 0);
				for i = 1, nCount do
					local nodeEntry = addNpc(nodeNPC);
					if nodeEntry then
						local sToken = DB.getValue(vNPCItem, "token", "");
						if sToken ~= "" then
							nodeEntry.token.setPrototype(sToken);
							if aPlacement[i] and aPlacement[i].imagelink ~= "" then
								local tokenAdded = Token.addToken(aPlacement[i].imagelink, sToken, aPlacement[i].imagex, aPlacement[i].imagey);
								if tokenAdded then
									nodeEntry.token.acquireReference(tokenAdded);
								end
							end
						end
					else
						ChatManager.SystemMessage("[ERROR] Unable to add '" .. sName .. "' to CT. NPC creation failed.");
					end
				end
			else
				ChatManager.SystemMessage("[ERROR] Unable to add '" .. sName .. "' to CT. Missing data record. Check your modules.");
			end
		end
	end
end

function onDrop(x, y, draginfo)
  if User.isHost() then
  
    if draginfo.isType("playercharacter")  then
      local source = draginfo.getDatabaseNode();
      local token = draginfo.getTokenData();
      if source then
        addPc(source, token);
      end
      return true;
      
    elseif draginfo.isType("shortcut")  then
      local class = draginfo.getShortcutData();
      local source = draginfo.getDatabaseNode();
      if source and class == "npc" then
        addNpc(source);
      end
      return true;
    end
    
  end
  
end

function getPreferences()
  return PreferenceManager.load(Preferences.ClientTrackerPref);
end

local entries = nil;

function patchTargets()
  --[[ repopulate the targets of each combatant's weapons and shields ]]
  entries = {};
  for i,ent in ipairs(getWindows()) do
    local entnode = ent.getDatabaseNode();
    local active = ent.getPanel("active");
    if entnode and active then
      --[[ this entry has data, add the window and its nodename to the entries table for future quick reference ]]
      entries[entnode.getNodeName()] = ent;
      --[[ examine each attack
      for j,win in ipairs(active.attacks.getWindows()) do
        patchItem(win);
      end ]]
      --[[ examine each defence
      for j,win in ipairs(active.defences.getWindows()) do
        patchItem(win);
      end ]]
    end
  end
  --[[ done ]]
end

function patchItem(win)
  local winnode = win.getDatabaseNode();
  if winnode then
    --[[ this item has data]]
    local targetnodename = win.targetnode.getValue();
    if targetnodename~="" then
      local targetwin = getEntry(targetnodename);
      --[[ set the target ]]
      win.setTarget(targetwin);
    else
      --[[ clear the target ]]
      win.setTarget(nil);
    end
  end
end

function getEntry(nodename)
  --[[ is the target in our entries list? ]]
  local win = entries[nodename];
  if win then
    return win;
  end
  for k, v in ipairs(getWindows()) do
    if v.getDatabaseNode().getNodeName()==nodename then
      --[[ save the results for next time ]]
      entries[nodename] = v;
      --[[ done ]]
      return v;
    end
  end
  return nil;
end

function getActiveEntry()
  for k, v in ipairs(getWindows()) do
    if v.isActive() then
      return v;
    end
  end
  return nil;
end

function requestActivation(entry)
  for k, v in ipairs(getWindows()) do
    v.setActive(false);
  end
  entry.setActive(true);
end

function nextActor()
  local last = getActiveEntry();
  local entry = getNextActor(last);
  if last then
    -- See if the TurnComplete box has been checked
	if not last.turncomplete.getState(true) then
		-- Update Effects
		local effects = last.getPanel("effects");
		if effects and PreferenceManager.load(Preferences.EffectsEndOfTurnPref)==Preferences.Yes then
			effects.progressEffects();
		end
		
		-- Update Exhaustion
		local node = last.getDatabaseNode();
		local otherActivity = false;
		local exhaustionMultiplier = 1;
		if PreferenceManager.load(Preferences.ExhaustionHitsMultiplierPref) == Preferences.Yes then
			local percentDamaged = node.getChild("damage").getValue() / node.getChild("hits").getValue(); 
			if percentDamaged > 0.5 then 
				exhaustionMultiplier = 4;
			elseif percentDamaged > 0.25 then
				exhaustionMultiplier = 2;
			end
		end
		if node.getChild("activitymelee") then
			if node.getChild("activitymelee").getValue() > 0 then
				if PreferenceManager.load(Preferences.ExhaustionAutoTrackPref) == Preferences.Yes then 
					node.getChild("exhaustioncurrent").setValue(node.getChild("exhaustioncurrent").getValue() + (0.5 * exhaustionMultiplier));
				end
				otherActivity = true;
				node.getChild("activitymelee").setValue(0);
			end
		end
		if node.getChild("activitymissile") then
			if node.getChild("activitymissile").getValue() > 0 then
				if PreferenceManager.load(Preferences.ExhaustionAutoTrackPref) == Preferences.Yes then 
					node.getChild("exhaustioncurrent").setValue(node.getChild("exhaustioncurrent").getValue() + (0.16 * exhaustionMultiplier));
				end
				otherActivity = true;
				node.getChild("activitymissile").setValue(0);
			end
		end
		if node.getChild("activityconcentration") then
			if node.getChild("activityconcentration").getValue() > 0 then
				if PreferenceManager.load(Preferences.ExhaustionAutoTrackPref) == Preferences.Yes then 
					node.getChild("exhaustioncurrent").setValue(node.getChild("exhaustioncurrent").getValue() + (0.16 * exhaustionMultiplier));
				end
				otherActivity = true;
				node.getChild("activityconcentration").setValue(0);
			end
		end
		if PreferenceManager.load(Preferences.ExhaustionAutoTrackPref) == Preferences.Yes then 
			local pace = node.getChild("pace").getValue();
			node.getChild("exhaustioncurrent").setValue(node.getChild("exhaustioncurrent").getValue() + (Rules_Move.PaceExhaustion(pace) * exhaustionMultiplier));
		end
		node.getChild("pace").setValue(Rules_Move.PaceNone());

		-- Reduce the Activity Percent by 100 down to a minimum of 0
		last.activitypercent.setValue(last.activitypercent.getValue() - 100);
		if last.activitypercent.getValue() < 0 then
			last.activitypercent.setValue(0);
		end
		last.turncomplete.setState(true);
	end
  end
  if entry then
    requestActivation(entry);
  else
    nextPhase();
  end
end

function getNextActor(last)
	local entry = getNextWindow(last);
	while entry do
		local phases = entry.getPanel("active").phases.getValue();
		if string.find(phases, window.phasecounter.getValue()) then
			return entry;
		else
			entry = getNextWindow(entry);
		end
	end
	return entry;
end

function nextPhase()
	local msg = {};
	local current = getActiveEntry();
	-- clear currently active entry
	if current then
		current.setActive(false);
	end
	if window.phasecounter.getValue() < PreferenceManager.load(Preferences.RoundPhasesPref) then
		window.phasecounter.setValue(window.phasecounter.getValue() + 1);
		msg.text = "~~ Round " .. window.roundcounter.getValue() .. " - Phase " .. window.phasecounter.getValue() .. " ~~";
		msg.font = "narratorfont";
		msg.icon = "button_ctnextphase";
		ChatManager.deliverMessage(msg);
	else
		nextRound();
	end
end

function nextRound()
  local msg = {};
  local current = getActiveEntry();
  local resetinit = (PreferenceManager.load(Preferences.RetainInitPref)~=Preferences.Yes);
  -- clear currently active entry
  if current then
    current.setActive(false);
  end
  -- increment the round counter
  window.roundcounter.setValue(window.roundcounter.getValue() + 1);
  window.phasecounter.setValue(1);
  allPhases = getAllPhases();
  phasesVisible = getPhasesVisible();
  -- reset initiative, progress effects etc
  for k, v in ipairs(getWindows()) do
	if not v.turncomplete.getState(true) or PreferenceManager.load(Preferences.EffectsEndOfTurnPref)==Preferences.No then
		local effects = v.getPanel("effects");
		if effects then
		  effects.progressEffects();
		end
	end
    if resetinit then
      v.initiative.setValue(0);
    end
    v.turncomplete.setState(false);
	if PreferenceManager.load(Preferences.SkipBelowZeroHitsPref) == Preferences.Yes and (v.hits.getValue() - v.damage.getValue()) <= 0 then
		v.getPanel("active").phases.setValue("");
	else
		v.getPanel("active").phases.setValue(allPhases);
	end
	v.getPanel("active").phases.setVisible(phasesVisible);
	v.getPanel("active").phasesLabel.setVisible(phasesVisible);
  end
  -- write a message to the chat window
  if PreferenceManager.load(Preferences.RoundPhasesPref) == 1 then
	msg.text = "~~ Round " .. window.roundcounter.getValue() .. " ~~";
  else
	msg.text = "~~ Round " .. window.roundcounter.getValue() .. " - Phase " .. window.phasecounter.getValue() .. " ~~";
  end
  msg.font = "narratorfont";
  msg.icon = "button_ctnextround";
  ChatManager.deliverMessage(msg);
  -- done
end

function getAllPhases()
	local maxPhases = PreferenceManager.load(Preferences.RoundPhasesPref);
	local currentPhase = 2;
	local phases = "1";
	
	while currentPhase <= maxPhases do
		phases = phases .. "," .. currentPhase
		currentPhase = currentPhase + 1;
	end
	
	return phases;
end

function getPhasesVisible()
	if PreferenceManager.load(Preferences.RoundPhasesPref) == 1 then
		return false;
	else
		return true;
	end
end

function toggleVisibility()
--	if not enablevisibilitytoggle then
--		return;
--	end
	
	local visibilityon = window.button_global_visibility.getState();
	for k,v in pairs(getWindows()) do
		if v.type.getValue() ~= "pc" then
			if visibilityon ~= v.shownpc.getState() then
				v.shownpc.setState(visibilityon);
			end
		end
	end
end

-- Rest Functions
function restHours(hours)
	for i,ent in ipairs(getWindows()) do
		ent.restHours(hours);
	end
end

function restRemoveHits()
	for i,ent in ipairs(getWindows()) do
		ent.restRemoveHits();
	end
end

function restRemovePP()
	for i,ent in ipairs(getWindows()) do
		ent.restRemovePP();
	end
end

function restRemoveEffects()
	for i,ent in ipairs(getWindows()) do
		ent.restRemoveEffects();
	end
end

function restRemoveHitsPP()
	for i,ent in ipairs(getWindows()) do
		ent.restRemoveHits();
		ent.restRemovePP();
	end
end

function restRemoveHitsEffects()
	for i,ent in ipairs(getWindows()) do
		ent.restRemoveHits();
		ent.restRemoveEffects();
	end
end

function restRemovePPEffects()
	for i,ent in ipairs(getWindows()) do
		ent.restRemovePP();
		ent.restRemoveEffects();
	end
end

function restRemoveHitsPPEffects()
	for i,ent in ipairs(getWindows()) do
		ent.restRemoveHits();
		ent.restRemovePP();
		ent.restRemoveEffects();
	end
end

-- Initiative Functions
function clearAllInit()
	for i,ent in ipairs(getWindows()) do
		local node = ent.getDatabaseNode();
		if node then
			node.getChild("initiative").setValue(0);
		end
	end
end

function rollAllInit()
	rollNPCInit();
	rollPCInit();
end

function rollNPCInit()
	for i,ent in ipairs(getWindows()) do
		local node = ent.getDatabaseNode();
		if node.getChild("type").getValue() == "npc" then
			ent.rollInit(node);
		end
	end
end

function rollPCInit()
	for i,ent in ipairs(getWindows()) do
		local node = ent.getDatabaseNode();
		if node.getChild("type").getValue() == "pc" then
			ent.rollInit(node);
		end
	end
end

function removeTurnComplete()
	for i,ent in ipairs(getWindows()) do
		ent.turncomplete.setState(false);
	end
end

function deleteNPCs()
	for i,ent in ipairs(getWindows()) do
		local node = ent.getDatabaseNode();
		if node.getChild("type").getValue() == "npc" then
			removeFromTargets(node.getNodeName());
			ent.delete();
		end
	end
end

function removeFromTargets(nodeName)
	for i,ent in ipairs(getWindows()) do
		local node = ent.getDatabaseNode();
		for j, att in pairs(node.getChild("attacks").getChildren()) do
			if att.getChild("targetnode").getValue() == nodeName then
				att.getChild("targetnode").setValue(nil);
			end
		end
		for j, att in pairs(node.getChild("defences").getChildren()) do
			if att.getChild("targetnode").getValue() == nodeName then
				att.getChild("targetnode").setValue(nil);
			end
		end
	end
end

function toggleStats()

end

function toggleCombat()
	local globalCombat = window.button_global_combat.getValue();
	for i,ent in ipairs(getWindows()) do
		for i, pan in ipairs(ent.panels.getWindows()) do
			if pan.getClass() == "combatpanel_active" then
				if pan.isDisplayed() ~= globalCombat then
					pan.toggleForceDisplay();
					ent.active_button.refresh();
				end
			end
		end
	end
end

function toggleEffects()
	local globalEffects = window.button_global_effects.getValue();
	for i,ent in ipairs(getWindows()) do
		for i, pan in ipairs(ent.panels.getWindows()) do
			if pan.getClass() == "combatpanel_effects" then
				if pan.isDisplayed() ~= globalEffects then
					pan.toggleForceDisplay();
					ent.effects_button.refresh();
				end
			end
		end
	end
end

function toggleNotes()
	local globalNotes = window.button_global_notes.getValue();
	for i,ent in ipairs(getWindows()) do
		for i, pan in ipairs(ent.panels.getWindows()) do
			if pan.getClass() == "combatpanel_notes" then
				if pan.isDisplayed() ~= globalNotes then
					pan.toggleForceDisplay();
					ent.notes_button.refresh();
				end
			end
		end
	end
end