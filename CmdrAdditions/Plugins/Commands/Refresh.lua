local RefreshCommand = {
	Id = "Refresh",
	Aliases = {},
	Description = "Respawns players' characters, but keeps their old position.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to refresh"
		}
	}
}

function RefreshCommand.RunServer(_, players)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local cframe = character:GetPrimaryPartCFrame()

			coroutine.wrap(function()
				player:LoadCharacter()

				local newCharacter = player.Character
				newCharacter:SetPrimaryPartCFrame(cframe)
			end)()
		end
	end

	return ("Refreshed %d player(s)."):format(#players)
end

return RefreshCommand