local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local CmdrContext = require(script.CmdrContext)

local EventManager = require(script.EventManager)
local WindowManager = require(script.WindowManager)

local UI = Roact.Component:extend("UI")

function UI:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 1000 - 1 -- Cmdr display order is 1000
	}, {
		Roact.createElement(CmdrContext.Provider, {
			value = self.props.Cmdr
		}, {
			EventManager = Roact.createElement(EventManager),
			WindowManager = Roact.createElement(WindowManager)
		})
	})
end

return UI