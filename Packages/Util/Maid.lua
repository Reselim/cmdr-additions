local LOCKED_ERROR = "Maid no longer usable, create a new maid if you wish to add events"

local TABLE_SEARCH_FUNCTIONS = {
	"Destroy", "destroy",
	"Disconnect", "disconnect"
}

local function dispose(object)
	local objectType = typeof(object)

	if objectType == "function" then
		object()
	elseif objectType == "table" or objectType == "userdata" then
		for _, functionName in ipairs(TABLE_SEARCH_FUNCTIONS) do
			local disposeFunction = object[functionName]
			if disposeFunction then
				disposeFunction(object)
				return
			end
		end
	elseif objectType == "Instance" then
		object:Destroy()
	elseif objectType == "RBXScriptConnection" then
		object:Disconnect()
	end
end

local Maid = {}
Maid.__index = Maid

function Maid.new(tasks)
	local self = setmetatable({
		_tasks = {},
		_locked = false
	}, Maid)

	if tasks then
		self:giveTasks(tasks)
	end

	return self
end

function Maid:giveTask(task)
	assert(not self._locked, LOCKED_ERROR)
	table.insert(self._tasks, task)
end

function Maid:giveTasks(tasks)
	assert(not self._locked, LOCKED_ERROR)
	for _, task in pairs(tasks) do
		self:giveTask(task)
	end
end

function Maid:clean()
	-- Calling Maid:clean() multiple times is okay; it shouldn't error

	-- Example case: Disconnecting any input listeners when a Roact component is unmounted
	-- that may otherwise be disconnected when the input is ended.

	if not self._locked then
		self._locked = true

		for _, task in pairs(self._tasks) do
			dispose(task)
		end

		self._tasks = nil
	end
end

return Maid