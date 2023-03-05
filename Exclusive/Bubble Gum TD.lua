local function Loadstring(owner, repositorie, branch, file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/%s/%s/%s.lua"):format(owner, repositorie, branch, file)), file..'.lua')()
end

_G.MapOptions = {
    ChosenMap = "Meadow";
    ChosenGamemode = "Classic";
    ChosenDifficulty = "Normal";
}

_G.LobbySettings = {
    ChosenGameSpeedControl = "Everyone";
    FriendsOnly = false;
    PartyOnly = false;
}

_G.Webhook = {
    SavedWebhook = "";
}

local filenameMapOptions = "BGTD - Map Options.txt"
local filenameLobbySettings = "BGTD - Lobby Settings.txt"
local filenameWebhook = "BGTD - Webhook.txt"

function loadMapOptions()
    local HttpService = game:getService("HttpService")
    if (readfile and isfile and isfile(filenameMapOptions)) then
        _G.MapOptions = HttpService:JSONDecode(readfile(filenameMapOptions));
    end
end

function saveMapOptions()
    local json;
    local HttpService = game:GetService("HttpService")
    if (writefile) then
        json = HttpService:JSONEncode(_G.MapOptions);
        writefile(filenameMapOptions, json);
    end
end

function loadLobbySettings()
    local HttpService = game:getService("HttpService")
    if (readfile and isfile and isfile(filenameLobbySettings)) then
        _G.LobbySettings = HttpService:JSONDecode(readfile(filenameLobbySettings));
    end
end

function saveLobbySettings()
    local json;
    local HttpService = game:GetService("HttpService")
    if (writefile) then
        json = HttpService:JSONEncode(_G.LobbySettings);
        writefile(filenameLobbySettings, json);
    end
end

function loadWebhook()
    local HttpService = game:getService("HttpService")
    if (readfile and isfile and isfile(filenameWebhook)) then
        _G.Webhook = HttpService:JSONDecode(readfile(filenameWebhook));
    end
end

function saveWebhook()
    local json;
    local HttpService = game:GetService("HttpService")
    if (writefile) then
        json = HttpService:JSONEncode(_G.Webhook);
        writefile(filenameWebhook, json);
    end
end

loadMapOptions()
loadLobbySettings()
loadWebhook()

local Luxtl = Loadstring('Glowing-Red', 'Library', 'main', 'Luxware-UI-Library')

local Luxt = Luxtl.CreateWindow("BGTD", 6493464871)

local Automatic = Luxt:Tab("Automatic", 6087485864)
local Gems = Luxt:Tab("Gem Farm", 0)
local SettingsTab = Luxt:Tab("Random", 8310265118)

local AutomaticActions = Automatic:Section("Auto")
local GemActions = Gems:Section("Gem Farming")
local GemSettings = Gems:Section("Gem Settings")
local Settings = SettingsTab:Section("Random Stuff")

local Rounds = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Right.Slide.Round.Highlight
local GameGui = game:GetService("Players").LocalPlayer.PlayerGui.GameGui
local MyGameCurrent = game:GetService("Players").LocalPlayer.PlayerGui.LobbyGui.Lobbies.Frame.Container.Pages.Frame.Current
local FastForwardInnerIcon = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Right.Slide.SideButtons.FastForward.Frame.Container.Icon.Inner
local NextWave = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Top.NextWave

GemActions:Label("Autofarms Crystal Cave Normal")
GemActions:Toggle("Autofarm Gems", function(bool)
    getgenv().GemFarm = bool
    if bool then
        GemFarm();
    end
end)
GemSettings:Label("Logs the amount of gems you have\nwhilst you use the gem farm")
GemSettings:Toggle("Gem Logger", function(bool)
    getgenv().GemLogger = bool
end)
GemSettings:Label("Paste in the webhook in the box below")
GemSettings:TextBox("", "Webhook here...", function(getText)
_G.Webhook.SavedWebhook = getText
end)
GemSettings:Label("Sets your clipboard to the current webhook")
GemSettings:Button("Check Webhook", function()
    setclipboard(_G.Webhook.SavedWebhook)
end)
GemSettings:Label("Saves the webhook you have used")
GemSettings:Button("Save", function()
    saveWebhook()
end)


AutomaticActions:Label("Auto Creates A Game Every 5 Seconds")
AutomaticActions:Toggle("Create Game", function(bool)
    getgenv().CreateLobby = bool
    if bool then
        CreateLobby();
    end
end)
AutomaticActions:Label("Auto Starts The Game")
AutomaticActions:Toggle("Start Game", function(bool)
    getgenv().StartGame = bool
    if bool then
        StartGame();
    end
end)
AutomaticActions:Label("Auto Starts The Round")
AutomaticActions:Toggle("Start Round", function(bool)
    getgenv().StartRound = bool
    if bool then
        StartRound();
    end
end)
AutomaticActions:Label("Auto Enables Fast Forward")
AutomaticActions:Toggle("Fast Forward", function(bool)
    getgenv().FastForward = bool
    if bool then
        FastForward();
    end
end)
AutomaticActions:Label("Auto Leaves The Game When Its Done")
AutomaticActions:Toggle("Leave Game", function(bool)
    getgenv().LeaveGame = bool
    if bool then
        LeaveGame();
    end
end)

local MapOptions = Automatic:Section("Game Options")
MapOptions:Label("Choose Map")
MapOptions:DropDown("Map", {"Meadow", "Treasure Cove", "Candy Land", "Wild West", "Crystal Caves"}, function(MapChosen) -- food is chosen item
    _G.MapOptions.ChosenMap = MapChosen
end)
MapOptions:Label("Choose Gamemode")
MapOptions:DropDown("Gamemode", {"Classic", "Reversed Track", "?", "?", "?", "?"}, function(GamemodeChosen) -- food is chosen item
    _G.MapOptions.ChosenGamemode = GamemodeChosen
end)
MapOptions:Label("Choose Difficulty")
MapOptions:DropDown("Difficulty", {"Normal", "Hard", "Expert"}, function(DifficultyChosen) -- food is chosen item
    _G.MapOptions.ChosenDifficulty = DifficultyChosen
end)
MapOptions:Label("Save Map Options")
MapOptions:Button("Save", function()
    saveMapOptions()
end)

local LobbySettings = Automatic:Section("Game Settings")
game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Game Speed Control", _G.LobbySettings.ChosenGameSpeedControl)
game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Friends Only", _G.LobbySettings.FriendsOnly)
game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Party Only", _G.LobbySettings.PartyOnly)

LobbySettings:Label("Game Speed Control")
LobbySettings:DropDown("Game Speed Control", {"Everyone", "Owner"}, function(GameSpeedControlChosen) -- food is chosen item
    _G.LobbySettings.ChosenGameSpeedControl = GameSpeedControlChosen
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Game Speed Control", _G.LobbySettings.ChosenGameSpeedControl)
end)
LobbySettings:Label("Friends Only")
LobbySettings:DropDown("Friends Only", {"On", "Off"}, function(FriendsOnlyChosen) -- food is chosen item
    if FriendsOnlyChosen == "On" then
        _G.LobbySettings.FriendsOnly = true
    elseif FriendsOnlyChosen == "Off" then
        _G.LobbySettings.FriendsOnly = false
    end
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Friends Only", _G.LobbySettings.FriendsOnly)
end)
LobbySettings:Label("Party Only")
LobbySettings:DropDown("Party Only", {"On", "Off"}, function(PartyOnlyChosen) -- food is chosen item
    if PartyOnlyChosen == "On" then
        _G.LobbySettings.PartyOnly = true
    elseif PartyOnlyChosen == "Off" then
        _G.LobbySettings.PartyOnly = false
    end
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Party Only", _G.LobbySettings.PartyOnly)
end)
LobbySettings:Label("Save Lobby Settings")
LobbySettings:Button("Save", function()
    saveLobbySettings()
end)

Settings:Button("Lets you see your gems for a second\nwhilst inside a round", function()
    SeeGems()
end)

Settings:Label("Changes Rainbow Texture Into Gold")
Settings:Toggle("Change Texture", function(bool)
    ToggleGold();
end)

function ToggleGold()
    local Textures = game:GetService("ReplicatedStorage").SharedModules.MatchUtility.getTowerModel.RigTower.Rainbowify.Textures
    local Textures2 = game:GetService("ReplicatedStorage").SharedModules.MatchUtility.getTowerModel.RigTower.GoldTexture
    local RigTower = game:GetService("ReplicatedStorage").SharedModules.MatchUtility.getTowerModel.RigTower

    Textures.Name = "GoldTexture"
    Textures.Parent = RigTower

    Textures2.Name = "Textures"
    Textures2.Parent = RigTower.Rainbowify
end

function SeeGems()
    local LocalGems = game:GetService("Players").LocalPlayer.PlayerGui.LobbyGui.HUD.Gems
    local Gems = LocalGems:Clone()
    local GameProfile = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Left.Players:FindFirstChild(game:GetService("Players").LocalPlayer.Name)
    Gems.Parent = GameProfile
    Gems.Activation:Destroy()
    Gems.Position = UDim2.new(0, -4.5, 0, 150)

    wait(1)

    GameProfile.Gems:Destroy()
end

function GemLogger()
    if getgenv().GemLogger == true then
local Webhook = _G.Webhook.SavedWebhook

local embed1 = {
       ['title'] = 'You currently have '..game:GetService("Players").LocalPlayer.PlayerGui.LobbyGui.HUD.Gems.Label.Text.." Gems - "..tostring(os.date("%I:%M %p"))
   }
local a = syn.request({
   Url = Webhook,
   Headers = {['Content-Type'] = 'application/json'},
   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed1}, ['content'] = ''}),
   Method = "POST"
})
end
return
end

