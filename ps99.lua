--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

if _G.Started then
	return;
end
_G.Started = true;
local defaultConfig = {["Raid Settings"]={Enabled=true,Difficulty=1,OpenLeprechaunChest=false,["Boss Settings"]={Enabled=true,TargetBosses={"Boss 1","Boss 2","Boss 3"},UpgradeBossChests=true},["Egg Settings"]={Enabled=true,MinimumEggMulti=500,MinimumLuckyCoins="1m",MaxOpenTime=30}},Webhook={url="",["Discord Id to ping"]={""}},UpgradeSettings={Enabled=true,LuckyRaidXP={priority=1,priority_upgrade=13,maxTier=17,required=true},LuckyRaidDamage={priority=2,priority_upgrade=15,maxTier=17,required=true},LuckyRaidAttackSpeed={priority=3,priority_upgrade=7,maxTier=10,required=true},LuckyRaidPets={priority=4,priority_upgrade=10,maxTier=10,required=true},LuckyRaidTitanicChest={priority=10,maxTier=99},LuckyRaidHugeChest={priority=11,maxTier=99},LuckyRaidBossHugeChances={priority=12,maxTier=99},LuckyRaidBossTitanicChances={priority=13,maxTier=99},LuckyRaidBetterLoot={enabled=false},LuckyRaidPetSpeed={enabled=false},LuckyRaidMoreCurrency={enabled=false},LuckyRaidEggCost={enabled=false},LuckyRaidKeyDrops={enabled=false}}};
local function mergeConfig(default, user)
	local FlatIdent_66556 = 0;
	local result;
	while true do
		if (FlatIdent_66556 == 0) then
			result = {};
			for k, v in pairs(default) do
				if ((type(v) == "table") and (type(user[k]) == "table")) then
					result[k] = mergeConfig(v, user[k]);
				elseif (user[k] ~= nil) then
					result[k] = user[k];
				else
					result[k] = v;
				end
			end
			FlatIdent_66556 = 1;
		end
		if (FlatIdent_66556 == 1) then
			for k, v in pairs(user) do
				if (result[k] == nil) then
					result[k] = v;
				end
			end
			return result;
		end
	end
end
local Settings = mergeConfig(defaultConfig, getgenv().Settings or {});
local Raid = Settings["Raid Settings"];
local Webhook = Settings['Webhook'];
local SuffixesLower = {"k","m","b","t"};
local SuffixesUpper = {"K","M","B","T"};
local function RemoveSuffix(Amount)
	local FlatIdent_61538 = 0;
	local a;
	local Suffix;
	local b;
	while true do
		if (FlatIdent_61538 == 0) then
			a, Suffix = Amount:gsub("%a", ""), Amount:match("%a");
			b = table.find(SuffixesUpper, Suffix) or table.find(SuffixesLower, Suffix) or 0;
			FlatIdent_61538 = 1;
		end
		if (FlatIdent_61538 == 1) then
			return tonumber(a) * math.pow(10, b * 3);
		end
	end
end
if (type(Raid["Egg Settings"].MinimumLuckyCoins) ~= "number") then
	Raid["Egg Settings"].MinimumLuckyCoins = RemoveSuffix(Raid["Egg Settings"].MinimumLuckyCoins);
end
local function load(url, file)
	local path = "Hasty-Utils/" .. file;
	local ok, res = pcall(game.HttpGet, game, url);
	if (ok and res) then
		local FlatIdent_2FBEB = 0;
		while true do
			if (FlatIdent_2FBEB == 1) then
				return loadstring(res)();
			end
			if (FlatIdent_2FBEB == 0) then
				if not isfolder("Hasty-Utils") then
					makefolder("Hasty-Utils");
				end
				writefile(path, res);
				FlatIdent_2FBEB = 1;
			end
		end
	end
	return loadstring(readfile(path))();
