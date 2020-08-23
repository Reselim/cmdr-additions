local Connection = {}
Connection.__index = Connection

function Connection.new(stream, handler)
	return setmetatable({
		Stream = stream,
		Connected = false,
		_handler = handler
	}, Connection)
end

function Connection:Disconnect()
	for index, connection in pairs(self.Stream._connections) do
		if connection == self then
			table.remove(self.Stream._connections, index)
			return
		end
	end

	if #self.Stream._connections == 0 then
		self.Stream:_unsubscribe()
	end
end

local Stream = {}
Stream.__index = Stream

function Stream.new(streams, name)
	return setmetatable({
		Streams = streams,
		Name = name,
		Subscribed = false,
		_connections = {}
	}, Stream)
end

function Stream:_subscribe()
	if not self.Subscribed then
		return self.Streams.CmdrAdditions.Network:Request("StreamSubscribe", self.Name)
	end
end

function Stream:_unsubscribe()
	if self.Subscribed then
		return self.Streams.CmdrAdditions.Network:Request("StreamUnsubscribe", self.Name)
	end
end

function Stream:_emit(event)
	for _, connection in pairs(self._connections) do
		connection._handler(event)
	end
end

function Stream:FetchHistory()
	return self.Streams.CmdrAdditions.Network:Request("StreamGetHistory", self.Name)
end

function Stream:Connect(handler)
	if #self._connections == 0 then
		self:_subscribe()
	end

	local connection = Connection.new(self, handler)
	table.insert(self._connections, connection)
	return connection
end

return Stream