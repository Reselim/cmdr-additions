local JumpCommand = {
	Id = "Jump",
	Aliases = { "unstun", "unplatformstand" },
	Description = "Makes players jump; also sets PlatformStand to false.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to make jump"
		}
	}
}

function JumpCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = false
				humanoid.Jump = true
			end
		end
	end

	return ("Made %d player(s) jump."):format(#players)
end

return JumpCommand