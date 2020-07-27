local RunService = game:GetService("RunService")

local Plugins = {
	Commands = require(script.Commands),
	Permissions = require(script.Permissions)
}

if RunService:IsClient() then
	Plugins.UI = require(script.UI)
end

return Plugins