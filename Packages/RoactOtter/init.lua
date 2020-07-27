local Roact = require(script.Parent.Roact)

local AssignedBinding = require(script.AssignedBinding)

local getMotorType = require(script.getMotorType)

local RoactOtter = {}

function RoactOtter.getBinding(motor)
	assert(motor)

	if motor[AssignedBinding] then
		return motor[AssignedBinding]
	end

	local motorType = getMotorType(motor)

	local defaultValue
	if motorType == "Single" then
		defaultValue = motor.__state.value
	elseif motorType == "Group" then
		defaultValue = {}
		for key, state in pairs(motor.__states) do
			defaultValue[key] = state.value
		end
	else
		error("Unknown motor type")
	end

	local binding, setBindingValue = Roact.createBinding(defaultValue)
	motor:onStep(function(value)
		setBindingValue(value)
	end)

	motor[AssignedBinding] = binding
	return binding
end

function RoactOtter.getBindingForProp(motor, prop)
	local motorBinding = RoactOtter.getBinding(motor)
	return motorBinding:map(function(values)
		return values[prop]
	end)
end

return RoactOtter