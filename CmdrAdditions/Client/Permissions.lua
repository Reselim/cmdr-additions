local Shared = script:FindFirstAncestor("CmdrAdditions").Shared

local GroupController = require(Shared.GroupController)

local PermissionsClient = {}
PermissionsClient.__index = PermissionsClient

function PermissionsClient.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		Controller = GroupController.new(cmdrAdditions.Config)
	}, PermissionsClient)

	self.Group = self.Controller:GetDefaultGroup()

	local function setGroup(groupName)
		self.Group = groupName
	end
	cmdrAdditions.Network:HandleEvent("UpdateGroup", setGroup)
	cmdrAdditions.Network:Request("GetGroup"):andThen(setGroup)

	return self
end

function PermissionsClient:CanRunCommand(commandId)
	return self.Controller:CanGroupRunCommand(self.Group, commandId)
end

function PermissionsClient:SetRegistery(registry)
	self.Controller:SetRegistry(registry)
end

return PermissionsClient