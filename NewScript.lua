--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Get the player who executed the script
local player = game:GetService("Players").LocalPlayer

local players = game:GetService("Players"):GetPlayers()

-- Create a new ScreenGui object to hold the UI elements
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

-- Create a new Frame object to hold the UI elements
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 300) -- Set the size of the frame
frame.Position = UDim2.new(0.5, -300, 0.5, -150) -- Position the frame in the center of the screen
frame.BackgroundTransparency = 0.5 -- Make the frame partially transparent
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Set the background color of the frame to black
frame.BorderSizePixel = 2 -- Add a border to the frame
frame.BorderColor3 = Color3.new(1, 1, 1) -- Set the border color of the frame to white
frame.Active = false -- Make the frame draggable
frame.Parent = gui

-- Create a new TextBox object to allow the user to input audio IDs
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0, 500, 0, 20) -- Set the size of the text box
textbox.Position = UDim2.new(0.5, -250, 0.1, 0) -- Position the text box near the top of the frame
textbox.PlaceholderText = "Enter audio ID" -- Set the placeholder text for the text box
textbox.Parent = frame

local volumetextbox = Instance.new("TextBox")
volumetextbox.Size = UDim2.new(0, 500, 0, 20)
volumetextbox.Position = UDim2.new(0.5, -250, 0.1, 20)
volumetextbox.PlaceholderText = "Enter Volume"
volumetextbox.Parent = frame

local pitchtextbox = Instance.new("TextBox")
pitchtextbox.Size = UDim2.new(0, 500, 0, 20)
pitchtextbox.Position = UDim2.new(0.5, -250, 0.1, 40)
pitchtextbox.PlaceholderText = "Enter Pitch"
pitchtextbox.Parent = frame

-- Create a new TextButton object to serve as the UI button
local button = Instance.new("TextButton")
button.Text = "Toggle Sound"
button.Size = UDim2.new(0, 80, 0, 30) -- Set the size of the button
button.Position = UDim2.new(0.5, -180, 0.4, 5) -- Position the button near the bottom of the frame
button.Parent = frame

local loop = Instance.new("TextButton")
loop.Text = "Loop"
loop.Size = UDim2.new(0, 80, 0, 30)
loop.Position = UDim2.new(0.5, -90, 0.4, 5)
loop.Parent = frame

local getallaudios = Instance.new("TextButton")
getallaudios.Text = "Get all audios"
getallaudios.Size = UDim2.new(0, 80, 0 ,30)
getallaudios.Position = UDim2.new(0.5, 0, 0.4, 5)
getallaudios.Parent = frame

local clone = Instance.new("TextButton")
clone.Text = "Clone"
clone.Size = UDim2.new(0, 80, 0, 30)
clone.Position = UDim2.new(0.5, 90, 0.4, 5)
clone.Parent = frame

local deleteclone = Instance.new("TextButton")
deleteclone.Text = "Delete Clone"
deleteclone.Size = UDim2.new(0, 80, 0, 30)
deleteclone.Position = UDim2.new(0.5, 90, 0.4, 50)
deleteclone.Parent = frame

local deleteall = Instance.new("TextButton")
deleteall.Text = "Delete all"
deleteall.Size = UDim2.new(0, 80, 0, 30)
deleteall.Position = UDim2.new(0.5, 0, 0.4, 50)
deleteall.TextColor3 = Color3.new(1, 0, 0)
deleteall.Parent = frame

local createaudio = Instance.new("TextButton")
createaudio.Text = "Create new\ninstance"
createaudio.Size = UDim2.new(0, 80, 0, 30)
createaudio.Position = UDim2.new(0.5, -90, 0.4, 50)
createaudio.Parent = frame

local rejoinButton = Instance.new("TextButton")
rejoinButton.Text = "Rejoin"
rejoinButton.Size = UDim2.new(0, 80, 0, 30)
rejoinButton.Position = UDim2.new(0.5, -180, 0.4, 50)
rejoinButton.Parent = frame

-- Create a new Sound object
local sound = Instance.new("Sound")
sound.SoundId = "" -- Set the initial SoundId to an empty string
sound.Parent = game.Workspace -- Play the sound from the workspace
sound.Volume = 1
sound.Looped = false -- Make the sound loopable

local soundCount = 0

-- Create a boolean flag to keep track of whether the sound is playing or not
local isPlaying = false

-- Add the GUI window to the player's screen
gui.Parent = player.PlayerGui

