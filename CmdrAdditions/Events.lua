local RunService = game:GetService("RunService")

local Events = {}
Events.__index = Events

function Events.new()
	local self = setmetatable({}, Events)

	if RunService:IsClient() then
		self._folder = script:FindFirstChild("GeneratedEvents")
		assert(self._folder, "Can't find GeneratedEvents folder")
	elseif RunService:IsServer() then
		local folder = Instance.new("Folder")
		folder.Name = "GeneratedEvents"
		folder.Parent = script
		self._folder = folder
	end

	return self
end

function Events:CreateEvent(eventName)
	assert(RunService:IsServer(), "CreateEvent can only be ran on the server")

	local remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = eventName
	remoteEvent.Parent = self._folder

	return remoteEvent
end

function Events:GetEvent(eventName)
	return self._folder:FindFirstChild(eventName)
end

return Events.new()