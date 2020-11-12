local Dictionary = {}

--- Merges key/value pairs from multiple dictionaries into one 
-- @param ... Tuple of dictionaries to merge
function Dictionary.merge(...)
	local newDictionary = {}

	for _, dictionary in pairs({ ... }) do
		for key, value in pairs(dictionary) do
			newDictionary[key] = value
		end
	end

	return newDictionary
end

--- Counts the number of items in a dictionary by iterating over it
-- @param dictionary The dictionary to count
function Dictionary.count(dictionary)
	local count = 0

	for _ in pairs(dictionary) do
		count = count + 1
	end
	
	return count
end

--- Like Array.Map, however it keeps the key
-- @param dictionary Dictionary to map
-- @param callback(value,key,dictionary) Function called on every element
function Dictionary.map(dictionary, callback)
	local newDictionary = {}

	for key, value in pairs(dictionary) do
		newDictionary[key] = callback(value, key, dictionary)
	end

	return newDictionary
end

--- Creates a shallow copy of a dictionary
-- @param dictionary The dictionary to copy
function Dictionary.clone(dictionary)
	local newDictionary = {}

	for key, value in pairs(dictionary) do
		newDictionary[key] = value
	end

	return newDictionary
end

return Dictionary