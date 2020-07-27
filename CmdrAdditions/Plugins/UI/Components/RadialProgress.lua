local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local TRANSPARENCY_SEQUENCE = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5 - 0.001, 1),
	NumberSequenceKeypoint.new(0.5 + 0.001, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local RadialProgress = Roact.PureComponent:extend("RadialProgress")

RadialProgress.defaultProps = {
	Clockwise = true
}

function RadialProgress:render()
	local imageSize = self.props.ImageSize

	local gradientRotation = self.props.Clockwise and self.props.Value:map(function(value)
		return (value - 0.5) * 360
	end) or angle:map(function(value)
		return -value * 360
	end)

	local isUnderHalf = self.props.Value:map(function(value) return value < 0.5 end)
	local isOverHalf = self.props.Value:map(function(value) return value > 0.5 end)

	return Roact.createElement("Frame", {
		Size = self.props.Size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
		Rotation = self.props.Rotation,

		BackgroundTransparency = 1
	}, {
		Left = Roact.createElement("ImageLabel", {
			Image = self.props.Image,
			ImageColor3 = self.props.ImageColor3,
			ImageTransparency = self.props.ImageTransparency,
			ImageRectSize = Vector2.new(imageSize.X / 2, imageSize.Y),

			Size = UDim2.new(0.5, 0, 1, 0),
			
			BackgroundTransparency = 1,

			Visible = not self.props.Clockwise or isOverHalf
		}, {
			Gradient = Roact.createElement("UIGradient", {
				Offset = Vector2.new(0.5, 0),
				Transparency = TRANSPARENCY_SEQUENCE,
				-- The image itself will not be visible if under half, so we can just keep this enabled
				Enabled = self.props.Clockwise and true or isUnderHalf,
				Rotation = gradientRotation
			})
		}),

		Right = Roact.createElement("ImageLabel", {
			Image = self.props.Image,
			ImageColor3 = self.props.ImageColor3,
			ImageTransparency = self.props.ImageTransparency,
			ImageRectSize = Vector2.new(imageSize.X / 2, imageSize.Y),
			ImageRectOffset = Vector2.new(imageSize.X / 2, 0),

			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			
			BackgroundTransparency = 1,

			Visible = self.props.Clockwise or isOverHalf
		}, {
			Gradient = Roact.createElement("UIGradient", {
				Offset = Vector2.new(-0.5, 0),
				Transparency = TRANSPARENCY_SEQUENCE,
				Enabled = self.props.Clockwise and isUnderHalf or true,
				Rotation = gradientRotation
			})
		})
	})
end

return RadialProgress