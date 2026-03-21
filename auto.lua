if _G.AutoRankStarted then return end
_G.AutoRankStarted = true

local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Library = ReplicatedStorage:WaitForChild("Library")
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local ZoneCmds = require(Library.Client.ZoneCmds)
local RebirthCmds = require(Library.Client.RebirthCmds)
local PetNetworking = require(Library.Client.PetNetworking)
local RankCmds = require(Library.Client.RankCmds)
local RanksDirectory = require(Library.Directory.Ranks)

-- FIX LỖI "THREAD CANNOT ACCESS INSTANCE" CỦA CODEX TẠI ĐÂY
local function loadUtils(url, file)
    local path = "Hasty-Utils/" .. file
    -- Thay đổi cách gọi HttpGet để Codex không bị lỗi luồng
    local ok, res = pcall(function() return game:HttpGet(url) end) 
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
vm:Add("NeedToFarmBreakables", false, "boolean")

_G.PreparingToHop = false -- CÔNG TẮC NGẮT ĐIỆN TOÀN TẬP

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

local THINGS = Workspace:WaitForChild("__THINGS")
local LootbagsFolder = THINGS:FindFirstChild("Lootbags")
if LootbagsFolder then
    LootbagsFolder.ChildAdded:Connect(function(bag)
        task.wait()
        if bag then Network.Fire("Lootbags_Claim", { bag.Name }); bag:Destroy() end
    end)
end
local OrbsFolder = THINGS:FindFirstChild("Orbs")
if OrbsFolder then
    OrbsFolder.ChildAdded:Connect(function(orb)
        task.wait()
        if orb then Network.Fire("Orbs: Collect", { tonumber(orb.Name) }); orb:Destroy() end
    end)
end

--====================================================================--
--//        PHẦN 2: AUTO WORLD & PURE SERVER HOP (V15 - CHUẨN LOGIC)  //--
--====================================================================--
--====================================================================--
--//        CẬP NHẬT: TỰ TÌM CỔNG NGOÀI ZONE & NEO VỊ TRÍ           //--
--====================================================================--

local function GoToWorldPortal()
    -- Vì cổng nằm ngoài Zone, ta tìm trong Workspace.__THINGS hoặc Map chung
    local portalPath = nil
    pcall(function()
        -- Tìm các object có tên liên quan đến Portal hoặc Travel
        for _, v in pairs(Workspace:GetChildren()) do
            if string.find(v.Name, "Portal") or string.find(v.Name, "Travel") then
                portalPath = v
                break
            end
        end
    end)

    if portalPath then
        StatusLabel.Text = "Status: Moving to Portal..."
        LocalPlayer.Character:PivotTo(portalPath.WorldPivot + Vector3.new(0, 5, 0))
        task.wait(1)
        -- Gửi lệnh xác nhận "Yes" như trong ảnh bạn gửi
        -- Lưu ý: Bạn có thể cần kiểm tra tên Remote chính xác của game
        pcall(function() Network.Invoke("Travel_ToNextWorld") end) 
    else
        StatusLabel.Text = "Status: Portal not found, checking UI..."
    end
end

-- Biến kiểm tra vị trí để neo nhân vật
local lastPosUpdate = os.clock()
local centerPoint = nil

