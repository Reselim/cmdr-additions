local HttpService = game:GetService("HttpService")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Roact = require(Packages.Roact)

local EventController = Roact.Component:extend("EventController")

function EventController:init()
	self.props.Cmdr:HandleEvent(self.props.ListenTo, function(data)
		self:pushEvent(data)
	end)
end

function EventController:pushEvent(data)
	self:setState(function(state)
		local newState = {}

		table.insert(newState, 1, {
			Id = HttpService:GenerateGUID(false),
			Active = true,
			Data = data
		})

		for index, event in pairs(state) do
			table.insert(newState, {
				Id = event.Id,
				Active = (index + 1) <= self.props.MaxQuantity,
				Data = event.Data
			})
		end

		return newState
	end)
end

function EventController:render()
	local events = {}

	for index, event in ipairs(self.state) do
		events[event.Id] = Roact.createElement(self.props.Component, {
			Index = index,
			Active = event.Active,
			Data = event.Data,
			Destroy = function()
				self:setState(function(state)
					-- TODO: get current index from id
					table.remove(state, index)
					return state
				end)
			end
		})
	end

	return Roact.createFragment(events)
end

return EventController