local rfeLabel = Instance.new("TextLabel")
rfeLabel.Size = UDim2.new(0, 580, 0, 20)
rfeLabel.Position = UDim2.new(0.5, -290, 0.7, 50)
rfeLabel.TextColor3 = Color3.new(1, 1, 1)
rfeLabel.TextWrapped = true
rfeLabel.TextXAlignment = Enum.TextXAlignment.Center
rfeLabel.Parent = frame

local function updateRFELabel()
	rfeLabel.Text = "RespectFilteringEnabled(RFE): "..tostring(game:GetService("SoundService").RespectFilteringEnabled)
end

local isDragging = false
local dragStart = nil

local function onFrameInputBegan(input, gameProcessedEvent)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isDragging = true
		dragStart = input.Position
	end
end

-- Function to handle when the user moves the mouse while dragging the frame
local function onFrameInputChanged(input, gameProcessedEvent)
	if isDragging then
		local delta = input.Position - dragStart
		frame.Position = frame.Position + UDim2.new(0, delta.X, 0, delta.Y)
		dragStart = input.Position
	end
end

-- Function to handle when the user stops dragging the frame
local function onFrameInputEnded(input, gameProcessedEvent)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isDragging = false
	end
end

-- Connect the input functions to the frame's input events
frame.InputBegan:Connect(onFrameInputBegan)
frame.InputChanged:Connect(onFrameInputChanged)
frame.InputEnded:Connect(onFrameInputEnded)

-- Create a message label to display error messages to the user
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0, 580, 0, 20) -- Set the size of the message label
messageLabel.Position = UDim2.new(0.5, -290, 0.45, 70) -- Position the message label near the center of the frame
messageLabel.TextColor3 = Color3.new(1, 0, 0) -- Set the text color of the message label to red
messageLabel.TextWrapped = true -- Wrap the text in the message label if it is too long
messageLabel.TextXAlignment = Enum.TextXAlignment.Center -- Center the text in the message label horizontally
messageLabel.Parent = frame

-- Function to display an error message to the user
local function displayErrorMessage(message)
	local searchText = "Please enter a valid audio ID"
	messageLabel.Text = message
	if string.find(messageLabel.Text:lower(), searchText:lower()) then
		wait(2) -- Wait for 2 seconds before clearing the message
		messageLabel.Text = ""
	end
end

-- Update the toggleSound function to handle errors
local function toggleSound()
	local playnumber = 0
	if isPlaying and sound.Looped then
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text then
				wait(0.025)
				sound:Stop()
				isPlaying = false
				playnumber += 1
				displayErrorMessage("Audio #"..playnumber.." stopped.")
				messageLabel.TextColor3 = Color3.new(1, 0, 0)
			end
		end
	else
		if sound.SoundId == "" then
			displayErrorMessage("Please enter an audio ID")
			return
		end
		local success, errorMessage = pcall(function()
			isPlaying = true
			for _, sound in next, workspace:GetDescendants() do
				if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text then
					wait(0.04)
					playnumber += 1
					sound:Play()
					sound.SoundId = "rbxassetid://"..tostring(textbox.Text)
					sound.Volume = tonumber(volumetextbox.Text) or 1
					sound.Pitch = tonumber(pitchtextbox.Text) or 1
					displayErrorMessage("Audio #"..playnumber.." playing.")
					messageLabel.TextColor3 = Color3.new(0, 1, 0)
				end
			end
		end)

		if not success then
			messageLabel.TextColor3 = Color3.new(1, 0, 0)
			displayErrorMessage(errorMessage)
		end
	end
end

-- Update the setSoundId function to handle errors
local function setSoundId()
	local audioId = tonumber(textbox.Text)
	if audioId then
		sound.SoundId = "rbxassetid://"..tostring(audioId)
	else
		displayErrorMessage("Please enter a valid audio ID")
	end
end

-- Connect the setSoundId function to the textbox's FocusLost event
textbox.FocusLost:Connect(setSoundId)

-- Connect the toggleSound function to the button's MouseButton1Click event
button.MouseButton1Click:Connect(toggleSound)

local function rejoin()
	local teleportService = game:GetService("TeleportService")
	local placeId = game.PlaceId
	local jobId = game.JobId
	if placeId ~= 0 and jobId ~= "" then
		messageLabel.TextColor3 = Color3.new(1, 1, 1)
		displayErrorMessage("Rejoining server...")
		wait(0.5)
		teleportService:TeleportToPlaceInstance(placeId, jobId)
	end
