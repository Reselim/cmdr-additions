local SetJumpPowerCommand = {
	Id = "SetJumpPower",
	Aliases = { "jumppower", "jp" },
	Description = "Updates the JumpPower property on players' humanoids.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to update"
		},

		{
			Type = "number",
			Name = "Jump power"
		}
	}
}

function SetJumpPowerCommand.RunServer(_, players, jumpPower)
	for _, player in pairs(players) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.JumpPower = jumpPower
			end
		end
	end

	return ("Set %d player(s) jump power to %d."):format(#players, jumpPower)
end

return SetJumpPowerCommand