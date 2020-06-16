function onInit()
    if super and super.onInit then
        super.onInit();
    end
	showGeneral(isGeneral());
end

function isWeapon()
	local node = getDatabaseNode();
	if node.getChild("item_type") then
		if node.getChild("item_type").getValue() == 1 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function isDefence()
	local node = getDatabaseNode();
	if node.getChild("item_type") then
		if node.getChild("item_type").getValue() == 2 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function isConsumable()
	local node = getDatabaseNode();
	if node.getChild("item_type") then
		if node.getChild("item_type").getValue() == 3 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function isGeneral()
	local node = getDatabaseNode();
	if node.getChild("item_type") then
		if node.getChild("item_type").getValue() == 4 then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function showGeneral(state)
	general_label.setVisible(state);
	general_notes.setVisible(state);
end

