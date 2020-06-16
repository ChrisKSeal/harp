
function applyModifierStackToRoll(draginfo)
  if ModifierStack.isEmpty() then
    --[[ do nothing ]]
  elseif draginfo.getNumberData() == 0 and draginfo.getDescription() == "" then
    draginfo.setDescription(ModifierStack.getDescription());
    draginfo.setNumberData(ModifierStack.getSum());
  else
    local originalnumber = draginfo.getNumberData();
    local numstr = tostring(originalnumber);
    if originalnumber > 0 then
      numstr = "+" .. originalnumber;
    end

    local moddesc = ModifierStack.getDescription(true);
    local desc = draginfo.getDescription();
    
    if numstr ~= "0" then
      desc = desc .. " " .. numstr;
    end
    if moddesc ~= "" then
      desc = desc .. " (" .. moddesc .. ")";
    end
    
    draginfo.setDescription(desc);
    draginfo.setNumberData(draginfo.getNumberData() + ModifierStack.getSum());
  end
  
  ModifierStack.reset();
end

---------------------------------------------------------
-- TTTTTTTT   OO          DDDD       OO
--    T      O  O         D   D     O  O 
--    T      O  O         D   D     O  O 
--    T      O  O         D   D     O  O 
--    T      O  O         D   D     O  O 
--    T      O  O         D   D     O  O 
--    T      O  O         D   D     O  O 
--    T       OO          DDDD       OO
--
--  TODO: Tony - ERROR HANDLING and CHECKING 
--        This code must be rock-solid as any errors inside here cause FG to crash on exit
--
-------------------------------------

function onDiceLanded(draginfo)
  local custData = nil;
  draginfo, custData = Rules_CustomData.Prepare(draginfo);
  if not draginfo then
	return;
  end
  if not custData or type(custData)~="table" or custData.ctNodeInit or custData.diceLanded then
    applyModifierStackToRoll(draginfo);
    return mergeD100Results(draginfo);
  end
  if custData.type==Rules_Constants.DataType.DieRoll then
    custData.nestedCustomData = custData;
    custData.type = "D100DieRoll";
  end
  if custData.type=="D100DieRoll" then
    if custData.dieType ~= Rules_Constants.DieType.Closed and
       custData.dieType ~= Rules_Constants.DieType.LowOpenEnded and
       custData.dieType ~= Rules_Constants.DieType.OpenEnded and
       custData.dieType ~= Rules_Constants.DieType.HighOpenEnded then
      applyModifierStackToRoll(draginfo);
	  return;
	end
	
    if Dice.handleChatwindowD100(draginfo, custData) then
      -- the dice were 'exploded' inside handleChatwindowD100 so we do not need to do any further processing 
      return true;
    end
    -- closed ended or the value did not result in any dice explosion
  elseif custData.type == "DiceExplosion" then
    if not custData.dieType or string.sub(custData.dieType,1,12) ~= "D100Exploded" then
      displayD100Results(draginfo, dieList);
      return true;
    end
    openDirection = string.sub(custData.dieType,13,string.len(custData.dieType));
    handled, draginfo = Dice.explodeChatwindowD100(draginfo, openDirection, custData);
    if handled then
      return true;
    end
  else
    -- this is the 'fall-through' code. i.e. if the roll was not handled by the code above then it's most likely a simple dice rolled in the chatwindow so we add mods from the modbox and display the result
    applyModifierStackToRoll(draginfo);
    return true;
  end
  if not draginfo.getCustomData().dieResults then
    applyModifierStackToRoll(draginfo);
    return;
  end

  -- handle the result here so the value is shown as a single result rather than a d100 and a d10
  local dieList = {};
  for i,val in ipairs(draginfo.getCustomData().dieResults) do
    local dieListEntry = {["result"]=val, ["type"]="d100"};
    table.insert(dieList, dieListEntry);
  end
  
  if custData.nestedCustomData then
    -- process a normal attack or skill roll
    processRMCDieRoll(dieList, draginfo, custData.nestedCustomData);
  end
  -- show the results
  displayD100Results(draginfo, dieList);
  return true;
end

function displayD100Results(draginfo, dieList)
  local msg = {font="systemfont"};
  local custData = draginfo.getCustomData();
  local title = "";
  local reveal = false;
  -- use nested data, where present
  if custData.nestedCustomData then
    -- find the roll title
    if custData.nestedCustomData.name then
      title = custData.nestedCustomData.name;
    end
    -- set the message sender (and hide/reveal dice for GM rolls)
    if User.isHost() and custData.nestedCustomData.revealDice then
      reveal = true;
    end
  else
    -- find the roll title
    if custData.name then
      title = custData.name;
    end
    -- set the message sender (and hide/reveal dice for GM rolls)
    if User.isHost() and custData.revealDice then
      reveal = true;
    end
  end
  -- apply any remaining modifiers to the roll
  applyModifierStackToRoll(draginfo);
  -- the string data object
  if draginfo.getStringData() and draginfo.getStringData() ~= "" then
    if title=="" then
      title = draginfo.getStringData();
    else
      title = title..", "..draginfo.getStringData();
    end
  end
  -- the description object
  if draginfo.getDescription() and draginfo.getDescription() ~= "" then
    if title=="" then
      title = draginfo.getDescription();
    else
      title = title..", "..draginfo.getDescription();
    end
  end
  
  deliverDiceMessage(title,dieList,draginfo.getNumberData(),reveal);
end

