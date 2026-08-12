-- // server location
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GEO_URL = "https://ipapi.co/json/"

local LocationFunction = ReplicatedStorage:FindFirstChild("GetServerLocation")
if not LocationFunction then
	LocationFunction = Instance.new("RemoteFunction")
	LocationFunction.Name = "GetServerLocation"
	LocationFunction.Parent = ReplicatedStorage
end

local CachedLocation = "Unknown"

local function FetchServerLocation()
	local ok, result = pcall(function()
		return HttpService:GetAsync(GEO_URL)
	end)

	if not ok then
		warn("[ServerLocation] Could not reach the geolocation API: " .. tostring(result))
		return
	end

	local decodeOk, data = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if not decodeOk or type(data) ~= "table" then
		warn("[ServerLocation] Could not read the geolocation reply.")
		return
	end

	local country = data.country_name
	local region = data.region

	if type(region) == "string" and region ~= "" and type(country) == "string" then
		CachedLocation = region .. ", " .. country
	elseif type(country) == "string" then
		CachedLocation = country
	end
end

spawn(FetchServerLocation)

LocationFunction.OnServerInvoke = function(_Player)
	return CachedLocation
end