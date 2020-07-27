local Math = {}

Math.E = 2.718281828459
Math.Tau = math.pi * 2

--- Linear intepolation between 2 numbers
-- @param origin Starting point (alpha = 0)
-- @param target Ending point (alpha = 1)
-- @param alpha Progress from origin to target (range [0, 1])
function Math.Lerp(origin, target, alpha)
	return origin + (target - origin) * alpha
end

--- Rounds a number
-- @param number Number to round
-- @param step Increment to round the number to (default: 1)
function Math.Round(number, step)
	step = step or 1
	return math.floor(number / step + 0.5) * step
end

--- Maps a number from one range to another
-- @param number Number to map
-- @param min Minimum of the current range
-- @param max Maximum of the current range
-- @param newMin Minimum of the target range
-- @param newMax Maximum of the target range
function Math.Map(number, min, max, newMin, newMax)
	return (((number - min) * (newMax - newMin)) / (max - min)) + newMin
end

--- Rotates a Vector2 value
-- @param vector Vector2 to be rotated
-- @param angle Amount in radians to rotate the Vector2 by
function Math.Rotate2D(vector, angle)
	local sin = math.sin(angle)
	local cos = math.cos(angle)

	return Vector2.new(
		vector.X * cos + vector.Y * sin,
		-vector.X * sin + vector.Y * cos
	)
end

--- Gets the delta between 2 angles
-- @param origin Starting angle
-- @param target Ending angle
function Math.AngleDelta(origin, target)
	local delta = (target - origin) % Math.Tau

	if delta > math.pi then
		delta = delta - Math.Tau
	end

	return delta
end

--- Multiplicative blending of alpha values
-- @param alphaValues A list of alpha values to blend
-- @param target The alpha value to lerp towards (default: 1)
function Math.BlendMultiply(alphaValues, target)
	local output

	for _, value in pairs(alphaValues) do
		output = output and Math.Lerp(output, target or 1, value) or value
	end

	return output
end

--- Additive blending of alpha values
-- @param alphaValues A list of alpha values to blend
function Math.BlendAdditive(alphaValues)
	local output = 0

	for _, value in pairs(alphaValues) do
		output = output + value
	end

	return output
end

return Math