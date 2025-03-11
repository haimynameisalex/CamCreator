--!nonstrict

--------------- / Code made by @ pro_gamercgdd. Creates a camera with hinge surface in-front \ -----------
-------------- / Made this because I keep creating camera's with hinge surface in the back. \ ------------

--[[
MIT License

Copyright (c) 2025 haimynameisalex

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-------------- / Services \ -----------

local Selection = game:GetService("Selection")
local CoreGui = game:GetService("CoreGui")

-------------- / Plugin \ --------------

local toolbar = plugin:CreateToolbar("Create Camera")
local pluginButton = toolbar:CreateButton(
	"CamCreator",
	"Inserts a part that acts like a camera.",
	"rbxassetid://138516402626431"
)

local Camera = workspace.Camera

-------------- / Assets \ ----------------

local camCreator = script.Parent
local assets = camCreator:WaitForChild("Assets")
local models = assets:WaitForChild("Models")

local destinationPoints = models:WaitForChild("DestinationPoints")

------------- / GUI \ -----------------

local GUI = assets:WaitForChild("GUI")
local keyControlsGUI_Assets = GUI:WaitForChild("keyControlsGUI")
local mainGUI_Assets = GUI:WaitForChild("MainGui")

------------- / Variables \ ---------------

local toggle : number = 0
local selectedInstances = {}

--// Set GUI
local mainGUI = CoreGui:FindFirstChild("MainGUI") or mainGUI_Assets
mainGUI.Enabled = false
mainGUI.Parent = CoreGui

local mainFrame = mainGUI:WaitForChild("MainFrame")
local createCameraPartGUI = mainFrame:WaitForChild("CreateCameraPart")
local createDestinationPointsGUI = mainFrame:WaitForChild("CreateDestinationPoints")

------------ / Code \ -----------------

--// Instance functions

function SelectAllInstances()
	Selection:Set(selectedInstances)
end

--// Functions

function CreateCamera(parent : Instance)
	if parent ~= nil then
		local cameraPart = Instance.new("Part")
		cameraPart.Name = "CameraPart"

		cameraPart.Parent = parent
		cameraPart.Anchored = true
		cameraPart.CanCollide = false

		cameraPart.CFrame = Camera.CFrame * CFrame.new(0.5, 0, 0)

		------ // SURFACE \\ ---------

		cameraPart.FrontSurface = Enum.SurfaceType.Hinge
		cameraPart.BackSurface = Enum.SurfaceType.Smooth
		cameraPart.LeftSurface = Enum.SurfaceType.Smooth
		cameraPart.RightSurface = Enum.SurfaceType.Smooth
		cameraPart.BottomSurface = Enum.SurfaceType.Smooth
		cameraPart.TopSurface = Enum.SurfaceType.Smooth

		--// Insert the instance that needs to be selected \\ --
		table.insert(selectedInstances, cameraPart)
	else
		warn("Create Camera || Argument 1 expected to be Instance, got nil.")
	end
end

function CreateDestinationPoints(parent : Instance)
	if parent ~= nil then
		--// Creates a destination point, possibly used for tweening

		local clonedDestPoint = destinationPoints:Clone()
		clonedDestPoint.Parent = parent

		clonedDestPoint:PivotTo(Camera.CFrame * CFrame.new(1, 0, 0))
		
		table.insert(selectedInstances, clonedDestPoint)
	else
		warn("Create Camera || Argument 1 expected to be Instance, got nil.")
	end
end

--// Functions (Main)

function destPointMain()
	table.clear(selectedInstances)
	
	local selectedInstance = Selection:Get()[1]
	if selectedInstance ~= nil then
		local selectedNumber : number = #Selection:Get()
		if selectedNumber > 1 then
			for _, selectedInstances in pairs(Selection:Get()) do
				if selectedInstances ~= nil then
					CreateDestinationPoints(selectedInstances)
				else
					warn("Create Camera || Multiplie Instances could be nil?")
				end
				
				SelectAllInstances()
			end
		else
			--// Selected only one instance
			
			CreateDestinationPoints(selectedInstance)
			SelectAllInstances()
		end
	else
		CreateDestinationPoints(workspace)
		SelectAllInstances()
	end
end

function insertCameraMain()
	table.clear(selectedInstances)

	local selectedInstance = Selection:Get()[1]
	if selectedInstance ~= nil then
		local selectedNumber = #Selection:Get()
		if selectedNumber > 1 then
			for _, selectedInstances in pairs(Selection:Get()) do
				if selectedInstances ~= nil then
					CreateCamera(selectedInstances)
				else
					warn("Create Camera || Multiplie Instances could be nil?")
				end

				SelectAllInstances()
			end
		else
			--// Selected only one instance.

			CreateCamera(selectedInstance)
			SelectAllInstances()
		end
	else
		--// Didn't select anything.

		CreateCamera(workspace)
		SelectAllInstances()
	end
end

----- // Main

pluginButton.Click:Connect(function()
	mainGUI.Enabled = not mainGUI.Enabled
end)

---------- / Basic logic \ ----------

createCameraPartGUI.MouseButton1Click:Connect(insertCameraMain)
createDestinationPointsGUI.MouseButton1Click:Connect(destPointMain)
