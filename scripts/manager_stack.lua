-- Stack manager module
local scriptName = "ManagementScript_StackManager.lua";

local queuelist = {};
local stacknode = nil;

-- Public routines

function isActive()
  local usestack = PreferenceManager.load(Preferences.UseDieStackPref);
  if usestack and usestack==Preferences.No then
    return false;
  else
    return true;
  end
end

function addEntry(customData)
  local node;
  local target;
  if User.isHost() then
    target = stacknode;
  else
    target = getMyQueue(User.getUsername());
  end
  if not target then
    -- nothing to do, can't find the target
    ErrorHandler.showWarning("Unable to send die roll to GM: message stack missing","addEntry",scriptName,true);
    return;
  end
  if not User.isHost() and not isActive() then
    -- stack is disabled, don't add the node
    ErrorHandler.showWarning("The GM has disabled this function","addEntry",scriptName,true);
    return;
  end
  node = target.createChild();
  if node then
    encode(node, customData);
  else
    ErrorHandler.showWarning("Unable to send die roll to GM: could not create the database node","addEntry",scriptName,true);
  end
  if User.isHost() then
    -- open the table resolver
    if not Interface.findWindow("tableresolver","") then
      Interface.openWindow("tableresolver","");
    end
  else
    -- let the host know
    if node and ChatManager and ChatManager.sendCommand then
      -- send a stack command to the host, with the child node path as a parameter
      ChatManager.sendCommand("stack",node.getNodeName());
    end
  end
end

function handleStackCommand(name,text,sender)
  if text~="" then
    local node = DB.findNode(text);
    if node and stacknode then
      -- copy the queued item to the stack
      copyNode(stacknode,node,true);
      -- delete the item from the queue
      node.delete();
      -- open the table resolver
      if not Interface.findWindow("tableresolver","") then
        Interface.openWindow("tableresolver","");
      end
    end
  end
end

function copyNode(parent,source,rename)
  local nodeName,nodeType,newNode;
  nodeName = source.getName();
  nodeType = source.getType();
  if nodeType=="string" or nodeType=="number" then
    local nodeValue = source.getValue();
    newNode = parent.createChild(nodeName,nodeType);
    newNode.setValue(nodeValue);
    return;
  end
  if nodeType=="node" then
    if rename then
      newNode = parent.createChild();
    else
      newNode = parent.createChild(nodeName);
    end
    for k,child in pairs(source.getChildren()) do
      copyNode(newNode,child);
    end
  end
end

function decode(stackEntryNode)
  local customData = {};
  local customDataNode = stackEntryNode.createChild("customData");
  local modifiers = nil;
  local modifiersNode = nil;
  -- error check, return an empty table
  if not customDataNode then
    return customData;
  end
  -- common fields
  getField(customDataNode,customData,"tableType","");
  getField(customDataNode,customData,"name","");
  getField(customDataNode,customData,"dieResult",0);
  getField(customDataNode,customData,"unmodifiedRoll",0);
  getField(customDataNode,customData,"dieType","");
  getField(customDataNode,customData,"type","");
  getField(customDataNode,customData,"tableID","");
  getField(customDataNode,customData,"actorNodeName","");
  getField(customDataNode,customData,"actorName","");
  getField(customDataNode,customData,"rollType",0);
  if customData.rollType==Rules_Constants.SkillType.Attack then
	getField(customDataNode,customData,"size",0);
  end
  -- type-specific fields
  if customData.tableType==Rules_Constants.TableType.Attack then
    getField(customDataNode,customData,"armorType",1);
    getField(customDataNode,customData,"attackerNode","");
    getField(customDataNode,customData,"attackerName","");
    getField(customDataNode,customData,"attackerNodeName","");
    getField(customDataNode,customData,"defenderNodeName","");
    getField(customDataNode,customData,"defenderName","");
    getField(customDataNode,customData,"attackDBNodeName","");
    getField(customDataNode,customData,"attackDBNodeClass","");
    getField(customDataNode,customData,"critTableID","");
    getField(customDataNode,customData,"critTableName","");
    getField(customDataNode,customData,"fumbleValue",0);
    getField(customDataNode,customData,"maxResultLevel",0);
  end
  -- modifiers
  modifiersNode = customDataNode.createChild("modifiers");
  modifiers = {};
  if modifiersNode and modifiersNode.getChildren() then
    for k,node in pairs(modifiersNode.getChildren()) do
      local desc = node.createChild("description","string").getValue();
      local val = node.createChild("value","number").getValue();
      table.insert(modifiers,{description=desc, value=val});
    end
  end
  customData.modifiers = modifiers;
  -- done
  return customData;