function GemFarm()
    spawn(function()
local GemFarmRounds = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Right.Slide.Round.Highlight
local GemFarmGameGui = game:GetService("Players").LocalPlayer.PlayerGui.GameGui

function LoadAndStart()
    if GemFarmGameGui.Enabled == true then
        return
    end
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Game Speed Control", "Owner")
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Friends Only", false)
    game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Party Only", true)
    
    local MapArgs = {
        ["Map"] = "Crystal Caves", 
	    ["Gamemode"] = "Classic", 
	    ["Difficulty"] = "Normal"
    }
    game:GetService("ReplicatedStorage").Events.CreateLobby:FireServer(MapArgs)
    
    wait(.5)
    
    game:GetService("ReplicatedStorage").Events.StartLobby:FireServer()
    game:GetService("ReplicatedStorage").Events.SetGiftRecipient:FireServer()
    return
end


while getgenv().GemFarm == true and wait(.5) do
    if GemFarmGameGui.Enabled == false then
        LoadAndStart()
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n0/30" then
        game:GetService("ReplicatedStorage").Events.StartNextWave:FireServer()
        game:GetService("ReplicatedStorage").Events.SetMatchFastForward:FireServer(true)
        GemLogger()
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n1/30" then
        game:GetService("ReplicatedStorage").Events.PlaceTower:FireServer("Ninja Bunny", nil, Vector3.new(21.547698974609, 0, -17.344116210938))
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n3/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 1, 1)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n4/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 1, 2)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n5/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 1)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n6/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 2)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n8/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 3)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n10/30" then
        game:GetService("ReplicatedStorage").Events.PlaceTower:FireServer("Reaper", nil, Vector3.new(23.167327880859, 0, -23.158935546875))
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n14/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 2, 1)
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 2, 2)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n16/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 1)
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 2)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n20/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 3)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n27/30" then
        game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 4)
    elseif GemFarmGameGui.Enabled == true and GemFarmRounds.Text == "<font size='24'>Round</font>\n30/30" then
        if game:GetService("Players").LocalPlayer.PlayerGui.GameGui:FindFirstChild("EndingFrame") then
            wait(5)
            game:GetService("ReplicatedStorage").Events.LeaveMatch:FireServer()
            wait(1.5)
        end
    end
