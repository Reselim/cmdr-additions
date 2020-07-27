local Plugins = require(script.Plugins)

local CmdrAdditions = {}
CmdrAdditions.__index = CmdrAdditions

function CmdrAdditions.new(config)
	local self = setmetatable({
		Plugins = {},
		Config = config
	}, CmdrAdditions)

	for pluginName, plugin in pairs(Plugins) do
		self.Plugins[pluginName] = plugin.new(self)
	end

	return self
end

function CmdrAdditions:Register(cmdr)
	cmdr.CmdrAdditions = self
	
	for _, plugin in pairs(self.Plugins) do
		plugin:Register(cmdr)
	end
end

return CmdrAdditions