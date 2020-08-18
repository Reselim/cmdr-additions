local Workspace = game:GetService("Workspace")

local Root = script:FindFirstAncestor("CmdrAdditions")
local Packages = Root.Packages
local Components = script:FindFirstAncestor("UI").Components

local Roact = require(Packages.Roact)
local Flipper = require(Packages.Flipper)
local RoactFlipper = require(Packages.RoactFlipper)
local Util = require(Packages.Util)

local RoundedRectangle = require(Components.RoundedRectangle)

local ContentTypes = require(script.Parent.ContentTypes)
local WindowNavbar = require(script.Parent.WindowNavbar)

local Camera = Workspace.CurrentCamera

local Window = Roact.PureComponent:extend("Window")

function Window:init()
	self.Motor = Flipper.SingleMotor.new(0)

	self.Size, self.SetSize = Roact.createBinding(self.props.InitialSize)
	self.Position, self.SetPosition = Roact.createBinding((Camera.ViewportSize - self.props.InitialSize) / 2)
end

function Window:didMount()
	self.Motor:start()
	self.Motor:setGoal(
		Flipper.Spring.new(1, {
			frequency = 5,
			dampingRatio = 1
		})
	)
end

function Window:close()
	if not self.IsClosing then
		self.IsClosing = true

		self.Motor:setGoal(
			Flipper.Spring.new(0, {
				frequency = 5,
				dampingRatio = 0.85
			})
		)

		self.Motor:onComplete(self.props.Destroy)
	end
end

function Window:willUnmount()
	self.Motor:destroy()
end

function Window:render()
	local transparency = RoactFlipper.getBinding(self.Motor):map(function(value)
		return 1 - value
	end)

	return Roact.createElement(RoundedRectangle, {
		Radius = 8,
		Color = Color3.new(0, 0, 0),
		Transparency = transparency:map(function(value)
			return Util.Math.Lerp(0.5, 1, value)
		end),

		Size = self.Size:map(function(value)
			return UDim2.new(0, value.X, 0, value.Y)
		end),
		Position = self.Position:map(function(value)
			return UDim2.new(0, value.X, 0, value.Y)
		end),

		Active = true
	}, {
		Navbar = Roact.createElement(WindowNavbar, {
			Title = self.props.Title,
			Icon = self.props.Icon,
			Transparency = transparency,

			Move = function(offset)
				self.SetPosition(self.Position:getValue() + offset)
			end,

			Close = function()
				self:close()
			end
		}),

		Content = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, -34),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),

			ClipsDescendants = true,
			BackgroundTransparency = 1
		}, {
			Element = Roact.createElement(ContentTypes[self.props.Type], {
				Transparency = transparency
				-- TODO: Connect to stream to fetch data
			})
		})
	})
end

return Window