local Connection = {}
Connection.__index = Connection

function Connection.new(event, handler)
	return setmetatable({
		event = event,
		connected = true,
		_handler = handler
	}, Connection)
end

function Connection:disconnect()
	if self.connected then
		self.connected = false

		for index, connection in pairs(self.event._connections) do
			if connection == self then
				table.remove(self.event._connections, index)
				return
			end
		end
	end
end

local Event = {}
Event.__index = Event

function Event.new()
	return setmetatable({
		_connections = {},
		_threads = {}
	}, Event)
end

function Event:fire(...)
	for _, connection in pairs(self._connections) do
		connection._handler(...)
	end

	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end
	
	self._threads = {}
end

function Event:connect(handler)
	local connection = Connection.new(self, handler)
	table.insert(self._connections, connection)
	return connection
end

function Event:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

return Event