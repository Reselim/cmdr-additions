local Color = {}

function Color.getRelativeLuminance(color3)
	return
		color3.r * 0.2126 +
		color3.g * 0.7152 +
		color3.b * 0.0722
end

function Color.toHex(color3)
	local R = color3.r * 255
	local G = color3.g * 255
	local B = color3.b * 255

	return ("%.2x%.2x%.2x"):format(R, G, B)
end

function Color.fromHex(hex)
	hex = hex:gsub("^#", "")

	local R, G, B = hex:match("(%x%x)(%x%x)(%x%x)")

	R = tonumber(R, 16)
	G = tonumber(G, 16)
	B = tonumber(B, 16)

	return Color3.fromRGB(R, G, B)
end

return Color