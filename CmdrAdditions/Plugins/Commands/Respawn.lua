local RespawnCommand = {
	Id = "Respawn",
	Aliases = { "loadcharacter" },
	Description = "Respawns players' characters.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to respawn"
		}
	}
}

function RespawnCommand.RunServer(_, players)
	for _, player in pairs(players) do
		coroutine.wrap(function()
			player:LoadCharacter()
		end)()
	end

	return ("Respawned %d player(s)."):format(#players)
end

return RespawnCommand