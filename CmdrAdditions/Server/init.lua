local Shared = script:FindFirstAncestor("CmdrAdditions").Shared

local Base = require(Shared.Base)

local Network = require(script.Network)
local Permissions = require(script.Permissions)
local Streams = require(script.Streams)

local CmdrAdditionsServer = setmetatable({}, Base)
CmdrAdditionsServer.__index = CmdrAdditionsServer

function CmdrAdditionsServer.new(...)
	local self = setmetatable(Base.new(...), CmdrAdditionsServer)

	self.Network = Network.new(self)
	self.Permissions = Permissions.new(self)
	self.Streams = Streams.new(self)

	return self
end

function CmdrAdditionsServer:SetCmdr(cmdr)
	Base.SetCmdr(self, cmdr)

	self.Permissions:SetRegistry(cmdr.Registry)

	-- Register permissions hook
	cmdr.Registry:RegisterHook("BeforeRun", function(context)
		if not self.Permissions:CanPlayerRunCommand(context.Executor, context.Name) then
			warn(("[cmdr-additions] %s somehow got past client-side validation for running commands!"):format(context.Executor.Name))
			return false
		end
	end)

	-- Register log stream
	local logStream = self.Streams:GetStream("CommandLogs")
	
	logStream:AddRestrictor(function(player)
		return true--self.Permissions:CanPlayerRunCommand(player, "CommandLogs")
	end)

	cmdr.Registry:RegisterHook("AfterRun", function(context)
		local executor = context.Executor

		logStream:Push({
			Time = os.time(),
			Player = { Name = executor.Name, UserId = executor.UserId },
			Text = context.RawText
		})
	end)
end

return CmdrAdditionsServer