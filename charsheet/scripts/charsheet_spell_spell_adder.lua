function update()
	local node = getDatabaseNode().getParent().getParent();
	if node.getChild("combat") then
		local cmbtnode = node.getChild("combat");
		if cmbtnode.getChild("defences") then
			local defnode = cmbtnode.getChild("defences");
			for i, itm in pairs(defnode.getChildren()) do
				local idflg = itm.createChild("isidentified","number").getValue();
				local spadd = itm.createChild("spell_adder","number").getValue();
				if idflg == 1  and spadd > 0 then
					local itemlink = DB.getPath(itm);
					local itemclass = "item_defence";
					local name = itm.createChild("name","string").getValue();
					local flg = isLinked(itemlink, node);
					if not flg then
						local newentry = createWindow();
						newentry.item_link.setValue(itemlink);
						newentry.item_class.setValue(itemclass);
						newentry.name.setValue(name);
						newentry.spell_adder.setValue(spadd);
					end
				end
			end
		end
		if cmbtnode.getChild("weapons") then
			local defnode = cmbtnode.getChild("weapons");
			for i, itm in pairs(defnode.getChildren()) do
				local idflg = itm.createChild("isidentified","number").getValue();
				local spadd = itm.createChild("spell_adder","number").getValue();
				if idflg == 1  and spadd > 0 then
					local itemlink = DB.getPath(itm);
					local itemclass = "item_weapon";
					local name = itm.createChild("name","string").getValue();
					local flg = isLinked(itemlink, node);
					if not flg then
						local newentry = createWindow();
						newentry.item_link.setValue(itemlink);
						newentry.item_class.setValue(itemclass);
						newentry.name.setValue(name);
						newentry.spell_adder.setValue(spadd);
					end
				end
			end
		end
	end
	if node.getChild("items") then
		local itmnode = node.getChild("items");
		if itmnode.getChild("general") then
			local itemnode = itmnode.getChild("general");
			for i, itm in pairs(itemnode.getChildren()) do
				local idflg = itm.createChild("isidentified","number").getValue();
				local spadd = itm.createChild("spell_adder","number").getValue();
				if idflg == 1  and spadd > 0 then
					local itemlink = DB.getPath(itm);
					local itemclass = "item_general";
					local name = itm.createChild("name","string").getValue();
					local flg = isLinked(itemlink, node);
					if not flg then
						local newentry = createWindow();
						newentry.item_link.setValue(itemlink);
						newentry.item_class.setValue(itemclass);
						newentry.name.setValue(name);
						newentry.spell_adder.setValue(spadd);
					end
				end
			end
		end
	end
end

function isLinked(itemlink, charnode)
	local flg = false;
	local mgnode = charnode.createChild("magic");
	local ppnode = mgnode.createChild("spell_adders");
	for i, itm in pairs(ppnode.getChildren()) do
		local testlink = itm.createChild("item_link","string").getValue();
		if testlink == itemlink then
			flg = true;
		end	
	end
	return flg;
end

function onInit()
	local node = getDatabaseNode().getParent().getParent();
	local cmbtnode = node.createChild("combat");
	local curnode = cmbtnode.createChild("defences");
	curnode.onChildUpdate = update;
	curnode = cmbtnode.createChild("weapons");
	curnode.onChildUpdate = update;
	cmbtnode = node.createChild("items");
	curnode = cmbtnode.createChild("general");
	curnode.onChildUpdate = update;
	update();
end