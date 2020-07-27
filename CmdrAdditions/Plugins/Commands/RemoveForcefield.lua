local RemoveForcefieldCommand = {
	Id = "RemoveForcefield",
	Aliases = { "unff", "unforcefield" },
	Description = "Removes all forcefields that are on players' characters.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to remove forcefields from"
		}
	}
}

function RemoveForcefieldCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			for _, child in pairs(character:GetChildren()) do
				if child.ClassName == "ForceField" then
					child:Destroy()
				end
			end
		end
	end

	return ("Removed all forcefields on %d players."):format(#players)
end

return RemoveForcefieldCommand