local Stream = require(script.Stream)

local StreamsClient = {}
StreamsClient.__index = StreamsClient

function StreamsClient.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		_streams = {}
	}, StreamsClient)

	cmdrAdditions.Network:HandleEvent("StreamEvent", function(streamName, event)
		local stream = self._streams[streamName]
		if stream then
			stream:_emit(event)
		end
	end)

	return self
end

function StreamsClient:GetStream(streamName)
	local stream = self._streams[streamName]

	if not stream then
		stream = Stream.new(self, streamName)
		self._streams[streamName] = stream
	end

	return stream
end

return StreamsClient