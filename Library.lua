local AkrionLib = {
    ThemeObjects = {};
    Connections = {},
    Themes = {
		Aesthetic = {
			Primary = Color3.fromRGB(121, 98, 84),
			Secondary = Color3.fromRGB(100, 81, 70),
			Divider = Color3.fromRGB(43, 23, 14),
			Text = Color3.fromRGB(209, 187, 167),
			TextDark = Color3.fromRGB(43, 23, 14),
			User = "rbxassetid://1098069078"
		};
		Midnight = {
			Primary = Color3.fromRGB(49, 51, 56),
			Secondary = Color3.fromRGB(43, 45, 49),
			Divider = Color3.fromRGB(55, 57, 63),
			Text = Color3.fromRGB(86, 98, 246),
			TextDark = Color3.fromRGB(70, 78, 175),
			User = "rbxassetid://3600632866"
		};
	};
	SelectedTheme = "Aesthetic";
	Hidden = false;
}

local AkrionTable = {
	Tabs = {};
	Fonts = {
	    Default = Font.new("rbxassetid://1");
	    Akronim = Font.new("rbxassetid://12187368317");
	    BoldAkronim = Font.new("rbxassetid://12187368317", Enum.FontWeight.Bold);
	};
}

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Plr = Players.LocalPlayer
local Mouse = Plr:GetMouse()

local Akrion
local Messages

function AkrionLib:IsRunning()
	if gethui then
		return Akrion.Parent == gethui()
	else
		return Akrion.Parent == game:GetService("CoreGui")
	end
end

local function Connect(a, b)
	if not AkrionLib:IsRunning() then
		return
	end
	local c = a:Connect(b)
	table.insert(AkrionLib.Connections, c)
	return c
end

