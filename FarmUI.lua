local FarmUI = {}
FarmUI.__index = FarmUI

function FarmUI.new(Config)
	local Self = setmetatable({}, FarmUI)
	Self.Player = game.Players.LocalPlayer
	Self.GuiName = "PiraFullscreenGui"
	Self.Elements = {}
	Self.Parent = game:GetService("CoreGui")
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = Self.GuiName
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = Self.Parent
	ScreenGui.ResetOnSpawn = false
	Self.ScreenGui = ScreenGui

	local Background = Instance.new("Frame")
	Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Background.BorderColor3 = Color3.fromRGB(255, 0, 255)
	Background.BorderMode = Enum.BorderMode.Inset
	Background.Parent = ScreenGui
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.AnchorPoint = Vector2.new(0.5, 0.5)

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.BackgroundTransparency = 1
	Container.Parent = Background
	Self.Container = Container

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0.015, 0)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.VerticalAlignment = Enum.VerticalAlignment.Center
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Container

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(1, -20, 1, -20)
    ToggleBtn.AnchorPoint = Vector2.new(1, 1)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ToggleBtn.Text = "👁"
    ToggleBtn.TextSize = 22
    ToggleBtn.Parent = ScreenGui
    
    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(1, 0)
    UICornerBtn.Parent = ToggleBtn
    
    local UIStrokeBtn = Instance.new("UIStroke")
    UIStrokeBtn.Color = Color3.fromRGB(255, 0, 255)
    UIStrokeBtn.Thickness = 2
    UIStrokeBtn.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        Background.Visible = not Background.Visible
        ToggleBtn.Text = Background.Visible and "👁" or "🙈"
    end)

	local Sorted = {}
	for Name, Data in pairs(Config.UI) do table.insert(Sorted, {Name = Name, Order = Data[1], Text = Data[2], Size = Data[3]}) end
	table.sort(Sorted, function(A, B) return A.Order < B.Order end)

	for Index, Item in ipairs(Sorted) do
		local Label = Instance.new("TextLabel")
		Label.Name = Item.Name
		Label.LayoutOrder = Item.Order
		Label.Size = Item.Size and UDim2.new(unpack(Item.Size)) or UDim2.new(0.6, 0, 0.045, 0)
		Label.BackgroundTransparency = 1
		Label.Font = Enum.Font.FredokaOne
		Label.Text = Item.Text
		Label.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label.TextScaled = true
		Label.Parent = Self.Container
		Self.Elements[Item.Name] = Label

		if Index < #Sorted then
			local Spacer = Instance.new("Frame")
			Spacer.LayoutOrder = Item.Order + 0.5
			Spacer.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
			Spacer.Size = UDim2.new(0.4, 0, 0, 2)
			Spacer.Parent = Self.Container
		end
	end
	return Self
end

function FarmUI:SetText(Name, Text) 
    if self.Elements[Name] then 
        task.defer(function() self.Elements[Name].Text = Text end)
    end 
end
function FarmUI:Format(Int)
	local Index = 1; local Suffix = {"", "K", "M", "B", "T"}
	while Int >= 1000 and Index < #Suffix do Int = Int / 1000; Index = Index + 1 end
	if Index == 1 then return string.format("%d", Int) end
	return string.format("%.2f%s", Int, Suffix[Index])
end

return FarmUI -- TRẢ VỀ THƯ VIỆN KHI ĐƯỢC LOAD
