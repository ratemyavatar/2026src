local TagConfig = {
	-- fallback
	DefaultFont = Enum.Font.SourceSans,
	DefaultColor = Color3.fromRGB(255, 255, 255),

	--["music"] = {
	--	text = "♪♫ ",
	--	animated = true,
	--	animationStyle = "Wave",
	--	speed = 1,
	--	gradientColors = ColorSequence.new({
	--		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	--		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 160, 255)),
	--		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	--	}),
	--},

	--["love"] = {
	--	text = "<3 ",
	--	animated = true,
	--	animationStyle = "Spin",
	--	speed = 0.6,
	--	gradientColors = ColorSequence.new({
	--		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 220)),
	--		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 160)),
	--		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 220)),
	--	}),
	--},

	--["colossal"] = {
	--	text = "[Colossal] ",
	--	font = Enum.Font.Fondamento,
	--	animated = true,
	--	animationStyle = "Spin",
	--	speed = 1,
	--	gradientColors = ColorSequence.new({
	--		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	--		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
	--		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
	--		ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
	--		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
	--	}),
	--},

	--["ice"] = {
	--	text = "[Ice] ",
	--	animated = false,
	--	gradientRotation = 90,
	--	gradientColors = ColorSequence.new({
	--		ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 240, 255)),
	--		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)),
	--		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 240, 255)),
	--	}),
	--},

	--["ghost"] = {
	--	text = "",
	--	animated = true,
	--	animationStyle = "Breath",
	--	speed = 0.8,
	--	textColor = Color3.fromRGB(200, 220, 255),
	--	breathDim = Color3.fromRGB(30, 35, 50),
	--},

	--["bounce"] = {
	--	text = "",
	--	animated = true,
	--	animationStyle = "Bounce",
	--	speed = 0.5,
	--	gradientColors = ColorSequence.new({
	--		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
	--		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	--	}),
	--},

	["verified"] = {
		text = utf8.char(0xE000) .. " ",
		animated = false,
		animationStyle = "Wave",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	},

	["premium"] = {
		text = utf8.char(0xE001) .. " ",
		animated = false,
		animationStyle = "Wave",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	},

	["robux"] = {
		text = utf8.char(0xE002) .. " ",
		animated = false,
		animationStyle = "Wave",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	},

	["plus"] = {
		text = utf8.char(0xE003) .. " ",
		animated = false,
		animationStyle = "Wave",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	},

	["owner"] = {
		text = "[Owner] ",
		animated = true,
		animationStyle = "Spin",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0)),
		}),
		users = {49603, 78857, 181869},
	},

	["developer"] = {
		text = "[Developer] ",
		animated = true,
		animationStyle = "Spin",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 127)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 127)),
		}),
		users = {14159, 18205},
	},

	["admin"] = {
		text = "[Admin] ",
		animated = true,
		animationStyle = "Shimmer",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 127)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 127)),
		}),
	},

	["mod"] = {
		text = "[Mod] ",
		animated = true,
		animationStyle = "Shimmer",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 255)),
		}),
	},

	["test"] = {
		text = utf8.char(0xE005) .. " ",
		animated = false,
		animationStyle = "Wave",
		speed = 1,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	},
}

return TagConfig