end
local vm = load("https://raw.githubusercontent.com/Paule1248/Open-Source/refs/heads/main/Utils/VariablesManager", "VariablesManager.lua");
local FarmUI = {};
FarmUI.__index = FarmUI;
FarmUI.new = function(Config)
	local FlatIdent_63487 = 0;
	local Self;
	local ScreenGui;
	local Background;
	local Container;
	local Layout;
	local ToggleBtn;
	local UICornerBtn;
	local UIStrokeBtn;
	local Sorted;
	while true do
		if (FlatIdent_63487 == 6) then
			Layout = Instance.new("UIListLayout");
			Layout.Padding = UDim.new(0.015, 0);
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			Layout.VerticalAlignment = Enum.VerticalAlignment.Center;
			FlatIdent_63487 = 7;
		end
		if (8 == FlatIdent_63487) then
			ToggleBtn.Position = UDim2.new(1, -20, 1, -20);
			ToggleBtn.AnchorPoint = Vector2.new(1, 1);
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
			ToggleBtn.Text = "👁";
			FlatIdent_63487 = 9;
		end
		if (4 == FlatIdent_63487) then
			Background.Size = UDim2.new(1, 0, 1, 0);
			Background.Position = UDim2.new(0.5, 0, 0.5, 0);
			Background.AnchorPoint = Vector2.new(0.5, 0.5);
			Container = Instance.new("Frame");
			FlatIdent_63487 = 5;
		end
		if (FlatIdent_63487 == 12) then
			table.sort(Sorted, function(A, B)
				return A.Order < B.Order;
			end);
			for Index, Item in ipairs(Sorted) do
				local Label = Instance.new("TextLabel");
				Label.Name = Item.Name;
				Label.LayoutOrder = Item.Order;
				Label.Size = (Item.Size and UDim2.new(unpack(Item.Size))) or UDim2.new(0.6, 0, 0.045, 0);
				Label.BackgroundTransparency = 1;
				Label.Font = Enum.Font.FredokaOne;
				Label.Text = Item.Text;
				Label.TextColor3 = Color3.fromRGB(255, 255, 255);
				Label.TextScaled = true;
				Label.Parent = Self.Container;
				Self.Elements[Item.Name] = Label;
				if (Index < #Sorted) then
					local FlatIdent_65290 = 0;
					local Spacer;
					while true do
						if (FlatIdent_65290 == 1) then
							Spacer.BackgroundColor3 = Color3.fromRGB(255, 0, 255);
							Spacer.Size = UDim2.new(0.4, 0, 0, 2);
							FlatIdent_65290 = 2;
						end
						if (FlatIdent_65290 == 2) then
							Spacer.Parent = Self.Container;
							break;
						end
						if (FlatIdent_65290 == 0) then
							Spacer = Instance.new("Frame");
							Spacer.LayoutOrder = Item.Order + 0.5;
							FlatIdent_65290 = 1;
						end
					end
				end
			end
			return Self;
		end
		if (FlatIdent_63487 == 5) then
			Container.Size = UDim2.new(1, 0, 1, 0);
			Container.BackgroundTransparency = 1;
			Container.Parent = Background;
			Self.Container = Container;
			FlatIdent_63487 = 6;
		end
		if (FlatIdent_63487 == 7) then
			Layout.SortOrder = Enum.SortOrder.LayoutOrder;
			Layout.Parent = Container;
			ToggleBtn = Instance.new("TextButton");
			ToggleBtn.Size = UDim2.new(0, 45, 0, 45);
			FlatIdent_63487 = 8;
		end
		if (FlatIdent_63487 == 11) then
			UIStrokeBtn.Parent = ToggleBtn;
			ToggleBtn.MouseButton1Click:Connect(function()
				local FlatIdent_79536 = 0;
				while true do
					if (FlatIdent_79536 == 0) then
						Background.Visible = not Background.Visible;
						ToggleBtn.Text = (Background.Visible and "👁") or "🙈";
						break;
					end
				end
			end);
			Sorted = {};
			for Name, Data in pairs(Config.UI) do
				table.insert(Sorted, {Name=Name,Order=Data[1],Text=Data[2],Size=Data[3]});
			end
			FlatIdent_63487 = 12;
		end
		if (FlatIdent_63487 == 3) then
			Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
			Background.BorderColor3 = Color3.fromRGB(255, 0, 255);
			Background.BorderMode = Enum.BorderMode.Inset;
			Background.Parent = ScreenGui;
			FlatIdent_63487 = 4;
		end
		if (2 == FlatIdent_63487) then
			ScreenGui.Parent = Self.Parent;
			ScreenGui.ResetOnSpawn = false;
			Self.ScreenGui = ScreenGui;
			Background = Instance.new("Frame");
			FlatIdent_63487 = 3;
		end
		if (FlatIdent_63487 == 10) then
			UICornerBtn.Parent = ToggleBtn;
			UIStrokeBtn = Instance.new("UIStroke");
			UIStrokeBtn.Color = Color3.fromRGB(255, 0, 255);
			UIStrokeBtn.Thickness = 2;
			FlatIdent_63487 = 11;
		end
		if (FlatIdent_63487 == 0) then
			Self = setmetatable({}, FarmUI);
			Self.Player = game.Players.LocalPlayer;
			Self.GuiName = "PiraFullscreenGui";
			Self.Elements = {};
			FlatIdent_63487 = 1;
		end
		if (FlatIdent_63487 == 9) then
			ToggleBtn.TextSize = 22;
			ToggleBtn.Parent = ScreenGui;
			UICornerBtn = Instance.new("UICorner");
			UICornerBtn.CornerRadius = UDim.new(1, 0);
			FlatIdent_63487 = 10;
		end
		if (FlatIdent_63487 == 1) then
			Self.Parent = game:GetService("CoreGui");
			ScreenGui = Instance.new("ScreenGui");
			ScreenGui.Name = Self.GuiName;
			ScreenGui.IgnoreGuiInset = true;
			FlatIdent_63487 = 2;
		end
	end
end;
FarmUI.SetText = function(self, Name, Text)
	if self.Elements[Name] then
		task.defer(function()
			self.Elements[Name].Text = Text;
		end);
	end
end;
FarmUI.Format = function(self, Int)
	local FlatIdent_12544 = 0;
	local Index;
	local Suffix;
	while true do
		if (FlatIdent_12544 == 1) then
			while (Int >= 1000) and (Index < #Suffix) do
				local FlatIdent_295EB = 0;
				while true do
					if (FlatIdent_295EB == 0) then
						Int = Int / 1000;
						Index = Index + 1;
						break;
					end
				end
			end
			if (Index == 1) then
				return string.format("%d", Int);
			end
			FlatIdent_12544 = 2;
		end
		if (FlatIdent_12544 == 0) then
			Index = 1;
			Suffix = {"","K","M","B","T"};
			FlatIdent_12544 = 1;
		end
		if (FlatIdent_12544 == 2) then
			return string.format("%.2f%s", Int, Suffix[Index]);
		end
	end
end;
local UI = FarmUI.new({UI={Title={1,"🌟 AUTO LUCKY RAID",{0.8,0,0.08,0}},Status={2,"Status: Starting..."},Level={3,"Current Level: 0"},Room={4,"Current Room: 0"},BreakablesLeft={5,"Total Breakables Left: 0"},RaidsCompleted={6,"Total Raids Completed: 0"},Huges={7,"Session Huges: 0"},Titanics={8,"Session Titanics: 0"},Eggs={9,"Total Eggs Hatched: 0"},TimeFarmed={10,"Time Farmed: 00:00:00"},FPS={11,"FPS: 60"}}});
local scriptStartTime = os.time();
task.spawn(function()
	while task.wait(1) do
		local FlatIdent_981A3 = 0;
		local elapsed;
		local h;
		local m;
		local s;
		while true do
			if (FlatIdent_981A3 == 0) then
				elapsed = os.time() - scriptStartTime;
				h = math.floor(elapsed / 3600);
				FlatIdent_981A3 = 1;
			end
			if (FlatIdent_981A3 == 2) then
				UI:SetText("TimeFarmed", string.format("Time Farmed: %02d:%02d:%02d", h, m, s));
				break;
			end
			if (FlatIdent_981A3 == 1) then
				m = math.floor((elapsed % 3600) / 60);
				s = elapsed % 60;
				FlatIdent_981A3 = 2;
			end
		end
	end
end);
local Workspace = game:GetService("Workspace");
task.spawn(function()
	while task.wait(0.5) do
		UI:SetText("FPS", "FPS: " .. math.floor(Workspace:GetRealPhysicsFPS()));
	end
end);
local DEBUG_BREAKABLES = true;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local VirtualUser = game:GetService("VirtualUser");
local Player = Players.LocalPlayer;
local Character = Player.Character or Player.CharacterAdded:Wait();
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
local THINGS = Workspace:FindFirstChild("__THINGS");
local ActiveInstances = workspace.__THINGS.__INSTANCE_CONTAINER.Active;
local __FAKE_INSTANCE_BREAK_ZONES = workspace.__THINGS.__FAKE_INSTANCE_BREAK_ZONES;
local mainfound = false;
local chestsPos = {};
local eggs = {};
local mainPos = Vector3.new(0, 0, 0);
local totalRaidsCompleted = 0;
local totaltitanics = 0;
pcall(function()
	local FlatIdent_9622C = 0;
	while true do
		if (FlatIdent_9622C == 0) then
			Player.PlayerScripts.Scripts.Core["Server Closing"].Enabled = false;
			Player.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false;
			break;
		end
	end
end);
Player.Idled:Connect(function()
	local FlatIdent_2D88C = 0;
	while true do
		if (FlatIdent_2D88C == 0) then
			VirtualUser:CaptureController();
			VirtualUser:ClickButton2(Vector2.new());
			break;
		end
	end
end);
local Library = ReplicatedStorage.Library;
local Network = require(Library.Client.Network);
local Save = require(Library.Client.Save);
local InstancingCmds = require(Library.Client.InstancingCmds);
local PetNetworking = require(Library.Client.PetNetworking);
local MapCmds = require(Library.Client.MapCmds);
local CustomEggsCmds = require(Library.Client.CustomEggsCmds);
local EggCmds = require(Library.Client.EggCmds);
local HatchingCmds = require(Library.Client.HatchingCmds);
local RaidCmds = require(Library.Client.RaidCmds);
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance);
local Raids = require(Library.Types.Raids);
local Items = require(Library.Items);
local CurrencyCmds = require(Library.Client.CurrencyCmds);
local EventUpgradeCmds = require(Library.Client.EventUpgradeCmds);
local MasteryCmds = require(Library.Client.MasteryCmds);
local CalcEggPrice = require(Library.Balancing.CalcEggPrice);
local EventUpgrades = require(Library.Directory.EventUpgrades);
local Eggs_Directory = require(Library.Directory.Eggs);
local FruitCmds = require(Library.Client.FruitCmds);
Network.Fire("Idle Tracking: Stop Timer");
local SafePart = Instance.new("Part", Workspace);
SafePart.Size = Vector3.new(10, 1, 10);
SafePart.Anchored = true;
SafePart.CFrame = HumanoidRootPart.CFrame - Vector3.new(0, 3, 0);
local vmInst = vm:new();
vmInst:Add("AllBreakables", {}, "table");
vmInst:Add("Euids", {}, "table");
vmInst:Add("LastUseEuids", {}, "table");
vmInst:Add("BreakablesInUse", {}, "table");
vmInst:Add("PetIDs", {}, "table");
vmInst:Add("BulkAssignments", {});
vmInst:Add("current_zone", nil, "string");
vmInst:Add("lastZone", nil, "string");
vmInst:Add("LeftOnPurpose", false, "boolean");
local destroyedCount = 0;
local lastPrint = os.clock();
local function TeleportPlayer(cf)
	local FlatIdent_D79D = 0;
	while true do
		if (0 == FlatIdent_D79D) then
			HumanoidRootPart.Anchored = false;
			HumanoidRootPart.CFrame = cf;
			FlatIdent_D79D = 1;
		end
		if (FlatIdent_D79D == 1) then
			SafePart.CFrame = cf - Vector3.new(0, 3, 0);
			break;
		end
	end
end
local function EnterInstance(Name)
	local retries = 0;
	while (InstancingCmds.GetInstanceID() ~= Name) and (retries < 5) do
		pcall(function()
			setthreadidentity(2);
			InstancingCmds.Enter(Name);
			setthreadidentity(8);
		end);
		task.wait(1);
		retries = retries + 1;
	end
end
if (Settings['UpgradeSettings'] and Settings['UpgradeSettings'].Enabled) then
	task.spawn(function()
		pcall(function()
			Network.Invoke("LuckyRaidUpgrades_Reset");
		end);
	end);
end
local luckyUpgrades = {};
for upgradeId, data in next, EventUpgrades do
	if upgradeId:find("LuckyRaid") then
		luckyUpgrades[upgradeId] = data;
	end
end
local orbItem = Items.Misc("Lucky Raid Orb V2");
local function PurchaseUpgrades()
	local Config = Settings['UpgradeSettings'];
	if (not Config or (Config.Enabled == false)) then
		return nil;
	end
	local currentOrbs = orbItem:CountExact();
	local allRequiredDone = true;
	for id, cfg in pairs(Config) do
		if ((type(cfg) == "table") and (cfg.enabled ~= false) and cfg.required) then
			local currentTier = EventUpgradeCmds.GetTier(id);
			if (currentTier < (cfg.priority_upgrade or 1)) then
				allRequiredDone = false;
				break;
			end
		end
	end
	local bestUpgrade = nil;
	local bestPriority = math.huge;
	local bestCost = math.huge;
	for id, cfg in pairs(Config) do
		local FlatIdent_6C033 = 0;
		local currentTier;
		local maxTier;
		local priority;
		local data;
		local nextTierData;
		local cost;
		while true do
			if (FlatIdent_6C033 == 1) then
				priority = cfg.priority or 99;
				if (currentTier >= maxTier) then
					continue;
				end
				if (not allRequiredDone and (not cfg.required or (currentTier >= (cfg.priority_upgrade or maxTier)))) then
					continue;
				end
				FlatIdent_6C033 = 2;
			end
			if (FlatIdent_6C033 == 3) then
				if (not nextTierData or not nextTierData._data) then
					continue;
				end
				cost = nextTierData._data._am or 1;
				if (currentOrbs >= cost) then
					if ((priority < bestPriority) or ((priority == bestPriority) and (cost < bestCost))) then
						local FlatIdent_47ABB = 0;
						while true do
							if (FlatIdent_47ABB == 1) then
								bestUpgrade = id;
								break;
							end
							if (FlatIdent_47ABB == 0) then
								bestPriority = priority;
								bestCost = cost;
								FlatIdent_47ABB = 1;
							end
						end
					end
				end
				break;
			end
			if (FlatIdent_6C033 == 0) then
				if ((type(cfg) ~= "table") or (cfg.enabled == false)) then
					continue;
				end
				currentTier = EventUpgradeCmds.GetTier(id);
				maxTier = cfg.maxTier or 99;
				FlatIdent_6C033 = 1;
			end
			if (FlatIdent_6C033 == 2) then
				data = luckyUpgrades[id];
				if not data then
					continue;
				end
				nextTierData = data.TierCosts[currentTier + 1];
				FlatIdent_6C033 = 3;
			end
		end
	end
	if bestUpgrade then
		pcall(function()
			EventUpgradeCmds.Purchase(bestUpgrade);
		end);
	end
	return bestUpgrade;
end
local function onBreakablesDestroyed(data)
	if (type(data) == "string") then
		local FlatIdent_45D37 = 0;
		local allBreakables;
		while true do
			if (FlatIdent_45D37 == 1) then
				vmInst:TableSet("AllBreakables", data, nil);
				vmInst:TableSet("BreakablesInUse", data, nil);
				break;
			end
			if (FlatIdent_45D37 == 0) then
				allBreakables = vmInst:Get("AllBreakables");
				if (allBreakables[data] and allBreakables[data].Part) then
					allBreakables[data].Part:Destroy();
				end
				FlatIdent_45D37 = 1;
			end
		end
	elseif (type(data) == "table") then
		local FlatIdent_90A41 = 0;
		local allBreakables;
		while true do
			if (FlatIdent_90A41 == 0) then
				allBreakables = vmInst:Get("AllBreakables");
				for _, breakable in pairs(data) do
					local FlatIdent_6D9D2 = 0;
					local id;
					while true do
						if (FlatIdent_6D9D2 == 0) then
							id = breakable[1];
							if (allBreakables[id] and allBreakables[id].Part) then
								allBreakables[id].Part:Destroy();
							end
							FlatIdent_6D9D2 = 1;
						end
						if (FlatIdent_6D9D2 == 1) then
							vmInst:TableSet("AllBreakables", id, nil);
							vmInst:TableSet("BreakablesInUse", id, nil);
							break;
						end
					end
				end
				break;
			end
		end
	end
end
local function onBreakablesCreated(data)
	for _, breakableData in pairs(data) do
		local FlatIdent_28014 = 0;
		local key;
		local allBreakables;
		while true do
			if (FlatIdent_28014 == 1) then
				allBreakables = vmInst:Get("AllBreakables");
				if not allBreakables[key] then
					local FlatIdent_72421 = 0;
					while true do
						if (FlatIdent_72421 == 0) then
							vmInst:TableSet("AllBreakables", key, breakableData[1]);
							vmInst:TableSet("BreakablesInUse", key, {});
							break;
						end
					end
				end
				break;
			end
			if (FlatIdent_28014 == 0) then
				if (not breakableData[1] or not breakableData[1].u) then
					continue;
				end
				key = tostring(breakableData[1].u);
				FlatIdent_28014 = 1;
			end
		end
	end
end
local function onBreakableCleanup(data)
	for _, entry in pairs(data) do
		local key = tostring(entry[1]);
		vmInst:TableSet("AllBreakables", key, nil);
		vmInst:TableSet("BreakablesInUse", key, nil);
	end
end
local events = {"Breakables_Created","Breakables_Ping","Breakables_DestroyDueToReplicationFail","Breakables_Cleanup","Orbs: Create"};
for _, event in ipairs(events) do
	for _, connection in ipairs(getconnections(Network.Fired(event))) do
		connection:Disconnect();
	end
end
Network.Fired("Breakables_Created"):Connect(onBreakablesCreated);
Network.Fired("Breakables_Ping"):Connect(onBreakablesCreated);
Network.Fired("Breakables_Destroyed"):Connect(onBreakablesDestroyed);
Network.Fired("Breakables_DestroyDueToReplicationFail"):Connect(onBreakablesDestroyed);
Network.Fired("Breakables_Cleanup"):Connect(onBreakableCleanup);
Network.Fired("Orbs: Create"):Connect(function(Orbs)
	local FlatIdent_4508F = 0;
	local Collect;
	while true do
		if (FlatIdent_4508F == 1) then
			if (#Collect > 0) then
				pcall(function()
					Network.Fire("Orbs: Collect", Collect);
				end);
			end
			break;
		end
		if (FlatIdent_4508F == 0) then
			Collect = {};
			for _, v in ipairs(Orbs) do
				local FlatIdent_1013A = 0;
				local ID;
				while true do
					if (0 == FlatIdent_1013A) then
						ID = tonumber(v.id);
						if ID then
							table.insert(Collect, ID);
						end
						break;
					end
				end
			end
			FlatIdent_4508F = 1;
		end
	end
end);
Network.Fired("CustomEggs_Updated"):Connect(function(p194)
	for id, data in pairs(p194) do
		if eggs[id] then
			local FlatIdent_77172 = 0;
			while true do
				if (FlatIdent_77172 == 0) then
					if data.hatchable then
						eggs[id].hatchable = data.hatchable;
					end
					if data.renderable then
						eggs[id].renderable = data.renderable;
					end
					break;
				end
			end
		end
	end
end);
Network.Fired("CustomEggs_Broadcast"):Connect(function(data)
	local FlatIdent_521D6 = 0;
	local model;
	while true do
		if (0 == FlatIdent_521D6) then
			model = THINGS.CustomEggs:WaitForChild(data.uid, 60);
			if model then
				eggs[data.uid] = {model=model,position=model:GetPivot().Position,hatchable=data.hatchable,renderable=data.renderable,id=data.id,uid=data.uid,dir=Eggs_Directory[data.id]};
			end
			break;
		end
	end
end);
for uid, data in pairs(CustomEggsCmds.All()) do
	eggs[uid] = {model=data._model,position=data._position,hatchable=data._hatchable,renderable=data._renderable,id=data._id,uid=data._uid,dir=data._dir};
end
local function updateEuids()
	if (type(PetNetworking.EquippedPets()) ~= "table") then
		return;
	end
	vmInst:TableClear("Euids");
	vmInst:TableClear("PetIDs");
	for petID, petData in pairs(PetNetworking.EquippedPets()) do
		vmInst:TableSet("Euids", petID, petData);
		vmInst:TableInsert("PetIDs", petID);
	end
	local validPets = {};
	for _, petID in ipairs(vmInst:Get("PetIDs")) do
		if vmInst:Get("Euids")[petID] then
			table.insert(validPets, petID);
		end
	end
	vmInst:TableClear("PetIDs");
	for _, v in ipairs(validPets) do
		vmInst:TableInsert("PetIDs", v);
	end
	Network.Fired("Pets_LocalPetsUpdated"):Connect(function(pets)
		local FlatIdent_634AF = 0;
		local euids;
		while true do
			if (0 == FlatIdent_634AF) then
				if (type(pets) ~= "table") then
					return;
				end
				euids = vmInst:Get("Euids");
				FlatIdent_634AF = 1;
			end
			if (FlatIdent_634AF == 1) then
				for _, v in pairs(pets) do
					if (v.ePet and v.ePet.euid and not euids[v.ePet.euid]) then
						local FlatIdent_21297 = 0;
						while true do
							if (FlatIdent_21297 == 0) then
								vmInst:TableSet("Euids", v.ePet.euid, v.ePet);
								vmInst:TableInsert("PetIDs", v.ePet.euid);
								break;
							end
						end
					end
				end
				break;
			end
		end
	end);
	Network.Fired("Pets_LocalPetsUnequipped"):Connect(function(pets)
		local FlatIdent_91608 = 0;
		local validPets;
		while true do
			if (FlatIdent_91608 == 1) then
				validPets = {};
				for _, petID in ipairs(vmInst:Get("PetIDs")) do
					if vmInst:Get("Euids")[petID] then
						table.insert(validPets, petID);
					end
				end
				FlatIdent_91608 = 2;
			end
			if (2 == FlatIdent_91608) then
				vmInst:TableClear("PetIDs");
				for _, v in ipairs(validPets) do
					vmInst:TableInsert("PetIDs", v);
				end
				break;
			end
			if (FlatIdent_91608 == 0) then
				if (type(pets) ~= "table") then
					return;
				end
				for _, petID in pairs(pets) do
					vmInst:TableSet("Euids", petID, nil);
				end
				FlatIdent_91608 = 1;
			end
		end
	end);
end
updateEuids();
task.spawn(function()
	local function ManageFruits()
		local FlatIdent_276C2 = 0;
		local fruitInv;
		local bestFruits;
		local activeFruits;
		while true do
			if (FlatIdent_276C2 == 0) then
				fruitInv = Save.Get().Inventory.Fruit;
				if not fruitInv then
					return;
				end
				FlatIdent_276C2 = 1;
			end
			if (FlatIdent_276C2 == 1) then
				bestFruits = {};
				for uid, data in pairs(fruitInv) do
					if (data.id and (data.id ~= "Candycane")) then
						local FlatIdent_8E5B4 = 0;
						local baseId;
						local currentBestUid;
						while true do
							if (FlatIdent_8E5B4 == 1) then
								if not currentBestUid then
									bestFruits[baseId] = uid;
								else
									local FlatIdent_7063 = 0;
									local currentBestData;
									local isNewShiny;
									local isOldShiny;
									while true do
										if (FlatIdent_7063 == 0) then
											currentBestData = fruitInv[currentBestUid];
											isNewShiny = data.sh == true;
											FlatIdent_7063 = 1;
										end
										if (FlatIdent_7063 == 1) then
											isOldShiny = currentBestData.sh == true;
											if (isNewShiny and not isOldShiny) then
												bestFruits[baseId] = uid;
											elseif (isNewShiny == isOldShiny) then
												local newAmt = data._am or 1;
												local oldAmt = currentBestData._am or 1;
												if (newAmt > oldAmt) then
													bestFruits[baseId] = uid;
												end
											end
											break;
										end
									end
								end
								break;
							end
							if (FlatIdent_8E5B4 == 0) then
								baseId = data.id;
								currentBestUid = bestFruits[baseId];
								FlatIdent_8E5B4 = 1;
							end
						end
					end
				end
				FlatIdent_276C2 = 2;
			end
			if (FlatIdent_276C2 == 3) then
				if (type(activeFruits) ~= "table") then
					activeFruits = {};
				end
				for fruitName, uid in pairs(bestFruits) do
					local FlatIdent_3B08E = 0;
					local hasBuff;
					local activeData;
					while true do
						if (FlatIdent_3B08E == 0) then
							hasBuff = false;
							activeData = activeFruits[fruitName];
							FlatIdent_3B08E = 1;
						end
						if (FlatIdent_3B08E == 1) then
							if activeData then
								if ((type(activeData) == "number") and (activeData > 0)) then
									hasBuff = true;
								elseif ((type(activeData) == "table") and (next(activeData) ~= nil)) then
									hasBuff = true;
								elseif (activeData == true) then
									hasBuff = true;
								end
							end
							if not hasBuff then
								local FlatIdent_3CDED = 0;
								while true do
									if (0 == FlatIdent_3CDED) then
										pcall(function()
											FruitCmds.Consume(uid, 1);
										end);
										pcall(function()
											Network.Fire("Fruits: Consume", uid, 1);
										end);
										FlatIdent_3CDED = 1;
									end
									if (FlatIdent_3CDED == 1) then
										task.wait(0.2);
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (FlatIdent_276C2 == 2) then
				activeFruits = nil;
				pcall(function()
					activeFruits = FruitCmds.GetActiveFruits();
				end);
				FlatIdent_276C2 = 3;
			end
		end
	end
	ManageFruits();
	Network.Fired("Fruits: Update"):Connect(function()
		local FlatIdent_3B868 = 0;
		while true do
			if (FlatIdent_3B868 == 0) then
				task.wait(1);
				ManageFruits();
				break;
			end
		end
	end);
end);
task.spawn(function()
	local breakableOffset = 0;
	while true do
		local FlatIdent_D14D = 0;
		local availableBreakables;
		while true do
			if (FlatIdent_D14D == 0) then
				task.wait();
				vmInst:Set("current_zone", InstancingCmds.GetInstanceID() or MapCmds.GetCurrentZone());
				FlatIdent_D14D = 1;
			end
			if (1 == FlatIdent_D14D) then
				availableBreakables = {};
				for key, info in pairs(vmInst:Get("AllBreakables")) do
					if ((info.pid == vmInst:Get("current_zone")) and (info.id ~= "Ice Block")) then
						table.insert(availableBreakables, key);
					end
				end
				FlatIdent_D14D = 2;
			end
			if (FlatIdent_D14D == 2) then
				if (#availableBreakables > 0) then
					local now = os.clock();
					local lastUseEuids = vmInst:Get("LastUseEuids");
					local bulkAssignments = {};
					for i, petID in ipairs(vmInst:Get("PetIDs")) do
						if vmInst:Get("Euids")[petID] then
							local FlatIdent_77478 = 0;
							local lastData;
							local blockedKey;
							local filtered;
							local pool;
							while true do
								if (FlatIdent_77478 == 0) then
									lastData = lastUseEuids[petID];
									blockedKey = (lastData and ((now - lastData.time) < 1) and lastData.breakableKey) or nil;
									FlatIdent_77478 = 1;
								end
								if (1 == FlatIdent_77478) then
									filtered = {};
									for _, key in ipairs(availableBreakables) do
										if (key ~= blockedKey) then
											table.insert(filtered, key);
										end
									end
									FlatIdent_77478 = 2;
								end
								if (FlatIdent_77478 == 3) then
									bulkAssignments[petID] = pool[(((i - 1) + breakableOffset) % #pool) + 1];
									vmInst:TableSet("LastUseEuids", petID, {time=now,breakableKey=pool[(((i - 1) + breakableOffset) % #pool) + 1]});
									break;
								end
								if (FlatIdent_77478 == 2) then
									pool = filtered;
									if (#filtered == 0) then
										local oldestKey = nil;
										local oldestTime = math.huge;
										local lastUseEuidsAll = vmInst:Get("LastUseEuids");
										for _, key in ipairs(availableBreakables) do
											local lastUsed = -math.huge;
											for _, data in pairs(lastUseEuidsAll) do
												if ((data.breakableKey == key) and (data.time > lastUsed)) then
													lastUsed = data.time;
												end
											end
											if (lastUsed < oldestTime) then
												local FlatIdent_B1F4 = 0;
												while true do
													if (FlatIdent_B1F4 == 0) then
														oldestTime = lastUsed;
														oldestKey = key;
														break;
													end
												end
											end
										end
										pool = {(oldestKey or availableBreakables[1])};
									end
									FlatIdent_77478 = 3;
								end
							end
						end
					end
					if next(bulkAssignments) then
						local FlatIdent_656E9 = 0;
						while true do
							if (FlatIdent_656E9 == 1) then
								task.wait(0.1);
								break;
							end
							if (FlatIdent_656E9 == 0) then
								task.spawn(function()
									pcall(function()
										Network.Fire("Breakables_JoinPetBulk", bulkAssignments);
									end);
								end);
								pcall(function()
									Network.UnreliableFire("Breakables_PlayerDealDamage", tostring(availableBreakables[1]));
								end);
								FlatIdent_656E9 = 1;
							end
						end
					end
					breakableOffset = breakableOffset + 1;
				else
					local FlatIdent_163A8 = 0;
					while true do
						if (FlatIdent_163A8 == 0) then
							vmInst:Set("current_zone", nil);
							breakableOffset = 0;
							break;
						end
					end
				end
				break;
			end
		end
	end
end);
task.spawn(function()
	local Data = Save.Get();
	local StartEggs = Data.EggsHatched or 0;
	local discovered_Huge_titan = {};
	local localPlayer = game:GetService("Players").LocalPlayer;
	local totalhuges = 0;
	local function getPetLabel(data)
		local FlatIdent_1E5DB = 0;
		local prefix;
		while true do
			if (FlatIdent_1E5DB == 0) then
				prefix = "";
				if data.sh then
					prefix = "Shiny ";
				end
				FlatIdent_1E5DB = 1;
			end
			if (FlatIdent_1E5DB == 1) then
				if (data.pt == 1) then
					prefix = prefix .. "Golden ";
				elseif (data.pt == 2) then
					prefix = prefix .. "Rainbow ";
				end
				return prefix .. data.id;
			end
		end
	end
	local function sendWebhook(data)
		local FlatIdent_40096 = 0;
		local isTitanic;
		local isShiny;
		local isRainbow;
		local isGolden;
		local color;
		local pingText;
		local body;
		while true do
			if (FlatIdent_40096 == 0) then
				if (not Webhook or not Webhook.url or (Webhook.url == "")) then
					return;
				end
				isTitanic = string.find(data.id, "Titanic") or string.find(data.id, "titanic");
				FlatIdent_40096 = 1;
			end
			if (FlatIdent_40096 == 2) then
				isGolden = data.pt == 1;
				color = (isRainbow and 11141375) or (isGolden and 16766720) or (isShiny and 4031935) or (isTitanic and 16711680) or 16776960;
				FlatIdent_40096 = 3;
			end
			if (FlatIdent_40096 == 3) then
				pingText = "";
				if Webhook["Discord Id to ping"] then
					local FlatIdent_6E214 = 0;
					local ids;
					while true do
						if (FlatIdent_6E214 == 0) then
							ids = Webhook["Discord Id to ping"];
							if (type(ids) == "table") then
								for _, id in ipairs(ids) do
									if ((tostring(id) ~= "") and (tostring(id) ~= "0")) then
										pingText = pingText .. "<@" .. tostring(id) .. "> ";
									end
								end
							elseif ((tostring(ids) ~= "") and (tostring(ids) ~= "0")) then
								pingText = "<@" .. tostring(ids) .. ">";
							end
							break;
						end
					end
				end
				FlatIdent_40096 = 4;
			end
			if (FlatIdent_40096 == 1) then
				isShiny = data.sh;
				isRainbow = data.pt == 2;
				FlatIdent_40096 = 2;
			end
			if (FlatIdent_40096 == 4) then
				body = game:GetService("HttpService"):JSONEncode({content=(((pingText ~= "") and pingText) or nil),embeds={{title=((isTitanic and "✨ Titanic Hatched!") or "🎉 Huge Hatched!"),description=("**" .. localPlayer.Name .. "** hatched a **" .. getPetLabel(data) .. "**"),color=color,footer={text=("Eggs hatched: " .. tostring(Data.EggsHatched - StartEggs))}}}});
				pcall(function()
					request({Url=Webhook.url,Method="POST",Headers={["Content-Type"]="application/json"},Body=body});
				end);
				break;
			end
		end
	end
	for UUID, data in pairs(Data.Inventory.Pet or {}) do
		if (string.find(data.id, "Huge") or string.find(data.id, "Titanic") or string.find(data.id, "titanic")) then
			discovered_Huge_titan[UUID] = true;
		end
	end
	while task.wait() do
		local FlatIdent_90E07 = 0;
		while true do
			if (FlatIdent_90E07 == 0) then
				Data = Save.Get();
				for UUID, data in pairs(Data.Inventory.Pet or {}) do
					if (string.find(data.id, "Huge") or string.find(data.id, "Titanic") or string.find(data.id, "titanic")) then
						if not discovered_Huge_titan[UUID] then
							local FlatIdent_4AB8B = 0;
							while true do
								if (FlatIdent_4AB8B == 1) then
									if (string.find(data.id, "Titanic") or string.find(data.id, "titanic")) then
										local FlatIdent_3831 = 0;
										while true do
											if (FlatIdent_3831 == 0) then
												totaltitanics = totaltitanics + 1;
												UI:SetText("Titanics", "Session Titanics: " .. tostring(totaltitanics));
												break;
											end
										end
									else
										totalhuges = totalhuges + 1;
										UI:SetText("Huges", "Session Huges: " .. tostring(totalhuges));
									end
									break;
								end
								if (FlatIdent_4AB8B == 0) then
									discovered_Huge_titan[UUID] = true;
									pcall(sendWebhook, data);
									FlatIdent_4AB8B = 1;
								end
							end
						end
					end
				end
				FlatIdent_90E07 = 1;
			end
			if (FlatIdent_90E07 == 1) then
				UI:SetText("Eggs", "Total Eggs Hatched: " .. UI:Format(Data.EggsHatched - StartEggs));
				PurchaseUpgrades();
				FlatIdent_90E07 = 2;
			end
			if (FlatIdent_90E07 == 2) then
				pcall(function()
					Network.Invoke("Mailbox: Claim All");
				end);
				break;
			end
		end
	end
end);
local function OpenBossRooms(CurrentRaid)
	if not CurrentRaid then
		return;
	end
	local BossSettings = Raid["Boss Settings"];
	if (not BossSettings or not BossSettings.Enabled) then
		return;
	end
	local targetBosses = BossSettings.TargetBosses or {};
	for i, v in pairs(Raids.BossDirectory) do
		local FlatIdent_21E03 = 0;
		local bossName;
		local timer;
		local Success;
		local Error;
		while true do
			if (FlatIdent_21E03 == 2) then
				if ((v.BossNumber == 3) and (Items.Misc("Lucky Raid Boss Key V2"):CountExact() < 1)) then
					continue;
				end
				timer = os.clock();
				FlatIdent_21E03 = 3;
			end
			if (FlatIdent_21E03 == 1) then
				if not table.find(targetBosses, bossName) then
					continue;
				end
				if BossSettings.UpgradeBossChests then
					local FlatIdent_270C = 0;
					local created;
					while true do
						if (FlatIdent_270C == 0) then
							created = nil;
							pcall(function()
								created = Network.Invoke("LuckyRaid_PullLever", v.BossNumber);
							end);
							FlatIdent_270C = 1;
						end
						if (FlatIdent_270C == 1) then
							if created then
								UI:SetText("Status", "Status: Upgraded " .. bossName .. " Chest...");
								task.wait(0.25);
							end
							break;
						end
					end
				end
				FlatIdent_21E03 = 2;
			end
			if (FlatIdent_21E03 == 0) then
				if (CurrentRaid._roomNumber < v.RequiredRoom) then
					continue;
				end
				bossName = "Boss " .. tostring(v.BossNumber);
				FlatIdent_21E03 = 1;
			end
			if (3 == FlatIdent_21E03) then
				Success, Error = nil;
				repeat
					task.wait();
					pcall(function()
						Success, Error = Network.Invoke("Raids_StartBoss", v.BossNumber);
					end);
				until Success or Error or ((os.clock() - timer) >= 3) 
				break;
			end
		end
	end
end
Network.Fired("Raid: Spawned Room"):Connect(function(RoomNumber)
	UI:SetText("Room", "Current Room: " .. tostring(RoomNumber));
	pcall(function()
		Network.Invoke("LuckyRaidBossKey_Combine", 1);
	end);
end);
HumanoidRootPart.Anchored = true;
EnterInstance("LuckyEventWorld");
if Raid.Enabled then
	while task.wait() do
		local CurrentRaid = RaidInstance.GetByOwner(Player);
		if (not CurrentRaid or vmInst:Get("LeftOnPurpose")) then
			local FlatIdent_23FF9 = 0;
			local Level;
			local OpenPortal;
			while true do
				if (FlatIdent_23FF9 == 0) then
					vmInst:Set("LeftOnPurpose", false);
					Level = RaidCmds.GetLevel();
					FlatIdent_23FF9 = 1;
				end
				if (FlatIdent_23FF9 == 1) then
					UI:SetText("Level", "Current Level: " .. tostring(Level));
					UI:SetText("Status", "Status: Creating Raid...");
					FlatIdent_23FF9 = 2;
				end
				if (FlatIdent_23FF9 == 2) then
					OpenPortal = nil;
					for i = 1, 10 do
						local Portal = RaidInstance.GetByPortal(i);
						if (not Portal or (Portal and (Portal._owner == game.Players.LocalPlayer))) then
							OpenPortal = i;
							break;
						end
					end
					FlatIdent_23FF9 = 3;
				end
				if (FlatIdent_23FF9 == 4) then
					task.wait();
					break;
				end
				if (FlatIdent_23FF9 == 3) then
					pcall(function()
						Network.Fire("Instancing_PlayerLeaveInstance", "LuckyRaid");
					end);
					pcall(function()
						Network.Invoke("Raids_RequestCreate", {Difficulty=(((type(Raid.Difficulty) == "number") and (Level >= Raid.Difficulty) and Raid.Difficulty) or Level),Portal=OpenPortal,PartyMode=1});
					end);
					FlatIdent_23FF9 = 4;
				end
			end
		end
		repeat
			task.wait(0.25);
			CurrentRaid = RaidInstance.GetByOwner(Player);
		until CurrentRaid 
		if CurrentRaid then
			UI:SetText("Status", "Status: Joining Raid...");
			local RaidID = CurrentRaid._id;
			local Joined = false;
			pcall(function()
				Joined = Network.Invoke("Raids_Join", RaidID);
			end);
			if not Joined then
				repeat
					local FlatIdent_559FF = 0;
					while true do
						if (FlatIdent_559FF == 0) then
							task.wait(0.5);
							pcall(function()
								Joined = Network.Invoke("Raids_Join", RaidID);
							end);
							break;
						end
					end
				until Joined 
			end
			task.wait(0.2);
			repeat
				task.wait();
			until __FAKE_INSTANCE_BREAK_ZONES:FindFirstChild("Main", true) 
			__FAKE_INSTANCE_BREAK_ZONES:FindFirstChild("Main", true).CanCollide = true;
			mainPos = __FAKE_INSTANCE_BREAK_ZONES:FindFirstChild("Main", true).CFrame;
			local completed = false;
			local completedTime = 0;
			local total = 0;
			Network.Fired("Raid: Completed"):Once(function()
				local FlatIdent_61F8E = 0;
				while true do
					if (1 == FlatIdent_61F8E) then
						totalRaidsCompleted = totalRaidsCompleted + 1;
						UI:SetText("RaidsCompleted", "Total Raids Completed: " .. tostring(totalRaidsCompleted));
						break;
					end
					if (FlatIdent_61F8E == 0) then
						completed = true;
						completedTime = os.clock();
						FlatIdent_61F8E = 1;
					end
				end
			end);
			UI:SetText("Status", "Status: Farming Breakables...");
			repeat
				task.wait();
				OpenBossRooms(RaidInstance.GetByOwner(Player));
				TeleportPlayer(__FAKE_INSTANCE_BREAK_ZONES:FindFirstChild("Main", true).CFrame + Vector3.new(0, 3, 0));
				total = 0;
				for key, info in pairs(vmInst:Get("AllBreakables")) do
					if ((info.pid and info.pid:lower():find("raid")) or (info.id and info.id:lower():find("raid"))) then
						total += 1
					end
				end
				UI:SetText("BreakablesLeft", "Total Breakables Left: " .. tostring(total));
				if (completed and ((os.clock() - completedTime) >= 3)) then
					break;
				end
			until completed and (total == 0) 
			UI:SetText("Status", "Status: Opening Chests...");
			for chestId, chestData in pairs(CurrentRaid._chests) do
				if (chestId:find("Sign") or (chestId:find("Leprechaun") and not Raid.OpenLeprechaunChest)) then
					continue;
				end
				chestsPos[chestId] = chestData.Model:FindFirstChildOfClass("MeshPart").CFrame;
				if (chestData.Opened or not chestData.Model or not chestData.Model:FindFirstChildOfClass("MeshPart")) then
					continue;
				end
				TeleportPlayer(chestData.Model:FindFirstChildOfClass("MeshPart").CFrame);
				local success, reason;
				local chestRetries = 0;
				repeat
					local FlatIdent_7993F = 0;
					while true do
						if (FlatIdent_7993F == 1) then
							chestRetries = chestRetries + 1;
							break;
						end
						if (FlatIdent_7993F == 0) then
							task.wait();
							pcall(function()
								success, reason = Network.Invoke("Raids_OpenChest", chestId);
							end);
							FlatIdent_7993F = 1;
						end
					end
				until success or string.find(reason or "tier", "tier") or (chestRetries > 10) 
			end
			for chestId, cPos in pairs(chestsPos) do
				local FlatIdent_9525B = 0;
				local success;
				local reason;
				local chestRetries;
				while true do
					if (FlatIdent_9525B == 1) then
						chestRetries = 0;
						repeat
							local FlatIdent_12E4E = 0;
							while true do
								if (1 == FlatIdent_12E4E) then
									chestRetries = chestRetries + 1;
									break;
								end
								if (0 == FlatIdent_12E4E) then
									task.wait();
									pcall(function()
										success, reason = Network.Invoke("Raids_OpenChest", chestId);
									end);
									FlatIdent_12E4E = 1;
								end
							end
						until success or string.find(reason or "tier", "tier") or (chestRetries > 10) 
						break;
					end
					if (FlatIdent_9525B == 0) then
						TeleportPlayer(cPos);
						success, reason = nil;
						FlatIdent_9525B = 1;
					end
				end
			end
			mainfound = true;
			if (Raid["Egg Settings"].Enabled and Save.Get().RaidEggMultiplier and (Save.Get().RaidEggMultiplier >= Raid["Egg Settings"].MinimumEggMulti) and CurrencyCmds.CanAfford("LuckyCoins", Raid["Egg Settings"].MinimumLuckyCoins)) then
				local FlatIdent_5C0FA = 0;
				local LuckyEgg;
				local EggPrice;
				local EggPosition;
				local StartingTime;
				local MaxEggHatch;
				local NeedsPrice;
				local multiplier;
				while true do
					if (FlatIdent_5C0FA == 3) then
						multiplier = Save.Get().RaidEggMultiplier;
						UI:SetText("Status", "Status: Hatching Egg | x" .. tostring(multiplier));
						repeat
							local FlatIdent_8770C = 0;
							while true do
								if (FlatIdent_8770C == 1) then
									TeleportPlayer(CFrame.new(EggPosition));
									break;
								end
								if (FlatIdent_8770C == 0) then
									task.wait();
									pcall(function()
										Network.Invoke("CustomEggs_Hatch", LuckyEgg, MaxEggHatch);
									end);
									FlatIdent_8770C = 1;
								end
							end
						until not CurrencyCmds.CanAfford("LuckyCoins", NeedsPrice) or ((os.time() - StartingTime) >= (Raid["Egg Settings"].MaxOpenTime * 60)) 
						break;
					end
					if (1 == FlatIdent_5C0FA) then
						TeleportPlayer(CFrame.new(3443, -167, 3534));
						LuckyEgg, EggPrice, EggPosition = nil;
						repeat
							local FlatIdent_2C195 = 0;
							while true do
								if (FlatIdent_2C195 == 0) then
									task.wait();
									for UID, data in pairs(eggs) do
										if not (data.hatchable and data.renderable and data.position) then
											continue;
										end
										local Power = EventUpgradeCmds.GetPower("LuckyRaidEggCost");
										local CheaperEggs = (MasteryCmds.HasPerk("Eggs", "CheaperEggs") and MasteryCmds.GetPerkPower("Eggs", "CheaperEggs")) or 0;
										EggPrice = CalcEggPrice(data.dir) * (1 - (Power / 100)) * (1 - (CheaperEggs / 100));
										LuckyEgg = UID;
										EggPosition = data.position;
										break;
									end
									break;
								end
							end
						until LuckyEgg and EggPrice 
						FlatIdent_5C0FA = 2;
					end
					if (2 == FlatIdent_5C0FA) then
						StartingTime = os.time();
						MaxEggHatch = EggCmds.GetMaxHatch();
						NeedsPrice = EggPrice * MaxEggHatch;
						FlatIdent_5C0FA = 3;
					end
					if (FlatIdent_5C0FA == 0) then
						pcall(function()
							Network.Fire("Instancing_PlayerLeaveInstance", "LuckyRaid");
						end);
						task.wait(0.1);
						pcall(function()
							Network.Invoke("Instancing_PlayerEnterInstance", "LuckyEgg");
						end);
						FlatIdent_5C0FA = 1;
					end
				end
			end
			vmInst:Set("LeftOnPurpose", true);
		end
	end
end
