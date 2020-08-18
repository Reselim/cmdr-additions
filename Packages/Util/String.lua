local String = {}

--- Builds a string from a sequence of character codes
-- @param codes Array of character codes
function String.Build(codes)
	local output = {}

	for index = 1, #codes, 4096 do
		table.insert(output, string.char(
			unpack(codes, index, math.min(index + 4096 - 1, #codes))
		))
	end

	return table.concat(output, "")
end

--- Trims leading and trailing whitespace from a string
-- @param string String to trim
function String.Trim(string)
	return string
		:gsub("^%s+", "")
		:gsub("%s+$", "")
end

return String