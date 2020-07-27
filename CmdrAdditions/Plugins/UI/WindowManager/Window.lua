local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)
local Otter = require(Packages.Otter)
local RoactOtter = require(Packages.RoactOtter)

local Window = Roact.PureComponent:extend("Window")

function Window:init()

end

function Window:render()
	
end

return Window