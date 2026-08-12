local TweenService = game:GetService("TweenService")
local Image = script.Parent

while true do
	local Tween = TweenService:Create(Image, TweenInfo.new(2,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Rotation = Image.Rotation + 360})
	Tween:Play()
	Tween.Completed:Wait()
	Image.Rotation = Image.Rotation % 360
end