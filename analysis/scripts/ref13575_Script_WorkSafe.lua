local Pcall=function(func,...) local function cour(...) coroutine.resume(coroutine.create(func),...) end local ran,error=pcall(cour,...) if error then print('Error: '..error) end end
local mode=script.Mode.Value

if mode=="AnchorSafe" or mode=="ObjectSafe" then
	function cover(part)
		for i,v in pairs(part:GetChildren()) do
			pcall(cover,v)
		end
		if part==workspace then return end
		if not part:IsA("Terrain") and part.Archivable then
			local anchor=false
			local parent
			local orig
			local pos
			if (part:IsA("Part") or part:IsA("UnionOperation")) and mode=="AnchorSafe" then
				if part.Anchored then			
					anchor=true
					pos=part.Position
					--print("ANCHORE 1")
				end
			elseif mode=="ObjectSafe" then
				parent=part.Parent
				orig=part:Clone()
				--print("DEL ONE")
			end
			local event
			event=part.Changed:Connect(function(p)
				pcall(function()
					if anchor and part and part.Parent and mode=="AnchorSafe" then
						part.Anchored=true
						part.Position=pos
						--print("ANCHOR")
					elseif mode=="ObjectSafe" then
						if part and part.Parent~=parent and part.Parent~=nil then
							part.Parent=parent
						elseif not part or not part.Parent then
							local new=orig:clone()
							new.Parent=workspace
							cover(new)
							event:Disconnect()
						end
						--print("DELETE "..part:GetFullName())
					end
				end)
			end)
		end
	end
	pcall(cover,workspace)
elseif mode=="AntiLeak" then
	local function noleak(obj) 
		if obj.ClassName == "StarterPlayerScripts" or obj.ClassName == "OLD.ServerStorage" or obj.ClassName == "Tool" or obj.ClassName == "HopperBin" then return end 
		obj.Archivable = false 
		obj.Changed:Connect(function(p)
			obj.Archivable = false
		end)
		for i,v in pairs(obj:GetChildren()) do 
			pcall(function() 
				v.Archivable = false 	
				v.Changed:Connect(function(p)
					v.Archivable = false
				end)
			end) 
		end 
	end
	pcall(noleak,game) 
	pcall(noleak,workspace)
	pcall(noleak,game:service("ReplicatedStorage"))
	--pcall(noleak,game:service("ServerStorage"))
	pcall(noleak,game:service("ServerScriptService"))
end

warn("Adonis_WorkSafe Instance Loaded")