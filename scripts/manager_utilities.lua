
function getRevealDice()
  -- hide or reveal dice?
  if User.isHost() then
    if ChatManager.getDieRevealFlag() then
      return true;
    else
      return false;
    end
  else
    return true;
  end
end

function AddModifierStack(modifiers)
	-- add items in the modifier stack
	if not ModifierStack.isEmpty() then
		local mods = ModifierStack.getModifiers();
		for i = 1, #mods do
		  table.insert(modifiers, mods[i]);
		end
		-- clear the modifier stack
		ModifierStack.reset();
	end
end

function isStunned(target)
	local stunned = false;
	
	for k, eff in pairs(target.getChild("effects").getChildren()) do
		if eff.getChild("stunned") then
			if eff.getChild("stunned").getValue() > 0 then
				stunned = true;
			end
		end
	end	
	
	return stunned;
end

-- String to Table functions  
function stringToTable(str)
  tbl = {};
  if (not str) or type(str)~="string" then
    return nil;
  end
  -- decode the string
  str = strdecode(str);
  if string.len(str)<2 then
    return nil;
  end
  -- remove opening and closing braces
  str = string.sub(str,2,-2);
  -- split into fields
  for fld in string.gfind(str,"([^\n]*)\n") do
    local i,j,tp,nm,val = string.find(fld,"type:([^\t]*)\tname:([^\t]*)\tvalue:(.*)");
    if i then
      if tp=="string" then
        tbl[nm] = ""..strdecode(val);
      elseif tp=="number" then
        tbl[nm] = 0 + tonumber(val);
      elseif tp=="boolean" then
        if val=="true" then
          tbl[nm] = true;
        else
          tbl[nm] = false;
        end
      elseif tp=="table" then
        val = stringToTable(val);
        tbl[nm] = val;
      else
        tbl[nm] = "Unknown type: "..tp;
      end
    end
  end
  return tbl;
end

function tableToString(tbl)
  local result = "";
  if (not tbl) or type(tbl)~="table" then
    return "";
  end
  for k,v in pairs(tbl) do
    local nm=strencode(k);
    local tp = type(v);
    local val = "";
    if tp=="number" then
      val=""..v;
    elseif tp=="string" then
      val=strencode(v);
    elseif tp=="boolean" then
      if v then
        val="true";
      else
        val="false";
      end
    elseif tp=="table" then
      val = strencode(tableToString(v));
    else
      val = "Unknown type: "..tp;
      tp = "string";
    end
    result = result.."type:"..tp.."\tname:"..nm.."\tvalue:"..val.."\n";
  end
  return strencode("{"..result.."}");
end

-- copygem starts here
function copyGem(src, dst)
  -- Descriptive fields
  if src.getChild("name") then
    dst.createChild("name","string").setValue(src.getChild("name").getValue());
  end
  if src.getChild("rural") then
    dst.createChild("rural","string").setValue(src.getChild("rural").getValue());
  end
  if src.getChild("town") then
    dst.createChild("town","string").setValue(src.getChild("town").getValue());
  end
  if src.getChild("city") then
    dst.createChild("city","string").setValue(src.getChild("city").getValue());
  end
  if src.getChild("note") then
    dst.createChild("note","string").setValue(src.getChild("note").getValue());
  end
    if src.getChild("type") then
    dst.createChild("type","number").setValue(src.getChild("type").getValue());
  end
  if src.getChild("denomination") then
    dst.createChild("denomination","string").setValue(src.getChild("denomination").getValue());
  end
  if src.getChild("caratvalue") then
    dst.createChild("caratvalue","number").setValue(src.getChild("caratvalue").getValue());
  end
  if src.getChild("carats") then
    dst.createChild("carats","number").setValue(src.getChild("carats").getValue());
  end
  if src.getChild("eep") then
    dst.createChild("eep","number").setValue(src.getChild("eep").getValue());
  end
  if src.getChild("tendency") then
    dst.createChild("tendency","string").setValue(src.getChild("tendency").getValue());
  end
  if src.getChild("description") then
    dst.createChild("description","string").setValue(src.getChild("description").getValue());
  end

end

