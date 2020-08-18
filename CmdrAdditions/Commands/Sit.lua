local SitComamnd = {
	Id = "Sit",
	Aliases = {},
	Description = "Makes players sit.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to sit down"
		}
	}
}

function SitComamnd.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Sit = true
			end
		end
	end

	return ("Sat %d player(s) down."):format(#players)
end

return SitComamnd