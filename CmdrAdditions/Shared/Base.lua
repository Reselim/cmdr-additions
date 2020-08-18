local RunService = game:GetService("RunService")

local Commands = script:FindFirstAncestor("CmdrAdditions").Commands

local Base = {}
Base.__index = Base

function Base.new(config)
	return setmetatable({
		Config = config
	}, Base)
end

function Base:SetCmdr(cmdr)
	assert(not self.Cmdr, "SetCmdr can only be called once!")
	self.Cmdr = cmdr
	cmdr.CmdrAdditions = self

	-- Register commands
	for _, commandModule in pairs(Commands:GetChildren()) do
		local command = require(commandModule)

		cmdr.Registry:RegisterCommandObject({
			Name = command.Id:lower(),
			Aliases = command.Aliases,
			Description = command.Description,
			Args = command.Args,

			Group = "CmdrAdditions",
			Run = RunService:IsServer() and command.RunServer
				or RunService:IsClient() and command.RunClient
				or nil
		}, true)
	end

	-- Add CmdrAdditions property to every CommandContext
	cmdr.Registry:RegisterHook("BeforeRun", function(context)
		context.CmdrAdditions = self
	end)
end

return Base