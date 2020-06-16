
SPECIAL_MSGTYPE_DICETOWER = "dicetower";

local commandhandlers = {};

-- Hotkey handling for custom data objects
function hotkeyActivated(draginfo)
  if (User.isHost() and draginfo.isType(Rules_Constants.DataType.AttackEffects))
		or draginfo.isType("Hotkey:SkillRoll") 
		or draginfo.isType("Hotkey:MMSkillRoll") 
		or draginfo.isType("Hotkey:StatRoll")
		or draginfo.isType("Hotkey:RR") then
    handleCustomData(draginfo);
    return true;
  end
end

-- Custom draginfo handling
function handleCustomData(draginfo)
  if User.isHost() and draginfo.isType(Rules_Constants.DataType.AttackEffects) then
    -- Attack/Critical/Fumble results
    local msg = {};
    msg.font = "systemfont";
    msg.sender = GmIdentityManager.getCurrent();
    msg.text = draginfo.getStringData();
    -- add number data?
    if draginfo.getNumberData()~=0 then
      msg.dice = {};
      msg.diemodifier = draginfo.getNumberData();
      msg.dicesecret = false;
    end
    deliverMessage(msg);
    return true;
  end
  draginfo.resetType();
  draginfo, customdata = Rules_CustomData.Prepare(draginfo);
  if customdata then
      throwDice("dice",{"d100","d10"},0,"",customdata);
      return true;
  end
end

-- Initialization
function onInit()
  if super and super.onInit then
    super.onInit();
  end
  registerSlashHandler("/die", processDie);
  if User.isLocal() then
    return;
  end
  -- capture hot key presses
  if ChatManager and ChatManager.handleCustomData then
    Interface.onHotkeyActivated = hotkeyActivated;
  end
  -- register slash commands
  registerSlashHandler("/whisper", processWhisper);
  registerSlashHandler("/version", processVersion);
  
  -- register import and export character commands
  if User.isHost() then
	registerSlashHandler("/importchar", processImport);
	registerSlashHandler("/exportchar", processExport);
  end
  
  registerSpecialMsgHandler(SPECIAL_MSGTYPE_DICETOWER, handleDiceTower);
end

-- Command handlers
function registerCommandHandler(command,handler)
  commandhandlers[command] = handler;
end

function sendCommand(name,text)
  local msg = {};
  msg.sender = "/cmd "..name.." "..User.getUsername();
  msg.text = text;
  msg.font = "";
  deliverMessage(msg, "");
end

function executeCommand(message)
  local cmd = parseCommand(message);
  if cmd and cmd.name then
    local handler = commandhandlers[cmd.name];
    if handler then
      handler(cmd.name,cmd.text,cmd.sender);
      return true;
    end
  end
end

function parseCommand(msg)
  if msg and msg.sender then
    local sender = string.sub(msg.sender,1,-2);
    local cmd = {};
    local pos = 1;
    local first, last;
    -- command body
    cmd.text = msg.text;
    -- test word
    first, last = string.find(sender, "%s+", pos);
    if first then
      local test = string.sub(sender, pos, first-1);
      if test~="/cmd" then
        return nil;
      end
      pos = last+1;
    else
      return nil;
    end
    -- command name
    first, last = string.find(sender, "%s+", pos);
    if first then
      cmd.name = string.sub(sender, pos, first-1);
      cmd.sender = string.sub(sender, last+1);
    else
      cmd.name = string.sub(sender, pos);
      cmd.sender = "";
    end
    -- done
    return cmd;
  else
    return nil;
  end
end

-- Chat window registration for general purpose message dispatching

function registerControl(ctrl)
  control = ctrl;
  -- display the copyright message
  for i,txt in ipairs(Rules_Constants.CopyrightText) do
    addMessage({text = txt, font = "systemfont", icon = "chat_logo"});
  end
end

function registerEntryControl(ctrl)
  entrycontrol = ctrl;
  ctrl.onSlashCommand = onSlashCommand;
end

