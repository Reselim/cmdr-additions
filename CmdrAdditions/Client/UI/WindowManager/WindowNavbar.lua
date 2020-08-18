local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Components = script:FindFirstAncestor("UI").Components

local Roact = require(Packages.Roact)
local Util = require(Packages.Util)

local RoundedRectangle = require(Components.RoundedRectangle)
local Dragger = require(Components.Dragger)

local ICONS = {
	AdminLogs = "rbxassetid://",
	ChatLogs = "rbxassetid://"
}

local function WindowNavbarButton(props)
	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, 18, 1, 0),

		LayoutOrder = -props.Index,
		BackgroundTransparency = 1
	}, {
		Circle = Roact.createElement("ImageLabel", {
			Image = "rbxassetid://3088713341",
			ImageColor3 = props.Color,
			ImageTransparency = props.Transparency,

			Size = UDim2.new(0, 10, 0, 10),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 1
		})
	})
end

local WindowNavbar = Roact.PureComponent:extend("WindowNavbar")

function WindowNavbar:render()
	local transparency = self.props.Transparency

	return Roact.createElement(RoundedRectangle, {
		Radius = 8,
		Mode = "SingleEdge",
		Edge = "Top",
		Color = Color3.new(0, 0, 0),
		Transparency = transparency:map(function(value)
			return Util.Math.Lerp(0.5, 1, value)
		end),

		Size = UDim2.new(1, 0, 0, 34),

		ClipsDescendants = true
	}, {
		Dragger = Roact.createElement(Dragger, {
			Size = UDim2.new(1, 0, 1, 0),
			Move = self.props.Move
		}),

		Title = Roact.createElement("TextLabel", {
			Text = self.props.Title,
			Font = Enum.Font.Gotham,
			TextSize = 18,
			TextColor3 = Color3.new(1, 1, 1),
			TextTransparency = transparency,
			TextXAlignment = Enum.TextXAlignment.Left,

			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 14, 0, 0),

			BackgroundTransparency = 1
		}),

		Buttons = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Close = Roact.createElement(WindowNavbarButton, {
				Index = 1,
				Color = Color3.fromRGB(0xDF, 0x36, 0x53),
				Activated = self.props.Close,
				Transparency = transparency
			}),

			Toggle = Roact.createElement(WindowNavbarButton, {
				Index = 2,
				Color = Color3.fromRGB(0xDF, 0x96, 0x36),
				Activated = self.props.Toggle,
				Transparency = transparency
			}),

			Padding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 10)
			}),

			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}),

		Icon = Roact.createElement("ImageLabel", {
			Image = ICONS[self.props.Icon],
			ImageTransparency = transparency:map(function(value)
				return Util.Math.Lerp(0.85, 1, value)
			end),

			Size = UDim2.new(0, 48, 0, 48),
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),

			ZIndex = 0,
			BackgroundTransparency = 1
		})
	})
end

return WindowNavbar