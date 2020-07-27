local Players = game:GetService("Players")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Roact = require(Packages.Roact)

local Root = require(script.Root)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UIPlugin = {}
UIPlugin.__index = UIPlugin

function UIPlugin.new(cmdrAdditions)
	return setmetatable({
		CmdrAdditions = cmdrAdditions
	}, UIPlugin)
end

function UIPlugin:Register(cmdr)
	local component = Roact.createElement(Root, {
		Cmdr = cmdr,
		CmdrAdditions = self.CmdrAdditions,
		Plugin = self
	})

	self.Handle = Roact.mount(component, PlayerGui, "CmdrAdditions")
end

return UIPlugin