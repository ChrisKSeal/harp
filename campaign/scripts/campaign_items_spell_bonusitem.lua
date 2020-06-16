function onInit()
	if super and super.onInit then
		super.onInit();
	end

	-- done
	initialised = true;
	registerMenuItem("Delete Bound Spell","delete",6);
end

function onMenuSelection(item)
	if item then
		if item==6 then
			getDatabaseNode().delete();
		end
	end
end