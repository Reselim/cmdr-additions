local Packages = script:FindFirstAncestor("CmdrAdditions").Packages
local Roact = require(Packages.Roact)

local Window = require(script.Window)

local WindowManager = Roact.Component:extend("WindowManager")

function WindowManager:init()
	
end

function WindowManager:render()

end

return WindowManager