--====================================================================--
--//                   HASTY AUTO RANK (V6.2 FINAL)                 //--
--====================================================================--

-- 1. ĐỢI GAME TẢI XONG (Tránh lỗi luồng của Codex)
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if LocalPlayer then
    repeat task.wait() until LocalPlayer.PlayerGui and not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")
end

local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Library = ReplicatedStorage:WaitForChild("Library")
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local ZoneCmds = require(Library.Client.ZoneCmds)
local RebirthCmds = require(Library.Client.RebirthCmds)
local PetNetworking = require(Library.Client.PetNetworking)
local RankCmds = require(Library.Client.RankCmds)
local RanksDirectory = require(Library.Directory.Ranks)

-- 2. KHỞI TẠO VARIABLES MANAGER (Chống lỗi Thread)
local function loadUtils(url, file)
    local path = "Hasty-Utils/" .. file
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

_G.PreparingToHop = false
_G.AutoRankStarted = true

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
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

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
Instance.new("UIListLayout", QuestsFrame).Padding = UDim.new(0, 8)

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
    vm:TableClear("Euids")
    vm:TableClear("PetIDs")
    for petID, petData in pairs(PetNetworking.EquippedPets()) do
        vm:TableSet("Euids", petID, petData)
        vm:TableInsert("PetIDs", petID)
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
--//        PHẦN 2: AUTO WORLD, CỔNG PORTAL & REBIRTH NEO TÂM       //--
--====================================================================--
local currentZone = ""
local centerPoint = nil
local lastPosUpdate = os.clock()

local function GetZonePath(zoneNumber)
    local searchPattern = "^" .. tostring(zoneNumber) .. " |"
    for _, folderName in ipairs({"Map", "Map2", "Map3", "Map4", "Map5", "Map6"}) do
        local mapFolder = Workspace:FindFirstChild(folderName)
        if mapFolder then
            for _, zoneFolder in pairs(mapFolder:GetChildren()) do
                if string.find(zoneFolder.Name, searchPattern) then return zoneFolder end
            end
        end
    end
    return nil
end

local function GoToWorldPortal()
    local portalPath = nil
    pcall(function()
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
        pcall(function() Network.Invoke("Travel_ToNextWorld") end) 
    else
        StatusLabel.Text = "Status: Portal not found, checking UI..."
    end
end

local function teleportToMaxZone(zoneName, maxZoneData)
    if _G.PreparingToHop then return end 
    
    if currentZone ~= zoneName then
        currentZone = zoneName
        vm:Set("current_zone", currentZone)
        StatusLabel.Text = "Status: Teleporting to " .. zoneName
        
        local zonePath = GetZonePath(maxZoneData.ZoneNumber)
        if zonePath then
            if zonePath:FindFirstChild("PERSISTENT") and zonePath.PERSISTENT:FindFirstChild("Teleport") then
                LocalPlayer.Character:PivotTo(zonePath.PERSISTENT.Teleport.CFrame + Vector3.new(0, 5, 0))
                task.wait(0.5)
            end
            
            local interact = zonePath:WaitForChild("INTERACT", 3)
            if interact and interact:FindFirstChild("BREAK_ZONES") then
                local breakZones = interact.BREAK_ZONES
                local dist = math.huge
                local closestZone = nil
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, v in pairs(breakZones:GetChildren()) do
                        local mag = (hrp.Position - v.Position).Magnitude
                        if mag < dist then dist = mag; closestZone = v end
                    end
                    if closestZone then 
                        LocalPlayer.Character:PivotTo(closestZone.CFrame + Vector3.new(0, 10, 0)) 
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if _G.PreparingToHop then break end 
        
        pcall(function()
            local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
            if not zoneName or not maxZoneData then return end
            
            -- 1. Vào Portal
            if (maxZoneData.ZoneNumber == 99 or maxZoneData.ZoneNumber == 199 or maxZoneData.ZoneNumber == 239) then
                GoToWorldPortal()
                task.wait(5)
            end

            -- 2. Rebirth
            local nextRebirthData = nil
            pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end)

            if nextRebirthData and maxZoneData.ZoneNumber >= nextRebirthData.ZoneNumberRequired then
                StatusLabel.Text = "Status: Rebirthing in 5s..."
                task.wait(5) 
                Network.Invoke("Rebirth_Request", tostring(nextRebirthData.RebirthNumber))
                currentZone = ""
                vm:Set("current_zone", nil)
                centerPoint = nil 
                return
            end
            
            -- 3. Mua Zone & Teleport
            local nextZoneName = ZoneCmds.GetNextZone()
            if nextZoneName then Network.Invoke("Zones_RequestPurchase", nextZoneName) end
            
            teleportToMaxZone(zoneName, maxZoneData)

            -- 4. Giữ vị trí trung tâm (Neo 10s)
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not centerPoint or (currentZone ~= zoneName) then
                    local zonePath = GetZonePath(maxZoneData.ZoneNumber)
                    if zonePath and zonePath:FindFirstChild("INTERACT") then
                        local bZones = zonePath.INTERACT:FindFirstChild("BREAK_ZONES")
                        if bZones and bZones:GetChildren()[1] then
                            centerPoint = bZones:GetChildren()[1].CFrame
                        end
                    end
                end

                if centerPoint then
                    local dist = (hrp.Position - centerPoint.Position).Magnitude
                    if dist > 15 then 
                        if os.clock() - lastPosUpdate > 10 then
                            StatusLabel.Text = "Status: Returning to Center..."
                            LocalPlayer.Character:PivotTo(centerPoint + Vector3.new(0, 10, 0))
                            lastPosUpdate = os.clock()
                        end
                    else
                        lastPosUpdate = os.clock() 
                    end
                end
            end
        end)
    end
