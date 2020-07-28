local StunCommand = {
	Id = "Stun",
	Aliases = { "platformstand" },
	Description = "Stuns players by setting PlatformStand on their humanoids to true.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to stun"
		}
	}
}

function StunCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
			end
		end
	end

	return ("Stunned %d player(s)."):format(#players)
end

return StunCommand