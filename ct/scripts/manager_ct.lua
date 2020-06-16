-- combat support routines

function isValidID(idnum)
	local ctEntriesNode = DB.findNode("combattracker.entries");
	if ctEntriesNode then
		for k, ent in pairs(ctEntriesNode.getChildren()) do
			if ent.getChild("idnum") and idnum == ent.getChild("idnum").getValue() then
				return false;
			end
		end
	end
	return true;
end

-- register the default panels
function onInit()
  if User.isLocal() then
    return;
  end
  register("active","combatpanel_active","indicator_combat",false);
  register("effects","combatpanel_effects","indicator_effect",false);
  register("notes","combatpanel_notes","indicator_casterprep",true);
end

-- pc targeting
  
local targetlist = {};

function removeTokenFromTargets(tokenId)
	for k, target in pairs(targetlist) do
		if target.token and target.token.getId() == tokenId then
			target.token = nil;
		end
	end
end

function setTarget(pcid,targetpath,ref)
  local targetnode, entry;
  -- clear any existing targeting by this pc
  if targetlist[pcid] then
    local token = targetlist[pcid].token;
    targetlist[pcid] = nil;
    if token then
      token.setTarget(false,pcid);
    end
  end
  -- find the pc entry in the combat tracker
  entry = getPCEntry(pcid);
  -- find the target combat tracker node (could be nil)
  targetnode = DB.findNode(targetpath);
  -- if nil, there is little left to do except clear the targeting
  if not targetnode then
    if entry then
      entry.setTarget("");
    end
    -- done
    return;
  end
  -- check if a pc is trying to target itself
  local link = targetnode.createChild("link","windowreference");
  local class,record = link.getValue();
  local pcpath = "charsheet." .. pcid;
  if record and record==pcpath then
    -- clear the target indicator
    ref.setTarget(false,pcid);
    return;
  end
  -- create an entry for the list
  targetlist[pcid] = {target=targetpath,token=ref};
  -- set the tracker targeting
  if entry then
    entry.setTarget(targetpath);
  end
  -- done
end

function getPCEntry(pcid)
  if User.isHost() then
    local tracker = Interface.findWindow("combattracker","combattracker");
    local pcpath = "charsheet." .. pcid;
    if not tracker then
      return nil;
    end
    for i,entry in ipairs(tracker.list.getWindows()) do
      local class,record = entry.link.getValue();
      if record and record==pcpath then
        return entry;
      end
    end
    return nil;
  else
    return nil;
  end
end

function getCombatantCTNode(node)
	local nodeName = node.getNodeName();
	local ctEntriesNode = DB.findNode("combattracker.entries");
	if ctEntriesNode then
		for k, ent in pairs(ctEntriesNode.getChildren()) do
			local ctNodeType, ctNodeName = ent.getChild("link").getValue();
			if nodeName == ctNodeName or node == ent then
				return ent;
			end
		end
	end
	return nil;
end

-- panel manager for the combat tracker

local panellist = {};
local panelid  = {};
local count = 0;

function register(name, class, icon, gmonly)
  local paneldata = {};
  local id = 0;
  -- check we have valid parameters
  if not name or not class or not icon then
    return false;
  end
  -- check if the entry already exists
  if panelid[name] then
    id = panelid[name];
  else
    count = count + 1;
    id = count;
    panelid[name] = id;
  end
  -- create the data structure
  paneldata.name = name;
  paneldata.icon = icon;
  paneldata.windowclass = class;
  paneldata.gmonly = gmonly;
  -- add/update the entry
  panellist[id] = paneldata;
  return true;  
end

function getPanels()
  return panellist;
end
