local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Roact = require(Packages.Roact)

local EventManager = require(script.Parent.EventManager)
local WindowManager = require(script.Parent.WindowManager)

local Root = Roact.Component:extend("Root")

function Root:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 1000 - 1 -- Cmdr display order is 1000
	}, {
		EventManager = Roact.createElement(EventManager, self.props),
		WindowManager = Roact.createElement(WindowManager, self.props)
	})
end

return Root