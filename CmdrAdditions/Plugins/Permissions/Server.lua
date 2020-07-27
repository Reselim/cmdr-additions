local Players = game:GetService("Players")

local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages

local Events = require(Root.Events)
local Promise = require(Packages.Promise)

local PermissionsController = require(script.Parent.Controller)

local PermissionsPluginServer = {}
PermissionsPluginServer.__index = PermissionsPluginServer

function PermissionsPluginServer.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		Config = cmdrAdditions.Config,
		_controller = PermissionsController.new(cmdrAdditions.Config),
		_playerGroups = {}
	}, PermissionsPluginServer)

	self._remoteEvent = Events:CreateEvent("ReplicateCurrentGroup")
	self._remoteEvent.OnServerEvent:Connect(function(player)
		self._remoteEvent:FireClient(player, self._playerGroups[player])
	end)
	
	Players.PlayerAdded:Connect(function(player)
		-- Set currentGroup to the lowest priority group
		self:SetPlayerGroup(player, self.Config.Groups[#self.Config.Groups].Name)

		self:_fetchGroupForPlayer(player):andThen(function(groupName)
			if groupName then
				self:SetPlayerGroup(player, groupName)
			end
		end):catch(function(error)
			warn(("[cmdr-additions] Failed fetching group for player %s:"):format(player.Name))
			warn(error)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._playerGroups[player] = nil
	end)

	return self
end

function PermissionsPluginServer:_fetchGroupForPlayer(player)
	local promises = {}

	for _, getter in ipairs(self.Config.GroupGetters) do
		table.insert(promises, Promise.new(function(resolve, reject)
			local success, result = pcall(getter, player)

			if success then
				resolve(result)
			else
				reject(result)
			end
		end))
	end

	return Promise.all(promises):andThen(function(returnedGroups)
		local highestGroup

		for _, groupName in pairs(returnedGroups) do
			local group = self._controller.Groups[groupName]

			if not highestGroup or group.Index < highestGroup.Index then
				highestGroup = group
			end
		end

		if highestGroup then
			return highestGroup.Name
		end
	end)
end

function PermissionsPluginServer:CanPlayerRunCommand(player, commandId)
	local groupName = self._playerGroups[player]
	return self._controller:CanGroupRunCommand(groupName, commandId)
end

function PermissionsPluginServer:GetPlayerGroup(player)
	return self._playerGroups[player]
end

function PermissionsPluginServer:SetPlayerGroup(player, groupName)
	if player:IsDescendantOf(game) then
		self._playerGroups[player] = groupName
		self._remoteEvent:FireClient(player, groupName)
	end
end

function PermissionsPluginServer:Register(cmdr)
	self._controller:SetRegistry(cmdr.Registry)
	
	cmdr.Registry:RegisterHook("BeforeRun", function(context)
		if not self:CanPlayerRunCommand(context.Executor, context.Name) then
			warn(("[cmdr-additions] %s somehow bypassed client-side group validation!"):format(context.Executor.Name))
			return "Unauthorized"
		end
	end)
end

return PermissionsPluginServer