local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Roact = require(Packages.Roact)

local EventController = require(script.EventController)
local EventTypes = require(script.EventTypes)

local EventManager = Roact.Component:extend("EventManager")

function EventManager:render()
	local eventControllers = {}

	for eventType, component in pairs(EventTypes) do
		eventControllers[eventType] = Roact.createElement(EventController, {
			Component = component,
			ListenTo = component.listenTo,
			MaxQuantity = component.maxQuantity,
			Cmdr = self.props.Cmdr
		})
	end

	return Roact.createFragment(eventControllers)
end

return EventManager