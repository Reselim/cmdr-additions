local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages

local Promise = require(Packages.Promise)
local Util = require(Packages.Util)

local NetworkClient = {}
NetworkClient.__index = NetworkClient

function NetworkClient.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,

		_remoteEvent = Root:FindFirstChildOfClass("RemoteEvent"),
		_remoteFunction = Root:FindFirstChildOfClass("RemoteFunction"),

		_events = {}
	}, NetworkClient)

	self._remoteEvent.OnClientEvent:Connect(function(eventName, ...)
		self:_getEvent(eventName):Fire(eventName)
	end)

	return self
end

function NetworkClient:_getEvent(eventName)
	local event = self._events[eventName]

	if not event then
		event = Util.Event.new()
		self._events[eventName] = event
	end

	return event
end

function NetworkClient:HandleEvent(eventName, handler)
	return self:_getEvent(eventName):Connect(handler)
end

function NetworkClient:Request(handlerName, ...)
	local arguments = { ... }
	return Promise.new(function(resolve, reject)
		local results = { self._remoteFunction:InvokeServer(handlerName, unpack(arguments)) }
		local success = table.remove(results, 1)

		if success then
			resolve(unpack(results))
		else
			reject(unpack(results))
		end
	end)
end

return NetworkClient