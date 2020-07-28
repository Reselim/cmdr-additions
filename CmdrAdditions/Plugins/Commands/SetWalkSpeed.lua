local SetWalkSpeedCommand = {
	Id = "SetWalkSpeed",
	Aliases = { "walkspeed", "ws" },
	Description = "Updates the WalkSpeed property on players' humanoids.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to update"
		},

		{
			Type = "number",
			Name = "Walk speed",
			Description = "Maximum walking speed, measured in studs per second"
		}
	}
}

function SetWalkSpeedCommand.RunServer(_, players, walkSpeed)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = walkSpeed
			end
		end
	end

	return ("Set %d player(s) walk speed to %d."):format(#players, walkSpeed)
end

return SetWalkSpeedCommand