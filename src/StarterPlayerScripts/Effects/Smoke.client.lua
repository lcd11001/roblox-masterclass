local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local part = workspace:FindFirstChild("Smoke Part") -- Ensure the part exists
if not part then
	part = Instance.new("Part")
	part.Name = "Smoke Part"
	part.Size = Vector3.new(1, 1, 1)
	part.Color = Color3.new(0.5, 0.5, 0.5) -- Gray color for visibility
	part.Position = Vector3.new(20, 10, -20) -- Set initial position
	part.Anchored = true
    part.CanCollide = false -- Prevent collisions
    part.Transparency = 1.0 -- Make it invisible
	part.Parent = workspace
end

local smoke = Instance.new("Smoke")
smoke.Size = 30 -- You can adjust the size
smoke.Opacity = 0.5 -- You can adjust the opacity
smoke.RiseVelocity = 15 -- You can adjust the rise velocity
smoke.Color = Color3.new(0.8, 0.8, 0.6) -- Sand color for smoke
smoke.TimeScale = 3 -- You can adjust the time scale
smoke.Parent = part

if part and camera then
	RunService.RenderStepped:Connect(function()
		part.CFrame = camera.CFrame * CFrame.new(0, 0, -2) -- Position the part in front of the camera
	end)
end
