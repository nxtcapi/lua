
--[[
Custom Commision
22/03/2026
ignore shitty code this was made in 15 minutes
]]


--// Logic
local TDC = {}

TDC.AutoEnterGift = { Enabled = false, Thread = nil }
TDC.AutoEnterGift.Enable = function(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        while self.Enabled do
            game:GetService("ReplicatedStorage").Events.EnterGift:FireServer()
            task.wait(5)
        end
    end)
end

TDC.AutoEnterGift.Disable = function(self)
    self.Enabled = false
    task.cancel(self.Thread)
end

TDC.AutoClaimChest = { Enabled = false, Thread = nil}
TDC.AutoClaimChest.Enable = function(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        while self.Enabled do
            firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Chest.Part, 1)
            task.wait(0.1)
            firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Chest.Part, 0)
            task.wait(20)
        end
    end)
end

TDC.AutoClaimChest.Disable = function(self)
    self.Enabled = false
    task.cancel(self.Thread)
end

TDC.Autoclicker = { Enabled = false, Thread = nil }
TDC.Autoclicker.Enable = function(self)
    game:GetService("ReplicatedStorage").Events.ClientClick:FireServer( "Autoclicker" )
end

TDC.Autoclicker.Disable = function(self)
    game:GetService("ReplicatedStorage").Events.ClientClick:FireServer( "Autoclicker" )
end

TDC.AutoCase = { Enabled = false, Thread = nil, Crate = "Starter", Notify = false }

TDC.AutoCase.Enable = function(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        while self.Enabled do
            local result = game:GetService("ReplicatedStorage").Events.OpenCase:InvokeServer(self.Crate)
            if self.Notify and result ~= nil then
                Library:Notify({
                    Title = "Auto Case",
                    Description = "Unboxed: " .. result,
                    Time = 4,
                })
            end
            task.wait(1)
        end
    end)
end

TDC.AutoCase.Disable = function(self)
    self.Enabled = false
    task.cancel(self.Thread)
end


--// this is straight pasted ouf the github docs, idk why they formated it like that but could care less
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false 
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
	Title = "Trade Tower Central",
	Footer = "version: 1.0.0",
	NotifySide = "Right",
	ShowCustomCursor = true,
})

--// Cleanup
task.spawn(function() 
	while task.wait(1) do
		if Library.Unloaded then
			for _, v in pairs(TDC) do
				if type(v) == "table" and v.Disable then
					v:Disable()
				end
			end
		end
	end
end)

local Tabs = {
	Main = Window:AddTab("Main", "user"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local Farming_Section = Tabs.Main:AddLeftGroupbox("Farming", "boxes")

Farming_Section:AddToggle("Autoclicker", {
	Text = "Autoclicker",
	Callback = function(Value)
        task.spawn(TDC.Autoclicker[Value and "Enable" or "Disable"], TDC.Autoclicker)
	end,
})

local Crates_Section = Tabs.Main:AddLeftGroupbox("Crates", "boxes")

Crates_Section:AddToggle("Auto Open Crate", {
	Text = "Auto Open Crate",
	Callback = function(Value)
        task.spawn(TDC.AutoCase[Value and "Enable" or "Disable"], TDC.AutoCase)
	end,
})

Crates_Section:AddDropdown("Crate Selection", {
	Values = { "Starter", "Noobie", "Stepping", "Learning", "Funding", "Business", "Legendary", "Marcellus", "Famous", "Mythic", "Eirene", "Aeschylus", "Olysseus", "Big Boy", "Dye", "Indy", "Risk", "Grace" },
	Default = 1,    
	Multi = false, 
	Text = "Crate Selection",
	Searchable = true, 
	Callback = function(Value)
        TDC.AutoCase.Crate = Value
	end,
	Disabled = false, 
	Visible = true,
})

Crates_Section:AddToggle("Notify", {
	Text = "Notify Results",
	Callback = function(Value)
        TDC.AutoCase.Notify = Value
	end,
})

local Misc_Section = Tabs.Main:AddRightGroupbox("Misc", "boxes")

Misc_Section:AddToggle("Auto Enter Gift", {
	Text = "Auto Enter Server Gifts",
	Tooltip = "Automatically enters server gifts",
	Callback = function(Value)
        task.spawn(TDC.AutoEnterGift[Value and "Enable" or "Disable"], TDC.AutoEnterGift)
	end,
})

Misc_Section:AddToggle("Auto Claim Chest", {
	Text = "Auto Claim Chest",
	Tooltip = "Automatically claim chest",
	Callback = function(Value)
        task.spawn(TDC.AutoClaimChest[Value and "Enable" or "Disable"], TDC.AutoClaimChest)
	end,
})


--// Again pasted from docs
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddSlider("UICornerSlider", {
	Text = "Corner Radius",
	Default = Library.CornerRadius,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(value)
		Window:SetCornerRadius(value)
	end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind 

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("IWCommisions")
SaveManager:SetFolder("IWCommisions/Trade Tower Central")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
