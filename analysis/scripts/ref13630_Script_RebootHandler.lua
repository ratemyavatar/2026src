if script.Parent then
	local dDropperVal = script:WaitForChild("Dropper");
	local dTargetVal = script:WaitForChild("Runner");
	local parentVal = script:WaitForChild("mParent");
	local modelVal = script:WaitForChild("Model");
	local modeVal = script:WaitForChild("Mode");

	warn("Reloading in 5 seconds...");
	wait(5)
	script.Parent = nil;

	local dropper = dDropperVal.Value;
	local dTarget = dTargetVal.Value;
	local tParent = parentVal.Value;
	local model = modelVal.Value;
	local mode = modeVal.Value;

	local function CleanUp()
		warn("TARGET DISABLED");
		dTarget.Disabled = true;
		pcall(function() dTarget.Parent = game:GetService("ServerScriptService") end);
		wait()
		pcall(function() dTarget:Destroy() end);

		warn("TARGET DESTROYED");
		wait();

		warn("CLEANING")

		_G.Adonis = nil;
		_G.__Adonis_MODULE_MUTEX = nil;
		_G.__Adonis_MUTEX = nil;

		warn("_G VARIABLES CLEARED")

		warn("MOVING MODEL");
		dropper.Disabled = true;
		model.Parent = tParent;
	end

	if mode == "REBOOT" then
		warn("ATTEMPTING TO RELOAD ADONIS");
		CleanUp();
		wait();

		warn("MOVING")
		model.Parent = tParent;

		wait()

		warn("RUNNING");
		model.Loader.Dropper.Disabled = false;
	elseif mode == "STOP" then
		warn("ATTEMPTING TO STOP ADONIS");
		CleanUp();
	end

	warn("COMPLETE")

	warn("Destroying reboot handler...");
	script:Destroy();
end