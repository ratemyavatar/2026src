wait()
local mode = script.Mode.Value--"Teleport"
local name = script.Target.Value
local localplayer = game.Players.LocalPlayer
local mouse = localplayer:GetMouse()
local tool = script.Parent
local use = false
local holding = false
local target = game.Players:WaitForChild(name)
local char = target.Character
local hum = char:FindFirstChild('Humanoid')
if not hum then tool:Destroy() end

hum.Died:Connect(function() tool:Destroy() end)
tool.Name = mode..' '..target.Name

function onButton1Down(mouse)
  if not target.Character or not target.Character:FindFirstChild('Humanoid') then return end
  if mode=='Teleport' then
    local torso=target.Character:FindFirstChild('HumanoidRootPart')
    if not torso then return end
    local pos=mouse.Hit.p
    torso.CFrame=CFrame.new(Vector3.new(pos.x, pos.y + 4, pos.z))
  elseif mode=='Walk' then
    hum:MoveTo(mouse.Hit.p)
  end
end

function rotate()
  local char=target.Character
  local torso=char:FindFirstChild('HumanoidRootPart')
  if not torso then return end
  repeat
    torso.CFrame=CFrame.new(torso.Position,Vector3.new(mouse.Hit.p.X,torso.Position.Y,mouse.Hit.p.Z))
    wait()
  until not holding or not use
end

mouse.KeyDown:Connect(function(key)
if key:lower()=='r' and use then
  rotate()
end
if key:lower()=='x' then
  tool:Destroy()
end
end)

mouse.KeyUp:Connect(function(key)
if key:lower()=='r' then
  holding = false
end
end)

function onEquipped(mouse)
  use = true
  mouse.Icon = "rbxasset://textures\\ArrowCursor.png"
  mouse.Button1Down:Connect(function() onButton1Down(mouse) end)
end

game:service("UserInputService").InputBegan:Connect(function(InputObject,gpe)
if  InputObject.UserInputType == Enum.UserInputType.Keyboard and not gpe then
  if InputObject.KeyCode == Enum.KeyCode.R then
    holding = true
    rotate()
  elseif InputObject.KeyCode == Enum.KeyCode.X then
    tool:Destroy()
  end
end
end)

game:service("UserInputService").InputEnded:Connect(function(InputObject)
if  InputObject.UserInputType == Enum.UserInputType.Keyboard then
  if InputObject.KeyCode == Enum.KeyCode.R then
    holding = false
  end
end
end)

tool.Equipped:Connect(onEquipped)
tool.Unequipped:Connect(function() use=false holding=false end)