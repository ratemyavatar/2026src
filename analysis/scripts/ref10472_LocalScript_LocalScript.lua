local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local remote = ReplicatedStorage:WaitForChild("PromptGroupJoin")
local gui = script.Parent
local prompt = gui:WaitForChild("Prompt")
local link = gui:WaitForChild("Link")
local center = gui:WaitForChild("Centerpoint")
local accept = prompt:WaitForChild("Accept")
local decline = prompt:WaitForChild("Decline")
local textbox = link:WaitForChild("link")
local close = link:WaitForChild("Close")
local GROUP_LINK = "https://www.pekora.zip/groups/9094/Rate-My-Avatar-Korone"

textbox.Text = GROUP_LINK
textbox.ClearTextOnFocus = false
pcall(function()
	textbox.TextEditable = false
end)

local tweenInfo = TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local openPosition = center.Position
local closedPosition = UDim2.new(openPosition.X.Scale, openPosition.X.Offset, -1, 0)

prompt.Position = closedPosition
link.Position = closedPosition
prompt.Visible = false
link.Visible = false

local busy = false
local function tween(object, position)
	local t = TweenService:Create(object, tweenInfo, {Position = position})
	t:Play()
	t.Completed:Wait()
end

remote.OnClientEvent:Connect(function()
	if busy then
		return
	end
	busy = true
	link.Visible = false
	link.Position = closedPosition
	prompt.Visible = true
	prompt.Position = closedPosition
	tween(prompt, openPosition)
end)

accept.MouseButton1Click:Connect(function()
	tween(prompt, closedPosition)
	prompt.Visible = false
	link.Visible = true
	link.Position = closedPosition
	tween(link, openPosition)
	wait()
	if not UserInputService.TouchEnabled then
		textbox:CaptureFocus()
		pcall(function()
			textbox.CursorPosition = 1
			textbox.SelectionStart = #textbox.Text + 1
		end)
	end
end)

decline.MouseButton1Click:Connect(function()
	tween(prompt, closedPosition)
	prompt.Visible = false
	busy = false
end)

close.MouseButton1Click:Connect(function()
	tween(link, closedPosition)
	link.Visible = false
	busy = false
end)