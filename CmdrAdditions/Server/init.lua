local Shared = script:FindFirstAncestor("CmdrAdditions").Shared

local Base = require(Shared.Base)
local Permissions = require(script.Permissions)
local Network = require(script.Network)

local CmdrAdditionsServer = setmetatable({}, Base)
CmdrAdditionsServer.__index = CmdrAdditionsServer

function CmdrAdditionsServer.new(...)
	local self = setmetatable(Base.new(...), CmdrAdditionsServer)

	self.Network = Network.new(self)
	self.Permissions = Permissions.new(self)

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
end

return CmdrAdditionsServer