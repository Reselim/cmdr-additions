local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")

local SetGravityModifierCommand = {
	Id = "SetGravityModifier",
	Aliases = { "setgrav", "grav" },
	Description = "Sets characters' gravity compared to the global gravity.",
	Args = {
		{
			Type = "players",
			Name = "Players",
			Description = "The players to change gravity for"
		},

		{
			Type = "number",
			Name = "Gravity modifier",
			Description = "The ratio of character gravity to global gravity; 0 for no gravity, 1 for default"
		}
	}
}

function SetGravityModifierCommand.RunServer(_, players, gravityModifier)
	local massModifier = gravityModifier - 1

	for _, player in pairs(players) do
		local character = player.Character
		if character then
			-- Remove existing BodyForces
			for _, object in pairs(character:GetDescendants()) do
				if object.ClassName == "BodyForce" and CollectionService:HasTag(object, "CmdrAdditions") then
					object:Destroy()
				end
			end

			if gravityModifier ~= 1 then
				-- Add new BodyForces
				for _, object in pairs(character:GetDescendants()) do
					if object:IsA("BasePart") and not object.Massless then
						local bodyForce = Instance.new("BodyForce")
						bodyForce.Force = Vector3.new(0, -object:GetMass() * Workspace.Gravity * massModifier, 0)
						bodyForce.Parent = object
						CollectionService:AddTag(bodyForce, "CmdrAdditions")
					end
				end
			end
		end
	end

	return ("Set the gravity modifier of %d player(s) to %.1f"):format(#players, gravityModifier)
end

return SetGravityModifierCommand