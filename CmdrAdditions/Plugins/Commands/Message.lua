local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local MessageCommand = {
	Id = "Message",
	Aliases = { "m" },
	Description = "Shows a message that covers all players' screens.",
	Args = {
		{
			Type = "string",
			Name = "Content",
			Description = "The content of the message to show"
		}
	}
}

function MessageCommand.RunServer(context, content)
	local filterResult = TextService:FilterStringAsync(content, context.Executor.UserId, Enum.TextFilterContext.PublicChat)
	
	local cmdrAdditions = context.Cmdr.CmdrAdditions
	local permissionsPlugin = cmdrAdditions.Plugins.Permissions

	for _, player in pairs(Players:GetChildren()) do
		coroutine.wrap(function()
			local filteredContent = filterResult:GetNonChatStringForUserAsync(player.UserId)
			
			context:SendEvent(player, "ShowGlobalMessage", {
				Content = filteredContent,
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