-- Generic message delivery
function deliverMessage(msg, recipients)
  if control then
    control.deliverMessage(msg, recipients);
  end
end

function addMessage(msg)
  if control then
    control.addMessage(msg);
  end
end

function throwDice(...)
  if control then
    control.throwDice(...);
  end
end

-- Slash command dispatching
slashhandlers = {};

function registerSlashHandler(command, callback)
  slashhandlers[command] = callback;
end

function unregisterSlashHandler(command, callback)
  slashhandlers[command] = nil;
end

function onSlashCommand(command, parameters)
  local cmd = nil;
	for c, h in pairs(slashhandlers) do
	  if string.lower(c)==string.lower(command) then
	    -- exact match
			h(parameters);
			return;
		elseif string.find(string.lower(c), string.lower(command), 1, true) == 1 then
		  -- close match
		  cmd = h;
		end
	end
	if cmd then
	  cmd(parameters);
	end
end

-- Aliases
function doAutocomplete()
  local buffer = entrycontrol.getValue();
  local spacepos = string.find(string.reverse(buffer), " ", 1, true);
  
  local search = "";
  local remainder = buffer;
  
  if spacepos then
    search = string.sub(buffer, #buffer - spacepos + 2);
    remainder = string.sub(buffer, 1, #buffer - spacepos + 1);
  else
    search = buffer;
    remainder = "";
  end
  
  -- Check identities
  for k, v in ipairs(User.getAllActiveIdentities()) do
    local label = User.getIdentityLabel(v);
    if label and string.find(string.lower(label), string.lower(search), 1, true) == 1 then
      local replacement = remainder .. label;
      entrycontrol.setValue(replacement);
      entrycontrol.setCursorPosition(#replacement + 1);
      entrycontrol.setSelectionPosition(#replacement + 1);
      return;
    end
  end
end

-- Whispers
--[[function processWhisper(params)
  if User.isHost() then
    local msg = {};
    msg.font = "msgfont";

    local spacepos = string.find(params, " ", 1, true);
    if spacepos then
      local recipient = string.sub(params, 1, spacepos-1);
      local originalrecipient = recipient;
      local message = string.sub(params, spacepos+1);

      -- Find user
      local user = nil;

      for k, v in ipairs(User.getAllActiveIdentities()) do
        local label = User.getIdentityLabel(v);
        if string.lower(label) == string.lower(originalrecipient) then
          -- Direct match
          user = User.getIdentityOwner(v);
          if user then
            recipient = label;
            break;
          end
        elseif not user and string.find(string.lower(label), string.lower(recipient), 1, true) == 1 then
          -- Partial match
          user = User.getIdentityOwner(v);
          if user then
            recipient = label;
          end
        end
      end

      if user then
        msg.text = message;

        msg.sender = "<heard whisper>";
        control.deliverMessage(msg, user);

        msg.sender = "-> " .. recipient;
        control.addMessage(msg);
        
        return;
      end

      msg.font = "systemfont";
      msg.text = "Whisper recipient not found";
      control.addMessage(msg);
      
      return;
    end

    msg.font = "systemfont";
    msg.text = "Usage: /whisper [recipient] [message]";
    control.addMessage(msg);
  else
    local msg = {};
    msg.font = "msgfont";
    msg.text = params;

    msg.sender = User.getIdentityLabel();
    control.deliverMessage(msg, "");

    msg.sender = "<sent whisper>";
    control.addMessage(msg);
  end
end]]--

-----------------------
-- WHISPERS
-----------------------

function processWhisper(sCommand, sParams)
	-- Find the target user for the whisper
	local sLowerParams = string.lower(sParams);
	local sGMIdentity = "gm ";

	local sRecipient = nil;
	if string.sub(sLowerParams, 1, string.len(sGMIdentity)) == sGMIdentity then
		sRecipient = "GM";
	else
		for _,vID in ipairs(User.getAllActiveIdentities()) do
			local sIdentity = User.getIdentityLabel(vID);

			local sIdentityMatch = string.lower(sIdentity) .. " ";
			if string.sub(sLowerParams, 1, string.len(sIdentityMatch)) == sIdentityMatch then
				if sRecipient then
					if #sRecipient < #sIdentity then
						sRecipient = sIdentity;
					end
				else
					sRecipient = sIdentity;
				end
			end
		end
	end
	
	local sMessage;
	if sRecipient then
		sMessage = string.sub(sParams, #sRecipient + 2)
	else
		sMessage = sParams;
	end
	
	processWhisperHelper(sRecipient, sMessage);
end

sLastWhisperer = nil;

function processReply(sCommand, sParams)
	if not sLastWhisperer then
		ChatManager.SystemMessage(Interface.getString("error_slashreplytargetmissing"));
		return;
	end
	processWhisperHelper(sLastWhisperer, sParams);
end

function processWhisperHelper(sRecipient, sMessage)
	-- Make sure we have a valid identity and valid user owning the identity
	local sUser = nil;
	local sRecipientID = nil;
	if sRecipient then
		if sRecipient == "GM" then
			sRecipientID = "";
			sUser = "";
		else
			for _,vID in ipairs(User.getAllActiveIdentities()) do
				local sIdentity = User.getIdentityLabel(vID);
				if sIdentity == sRecipient then
					sRecipientID = vID;
					sUser = User.getIdentityOwner(vID);
				end
			end
		end
	end
	if not sRecipientID or not sUser then
		ChatManager.SystemMessage(Interface.getString("error_slashwhispertargetmissing"));
		ChatManager.SystemMessage("Usage: /w GM [message]\rUsage: /w [recipient] [message]");
		return;
	end
	
	-- Check for empty message
	if sMessage == "" then
		ChatManager.SystemMessage(Interface.getString("error_slashwhispermsgmissing"));
		ChatManager.SystemMessage("Usage: /w GM [message]\rUsage /w [recipient] [message]");
		return;
	end
	
	-- Make sure we have a user identity
	local sSender;
	if User.isHost() then
		sSender = "";
	else
		sSender = User.getCurrentIdentity();
		if not sSender then
			ChatManager.SystemMessage(Interface.getString("error_slashwhispersourcemissing"));
			return;
		end
	end
	
	-- Send the whisper
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_WHISPER;
	msgOOB.sender = sSender;
	msgOOB.receiver = sRecipientID;
	msgOOB.text = sMessage;

	if User.isHost() then
		Comm.deliverOOBMessage(msgOOB, { sUser, "" });
	else
		Comm.deliverOOBMessage(msgOOB);
	end
	
	-- Show what the user whispered
	local msg = { font = "whisperfont", sender = "", mode="whisper", icon = { "indicator_whisper" } };
	
	if User.isHost() then
		if OptionsManager.isOption("PCHT", "on") then
			table.insert(msg.icon, "portrait_gm_token");
		end
		
	else
		if #(User.getOwnedIdentities()) > 1 then
			msg.sender = User.getIdentityLabel(sSender);
		end
		
		if OptionsManager.isOption("PCHT", "on") then
			table.insert(msg.icon, "portrait_" .. msgOOB.sender .. "_chat");
		end
	end

	msg.sender = msg.sender .. " -> " .. sRecipient;
	msg.text = sMessage;
	
	Comm.addChatMessage(msg);
end

function handleWhisper(msgOOB)
	-- Validate
	if not msgOOB.sender or not msgOOB.receiver or not msgOOB.text then
		return;
	end

	-- Check to see if GM has asked to see whispers
	if User.isHost() then
		if msgOOB.sender == "" then
			return;
		end
		if msgOOB.receiver ~= "" and OptionsManager.isOption("SHPW", "off") then
			return;
		end
		
	-- Ignore messages not targeted to this user
	else
		if msgOOB.receiver == "" then
			return;
		end
		if not User.isOwnedIdentity(msgOOB.receiver) then
			return;
		end
	end
	
	-- Get the send and receiver labels
	local sSender, sReceiver;
	if msgOOB.sender == "" then
		sSender = "GM";
	else
		sSender = User.getIdentityLabel(msgOOB.sender) or "<unknown>";
	end
	if msgOOB.receiver == "" then
		sReceiver = "GM";
	else
		sReceiver = User.getIdentityLabel(msgOOB.receiver) or "<unknown>";
	end
	
	-- Remember last whisperer
	if not User.isHost() or msgOOB.receiver == "" then
		sLastWhisperer = sSender;
	end
	
	-- Build the message to display
	local msg = { font = "whisperfont", text = "", mode = "whisper", icon = { "indicator_whisper" } };
	msg.sender = sSender;
	if OptionsManager.isOption("PCHT", "on") then
		if msgOOB.sender == "" then
			table.insert(msg.icon, "portrait_gm_token");
		else
			table.insert(msg.icon, "portrait_" .. msgOOB.sender .. "_chat");
		end
	end
	if User.isHost() then
		if msgOOB.receiver ~= "" then
			msg.sender = msg.sender .. " -> " .. sReceiver;
		end
	else
		if #(User.getOwnedIdentities()) > 1 then
			msg.sender = msg.sender .. " -> " .. sReceiver;
		end
	end
	msg.text = msg.text .. msgOOB.text;
	
	-- Show whisper message
	Comm.addChatMessage(msg);
end

function sendWhisperToID(sIdentity)
	local wChat = Interface.findWindow("chat", "")
	if not wChat then
		return
	end
	
	local sCommand = "/w " .. User.getIdentityLabel(sIdentity) .. " ";
	wChat.entry.setValue(sCommand);
	wChat.entry.setFocus();
	wChat.entry.setSelectionPosition(#sCommand + 1);
end



-- Dice
function getDieRevealFlag()
  if PreferenceManager.load(Preferences.RevealDicePref) == Preferences.Yes then
    return true;
  end
  
  return false;
end

function processDie(params)
  if control then
    if User.isHost() then
      if params == "reveal" then
        PreferenceManager.save(Preferences.RevealDicePref, Preferences.Yes);

        local msg = {};
        msg.font = "systemfont";
        msg.text = "Revealing all die rolls";
        control.addMessage(msg);

        return;
      end
      if params == "hide" then
        PreferenceManager.save(Preferences.RevealDicePref, Preferences.No);

        local msg = {};
        msg.font = "systemfont";
        msg.text = "Hiding all die rolls";
        control.addMessage(msg);

        return;
      end
    end
  
    local diestring, descriptionstring = string.match(params, "%s*(%S+)%s*(.*)");
    
    if not diestring then
      local msg = {};
      msg.font = "systemfont";
      msg.text = "Usage: /die [dice] [description]";
      control.addMessage(msg);
      return;
    end
    
    local dice = {};
    local modifier = 0;
    
    for s, m, d in string.gmatch(diestring, "([%+%-]?)(%d*)(%w*)") do
      if m == "" and d == "" then
        break;
      end

      if d ~= "" then
        for i = 1, tonumber(m) or 1 do
          table.insert(dice, d);
          if d == "d100" then
            table.insert(dice, "d10");
          end
        end
      else
        if s == "-" then
          modifier = modifier - m;
        else
          modifier = modifier + m;
        end
      end
    end

    if #dice == 0 then
      local msg = {};
      
      msg.font = "systemfont";
      msg.text = descriptionstring;
      msg.dice = {};
      msg.diemodifier = modifier;
      msg.dicesecret = false;

      if User.isHost() then
        msg.sender = GmIdentityManager.getCurrent();
      else
        msg.sender = User.getIdentityLabel();
      end
    
      deliverMessage(msg);
    else

      control.throwDice("dice", dice, modifier, descriptionstring);
    end
  end
end

-- print version info
function processVersion()
  addMessage({text = Rules_Constants.RulesetVersion, font = "systemfont"});
end

function getControl()
  return control;
end

function processImport(params)
	local sFile = Interface.dialogFileOpen();
	if sFile then
		DB.import(sFile, "charsheet", "character");
		SystemMessage("Character(s) imported");
	end
end

function processExport(params)
	local nodeChar = nil;
	local sChar = ""; 
	local sFind = StringManager.trimString(params);
	if string.len(sFind) > 0 then
		local nodeCharacters = DB.findNode("charsheet");
		if nodeCharacters then
			for kChar, vChar in pairs(nodeCharacters.getChildren()) do
				local nodeChild = vChar.getChild("name");
				if nodeChild then
					local varReturn = nodeChild.getValue();
					if varReturn then
						sChar = varReturn;
					end
				end
				if string.len(sChar) > 0 then
					if string.lower(sFind) == string.lower(string.sub(sChar, 1, string.len(sFind))) then
						nodeChar = vChar;
						break;
					end
				end
			end
		end
		if not nodeChar then
			SystemMessage("Unable to find character requested for export. (" .. params .. ")");
			return;
		end
	end
	
	local sFile = Interface.dialogFileSave();
	if sFile then
		if nodeChar then
			DB.export(sFile, nodeChar, "character");
			SystemMessage("Exported character: " .. sChar);
		else
			DB.export(sFile, "charsheet", "character", true);
			SystemMessage("Exported all characters");
		end
	end
end

-- SystemMessage: prints a message in the Chatwindow
function SystemMessage(msgtxt)
	local msg = {font = "systemfont"};
	msg.text = msgtxt;
	addMessage(msg);
end

--
--
-- SPECIAL MESSAGE HANDLING
--
--

SPECIAL_MSG_TAG = "[SPECIAL]";
SPECIAL_MSG_SEP = "|||";

specialmsghandlers = {};

function registerSpecialMsgHandler(msgtype, callback)
	specialmsghandlers[msgtype] = callback;
end

function sendSpecialMessage(msgtype, params)
	-- Hosts go directly to handling the message
	if User.isHost() then
		handleSpecialMessage(msgtype, "", "", params);
	
	-- Clients build a special message to send to the host
	else
		-- Build the special message to send
		local msg = {font = "msgfont", text = ""};
		msg.sender = SPECIAL_MSG_TAG .. SPECIAL_MSG_SEP .. msgtype .. SPECIAL_MSG_SEP .. User.getUsername() .. SPECIAL_MSG_SEP .. User.getIdentityLabel() .. SPECIAL_MSG_SEP;
		for k,v in pairs(params) do
			msg.text = msg.text .. v .. SPECIAL_MSG_SEP;
		end

		-- Deliver to the host
		deliverMessage(msg, "");
	end
end

function processSpecialMessage(msg)
	-- Only the host can process special messages
	if not User.isHost() then
		return false;
	end
	
	-- Make sure the sender this is a special message
	if string.find(msg.sender, SPECIAL_MSG_TAG, 1, true) ~= 1 then
		return false;
	end

	-- Parse out the special message details
	local msg_meta = {};
	local msg_clause;
	local clause_match = "(.-)" .. SPECIAL_MSG_SEP;
	for msg_clause in string.gmatch(msg.sender, clause_match) do
		table.insert(msg_meta, msg_clause);
	end
	local msgtype = msg_meta[2];
	local msguser = msg_meta[3];
	local msgidentity = msg_meta[4];
	
	-- Parse out the special message parameters
	local msg_params = {};
	for msg_clause in string.gmatch(msg.text, clause_match) do
		table.insert(msg_params, msg_clause);
	end
	
	-- Handle the special message
	handleSpecialMessage(msgtype, msguser, msgidentity, msg_params);
	return true;
end

function handleSpecialMessage(msgtype, msguser, msgidentity, paramlist)
	for k,v in pairs(specialmsghandlers) do
		if msgtype == k then
			v(msguser, msgidentity, paramlist);
			return;
		end
	end
	
	SystemMessage("[ERROR] Unknown special message received, Type = " .. msgtype);
end


--
--
--  DICE TOWER
--
--

function handleDiceTower(msguser, msgidentity, paramlist)
	-- Get the parameters
	local droptype = paramlist[1];
	local desc = paramlist[2];
	local dicestr = paramlist[3];
	local dieType = paramlist[4];
	local tableID = paramlist[5];
	local stringData = paramlist[6];
	local stringMods = paramlist[7];
	local customdata = {type=Rules_Constants.DataType.DieRoll,tableType=Rules_Constants.TableType.Other,modifiers={}};

	if desc == "" then
		if string.sub(dicestr,1,10) == "0d10+1d100" or string.sub(dicestr,1,10) == "1d100+0d10" then
			desc = "1d100";
			if string.len(dicestr) > 10 then
				desc = desc .. string.sub(dicestr, 11);
			end
			if dieType ~= "" then
				desc = desc .. " " .. dieType;
			else
				desc = desc .. " Closed";
			end
		else
			desc = dicestr;
		end
	end
	
	-- Build the description string
	local roll_desc = "[TOWER] ";
	if msgidentity ~= "" then
		roll_desc = roll_desc .. msgidentity .. " -> ";
	else
		roll_desc = roll_desc .. "GM -> ";
	end
	
	if stringData and (droptype ~= "Hotkey:SkillRoll" 
					and droptype ~= "Hotkey:MMSkillRoll" 
					and droptype ~= "Hotkey:StatRoll" 
					and droptype ~= "Hotkey:RR") then
		roll_desc = roll_desc .. stringData;
	end

	-- Roll the dice
	local dice, modifier = StringManager.convertStringToDice(dicestr);
	if droptype == "Hotkey:SkillRoll" then
		customdata = Rules_CustomData.Skill(stringData);
		customdata.modifiers = StringManager.convertStringToModifiers(stringMods);
		customdata.name = roll_desc .. customdata.name;
	elseif droptype == "Hotkey:MMSkillRoll" then
		local actorNode = DB.findNode(stringData);
		customdata = Rules_CustomData.Skill(nil, actorNode, desc, Rules_Constants.SkillType.MoveManeuver);
		customdata.modifiers = StringManager.convertStringToModifiers(stringMods);
		Rules_Modifiers.MMSkill(customdata.modifiers, actorNode, desc);
		customdata.name = roll_desc .. customdata.name;
	elseif droptype == "Hotkey:StatRoll" then
		customdata = Rules_CustomData.Stat(stringData);
		customdata.modifiers = StringManager.convertStringToModifiers(stringMods);
		customdata.name = roll_desc .. customdata.name;
	elseif droptype == "Hotkey:RR" then
		customdata = Rules_CustomData.ResistanceRoll(stringData);
		customdata.modifiers = StringManager.convertStringToModifiers(stringMods);
		customdata.name = roll_desc .. customdata.name;
	else
		customdata.dieType = dieType;
		customdata.tableID = tableID;
		roll_desc = roll_desc .. desc;		
	end
	
	  -- need to show modifiers (from attack/skill custom data) in the chat window text
	if customdata.modifiers then
		for i, mod in pairs(customdata.modifiers) do
			desc = desc .. ", ";
			if mod.description then
				desc = desc .. mod.description .. " ";
			end
			if tonumber(mod.value) then
				if tonumber(mod.value) > 0 then
					desc = desc .. "+" ..  mod.value;
				else
					desc = desc .. mod.value;
				end
			end
		end
	end

	if customdata then
		ChatManager.throwDice("dice", dice, modifier, roll_desc, customdata);
	else
		ChatManager.throwDice("dice", dice, modifier, roll_desc);
	end

	-- Return a confirmation to client, if needed
	if msguser ~= "" then
		-- Build the message
		local clientmsg = {font = "chatfont", icon = "dicetower_icon", sender = "[TOWER]", text = ""};
		if desc ~= "" then
			clientmsg.text = desc;
		end
	
		-- Deliver the message
		deliverMessage(clientmsg, msguser);
	end

end
