local LOADER_URL = "https://api.luarmor.net/files/v4/loaders/a1f980ee0770fbf5a5c18a69f3c90f2b.lua"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "kryptex Loader",
			Text = tostring(text),
			Duration = 5,
		})
	end)
end

local function saveKey(key)
	if type(writefile) == "function" then
		pcall(function()
			writefile("kryptex_key.txt", key)
		end)
	end
end

local function readSavedKey()
	if type(readfile) == "function" and type(isfile) == "function" then
		local ok, exists = pcall(function()
			return isfile("kryptex_key.txt")
		end)

		if ok and exists then
			local readOk, value = pcall(function()
				return readfile("kryptex_key.txt")
			end)

			if readOk and type(value) == "string" then
				return value
			end
		end
	end

	return ""
end

local function loadProtectedScript(key)
	key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")

	if key == "" then
		notify("Enter your key first.")
		return
	end

	if LOADER_URL == "" or LOADER_URL == "PASTE_LUARMOR_LOADER_URL_HERE" then
		notify("Paste your LuaArmor loader URL in the script first.")
		return
	end

	saveKey(key)

	pcall(function()
		local env = getgenv and getgenv() or _G
		env.script_key = key
	end)

	pcall(function()
		_G.script_key = key
	end)

	pcall(function()
		script_key = key
	end)

	local ok, source = pcall(function()
		return game:HttpGet(LOADER_URL)
	end)

	if not ok or type(source) ~= "string" or source == "" then
		notify("Could not download loader.")
		return
	end

	local chunk, loadError = loadstring(source)
	if not chunk then
		notify("Loader error: " .. tostring(loadError))
		return
	end

	local ran, runError = pcall(chunk)
	if not ran then
		notify("Script error: " .. tostring(runError))
	end
end

local oldGui = playerGui:FindFirstChild("KryptexKeyGui")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "KryptexKeyGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 190)
frame.Position = UDim2.new(0.5, -180, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -52, 0, 48)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "kryptex Key"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 36, 0, 36)
close.Position = UDim2.new(1, -46, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(132, 44, 44)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -36, 0, 44)
input.Position = UDim2.new(0, 18, 0, 64)
input.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.PlaceholderText = "Enter your key..."
input.PlaceholderColor3 = Color3.fromRGB(145, 150, 165)
input.Text = readSavedKey()
input.TextSize = 16
input.Font = Enum.Font.Gotham
input.ClearTextOnFocus = false
input.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = input

local loadButton = Instance.new("TextButton")
loadButton.Size = UDim2.new(1, -36, 0, 44)
loadButton.Position = UDim2.new(0, 18, 0, 124)
loadButton.BackgroundColor3 = Color3.fromRGB(55, 111, 190)
loadButton.Text = "Load Script"
loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadButton.TextSize = 17
loadButton.Font = Enum.Font.GothamBold
loadButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = loadButton

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

loadButton.MouseButton1Click:Connect(function()
	loadButton.Text = "Loading..."
	loadProtectedScript(input.Text)
	task.wait(0.4)
	loadButton.Text = "Load Script"
end)

TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -180, 0.5, -95),
}):Play()
