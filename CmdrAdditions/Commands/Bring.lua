local BringCommand = {
	Id = "Bring",
	Aliases = {},
	Description = "Teleports players to you.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to bring"
		}
	}
}

function BringCommand.RunServer(context, players)
	local targetCharacter = context.Executor.Character

	if not targetCharacter then
		return "You don't have a character!"
	end

	local targetPosition = targetCharacter:GetPrimaryPartCFrame().Position

	for _, player in pairs(players) do
		local character = player.Character
		if character then
			character:MoveTo(targetPosition)
		end
	end

	return ("Teleported %d player(s) to you."):format(#players)
end

return BringCommand