-- COPY TRANSORT STARTS HERE
function copyTransport(src, dst)
  -- Descriptive fields
  if src.getChild("name") then
    dst.createChild("name","string").setValue(src.getChild("name").getValue());
  end
  if src.getChild("rural") then
    dst.createChild("rural","string").setValue(src.getChild("rural").getValue());
  end
  if src.getChild("town") then
    dst.createChild("town","string").setValue(src.getChild("town").getValue());
  end
  if src.getChild("city") then
    dst.createChild("city","string").setValue(src.getChild("city").getValue());
  end
  if src.getChild("note") then
    dst.createChild("note","string").setValue(src.getChild("note").getValue());
  end
    if src.getChild("type") then
    dst.createChild("type","number").setValue(src.getChild("type").getValue());
  end
  if src.getChild("ftrn") then
    dst.createChild("ftrn","string").setValue(src.getChild("ftrn").getValue());
  end
  if src.getChild("mihr") then
    dst.createChild("mihr","string").setValue(src.getChild("mihr").getValue());
  end
  if src.getChild("mnb") then
    dst.createChild("mnb","string").setValue(src.getChild("mnb").getValue());
  end
  if src.getChild("htwt") then
    dst.createChild("htwt","string").setValue(src.getChild("htwt").getValue());
  end
  if src.getChild("capacity") then
    dst.createChild("capacity","string").setValue(src.getChild("capacity").getValue());
  end
  if src.getChild("ob") then
    dst.createChild("ob","string").setValue(src.getChild("ob").getValue());
  end
  return dst;
end

-- copyHerb starts here
function copyHerb(src, dst)
  -- Descriptive fields
  if src.getChild("name") then
    dst.createChild("name","string").setValue(src.getChild("name").getValue());
  end
  if src.getChild("rural") then
    dst.createChild("rural","string").setValue(src.getChild("rural").getValue());
  end
  if src.getChild("codes") then
    dst.createChild("codes","string").setValue(src.getChild("codes").getValue());
  end
  if src.getChild("form") then
    dst.createChild("form","string").setValue(src.getChild("form").getValue());
  end
  if src.getChild("effect") then
    dst.createChild("effect","string").setValue(src.getChild("effect").getValue());
  end
    if src.getChild("type") then
    dst.createChild("type","number").setValue(src.getChild("type").getValue());
  end
  if src.getChild("aoe") then
    dst.createChild("aoe","string").setValue(src.getChild("aoe").getValue());
  end
  return dst;
end

function copySpell(src, dst)
  if src.getChild("name") then
    dst.createChild("name","string").setValue(src.getChild("name").getValue());
  end
  if src.getChild("duration") then
    dst.createChild("duration","string").setValue(src.getChild("duration").getValue());
  end
  if src.getChild("range") then
    dst.createChild("range","string").setValue(src.getChild("range").getValue());
  end
  if src.getChild("description") then
    dst.createChild("description","string").setValue(src.getChild("description").getValue());
  end
  if src.getChild("spheres") then
    dst.createChild("spheres","string").setValue(src.getChild("spheres").getValue());
  end
  if src.getChild("class") then
    dst.createChild("class", "number").setValue(src.getChild("class").getValue());
  end
  if src.getChild("ppcost") then
    dst.createChild("ppcost", "number").setValue(src.getChild("ppcost").getValue());
  end
  if src.getChild("rr") then
    dst.createChild("rr", "number").setValue(src.getChild("rr").getValue());
  end
  if src.getChild("cast") then
    dst.createChild("cast", "number").setValue(src.getChild("cast").getValue());
  end
  if src.getChild("associatedskill") then
	dst.createChild("associatedskill","string").setValue(src.getChild("associatedskill").getValue());
  end
  if src.getChild("size") then
    dst.createChild("size", "number").setValue(src.getChild("size").getValue());
  end
  if src.getChild("spelltable") then
    local attknode = dst.createChild("spelltable");
    if src.getChild("spelltable.name") then
      attknode.createChild("name","string").setValue(src.getChild("spelltable.name").getValue());
    end
    if src.getChild("spelltable.tableid") then
      attknode.createChild("tableid","string").setValue(src.getChild("spelltable.tableid").getValue());
    end
  end
  if src.getChild("scaleopts") then
	local optnode = dst.createChild("scaleopts");
		for k,skl in pairs(src.getChild("scaleopts").getChildren()) do
		    local curnode = optnode.createChild(k);
			  if skl.getChild("name") then
			    curnode.createChild("name","string").setValue(skl.getChild("name").getValue());
			  end
			  if skl.getChild("cost") then
			    curnode.createChild("cost","number").setValue(skl.getChild("cost").getValue());
			  end
			  if skl.getChild("ismultiple") then
			    curnode.createChild("ismultiple","number").setValue(skl.getChild("ismultiple").getValue());
			  end
		end
	end
end


function strencode(str)
  local result = str;
  result = string.gsub(result,"@", "@at;");
  result = string.gsub(result,"\n","@nl;");
  result = string.gsub(result,"{", "@op;");
  result = string.gsub(result,"}", "@cl;");
  return result;
end

function strdecode(str)
  local result = str;
  result = string.gsub(result,"@nl;","\n");
  result = string.gsub(result,"@op;","{");
  result = string.gsub(result,"@cl;","}");
  result = string.gsub(result,"@at;","@");
  return result;
end

