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
    local c = Component(a)
    if type(c) == "table" then
        for d,e in pairs(Component(a)) do
            b:AddButton({
                Title = e.Name;
                Description = e.Description;
                Search = e.SearchName;
                Url = e.Url;
            })
        end
        table.clear(c)
    end
end
