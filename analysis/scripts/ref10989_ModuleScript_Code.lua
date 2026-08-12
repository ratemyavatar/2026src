client = nil
cPcall = nil
Pcall = nil
Routine = nil
service = nil
gTable = nil

--// All global vars will be wiped/replaced except script

return function(data)
	local playergui = service.PlayerGui
	local gui = client.UI.Prepare(script.Parent.Parent)
	local label = gui.LABEL
	local str = data.Message
	local topbar = client.UI.Get("TopBar")
	
	client.UI.Remove("Notif",script.Parent.Parent)
	
	if str and type(str)=="string" then
		label.Text = str
		label.Position = UDim2.new(0, 0, 0, ((topbar and 40) or 0) - 35)
		gTable:Ready()
	else
		gui:Destroy()
	end
end