task.spawn(function()
    while task.wait(1) do
        if _G.PreparingToHop then break end 
        
        pcall(function()
            local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone() [cite: 34]
            if not zoneName or not maxZoneData then return end
            
            -- 1. KIỂM TRA ĐIỀU KIỆN QUA WORLD MỚI (Dựa trên số Zone cuối)
            if (maxZoneData.ZoneNumber == 99 or maxZoneData.ZoneNumber == 199 or maxZoneData.ZoneNumber == 239) then
                GoToWorldPortal()
                task.wait(5)
            end

            -- 2. TÁI SINH (REBIRTH) VÀ ĐỢI 5 GIÂY
            local nextRebirthData = nil
            pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end) [cite: 35]

            if nextRebirthData and maxZoneData.ZoneNumber >= nextRebirthData.ZoneNumberRequired then
                StatusLabel.Text = "Status: Rebirthing in 5s..."
                task.wait(5) -- Đợi 5s đúng ý bạn [cite: 26]
                Network.Invoke("Rebirth_Request", tostring(nextRebirthData.RebirthNumber)) [cite: 35]
                
                -- Ép nhân vật tìm lại map ngay lập tức
                currentZone = "" [cite: 36]
                vm:Set("current_zone", nil) [cite: 36]
                centerPoint = nil -- Reset điểm neo
                return
            end
            
            -- 3. MUA ZONE & TELEPORT
            local nextZoneName = ZoneCmds.GetNextZone() [cite: 37]
            if nextZoneName then Network.Invoke("Zones_RequestPurchase", nextZoneName) end [cite: 37]
            
            teleportToMaxZone(zoneName, maxZoneData) [cite: 27]

            -- 4. LOGIC GIỮ NHÂN VẬT Ở GIỮA MAP (NEO 10 GIÂY)
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") [cite: 30]
            if hrp then
                -- Lấy điểm giữa của Zone hiện tại làm điểm neo
                if not centerPoint or (currentZone ~= zoneName) then
                    local zonePath = GetZonePath(maxZoneData.ZoneNumber) [cite: 11]
                    if zonePath and zonePath:FindFirstChild("INTERACT") then
                        local bZones = zonePath.INTERACT:FindFirstChild("BREAK_ZONES") [cite: 29]
                        if bZones and bZones:GetChildren()[1] then
                            centerPoint = bZones:GetChildren()[1].CFrame [cite: 32]
                        end
                    end
                end

                -- Kiểm tra nếu rời xa điểm neo quá 10 giây
                if centerPoint then
                    local dist = (hrp.Position - centerPoint.Position).Magnitude [cite: 31]
                    if dist > 15 then -- Nếu lệch quá xa
                        if os.clock() - lastPosUpdate > 10 then
                            StatusLabel.Text = "Status: Returning to Center..."
                            LocalPlayer.Character:PivotTo(centerPoint + Vector3.new(0, 10, 0)) [cite: 32]
                            lastPosUpdate = os.clock()
                        end
                    else
                        lastPosUpdate = os.clock() -- Reset thời gian nếu vẫn ở gần
                    end
                end
            end
        end)
    end
