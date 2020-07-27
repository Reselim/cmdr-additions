local RunService = game:GetService("RunService")

if RunService:IsClient() then
	return require(script.Client)
elseif RunService:IsServer() then
	return require(script.Server)
end