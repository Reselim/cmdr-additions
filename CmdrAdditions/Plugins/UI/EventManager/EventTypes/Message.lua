local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Components = script:FindFirstAncestor("UI").Components

local Roact = require(Packages.Roact)
local Otter = require(Packages.Otter)
local RoactOtter = require(Packages.RoactOtter)
local Utility =  require(Packages.Utility)

local RadialProgress = require(Components.RadialProgress)
local VectorClip = require(Components.VectorClip)

local TEXT_MAX_WIDTH = 480
local CONTENT_PADDING = Vector2.new(22, 19)

local function GetActiveTime(text)
	return 6 -- todo: calculate based on text length
end

local MessageEvent = Roact.PureComponent:extend("MessageEvent")

MessageEvent.listenTo = "ShowGlobalMessage"
MessageEvent.maxQuantity = 1

function MessageEvent:init()
	self.Motor = Otter.createSingleMotor(0)
	self.TimeRemaining, self.SetTimeRemaining = Roact.createBinding(0)

	local data = self.props.Data
	self.ActiveTime = data.Duration or GetActiveTime(data.Text)
end

function MessageEvent:didMount()
	self.Motor:start()
	self.Motor:setGoal(
		Otter.spring(1, {
			frequency = 6,
			dampingRatio = 1.2
		})
	)

	local initTime = tick()
	self.RenderListener = RunService.RenderStepped:Connect(function()
		local timeRemaining = self.ActiveTime - math.clamp(tick() - initTime, 0, self.ActiveTime)

		if timeRemaining == 0 and self.props.Active then
			self:close()
			self.RenderListener:Disconnect()
		end

		self.SetTimeRemaining(timeRemaining)
	end)
end

function MessageEvent:close()
	self.Motor:setGoal(
		Otter.spring(0, {
			frequency = 4,
			dampingRatio = 0.75
		})
	)

	self.Motor:onComplete(function()
		self.Motor:stop()
		self.props.Destroy()
	end)
end

function MessageEvent:didUpdate(lastProps)
	if self.props.Active ~= lastProps.Active and not self.props.Active then
		self:close()
	end
end

function MessageEvent:willUnmount()
	self.Motor:destroy()
	if self.RenderListener then
		self.RenderListener:Disconnect()
	end
end

function MessageEvent:render()
	local data = self.props.Data

	local textBounds = TextService:GetTextSize(
		data.Text, 26, Enum.Font.Gotham,
		Vector2.new(TEXT_MAX_WIDTH, math.huge)
	)
	local lineCount = textBounds.Y / 26
	textBounds = textBounds + Vector2.new(0, (26 * 0.2) * (lineCount - 1))

	local transparency = RoactOtter.getBinding(self.Motor):map(function(value)
		return 1 - value
	end)

	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = transparency:map(function(value)
			return Utility.Math.Lerp(0.5, 1, value)
		end),

		Size = UDim2.new(1, 0, 1, 0),

		LayoutOrder = 1,
		BorderSizePixel = 0
	}, {
		Content = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = transparency:map(function(value)
				return Utility.Math.Lerp(0.5, 1, value)
			end),

			Size = UDim2.new(0, TEXT_MAX_WIDTH + CONTENT_PADDING.X * 2, 0, textBounds.Y + CONTENT_PADDING.Y * 2),

			BorderSizePixel = 0
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = data.Text,
				Font = Enum.Font.Gotham,
				TextSize = 26,
				LineHeight = 1.2,
				TextColor3 = Color3.new(1, 1, 1),
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				
				Size = UDim2.new(1, 0, 1, 0),

				BackgroundTransparency = 1
			}),

			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			}),

			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, CONTENT_PADDING.X),
				PaddingRight = UDim.new(0, CONTENT_PADDING.X),
				PaddingTop = UDim.new(0, CONTENT_PADDING.Y),
				PaddingBottom = UDim.new(0, CONTENT_PADDING.Y)
			})
		}),

		Footer = Roact.createElement("Frame", {
			Size = UDim2.new(0, TEXT_MAX_WIDTH + CONTENT_PADDING.X * 2, 0, 44),
			BackgroundTransparency = 1
		}, {
			Author = data.Author and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			}, {
				Avatar = Roact.createElement("Frame", {
					Size = UDim2.new(0, 44, 0, 44),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				}, {
					Image = Roact.createElement(VectorClip, {
						Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(data.Author.Player.UserId),
						ImageTransparency = transparency,
						Shape = "Circle",

						Size = UDim2.new(1, 0, 1, 0)
					}),
					
					Background = Roact.createElement("ImageLabel", {
						Image = "rbxassetid://2600845734",
						ImageColor3 = Color3.new(0, 0, 0),
						ImageTransparency = transparency:map(function(value)
							return Utility.Math.Lerp(0.7, 1, value)
						end),

						Size = UDim2.new(1, 0, 1, 0),

						ZIndex = 0,
						BackgroundTransparency = 1
					})
				}),

				Details = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					LayoutOrder = 2,
					BackgroundTransparency = 1
				}, {
					Name = Roact.createElement("TextLabel", {
						Text = data.Author.Player.Name,
						Font = Enum.Font.GothamBold,
						TextSize = 18,
						TextColor3 = Color3.new(1, 1, 1),
						TextTransparency = transparency,
						TextXAlignment = Enum.TextXAlignment.Left,

						Size = UDim2.new(1, 0, 0, 18),
						
						LayoutOrder = 1,
						BackgroundTransparency = 1
					}),

					Role = Roact.createElement("TextLabel", {
						Text = data.Author.Role,
						Font = Enum.Font.Gotham,
						TextSize = 14,
						TextColor3 = Color3.new(1, 1, 1),
						TextTransparency = transparency,
						TextXAlignment = Enum.TextXAlignment.Left,

						Size = UDim2.new(1, 0, 0, 14),
						
						LayoutOrder = 2,
						BackgroundTransparency = 1
					}),

					Layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})
				}),

				Layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15)
				})
			}),

			Timer = Roact.createElement("Frame", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),

				BackgroundTransparency = 1
			}, {
				Text = Roact.createElement("TextLabel", {
					Text = self.TimeRemaining:map(math.ceil),
					Font = Enum.Font.GothamBold,
					TextSize = 14,
					TextColor3 = Color3.new(1, 1, 1),
					TextTransparency = transparency,
					TextXAlignment = Enum.TextXAlignment.Right,

					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, -8, 0, 0),
					AnchorPoint = Vector2.new(1, 0),

					BackgroundTransparency = 1
				}),

				Progress = Roact.createElement(RadialProgress, {
					Image = "rbxassetid://5409990484",
					ImageTransparency = value,
					ImageSize = Vector2.new(36, 36),

					Size = UDim2.new(1, 0, 1, 0),

					Value = self.TimeRemaining:map(function(value)
						return value / self.ActiveTime
					end)
				}),

				Background = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://5409990484",
					ImageTransparency = transparency:map(function(value)
						return Utility.Math.Lerp(0.7, 1, value)
					end),

					Size = UDim2.new(1, 0, 1, 0),

					ZIndex = 0,
					BackgroundTransparency = 1
				})
			})
		}),

		LightingEffects = Roact.createElement(Roact.Portal, {
			target = Lighting
		}, {
			Blur = Roact.createElement("BlurEffect", {
				Size = RoactOtter.getBinding(self.Motor):map(function(value)
					return Utility.Math.Lerp(0, 24, value)
				end)
			})
		}),

		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20)
		})
	})
end

return MessageEvent