end
    end)
end

function CreateLobby()
    spawn(function()
        while getgenv().CreateLobby == true do
            wait(5)
            if GameGui.Enabled == true or MyGameCurrent.NoLobby.Visible == false then
            elseif GameGui.Enabled == false or MyGameCurrent.NoLobby.Visible == true then
            game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Game Speed Control", _G.LobbySettings.ChosenGameSpeedControl)
            game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Friends Only", _G.LobbySettings.FriendsOnly)
            game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Party Only", _G.LobbySettings.PartyOnly)

            local MapArgs = {
                ["Map"] = _G.MapOptions.ChosenMap, 
                ["Gamemode"] = _G.MapOptions.ChosenGamemode, 
                ["Difficulty"] = _G.MapOptions.ChosenDifficulty
            }
            game:GetService("ReplicatedStorage").Events.CreateLobby:FireServer(MapArgs)
            end
        end
    end)
end

function StartGame()
    spawn(function()
        while getgenv().StartGame == true do
            if GameGui.Enabled == true or MyGameCurrent.NoLobby.Visible == true then
            elseif GameGui.Enabled == false or MyGameCurrent.NoLobby.Visible == false then
            game:GetService("ReplicatedStorage").Events.StartLobby:FireServer()
            game:GetService("ReplicatedStorage").Events.SetGiftRecipient:FireServer()
            end
            wait()
        end
    end)
