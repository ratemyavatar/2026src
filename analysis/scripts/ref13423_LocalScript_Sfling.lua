wait()
local cam = workspace.CurrentCamera
local torso = script.Parent
local hum = torso.Parent.Humanoid
local strength = script.Strength.Value
for i=1,100 do
  wait(0.1)
  hum.Sit = true
  local ex = Instance.new("Explosion",cam)
  ex.Position = torso.Position+Vector3.new(math.random(-5,5),-10,math.random(-5,5))
  ex.BlastRadius = 35;
  ex.BlastPressure = strength;
  ex.ExplosionType = Enum.ExplosionType.CratersAndDebris;
  ex.DestroyJointRadiusPercent = 0
end
script:Destroy()