function isRanged(wpn)
	local flg = false;
	if wpn.getChild("primary_category") then
		local class = wpn.getChild("primary_category").getValue();
		if class > 6 and class < 13 then
			flg = true;
		elseif class > 17 then
			flg = true;
		end
	end
	if wpn.getChild("multiple_attacks") then
		if wpn.getChild("multiple_attacks").getValue() == 1 then
			local class = wpn.getChild("secondary_category").getValue();
			if class > 6 and class < 13 then
				flg = true;
			elseif class > 17 then
				flg = true;
			end
		end
	end
	return flg;
end

function isMelee(wpn)
	local flg = false;
	if wpn.getChild("primary_category") then
		local class = wpn.getChild("primary_category").getValue();
		if class > 12 and class < 18 then
			flg = true;
		elseif class < 7 then
			flg = true;
		end
	end
	if wpn.getChild("multiple_attacks") then
		if wpn.getChild("multiple_attacks").getValue() == 1 then
			local class = wpn.getChild("secondary_category").getValue();
			if class > 12 and class < 18 then
				flg = true;
			elseif class < 7 then
				flg = true;
			end
		end
	end
	return flg;
end