return function(motor)
	-- hack, for now
	if motor.__state then
		return "Single"
	elseif motor.__states then
		return "Group"
	end
end