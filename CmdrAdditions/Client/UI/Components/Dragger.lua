local UserInputService = game:GetService("UserInputService")

local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)
local Util = require(Packages.Util)

local Dragger = Roact.PureComponent:extend("Dragger")

function Dragger:handleInput(input)
	local userInputType = input.UserInputType

	local isMouse = userInputType == Enum.UserInputType.MouseButton1
	local isTouch = userInputType == Enum.UserInputType.Touch

	if not self.CurrentInput and (isMouse or isTouch) then
		self.CurrentInput = input

		local maid = Util.Maid.new()

		local lastPosition = input.Position
		local function updatePosition(position)
			local deltaPosition = position - lastPosition
			self.props.Move(Vector2.new(deltaPosition.X, deltaPosition.Y))
			lastPosition = position
		end
		
		if isMouse then
			maid:GiveTasks({
				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						updatePosition(input.Position)
					end
				end),

				UserInputService.InputEnded:Connect(function(input)
					if input == self.CurrentInput then
						maid:Clean()
						self.CurrentInput = nil
					end
				end)
			})
		elseif isTouch then
			maid:GiveTasks({
				input:GetPropertyChangedSignal("Position"):Connect(function()
					updatePosition(input.Position)
				end),

				input:GetPropertyChangedSignal("UserInputState", function()
					local userInputState = input.UserInputState
	
					if
						userInputState == Enum.UserInputState.End
						or userInputState == Enum.UserInputState.Cancel
					then
						maid:Clean()
						self.CurrentInput = nil
					end
				end)
			})
		end
	end
end

function Dragger:render()
	return Roact.createElement("Frame", {
		Size = self.props.Size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,

		Active = true,
		BackgroundTransparency = 1,

		[Roact.Event.InputBegan] = function(_, input)
			self:handleInput(input)
		end
	})
end

return Dragger