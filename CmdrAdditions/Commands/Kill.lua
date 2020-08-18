local KillCommand = {
	Id = "Kill",
	Aliases = {},
	Description = "Kills players by running BreakJoints on their character.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to kill"
		}
	}
}

function KillCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if player.Character then
			character:BreakJoints()
		end
	end

	return ("Killed %d player(s)."):format(#players)
end

return KillCommand