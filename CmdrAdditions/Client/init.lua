local Players = game:GetService("Players")

local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages
local Shared = Root.Shared

local Roact = require(Packages.Roact)

local Base = require(Shared.Base)
local Permissions = require(script.Permissions)
local Network = require(script.Network)
local UI = require(script.UI)
local Streams = require(script.Streams)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local CmdrAdditionsClient = setmetatable({}, Base)
CmdrAdditionsClient.__index = CmdrAdditionsClient

function CmdrAdditionsClient.new(...)
	local self = setmetatable(Base.new(...), CmdrAdditionsClient)

	self.Network = Network.new(self)
	self.Permissions = Permissions.new(self)
	self.Streams = Streams.new(self)

	return self
end

function CmdrAdditionsClient:SetCmdr(cmdr)
	Base.SetCmdr(self, cmdr)

	self.Permissions:SetRegistery(cmdr.Registry)

	-- Register permissions hook
	cmdr.Registry:RegisterHook("BeforeRun", function(context)
		if not self.Permissions:CanRunCommand(context.Name) then
			local requiredGroup = self.Permissions.Controller:GetCommandGroup(context.Name)
			return ("You don't have permission to run this command! Required group: %s"):format(requiredGroup)
		end
	end)

	-- Mount UI
	local element = Roact.createElement(UI, {
		Cmdr = cmdr,
		CmdrAdditions = self
	})
	self._uiHandle = Roact.mount(element, PlayerGui, "UI")
end

return CmdrAdditionsClient