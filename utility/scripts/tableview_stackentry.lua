-- Die Stack entries

local portraitwidget = nil;
local resolver = nil;

function onInit()
  local customDataNode;
  if super and super.onInit then
    super.onInit();
  end
  -- store a reference to the attack grid
  if windowlist and windowlist.window then
    resolver = windowlist.window;
  end
  -- track changes to the customData
  customDataNode = getDatabaseNode().createChild("customData");
  customDataNode.onChildUpdate = redraw;
  redraw();
  if resolver then
    registerMenuItem("Resolve", "resolve", 3); 
  end
end

function redraw()
  local customData;
  local actorNodeName = "";
  local actorName;
  local actionTitle;
  -- get the custom data
  customData = StackManager.decode(getDatabaseNode());
  -- get the protagonist's charsheet node
  if customData.actorNodeName then
    actorNodeName = customData.actorNodeName;
  end
  -- what type of roll is it?
  if customData.tableType==Rules_Constants.TableType.Attack then
    actorName = customData.attackerName;
	if string.len(customData.defenderName) > 0 then
		actionTitle = customData.name .. " vs " .. customData.defenderName;
	else
		actionTitle = customData.name .. " vs <NO TARGET>";
	end
  elseif customData.tableType==Rules_Constants.TableType.Other then
    actorName = customData.actorName;
    actionTitle = customData.name;
  else
    actorName = "(Unknown)";
    actionTitle = "Unexpected action type: " .. customData.tableType;
  end
  -- set the display properties
  if actorNodeName~="" then
    local starts;
    local ends;
    local actorId;
    -- extract the node id (last section of the full path name)
    starts, ends, actorId = string.find(actorNodeName,"[[^%.]*%.]*([^%.]*)$");
    if actorId then
      portraitwidget = token.addBitmapWidget("portrait_" .. actorId .. "_miniportrait");
    end
  end
  if portraitwidget and portraitwidget.getBitmapName() then
    token.setIcon(nil);
  end  
  name.setValue(actorName);
  result.setValue(customData.dieResult);
  title.setValue(actionTitle);
  -- done
end

function onMenuSelection(level1)
  if level1 == 3 then
    resolve();
  end
end

function resolve()
  -- Resolve stacked roll
  local customData = StackManager.decode(getDatabaseNode());
  if resolver and (customData.tableType==Rules_Constants.TableType.Attack or customData.tableType==Rules_Constants.TableType.Other) then 
    customData.title = name.getValue()..": "..title.getValue();
	Rules_Combat.setAddCrits(customData);
	Rules_Combat.setAltCrit(customData);
	Rules_Combat.setLevels(customData);
	Rules_Combat.setUnmodifiedRoll(customData);
    resolver.resolve(customData,self);
  end
end
