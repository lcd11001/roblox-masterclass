print("LoadingScript")
local TweenService = game:GetService("TweenService")

local ReplicatedFirst = game:GetService("ReplicatedFirst")
ReplicatedFirst:RemoveDefaultLoadingScreen()

local ContentProvider = game:GetService("ContentProvider")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local loadingGui = script:WaitForChild("LoadingGui"):Clone()
loadingGui.Parent = playerGui

-- task.wait(5)
local LoadingGuiFrame = loadingGui:FindFirstChild("LoadingGuiFrame", true)
local loadingLabel = loadingGui:FindFirstChild("LoadingLabel", true)
local loadingBar = loadingGui:FindFirstChild("LoadingBar", true)

local loadingBarColors = {
	-- generate rainbow 7 colors
	Color3.fromRGB(255, 0, 0), -- Red
	Color3.fromRGB(255, 127, 0), -- Orange
	Color3.fromRGB(255, 255, 0), -- Yellow
	Color3.fromRGB(0, 255, 0), -- Green
	Color3.fromRGB(0, 0, 255), -- Blue
	Color3.fromRGB(75, 0, 130), -- Indigo
	Color3.fromRGB(148, 0, 211), -- Violet
}

local function lerpColor(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t, -- R
		a.G + (b.G - a.G) * t, -- G
		a.B + (b.B - a.B) * t -- B
	)
end

-- Evenly distributes stops across 0..1
local function colorAt(progress)
	local n = #loadingBarColors
	if n == 0 then
		return Color3.new(1, 1, 1)
	elseif n == 1 then
		return loadingBarColors[1]
	end
	progress = math.clamp(progress, 0, 1)
	-- print("Color at progress:", progress)

	local scaled = progress * (n - 1)
	local idx = math.floor(scaled) + 1 -- 1-based
	local nextIdx = math.min(idx + 1, n)
	-- print("idx:", idx, "nextIdx:", nextIdx)

	local t = scaled - (idx - 1)
	-- print("t:", t)

	local c1 = loadingBarColors[idx]
	local c2 = loadingBarColors[nextIdx]
	if nextIdx == idx then
		return c1
	end
	return lerpColor(c1, c2, t)
end

if loadingBar then
	loadingBar.Size = UDim2.fromScale(0, 1)
	loadingBar.BackgroundColor3 = colorAt(0)
end

local activeTween = nil
local activeCallback = nil
local tweenTime = 0.25
local function updateProgress(i, total, assetName, callback)
	if not loadingBar then
		return
	end
	local p = i / total
	if loadingLabel then
		loadingLabel.Text = ("Loading: %s (%d/%d)"):format(assetName, i, total)
	end
	if activeTween and activeTween.PlaybackState == Enum.PlaybackState.Playing then
		if activeCallback then
			activeCallback:Disconnect()
			activeCallback = nil
		end
		activeTween:Cancel()
	end

	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	activeTween = TweenService:Create(loadingBar, tweenInfo, {
		Size = UDim2.fromScale(p, 1),
		BackgroundColor3 = colorAt(p),
	})
	activeTween:Play()
	if callback then
		activeCallback = activeTween.Completed:Connect(function()
			callback()
		end)
	end
end

local assets = game:GetChildren()
for index, asset in ipairs(assets) do
	ContentProvider:PreloadAsync({ asset }, function(assetId, status)
		-- print("index", index, "preload", assetId, "status", status)
		-- if loadingLabel and loadingBar then
		-- 	loadingLabel.Text = "Loading: " .. asset.Name
		-- 	loadingBar.Size = UDim2.fromScale(index / #assets, 1)
		-- end
		updateProgress(index, #assets, asset.Name)
	end)
end

updateProgress(#assets, #assets, "All Assets", function()
	-- loadingGui:Destroy()

	local finalTween = TweenService:Create(LoadingGuiFrame, TweenInfo.new(tweenTime), {
		Transparency = 1,
	})
	finalTween:Play()
	finalTween.Completed:Connect(function()
		loadingGui:Destroy()
	end)
end)
