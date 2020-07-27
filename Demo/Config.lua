return {
	Groups = {
		-- Make sure these are in order!

		{ Name = "Creator" },
		{ Name = "Admin", AllowHigherGroups = true },
		{ Name = "Mod", AllowHigherGroups = true },
		{ Name = "VIP", AllowHigherGroups = true },
		{ Name = "Default", AllowHigherGroups = true }
	},
	
	GroupGetters = {
		-- Will automatically select the highest permission group returned here.
		-- Returning a promise is supported, but these will always run asynchronously.
		-- These are only ran on the server.

		function(player)
			return ({
				[24346602] = "Creator" -- Reselim
			})[player.UserId]
		end,

		function(player)
			local rank = player:GetRankInGroup(2684849)

			if rank >= 225 then return "Creator" end
			if rank >= 200 then return "Admin" end
			if rank >= 100 then return "VIP" end
		end,

		function()
			-- WARNING: This gives everyone admin by default!
			return "Admin"
		end
	},

	-- Should the permission system be enabled for commands that haven't been registered by cmdr-additions?
	BlockForeignCommands = false,

	DefaultCommandGroup = "Admin",
	CommandGroups = {
		GiveHat = "VIP",
		To = "Default"
	}
}