local GroupController = {}
GroupController.__index = GroupController

function GroupController.new(config)
	local self = setmetatable({
		Config = config,
		Groups = {}
	}, GroupController)

	for index, group in pairs(config.Groups) do
		self.Groups[group.Name] = {
			Name = group.Name,
			Index = index,
			AllowHigherGroups = true
		}
	end

	return self
end

function GroupController:SetRegistry(registry)
	self.Registry = registry
end

function GroupController:GetDefaultGroup()
	return self.Config.Groups[#self.Config.Groups].Name
end

function GroupController:GetCommandGroup(commandId)
	assert(commandId, "missing argument #1: commandId")
	return self.Config.CommandGroups[commandId] or self.Config.DefaultCommandGroup
end

function GroupController:CanGroupAccessOtherGroup(groupName, targetGroupName)
	assert(groupName, "missing argument #1: groupName")
	assert(targetGroupName, "missing argument #2: targetGroupName")

	local group = self.Groups[groupName]
	local targetGroup = self.Groups[targetGroupName]

	if group.Name == targetGroup.Name then
		return true
	end

	if targetGroup.AllowHigherGroups and group.Index < targetGroup.Index then
		return true
	end

	return false
end

function GroupController:CanGroupRunCommand(groupName, commandId)
	assert(groupName, "missing argument #1: groupName")
	assert(commandId, "missing argument #2: commandId")

	local command = self.Registry.Commands[commandId]

	if command.Group == "CmdrAdditions" or self.Config.BlockForeignCommands then
		local requiredGroup = self:GetCommandGroup(command.Name)
		return self:CanGroupAccessOtherGroup(groupName, requiredGroup)
	else
		return true
	end
end

return GroupController