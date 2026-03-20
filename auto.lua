if _G.AutoRankStarted then return end
_G.AutoRankStarted = true

local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Library = ReplicatedStorage:WaitForChild("Library")
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local ZoneCmds = require(Library.Client.ZoneCmds)
local RebirthCmds = require(Library.Client.RebirthCmds)
local MapCmds = require(Library.Client.MapCmds)

-- Hack Tốc độ chạy (Lấy từ script cũ của bạn)
pcall(function()
    require(Library.Client.PlayerPet).CalculateSpeedMultiplier = function(...)
        return 200
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function() 
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new()) 
end)

--====================================================================--
--//                     UI: AUTO RANK DASHBOARD                    //--
--====================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoRankUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local FullscreenBG = Instance.new("Frame")
FullscreenBG.Size = UDim2.new(1, 0, 1, 0)
FullscreenBG.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
FullscreenBG.BorderSizePixel = 0
FullscreenBG.Parent = ScreenGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(1, -20, 1, -20)
ToggleBtn.AnchorPoint = Vector2.new(1, 1)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 255, 180)
ToggleBtn.Text = "👁"
ToggleBtn.TextSize = 25
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

local uiVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    FullscreenBG.Visible = uiVisible
    ToggleBtn.Text = uiVisible and "👁" or "🙈"
    ToggleBtn.BackgroundColor3 = uiVisible and Color3.fromRGB(30, 255, 180) or Color3.fromRGB(255, 80, 80)
end)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 600, 0.8, 0)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundTransparency = 1
Container.Parent = FullscreenBG

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Container

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "🌟 HASTY AUTO RANK 🌟"
TitleLabel.TextColor3 = Color3.fromRGB(30, 255, 180)
TitleLabel.TextSize = 40
TitleLabel.Parent = Container

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "Status: Starting..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18
StatusLabel.Parent = Container

local QuestsFrame = Instance.new("Frame")
QuestsFrame.Size = UDim2.new(1, 0, 0, 200)
QuestsFrame.BackgroundTransparency = 1
QuestsFrame.Parent = Container
local QuestsLayout = Instance.new("UIListLayout")
QuestsLayout.Padding = UDim.new(0, 8)
QuestsLayout.Parent = QuestsFrame

local QuestLabels = {}
for i = 1, 4 do
    local QLabel = Instance.new("TextLabel")
    QLabel.Size = UDim2.new(1, 0, 0, 25)
    QLabel.BackgroundTransparency = 1
    QLabel.Font = Enum.Font.Gotham
    QLabel.Text = "Loading Quest " .. i .. "..."
    QLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    QLabel.TextSize = 16
    QLabel.Parent = QuestsFrame
    QuestLabels[i] = QLabel
end

--====================================================================--
--//                 PHẦN 1: AUTO WORLD & REBIRTH                   //--
--====================================================================--

-- Hàm tìm Map động (Không cần dùng PlaceId, hỗ trợ tới World 99)
local function GetZonePath(zoneNumber, zoneName)
    local expectedName = tostring(zoneNumber) .. " | " .. zoneName
    -- Quét các thư mục Map hiện có trong Workspace
    for _, folderName in ipairs({"Map", "Map2", "Map3", "Map4", "Map5", "Map6"}) do
        local mapFolder = Workspace:FindFirstChild(folderName)
        if mapFolder then
            local zoneFolder = mapFolder:FindFirstChild(expectedName)
            if zoneFolder then
                return zoneFolder
            end
        end
    end
    return nil
end

local currentZone = ""

-- Hàm dịch chuyển chính xác (Kế thừa từ script của bạn)
local function teleportToMaxZone()
    local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
    if not zoneName or not maxZoneData then return end
    
    if currentZone ~= zoneName then
        currentZone = zoneName
        StatusLabel.Text = "Status: Teleporting to " .. zoneName
        
        local zonePath = GetZonePath(maxZoneData.ZoneNumber, zoneName)
        if zonePath and zonePath:FindFirstChild("PERSISTENT") and zonePath.PERSISTENT:FindFirstChild("Teleport") then
            LocalPlayer.Character:PivotTo(zonePath.PERSISTENT.Teleport.CFrame + Vector3.new(0, 3, 0))
        end
    end
end

-- Vòng lặp Auto World
task.spawn(function()
    local nextRebirthData = RebirthCmds.GetNextRebirth()
    local rebirthNumber = 999
    local rebirthZone = 999
    
    if nextRebirthData then
        rebirthNumber = nextRebirthData.RebirthNumber
        rebirthZone = nextRebirthData.ZoneNumberRequired
    end

    while task.wait(1) do
        pcall(function()
            local nextZoneName, nextZoneData = ZoneCmds.GetNextZone()
            
            -- Nếu có map mới để mua
            if nextZoneName then
                local success = Network.Invoke("Zones_RequestPurchase", nextZoneName)
                if success then
                    StatusLabel.Text = "Status: Purchased " .. nextZoneName
                    
                    -- Kiểm tra xem đủ điều kiện Rebirth chưa
                    if nextZoneData.ZoneNumber >= rebirthZone then
                        StatusLabel.Text = "Status: Rebirthing..."
                        Network.Invoke("Rebirth_Request", tostring(rebirthNumber))
                        task.wait(10) -- Đợi game load
                        
                        -- Cập nhật dữ liệu Rebirth mới
                        nextRebirthData = RebirthCmds.GetNextRebirth()
                        if nextRebirthData then
                            rebirthNumber = nextRebirthData.RebirthNumber
                            rebirthZone = nextRebirthData.ZoneNumberRequired
                        end
                    end
                    teleportToMaxZone()
                end
            end
            
            -- Luôn giữ nhân vật ở Map cao nhất
            teleportToMaxZone()
        end)
    end
end)

--====================================================================--
--//             PHẦN 2: RANK TRACKER & AUTO CLAIM                  //--
--====================================================================--
task.spawn(function()
    while task.wait(1) do
        local data = Save.Get()
        
        -- Auto Claim Quà Rank
        pcall(function()
            for i = 1, 99 do
                Network.Invoke("Rank: Claim Reward", i)
            end
        end)

        -- Hiển thị thông tin Quest
        if data and data.Goals then
            local index = 1
            for goalId, goalData in pairs(data.Goals) do
                if index > 4 then break end
                
                local currentAmt = goalData.Amount or 0
                local targetAmt = goalData.Target or 1
                local goalType = goalData.Type or tostring(goalId)
                
                local percent = math.floor((currentAmt / targetAmt) * 100)
                if percent > 100 then percent = 100 end
                
                local textStr = string.format("📌 [%s] : %d / %d (%d%%)", goalType, currentAmt, targetAmt, percent)
                
                if currentAmt >= targetAmt then
                    QuestLabels[index].TextColor3 = Color3.fromRGB(50, 255, 50)
                    textStr = "✅ " .. goalType .. " - COMPLETED!"
                else
                    QuestLabels[index].TextColor3 = Color3.fromRGB(200, 200, 255)
                end
                
                QuestLabels[index].Text = textStr
                index = index + 1
            end
            
            for i = index, 4 do
                QuestLabels[i].Text = ""
            end
        end
    end
end)
