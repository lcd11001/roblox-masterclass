local part = workspace:FindFirstChild("Explosion Part") -- Ensure the part exists
if not part then
	part = Instance.new("Part")
	part.Name = "Explosion Part"
	part.Size = Vector3.new(1, 1, 1)
	part.Color = Color3.new(1, 0, 0) -- Red color for visibility
	part.Position = Vector3.new(20, 1, -20) -- Set initial position
	part.Anchored = true
	part.Parent = workspace
end

while true do
	local explosion = Instance.new("Explosion")
	explosion.Position = part.Position
	explosion.BlastRadius = 10 -- You can adjust the radius
	explosion.BlastPressure = 500000 -- You can adjust the pressure
	explosion.DestroyJointRadiusPercent = 0.1
	explosion.Parent = part
	task.wait(2) -- Adjust how often the explosion happens
end
