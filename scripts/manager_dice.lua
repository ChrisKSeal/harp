local scriptName = "ManagementScript_Dice.lua";
local openUpMin   = 95;      --95;
local openDownMax = 6;       --6;
  
-- ##################### External Functions - can be called by other code #########################################
function handleChatwindowD100(dragData, dieType)
  local functionName = "handleChatwindowD100";

  local handled = false;
  local d100Found = false;
  local d10Found = false;
  local d100Result = 0;
  local d10Result = 0;
  local dieList = dragData.getDieList();
  local dieType = dragData.getCustomData().dieType;
  local explosionDice = {};
  local custData = {};
  local custDataDieResults = {};
  
  if dragData.getCustomData().nestedCustomData then
    -- nestedCustomData is used to hold info about an attack being made from the combat tracker
    -- (OB/DB/AT/Table/etc) we don't use that data here, just keep it 'alive'
    custData.nestedCustomData = dragData.getCustomData().nestedCustomData;
  end
  if dragData.getCustomData().revealDice then
    custData.revealDice = true;
  end
  
  if dieList then
    for k,v in pairs(dieList) do
      if v["type"] == "d100" then
        d100Found = true;  
        d100Result = tonumber((v["result"])) or 0;
      end
      if v["type"] == "d10" then
        d10Found = true;
        d10Result = tonumber((v["result"])) or 0;
      end
    end
    if d100Found and d10Found then
      -- yep, this is a d100 roll
      if  dieType 
      and (   dieType == Rules_Constants.DieType.OpenEnded
           or dieType == Rules_Constants.DieType.HighOpenEnded
           or dieType == Rules_Constants.DieType.LowOpenEnded ) then
        
        explosion, direction = explodeDice(d100Result + d10Result, dieType);
        if explosion then
          table.insert(explosionDice, "d100");
          table.insert(explosionDice, "d10");
          
          table.insert(custDataDieResults, d100Result + d10Result);
          
          custData.type = "DiceExplosion";
          custData.dieType = "D100Exploded" .. direction;
          custData.dieResults = custDataDieResults;
          
          ChatManager.throwDice("dice", explosionDice, dragData.getNumberData(), dragData.getDescription(), custData); 
          return true; -- we have handled this result - return true to prevent the normal scripts from processing the original dice results
        else
          -- value was not large/small enough for an open ended roll so just return  the value
          table.insert(custDataDieResults, d100Result + d10Result);
          custData.dieResults = custDataDieResults;
          custData.dieType = "D100";
          dragData.setCustomData(custData);
        end
      else
        -- closed ended so just return the result
        table.insert(custDataDieResults, d100Result + d10Result);
        custData.dieResults = custDataDieResults;
        custData.dieType = "D100";
        dragData.setCustomData(custData);
      end
    else
      -- we shouldn't have got into here unless the dice rolled was a d100 and a d10!
      ErrorHandler.showError("Invalid dice.", functionName, scriptName, false);
    end
  else
    -- we shouldn't have got into here without any dice!
    ErrorHandler.showError("Missing dice.", functionName, scriptName, false);
  end
  
  return handled;
end

-- ##################### Internal Functions - used within this script ############################################


function explodeDice(result, dieType)
  local explode = false;
  local direction;
  if  result > openUpMin 
  and (   dieType == Rules_Constants.DieType.OpenEnded 
       or dieType == Rules_Constants.DieType.HighOpenEnded) then
       
    direction = "Up";
    explode = true;
    
  elseif  openDownMax > result 
     and (   dieType == Rules_Constants.DieType.OpenEnded 
          or dieType == Rules_Constants.DieType.LowOpenEnded) then
          
        direction = "Down";
      explode = true;

  end

  return explode, direction; 
end


function explodeChatwindowD100(dragData, openDirection, currentCustData)
  local functionName = "explodeChatwindowD100";
  
  local d100Found = false;
  local d100Found = false;
  local d10Result = 0;
  local d10Result = 0;
  local explosionDice = {};
  local custData = {};
  local custDataDieResults = {};
  local dieList = dragData.getDieList();
  local dieType;
  local theResult;
  
  if currentCustData.nestedCustomData then
    custData.nestedCustomData = currentCustData.nestedCustomData;  -- nestedCustomData is used to hold info about an attack being made from the combat tracker (OB/DB/AT/Table/etc) we don't use that data here, just keep it 'alive'
  end
  
  if currentCustData and type(currentCustData) == "table" and currentCustData.dieResults then
    for i, k in ipairs(currentCustData.dieResults) do
      table.insert(custDataDieResults,k);
    end
  end
  --custData.dieResults = custDataDieResults;
  
  if dieList then
    for k,v in pairs(dieList) do
      if v["type"] == "d100" then
        d100Found = true;  
        d100Result = tonumber((v["result"]))
      end
      if v["type"] == "d10" then
        d10Found = true;
        d10Result = tonumber((v["result"]))
      end
    end
    if d100Found and d10Found then
      
        if openDirection == "Up" then 
        dieType = Rules_Constants.DieType.HighOpenEnded;
        theResult = d100Result + d10Result;
      else
        dieType = Rules_Constants.DieType.HighOpenEnded; -- for "Down" we do a High OpenEnded roll and subtracting the value
        theResult = -(d100Result + d10Result);
        end
         
      table.insert(custDataDieResults, theResult);
      custData.dieResults = custDataDieResults;
      dragData.setCustomData(custData); -- set here so it will still be returned if there are (non fatal)errors below 
        
      explosion = explodeDice(d100Result + d10Result, dieType);
      if explosion then
        table.insert(explosionDice, "d100");
        table.insert(explosionDice, "d10");
      
        custData.type = "DiceExplosion";
        custData.dieType = "D100Exploded" .. openDirection;
        
        ChatManager.throwDice("dice", explosionDice, dragData.getNumberData(), dragData.getDescription(), custData); 
        return true; -- we have handled this result - return true to prevent the normal scripts from processing the original dice results
      else
        -- value was not large/small enough for another open ended roll so just return false
        return false, dragData;
      end
        
    else
      -- we shouldn't have got into here unless the dice rolled was a d100 and a d10!
      ErrorHandler.showError("Invalid dice.", functionName, scriptName, false);
    end
  else
    -- we shouldn't have got into here without any dice!
    ErrorHandler.showError("Missing dice.", functionName, scriptName, false);
  end
  
  return false;
  
end
