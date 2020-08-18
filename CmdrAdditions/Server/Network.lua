local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages

local Promise = require(Packages.Promise)

local NetworkServer = {}
NetworkServer.__index = NetworkServer

function NetworkServer.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		_handlers = {}
	}, NetworkServer)

	-- For server -> client events only
	local remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Parent = Root
	self._remoteEvent = remoteEvent

	-- All requests from the client to the server go through the RemoteFunction so a full response can always be returned
	local remoteFunction = Instance.new("RemoteFunction")
	remoteFunction.Parent = Root
	self._remoteFunction = remoteFunction

	function remoteFunction.OnServerInvoke(player, eventName, ...)
		local handler = self._handlers[eventName]

		if not handler then
			return false, ("No handler for event %s"):format(eventName)
		end

		local results = { pcall(handler, player, ...) }
		local success = table.remove(results, 1)

		if success and Promise.is(results[1]) then
			return results[1]:await()
		end

		return success, unpack(results)
	end

	return self
end

function NetworkServer:SendEvent(player, eventName, ...)
	self._remoteEvent:FireClient(player, eventName, ...)
end

function NetworkServer:BroadcastEvent(eventName, ...)
	self._remoteEvent:FireAllClients(eventName, ...)
end

function NetworkServer:SetRequestHandler(handlerName, handler)
	assert(not self._handlers[handlerName], ("Handler already exists for event %s"):format(handlerName))
	self._handlers[handlerName] = handler
end

return NetworkServer