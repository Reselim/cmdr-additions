local Root = script:FindFirstAncestor("CmdrAdditions")

local Events = require(Root.Events)

local PermissionsController = require(script.Parent.Controller)

local PermissionsPluginClient = {}
PermissionsPluginClient.__index = PermissionsPluginClient

function PermissionsPluginClient.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		Config = cmdrAdditions.Config,
		_controller = PermissionsController.new(cmdrAdditions.Config)
	}, PermissionsPluginClient)

	-- Set currentGroup to the lowest priority group, until it can be fetched from the server
	self._currentGroup = self.Config.Groups[#self.Config.Groups].Name

	self._remoteEvent = Events:GetEvent("ReplicateCurrentGroup")
	self._remoteEvent.OnClientEvent:Connect(function(currentGroup)
		self._currentGroup = currentGroup
	end)
	self._remoteEvent:FireServer() -- Request server to send over the current group

	return self
end

function PermissionsPluginClient:CanRunCommand(commandId)
	return self._controller:CanGroupRunCommand(self._currentGroup, commandId)
end

function PermissionsPluginClient:Register(cmdr)
	self._controller:SetRegistry(cmdr.Registry)

	cmdr.Registry:RegisterHook("BeforeRun", function(context)
		if not self:CanRunCommand(context.Name) then
			local requiredGroup = self._controller:GetCommandGroup(context.Name)
			return ("You must be in group %s to use this command. Current group: %s"):format(requiredGroup, self._currentGroup)
		end
	end)
end

return PermissionsPluginClient