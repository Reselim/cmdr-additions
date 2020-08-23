local Stream = require(script.Stream)

local StreamsServer = {}
StreamsServer.__index = StreamsServer

function StreamsServer.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		_streams = {}
	}, StreamsServer)

	cmdrAdditions.Network:SetRequestHandler("StreamSubscribe", function(player, streamName)
		local stream = self:GetStreamStrict(streamName)
		assert(stream:CanPlayerAccess(player), "Unauthorized")
		stream:AddSubscriber(player)
	end)

	cmdrAdditions.Network:SetRequestHandler("StreamUnsubscribe", function(player, streamName)
		self:GetStreamStrict(streamName):RemoveSubscriber(player)
	end)

	cmdrAdditions.Network:SetRequestHandler("StreamGetHistory", function(player, streamName)
		local stream = self:GetStreamStrict(streamName)
		assert(stream:CanPlayerAccess(player), "Unauthorized")
		return stream.History
	end)

	return self
end

function StreamsServer:GetStreamStrict(streamName)
	local stream = self._streams[streamName]

	if not stream then
		error(("Unknown stream with name %s"):format(streamName), 2)
	end
	
	return stream
end

function StreamsServer:GetStream(streamName)
	local stream = self._streams[streamName]

	if not stream then
		stream = Stream.new(streamName)

		stream.Event:Connect(function(event)
			for _, subscriber in pairs(stream.Subscribers) do
				self.CmdrAdditions.Network:SendEvent(subscriber, "StreamEvent", streamName, event)
			end
		end)

		self._streams[streamName] = stream
	end

	return stream
end

return StreamsServer