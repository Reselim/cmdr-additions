local ForcefieldCommand = {
	Id = "Forcefield",
	Aliases = { "ff" },
	Description = "Gives players a forcefield.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to give a forcefield to"
		}
	}
}

function ForcefieldCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local forcefield = Instance.new("ForceField")
			forcefield.Parent = character
		end
	end

	return ("Assigned a forcefield to %d player(s)."):format(#players)
end

return ForcefieldCommand