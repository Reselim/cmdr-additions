local TextService = game:GetService("TextService")

local MessageCommand = {
	Id = "Message",
	Aliases = { "m" },
	Description = "Shows a message that covers all players' screens.",
	Args = {
		{
			Type = "string",
			Name = "Message",
			Description = "The message to show"
		}
	}
}

function MessageCommand.RunServer(context, message)
	local author = context.Executor

	context:BroadcastEvent("ShowGlobalMessage", {
		Text = message,
		Author = {
			Player = author,
			Role = "todo"
		}
	})
end

return MessageCommand