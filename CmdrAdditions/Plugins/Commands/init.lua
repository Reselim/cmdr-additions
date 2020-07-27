local RunService = game:GetService("RunService")

local CommandsPlugin = {}
CommandsPlugin.__index = CommandsPlugin

function CommandsPlugin.new(cmdrAdditions)
	local self = setmetatable({
		CmdrAdditions = cmdrAdditions,
		Commands = {}
	}, CommandsPlugin)

	for _, commandModule in pairs(script:GetChildren()) do
		local command = require(commandModule)
		self.Commands[commandModule.Name] = command
	end

	return self
end

function CommandsPlugin:Register(cmdr)
	for _, command in pairs(self.Commands) do
		cmdr.Registry:RegisterCommandObject({
			Name = command.Id:lower(),
			Aliases = command.Aliases,
			Description = command.Description,
			Group = "CmdrAdditions",
			Args = command.Args,
			Run = RunService:IsServer() and command.RunServer or command.RunClient
		}, true)
	end
end

return CommandsPlugin