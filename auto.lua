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
local PetNetworking = require(Library.Client.PetNetworking)

-- Load thư viện theo dõi biến
local function loadUtils(url, file)
    local path = "Hasty-Utils/" .. file
    local ok, res = pcall(game.HttpGet, game, url)
    if ok and res then
        if not isfolder("Hasty-Utils") then makefolder("Hasty-Utils") end
        writefile(path, res)
        return loadstring(res)()
    end
    return loadstring(readfile(path))()
end
local vm = loadUtils("https://raw.githubusercontent.com/Paule1248/Open-Source/refs/heads/main/Utils/VariablesManager", "VariablesManager.lua")
vm = vm:new()

vm:Add("AllBreakables", {}, "table")
vm:Add("Euids", {}, "table")
vm:Add("LastUseEuids", {}, "table")
vm:Add("PetIDs", {}, "table")
vm:Add("current_zone", nil, "string")

-- Hack Tốc độ chạy & Anti-AFK
pcall(function() require(Library.Client.PlayerPet).CalculateSpeedMultiplier = function(...) return 200 end end)
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

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
--//             PHẦN 1: QUẢN LÝ DỮ LIỆU & NHẶT ĐỒ THÔNG MINH       //--
--====================================================================--
-- 1.1 Quản lý rương (Tạo & Xóa)
local function onBreakablesDestroyed(data)
    if type(data) == "string" then vm:TableSet("AllBreakables", data, nil)
    elseif type(data) == "table" then for _, v in pairs(data) do vm:TableSet("AllBreakables", v[1], nil) end end
end
local function onBreakablesCreated(data)
    for _, v in pairs(data) do
        if v[1] and v[1].u then vm:TableSet("AllBreakables", tostring(v[1].u), v[1]) end
    end
end
Network.Fired("Breakables_Created"):Connect(onBreakablesCreated)
Network.Fired("Breakables_Ping"):Connect(onBreakablesCreated)
Network.Fired("Breakables_Destroyed"):Connect(onBreakablesDestroyed)
Network.Fired("Breakables_DestroyDueToReplicationFail"):Connect(onBreakablesDestroyed)
Network.Fired("Breakables_Cleanup"):Connect(function(data) for _, v in pairs(data) do vm:TableSet("AllBreakables", tostring(v[1]), nil) end end)

-- 1.2 Quản lý Thú cưng
local function updateEuids()
    if type(PetNetworking.EquippedPets()) ~= "table" then return end
    vm:TableClear("Euids"); vm:TableClear("PetIDs")
    for petID, petData in pairs(PetNetworking.EquippedPets()) do
        vm:TableSet("Euids", petID, petData); vm:TableInsert("PetIDs", petID)
    end
end
updateEuids()
Network.Fired("Pets_LocalPetsUpdated"):Connect(updateEuids)
Network.Fired("Pets_LocalPetsUnequipped"):Connect(updateEuids)

-- 1.3 Auto Nhặt Lootbags & Orbs (Kế thừa siêu tốc từ code cũ)
local THINGS = Workspace:WaitForChild("__THINGS")
local LootbagsFolder = THINGS:FindFirstChild("Lootbags")
if LootbagsFolder then
    LootbagsFolder.ChildAdded:Connect(function(bag)
        task.wait()
        if bag then
            Network.Fire("Lootbags_Claim", { bag.Name })
            bag:Destroy()
        end
    end)
end
local OrbsFolder = THINGS:FindFirstChild("Orbs")
if OrbsFolder then
    OrbsFolder.ChildAdded:Connect(function(orb)
        task.wait()
        if orb then
            Network.Fire("Orbs: Collect", { tonumber(orb.Name) })
            orb:Destroy()
        end
    end)
end

--====================================================================--
--//                 PHẦN 2: AUTO WORLD & REBIRTH                   //--
--====================================================================--
-- Tìm Map tự động hỗ trợ tới World 99
local function GetZonePath(zoneNumber, zoneName)
    local expectedName = tostring(zoneNumber) .. " | " .. zoneName
    for _, folderName in ipairs({"Map", "Map2", "Map3", "Map4", "Map5", "Map6"}) do
        local mapFolder = Workspace:FindFirstChild(folderName)
        if mapFolder then
            local zoneFolder = mapFolder:FindFirstChild(expectedName)
            if zoneFolder then return zoneFolder end
        end
    end
    return nil
end

local currentZone = ""

