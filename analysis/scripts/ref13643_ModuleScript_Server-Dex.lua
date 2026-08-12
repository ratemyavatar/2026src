return function(Vargs)
	local server = Vargs.Server;
	local service = Vargs.Service;

	local dexGui = script.Dex_Explorer;
	local Deps = server.Deps;
	local Core = server.Core;
	local Admin = server.Admin;
	local Process = server.Process;
	local Settings = server.Settings;
	local Functions = server.Functions;
	local Commands = server.Commands;
	local Remote = server.Remote;
	local Logs = server.Logs;

	local Event = nil;

	local Authorized = {}; --// Users who have been given Dex and are authorized to use the remote event

	local function MakeEvent()
		if not Event then
			Event =  service.New("RemoteFunction", {
				Name = "DexEvent";
				Parent = service.ReplicatedStorage;
			})

			Event.OnServerInvoke = (function(Plr, Action, ...)
				local pData = Authorized[Plr];
				if not pData then
					server.Anti.Detected(Plr, "kick", "Unauthorized Dex Event");
				else
					local args = {...};
					local Suppliments = args[1];

					if (Action == "Destroy" or Action == "Delete") and args[1] then
						args[1]:Destroy();
						return true;
					elseif Action == "ClearClipboard" then
						pData.Clipboard = {};
						return true;
					elseif Action == "Duplicate" and args[1] and args[2] then
						local obj = args[1];
						local par = args[2];

						local new = obj:Clone()
						new.Parent = par;

						return new;
					elseif Action == "Copy" and args[1] then
						local obj = args[1];
						local new = obj:Clone();
						table.insert(pData.Clipboard, new)

						return new;
					elseif Action == "Paste" and args[1] then
						local parent = args[1];

						for i,v in pairs(pData.Clipboard) do
							v:Clone().Parent = parent;
						end

						return true;
					elseif Action == "SetProperty" and args[3] then
						local obj = args[1];
						local prop = args[2];
						local value = args[3];

						if obj and prop then
							obj[prop] = value;
							return true;
						end
					elseif Action == "InstanceNew" then
						return service.New(args[1], args[2]);
					end
				end
			end)
		end
	end

	server.Commands.DexExplore = {
		Prefix = Settings.Prefix;
		Commands = {"dex";"dexexplorer";"dexexplorer"};
		Args = {};
		Description = "Lets you explore the game using Dex [Credit to Raspberry Pi/Raspy_Pi/raspymgx/OpenOffset(?)]";
		AdminLevel = 300;
		Function = function(plr,args)
			Authorized[plr] = {
				Clipboard = {};
			}; --// double as per-player explorer-related data

			if not Event then  MakeEvent(); end
			Remote.MakeLocal(plr, dexGui:Clone(), "PlayerGui")
		end
	};

	Logs.AddLog("Script", "Dex Plugin Loaded");
end