local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local ServerMessageCommand = {
	Id = "ServerMessage",
	Aliases = { "sm" },
	Description = "Like the \"message\" command, but without author details.",
	Args = {
		{
			Type = "string",
			Name = "Content",
			Description = "The content of the message to show"
		}
	}
}

function ServerMessageCommand.RunServer(context, content)
	local filterResult = TextService:FilterStringAsync(content, context.Executor.UserId, Enum.TextFilterContext.PublicChat)

	for _, player in pairs(Players:GetChildren()) do
		coroutine.wrap(function()
			local filteredContent = filterResult:GetNonChatStringForUserAsync(player.UserId)
			
			context:SendEvent(player, "ShowGlobalMessage", {
				Content = filteredContent
			})
		end)()
	end

	return "Sent message."
end

return ServerMessageCommand