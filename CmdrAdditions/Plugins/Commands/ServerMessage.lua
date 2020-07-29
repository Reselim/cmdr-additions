local Players = game:GetService("Players")
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
	local filterResult = TextService:FilterStringAsync(message, context.Executor.UserId, Enum.TextFilterContext.PublicChat)

	for _, player in pairs(Players:GetChildren()) do
		coroutine.wrap(function()
			local filteredMessage = filterResult:GetNonChatStringForUserAsync(player.UserId)
			
			context:SendEvent(player, "ShowGlobalMessage", {
				Content = filteredMessage
			})
		end)()
	end

	return "Sent message."
end

return ServerMessageCommand