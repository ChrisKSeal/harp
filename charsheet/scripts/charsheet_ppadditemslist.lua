function onInit()
  if super and super.onInit then
	super.onInit();
  end 
  refresh();
end


function refresh()
  local source = window.getDatabaseNode();
  getPPAdders(source);
end

function getPPAdders(src)
  local ppadd = 0;
  local name = nil;
  local newnode = nil;
  if src.getChild("weapons") then
    for k,skl in pairs(src.getChild("weapons").getChildren()) do
	  if skl.getChild("ppadd") then
	    ppadd = skl.getChild("ppadd").getValue();
	    if ppadd > 0 then
	      if skl.getChild("name") then
	        name = skl.createChild("name").getValue();
			if not checkExists(src, name) then
			  newnode = addPPAdd().getDatabaseNode();
			  newnode.createChild("name","string").setValue(name);
			  newnode.createChild("ppadd","number").setValue(ppadd);
			end
		  end
		end
	  end
	end
  end
  if src.getChild("harness") then
    for k,skl in pairs(src.getChild("harness").getChildren()) do
	  if skl.getChild("ppadd") then
	    ppadd = skl.getChild("ppadd").getValue();
	    if ppadd > 0 then
	      if skl.getChild("name") then
	        name = skl.createChild("name").getValue();
			if not checkExists(src, name) then
			  newnode = addPPAdd().getDatabaseNode();
			  newnode.createChild("name","string").setValue(name);
			  newnode.createChild("ppadd","number").setValue(ppadd);
			end
		  end
		end
	  end
	end
  end
  if src.getChild("shield") then
    for k,skl in pairs(src.getChild("shield").getChildren()) do
	  if skl.getChild("ppadd") then
	    ppadd = skl.getChild("ppadd").getValue();
	    if ppadd > 0 then
	      if skl.getChild("name") then
	        name = skl.createChild("name").getValue();
			if not checkExists(src, name) then
			  newnode = addPPAdd().getDatabaseNode();
			  newnode.createChild("name","string").setValue(name);
			  newnode.createChild("ppadd","number").setValue(ppadd);
			end
		  end
		end
	  end
	end
  end
end

function checkExists(source, name)
	local flag = false;
	for k,skl in pairs(source.getChild("ppadders").getChildren()) do
	  if skl.getChild("name") then
	    testname = skl.createChild("name").getValue();
		if testname == name then
		  flag = true;
		end
	  end
	end
	return flag;
end

function addPPAdd()
  local newentry = createWindow();
  local newnode = newentry.getDatabaseNode();

  -- Default use (not equipped)
  newnode.createChild("isused","number").setValue(0);

  return newentry;
end

