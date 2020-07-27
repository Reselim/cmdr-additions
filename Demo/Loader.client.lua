local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
local CmdrAdditions = require(ReplicatedStorage:WaitForChild("CmdrAdditions"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))

Cmdr:SetPlaceName("cmdr-additions")
Cmdr:SetActivationKeys({ Enum.KeyCode.Semicolon })
CmdrAdditions.new(Config):Register(Cmdr)