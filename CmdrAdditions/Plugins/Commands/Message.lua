local Players = game:GetService("Players")
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
	local filterResult = TextService:FilterStringAsync(message, context.Executor.UserId, Enum.TextFilterContext.PublicChat)
	
	local cmdrAdditions = context.Cmdr.CmdrAdditions
	local permissionsPlugin = cmdrAdditions.Plugins.Permissions

	for _, player in pairs(Players:GetChildren()) do
		coroutine.wrap(function()
			local filteredMessage = filterResult:GetNonChatStringForUserAsync(player.UserId)
			
			context:SendEvent(player, "ShowGlobalMessage", {
				Text = filteredMessage,
				Author = {
					Player = context.Executor,
					Role = permissionsPlugin:GetPlayerGroup(context.Executor)
				}
			})
		end)()
	end

	return "Sent message."
end

return MessageCommand