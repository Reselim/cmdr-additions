local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local UI = script:FindFirstAncestor("UI")

local Roact = require(Packages.Roact)

local CmdrContext = require(UI.CmdrContext)

local EventController = require(script.EventController)
local EventTypes = require(script.EventTypes)

local EventManager = Roact.Component:extend("EventManager")

function EventManager:render()
	return Roact.createElement(CmdrContext.Consumer, {
		render = function(cmdr)
			local eventControllers = {}

			for eventType, component in pairs(EventTypes) do
				eventControllers[eventType] = Roact.createElement(EventController, {
					Component = component,
					ListenTo = component.listenTo,
					MaxQuantity = component.maxQuantity,
					Cmdr = cmdr
				})
			end

			return Roact.createFragment(eventControllers)
		end
	})
end

return EventManager