--| Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--| Variables

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Colour = {
	["Common"] = Color3.fromRGB(0, 221, 255);
	["Uncommon"] = Color3.fromRGB(29, 0, 255);
	["Rare"] = Color3.fromRGB(255, 0, 234);
	["Legendary"] = Color3.fromRGB(255, 0, 4)
}


_G.Toggle = {
	Common = false;
	Uncommon = false;
	Rare = false;
	Legendary = false;

	Ingredients = false;
	Flowers = false;
}

_G.Distance = 1000

_G.Loaded = false
_G.Parts = {}

--// UI

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Force", 5013109572)

local PageOne = venyx:addPage("LocalPlayer", 5012544693)
local CharacterSection = PageOne:addSection("Character")

local PageTwo = venyx:addPage("ESP", 5012544693)
local TrinketSection = PageTwo:addSection("Trinkets")
local MiscSection = PageTwo:addSection("Misc")
local DistSection = PageTwo:addSection("Distance")

local PageThree = venyx:addPage("Locations", 5012544693)
local Tatooine = PageThree:addSection("Tatooine")
local Kira = PageThree:addSection("Kira")
local Kashyyyk = PageThree:addSection("Kashyyyk")
local Illum = PageThree:addSection("Illum")

local PageFour = venyx:addPage("Misc")
local Settings = PageFour:addSection("Settings")

--// Misc

local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

--| Function

function Notification(Title, Message)
	venyx:Notify(Title, Message)
end

function findPart(Slot)
	for Slo, ItemInfo in next, _G.Parts do
		if ItemInfo.Slot == Slot then
			return ItemInfo
		end
	end
end

function CreateESP(Part, Rarity)
	Part.Name = "Item"..#_G.Parts + 1

	local PartInfo = {
		Name = Part.Name;
		Part = Part;
		Rarity = Rarity;
		Slot = #_G.Parts + 1
	}

	PartInfo.bESP = Drawing.new("Text")
	PartInfo.bESP.Visible = false
	PartInfo.bESP.Center = true
	PartInfo.bESP.Outline = true
	PartInfo.bESP.Font = 2
	PartInfo.bESP.Size = 13	
	PartInfo.bESP.Color = Colour[Rarity]

	table.insert(_G.Parts, PartInfo)
	
	local rStep
	rStep = RunService.RenderStepped:Connect(function()
		if Part and workspace:FindFirstChild(Part.Name) then
			if Part.Name == "" then
				PartInfo.bESP.Visible = false
				PartInfo.bESP:Remove()
				rStep:Disconnect()
				table.remove(_G.Parts, PartInfo.Slot)
				PartInfo = nil
			end
			local Vector, OnScreen = Camera:WorldToViewportPoint(Part.Position)
			local Distance = math.floor((Part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)

			if OnScreen and (Distance <= _G.Distance) then
				PartInfo.bESP.Position = Vector2.new(Vector.X, Vector.Y)
				PartInfo.bESP.Text = Rarity.." | "..Distance.."m"
				PartInfo.bESP.Visible = true
			else
				PartInfo.bESP.Visible = false
			end
		else
			PartInfo.bESP.Visible = false
			PartInfo.bESP:Remove()
			rStep:Disconnect()
			table.remove(_G.Parts, PartInfo.Slot)
			PartInfo = nil
		end
	end)
end

function GetItemsByRarity(Rarity)
	for _, v in pairs(workspace:GetChildren()) do
		if (v:IsA("MeshPart") or v:IsA("UnionOperation")) and v:FindFirstChildOfClass("ProximityPrompt") then
			local RarityV = v.Rarity.Value
			if RarityV == Rarity and v.Name == "" then
				CreateESP(v, v.Rarity.Value)
			end
		end
	end
end

function GetListByRarity(Rarity)
	for Slot, ItemInfo in next, _G.Parts do
		if ItemInfo.Rarity == Rarity then
			ItemInfo.Part.Name = ""
		end
	end
end

function GetItemsAsync(Part, Rarity)
	
end

--| Elements

--// Character

CharacterSection:addSlider("WalkSpeed", 16, 0, 100, function(value)
	LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

--// ESP

TrinketSection:addToggle("Common", false, function(state)
	_G.Toggle["Common"] = state

	while _G.Toggle["Common"] == true do
		GetItemsByRarity("Common")
		wait(1)
	end
	GetListByRarity("Common")
end)

TrinketSection:addToggle("Uncommon", false, function(state)
	_G.Toggle["Uncommon"] = state

	while _G.Toggle["Uncommon"] == true do
		GetItemsByRarity("Uncommon")
		wait(1)
	end
	GetListByRarity("Uncommon")
end)

TrinketSection:addToggle("Rare", false, function(state)
	_G.Toggle["Rare"] = state

	while _G.Toggle["Rare"] == true do
		GetItemsByRarity("Rare")
		wait(1)
	end
	GetListByRarity("Rare")
end)

TrinketSection:addToggle("Legendary", false, function(state)
	_G.Toggle["Legendary"] = state

	while _G.Toggle["Legendary"] == true do
		GetItemsByRarity("Legendary")
		wait(1)
	end
	GetListByRarity("Legendary")
end)

MiscSection:addToggle("Ingredients", false, function(state)
	_G.Toggle["Ingredients"] = state
end)

MiscSection:addToggle("Flowers", false, function(state)
	_G.Toggle["Flowers"] = state
end)

DistSection:addSlider("Distance", 1000, 0, 10000, function(Value)
	_G.Distance = Value
end)

--// Teleports

Tatooine:addButton("Solare", function()
    game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Solare")
end)

Tatooine:addButton("Mos Relso", function()
    game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Mos Relso")
end)

Illum:addButton("Merlin's Dockyard", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Merlin's Dockyard")
end)

Illum:addButton("Arrendehl", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Arrendehl")
end)

Kashyyyk:addButton("Ariantos", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Ariantos")
end)

Kashyyyk:addButton("Taweret", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Taweret")
end)

Kira:addButton("Saro's Repose", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Saro's Repose")
end)

Kira:addButton("Sunlight Glade", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Sunlight Glade")
end)

Kira:addButton("Fort Gunjo", function()
	game:GetService("ReplicatedStorage").Requests.Travel:FireServer("Fort Gunjo")
end)

--// Settings

Settings:addKeybind("Hide UI", Enum.KeyCode.RightAlt, function()
	venyx:toggle()
end)

--| Load

venyx:SelectPage(venyx.pages[1], true)