end)

--====================================================================--
--//      PHẦN 3: NÃO ĐIỀU KHIỂN PET (CODEX STABLE FAST FARM)       //--
--====================================================================--
task.spawn(function()
    local breakableOffset = 0
    while task.wait(0.2) do 
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
                    if count >= 15 then break end 
                end
            end
        end)
    end
end)

--====================================================================--
--//        PHẦN 4: AUTO RANK REWARDS & MUA EGG SLOTS               //--
--====================================================================--
local lastRankTitle = "" 

local function CheckAndBuyEggSlots()
    pcall(function()
        local PurchasedSlots = Save.Get()["EggSlotsPurchased"] or 0
        local MaxSlots = RankCmds.GetMaxPurchasableEggSlots()
        
        if PurchasedSlots < MaxSlots then
            StatusLabel.Text = "Status: Upgrading Egg Slots..."
            while PurchasedSlots < MaxSlots do
                local EggSlotInfo = RankCmds.GetEggBundle(PurchasedSlots + 1)
                if Network.Invoke("EggHatchSlotsMachine_RequestPurchase", EggSlotInfo) then
                    PurchasedSlots = PurchasedSlots + 1
                    task.wait(0.5) 
                else
                    break 
                end
            end
            StatusLabel.Text = "Status: Egg Slots Upgraded!"
        end
    end)
end

