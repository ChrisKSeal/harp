function onInit()
  -- add a menu entry to delete this defence
  registerMenuItem("Delete defence","delete",6);
end

function onMenuSelection(item)
  if item then
    if item==6 then
      delete();
      return true;
    end
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

function setTargetFromToken(node)
  if node then
    targetnode.setValue(node.getNodeName());
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

function updateAttacks(parryAmount)
	local node = windowlist.window.windowlist.window.getDatabaseNode();

	if not node then
		return;
	end
  
	for k,att in pairs(node.createChild("attacks").getChildren()) do
		if att.isOwner() or User.isHost() then
			local ob = att.createChild("ob","number").getValue();
			local attType = att.createChild("type","number").getValue();
			if attType < 9 or attType > 10 then  -- only update attacks that aren't Elemental Attacks or Special Attacks
					att.createChild("attack","number").setValue(ob - parryAmount);
			end
		end
	end
  -- done
  return;
end