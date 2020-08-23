local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Util = require(Packages.Util)

local Stream = {}
Stream.__index = Stream

function Stream.new(name, historyLimit)
	return setmetatable({
		Name = name,

		History = {},
		_historyLimit = historyLimit or 500,
		
		Subscribers = {},
		_restrictors = {},

		Event = Util.Event.new()
	}, Stream)
end

function Stream:AddRestrictor(restrictor)
	table.insert(self._restrictors, restrictor)
end

function Stream:CanPlayerAccess(player)
	for _, restrictor in ipairs(self._restrictors) do
		if not restrictor(player) then
			return false
		end
	end

	return true
end

function Stream:AddSubscriber(player)
	self:RemoveSubscriber(player)
	table.insert(self.Subscribers, player)
end

function Stream:RemoveSubscriber(player)
	local index = table.find(self.Subscribers, player)
	if index then
		table.remove(self.Subscribers, index)
	end
end

function Stream:Push(event)
	self.Event:Fire(event)

	table.insert(self.History, event)
	
	if #self.History > self._historyLimit then
		for _ = 1, #self.History - self._historyLimit do
			table.remove(self.History, 1)
		end
	end
end

return Stream