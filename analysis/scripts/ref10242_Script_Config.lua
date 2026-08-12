--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Settings
local maxvolume = 1


















-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create or get the "SoundPlayEvent"
local soundPlayEvent = ReplicatedStorage:FindFirstChild("SoundPlayEvent") or Instance.new("RemoteEvent")
soundPlayEvent.Name = "SoundPlayEvent"
soundPlayEvent.Parent = ReplicatedStorage

local increaseVolEvent = ReplicatedStorage:FindFirstChild("IncreaseVol") or Instance.new("RemoteEvent")
increaseVolEvent.Name = "IncreaseVol"
increaseVolEvent.Parent = ReplicatedStorage

local decreaseVolEvent = ReplicatedStorage:FindFirstChild("DecreaseVol") or Instance.new("RemoteEvent")
decreaseVolEvent.Name = "DecreaseVol"
decreaseVolEvent.Parent = ReplicatedStorage

-- Create or get the "Looped" event
local loopedEvent = ReplicatedStorage:FindFirstChild("Looped") or Instance.new("RemoteEvent")
loopedEvent.Name = "Looped"
loopedEvent.Parent = ReplicatedStorage

-- Create or get the "Preset" event
local presetEvent = ReplicatedStorage:FindFirstChild("Preset") or Instance.new("RemoteEvent")
presetEvent.Name = "Preset"
presetEvent.Parent = ReplicatedStorage

-- Create or get the "Pause" event
local pauseEvent = ReplicatedStorage:FindFirstChild("Pause") or Instance.new("RemoteEvent")
pauseEvent.Name = "Pause"
pauseEvent.Parent = ReplicatedStorage

-- Create or get the "PlaySong" event
local playSongEvent = ReplicatedStorage:FindFirstChild("PlaySong") or Instance.new("RemoteEvent")
playSongEvent.Name = "PlaySong"
playSongEvent.Parent = ReplicatedStorage

-- References to the music player and sound object
local musicPlayer = workspace:WaitForChild("MusicPlayer")
local speaker = musicPlayer:WaitForChild("Speaker")
local soundObject = speaker:WaitForChild("Sound"):WaitForChild("Song")

-- Function to play the sound with the given sound ID
local function playSound(player, soundId)
	if soundObject then
		soundObject.SoundId = "rbxassetid://" .. soundId
		soundObject:Play()
	else
		warn("Sound object not found!")
	end
end

-- Function to handle volume increase
local function increaseVolume(player)
	if soundObject then
		local currentVolume = soundObject.Volume
		local newVolume = math.min(currentVolume + 0.1, maxvolume)  -- Increase by 0.1, but cap at 1
		soundObject.Volume = newVolume
		print(player.Name .. " increased the volume to " .. newVolume)
	else
		warn("Sound object not found!")
	end
end

-- Function to handle volume decrease
local function decreaseVolume(player)
	if soundObject then
		local currentVolume = soundObject.Volume
		local newVolume = math.max(currentVolume - 0.1, 0)  -- Decrease by 0.1, but cap at 0
		soundObject.Volume = newVolume
		print(player.Name .. " decreased the volume to " .. newVolume)
	else
		warn("Sound object not found!")
	end
end

-- Function to toggle the "Looped" property of the sound
local function toggleLooped(player)
	if soundObject then
		soundObject.Looped = not soundObject.Looped
		print("Sound looping is now", soundObject.Looped and "enabled." or "disabled.")
		-- Notify all clients of the new looped state
		loopedEvent:FireAllClients(soundObject.Looped)
	else
		warn("Sound object not found!")
	end
end

-- Function to toggle pause state
local function togglePause(player)
	if soundObject then
		if soundObject.IsPaused then
			soundObject:Resume()
		else
			soundObject:Pause()
		end
		print("Sound is now", soundObject.IsPaused and "paused." or "playing.")
	else
		warn("Sound object not found!")
	end
end

-- Function to play the song (resume if already playing)
local function playSong(player)
	if soundObject then
		-- If the sound is paused, resume it; otherwise, play it from the start
		if soundObject.IsPaused then
			soundObject:Resume()
			print("Song resumed by", player.Name)
		elseif not soundObject.IsPlaying then
			print("Song started by", player.Name)
		else
			print("Song is already playing.")
		end
	else
		warn("Sound object not found!")
	end
end

-- Listen for the "SoundPlayEvent" from the client
soundPlayEvent.OnServerEvent:Connect(function(player, soundId)
	playSound(player, soundId)
end)

-- Listen for the "Looped" event from the client
loopedEvent.OnServerEvent:Connect(function(player)
	toggleLooped(player)
end)

-- Listen for the "Preset" event from the client
presetEvent.OnServerEvent:Connect(function(player, songId)
	playSound(player, songId)
end)

-- Listen for the "Pause" event from the client
pauseEvent.OnServerEvent:Connect(function(player)
	togglePause(player)
end)

-- Listen for the "PlaySong" event from the client
playSongEvent.OnServerEvent:Connect(function(player)
	playSong(player)
end)

-- Listen for the "IncreaseVol" event from the client
increaseVolEvent.OnServerEvent:Connect(function(player)
	increaseVolume(player)
end)

-- Listen for the "DecreaseVol" event from the client
decreaseVolEvent.OnServerEvent:Connect(function(player)
	decreaseVolume(player)
end)