local function MakeDraggable(DragPoint, Main)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		Connect(DragPoint.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = Main.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		Connect(DragPoint.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		Connect(UIS.InputChanged, function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				--TweenService:Create(Main, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
				Main.Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
			end
		end)
	end)
end

local function GetFont(FontName)
	if AkrionTable.Fonts[FontName] ~= nil then
		return AkrionTable.Fonts[FontName]
	else
		return AkrionTable.Default
	end
end   

local function Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do
		Object[i] = v
	end
	for i, v in next, Children or {} do
		v.Parent = Object
	end
	return Object
end

local function ThemeProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then
		return "BackgroundColor3"
	end 
	if Object:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	end 
	if Object:IsA("UIStroke") then
		return "Color"
	end 
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then
		return "TextColor3"
	end   
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return "BackgroundColor3"
	end   
end

local function AddThemeObject(Type, Object)
	if not AkrionLib.ThemeObjects[Type] then
		AkrionLib.ThemeObjects[Type] = {}
	end    
	table.insert(AkrionLib.ThemeObjects[Type], Object)
	Object[ThemeProperty(Object)] = AkrionLib.Themes[AkrionLib.SelectedTheme][Type]
	return Object
end 

local function SetTheme(Theme)
    Theme = Theme or AkrionLib.SelectedTheme
    if not AkrionLib.Themes[Theme] then 
        return
    end
	for Name, Type in pairs(AkrionLib.ThemeObjects) do
		for _, Object in pairs(Type) do
			Object[ThemeProperty(Object)] = AkrionLib.Themes[Theme][Name]
		end    
	end
end

function SetupGui(gui)
    if not gui then
        return
    end
    if syn then
        --syn.protect_gui(gui)
        gui.Parent = game.CoreGui
    else
        gui.Parent = gethui() or game.CoreGui
    end
    if gethui then
        for _, Interface in ipairs(gethui():GetChildren()) do
            if Interface.Name == gui.Name and Interface ~= gui then
                Interface:Destroy()
            end
        end
    else
        for _, Interface in ipairs(game.CoreGui:GetChildren()) do
            if Interface.Name == gui.Name and Interface ~= gui then
                Interface:Destroy()
            end
        end    
    end
    task.spawn(function()
        while (AkrionLib:IsRunning()) do
            task.wait()
        end
        for _, Connection in next, AkrionLib.Connections do
            Connection:Disconnect()
        end
    end)
end

function AkrionLib:SendNotification(Configs)
    task.spawn(function()
    Configs = Configs or {}
    Configs.Title = Configs.Title or "Notification"
	Configs.Content = Configs.Content or "Content"
	Configs.Time = Configs.Time or 15
	
    local Notification = Create("Frame", {
        Name = "Message",
        Parent = Messages,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 250, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true
    })
    AddThemeObject("Primary", Create("Frame", {
        Name = "Content",
        Parent = Notification,
        Position = UDim2.new(1.25, 0, 0, 0),
        Active = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    }))
    Create("UISizeConstraint", {
        Parent = Notification.Content,
        MaxSize = Vector2.new(math.huge, 120)
    })
    Create("UICorner", {
        Parent = Notification.Content
    })
    Create("Frame", {
        Name = "Body",
        Parent = Notification.Content,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 0, 32),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    Create("UIPadding", {
        Parent = Notification.Content.Body,
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12)
    })
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Title",
        Parent = Notification.Content.Body,
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("BoldAkronim"),
        Text = Configs.Content,
        TextSize = 14.000,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }))
    AddThemeObject("Secondary", Create("Frame", {
        Name = "Top",
        Parent = Notification.Content,
        BackgroundColor3 = Color3.fromRGB(75, 61, 52),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 32),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 3
    }))
    Create("UICorner", {
        Parent = Notification.Content.Top
    })
    AddThemeObject("Divider", Create("Frame", {
        Name = "Detail",
        Parent = Notification.Content.Top,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(43, 23, 14),
        BackgroundTransparency = 0.700,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 3
    }))
    Create("Frame", {
        Name = "Exit",
        Parent = Notification.Content.Top,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(27, 42, 53),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = 3,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })
    Create("UIAspectRatioConstraint", {
        Parent = Notification.Content.Top.Exit
    })
    AddThemeObject("TextDark", Create("TextButton", {
        Name = "Close",
        Parent = Notification.Content.Top.Exit,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.600000024, 0),
        Size = UDim2.new(0.699999988, 0, 0.699999988, 0),
        FontFace = GetFont("Akronim"),
        Text = "x",
        TextColor3 = Color3.fromRGB(43, 23, 14),
        TextSize = 40.000
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Detail",
        Parent = Notification.Content.Top.Exit.Close,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "x",
        TextSize = 40.000,
        TextStrokeColor3 = Color3.fromRGB(43, 23, 14),
        TextWrapped = true
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Title",
        Parent = Notification.Content.Top,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(1, -12, 1, 0),
        FontFace = GetFont("BoldAkronim"),
        Text = Configs.Title,
        TextSize = 14.000,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }))
    AddThemeObject("Secondary", Create("Frame", {
        Name = "AntiRound",
        Parent = Notification.Content.Top,
        BackgroundColor3 = Color3.fromRGB(75, 61, 52),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.856250763, 0),
        Size = UDim2.new(1, 0, 0.143749237, 0)
    }))
    TS:Create(Notification.Content, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()
	wait(Configs.Time)
	TS:Create(Notification.Content, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {
		Position = UDim2.new(1.25, 0, 0, 0)
	}):Play()
	wait(0.65)
	Notification:Destroy()
	end)
end

