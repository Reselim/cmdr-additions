local TeleportCommand = {
	Id = "Teleport",
	Aliases = { "tp" },
	Description = "Teleports players to a player.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to teleport"
		},

		{
			Type = "player",
			Name = "Target player",
			Description = "The player to teleport to"
		}
	}
}

function TeleportCommand.RunServer(_, players, targetPlayer)
	local targetCharacter = targetPlayer.Character

	if not targetCharacter then
		return ("%s doesn't have a character!"):format(targetPlayer.Name)
	end

	local targetPosition = targetCharacter:GetPrimaryPartCFrame().Position

	for _, player in pairs(players) do
		local character = player.Character
		if character then
			character:MoveTo(targetPosition)
		end
	end

	return ("Teleported %d player(s) to %s."):format(#players, targetPlayer.Name)
end

return TeleportCommand