local HttpService = game:GetService("HttpService")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)
local Util = require(Packages.Util)

local Window = require(script.Window)

local DEFAULT_SIZE = Vector2.new(310, 370)

local WindowManager = Roact.Component:extend("WindowManager")

function WindowManager:init()
	--[[self:spawnWindow({
		Title = "Example window",
		Type = "Logs",
		Icon = "CommandLogs",
		Stream = "CommandLogs"
	})]]
end

function WindowManager:spawnWindow(data)
	local windowId = HttpService:GenerateGUID(false)

	self:setState({
		[windowId] = data
	})
end

function WindowManager:render()
	local windows = {}

	for windowId, data in pairs(self.state) do
		windows[windowId] = Roact.createElement(Window, Util.Dictionary.merge(data, {
			InitialSize = DEFAULT_SIZE,
			Destroy = function()
				self:setState({
					[windowId] = Roact.None
				})
			end
		}))
	end

	return Roact.createFragment(windows)
end

return WindowManager