-- Dịch chuyển dùng BREAK_ZONES (Lấy từ script cũ)
local function teleportToMaxZone()
    local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
    if not zoneName or not maxZoneData then return end
    
    if currentZone ~= zoneName then
        currentZone = zoneName
        vm:Set("current_zone", currentZone)
        StatusLabel.Text = "Status: Teleporting to " .. zoneName
        
        local zonePath = GetZonePath(maxZoneData.ZoneNumber, zoneName)
        if zonePath then
            -- Bước 1: Dịch chuyển ra cổng map để nạp dữ liệu rương (Load map)
            if zonePath:FindFirstChild("PERSISTENT") and zonePath.PERSISTENT:FindFirstChild("Teleport") then
                LocalPlayer.Character:PivotTo(zonePath.PERSISTENT.Teleport.CFrame + Vector3.new(0, 5, 0))
                task.wait(0.5)
            end
            
            -- Bước 2: Tìm bãi đập rương (BREAK_ZONES) và bay vào giữa bãi
            local interact = zonePath:WaitForChild("INTERACT", 3)
            if interact then
                local breakZones = interact:WaitForChild("BREAK_ZONES", 3)
                if breakZones then
                    local dist = math.huge
                    local closestZone = nil
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, v in pairs(breakZones:GetChildren()) do
                            local mag = (hrp.Position - v.Position).Magnitude
                            if mag < dist then
                                dist = mag
                                closestZone = v
                            end
                        end
                        if closestZone then
                            LocalPlayer.Character:PivotTo(closestZone.CFrame + Vector3.new(0, 10, 0))
                        end
                    end
                end
            end
        end
    end
end

-- Vòng lặp Mua Map / Rebirth
task.spawn(function()
    local nextRebirthData = nil
    pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end)
    local rebirthNumber = nextRebirthData and nextRebirthData.RebirthNumber or 999
    local rebirthZone = nextRebirthData and nextRebirthData.ZoneNumberRequired or 999

    while task.wait(1) do
        pcall(function()
            local nextZoneName, nextZoneData = ZoneCmds.GetNextZone()
            if nextZoneName then
                local success = Network.Invoke("Zones_RequestPurchase", nextZoneName)
                if success then
                    StatusLabel.Text = "Status: Purchased " .. nextZoneName
                    if nextZoneData.ZoneNumber >= rebirthZone then
                        StatusLabel.Text = "Status: Rebirthing..."
                        Network.Invoke("Rebirth_Request", tostring(rebirthNumber))
                        task.wait(10)
                        pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end)
                        rebirthNumber = nextRebirthData and nextRebirthData.RebirthNumber or 999
                        rebirthZone = nextRebirthData and nextRebirthData.ZoneNumberRequired or 999
                    end
                    teleportToMaxZone()
                end
            end
            teleportToMaxZone()
        end)
    end
end)

--====================================================================--
--//                   PHẦN 3: NÃO ĐIỀU KHIỂN PET & TAP             //--
--====================================================================--
task.spawn(function()
    local breakableOffset = 0
    while true do
        task.wait()
        local zone = vm:Get("current_zone")
        if not zone then continue end

        local availableBreakables = {}
        for key, info in pairs(vm:Get("AllBreakables")) do
            if info.pid == zone then table.insert(availableBreakables, key) end
        end

        if #availableBreakables > 0 then
            local now = os.clock()
            local lastUseEuids = vm:Get("LastUseEuids")
            local bulkAssignments = {}
            local firstTarget = nil -- Dùng để Auto Tap

            for i, petID in ipairs(vm:Get("PetIDs")) do
                if vm:Get("Euids")[petID] then
                    local pool = availableBreakables
                    local assignedKey = pool[((i - 1 + breakableOffset) % #pool) + 1]
                    bulkAssignments[petID] = assignedKey
                    vm:TableSet("LastUseEuids", petID, { time = now, breakableKey = assignedKey })
                    
                    if not firstTarget then firstTarget = assignedKey end
                end
            end

            if next(bulkAssignments) then
                -- Ném Pet ra farm
                task.spawn(function() Network.Fire("Breakables_JoinPetBulk", bulkAssignments) end)
                
                -- Auto Tap (Nhân vật chưởng/click phụ thú cưng)
                if firstTarget then
                    task.spawn(function() Network.UnreliableFire("Breakables_PlayerDealDamage", firstTarget) end)
                end
                
                task.wait(0.1) -- Tốc độ cào rương cực nhanh
            end
            breakableOffset = breakableOffset + 1
        else
            vm:Set("current_zone", nil); breakableOffset = 0
        end
    end
end)

--====================================================================--
--//             PHẦN 4: RANK TRACKER & AUTO CLAIM                  //--
--====================================================================--
task.spawn(function()
    while task.wait(1) do
        local data = Save.Get()
        
        -- Auto Claim Quà Rank
        pcall(function()
            for i = 1, 99 do Network.Invoke("Rank: Claim Reward", i) end
        end)

        -- Đọc Quest
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
            
            for i = index, 4 do QuestLabels[i].Text = "" end
        else
            QuestLabels[1].Text = "Waiting for Quest Data..."
        end
    end
end)
