local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local CmdrContext = Roact.createContext("Cmdr")

return CmdrContext