client = nil
cPcall = nil
Pcall = nil
Routine = nil
service = nil
gTable = nil

--// All global vars will be wiped/replaced except script

return function(data)
	local playergui = service.PlayerGui
	local localplayer = service.Players.LocalPlayer
	local scr = client.UI.Prepare(script.Parent.Parent)
	local main = scr.Main
	local t1 = main.Title
	local t2 = main.Message
	local msg = data.Message
	local color = data.Color

	local found = client.UI.Get("Output")
	if found then
		for i,v in pairs(found) do
			local p = v.Object
			if p and p.Parent then
				p.Main.Position = UDim2.new(0, 0, 0.35, p.Main.Position.Y.Offset+50)
			end
		end
	end

	t2.Text = msg
	t2.Font = "SourceSans"
	--t2.Position = UDim2.new(0, 0, 0.35, 0)
	main.Size = UDim2.new(1, 0, 0, 0)
	gTable.Ready()
	main:TweenSize(UDim2.new(1, 0, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1)
	wait(5)
	gTable.Destroy()
end