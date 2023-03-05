repeat wait() until game:IsLoaded()
local Akrion = loadstring(game:HttpGet("https://raw.githubusercontent.com/Glowing-Red/Akrion/main/Library.lua"))()
local Window = Akrion:MakeWindow({})
local Hubs = Window:MakeTab({Name = "Hub"})
local Menus = Window:MakeTab({Name = "Menu"})
local Universals = Window:MakeTab({Name = "Universal"})

--// Functions
function Component(file)
    local Sucess, Response = pcall(function()
        file = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Glowing-Red/Akrion/main/Components/%s.lua"):format(file)), file..'.lua')()
    end)
    if Sucess then
        return file
    end
    Akrion:SendNotification({
        Title = "Component Error";
        Content = ("An error occured whilst loading the component %s!"):format(file);
        Time = 3;
    })
    return nil
end

for a,b in pairs({["Hub"] = Hubs, ["Menu"] = Menus, ["Universal"] = Universals}) do
    local t = Component(a)
    if type(t) == "table" then
        for c,d in pairs(Component(a)) do
            b:AddButton({
                Title = d.Name;
                Description = d.Description;
                Search = d.SearchName;
                Url = d.Url;
            })
        end
        table.clear(t)
    end
end