task.spawn(function()
    pcall(function()
        lastRankTitle = RankCmds.GetTitle()
        CheckAndBuyEggSlots()
    end)

    while task.wait(5) do
        if _G.PreparingToHop then break end
        pcall(function()
            local currentSave = Save.Get()
            local currentTitle = RankCmds.GetTitle()
            
            -- Tự mua Slot khi Rank Up
            if currentTitle ~= lastRankTitle then
                lastRankTitle = currentTitle
                CheckAndBuyEggSlots() 
            end

            -- Nhận thưởng
            local totalStars = 0
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

--====================================================================--
--//           PHẦN 5: AUTO FRUIT THÔNG MINH (1 QUẢ/LẦN)            //--
--====================================================================--
local FruitList = {"Apple", "Orange", "Banana", "Pineapple", "Rainbow Fruit"}

local function HasFruitBuff()
    local save = Save.Get()
    if save and save.Boosts then
        for _, boost in pairs(save.Boosts) do
            for _, fruitName in ipairs(FruitList) do
                if string.find(boost.Id, fruitName) then return true end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(5) do
        if _G.PreparingToHop or HasFruitBuff() then continue end
        
        local data = Save.Get()
        local fruitUid = nil
        if data and data.Inventory and data.Inventory.Fruit then
            for uid, _ in pairs(data.Inventory.Fruit) do
                fruitUid = uid
                break 
            end
        end
        
        if fruitUid then
            pcall(function() 
                Network.Invoke("Consume Item", fruitUid)
                Network.Invoke("Fruits: Consume", fruitUid, 1) 
            end)
        end
    end
end)

--====================================================================--
--//           PHẦN 6: BỘ NÃO XỬ LÝ NHIỆM VỤ (QUEST BRAIN V2)       //--
--====================================================================--

-- ==================== 2 HÀM MỚI (TỔNG HỢP TỪ TẤT CẢ SCRIPT BẠN GỬI) ====================
local function AutoConsumeComet(goalId, needed)
    if vm:Get("IsProcessingComet_" .. goalId) then return end
    vm:Set("IsProcessingComet_" .. goalId, true)
    
    StatusLabel.Text = "Status: Đang dùng Comet (" .. needed .. " cái)..."
    
    local data = Save.Get()
    local cometUid = nil
    
    -- Tìm Comet chính xác (từ Lucky Raid script)
    if data and data.Inventory then
        for category, items in pairs(data.Inventory) do
            if type(items) == "table" then
                for uid, item in pairs(items) do
                    if type(item.id) == "string" and string.find(string.lower(item.id), "comet") then
                        cometUid = uid
                        break
                    end
                end
            end
            if cometUid then break end
        end
    end
    
    if not cometUid then
        vm:Set("IsProcessingComet_" .. goalId, false)
        return
    end
    
    for i = 1, needed do
        pcall(function()
            Network.Invoke("Consume Item", cometUid)
            Network.Invoke("Items: Consume", cometUid, 1)
            Network.Fire("Consume Item", cometUid)
            -- Fallback từ Flower Garden style
            pcall(function() Network.Invoke("Instancing_InvokeCustomFromClient", "Main", "ConsumeItem", cometUid) end)
        end)
        task.wait(0.45)  -- delay an toàn để server cập nhật progress
    end
    
    task.wait(2) -- chờ quest sync
    vm:Set("CometProg_" .. goalId, nil)
    vm:Set("IsProcessingComet_" .. goalId, false)
    print("[QUEST] Đã dùng xong " .. needed .. " Comet!")
end

local function AutoConsumePotion(goalId, requiredTier, needed)
    if vm:Get("IsProcessingPotion_" .. goalId) then return end
    vm:Set("IsProcessingPotion_" .. goalId, true)
    
    StatusLabel.Text = "Status: Đang uống Potion Tier " .. requiredTier .. " (" .. needed .. " cái)..."
    
    local data = Save.Get()
    local potionUid = nil
    
    -- Tìm Potion đúng tier (từ Lucky Raid + Auto Fuse style)
    if data and data.Inventory and data.Inventory.Potion then
        for uid, item in pairs(data.Inventory.Potion) do
            if item.tn == requiredTier then
                potionUid = uid
                break
            end
        end
    end
    
    if not potionUid then
        vm:Set("IsProcessingPotion_" .. goalId, false)
        return
    end
    
    for i = 1, needed do
        pcall(function()
            Network.Invoke("Consume Item", potionUid)
            Network.Invoke("Potions: Consume", potionUid, 1)
            Network.Fire("Consume Item", potionUid)
            pcall(function() Network.Invoke("Items: Consume", potionUid, 1) end)
        end)
        task.wait(0.4)
    end
    
    task.wait(2)
    vm:Set("IsDrinking_" .. goalId, false)
    vm:Set("IsProcessingPotion_" .. goalId, false)
    print("[QUEST] Đã uống xong " .. needed .. " Potion Tier " .. requiredTier)
end

-- ==================== VÒNG LẶP QUEST BRAIN (ĐÃ SỬA) ====================
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
                
                local goalName = GoalDictionary[typeId] or "Unknown Quest " .. typeId
                if typeId == 7 then goalName = string.format("Earn %s", tostring(goalData.CurrencyID or "Coins")) end
                if typeId == 34 then goalName = string.format("Use Tier %s Potions", ToRoman(requiredTier)) end
                
                -- ==================== XỬ LÝ QUEST 38 & 34 MỚI ====================
                if currentAmt < targetAmt then
                    if typeId == 21 or typeId == 38 or typeId == 14 or typeId == 15 then 
                        needToFarm = true 
                    end
                    
                    local needed = targetAmt - currentAmt
                    
                    if typeId == 38 then
                        AutoConsumeComet(goalId, needed)
                    elseif typeId == 34 then
                        AutoConsumePotion(goalId, requiredTier, needed)
                    end
                end
                -- =================================================================
                
                -- UI Update
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
