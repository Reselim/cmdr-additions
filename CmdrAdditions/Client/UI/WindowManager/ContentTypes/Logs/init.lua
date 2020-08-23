local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local LogsContent = Roact.PureComponent:extend("LogsContent")

function LogsContent:init()
	self.Listener = self.props.Stream:Connect(function(event)
		print(event.Player.Name, event.Text)
	end)
end

function LogsContent:willUnmount()

end

function LogsContent:render()
	
end

return LogsContent