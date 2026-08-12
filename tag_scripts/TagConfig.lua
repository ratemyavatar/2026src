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

	-- Owner: yellow, Pulse (breathing colour) so it cannot be mistaken for
	-- Admin red, Head Admin purple or Developer green at a glance.
	["owner"] = {
		text = "[Owner] ",
		animated = true,
		animationStyle = "Pulse",
		speed = 1,
		pulseColorA = Color3.fromRGB(255, 230, 0),
		pulseColorB = Color3.fromRGB(140, 120, 0),
		users = {49603, 78857, 181869},
	},

	-- Developer: green, Breath.
	["developer"] = {
		text = "[Developer] ",
		animated = true,
		animationStyle = "Breath",
		speed = 1,
		textColor = Color3.fromRGB(120, 235, 160),
		breathDim = Color3.fromRGB(30, 80, 40),
		users = {14159, 18205},
	},

	-- Head admin custom tag: purple, Spin. Given via the staff list: put the
	-- head admin in the StaffList_v2 whitelist with Rank 3 (the "Make Head
	-- Admin" command in the admin panel does this for you) and TagHandler
	-- hands out this tag.
	["headadmin"] = {
		text = "[Head Admin] ",
		animated = true,
		animationStyle = "Spin",
		speed = 1,
		textColor = Color3.fromRGB(170, 85, 255),
		chatColor = Color3.fromRGB(170, 85, 255),
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 85, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 85, 255)),
		}),
	},

	-- Admin: red, Shimmer.
	["admin"] = {
		text = "[Admin] ",
		animated = true,
		animationStyle = "Shimmer",
		speed = 1,
		textColor = Color3.fromRGB(255, 70, 70),
		chatColor = Color3.fromRGB(255, 70, 70),
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 70)),
		}),
	},

	-- Mod: cyan, Wave.
	["mod"] = {
		text = "[Mod] ",
		animated = true,
		animationStyle = "Wave",
		speed = 1,
		textColor = Color3.fromRGB(85, 255, 255),
		chatColor = Color3.fromRGB(130, 200, 255),
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 255)),
		}),
	},

	-- thugshaker's custom tag: black text with a white glint sweeping across
	-- it on a diagonal. The "Thug" animation style lives in the client
	-- StarterPlayerScripts/Tags script (also in this folder). The chat tag
	-- keeps the yellow-gold colour so it stays readable on the chat box.
	["thug"] = {
		text = "[Thug] ",
		animated = true,
		animationStyle = "Thug",
		speed = 1.2,
		textColor = Color3.fromRGB(0, 0, 0),
		chatColor = Color3.fromRGB(255, 200, 0),
		gradientRotation = 45,
		gradientColors = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}),
		users = {49603}, -- thugshaker
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
