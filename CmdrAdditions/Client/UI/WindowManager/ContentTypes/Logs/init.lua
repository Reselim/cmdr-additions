local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local LogsContent = Roact.PureComponent:extend("LogsContent")

function LogsContent:render()
	
end

return LogsContent