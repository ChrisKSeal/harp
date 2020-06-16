-- Roll and Drag
function Roll(nodepath)
	local customData = Rules_CustomData.ResistanceRoll(nodepath);
	if customData then
		ChatManager.throwDice("dice", {"d100","d10"}, 0, "", customData);
	end
end

