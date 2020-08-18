local TABLE_METHODS = {
	"Disconnect", "disconnect",
	"Destroy", "destroy"
}

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid:GiveTask(task)
	table.insert(self._tasks, task)
end

function Maid:GiveTasks(tasks)
	for _, task in pairs(tasks) do
		self:GiveTask(task)
	end
end

function Maid:Clean()
	for _, task in pairs(self._tasks) do
		if typeof(task) == "Instance" then
			task:Destroy()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif typeof(task) == "table" then
			for _, methodName in ipairs(TABLE_METHODS) do
				if task[methodName] then
					task[methodName](task)
				end
			end
		end
	end
end

Maid.Destroy = Maid.Clean

return Maid