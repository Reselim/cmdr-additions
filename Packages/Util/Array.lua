local Array = {}

--- Creates an array from a dictionary
-- @param dictionary Dictionary to turn into an array
function Array.from(dictionary)
	local newArray = {}

	for _, value in pairs(dictionary) do
		table.insert(newArray, value)
	end
	
	return newArray
end

--- Searches through an array using a callback function
-- @param array Array to search
-- @param callback(value,index,array) Function called on every array element
function Array.find(array, callback)
	for index, value in ipairs(array) do
		if callback(value, index, array) then
			return value, index
		end
	end
end

--- Creates a new array using callback as a filter function
-- @param array Array to filter
-- @param callback(value, index, array) Function called on every array element
function Array.filter(array, callback)
	local newArray = {}

	for index, value in ipairs(array) do
		if callback(value, index, array) then
			table.insert(newArray, value)
		end
	end

	return newArray
end

--- Creates a new array with all sub-array elements concatenated into it recursively up to the specified depth
-- @param array Array to flatten
-- @param depth Depth level specifying how deep a nested array structure should be flattened
function Array.flatten(array, depth)
	depth = (depth or 1) - 1

	local newArray = {}
	
	for _, value in ipairs(array) do
		if type(value) == "array" then
			for _, subValue in ipairs(value) do
				table.insert(newArray, subValue)
			end
		else
			table.insert(newArray, value)
		end
	end

	if depth > 0 then
		return Array.Flatten(newArray, depth)
	else
		return newArray
	end
end

--- Calls a function for each element in an array, and replaces that element with the return value from the callback
-- @param array Array to map
-- @param callback(value,index,array) Function called on every array element
function Array.map(array, callback)
	local newArray = {}

	for index, value in ipairs(array) do
		newArray[index] = callback(value, index, array)
	end

	return newArray
end

--- Reverses an array
-- @param array Array to reverse
-- @return A reversed copy of the array
function Array.reverse(array)
	local newArray = {}

	for index, value in ipairs(array) do
		newArray[(#array - index) + 1] = value
	end

	return newArray
end

--- Samples a subsection of an array
-- @param array Array to sample from
-- @param rangeStart Start of slice range
-- @param rangeEnd End of slice range
function Array.slice(array, rangeStart, rangeEnd)
	local newArray = {}

	for index = rangeStart, rangeEnd do
		newArray[(index - rangeStart) + 1] = array[index]
	end

	return newArray
end

--- Faster version of Array.Slice, which only supports up to 8000 values
-- @param array Array to sample from
-- @param rangeStart Start of slice range
-- @param rangeEnd End of slice range
function Array.fastSlice(array, rangeStart, rangeEnd)
	return { unpack(array, rangeStart, rangeEnd - 1) }
end

return Array