end)
--====================================================================--
--//      PHẦN 3: NÃO ĐIỀU KHIỂN PET (CODEX STABLE FAST FARM)       //--
--====================================================================--
-- Pet tự động tìm mục tiêu (Mượt và an toàn)
task.spawn(function()
    local breakableOffset = 0
    while task.wait(0.2) do -- Delay 0.2s để Codex không bị sặc
        if _G.PreparingToHop or not vm:Get("NeedToFarmBreakables") then continue end
        local zone = vm:Get("current_zone")
        if not zone then continue end

        local availableBreakables = {}
        for key, info in pairs(vm:Get("AllBreakables")) do
            if info.pid == zone then table.insert(availableBreakables, key) end
        end

        if #availableBreakables > 0 then
            local bulkAssignments = {}
            for i, petID in ipairs(vm:Get("PetIDs")) do
                if vm:Get("Euids")[petID] then
                    local assignedKey = availableBreakables[((i - 1 + breakableOffset) % #availableBreakables) + 1]
                    bulkAssignments[petID] = assignedKey
                end
            end

            if next(bulkAssignments) then
                pcall(function() Network.Fire("Breakables_JoinPetBulk", bulkAssignments) end)
            end
            breakableOffset = breakableOffset + 1
        else
            breakableOffset = 0
        end
    end
end)

-- AUTO TAP SIÊU TỐC (CÓ GIỚI HẠN CHỐNG CRASH)
task.spawn(function()
    while task.wait(0.1) do
        if _G.PreparingToHop or not vm:Get("NeedToFarmBreakables") then continue end
        local zone = vm:Get("current_zone")
        if not zone then continue end
        
        local count = 0
        pcall(function()
            for key, info in pairs(vm:Get("AllBreakables")) do
                if info.pid == zone then
                    Network.UnreliableFire("Breakables_PlayerDealDamage", key)
                    count = count + 1
                    -- GIỚI HẠN: Chỉ bắn 15 rương mỗi lần quét để Codex không văng lỗi
                    if count >= 15 then break end 
                end
            end
        end)
    end
end)

--====================================================================--
--//        PHẦN 4: AUTO CLAIM & BỘ NÃO XỬ LÝ NHIỆM VỤ (V6.1)       //--
--====================================================================--
local GoalDictionary = {
    [7] = "Earn %s", 
    [14] = "Collect Potions",
    [15] = "Collect Enchants",
    [21] = "Breakables in Best Area",
    [34] = "Use Tier %s Potions",
    [38] = "Break Comets in Best Area",
    [40] = "Make Golden Pets",
    [42] = "Hatch Legendary+ Pet"
}

local function ToRoman(num)
    local roman = {"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"}
    return roman[tonumber(num)] or tostring(num)
end

local function FormatValue(Value)
    local n = tonumber(Value)
    if not n then return tostring(Value) end
    local suffixes = {"", "k", "m", "b", "t"}
    local index = 1
    local absNumber = math.abs(n)
    while absNumber >= 1000 and index < #suffixes do absNumber = absNumber / 1000; index = index + 1 end
    return (absNumber >= 1 and index > 1) and string.format("%.2f", absNumber):gsub("%.00$", "") .. suffixes[index] or tostring(math.floor(absNumber)) .. suffixes[index]
end

task.spawn(function()
    while task.wait(5) do
        if _G.PreparingToHop then break end
        pcall(function()
            local currentSave = Save.Get()
            local totalStars = 0
            local currentTitle = RankCmds.GetTitle()
            if RanksDirectory[currentTitle] and RanksDirectory[currentTitle].Rewards then
                for i, v in pairs(RanksDirectory[currentTitle].Rewards) do
                    totalStars = totalStars + v.StarsRequired
                    if currentSave.RankStars >= totalStars and not currentSave.RedeemedRankRewards[tostring(i)] then
                        Network.Fire("Ranks_ClaimReward", i)
                        task.wait(0.5)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.PreparingToHop then break end
        local data = Save.Get()
        
        if data and data.Goals then
            local index = 1
            local needToFarm = false
            
            for goalId, goalData in pairs(data.Goals) do
                if index > 4 then break end
                
                local typeId = goalData.Type
                local currentAmt = goalData.Progress or 0
                local targetAmt = goalData.Amount or 1
                local requiredTier = goalData.PotionTier or goalData.Tier or 1
                
                local goalName = "Unknown Quest ID: " .. tostring(typeId)
                if typeId == 7 then goalName = string.format("Earn %s", tostring(goalData.CurrencyID or "Coins"))
                elseif typeId == 34 then goalName = string.format("Use Tier %s Potions", ToRoman(requiredTier))
                elseif GoalDictionary[typeId] then goalName = GoalDictionary[typeId] end

                if currentAmt < targetAmt then
                    if typeId == 21 or typeId == 38 or typeId == 14 or typeId == 15 then needToFarm = true end
                    
                    if typeId == 38 then
                        local lastProgress = vm:Get("CometProg_" .. goalId) or -1
                        local lastTime = vm:Get("CometTime_" .. goalId) or 0
                        if currentAmt ~= lastProgress or (os.clock() - lastTime > 30) then
                            local cometUid = nil
                            if data.Inventory then
                                for _, categoryData in pairs(data.Inventory) do
                                    if type(categoryData) == "table" then
                                        for uid, item in pairs(categoryData) do
                                            if type(item.id) == "string" and string.find(string.lower(item.id), "comet") then cometUid = uid break end
                                        end
                                    end
                                    if cometUid then break end
                                end
                            end
                            if cometUid then
                                vm:Set("CometProg_" .. goalId, currentAmt)
                                vm:Set("CometTime_" .. goalId, os.clock())
                                task.spawn(function()
                                    pcall(function() Network.Invoke("Consume Item", cometUid) end)
                                    pcall(function() Network.Invoke("Items: Consume", cometUid, 1) end)
                                end)
                            end
                        end
                    end

                    if typeId == 34 then
                        local neededToDrink = targetAmt - currentAmt
                        if not vm:Get("IsDrinking_" .. goalId) then
                            vm:Set("IsDrinking_" .. goalId, true)
                            task.spawn(function()
                                local targetUid = nil
                                if data.Inventory and data.Inventory.Potion then
                                    for uid, item in pairs(data.Inventory.Potion) do
                                        if item.tn == requiredTier then targetUid = uid break end
                                    end
                                end
                                if targetUid then
                                    for i = 1, neededToDrink do
                                        pcall(function() Network.Invoke("Consume Item", targetUid) end)
                                        pcall(function() Network.Invoke("Potions: Consume", targetUid, 1) end)
                                        task.wait(0.2) 
                                    end
                                end
                                task.wait(3) 
                                vm:Set("IsDrinking_" .. goalId, false)
                            end)
                        end
                    end
                end

                local percent = math.floor((currentAmt / targetAmt) * 100)
                if percent > 100 then percent = 100 end
                
                local textStr = string.format("📌 [%s] : %s / %s (%d%%)", goalName, FormatValue(currentAmt), FormatValue(targetAmt), percent)
                if currentAmt >= targetAmt then
                    QuestLabels[index].TextColor3 = Color3.fromRGB(50, 255, 50)
                    textStr = "✅ " .. goalName .. " - COMPLETED!"
                else
                    QuestLabels[index].TextColor3 = Color3.fromRGB(200, 200, 255)
                end
                
                QuestLabels[index].Text = textStr
                index = index + 1
            end
            
            vm:Set("NeedToFarmBreakables", needToFarm)
            for i = index, 4 do QuestLabels[i].Text = "" end
        else
            QuestLabels[1].Text = "Waiting for Quest Data..."
        end
    end
end)