end

rejoinButton.MouseButton1Click:Connect(rejoin)

local function toggleLoop()
	local audioId = tonumber(textbox.Text)
	if audioId then
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text then
				if not sound.Looped then
					sound.Looped = true
					loop.Text = "Unloop"
				else
					sound.Looped = false
					loop.Text = "Loop"
				end
			end
		end
	end
end

loop.MouseButton1Click:Connect(toggleLoop)

-- Add a close button to the frame
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.9525, -15, -0.0025, 15)
closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = frame

-- Function to handle when the user clicks the close button
local function onCloseButtonClicked()
	-- Destroy the UI elements
	gui:Destroy()
end

-- Connect the onCloseButtonClicked function to the close button's MouseButton1Click event
closeButton.MouseButton1Click:Connect(onCloseButtonClicked)

local function createinstance()
	local audioId = tonumber(textbox.Text)
	if audioId and soundCount == 0 then
		sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://"..tostring(textbox.Text) -- Set the initial SoundId to an empty string
		sound.Parent = game.Workspace -- Play the sound from the workspace
		soundCount += 1
		messageLabel.TextColor3 = Color3.new(0, 1, 0)
		displayErrorMessage("Sound Instance Created!")
	else
		messageLabel.TextColor3 = Color3.new(1, 0, 0)
		displayErrorMessage("Sound instance already created!")
	end
end

createaudio.MouseButton1Click:Connect(createinstance)
	

local function cloneAudio()
	local audioId = tonumber(textbox.Text)
	if audioId and soundCount > 0 and not sound.Playing and not sound.Looped or sound.Looped then
		sound:Clone().Parent = game.Workspace
		soundCount += 1
		messageLabel.TextColor3 = Color3.new(0, 1, 0)
		displayErrorMessage("Current audio count of audio ID "..textbox.Text..": "..soundCount)
	else
		messageLabel.TextColor3 = Color3.new(1, 0, 0)
		displayErrorMessage("Please enter a valid audio ID or audio is currently playing.")
	end
end

clone.MouseButton1Click:Connect(cloneAudio)

local function deleteClonedAudio()
	local cloneNumber = 0
	
	for _, sound in next, workspace:GetDescendants() do
		if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text then
			wait(0.05)
			cloneNumber += 1
			if soundCount > 0 then
				sound:Destroy()
				soundCount -= 1
				messageLabel.TextColor3 = Color3.new(1, 0, 0)
				displayErrorMessage("Clone #"..cloneNumber.." deleted.")
			else
				displayErrorMessage("Cannot find other clones!")
			end
		end
	end
	sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://"..tostring(textbox.Text) -- Set the initial SoundId to an empty string
	sound.Parent = game.Workspace
	soundCount += 1
end

deleteclone.MouseButton1Click:Connect(deleteClonedAudio)

local function deleteAllAudio()
	local cloneNumber = 0
	
	for _, sound in next, workspace:GetDescendants() do
		if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text then
			wait(0.05)
			cloneNumber += 1
			if soundCount > 0 then
				sound:Destroy()
				soundCount -= 1
				messageLabel.TextColor3 = Color3.new(1, 0, 0)
				displayErrorMessage("Deleted Audio #"..cloneNumber)
			end
		end
	end
end

deleteall.MouseButton1Click:Connect(deleteAllAudio)

local function getAllAudios()
	local audioId = tonumber(textbox.Text)
	if audioId then
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") and sound.SoundId == "rbxassetid://"..textbox.Text and soundCount == 0 then
				soundCount += 1
				messageLabel.TextColor3 = Color3.new(0, 1, 0)
				displayErrorMessage("Current audio count of audio ID "..textbox.Text..": "..soundCount)
			end
		end
	elseif soundCount >= 1 then
		messageLabel.TextColor3 = Color3.new(1, 0, 0)
		displayErrorMessage("Please enter a valid audio ID or audio is currently playing.")
	end
end

getallaudios.MouseButton1Click:Connect(getAllAudios)

while true do
	wait(0.5)
	local setting = game:GetService("SoundService").RespectFilteringEnabled
	if setting == false then
		rfeLabel.TextColor3 = Color3.new(0, 1, 0)
	else
		rfeLabel.TextColor3 = Color3.new(1, 0, 0)
	end
	updateRFELabel()
end
