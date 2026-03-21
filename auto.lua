if _G.AutoRankStarted then return end
_G.AutoRankStarted = true

local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local Library = ReplicatedStorage:WaitForChild("Library")
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local ZoneCmds = require(Library.Client.ZoneCmds)
local RebirthCmds = require(Library.Client.RebirthCmds)
local MapCmds = require(Library.Client.MapCmds)
local PetNetworking = require(Library.Client.PetNetworking)
local RankCmds = require(Library.Client.RankCmds)
local RanksDirectory = require(Library.Directory.Ranks)

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
vm:Add("NeedToFarmBreakables", false, "boolean")

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
--//        PHẦN 2: AUTO WORLD & ADVANCED SERVER HOP (V12)          //--
--====================================================================--
local function GetZonePath(zoneNumber)
    -- Tìm kiếm mờ thông minh: Bỏ qua lỗi viết sai tên thư mục của game
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

local currentZone = ""

-- HỆ THỐNG SERVER HOP TỐI THƯỢNG CỦA BẠN (ĐÃ TỐI ƯU HÓA)
local function AdvancedServerHop(placeId)
    local S_T = game:GetService("TeleportService")
    local S_H = game:GetService("HttpService")
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour

    local success, res = pcall(function() return S_H:JSONDecode(readfile("Hasty-ServerHop.json")) end)
    if success and type(res) == "table" then
        AllIDs = res
    else
        AllIDs = {actualHour}
        pcall(function() writefile("Hasty-ServerHop.json", S_H:JSONEncode(AllIDs)) end)
    end

    local function TPReturner()
        local url = 'https://games.roblox.com/v1/games/' .. tostring(placeId) .. '/servers/Public?sortOrder=Asc&limit=100'
        if foundAnything ~= "" then url = url .. '&cursor=' .. foundAnything end

        local Site = nil
        pcall(function() Site = S_H:JSONDecode(game:HttpGet(url)) end)
        if not Site then
            pcall(function()
                local req = (request or http and http.request or http_request or syn and syn.request)
                if req then Site = S_H:JSONDecode(req({Url = url, Method = "GET"}).Body) end
            end)
        end

        if not Site or not Site.data then return false end

        if Site.nextPageCursor and Site.nextPageCursor ~= "null" then
            foundAnything = Site.nextPageCursor
        else
            foundAnything = "" 
        end

        local num = 0
        for i,v in pairs(Site.data) do
            local Possible = true
            local ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then Possible = false end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            pcall(function()
                                if delfile then delfile("Hasty-ServerHop.json") end
                                AllIDs = {actualHour}
                            end)
                        end
                    end
                    num = num + 1
                end
                
                if Possible == true then
                    table.insert(AllIDs, ID)
                    pcall(function()
                        writefile("Hasty-ServerHop.json", S_H:JSONEncode(AllIDs))
                        S_T:TeleportToPlaceInstance(placeId, ID, LocalPlayer)
                    end)
                    task.wait(4)
                    return true 
                end
            end
        end
        return false
    end

    while task.wait(0.1) do
        local hopped = TPReturner()
        if hopped then break end
        if foundAnything == "" then
            pcall(function() if delfile then delfile("Hasty-ServerHop.json") end end)
            S_T:Teleport(placeId, LocalPlayer)
            break 
        end
    end
end

local lastHopAttempt = 0