function AkrionLib:MakeWindow(Configs)
    Akrion = Create("ScreenGui", {
        Name = "Akrion",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1,
        ResetOnSpawn = false
    })
    SetupGui(Akrion)
    Messages = Create("ScrollingFrame", {
        Name = "Messages",
        Parent = Akrion,
        Active = false,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(1, 0, 0, -25),
        Selectable = false,
        Size = UDim2.new(0, 275, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingEnabled = false
    })
    Create("UIListLayout", {
        Parent = Messages,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 5)
    })
    Create("UIPadding", {
        Parent = Messages,
        PaddingRight = UDim.new(0, 25)
    })
    local Menu = AddThemeObject("Primary", Create("Frame", {
        Name = "Menu",
        Parent = Akrion,
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.524999976, 0, 0.449999988, 0),
        ZIndex = 2
    }))
    Create("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(204, 204, 204)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(204, 204, 204)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
        Offset = Vector2.new(0.0299999993, 0),
        Rotation = 45,
        Parent = Menu
    })
    Create("UISizeConstraint", {
        Parent = Menu,
        MaxSize = Vector2.new(550, 350)
    })
    Create("UIScale", {
        Parent = Menu,
        Scale = 1.050
    })
    local Main = AddThemeObject("Primary", Create("Frame", {
        Name = "Main",
        Parent = Menu,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(121, 98, 84),
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2
    }))
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Main
    })
    local Shadow = Create("Frame", {
        Name = "Shadow",
        Parent = Menu,
        BackgroundTransparency = 3.000,
        Size = UDim2.new(1, 0, 1, 0)
    })
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.860,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.880,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.880,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    local Body = Create("Frame", {
        Name = "Body",
        Parent = Main,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0.879999995, 0)
    })
    local Top = AddThemeObject("Secondary", Create("Frame", {
        Name = "Top",
        Parent = Main,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40)
    }))
    MakeDraggable(Top, Menu)
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Top
    })
    AddThemeObject("Secondary", Create("Frame", {
        Parent = Top,
        AnchorPoint = Vector2.new(0, 1),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    }))
    local Right = Create("Frame", {
        Name = "Right",
        Parent = Top,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        ZIndex = 2
    })
    Create("UIAspectRatioConstraint", {
        Parent = Right
    })
    local Close = AddThemeObject("TextDark", Create("TextButton", {
        Name = "Close",
        Parent = Right,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.65, 0, 0.65, 0),
        Text = "",
        TextSize = 40.000
    }))
    AddThemeObject("TextDark", Create("TextLabel", {
        Name = "Detail",
        Parent = Right,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1.05, 0),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "x",
        TextSize = 40.000,
        TextWrapped = true
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Detail",
        Parent = Right.Detail,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "x",
        TextSize = 40.000,
        TextWrapped = true
    }))
    local TabTitle = AddThemeObject("TextDark", Create("TextLabel", {
        Name = "Title",
        Parent = Top,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 0, 0.699999988, 0),
        Size = UDim2.new(0.800000012, 0, 0.899999976, 0),
        ZIndex = 2,
        FontFace = GetFont("Akronim"),
        Text = "Home",
        TextScaled = true,
        TextSize = 30.000,
        TextWrapped = true
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Detail",
        Parent = TabTitle,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "Home",
        TextScaled = true,
        TextSize = 30.000,
        TextWrapped = true
    }))
    local Left = Create("Frame", {
        Name = "Left",
        Parent = Top,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Size = UDim2.new(0, 100, 1, 0),
        ZIndex = 2
    })
    Create("UIAspectRatioConstraint", {
        Parent = Left
    })
    local TabOpenButton = Create("TextButton", {
        Name = "Tab",
        Parent = Left,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Text = "",
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.65, 0, 0.65, 0),
    })
    AddThemeObject("TextDark", Create("TextLabel", {
        Name = "Detail",
        Parent = Left,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.600000024, 0),
        Size = UDim2.new(0.5, 0, 0.5, 0),
        FontFace = GetFont("Akronim"),
        Text = "=",
        TextSize = 40.000
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Detail",
        Parent = Left.Detail,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "=",
        TextSize = 40.000,
        TextWrapped = true
    }))
    local Tab = AddThemeObject("Secondary", Create("Frame", {
        Name = "Tab",
        Parent = Main,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(-0.300000012, 0, 1, 0),
        Size = UDim2.new(0.300000012, 0, 1, 0),
        ZIndex = 2
    }))
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Tab
    })
    AddThemeObject("Secondary", Create("Frame", {
        Name = "Main",
        Parent = Tab,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2
    }))
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Tab.Main
    })
    local Shadow = AddThemeObject("Secondary", Create("Frame", {
        Name = "Shadow",
        Parent = Tab,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1
    }))
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.860,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.880,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    Create("ImageLabel", {
        Parent = Shadow,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.new(1, 4, 1, 4),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.880,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })
    Create("Frame", {
        Name = "List",
        Parent = Tab.Main,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 5.000,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 1, -46),
        ZIndex = 3
    })
    Create("UIListLayout", {
        Parent = Tab.Main.List,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Create("Frame", {
        Name = "Top",
        Parent = Tab.Main,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 5.000,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 2
    })
    AddThemeObject("Divider", Create("Frame", {
        Name = "Detail",
        Parent = Tab.Main.Top,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1)
    }))
    Create("Frame", {
        Name = "Left",
        Parent = Tab.Main.Top,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 15.000,
        Size = UDim2.new(0, 100, 1, 0)
    })
    Create("UIAspectRatioConstraint", {
        Parent = Tab.Main.Top.Left
    })
    local TabCloseButton = AddThemeObject("TextDark", Create("TextButton", {
        Name = "Close",
        Parent = Tab.Main.Top.Left,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0.520238221, 0, 0.537499905, 0),
        Size = UDim2.new(0.840475798, 0, 0.724999905, 0),
        ZIndex = 2,
        FontFace = GetFont("Akronim"),
        Text = "",
        TextSize = 40.000,
        TextTransparency = 1.000
    }))
    AddThemeObject("TextDark", Create("TextLabel", {
        Name = "Arrow",
        Parent = Tab.Main.Top.Left,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.5, 0, 0.649999976, 0),
        Size = UDim2.new(0.5, 0, 0.5, 0),
        FontFace = GetFont("Akronim"),
        Text = "<",
        TextSize = 40.00
    }))
    AddThemeObject("Text", Create("TextLabel", {
        Name = "Detail",
        Parent = Tab.Main.Top.Left.Arrow,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = GetFont("Akronim"),
        Text = "<",
        TextSize = 40.000,
        TextWrapped = true
    }))

    --// Functions
    Connect(Close.MouseButton1Click, function()
        Menu.Visible = false
        AkrionLib.Hidden = true
    end)
    Connect(TabOpenButton.MouseButton1Click, function()
        TS:Create(Tab.Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Position = UDim2.new(1, 0, 1, 0)}):Play()
        TS:Create(Tab.Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Position = UDim2.new(1, 0, 1, 0)}):Play()
    end)
    Connect(TabCloseButton.MouseButton1Click, function()
        TS:Create(Tab.Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Position = UDim2.new(0, 0, 1, 0)}):Play()
        TS:Create(Tab.Main, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Position = UDim2.new(0, 0, 1, 0)}):Play()
    end)

    local WindowFunction = {}
    function WindowFunction:MakeTab(Configs)
        Configs = Configs or {}
        Configs.Name = Configs.Name or "Name"
        local TabContentButton = Create("TextButton", {
            Name = Configs.Name,
            Parent = Tab.Main.List,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 5.000,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 0.100000001, 0),
            FontFace = GetFont("Akronim"),
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = 14.000
        })
        AddThemeObject("Text", Create("TextLabel", {
            Name = "Detail",
            Parent = TabContentButton,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 10.000,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.9, 0, 0.45, 0),
            FontFace = GetFont("BoldAkronim"),
            Text = Configs.Name,
            TextScaled = true,
            TextSize = 14.000,
            TextStrokeTransparency = 0.600,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        }))
        local TabContent = Create("ScrollingFrame", {
            Name = Configs.Name,
            Parent = Body,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1.000,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Selectable = false,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageTransparency = 0.5,
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        })
        local TabFunction = {}
        local Items = 0
        if #AkrionTable.Tabs == 0 then
            function TabFunction:AddThemeButton(Theme)
                Theme = Theme or AkrionLib.SelectedTheme
                if not AkrionLib.Themes[Theme] then
                    return
                end
                Items = Items + 1
                TabContent.CanvasSize = UDim2.new(0, 0, 0, 24+125+(55*Items))
                local Button = Create("TextButton", {
                    Name = Theme,
                    Parent = TabContent,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1.000,
                    ClipsDescendants = true,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 50),
                    AutoButtonColor = false,
                    Text = ""
                })
                local Main = Create("Frame", {
                    Name = "Main",
                    Parent = Button,
                    BackgroundColor3 = AkrionLib.Themes[Theme].Secondary,
                    AnchorPoint = Vector2.new(0.5, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(1, -48, 1, 0)
                })
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Main
                })
                AddThemeObject("Divider", Create("Frame", {
                    Name = "Accent",
                    Parent = Main,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -1),
                    Size = UDim2.new(1, 0, 0, 1)
                }))
                Create("Frame", {
                    Name = "Info",
                    Parent = Main,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1.000,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -16, 1, 0)
                })
                Create("UIListLayout", {
                    Parent = Main.Info,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })
                Create("TextLabel", {
                    Name = "Title",
                    Parent = Main.Info,
                    BackgroundTransparency = 1.000,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 18),
                    FontFace = GetFont("BoldAkronim"),
                    Text = Theme,
                    TextSize = 16.000,
                    TextColor3 = AkrionLib.Themes[Theme].Text,
                    TextStrokeColor3 = Color3.fromRGB(31, 31, 31),
                    TextStrokeTransparency = 0.500,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                Create("TextLabel", {
                    Name = "Description",
                    Parent = Main.Info,
                    BackgroundTransparency = 1.000,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 14),
                    FontFace = GetFont("BoldAkronim"),
                    Text = string.format("Selects %s as your selected theme", Theme),
                    TextColor3 = AkrionLib.Themes[Theme].Text,
                    TextSize = 13.000,
                    TextStrokeColor3 = Color3.fromRGB(31, 31, 31),
                    TextStrokeTransparency = 0.500,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                Connect(Button.MouseButton1Click, function()
                    if Theme ~= AkrionLib.SelectedTheme then
                        AkrionLib.SelectedTheme = Theme
                        TabContent.User.Image = AkrionLib.Themes[AkrionLib.SelectedTheme].User
                        SetTheme()
                    end
                end)
                Connect(Button.MouseEnter, function()
                    if Theme ~= AkrionLib.SelectedTheme then
                        TabContent.User.Image = AkrionLib.Themes[Theme].User
                        SetTheme(Theme)
                    end
                end)
                Connect(Button.MouseLeave, function()
                    if Theme ~= AkrionLib.SelectedTheme then
                        TabContent.User.Image = AkrionLib.Themes[AkrionLib.SelectedTheme].User
                        SetTheme()
                    end
                end)
            end
            TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            TabTitle.Text = Configs.Name
            TabTitle.Detail.Text = Configs.Name
            Create("ImageLabel", {
                Name = "User",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                Size = UDim2.new(1, 0, 0, 125),
                Image = AkrionLib.Themes[AkrionLib.SelectedTheme].User,
                ScaleType = Enum.ScaleType.Crop
            })
            Create("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.20), NumberSequenceKeypoint.new(1.00, 1.00)},
                Parent = TabContent.User
            })
            AddThemeObject("Secondary", Create("ImageLabel", {
                Name = "Avatar",
                Image = Players:GetUserThumbnailAsync(Plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
                Parent = TabContent.User,
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 0.700,
                Position = UDim2.new(0.5, 0, 0.0500000007, 0),
                Size = UDim2.new(0, 70, 0, 70)
            }))
            Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = TabContent.User.Avatar
            })
            AddThemeObject("TextDark", Create("TextLabel", {
                Name = "Username",
                Parent = TabContent.User,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                Position = UDim2.new(0.5, 0, 0.825, 0),
                Size = UDim2.new(0.5, 0, 0.35, 0),
                FontFace = GetFont("Akronim"),
                Text = string.format("%s (@%s)", Plr.DisplayName, Plr.Name),
                TextScaled = true,
                TextSize = 32.000,
                TextWrapped = true
            }))
            AddThemeObject("Text", Create("TextLabel", {
                Name = "Detail",
                Parent = TabContent.User.Username,
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                Position = UDim2.new(0, 0, 1, -3),
                Size = UDim2.new(1, 0, 1, 0),
                FontFace = GetFont("Akronim"),
                Text = string.format("%s (@%s)", Plr.DisplayName, Plr.Name),
                TextScaled = true,
                TextSize = 30.000,
                TextWrapped = true
            }))
            Create("UIListLayout", {
                Parent = TabContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })
            Create("UIPadding", {
                Parent = TabContent,
                PaddingBottom = UDim.new(0, 0),
            })
        else
            TabContent.Visible = false
            TabContentButton.TextTransparency = 0.2
            TabContentButton.Detail.TextTransparency = 0.2
            Create("UIListLayout", {
                Parent = TabContent,
                SortOrder = Enum.SortOrder.Name,
                Padding = UDim.new(0, 5)
            })
            Create("UIPadding", {
                Parent = TabContent,
                PaddingBottom = UDim.new(0, 120),
                PaddingTop = UDim.new(0, 24)
            })
        end
        Create("UIScale", {
            Parent = TabContent,
        })
        
        --// Functions
        Connect(TabContentButton.MouseButton1Click, function()
            for t=1,#AkrionTable.Tabs do
                if AkrionTable.Tabs[t].Frame == TabContent then
                    AkrionTable.Tabs[t].Frame.Visible = true
                    TabTitle.Text = Configs.Name
                    TabTitle.Detail.Text = Configs.Name
                    TS:Create(AkrionTable.Tabs[t].Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {TextTransparency = 0}):Play()
                    TS:Create(AkrionTable.Tabs[t].Button.Detail, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {TextTransparency = 0}):Play()
                else
                    AkrionTable.Tabs[t].Frame.Visible = false
                    TS:Create(AkrionTable.Tabs[t].Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {TextTransparency = 0.2}):Play()
                    TS:Create(AkrionTable.Tabs[t].Button.Detail, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {TextTransparency = 0.2}):Play()
                end
            end
        end)
        table.insert(AkrionTable.Tabs, {
            ["Button"] = TabContentButton, 
            ["Frame"] = TabContent
        })
        function TabFunction:AddBlank()
            Items = Items + 1
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 48 + (55*Items))
            local Button = Create("TextButton", {
                Name = "",
                Parent = TabContent,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1.000,
                ClipsDescendants = true,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 50),
                AutoButtonColor = false,
                Text = ""
            })
        end
        function TabFunction:AddButton(Configs)
            Items = Items + 1
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 48 + (55*Items))
            Configs = Configs or {}
            Configs.Title = Configs.Title or "Name"
            Configs.Description = Configs.Description or "Description"
            Configs.Search = Configs.Search or "Search"
            Configs.Url = Configs.Url or ""
            Configs.Callback = Configs.Callback or function() print("Callback") end
            
            local Button = Create("TextButton", {
                Name = Configs.Search,
                Parent = TabContent,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1.000,
                ClipsDescendants = true,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 50),
                AutoButtonColor = false,
                Text = ""
            })
            local Main = AddThemeObject("Secondary", Create("Frame", {
                Name = "Main",
                Parent = Button,
                AnchorPoint = Vector2.new(0.5, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, -48, 1, 0)
            }))
            Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Main
            })
            AddThemeObject("Divider", Create("Frame", {
                Name = "Accent",
                Parent = Main,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -1),
                Size = UDim2.new(1, 0, 0, 1)
            }))
            Create("Frame", {
                Name = "Info",
                Parent = Main,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -16, 1, 0)
            })
            Create("UIListLayout", {
                Parent = Main.Info,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            AddThemeObject("Text", Create("TextLabel", {
                Name = "Title",
                Parent = Main.Info,
                BackgroundTransparency = 1.000,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 18),
                FontFace = GetFont("BoldAkronim"),
                Text = Configs.Title,
                TextSize = 16.000,
                TextStrokeColor3 = Color3.fromRGB(31, 31, 31),
                TextStrokeTransparency = 0.500,
                TextXAlignment = Enum.TextXAlignment.Left
            }))
            AddThemeObject("Text", Create("TextLabel", {
                Name = "Description",
                Parent = Main.Info,
                BackgroundTransparency = 1.000,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 14),
                FontFace = GetFont("BoldAkronim"),
                Text = Configs.Description,
                TextSize = 13.000,
                TextStrokeColor3 = Color3.fromRGB(31, 31, 31),
                TextStrokeTransparency = 0.500,
                TextXAlignment = Enum.TextXAlignment.Left,
            }))
            Connect(Button.MouseButton1Click, Configs.Callback)
        end
        return TabFunction
    end
    local Home = WindowFunction:MakeTab({Name = "Home"})
    for c=1,5 do Home:AddBlank(theme) end
    for theme,_ in pairs(AkrionLib.Themes) do
        Home:AddThemeButton(theme)
    end
    Connect(UIS.InputBegan, function(Input)
		if Input.KeyCode == Enum.KeyCode.RightShift then
			Menu.Visible = AkrionLib.Hidden
			AkrionLib.Hidden = not AkrionLib.Hidden
		end
	end)
    return WindowFunction
end
return AkrionLib