end

function encode(stackEntryNode, customData)
  local customDataNode = stackEntryNode.createChild("customData");
  local modifiersNode = nil;
  -- common fields
  setField(customDataNode,customData,"tableType","string");
  setField(customDataNode,customData,"name","string");
  setField(customDataNode,customData,"dieResult","number");
  setField(customDataNode,customData,"unmodifiedRoll","number");
  setField(customDataNode,customData,"dieType","string");
  setField(customDataNode,customData,"type","string");
  setField(customDataNode,customData,"tableID","string");
  setField(customDataNode,customData,"actorNodeName","string");
  setField(customDataNode,customData,"actorName","string");
  setField(customDataNode,customData,"rollType","number");
  if customData.rollType==Rules_Constants.SkillType.Attack then
	setField(customDataNode,customData,"size","number");
  end
  -- type-specific fields
  if customData.tableType==Rules_Constants.TableType.Attack then
    setField(customDataNode,customData,"armorType","number");
    setField(customDataNode,customData,"attackerNode","string");
    setField(customDataNode,customData,"attackerNodeName","string");
    setField(customDataNode,customData,"attackerName","string");
    setField(customDataNode,customData,"defenderNodeName","string");
    setField(customDataNode,customData,"defenderName","string");
    setField(customDataNode,customData,"attackDBNodeName","string");
    setField(customDataNode,customData,"attackDBNodeClass","string");
    setField(customDataNode,customData,"critTableID","string");
    setField(customDataNode,customData,"critTableName","string");
    setField(customDataNode,customData,"fumbleValue","number");
    setField(customDataNode,customData,"maxResultLevel","number");
  end
  -- modifiers
  modifiersNode = customDataNode.createChild("modifiers");
  if modifiersNode and customData.modifiers then
    for i = 1, #customData.modifiers do
      node = modifiersNode.createChild();
      if node then
        setField(node,customData.modifiers[i],"description","string");
        setField(node,customData.modifiers[i],"value","number");
      end
    end
  end
  -- done
  return;
end

-- Initialization

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  if User.isLocal() then
    return;
  end
  if User.isHost() then
    -- TODO: clear the stack
    -- DB.createNode("stack").delete();
    stacknode = DB.createNode("stack");
    -- clear any remaining queues
    DB.createNode("queues").delete();
    -- register the stack command handler
    if ChatManager and ChatManager.registerCommandHandler then
      ChatManager.registerCommandHandler("stack",handleStackCommand);
    end
    -- capture user login
    User.onLogin = onLogin;
  end
end

-- User login and logout

function onLogin(username, activated)
  if activated then
    local myqueue;
    -- grant access to the list of queues
    DB.createNode("queues").addHolder(username,false);
    -- reset node owners (to fix FG bug)
    resetOwners();
    -- find/create a queue for this user
    myqueue = getMyQueue(username);
    -- found the queue?
    if myqueue then
      -- save a reference to it
      queuelist[username] = myqueue;
    end
  else
    -- look for an existing queue
    local myqueue = queuelist[username];
    -- found the queue?
    if myqueue then
      -- remove the reference
      queuelist[username] = nil;
      -- delete the queue
      myqueue.delete();
    end
    -- revoke access to the list
    DB.createNode("queues").removeHolder(username);
  end
end

-- Internal support routines

function resetOwners()
  if not User.isHost() then
    return;
  end
  DB.createNode("queues").addHolder(User.getUsername(),true);
  for username,node in pairs(queuelist) do
    node.addHolder(username,true);
  end
end

function getMyQueue(username)
  local queues = DB.findNode("queues");
  local newqueue = nil;
  if not queues then
    return nil;
  end
  if User.isHost() then
    for k,queue in pairs(queues.getChildren()) do
      if queue.getOwner()==username then
        return queue;
      end
    end
  else
    if username~=User.getUsername() then
      -- a client cannot get the queue of another client
      return nil;
    end
    for k,queue in pairs(queues.getChildren()) do
      if queue.isOwner() then
        return queue;
      end
    end
    -- client cannot create a queue if it doesn't exist
    return nil;
  end
  -- create a new queue for this user
  newqueue = queues.createChild();
  newqueue.addHolder(username,true);
  return newqueue;
end

function getField(node, customData, fieldname, defaultvalue)
  if node and node.getChild(fieldname) then
    customData[fieldname] = node.getChild(fieldname).getValue();
  else
    customData[fieldname] = defaultvalue;
  end
end

function setField(node, customData, fieldname, datatype)
  if node then
    node.createChild(fieldname, datatype).setValue(customData[fieldname]);
  end
end
