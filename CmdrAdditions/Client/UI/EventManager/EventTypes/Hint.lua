local TextService = game:GetService("TextService")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Components = script:FindFirstAncestor("UI").Components

local Roact = require(Packages.Roact)
local Flipper = require(Packages.Flipper)
local RoactFlipper = require(Packages.RoactFlipper)
local Util = require(Packages.Util)
local Promise = require(Packages.Promise)

local RoundedRectangle = require(Components.RoundedRectangle)

local OFFSET = 6
local SPACING = 4
local HEIGHT = 32
local DURATION = 4

local MOUNT_SPRING = {
	frequency = 4,
	dampingRatio = 0.95
}

local Hint = Roact.PureComponent:extend("Hint")

Hint.listenTo = "ShowHint"
Hint.maxQuantity = 3

function Hint:init()
	self.Motor = Flipper.GroupMotor.new({ Opacity = 0, Index = self.props.Index - 1 })
	self.ContentSize, self.SetContentSize = Roact.createBinding(Vector2.new(0, 0))
end

function Hint:didMount()
	self.Motor:setGoal({
		Index = Flipper.Spring.new(self.props.Index, MOUNT_SPRING),
		Opacity = Flipper.Spring.new(1, MOUNT_SPRING)
	})

	self.Timer = Promise.delay(DURATION):andThen(function()
		self:close()
	end)
end

function Hint:close()
	if self.props.Active and not self.IsClosing then
		if self.Timer then
			self.Timer:cancel()
		end

		self.IsClosing = true

		self.Motor:setGoal({
			Opacity = Flipper.Spring.new(0, {
				frequency = 6,
				dampingRatio = 0.8
			})
		})

		self.Motor:onComplete(self.props.Destroy)
	end
end

function Hint:didUpdate(lastProps)
	if self.props.Index ~= lastProps.Index then
		self.Motor:setGoal({
			Index = Flipper.Spring.new(self.props.Index, MOUNT_SPRING)
		})
	end

	if self.props.Active ~= lastProps.Active and not self.props.Active then
		self:close()
	end
end

function Hint:render()
	local data = self.props.Data
	
	local transparency = RoactFlipper.getBinding(self.Motor):map(function(values)
		return 1 - values.Opacity
	end)

	local authorTextBounds = TextService:GetTextSize(
		data.Author, 16, Enum.Font.GothamSemibold,
		Vector2.new(math.huge, math.huge)
	)

	local contentTextBounds = TextService:GetTextSize(
		data.Content, 16, Enum.Font.Gotham,
		Vector2.new(math.huge, math.huge)
	)

	return Roact.createElement(RoundedRectangle, {
		Radius = 8,
		Color = Color3.new(0, 0, 0),
		Transparency = transparency:map(function(value)
			return Util.Math.lerp(0.5, 1, value)
		end),

		Size = self.ContentSize:map(function(value)
			return UDim2.new(0, value.X, 0, HEIGHT)
		end),
		Position = RoactFlipper.getBinding(self.Motor):map(function(values)
			return UDim2.new(0.5, 0, 0, OFFSET + (HEIGHT + SPACING) * (values.Index - 1))
		end),
		AnchorPoint = Vector2.new(0.5, 0),

		Activated = function()
			self:close()
		end
	}, {
		Author = Roact.createElement(RoundedRectangle, {
			Mode = "SingleEdge",
			Edge = "Left",
			Radius = 8,

			Color = Color3.new(0, 0, 0),
			Transparency = transparency:map(function(value)
				return Util.Math.lerp(0.5, 1, value)
			end),

			Size = UDim2.new(0, 16 + authorTextBounds.X + 16, 1, 0),

			LayoutOrder = 1
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = data.Author,
				Font = Enum.Font.GothamSemibold,
				TextSize = 16,
				TextColor3 = Color3.new(1, 1, 1),
				TextTransparency = transparency,

				Size = UDim2.new(1, 0, 1, 0),

				BackgroundTransparency = 1
			})
		}),

		Content = Roact.createElement("TextLabel", {
			Text = data.Content,
			Font = Enum.Font.Gotham,
			TextSize = 16,
			TextColor3 = Color3.new(1, 1, 1),
			TextTransparency = transparency,

			Size = UDim2.new(0, 16 + contentTextBounds.X + 16, 1, 0),

			LayoutOrder = 2,
			BackgroundTransparency = 1
		}),

		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,

			[Roact.Change.AbsoluteContentSize] = function(object)
				self.SetContentSize(object.AbsoluteContentSize)
			end
		})
	})
end

return Hint