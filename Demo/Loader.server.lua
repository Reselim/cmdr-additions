local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage.Cmdr)
local CmdrAdditions = require(ReplicatedStorage.CmdrAdditions)
local Config = require(ReplicatedStorage.Config)

Cmdr:RegisterDefaultCommands()
CmdrAdditions.new(Config):Register(Cmdr)