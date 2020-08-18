local HintCommand = {
	Id = "Hint",
	Aliases = { "h" },
	Description = "Shows a message at the top of all players' screens.",
	Args = {
		{
			Type = "string",
			Name = "Content",
			Description = "The content of the message to show"
		}
	}
}

function HintCommand.RunServer(context, content)
	context:BroadcastEvent("ShowHint", {
		Content = content,
		Author = context.Executor.Name
	})

	return "Sent hint."
end

return HintCommand