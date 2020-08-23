local TrackCommand = {
	Id = "Track",
	Aliases = { "trace" },
	Description = "Puts a tracker UI element that follows where the player is on your screen.",
	Args = {
		{
			Type = "players",
			Name = "Players"
		}
	}
}

function TrackCommand.RunClient(context, players)
	
end

return TrackCommand