function mergeD100Results(draginfo)
  local dielist = draginfo.getDieList();
  -- create a custom delivery message
  local text = draginfo.getStringData();
  if (not text) or text=="" then
	text = draginfo.getDescription();
  end
  local customData = draginfo.getCustomData();
  if customData then
	  if customData.ctNodeInit then
		local initiative = 0;
		for i,v in ipairs(dielist) do
			initiative = initiative + v.result;
		end
		initiative = initiative + draginfo.getNumberData();
		customData.ctNodeInit.getChild("initiative").setValue(initiative);
	  end
	  
	  ----------- Put code in here to store result of rr
	  
	  if customData.diceLanded then
		text = Rules_CustomData.DiceLanded(customData, dielist);
	  end
  end
  if dielist and #dielist==2 then
    local d10Found = false;
    local d100Found = false;
    local d100Result = 0;
    for i,v in ipairs(dielist) do
      if v.type == "d100" then
        d100Found = true;  
        d100Result = d100Result + (tonumber(v.result) or 0);
      end
      if v.type == "d10" then
        d10Found = true;
        d100Result = d100Result + (tonumber(v.result) or 0);
      end
    end
    if d10Found and d100Found then
      deliverDiceMessage(text,{{type="d100",result=d100Result}},draginfo.getNumberData());
      return true;
    end
  end
  deliverDiceMessage(text,dielist,draginfo.getNumberData());
  return true;
end

function deliverDiceMessage(text,dielist,modifier,reveal)
  local msg = {font="systemfont"};
  if type(reveal)=="nil" then
    -- use standard rules
    if User.isHost() then
      if ChatManager.getDieRevealFlag() then
        reveal = true;
      end
    end
  end
  if reveal then
    msg.dicesecret = false;
  end
  if User.isHost() then
    msg.sender = GmIdentityManager.getCurrent();
  else
    msg.sender = User.getIdentityLabel();
  end
  -- set the message parameters
  msg.text = text;
  msg.dice = dielist;
  msg.diemodifier = modifier;
  -- Display dice total based on preference.
  if  PreferenceManager.load(Preferences.DiceTotalPref) == Preferences.Yes then
	msg.dicedisplay = 1;
  end
  -- done  
  deliverMessage(msg);
end

function onDrop(x, y, draginfo)
  draginfo.resetType();
  if (User.isHost() and draginfo.isType(Rules_Constants.DataType.AttackEffects)) then
    ChatManager.handleCustomData(draginfo);
    return true;
  elseif draginfo.getType() == "number" then
    applyModifierStackToRoll(draginfo);
  end
end

function moduleActivationRequested(module)
  local msg = {};
  msg.text = "Players have requested permission to load '" .. module .. "'";
  msg.font = "systemfont";
  msg.icon = "indicator_moduleloaded";
  addMessage(msg);
end

function moduleUnloadedReference(module)
  local msg = {};
  msg.text = "Could not open sheet with data from unloaded module '" .. module .. "'";
  msg.font = "systemfont";
  addMessage(msg);
end

function onReceiveMessage(msg)

  	-- Special handling for client-host behind the scenes communication
	if ChatManager.processSpecialMessage(msg) then
		return true;
	end

	if ChatManager and ChatManager.executeCommand then
		return ChatManager.executeCommand(msg);
	end
  
	-- Otherwise, let FG know to do standard processing
	return false;
	
end

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  ChatManager.registerControl(self);
  
  if User.isHost() then
    Module.onActivationRequested = moduleActivationRequested;
  end

  Module.onUnloadedReference = moduleUnloadedReference;
end

function onClose()
  ChatManager.registerControl(nil);
end

function processRMCDieRoll(dieList, draginfo, custData)
  local unmodifiedRoll = 0;
  local modroll = 0;
  if not custData then
    return;
  end
  
  for k, d in pairs(dieList) do
    unmodifiedRoll = unmodifiedRoll + d["result"];
	if k == 1 then
		custData.unmodifiedRoll = unmodifiedRoll;
	end
  end
  Debug.chat(unmodifiedRoll);
  
  -- need to show modifiers (from attack/skill custom data) in the chat window text
  if custData.modifiers then
    local modifierString = "";
    local totalModifier = 0;
    
    for i, mod in pairs(custData.modifiers) do
      if not mod.gmonly then
        if modifierString ~= "" then
          modifierString = modifierString .. ", ";
        end
        if mod.description then
          modifierString = modifierString .. mod.description .. " ";
        end
        if tonumber(mod.value) then
          if tonumber(mod.value) > 0 then
            modifierString = modifierString .. "+" ..  mod.value;
          else
            modifierString = modifierString .. mod.value;
          end
          totalModifier = totalModifier + mod.value;
        end
        draginfo.setDescription(modifierString);
        draginfo.setNumberData(totalModifier);
		modroll = unmodifiedRoll + totalModifier;
      end
    end
  end
  Debug.chat(modroll);
  -- Unless the roll is an attack type, the size doesn't matter
  if customData.rollType == Rules_Constants.SkillType.Attack then
    customData.size = 3;
  end
  

  if User.isHost() and custData.tableID~="" then
    -- GM-initiated roll, add to the stack
    custData.dieResult = unmodifiedRoll;
    StackManager.addEntry(custData);
  elseif custData.tableID~="" and PreferenceManager.load(Preferences.UseDieStackPref) == Preferences.Yes then
    -- player initiated roll, add to the 'stack' for the GM to resolve
   custData.dieResult = unmodifiedRoll;
   StackManager.addEntry(custData);
  end
  -- done
  return;
end
