local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local ToCommand = {
	Id = "To",
	Aliases = { "goto" },
	Description = "Teleports you to a player.",
	Args = {
		{
			Type = "player",
			Name = "Target player",
			Description = "The player to teleport to"
		}
	}
}

function ToCommand.RunClient(_, targetPlayer)
	local localCharacter = LocalPlayer.Character
	local targetCharacter = targetPlayer.Character

	if localCharacter and targetCharacter then
		local targetPosition = targetCharacter:GetPrimaryPartCFrame().Position
		localCharacter:MoveTo(targetPosition)
		return ("Successfully teleported you to %s."):format(targetPlayer.Name)
	else
		return "Either you or the target player does not have a character!"
	end
end

return ToCommand