local TextService = game:GetService("TextService")

local ServerMessageCommand = {
	Id = "ServerMessage",
	Aliases = { "sm" },
	Description = "Like the \"message\" command, but without author details.",
	Args = {
		{
			Type = "string",
			Name = "Message",
			Description = "The message to show"
		}
	}
}

function ServerMessageCommand.RunServer(context, message)
	context:BroadcastEvent("ShowGlobalMessage", {
		Text = message
	})
end

return ServerMessageCommand