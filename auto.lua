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
--//        PHẦN 2: AUTO WORLD & VŨ KHÍ SERVER HOP ĐỘC LẬP          //--
--====================================================================--
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

-- THUẬT TOÁN SERVER HOP
local function ServerHop(targetPlaceId)
    StatusLabel.Text = "Status: Server Hopping to " .. tostring(targetPlaceId)
    pcall(function() Network.Invoke("Save") end)
    task.wait(2)

    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    local function getServers()
        local url = 'https://games.roblox.com/v1/games/' .. tostring(targetPlaceId) .. '/servers/Public?sortOrder=Asc&limit=100'
        local servers = nil
        
        local success, res = pcall(function() return game:HttpGet(url) end)
        if success and res then
            local decoded = HttpService:JSONDecode(res)
            if decoded and decoded.data then servers = decoded.data end
        end
        
        if not servers then
            pcall(function()
                local req = (request or http and http.request or http_request or syn and syn.request)
                if req then
                    local response = req({Url = url, Method = "GET", Headers = { ["Content-Type"] = "application/json" }})
                    if response and response.Body then
                        servers = HttpService:JSONDecode(response.Body).data
                    end
                end
            end)
        end
        
        return servers
    end

    local servers = getServers()
    if servers and #servers > 0 then
        local validServers = {}
        for _, s in ipairs(servers) do
            if s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 then
                table.insert(validServers, s)
            end
        end
        
        if #validServers > 0 then
            local randomServer = validServers[math.random(1, #validServers)]
            pcall(function()
                TeleportService:TeleportToPlaceInstance(targetPlaceId, randomServer.id, LocalPlayer)
            end)
            return
        end
    end
    
    pcall(function() TeleportService:Teleport(targetPlaceId, LocalPlayer) end)
end

-- HỆ THỐNG DỊCH CHUYỂN & CHUYỂN WORLD ĐỘC LẬP
local function teleportToMaxZone()
    local zoneName, maxZoneData = ZoneCmds.GetMaxOwnedZone()
    if not zoneName or not maxZoneData then return end
    
    local targetPlaceId = game.PlaceId
    
    -- CHỈ KIỂM TRA ĐÃ XONG TẤT CẢ ZONE CHƯA LÀ CHUYỂN WORLD LUÔN
    if maxZoneData.ZoneNumber >= 99 and game.PlaceId == 8737899170 then targetPlaceId = 16498369169 end
    if maxZoneData.ZoneNumber >= 199 and game.PlaceId == 16498369169 then targetPlaceId = 17503543197 end
    if maxZoneData.ZoneNumber >= 239 and game.PlaceId == 17503543197 then targetPlaceId = 140403681187145 end

    -- GỌI SERVER HOP NẾU KHÁC MÁY CHỦ
    if game.PlaceId ~= targetPlaceId then
        ServerHop(targetPlaceId)
        task.wait(15) -- Nghỉ 15s chờ bay
        return
    end
    
    -- DỊCH CHUYỂN BÌNH THƯỜNG TRONG CÙNG WORLD
    if currentZone ~= zoneName then
        currentZone = zoneName
        vm:Set("current_zone", currentZone)
        StatusLabel.Text = "Status: Teleporting to " .. zoneName
        
        local zonePath = GetZonePath(maxZoneData.ZoneNumber, zoneName)
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

-- VÒNG LẶP MUA MAP VÀ REBIRTH (ĐÃ TÁCH RỜI)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- 1. HỆ THỐNG REBIRTH ĐỘC LẬP (Chỉ cần đủ zone là tự Rebirth)
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
            
            -- 2. HỆ THỐNG MUA MAP
            local nextZoneName, nextZoneData = ZoneCmds.GetNextZone()
            if nextZoneName then
                local success = Network.Invoke("Zones_RequestPurchase", nextZoneName)
                if success then StatusLabel.Text = "Status: Purchased " .. nextZoneName end
            end
            
            -- 3. CHẠY KIỂM TRA DỊCH CHUYỂN
            teleportToMaxZone()
        end)
    end
end)

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
            local bulkAssignments = {}
            local firstTarget = nil

            for i, petID in ipairs(vm:Get("PetIDs")) do
                if vm:Get("Euids")[petID] then
                    local assignedKey = availableBreakables[((i - 1 + breakableOffset) % #availableBreakables) + 1]
                    bulkAssignments[petID] = assignedKey
                    if not firstTarget then firstTarget = assignedKey end
                end
            end

            if next(bulkAssignments) then
                task.spawn(function() Network.Fire("Breakables_JoinPetBulk", bulkAssignments) end)
                if firstTarget then task.spawn(function() Network.UnreliableFire("Breakables_PlayerDealDamage", firstTarget) end) end
                task.wait(0.1)
            end
            breakableOffset = breakableOffset + 1
        else
            breakableOffset = 0
        end
    end
end)

--====================================================================--
--//        PHẦN 4: TỪ ĐIỂN NHIỆM VỤ & AI QUÉT KHO ĐỒ (V7)          //--
--====================================================================--
local GoalDictionary = {
    [7] = "Earn %s", 
    [9] = "Break Diamond Breakables",
    [14] = "Collect Potions",
    [15] = "Collect Enchants",
    [20] = "Hatch %s Best Eggs",
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
                elseif typeId == 20 then goalName = string.format("Hatch %s Best Eggs", FormatValue(targetAmt))
                elseif typeId == 34 then goalName = string.format("Use Tier %s Potions", ToRoman(requiredTier))
                elseif GoalDictionary[typeId] then goalName = GoalDictionary[typeId] end

                if currentAmt < targetAmt then
                    -- Bật Farm cho các nhiệm vụ đập phá
                    if typeId == 9 or typeId == 21 or typeId == 38 or typeId == 14 or typeId == 15 then
                        needToFarm = true 
                    end
                    
                    -- AUTO SỬ DỤNG COMET
                    if typeId == 38 then
                        local lastProgress = vm:Get("CometProg_" .. goalId) or -1
                        local lastTime = vm:Get("CometTime_" .. goalId) or 0
                        
                        if currentAmt ~= lastProgress or (os.clock() - lastTime > 30) then
                            local cometUid = nil
                            -- Quét sạch mọi danh mục trong túi đồ
                            if data.Inventory then
                                for _, categoryData in pairs(data.Inventory) do
                                    if type(categoryData) == "table" then
                                        for uid, item in pairs(categoryData) do
                                            local itemName = tostring(item.id or "")
                                            if string.find(string.lower(itemName), "comet") then
                                                cometUid = uid; break
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
                                    -- Tung mọi lệnh có thể
                                    pcall(function() Network.Invoke("Consume Item", cometUid, 1) end)
                                    pcall(function() Network.Invoke("Items: Consume", cometUid, 1) end)
                                    pcall(function() Network.Fire("Consume Item", cometUid, 1) end)
                                end)
                            end
                        end
                    end

                    -- AUTO UỐNG POTION THÔNG MINH
                    if typeId == 34 then
                        local neededToDrink = targetAmt - currentAmt
                        if not vm:Get("IsDrinking_" .. goalId) then
                            vm:Set("IsDrinking_" .. goalId, true)
                            
                            task.spawn(function()
                                local targetUid = nil
                                if data.Inventory and data.Inventory.Potion then
                                    for uid, item in pairs(data.Inventory.Potion) do
                                        -- Lọc thông minh: Tìm tn == 5 HOẶC tên có chứa "Potion" và "V"
                                        local itemName = tostring(item.id or "")
                                        if item.tn == requiredTier or (string.find(itemName, "Potion") and string.find(itemName, ToRoman(requiredTier))) then
                                            targetUid = uid; break
                                        end
                                    end
                                end
                                
                                if targetUid then
                                    for i = 1, neededToDrink do
                                        pcall(function() Network.Invoke("Consume Item", targetUid, 1) end)
                                        pcall(function() Network.Invoke("Potions: Consume", targetUid, 1) end)
                                        task.wait(0.15) 
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
