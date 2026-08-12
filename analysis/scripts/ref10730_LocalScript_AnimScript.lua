wait(1)
local frame=script.Parent
local user=game.Players.LocalPlayer
repeat wait() until user.Character local char=user.Character
local humanoid=char:WaitForChild("Humanoid")
local anim
function playanim(id)
	if char~=nil and humanoid~=nil then
		local id="rbxassetid://"..tostring(id)
		local oldanim=char:FindFirstChild("LocalAnimation")
		if anim~=nil then
			anim:Stop()
		end
		if oldanim~=nil then
			if oldanim.AnimationId==id then
				oldanim:Destroy()
				return
			end
			oldanim:Destroy()
		
		end
		local animation=Instance.new("Animation",char)
		animation.Name="LocalAnimation"
		animation.AnimationId=id
		anim=humanoid:LoadAnimation(animation)
		anim:Play()
	end
end
local b1=frame.bbdance
b1.MouseButton1Down:connect(function() playanim(b1.AnimID.Value) end)
local b2=frame.bored
b2.MouseButton1Down:connect(function() playanim(b2.AnimID.Value) end)
local b3=frame.cower
b3.MouseButton1Down:connect(function() playanim(b3.AnimID.Value) end)
local b4=frame.disco
b4.MouseButton1Down:connect(function() playanim(b4.AnimID.Value) end)
local b5=frame.dizzy
b5.MouseButton1Down:connect(function() playanim(b5.AnimID.Value) end)
local b6=frame.dorky
b6.MouseButton1Down:connect(function() playanim(b6.AnimID.Value) end)
local b7=frame.e
b7.MouseButton1Down:connect(function() playanim(b7.AnimID.Value) end)
local b8=frame.fancyfeet
b8.MouseButton1Down:connect(function() playanim(b8.AnimID.Value) end)
local b9=frame.fashionable
b9.MouseButton1Down:connect(function() playanim(b9.AnimID.Value) end)
local b10=frame.fasthands
b10.MouseButton1Down:connect(function() playanim(b10.AnimID.Value) end)
local b11=frame.godlike
b11.MouseButton1Down:connect(function() playanim(b11.AnimID.Value) end)
local b12=frame.happy
b12.MouseButton1Down:connect(function() playanim(b12.AnimID.Value) end)
local b13=frame.heroland
b13.MouseButton1Down:connect(function() playanim(b13.AnimID.Value) end)
local b16=frame.jw
b16.MouseButton1Down:connect(function() playanim(b16.AnimID.Value) end)
local b17=frame.lined
b17.MouseButton1Down:connect(function() playanim(b17.AnimID.Value) end)
local b18=frame.monkey
b18.MouseButton1Down:connect(function() playanim(b18.AnimID.Value) end)
local b19=frame.noobflex
b19.MouseButton1Down:connect(function() playanim(b19.AnimID.Value) end)
local b20=frame.rock
b20.MouseButton1Down:connect(function() playanim(b20.AnimID.Value) end)
local b21=frame.shuffle
b21.MouseButton1Down:connect(function() playanim(b21.AnimID.Value) end)
local b22=frame.shy
b22.MouseButton1Down:connect(function() playanim(b22.AnimID.Value) end)
local b23=frame.sleep
b23.MouseButton1Down:connect(function() playanim(b23.AnimID.Value) end)
local b24=frame.t
b24.MouseButton1Down:connect(function() playanim(b24.AnimID.Value) end)
local b25=frame.twirl
b25.MouseButton1Down:connect(function() playanim(b25.AnimID.Value) end)