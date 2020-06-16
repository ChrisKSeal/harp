--[[ ###################
--
-- The rollAttack() function creates a customData object with the following format
-- 
--  { armorType = 7,
--    attackDBNodeName = "",
--    attackDBNodeClass = "weapon",
--    attackerName = "Alan",
--    attackerNodeName = "tracker.id-00004",
--    actorName = "Alan",
--    actorNodeName = "charsheet.id-00001",
--    defenderName = "Colin",
--    defenderNodeName = "npc.id-00002",
--    dieType = Rules_Constants.DieType.HighOpenEnded,
--    fumbleValue = 4,
--    maxResultLevel = 4,
--    modifiers =
--    { 1 = {description = "Attack bonus", value = 40},
--      2 = {description = "Defence bonus", value = -15},
--      3 = {description = "Bonus vs AT", value = -5},
--      4 = {description = "Partial cover", value = -10}
--    },
--    name = "Longsword",
--    revealDice = false,
--    tableType = Rules_Constants.TableType.Attack,
--    tableID = "ALT04",
--    type = Rules_Constants.DataType.DieRoll
--  }
--
-- It then invokes throwDice("dice",{"d100","d10"},0,"",customData).
--
-- ################### ]]

local attacknode = nil;
local ownernode  = nil;

function onInit()
	attacknode = getDatabaseNode();
	ownernode  = attacknode.getParent().getParent();
	-- add a menu entry to delete this attack
	registerMenuItem("Delete attack","delete",6);
	-- track changes and update the Notes section
	if attacknode then
		if attacknode.createChild("attacktable") and attacknode.createChild("attacknode.tableid","string") then
			attacknode.createChild("attacktable.tableid","string").onUpdate = updateNotes;
		end
		if attacknode.createChild("chance","string") then
			attacknode.createChild("chance","string").onUpdate = updateNotes;
		end
	end
	if ownernode then
		if ownernode.createChild("type","string") then
			ownernode.createChild("type","string").onUpdate = updateNotes;
		end
	end
	-- force an update
	updateNotes();
end

function onClose()
	if attacknode then
		if attacknode.createChild("attacktable") and attacknode.createChild("attacknode.tableid","string") then
			attacknode.createChild("attacktable.tableid","string").onUpdate = function () end;
		end
		if attacknode.createChild("chance","string") then
			attacknode.createChild("chance","string").onUpdate = function () end;
		end
	end
	if ownernode then
		if ownernode.createChild("type","string") then
			ownernode.createChild("type","string").onUpdate = function () end;
		end
	end
end

function rollAttack()
	local attackNode = getDatabaseNode();
    local customData = Rules_CustomData.Attack(attackNode, targetnode.getValue()); 
  
  -- invoke the attack roll
  if customData then
    ChatManager.throwDice("dice",{"d10","d100"},0,"",customData);
  end
end

function dragAttack(button, x, y, dragData)
  if not dragData.isType("dice") then
	local attackNode = getDatabaseNode();
    local customData = Rules_CustomData.Attack(attackNode, targetnode.getValue()); 
    -- chat window dice rolling
    dragData.setType("dice");
    dragData.setDieList({"d100","d10"});
    dragData.setCustomData(customData);
  end
  return true;
end

function onMenuSelection(item)
  if item then
    if item==6 then
      delete();
      return true;
    end
  end
end

local updating = false;

function updateNotes()
  if not updating then
    updating = true;
	local tableid = "";
    local tp = "";
	local tablename = "";
	if ownernode then
		if ownernode.createChild("type","string") then
			tp = ownernode.createChild("type","string").getValue();
		end
	end
	if attacknode then
		if attacknode.getChild("attacktable") and attacknode.createChild("attacknode.tableid","string") then
			tableid = attacknode.createChild("attacktable.tableid","string").getValue();
		end
		if attacknode.getChild("attacktable") and attacknode.createChild("attacknode.name","string") then
			tablename = attacknode.createChild("attacktable.name","string").getValue();
		end
	end

    if tp~="pc" then
      local val = "";
		if attacknode.createChild("chance","string") then
			val = attacknode.createChild("chance","string").getValue();
		end
    end
    if tableid=="" then
      tableicon.setIcon("icon_notable");
      tableicon.setTooltipText("No attack table.");
      tableicon.setHoverCursor("arrow");
    else
      tableicon.setIcon("icon_table");
      tableicon.setTooltipText(tablename);
      tableicon.setHoverCursor("hand");
    end
    updating = false;
  end
end

function getTarget()
  return target;
end

function setTarget(win)
  if win then
    targetnode.setValue(win.getDatabaseNode().getNodeName());
  else
    targetnode.setValue("");
  end
end

function testDelete()
  if #(windowlist.getWindows()) > 1 and name.getValue()=="" then
    delete();
  end
end

function testNew()
  if name.getValue()~="" then
    local win = windowlist.createWindow();
    win.open.setValue("weapon",win.getDatabaseNode().getNodeName());
  end
end

function delete()
  local last = windowlist.getPrevWindow(window);
  if last then
    last.name.setFocus();
  end
  getDatabaseNode().delete();
end
