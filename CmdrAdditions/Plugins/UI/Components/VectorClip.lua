local Packages = script:FindFirstAncestor("CmdrAdditions").Packages

local Roact = require(Packages.Roact)

local FIELD_OF_VIEW = 60
local SHAPE_MESHES = {
	Circle = "rbxassetid://2983070105"
}

local VectorClip = Roact.PureComponent:extend("VectorClip")

VectorClip.defaultProps = {
	ClipShape = "Circle"
}

function VectorClip:init()
	self.CameraRef = Roact.createRef()
end

function VectorClip:render()
	local extentsRadius = 1 / 2
	local distanceFromRoot = extentsRadius / math.tan(math.rad(FIELD_OF_VIEW) / 2)
	local cameraCFrame = CFrame.new(0, distanceFromRoot, 0) * CFrame.Angles(-math.pi / 2, 0, math.pi)

	return Roact.createElement("ViewportFrame", {
		CurrentCamera = self.CameraRef,
		ImageTransparency = self.props.ImageTransparency,
		ImageColor3 = self.props.ImageColor3,

		Size = self.props.Size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,

		ZIndex = self.props.ZIndex,
		LayoutOrder = self.props.LayoutOrder,
		BackgroundTransparency = 1
	}, {
		Camera = Roact.createElement("Camera", {
			CFrame = cameraCFrame,
			FieldOfView = FIELD_OF_VIEW,

			[Roact.Ref] = self.CameraRef
		}),

		Part = Roact.createElement("Part", {
			-- Since Roblox ignores transparency in textures on non-transparent meshes, this
			-- is a hack to make sure we aren't forcibly given a background.
			Transparency = 0.011,

			Size = Vector3.new(0, 0, 0),
			CFrame = CFrame.new(0, 0, 0),

			Anchored = true,
			CanCollide = false,
			Locked = true
		}, {
			Mesh = Roact.createElement("SpecialMesh", {
				MeshType = Enum.MeshType.FileMesh,
				MeshId = SHAPE_MESHES[self.props.ClipShape],
				TextureId = self.props.Image
			})
		})
	})
end

return VectorClip