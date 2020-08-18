local Players = game:GetService("Players")

local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages
local Shared = Root.Shared

local Promise = require(Packages.Promise)

local GroupController = require(Shared.GroupController)

local PermissionsServer = {}
PermissionsServer.__index = PermissionsServer

function PermissionsServer.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		Controller = GroupController.new(cmdrAdditions.Config),
		_groups = {}
	}, PermissionsServer)

	Players.PlayerAdded:Connect(function(player)
		self._groups[player] = self.Controller:GetDefaultGroup()

		self:_resolvePlayerGroup(player):andThen(function(groupName)
			if groupName then
				self._groups[player] = groupName
			end
		end):catch(function(error)
			warn(("[cmdr-additions] Failed to get permission group for %s:"):format(player.Name))
			warn(error)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._groups[player] = nil
	end)

	cmdrAdditions.Network:SetRequestHandler("GetGroup", function(player)
		return self._groups[player]
	end)
	
	return self
end

function PermissionsServer:_resolvePlayerGroup(player)
	local promises = {}

	for _, getter in pairs(self.CmdrAdditions.Config.GroupGetters) do
		table.insert(promises, Promise.promisify(getter)(player))
	end

	return Promise.all(promises):andThen(function(groups)
		local targetGroup

		for _, groupName in pairs(groups) do
			local group = self.Controller.Groups[groupName]
			if not targetGroup or group.Index < targetGroup.Index then
				targetGroup = group
			end
		end

		return targetGroup.Name
	end)
end

function PermissionsServer:GetPlayerGroup(player)
	return self._groups[player] or self.Controller:GetDefaultGroup()
end

function PermissionsServer:SetPlayerGroup(player, groupName)
	-- Make sure the player is still in the game so we don't cause memory leaks
	if player:IsDescendantOf(game) then
		self._groups[player] = groupName
		self.CmdrAdditions.Network:SendEvent(player, "UpdateGroup", groupName)
	end
end

function PermissionsServer:CanPlayerRunCommand(player, commandId)
	local groupName = self:GetPlayerGroup(player)
	return self.Controller:CanGroupRunCommand(groupName, commandId)
end

function PermissionsServer:SetRegistry(registry)
	self.Controller:SetRegistry(registry)
end

return PermissionsServer