local function teleportToMaxZone()
    local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
    if not zoneName or not maxZoneData then return end
    local maxZ = maxZoneData.ZoneNumber
    
    -- LOGIC CỦA BẠN: So sánh số Map hiện tại với Mốc Ranh Giới World
    local targetWorldName = nil
    local targetPlaceId = game.PlaceId
    
    if maxZ >= 239 then targetWorldName = "Kawaii"; targetPlaceId = 140403681187145
    elseif maxZ >= 199 then targetWorldName = "Void"; targetPlaceId = 17503543197
    elseif maxZ >= 99 then targetWorldName = "Tech"; targetPlaceId = 16498369169
    end

    -- Nếu sai Máy chủ -> Kích hoạt lệnh Nhảy
    if targetWorldName and targetPlaceId ~= game.PlaceId then
        local nextRebirthData = nil
        pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end)
        
        -- CHỐT CHẶN: Nếu đến mốc nhảy nhưng vẫn NỢ Tái sinh -> Không nhảy, đứng chờ
        if nextRebirthData and maxZ >= nextRebirthData.ZoneNumberRequired then
            -- Bỏ qua không kích hoạt nhảy
        else
            -- Được phép nhảy!
            if os.clock() - lastHopAttempt > 15 then
                lastHopAttempt = os.clock()
                StatusLabel.Text = "Status: Hopping to " .. targetWorldName .. "..."
                pcall(function() Network.Invoke("Save") end)
                
                task.spawn(function()
                    pcall(function() Network.Invoke("Teleports_RequestTeleport", targetWorldName) end)
                    task.wait(4)
                    AdvancedServerHop(targetPlaceId)
                end)
            end
            return -- Dừng lệnh đi bộ để ưu tiên nhảy không gian
        end
    end

    -- DỊCH CHUYỂN BÌNH THƯỜNG TRONG MAP (LUÔN CHẠY KHI ĐANG Ở ĐÚNG WORLD)
    if currentZone ~= zoneName then
        currentZone = zoneName
        vm:Set("current_zone", currentZone)
        if string.find(StatusLabel.Text, "Hopping") == nil then
            StatusLabel.Text = "Status: Teleporting to " .. zoneName
        end
        
        local zonePath = GetZonePath(maxZ)
        if zonePath then
            if zonePath:FindFirstChild("PERSISTENT") and zonePath.PERSISTENT:FindFirstChild("Teleport") then
                LocalPlayer.Character:PivotTo(zonePath.PERSISTENT.Teleport.CFrame + Vector3.new(0, 5, 0))
                task.wait(0.5)
            end
            
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
                            if mag < dist then dist = mag; closestZone = v end
                        end
                        if closestZone then LocalPlayer.Character:PivotTo(closestZone.CFrame + Vector3.new(0, 10, 0)) end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local nextRebirthData = nil
            pcall(function() nextRebirthData = RebirthCmds.GetNextRebirth() end)

            if nextRebirthData then
                local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
                if maxZoneData and maxZoneData.ZoneNumber >= nextRebirthData.ZoneNumberRequired then
                    StatusLabel.Text = "Status: Rebirthing..."
                    Network.Invoke("Rebirth_Request", tostring(nextRebirthData.RebirthNumber))
                    task.wait(10)
                    currentZone = ""; vm:Set("current_zone", nil)
                    return
                end
            end
            
            local nextZoneName, nextZoneData = ZoneCmds.GetNextZone()
            if nextZoneName then
                local success = Network.Invoke("Zones_RequestPurchase", nextZoneName)
                if success then StatusLabel.Text = "Status: Purchased " .. nextZoneName end
            end
            
            teleportToMaxZone()
        end)
    end
