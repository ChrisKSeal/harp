isAttacks = true;
initialised = false;

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  -- attacks or defences?
  if getName()=="attacks" then
    isAttacks = true;
  else
    isAttacks = false;
  end
  -- allow default entries to be created
  initialised = true;
  -- force a check for empty slots
  onListRearranged(true);
end

function onMenuSelection(item)
  if item then
    if item==5 then
      local win = createWindow();
      win.open.setValue("weapon",win.getDatabaseNode().getNodeName());
      return true;
    end
  end
end

function addEntry(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();
  
  -- copy the weapon/shield data
  Utilities.copyWeapon(source,newnode);

  -- Shortcut
  newentry.open.setValue("weapon",newnode.getNodeName());
  
  return newentry;
end

function addSpellNode(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();

  -- Descriptive fields
  if source.getChild("name") then
    newnode.createChild("name","string").setValue(source.getChild("name").getValue());
  end

  -- Shortcut
  newentry.open.setValue("spell",source.getNodeName());
  
  return newentry;
end

function addItemNode(source)
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();

  -- Descriptive fields
  if source.getChild("name") then
    newnode.createChild("name","string").setValue(source.getChild("name").getValue());
  end

  -- Shortcut
  newentry.open.setValue("item",source.getNodeName());
  
  return newentry;
end

function addMANode(source)
  local bonus = 0;
  local tableID = "CLT-09";
  local tableName = "";
  if source.getChild("bonus") then
    bonus = source.getChild("bonus").getValue();
  end
  if source.getChild("type") and source.getChild("type").getValue()==2 then
    tableID = "CLT-08";
    tableName = "";
  end
  for rnk=1,4 do
    local rankNode = source.getChild("rank" .. rnk);
    if rankNode and rankNode.getValue()>0 then
      local newentry = createWindow();
      local newnode = newentry.getDatabaseNode();
      local attknode = nil;

      -- Descriptive fields
      if source.getChild("name") then
        newnode.createChild("name","string").setValue(source.getChild("name").getValue() .. " (Rank " .. rnk .. ")");
      end
      newnode.createChild("type","number").setValue(8); -- 8 is Natural Weapon

      -- Combat stats
      newnode.createChild("ob","number").setValue(rankNode.getValue()+bonus);
      newnode.createChild("fumble","number").setValue(2);
      newnode.createChild("max_level","number").setValue(rnk);
      
      -- Attack table
      attknode = newnode.createChild("attacktable");
      attknode.createChild("tableid","string").setValue(tableID);
      attknode.createChild("name","string").setValue(tableName);
      
      -- Shortcut
      newentry.open.setValue("weapon", newnode.getNodeName());
    end
  end
  return;
end

function onDrop(x, y, draginfo)
  if draginfo.isType("shortcut")  then
    local class = draginfo.getShortcutData();
    local source = draginfo.getDatabaseNode();
    if source and class == "weapon" then
      addEntry(source);
      return true;
    elseif source and class == "spell" then
      addSpellNode(source);
      return true;
    elseif source and class == "item" then
      addItemNode(source);
      return true;
    end
  end
  return false;
end

function onSortCompare(w1, w2)
  local n1 = w1.getDatabaseNode();
  local n2 = w2.getDatabaseNode();
  if n1.getChild("order") and n2.getChild("order") then
    return n1.getChild("order").getValue() > n2.getChild("order").getValue();
  elseif n1.getChild("order") then
    return false;
  elseif n2.getChild("order") then
    return true;
  elseif w1.name.getValue() == "" then
    return true;
  elseif w2.name.getValue() == "" then
    return false;
  end
  return n1.getNodeName() > n2.getNodeName();
end

function onListRearranged(changed)
  if initialised and changed and User.isHost() and (#getWindows()==0) then
    local win = createWindow();
    win.open.setValue("weapon", win.getDatabaseNode().getNodeName());
    if not isAttacks then
      -- name the default defence 'Parry'
      win.name.setValue("Parry");
    end
  end
end