end

function StartRound()
    spawn(function()
        while getgenv().StartRound == true do
            if GameGui.Enabled == true and NextWave.Visible == true then 
            game:GetService("ReplicatedStorage").Events.StartNextWave:FireServer()
            end
            wait()
        end
    end)
end

function FastForward()
    spawn(function()
        while getgenv().FastForward == true do
            if GameGui.Enabled == true and FastForwardInnerIcon.Image == "rbxassetid://6380649793" then
                game:GetService("ReplicatedStorage").Events.SetMatchFastForward:FireServer(true)
            end
            wait()
        end
    end)
end

function PlacePets_CrystalCaves()
    spawn(function()
        while getgenv().PlacePets_CrystalCaves == true do
                if GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n1/30" then
                    game:GetService("ReplicatedStorage").Events.PlaceTower:FireServer("Ninja Bunny", nil, Vector3.new(21.547698974609, 0, -17.344116210938))
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n3/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 1, 1)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n4/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 1, 2)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n5/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 1)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n6/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 2)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n8/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(0, 2, 3)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n10/30" then
                    game:GetService("ReplicatedStorage").Events.PlaceTower:FireServer("Reaper", nil, Vector3.new(23.167327880859, 0, -23.158935546875))
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n14/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 2, 1)
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 2, 2)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n16/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 1)
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 2)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n20/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 3)
                elseif GameGui.Enabled == true and Rounds.Text == "<font size='24'>Round</font>\n27/30" then
                    game:GetService("ReplicatedStorage").Events.UpgradeTower:FireServer(1, 3, 4)
                end
            wait()
        end
    end)
end

function LeaveGame()
    spawn(function()
        while getgenv().LeaveGame == true do
            wait(7.5)
            if GameGui.Enabled == false then
            elseif GameGui.Enabled == true then
            if game:GetService("Players").LocalPlayer.PlayerGui.GameGui:FindFirstChild("EndingFrame") then
            game:GetService("ReplicatedStorage").Events.LeaveMatch:FireServer()
            end
            end
        end
    end)
end



game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Game Speed Control", _G.LobbySettings.ChosenGameSpeedControl)
game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Friends Only", _G.LobbySettings.FriendsOnly)
game:GetService("ReplicatedStorage").Events.SetSetting:FireServer("Party Only", _G.LobbySettings.PartyOnly)

saveMapOptions()
saveLobbySettings()
saveWebhook()
return