end)
--====================================================================--
--//                   PHẦN 3: NÃO ĐIỀU KHIỂN PET                   //--
--====================================================================--
task.spawn(function()
    local breakableOffset = 0
    while true do
        task.wait()
        if not vm:Get("NeedToFarmBreakables") then continue end

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
            local firstTarget = nil

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
                task.spawn(function() Network.Fire("Breakables_JoinPetBulk", bulkAssignments) end)
                if firstTarget then
                    task.spawn(function() Network.UnreliableFire("Breakables_PlayerDealDamage", firstTarget) end)
                end
                task.wait(0.1)
            end
            breakableOffset = breakableOffset + 1
        else
            breakableOffset = 0
        end
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

-- Hàm đổi số sang số La Mã (Hiển thị UI)
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
    while absNumber >= 1000 and index < #suffixes do
        absNumber = absNumber / 1000
        index = index + 1
    end
    local formatted = (absNumber >= 1 and index > 1) and string.format("%.2f", absNumber):gsub("%.00$", "") or tostring(math.floor(absNumber))
    return formatted .. suffixes[index]
end

-- Vòng lặp Auto Claim
task.spawn(function()
    while task.wait(5) do
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

-- VÒNG LẶP CỦA BỘ NÃO (BRAIN LOOP)
task.spawn(function()
    while task.wait(1) do
        local data = Save.Get()
        
        if data and data.Goals then
            local index = 1
            local needToFarm = false
            
            for goalId, goalData in pairs(data.Goals) do
                if index > 4 then break end
                
                local typeId = goalData.Type
                local currentAmt = goalData.Progress or 0
                local targetAmt = goalData.Amount or 1
                
                -- Lấy chuẩn Tier từ API của game
                local requiredTier = goalData.PotionTier or goalData.Tier or 1
                
                -- 1. DỊCH TÊN NHIỆM VỤ
                local goalName = "Unknown Quest ID: " .. tostring(typeId)
                if typeId == 7 then
                    goalName = string.format("Earn %s", tostring(goalData.CurrencyID or "Coins"))
                elseif typeId == 34 then
                    goalName = string.format("Use Tier %s Potions", ToRoman(requiredTier))
                elseif GoalDictionary[typeId] then
                    goalName = GoalDictionary[typeId]
                end

                -- ==========================================
                -- 2. BỘ NÃO XỬ LÝ (GIẢI QUYẾT NHIỆM VỤ)
                -- ==========================================
                if currentAmt < targetAmt then
                    
                    if typeId == 21 or typeId == 38 or typeId == 14 or typeId == 15 then
                        needToFarm = true 
                    end
                    
                    -- AUTO SỬ DỤNG COMET (Tìm kiếm toàn diện kho đồ)
                    if typeId == 38 then
                        local lastProgress = vm:Get("CometProg_" .. goalId) or -1
                        local lastTime = vm:Get("CometTime_" .. goalId) or 0
                        
                        if currentAmt ~= lastProgress or (os.clock() - lastTime > 30) then
                            local cometUid = nil
                            
                            -- LỤC TUNG TOÀN BỘ KHO ĐỒ
                            if data.Inventory then
                                for categoryName, categoryData in pairs(data.Inventory) do
                                    if type(categoryData) == "table" then
                                        for uid, item in pairs(categoryData) do
                                            -- Chỉ cần ID có chứa chữ "comet" là lấy!
                                            if type(item.id) == "string" and string.find(string.lower(item.id), "comet") then
                                                cometUid = uid
                                                break
                                            end
                                        end
                                    end
                                    if cometUid then break end
                                end
                            end
                            
                            if cometUid then
                                vm:Set("CometProg_" .. goalId, currentAmt)
                                vm:Set("CometTime_" .. goalId, os.clock())
                                
                                task.spawn(function()
                                    -- Gửi đa dạng lệnh
                                    pcall(function() Network.Invoke("Consume Item", cometUid) end)
                                    pcall(function() Network.Invoke("Items: Consume", cometUid, 1) end)
                                    pcall(function() Network.Fire("Consume Item", cometUid) end)
                                end)
                            end
                        end
                    end

                    -- AUTO UỐNG POTION (Tìm kiếm theo tn - tier number)
                    if typeId == 34 then
                        local neededToDrink = targetAmt - currentAmt
                        
                        if not vm:Get("IsDrinking_" .. goalId) then
                            vm:Set("IsDrinking_" .. goalId, true)
                            
                            task.spawn(function()
                                local targetUid = nil
                                
                                -- Lục trong thư mục Potion
                                if data.Inventory and data.Inventory.Potion then
                                    for uid, item in pairs(data.Inventory.Potion) do
                                        -- Cứ bình nào có tier (tn) trùng khớp là lấy
                                        if item.tn == requiredTier then
                                            targetUid = uid
                                            break
                                        end
                                    end
                                end
                                
                                if targetUid then
                                    for i = 1, neededToDrink do
                                        pcall(function() Network.Invoke("Consume Item", targetUid) end)
                                        pcall(function() Network.Invoke("Potions: Consume", targetUid, 1) end)
                                        pcall(function() Network.Fire("Consume Item", targetUid) end)
                                        
                                        task.wait(0.15) 
                                    end
                                end
                                
                                task.wait(3) 
                                vm:Set("IsDrinking_" .. goalId, false)
                            end)
                        end
                    end
                end
                -- ==========================================

                -- 3. CẬP NHẬT GIAO DIỆN (UI)
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
