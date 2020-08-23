local UntrackCommand = {
	Id = "Untrack",
	Aliases = { "untrace" },
	Description = "Removes tracking UI elements placed on players.",
	Args = {
		{
			Type = "players",
			Name = "Players"
		}
	}
}

function UntrackCommand.RunClient(context, players)

end

return UntrackCommand