local UptimeCommand = {
	Id = "Uptime",
	Aliases = {},
	Description = "Shows how long the server has been up for.",
	Args = {}
}

function UptimeCommand.RunServer()
	local uptime = time()

	return ("%dh %dm %ds"):format(
		math.floor(uptime / (60 * 60)),
		math.floor(uptime / 60) % 60,
		math.floor(uptime) % 60
	)
end

return UptimeCommand