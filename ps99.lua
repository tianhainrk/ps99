

local obf_stringchar = string.char;
local obf_stringbyte = string.byte;
local obf_stringsub = string.sub;
local obf_bitlib = bit32 or bit;
local obf_XOR = obf_bitlib.bxor;
local obf_tableconcat = table.concat;
local obf_tableinsert = table.insert;
local function LUAOBFUSACTOR_DECRYPT_STR_0(LUAOBFUSACTOR_STR, LUAOBFUSACTOR_KEY)
	local result = {};
	for i = 1, #LUAOBFUSACTOR_STR do
		obf_tableinsert(result, obf_stringchar(obf_XOR(obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_STR, i, i + 1)), obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_KEY, 1 + (i % #LUAOBFUSACTOR_KEY), 1 + (i % #LUAOBFUSACTOR_KEY) + 1))) % 256));
	end
	return obf_tableconcat(result);
end
bit32 = {};
local v0 = 54 - 22;
local v1 = (1520 - (1191 + 327)) ^ v0;
bit32.bnot = function(v82)
	local v83 = 0 + 0;
	while true do
		if (v83 == 0) then
			v82 = v82 % v1;
			return (v1 - (699 - (208 + 490))) - v82;
		end
	end
end;
bit32.band = function(v84, v85)
	local v86 = 0 + 0;
	local v87;
	local v88;
	while true do
		if (v86 == (1 + 1)) then
			v87 = 836 - (660 + 176);
			v88 = 1;
			v86 = 1 + 2;
		end
		if (v86 == (203 - (14 + 188))) then
			if (v85 == (4294967970 - (534 + 141))) then
				return v84 % 4294967296;
			end
			v84, v85 = v84 % v1, v85 % v1;
			v86 = 1 + 1;
		end
		if (v86 == 3) then
			for v300 = 1 + 0, v0 do
				local v301 = 0;
				local v302;
				local v303;
				while true do
					if (v301 == (1 + 0)) then
						if ((v302 + v303) == (3 - 1)) then
							v87 = v87 + v88;
						end
						v88 = (2 - 0) * v88;
						break;
					end
					if (v301 == (0 - 0)) then
						v302, v303 = v84 % 2, v85 % (2 + 0);
						v84, v85 = math.floor(v84 / (2 + 0)), math.floor(v85 / (398 - (115 + 281)));
						v301 = 2 - 1;
					end
				end
			end
			return v87;
		end
		if (v86 == 0) then
			if (v85 == 255) then
				return v84 % (212 + 44);
			end
			if (v85 == 65535) then
				return v84 % (158384 - 92848);
			end
			v86 = 1;
		end
	end
end;
bit32.bor = function(v89, v90)
	local v91 = 0 - 0;
	local v92;
	local v93;
	while true do
		if (v91 == 0) then
			if (v90 == 255) then
				return (v89 - (v89 % (1123 - (550 + 317)))) + (368 - 113);
			end
			if (v90 == (92114 - 26579)) then
				return (v89 - (v89 % (183138 - 117602))) + (65820 - (134 + 151));
			end
			v91 = 1666 - (970 + 695);
		end
		if ((1 - 0) == v91) then
			if (v90 == 4294967295) then
				return 4294969285 - (582 + 1408);
			end
			v89, v90 = v89 % v1, v90 % v1;
			v91 = 6 - 4;
		end
		if (v91 == (2 - 0)) then
			v92 = 0 - 0;
			v93 = 1825 - (1195 + 629);
			v91 = 3 - 0;
		end
		if ((244 - (187 + 54)) == v91) then
			for v304 = 781 - (162 + 618), v0 do
				local v305, v306 = v89 % (2 + 0), v90 % (2 + 0);
				v89, v90 = math.floor(v89 / (3 - 1)), math.floor(v90 / (2 - 0));
				if ((v305 + v306) >= (1 + 0)) then
					v92 = v92 + v93;
				end
				v93 = 2 * v93;
			end
			return v92;
		end
	end
end;
bit32.bxor = function(v94, v95)
	v94, v95 = v94 % v1, v95 % v1;
	local v96 = 1636 - (1373 + 263);
	local v97 = 1;
	for v222 = 1, v0 do
		local v223, v224 = v94 % 2, v95 % (1002 - (451 + 549));
		v94, v95 = math.floor(v94 / (1 + 1)), math.floor(v95 / (2 - 0));
		if ((v223 + v224) == (1 - 0)) then
			v96 = v96 + v97;
		end
		v97 = (1386 - (746 + 638)) * v97;
	end
	return v96;
end;
bit32.lshift = function(v98, v99)
	if (math.abs(v99) >= v0) then
		return 0 + 0;
	end
	v98 = v98 % v1;
	if (v99 < (0 - 0)) then
		return math.floor(v98 * (2 ^ v99));
	else
		return (v98 * ((343 - (218 + 123)) ^ v99)) % v1;
	end
end;
bit32.rshift = function(v100, v101)
	if (math.abs(v101) >= v0) then
		return 0;
	end
	v100 = v100 % v1;
	if (v101 > (1581 - (1535 + 46))) then
		return math.floor(v100 * (2 ^ -v101));
	else
		return (v100 * ((2 + 0) ^ -v101)) % v1;
	end
end;
bit32.arshift = function(v102, v103)
	if (math.abs(v103) >= v0) then
		return 0 + 0;
	end
	v102 = v102 % v1;
	if (v103 > (560 - (306 + 254))) then
		local v283 = 0 + 0;
		if (v102 >= (v1 / (3 - 1))) then
			v283 = v1 - (2 ^ (v0 - v103));
		end
		return math.floor(v102 * (2 ^ -v103)) + v283;
	else
		return (v102 * ((1469 - (899 + 568)) ^ -v103)) % v1;
	end
end;
if _G.Started then
	return;
end
_G.Started = true;
local v9 = {[LUAOBFUSACTOR_DECRYPT_STR_0("\227\194\210\33\166\136\194\10\197\202\213\34\245", "\126\177\163\187\69\134\219\167")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\6\195\43\199\240\38\201", "\156\67\173\74\165")]=true,[LUAOBFUSACTOR_DECRYPT_STR_0("\16\190\79\16\181\37\83\56\163\80", "\38\84\215\41\118\220\70")]=1,[LUAOBFUSACTOR_DECRYPT_STR_0("\127\6\39\28\210\85\6\48\23\253\88\23\55\28\221\88\19\49\6", "\158\48\118\66\114")]=false,[LUAOBFUSACTOR_DECRYPT_STR_0("\137\43\3\37\51\150\254\191\48\25\56\116\182", "\155\203\68\112\86\19\197")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\99\211\55\254\76\125\225", "\152\38\189\86\156\32\24\133")]=true,[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67\133\73\239\68\162\85", "\38\156\55\199")]={LUAOBFUSACTOR_DECRYPT_STR_0("\138\114\111\59\83\37", "\35\200\29\28\72\115\20\154"),LUAOBFUSACTOR_DECRYPT_STR_0("\59\176\194\204\205\126", "\84\121\223\177\191\237\76"),LUAOBFUSACTOR_DECRYPT_STR_0("\153\89\218\179\122\3", "\161\219\54\169\192\90\48\80")},[LUAOBFUSACTOR_DECRYPT_STR_0("\124\82\7\55\72\70\5\7\70\81\19\6\65\71\19\49\90", "\69\41\34\96")]=true},[LUAOBFUSACTOR_DECRYPT_STR_0("\153\196\208\74\49\46\168\215\222\4\5\56", "\75\220\163\183\106\98")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\39\180\138\53\213\7\190", "\185\98\218\235\87")]=true,[LUAOBFUSACTOR_DECRYPT_STR_0("\230\53\41\239\211\191\198\25\32\225\243\191\199\40\46", "\202\171\92\71\134\190")]=(1103 - (268 + 335)),[LUAOBFUSACTOR_DECRYPT_STR_0("\4\200\34\129\36\212\33\164\60\194\39\145\10\206\37\134\58", "\232\73\161\76")]=LUAOBFUSACTOR_DECRYPT_STR_0("\234\212", "\126\219\185\34\61"),[LUAOBFUSACTOR_DECRYPT_STR_0("\33\207\70\93\110\114\253\211\5\195\91", "\135\108\174\62\18\30\23\147")]=(320 - (60 + 230))}},[LUAOBFUSACTOR_DECRYPT_STR_0("\129\236\40\195\23\161\56", "\167\214\137\74\171\120\206\83")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\158\226\62", "\199\235\144\82\61\152")]="",[LUAOBFUSACTOR_DECRYPT_STR_0("\35\31\170\40\8\4\189\107\46\18\249\63\8\86\169\34\9\17", "\75\103\118\217")]={""}},[LUAOBFUSACTOR_DECRYPT_STR_0("\242\68\119\6\184\26\194\103\117\0\173\23\201\83\99", "\126\167\52\16\116\217")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\237\32\33\130\184\28\248", "\156\168\78\64\224\212\121")]=true,[LUAOBFUSACTOR_DECRYPT_STR_0("\50\254\162\220\6\234\160\221", "\174\103\142\197")]={LUAOBFUSACTOR_DECRYPT_STR_0("\122\61\92\51\60\108\249\95\44\125\55\54\77\208\67\47\90\27\45\95\246\85\45\76", "\152\54\72\63\88\69\62"),LUAOBFUSACTOR_DECRYPT_STR_0("\248\209\237\87\205\246\239\85\208\230\225\79\199\240\231\72\213\202\231\95\247\204\239\82\215\193\253", "\60\180\164\142"),LUAOBFUSACTOR_DECRYPT_STR_0("\116\75\6\34\62\223\19\81\90\49\32\51\236\28\81\93\38\33\34\254\6", "\114\56\62\101\73\71\141"),LUAOBFUSACTOR_DECRYPT_STR_0("\148\252\216\207\161\219\218\205\188\193\206\195\189\202\211\193\171\253", "\164\216\137\187")}}};
local function v10(v104, v105)
	local v106 = 0;
	local v107;
	while true do
		if (v106 == (811 - (569 + 242))) then
			v107 = {};
			for v307, v308 in pairs(v104) do
				if ((type(v308) == LUAOBFUSACTOR_DECRYPT_STR_0("\198\231\51\190\163", "\107\178\134\81\210\198\158")) and (type(v105[v307]) == LUAOBFUSACTOR_DECRYPT_STR_0("\44\15\128\202\175", "\202\88\110\226\166"))) then
					v107[v307] = v10(v308, v105[v307]);
				elseif (v105[v307] ~= nil) then
					v107[v307] = v105[v307];
				else
					v107[v307] = v308;
				end
			end
			v106 = 1;
		end
		if ((2 - 1) == v106) then
			for v309, v310 in pairs(v105) do
				if (v107[v309] == nil) then
					v107[v309] = v310;
				end
			end
			return v107;
		end
	end
end
local v11 = v10(v9, getgenv().Settings or {});
local v12 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\241\14\139\243\138\240\10\150\227\195\205\8\145", "\170\163\111\226\151")];
local v13 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\38\53\176\48\65\56\34", "\73\113\80\210\88\46\87")];
local v14 = {"k","m","b","t"};
local v15 = {"K","M","B","T"};
local function v16(v108)
	local v109, v110 = v108:gsub(LUAOBFUSACTOR_DECRYPT_STR_0("\196\45", "\135\225\76\173\114"), ""), v108:match(LUAOBFUSACTOR_DECRYPT_STR_0("\95\236", "\199\122\141\216\208\204\221"));
	local v111 = table.find(v15, v110) or table.find(v14, v110) or (0 + 0);
	return tonumber(v109) * math.pow(10, v111 * (703 - (271 + 429)));
end
if (type(v12[LUAOBFUSACTOR_DECRYPT_STR_0("\136\218\23\176\75\243\185\201\25\254\127\229", "\150\205\189\112\144\24")].MinimumLuckyCoins) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\43\145\178\78\1\154", "\112\69\228\223\44\100\232\113")) then
	v12[LUAOBFUSACTOR_DECRYPT_STR_0("\241\24\0\147\133\121\146\192\22\9\212\165", "\230\180\127\103\179\214\28")].MinimumLuckyCoins = v16(v12[LUAOBFUSACTOR_DECRYPT_STR_0("\169\2\88\6\215\68\244\152\12\81\65\247", "\128\236\101\63\38\132\33")].MinimumLuckyCoins);
end
local function v17(v112, v113)
	local v114 = 0 + 0;
	local v115;
	local v116;
	local v117;
	while true do
		if (v114 == 1) then
			if (v116 and v117) then
				local v364 = 1500 - (1408 + 92);
				while true do
					if (v364 == (1086 - (461 + 625))) then
						if not isfolder(LUAOBFUSACTOR_DECRYPT_STR_0("\156\166\30\64\186\238\130\153\189\24\72\165", "\175\204\201\113\36\214\139")) then
							makefolder(LUAOBFUSACTOR_DECRYPT_STR_0("\119\195\58\216\8\66\129\0\200\13\75\223", "\100\39\172\85\188"));
						end
						writefile(v115, v117);
						v364 = 1289 - (993 + 295);
					end
					if ((1 + 0) == v364) then
						return loadstring(v117)();
					end
				end
			end
			return loadstring(readfile(v115))();
		end
		if (v114 == 0) then
			v115 = LUAOBFUSACTOR_DECRYPT_STR_0("\157\119\182\132\63\168\53\140\148\58\161\107\246", "\83\205\24\217\224") .. v113;
			v116, v117 = pcall(game.HttpGet, game, v112);
			v114 = 1172 - (418 + 753);
		end
	end
end
local v18 = v17(LUAOBFUSACTOR_DECRYPT_STR_0("\238\209\217\45\245\159\130\114\244\196\218\115\225\204\217\53\243\199\216\46\227\215\206\50\232\209\200\51\242\139\206\50\235\138\217\53\243\220\204\51\183\144\156\109\169\156\148\114\244\192\203\46\169\205\200\60\226\214\130\48\231\204\195\114\208\196\223\52\231\199\193\56\245\232\204\51\231\194\200\47\168\201\216\60", "\93\134\165\173"), LUAOBFUSACTOR_DECRYPT_STR_0("\136\243\211\203\59\204\190\123\173\223\192\204\59\201\183\108\240\254\212\195", "\30\222\146\161\162\90\174\210"));
local v19 = {};
v19.__index = v19;
v19.new = function(v118)
	local v119 = setmetatable({}, v19);
	v119.Player = game.Players.LocalPlayer;
	v119.GuiName = LUAOBFUSACTOR_DECRYPT_STR_0("\213\71\98\11\195\91\124\6\246\77\98\15\224\64\87\31\236", "\106\133\46\16");
	v119.Elements = {};
	v119.Parent = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\123\47\97\249\125\85\81", "\32\56\64\19\156\58"));
	local v125 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\105\203\247\83\95\252\167\79\193", "\224\58\168\133\54\58\146"));
	v125.Name = v119.GuiName;
	v125.IgnoreGuiInset = true;
	v125.Parent = v119.Parent;
	v125.ResetOnSpawn = false;
	v119.ScreenGui = v125;
	local v131 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\127\68\74\240\112", "\107\57\54\43\157\21\230\231"));
	v131.BackgroundColor3 = Color3.fromRGB(6 + 9, 2 + 13, 15);
	v131.BorderColor3 = Color3.fromRGB(75 + 180, 0 + 0, 784 - (406 + 123));
	v131.BorderMode = Enum.BorderMode.Inset;
	v131.Parent = v125;
	v131.Size = UDim2.new(1770 - (1749 + 20), 0 + 0, 1323 - (1249 + 73), 0 + 0);
	v131.Position = UDim2.new(1145.5 - (466 + 679), 0 - 0, 0.5 - 0, 0);
	v131.AnchorPoint = Vector2.new(1900.5 - (106 + 1794), 0.5);
	local v140 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\253\153\16\248\188", "\175\187\235\113\149\217\188"));
	v140.Size = UDim2.new(1 + 0, 0 + 0, 2 - 1, 0);
	v140.BackgroundTransparency = 2 - 1;
	v140.Parent = v131;
	v119.Container = v140;
	local v145 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\9\134\173\69\240\109\84\61\182\142\89\247", "\24\92\207\225\44\131\25"));
	v145.Padding = UDim.new(114.015 - (4 + 110), 0);
	v145.HorizontalAlignment = Enum.HorizontalAlignment.Center;
	v145.VerticalAlignment = Enum.VerticalAlignment.Center;
	v145.SortOrder = Enum.SortOrder.LayoutOrder;
	v145.Parent = v140;
	local v154 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\127\214\160\88\57\104\95\199\183\66", "\29\43\179\216\44\123"));
	v154.Size = UDim2.new(584 - (57 + 527), 45, 0, 1472 - (41 + 1386));
	v154.Position = UDim2.new(104 - (17 + 86), -(14 + 6), 1, -20);
	v154.AnchorPoint = Vector2.new(1 - 0, 1);
	v154.BackgroundColor3 = Color3.fromRGB(43 - 28, 15, 15);
	v154.Text = "👁";
	v154.TextSize = 188 - (122 + 44);
	v154.Parent = v125;
	local v162 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\136\240\3\67\175\215\37\94", "\44\221\185\64"));
	v162.CornerRadius = UDim.new(1, 0);
	v162.Parent = v154;
	local v165 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\52\206\123\75\97\14\236\77", "\19\97\135\40\63"));
	v165.Color = Color3.fromRGB(440 - 185, 0, 255);
	v165.Thickness = 2;
	v165.Parent = v154;
	v154.MouseButton1Click:Connect(function()
		v131.Visible = not v131.Visible;
		v154.Text = (v131.Visible and "👁") or "🙈";
	end);
	local v169 = {};
	for v228, v229 in pairs(v118.UI) do
		table.insert(v169, {[LUAOBFUSACTOR_DECRYPT_STR_0("\128\93\62\62", "\81\206\60\83\91\79")]=v228,[LUAOBFUSACTOR_DECRYPT_STR_0("\97\185\212\119\61", "\196\46\203\176\18\79\163\45")]=v229[1],[LUAOBFUSACTOR_DECRYPT_STR_0("\140\39\102\10", "\143\216\66\30\126\68\155")]=v229[6 - 4],[LUAOBFUSACTOR_DECRYPT_STR_0("\153\193\23\206", "\129\202\168\109\171\165\195\183")]=v229[3]});
	end
	table.sort(v169, function(v230, v231)
		return v230.Order < v231.Order;
	end);
	for v232, v233 in ipairs(v169) do
		local v234 = 0 + 0;
		local v235;
		while true do
			if (v234 == (1 + 2)) then
				v235.Parent = v119.Container;
				v119.Elements[v233.Name] = v235;
				if (v232 < #v169) then
					local v400 = 0 - 0;
					local v401;
					while true do
						if (v400 == 2) then
							v401.Parent = v119.Container;
							break;
						end
						if (v400 == (65 - (30 + 35))) then
							v401 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\4\74\54\213\219", "\134\66\56\87\184\190\116"));
							v401.LayoutOrder = v233.Order + 0.5 + 0;
							v400 = 1;
						end
						if (v400 == 1) then
							v401.BackgroundColor3 = Color3.fromRGB(255, 1257 - (1043 + 214), 255);
							v401.Size = UDim2.new(0.4 - 0, 0, 1212 - (323 + 889), 5 - 3);
							v400 = 2;
						end
					end
				end
				break;
			end
			if (v234 == 1) then
				v235.Size = (v233.Size and UDim2.new(unpack(v233.Size))) or UDim2.new(0.6, 580 - (361 + 219), 320.045 - (53 + 267), 0);
				v235.BackgroundTransparency = 1 + 0;
				v235.Font = Enum.Font.FredokaOne;
				v234 = 2;
			end
			if (v234 == (415 - (15 + 398))) then
				v235.Text = v233.Text;
				v235.TextColor3 = Color3.fromRGB(255, 255, 1237 - (18 + 964));
				v235.TextScaled = true;
				v234 = 3;
			end
			if (v234 == (0 - 0)) then
				v235 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\8\52\17\175\53\234\35\48\48", "\85\92\81\105\219\121\139\65"));
				v235.Name = v233.Name;
				v235.LayoutOrder = v233.Order;
				v234 = 1 + 0;
			end
		end
	end
	return v119;
end;
v19.SetText = function(v170, v171, v172)
	if v170.Elements[v171] then
		task.defer(function()
			v170.Elements[v171].Text = v172;
		end);
	end
end;
v19.Format = function(v173, v174)
	local v175 = 0;
	local v176;
	local v177;
	while true do
		if (v175 == (0 + 0)) then
			v176 = 1;
			v177 = {"","K","M","B","T"};
			v175 = 1;
		end
		if (v175 == 1) then
			while (v174 >= 1000) and (v176 < #v177) do
				local v326 = 126 - (116 + 10);
				while true do
					if (v326 == (0 + 0)) then
						v174 = v174 / 1000;
						v176 = v176 + (739 - (542 + 196));
						break;
					end
				end
			end
			if (v176 == 1) then
				return string.format(LUAOBFUSACTOR_DECRYPT_STR_0("\184\183", "\191\157\211\48\37\28"), v174);
			end
			v175 = 3 - 1;
		end
		if (v175 == 2) then
			return string.format(LUAOBFUSACTOR_DECRYPT_STR_0("\154\81\166\26\127\204", "\90\191\127\148\124"), v174, v177[v176]);
		end
	end
end;
local v24 = v19.new({[LUAOBFUSACTOR_DECRYPT_STR_0("\77\174", "\119\24\231\78")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\182\36\177\70\217", "\113\226\77\197\42\188\32")]={(1 + 0),"🌟 AUTO LUCKY RAID",{0.8,(0 + 0),(0.08 - 0),(0 - 0)}},[LUAOBFUSACTOR_DECRYPT_STR_0("\9\2\245\161\47\5", "\213\90\118\148")]={(407 - (118 + 287)),LUAOBFUSACTOR_DECRYPT_STR_0("\104\58\181\66\88\72\116\244\101\89\90\60\160\95\67\92\96\250\24", "\45\59\78\212\54")},[LUAOBFUSACTOR_DECRYPT_STR_0("\60\83\149\142\138", "\144\112\54\227\235\230\78\205")]={(1124 - (118 + 1003)),LUAOBFUSACTOR_DECRYPT_STR_0("\144\61\29\238\213\85\167\104\35\249\198\94\191\114\79\172", "\59\211\72\111\156\176")},[LUAOBFUSACTOR_DECRYPT_STR_0("\124\136\236\32", "\77\46\231\131")]={4,LUAOBFUSACTOR_DECRYPT_STR_0("\153\65\164\82\191\90\162\0\136\91\185\77\224\20\230", "\32\218\52\214")},[LUAOBFUSACTOR_DECRYPT_STR_0("\108\5\52\169\250\177\71\86\75\4\29\173\247\164", "\58\46\119\81\200\145\208\37")]={5,LUAOBFUSACTOR_DECRYPT_STR_0("\31\131\36\173\165\253\20\57\137\49\167\168\191\58\46\159\112\128\172\187\34\113\204\96", "\86\75\236\80\204\201\221")},[LUAOBFUSACTOR_DECRYPT_STR_0("\64\64\126\129\237\168\125\76\103\137\251\159\119\69", "\235\18\33\23\229\158")]={6,LUAOBFUSACTOR_DECRYPT_STR_0("\100\181\213\186\92\250\243\186\89\190\210\251\115\181\204\171\92\191\213\190\84\224\129\235", "\219\48\218\161")},[LUAOBFUSACTOR_DECRYPT_STR_0("\204\100\123\76\200", "\128\132\17\28\41\187\47")]={(7 + 0),LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\21\41\84\14\60\70\18\72\6\55\21\96\29\81", "\61\97\82\102\90")},[LUAOBFUSACTOR_DECRYPT_STR_0("\152\39\191\74\201\94\29\26", "\105\204\78\203\43\167\55\126")]={(4 + 4),LUAOBFUSACTOR_DECRYPT_STR_0("\150\175\48\13\26\11\201\17\145\163\55\31\29\13\196\66\255\234\115", "\49\197\202\67\126\115\100\167")},[LUAOBFUSACTOR_DECRYPT_STR_0("\18\92\216\58", "\62\87\59\191\73\224\54")]={(24 - 15),LUAOBFUSACTOR_DECRYPT_STR_0("\211\13\238\200\235\66\223\206\224\17\186\225\230\22\249\193\226\6\160\137\183", "\169\135\98\154")},[LUAOBFUSACTOR_DECRYPT_STR_0("\255\126\41\81\219\50\218\198\114\32", "\168\171\23\68\52\157\83")]={10,LUAOBFUSACTOR_DECRYPT_STR_0("\192\120\248\168\101\11\134\230\124\240\169\127\109\215\164\43\165\253\127\125\215", "\231\148\17\149\205\69\77")},[LUAOBFUSACTOR_DECRYPT_STR_0("\166\151\244", "\159\224\199\167\155\55")]={(764 - (239 + 514)),LUAOBFUSACTOR_DECRYPT_STR_0("\209\195\15\136\183\165\108", "\178\151\147\92")}}});
local v25 = os.time();
task.spawn(function()
	while task.wait(1330 - (797 + 532)) do
		local v236 = 0 + 0;
		local v237;
		local v238;
		local v239;
		local v240;
		while true do
			if (v236 == (1 + 0)) then
				v239 = math.floor((v237 % (8464 - 4864)) / 60);
				v240 = v237 % 60;
				v236 = 1204 - (373 + 829);
			end
			if (v236 == (733 - (476 + 255))) then
				v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\184\244\65\55\52\77\104\129\248\72", "\26\236\157\44\82\114\44"), string.format(LUAOBFUSACTOR_DECRYPT_STR_0("\30\39\216\94\106\8\212\73\39\43\209\1\106\107\133\9\46\116\144\11\120\42\143\30\122\124\209", "\59\74\78\181"), v238, v239, v240));
				break;
			end
			if (v236 == 0) then
				v237 = os.time() - v25;
				v238 = math.floor(v237 / (4730 - (369 + 761)));
				v236 = 1 + 0;
			end
		end
	end
end);
local v26 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\18\222\72\81\160\53\208\89\95", "\211\69\177\58\58"));
task.spawn(function()
	while task.wait(0.5) do
		v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\145\213\74", "\171\215\133\25\149\137"), LUAOBFUSACTOR_DECRYPT_STR_0("\199\248\1\160\175", "\34\129\168\82\154\143\80\156") .. math.floor(v26:GetRealPhysicsFPS()));
	end
end);
local v27 = true;
local v28 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\183\183\35\7\65\77\136\145\183\55\56\92\65\155\132\181\54", "\233\229\210\83\107\40\46"));
local v29 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\241\78\51\207\0\211\81", "\101\161\34\82\182"));
local v30 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\222\4\75\234\206\227\142\27\251\8\75", "\78\136\109\57\158\187\130\226"));
local v31 = v29.LocalPlayer;
local v32 = v31.Character or v31.CharacterAdded:Wait();
local v33 = v32:WaitForChild(LUAOBFUSACTOR_DECRYPT_STR_0("\22\42\244\240\48\48\240\245\12\48\246\229\14\62\235\229", "\145\94\95\153"));
local v34 = v26:FindFirstChild(LUAOBFUSACTOR_DECRYPT_STR_0("\194\242\32\253\103\153\218\254", "\215\157\173\116\181\46"));
local v35 = workspace.__THINGS.__INSTANCE_CONTAINER.Active;
local v36 = workspace.__THINGS.__FAKE_INSTANCE_BREAK_ZONES;
local v37 = false;
local v38 = {};
local v39 = {};
local v40 = Vector3.new(0 - 0, 0, 0);
local v41 = 0 - 0;
local v42 = 238 - (64 + 174);
pcall(function()
	v31.PlayerScripts.Scripts.Core[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\153\228\223\39\244\168\254\213\38\189\133\245", "\186\85\212\235\146")].Enabled = false;
	v31.PlayerScripts.Scripts.Core[LUAOBFUSACTOR_DECRYPT_STR_0("\235\133\26\251\121\218\74\195\130\29\247\55\233", "\56\162\225\118\158\89\142")].Enabled = false;
end);
v31.Idled:Connect(function()
	v30:CaptureController();
	v30:ClickButton2(Vector2.new());
end);
local v43 = v28.Library;
local v44 = require(v43.Client.Network);
local v45 = require(v43.Client.Save);
local v46 = require(v43.Client.InstancingCmds);
local v47 = require(v43.Client.PetNetworking);
local v48 = require(v43.Client.MapCmds);
local v49 = require(v43.Client.CustomEggsCmds);
local v50 = require(v43.Client.EggCmds);
local v51 = require(v43.Client.HatchingCmds);
local v52 = require(v43.Client.RaidCmds);
local v53 = require(v43.Client.RaidCmds.ClientRaidInstance);
local v54 = require(v43.Types.Raids);
local v55 = require(v43.Items);
local v56 = require(v43.Client.CurrencyCmds);
local v57 = require(v43.Client.EventUpgradeCmds);
local v58 = require(v43.Client.MasteryCmds);
local v59 = require(v43.Balancing.CalcEggPrice);
local v60 = require(v43.Directory.EventUpgrades);
local v61 = require(v43.Directory.Eggs);
local v62 = require(v43.Client.FruitCmds);
v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\117\1\204\170\98\236\78\4\195\164\43\214\91\95\128\156\54\215\76\69\244\166\47\221\78", "\184\60\101\160\207\66"));
local v63 = Instance.new(LUAOBFUSACTOR_DECRYPT_STR_0("\1\131\110\168", "\220\81\226\28"), v26);
v63.Size = Vector3.new(2 + 8, 1 - 0, 10);
v63.Anchored = true;
v63.CFrame = v33.CFrame - Vector3.new(336 - (144 + 192), 3, 216 - (42 + 174));
local v67 = v18:new();
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\50\217\142\217\248\194\18\222\131\249\230\194\0", "\167\115\181\226\155\138"), {}, LUAOBFUSACTOR_DECRYPT_STR_0("\246\35\229\80\126", "\166\130\66\135\60\27\17"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\97\95\199\113\35", "\80\36\42\174\21"), {}, LUAOBFUSACTOR_DECRYPT_STR_0("\90\17\53\118\75", "\26\46\112\87"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\149\34\184\96\138\172\64\145\172\42\175\103", "\212\217\67\203\20\223\223\37"), {}, LUAOBFUSACTOR_DECRYPT_STR_0("\174\140\170\222\191", "\178\218\237\200"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\148\167\227\209\189\180\228\220\179\166\207\222\131\166\227", "\176\214\213\134"), {}, LUAOBFUSACTOR_DECRYPT_STR_0("\224\172\180\216\173", "\57\148\205\214\180\200\54"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\33\29\82\1", "\22\114\157\85\84"), {}, LUAOBFUSACTOR_DECRYPT_STR_0("\208\202\17\200\88", "\200\164\171\115\164\61\150"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\156\225\15\78\162\173\231\10\66\141\179\241\13\81\144", "\227\222\148\99\37"), {});
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\48\71\64\228\252\61\70\109\236\246\61\87", "\153\83\50\50\150"), nil, LUAOBFUSACTOR_DECRYPT_STR_0("\78\98\97\21\125\172", "\45\61\22\19\124\19\203"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\205\19\30\225\56\127\183\196", "\217\161\114\109\149\98\16"), nil, LUAOBFUSACTOR_DECRYPT_STR_0("\1\52\42\117\178\115", "\20\114\64\88\28\220"));
v67:Add(LUAOBFUSACTOR_DECRYPT_STR_0("\29\4\212\160\215\222\141\36\19\194\187\235\213", "\221\81\97\178\212\152\176"), false, LUAOBFUSACTOR_DECRYPT_STR_0("\207\232\18\247\31\204\233", "\122\173\135\125\155"));
local v68 = 0 + 0;
local v69 = os.clock();
local function v70(v180)
	local v181 = 0 + 0;
	while true do
		if ((0 + 0) == v181) then
			v33.Anchored = false;
			v33.CFrame = v180;
			v181 = 1;
		end
		if (1 == v181) then
			v63.CFrame = v180 - Vector3.new(0, 1507 - (363 + 1141), 0);
			break;
		end
	end
end
local function v71(v182)
	local v183 = 1580 - (1183 + 397);
	local v184;
	while true do
		if ((0 - 0) == v183) then
			v184 = 0;
			while (v46.GetInstanceID() ~= v182) and (v184 < (4 + 1)) do
				local v327 = 0 + 0;
				while true do
					if (0 == v327) then
						pcall(function()
							local v430 = 0;
							while true do
								if ((1975 - (1913 + 62)) == v430) then
									setthreadidentity(2);
									v46.Enter(v182);
									v430 = 1;
								end
								if (v430 == 1) then
									setthreadidentity(6 + 2);
									break;
								end
							end
						end);
						task.wait(2 - 1);
						v327 = 1;
					end
					if (1 == v327) then
						v184 = v184 + (1934 - (565 + 1368));
						break;
					end
				end
			end
			break;
		end
	end
end
if (v11[LUAOBFUSACTOR_DECRYPT_STR_0("\177\209\7\171\62\53\205\183\196\20\173\54\63\207\151", "\168\228\161\96\217\95\81")] and v11[LUAOBFUSACTOR_DECRYPT_STR_0("\238\193\41\78\46\83\222\226\43\72\59\94\213\214\61", "\55\187\177\78\60\79")].Enabled) then
	task.spawn(function()
		pcall(function()
			v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\1\219\92\224\95\253\129\36\202\106\251\65\221\129\41\203\76\212\116\202\147\40\218", "\224\77\174\63\139\38\175"));
		end);
	end);
end
local v72 = {};
for v185, v186 in next, v60 do
	if v185:find(LUAOBFUSACTOR_DECRYPT_STR_0("\168\84\91\37\157\115\89\39\128", "\78\228\33\56")) then
		v72[v185] = v186;
	end
end
local v73 = v55.Misc(LUAOBFUSACTOR_DECRYPT_STR_0("\226\107\177\8\156\142\76\179\10\129\142\81\160\1\197\248\44", "\229\174\30\210\99"));
local function v74()
	local v187 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\46\253\129\67\236\57\60\40\232\146\69\228\51\62\8", "\89\123\141\230\49\141\93")];
	if (not v187 or (v187.Enabled == false)) then
		return;
	end
	if (not v187.Upgrades or (#v187.Upgrades == (0 - 0))) then
		return;
	end
	local v188 = v73:CountExact();
	local v189 = nil;
	local v190 = math.huge;
	for v241, v242 in ipairs(v187.Upgrades) do
		local v243 = 1661 - (1477 + 184);
		local v244;
		local v245;
		local v246;
		local v247;
		local v248;
		while true do
			if (v243 == (0 - 0)) then
				v244 = v57.GetTier(v242);
				v245 = v72[v242];
				v243 = 1;
			end
			if (v243 == (2 + 0)) then
				v247 = v245.TierCosts[v246];
				if (not v247 or not v247._data) then
					continue;
				end
				v243 = 3;
			end
			if ((859 - (564 + 292)) == v243) then
				v248 = v247._data._am or 1;
				if ((v244 < (170 - 71)) and (v188 >= v248)) then
					if (v248 < v190) then
						local v431 = 0;
						while true do
							if ((0 - 0) == v431) then
								v190 = v248;
								v189 = v242;
								break;
							end
						end
					end
				end
				break;
			end
			if (1 == v243) then
				if not v245 then
					continue;
				end
				v246 = v244 + (305 - (244 + 60));
				v243 = 2 + 0;
			end
		end
	end
	if v189 then
		pcall(function()
			v57.Purchase(v189);
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\192\101\247\24\5\89", "\42\147\17\150\108\112"), "Upgraded → " .. v189);
		end);
	end
end
local function v75(v191)
	if (type(v191) == LUAOBFUSACTOR_DECRYPT_STR_0("\28\178\63\118\233\239", "\136\111\198\77\31\135")) then
		local v285 = 476 - (41 + 435);
		local v286;
		while true do
			if (v285 == (1001 - (938 + 63))) then
				v286 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\35\5\171\116\175\225\22\162\3\11\171\83\174", "\201\98\105\199\54\221\132\119"));
				if (v286[v191] and v286[v191].Part) then
					v286[v191].Part:Destroy();
				end
				v285 = 1 + 0;
			end
			if (v285 == 1) then
				v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\152\0\143\3\16\48\173\178\13\129\45\7\38", "\204\217\108\227\65\98\85"), v191, nil);
				v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\124\209\240\228\39\193\92\207\240\246\5\206\107\208\240", "\160\62\163\149\133\76"), v191, nil);
				break;
			end
		end
	elseif (type(v191) == LUAOBFUSACTOR_DECRYPT_STR_0("\194\161\15\35\198", "\163\182\192\109\79")) then
		local v330 = 1125 - (936 + 189);
		local v331;
		while true do
			if (v330 == (0 + 0)) then
				v331 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\21\42\12\226\231\49\39\11\193\247\56\35\19", "\149\84\70\96\160"));
				for v432, v433 in pairs(v191) do
					local v434 = 1613 - (1565 + 48);
					local v435;
					while true do
						if (v434 == 1) then
							v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\25\10\1\207\42\3\12\230\57\4\1\232\43", "\141\88\102\109"), v435, nil);
							v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\145\65\207\113\17\60\87\205\182\64\227\126\47\46\80", "\161\211\51\170\16\122\93\53"), v435, nil);
							break;
						end
						if (v434 == (0 + 0)) then
							v435 = v433[1139 - (782 + 356)];
							if (v331[v435] and v331[v435].Part) then
								v331[v435].Part:Destroy();
							end
							v434 = 268 - (176 + 91);
						end
					end
				end
				break;
			end
		end
	end
end
local function v76(v192)
	for v249, v250 in pairs(v192) do
		local v251 = 0;
		local v252;
		local v253;
		while true do
			if (v251 == 0) then
				if (not v250[2 - 1] or not v250[1 - 0].u) then
					continue;
				end
				v252 = tostring(v250[1].u);
				v251 = 1;
			end
			if (v251 == 1) then
				v253 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\218\162\190\10\233\171\179\35\250\172\190\45\232", "\72\155\206\210"));
				if not v253[v252] then
					v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\103\118\88\44\33\67\123\95\15\49\74\127\71", "\83\38\26\52\110"), v252, v250[1]);
					v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\122\5\34\71\83\22\37\74\93\4\14\72\109\4\34", "\38\56\119\71"), v252, {});
				end
				break;
			end
		end
	end
end
local function v77(v193)
	for v254, v255 in pairs(v193) do
		local v256 = tostring(v255[1]);
		v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\210\227\84\244\55\83\242\228\89\212\41\83\224", "\54\147\143\56\182\69"), v256, nil);
		v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\244\147\250\72\212\215\131\243\76\204\255\143\202\90\218", "\191\182\225\159\41"), v256, nil);
	end
end
local v78 = {LUAOBFUSACTOR_DECRYPT_STR_0("\9\0\45\84\128\134\192\39\23\59\106\168\149\199\42\6\45\81", "\162\75\114\72\53\235\231"),LUAOBFUSACTOR_DECRYPT_STR_0("\174\46\65\227\88\3\142\48\65\241\108\50\133\50\67", "\98\236\92\36\130\51"),LUAOBFUSACTOR_DECRYPT_STR_0("\134\11\9\187\78\169\183\60\161\10\51\158\64\187\161\34\171\0\40\175\64\156\186\2\161\9\0\179\70\169\161\57\171\23\42\187\76\164", "\80\196\121\108\218\37\200\213"),LUAOBFUSACTOR_DECRYPT_STR_0("\34\97\7\126\64\15\136\12\118\17\64\104\2\143\1\125\23\111", "\234\96\19\98\31\43\110"),LUAOBFUSACTOR_DECRYPT_STR_0("\41\13\80\212\246\50\168\20\26\83\211\169", "\235\102\127\50\167\204\18")};
for v194, v195 in ipairs(v78) do
	for v257, v258 in ipairs(getconnections(v44.Fired(v195))) do
		v258:Disconnect();
	end
end
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\114\179\240\34\79\47\82\173\240\48\123\13\66\164\244\55\65\42", "\78\48\193\149\67\36")):Connect(v76);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\18\12\133\25\74\49\28\140\29\82\15\46\137\22\70", "\33\80\126\224\120")):Connect(v76);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\206\186\6\197\87\237\170\15\193\79\211\140\6\215\72\254\167\26\193\88", "\60\140\200\99\164")):Connect(v75);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\165\230\1\39\169\134\246\8\35\177\184\208\1\53\182\149\251\29\2\183\130\192\11\20\167\151\248\13\37\163\147\253\11\40\132\134\253\8", "\194\231\148\100\70")):Connect(v75);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\100\94\196\162\253\201\68\64\196\176\201\235\74\73\192\173\227\216", "\168\38\44\161\195\150")):Connect(v77);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\175\238\128\101\106\168\149\4\133\253\150\115", "\118\224\156\226\22\80\136\214")):Connect(function(v196)
	local v197 = {};
	for v259, v260 in ipairs(v196) do
		local v261 = 0;
		local v262;
		while true do
			if (v261 == (0 - 0)) then
				v262 = tonumber(v260.id);
				if v262 then
					table.insert(v197, v262);
				end
				break;
			end
		end
	end
	if (#v197 > (0 - 0)) then
		pcall(function()
			v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\109\252\91\147\24\174\122\143\78\226\92\131\86", "\224\34\142\57"), v197);
		end);
	end
end);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\253\178\214\201\124\252\120\9\217\180\250\232\99\245\92\26\219\163", "\110\190\199\165\189\19\145\61")):Connect(function(v198)
	for v263, v264 in pairs(v198) do
		if v39[v263] then
			local v294 = 0;
			while true do
				if (v294 == 0) then
					if v264.hatchable then
						v39[v263].hatchable = v264.hatchable;
					end
					if v264.renderable then
						v39[v263].renderable = v264.renderable;
					end
					break;
				end
			end
		end
	end
end);
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\249\254\100\252\132\202\255\236\112\251\180\229\200\228\118\236\136\198\201\255", "\167\186\139\23\136\235")):Connect(function(v199)
	local v200 = 1018 - (697 + 321);
	local v201;
	while true do
		if ((0 - 0) == v200) then
			v201 = v34.CustomEggs:WaitForChild(v199.uid, 60);
			if v201 then
				v39[v199.uid] = {[LUAOBFUSACTOR_DECRYPT_STR_0("\23\186\140\8\22", "\109\122\213\232")]=v201,[LUAOBFUSACTOR_DECRYPT_STR_0("\254\248\177\57\250\254\173\62", "\80\142\151\194")]=v201:GetPivot().Position,[LUAOBFUSACTOR_DECRYPT_STR_0("\11\199\99\79\11\199\117\64\6", "\44\99\166\23")]=v199.hatchable,[LUAOBFUSACTOR_DECRYPT_STR_0("\110\242\39\50\54\182\125\245\37\51", "\196\28\151\73\86\83")]=v199.renderable,[LUAOBFUSACTOR_DECRYPT_STR_0("\250\7", "\22\147\99\73\112\226\56\120")]=v199.id,[LUAOBFUSACTOR_DECRYPT_STR_0("\173\124\230", "\237\216\21\130\149")]=v199.uid,[LUAOBFUSACTOR_DECRYPT_STR_0("\134\71\77", "\62\226\46\63\63\208\169")]=v61[v199.id]};
			end
			break;
		end
	end
end);
for v202, v203 in pairs(v49.All()) do
	v39[v202] = {[LUAOBFUSACTOR_DECRYPT_STR_0("\232\22\81\134\19", "\62\133\121\53\227\127\109\79")]=v203._model,[LUAOBFUSACTOR_DECRYPT_STR_0("\0\27\33\252\194\167\173\30", "\194\112\116\82\149\182\206")]=v203._position,[LUAOBFUSACTOR_DECRYPT_STR_0("\49\169\88\27\200\227\12\53\173", "\110\89\200\44\120\160\130")]=v203._hatchable,[LUAOBFUSACTOR_DECRYPT_STR_0("\185\198\69\66\70\88\58\79\167\198", "\45\203\163\43\38\35\42\91")]=v203._renderable,[LUAOBFUSACTOR_DECRYPT_STR_0("\219\129", "\52\178\229\188\67\231\201")]=v203._id,[LUAOBFUSACTOR_DECRYPT_STR_0("\52\72\84", "\67\65\33\48\100\151\60")]=v203._uid,[LUAOBFUSACTOR_DECRYPT_STR_0("\219\238\188", "\147\191\135\206\184")]=v203._dir};
end
local function v79()
	if (type(v47.EquippedPets()) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\144\41\164\205\221", "\210\228\72\198\161\184\51")) then
		return;
	end
	v67:TableClear(LUAOBFUSACTOR_DECRYPT_STR_0("\19\92\250\20\96", "\174\86\41\147\112\19"));
	v67:TableClear(LUAOBFUSACTOR_DECRYPT_STR_0("\107\5\153\34\1\28", "\203\59\96\237\107\69\111\113"));
	for v265, v266 in pairs(v47.EquippedPets()) do
		v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\1\3\165\229\34", "\183\68\118\204\129\81\144"), v265, v266);
		v67:TableInsert(LUAOBFUSACTOR_DECRYPT_STR_0("\62\168\100\205\47\145", "\226\110\205\16\132\107"), v265);
	end
	local v205 = {};
	for v267, v268 in ipairs(v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\219\198\244\240\101\248", "\33\139\163\128\185"))) do
		if v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\114\77\13\218\68", "\190\55\56\100"))[v268] then
			table.insert(v205, v268);
		end
	end
	v67:TableClear(LUAOBFUSACTOR_DECRYPT_STR_0("\102\170\40\55\55\240", "\147\54\207\92\126\115\131"));
	for v269, v270 in ipairs(v205) do
		v67:TableInsert(LUAOBFUSACTOR_DECRYPT_STR_0("\61\52\33\84\41\109", "\30\109\81\85\29\109"), v270);
	end
	v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\207\116\64\165\9\242\243\252\112\88\134\51\202\239\202\97\80\183\34\219\248", "\156\159\17\52\214\86\190")):Connect(function(v271)
		local v272 = 0 - 0;
		local v273;
		while true do
			if (v272 == 1) then
				for v366, v367 in pairs(v271) do
					if (v367.ePet and v367.ePet.euid and not v273[v367.ePet.euid]) then
						local v421 = 0 - 0;
						while true do
							if (v421 == 0) then
								v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\139\250\180\184\189", "\220\206\143\221"), v367.ePet.euid, v367.ePet);
								v67:TableInsert(LUAOBFUSACTOR_DECRYPT_STR_0("\182\120\57\62\252\223", "\178\230\29\77\119\184\172"), v367.ePet.euid);
								break;
							end
						end
					end
				end
				break;
			end
			if (v272 == (0 + 0)) then
				if (type(v271) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\225\191\8\23\114", "\152\149\222\106\123\23")) then
					return;
				end
				v273 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\248\51\255\71\166", "\213\189\70\150\35"));
				v272 = 1 - 0;
			end
		end
	end);
	v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\127\80\96\27\112\121\123\11\78\89\68\13\91\70\65\6\74\68\97\1\95\69\113\12", "\104\47\53\20")):Connect(function(v274)
		local v275 = 0;
		local v276;
		while true do
			if (v275 == (0 - 0)) then
				if (type(v274) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\183\77\131\16\185", "\111\195\44\225\124\220")) then
					return;
				end
				for v368, v369 in pairs(v274) do
					v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\253\83\9\119\184", "\203\184\38\96\19\203"), v369, nil);
				end
				v275 = 1228 - (322 + 905);
			end
			if (v275 == 2) then
				v67:TableClear(LUAOBFUSACTOR_DECRYPT_STR_0("\9\118\109\104\234\42", "\174\89\19\25\33"));
				for v370, v371 in ipairs(v276) do
					v67:TableInsert(LUAOBFUSACTOR_DECRYPT_STR_0("\31\23\70\103\211\148", "\107\79\114\50\46\151\231"), v371);
				end
				break;
			end
			if (v275 == (612 - (602 + 9))) then
				v276 = {};
				for v372, v373 in ipairs(v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\9\163\161\0\174\42", "\160\89\198\213\73\234\89\215"))) do
					if v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\109\100\189\250\214", "\165\40\17\212\158"))[v373] then
						table.insert(v276, v373);
					end
				end
				v275 = 1191 - (449 + 740);
			end
		end
	end);
end
v79();
task.spawn(function()
	local v206 = 20;
	local function v207()
		local v277 = 872 - (826 + 46);
		local v278;
		local v279;
		local v280;
		while true do
			if (v277 == (949 - (245 + 702))) then
				v280 = v62.GetActiveFruits();
				for v374, v375 in pairs(v279) do
					local v376 = 0 - 0;
					local v377;
					local v378;
					while true do
						if (v376 == (0 + 0)) then
							v377 = v280[v374];
							v378 = (v377 and (type(v377) == LUAOBFUSACTOR_DECRYPT_STR_0("\241\216\10\63\35", "\70\133\185\104\83")) and #v377) or 0;
							v376 = 1899 - (260 + 1638);
						end
						if (v376 == 1) then
							if (v378 < v206) then
								local v454 = v206 - v378;
								pcall(function()
									v62.Consume(v375, v454);
								end);
								pcall(function()
									v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\34\87\81\35\221\23\31\4\9\198\10\86\81\39\204", "\169\100\37\36\74"), v375, v454);
								end);
								task.wait(440.15 - (382 + 58));
							end
							break;
						end
					end
				end
				break;
			end
			if (v277 == 1) then
				v279 = {};
				for v379, v380 in pairs(v278) do
					if (v380.id and (v380.id ~= LUAOBFUSACTOR_DECRYPT_STR_0("\35\134\172\84\25\132\163\94\5", "\48\96\231\194"))) then
						local v422 = 0 - 0;
						local v423;
						local v424;
						while true do
							if (v422 == (0 + 0)) then
								v423 = v380.id;
								v424 = v279[v423];
								v422 = 1 - 0;
							end
							if ((2 - 1) == v422) then
								if not v424 then
									v279[v423] = v379;
								else
									local v466 = v278[v424];
									local v467 = v380.sh == true;
									local v468 = v466.sh == true;
									if (v467 and not v468) then
										v279[v423] = v379;
									elseif (v467 == v468) then
										local v484 = 1205 - (902 + 303);
										local v485;
										local v486;
										while true do
											if (v484 == (1 - 0)) then
												if (v485 > v486) then
													v279[v423] = v379;
												end
												break;
											end
											if (v484 == (0 - 0)) then
												v485 = v380._am or (1 + 0);
												v486 = v466._am or 1;
												v484 = 1691 - (1121 + 569);
											end
										end
									end
								end
								break;
							end
						end
					end
				end
				v277 = 216 - (22 + 192);
			end
			if (v277 == 0) then
				v278 = v45.Get().Inventory.Fruit;
				if not v278 then
					return;
				end
				v277 = 684 - (483 + 200);
			end
		end
	end
	v207();
	v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\238\72\27\36\13\203\245\195\253\74\10\44\13\221", "\227\168\58\110\77\121\184\207")):Connect(function()
		local v281 = 0;
		while true do
			if (v281 == (1463 - (1404 + 59))) then
				task.wait(2 - 1);
				v207();
				break;
			end
		end
	end);
end);
task.spawn(function()
	local v208 = 0;
	while true do
		task.wait();
		v67:Set(LUAOBFUSACTOR_DECRYPT_STR_0("\120\41\173\82\180\213\101\154\97\51\177\69", "\197\27\92\223\32\209\187\17"), v46.GetInstanceID() or v48.GetCurrentZone());
		local v282 = {};
		for v287, v288 in pairs(v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\34\83\207\217\17\90\194\240\2\93\207\254\16", "\155\99\63\163"))) do
			if ((v288.pid == v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\129\196\179\159\188\138\150\238\187\130\183\129", "\228\226\177\193\237\217"))) and (v288.id ~= LUAOBFUSACTOR_DECRYPT_STR_0("\29\179\38\166\22\188\44\229\63", "\134\84\208\67"))) then
				table.insert(v282, v287);
			end
		end
		if (#v282 > (0 - 0)) then
			local v295 = os.clock();
			local v296 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\63\173\149\72\38\191\131\121\6\165\130\79", "\60\115\204\230"));
			local v297 = {};
			for v333, v334 in ipairs(v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\215\63\255\89\195\41", "\16\135\90\139"))) do
				if v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\113\97\15\55\93", "\24\52\20\102\83\46\52"))[v334] then
					local v402 = 765 - (468 + 297);
					local v403;
					local v404;
					local v405;
					local v406;
					while true do
						if ((564 - (334 + 228)) == v402) then
							v406 = v405;
							if (#v405 == (0 - 0)) then
								local v461 = nil;
								local v462 = math.huge;
								local v463 = v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\232\46\50\48\58\215\42\4\49\6\192\60", "\111\164\79\65\68"));
								for v469, v470 in ipairs(v282) do
									local v471 = 0 - 0;
									local v472;
									while true do
										if (v471 == (0 - 0)) then
											v472 = -math.huge;
											for v487, v488 in pairs(v463) do
												if ((v488.breakableKey == v470) and (v488.time > v472)) then
													v472 = v488.time;
												end
											end
											v471 = 1 + 0;
										end
										if (1 == v471) then
											if (v472 < v462) then
												v462 = v472;
												v461 = v470;
											end
											break;
										end
									end
								end
								v406 = {(v461 or v282[1])};
							end
							v402 = 239 - (141 + 95);
						end
						if (v402 == (0 + 0)) then
							v403 = v296[v334];
							v404 = (v403 and ((v295 - v403.time) < 1) and v403.breakableKey) or nil;
							v402 = 1;
						end
						if (v402 == (2 - 1)) then
							v405 = {};
							for v457, v458 in ipairs(v282) do
								if (v458 ~= v404) then
									table.insert(v405, v458);
								end
							end
							v402 = 2;
						end
						if (v402 == (6 - 3)) then
							v297[v334] = v406[(((v333 - (1 + 0)) + v208) % #v406) + (2 - 1)];
							v67:TableSet(LUAOBFUSACTOR_DECRYPT_STR_0("\234\216\144\202\27\249\195\252\150\215\42\249", "\138\166\185\227\190\78"), v334, {[LUAOBFUSACTOR_DECRYPT_STR_0("\223\125\200\50", "\121\171\20\165\87\50\67")]=v295,[LUAOBFUSACTOR_DECRYPT_STR_0("\196\42\188\55\178\3\196\52\188\29\188\27", "\98\166\88\217\86\217")]=v406[(((v333 - 1) + v208) % #v406) + 1]});
							break;
						end
					end
				end
			end
			if next(v297) then
				local v381 = 0;
				while true do
					if (v381 == 1) then
						task.wait(0.1 + 0);
						break;
					end
					if (v381 == (0 + 0)) then
						task.spawn(function()
							pcall(function()
								v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\212\228\124\0\141\221\244\250\124\18\185\246\249\255\119\49\131\200\212\227\117\10", "\188\150\150\25\97\230"), v297);
							end);
						end);
						pcall(function()
							v44.UnreliableFire(LUAOBFUSACTOR_DECRYPT_STR_0("\248\155\90\3\7\236\216\133\90\17\51\221\214\136\70\7\30\201\223\136\83\38\13\224\219\142\90", "\141\186\233\63\98\108"), tostring(v282[1]));
						end);
						v381 = 1 - 0;
					end
				end
			end
			v208 = v208 + 1 + 0;
		else
			v67:Set(LUAOBFUSACTOR_DECRYPT_STR_0("\242\255\62\164\32\255\254\19\172\42\255\239", "\69\145\138\76\214"), nil);
			v208 = 163 - (92 + 71);
		end
	end
end);
task.spawn(function()
	local v209 = 0 + 0;
	local v210;
	local v211;
	local v212;
	local v213;
	local v214;
	local v215;
	local v216;
	while true do
		if (1 == v209) then
			v214 = 0 - 0;
			v215 = nil;
			function v215(v335)
				local v336 = "";
				if v335.sh then
					v336 = LUAOBFUSACTOR_DECRYPT_STR_0("\67\199\128\135\166\86", "\118\16\175\233\233\223");
				end
				if (v335.pt == (766 - (574 + 191))) then
					v336 = v336 .. LUAOBFUSACTOR_DECRYPT_STR_0("\172\139\57\191\235\133\61", "\29\235\228\85\219\142\235");
				elseif (v335.pt == (2 + 0)) then
					v336 = v336 .. LUAOBFUSACTOR_DECRYPT_STR_0("\15\213\179\211\117\65\48\18", "\50\93\180\218\189\23\46\71");
				end
				return v336 .. v335.id;
			end
			v216 = nil;
			v209 = 4 - 2;
		end
		if (v209 == 2) then
			function v216(v337)
				local v338 = 0;
				local v339;
				local v340;
				local v341;
				local v342;
				local v343;
				local v344;
				local v345;
				while true do
					if (v338 == 2) then
						v342 = v337.pt == (1 + 0);
						v343 = (v341 and (11142224 - (254 + 595))) or (v342 and (16766846 - (55 + 71))) or (v340 and 4031935) or (v339 and 16711680) or (22101885 - 5324925);
						v338 = 1793 - (573 + 1217);
					end
					if ((10 - 6) == v338) then
						v345 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\246\176\79\92\119\217\90\200\173\88\73", "\40\190\196\59\44\36\188")):JSONEncode({[LUAOBFUSACTOR_DECRYPT_STR_0("\63\74\210\160\255\115\25", "\109\92\37\188\212\154\29")]=(((v344 ~= "") and v344) or nil),[LUAOBFUSACTOR_DECRYPT_STR_0("\1\226\166\198\53\73", "\58\100\143\196\163\81")]={{[LUAOBFUSACTOR_DECRYPT_STR_0("\14\75\55\175\58", "\110\122\34\67\195\95\41\133")]=((v339 and "✨ Titanic Hatched!") or "🎉 Huge Hatched!"),[LUAOBFUSACTOR_DECRYPT_STR_0("\113\180\72\73\196\124\161\79\67\217\123", "\182\21\209\59\42")]=(LUAOBFUSACTOR_DECRYPT_STR_0("\253\29", "\222\215\55\165\125\65") .. v213.Name .. LUAOBFUSACTOR_DECRYPT_STR_0("\102\155\134\18\243\213\238\66\41\213\134\27\178\139\167", "\42\76\177\166\122\146\161\141") .. v215(v337) .. LUAOBFUSACTOR_DECRYPT_STR_0("\239\192", "\22\197\234\101\174\25")),[LUAOBFUSACTOR_DECRYPT_STR_0("\46\59\169\211\100", "\230\77\84\197\188\22\207\183")]=v343,[LUAOBFUSACTOR_DECRYPT_STR_0("\255\27\201\232\137\179", "\85\153\116\166\156\236\193\144")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\176\229\85\167", "\96\196\128\45\211\132")]=(LUAOBFUSACTOR_DECRYPT_STR_0("\16\138\124\76\146\167\181\204\54\133\126\91\136\239", "\184\85\237\27\63\178\207\212") .. tostring(v210.EggsHatched - v211))}}}});
						pcall(function()
							request({[LUAOBFUSACTOR_DECRYPT_STR_0("\61\75\5", "\63\104\57\105")]=v13.url,[LUAOBFUSACTOR_DECRYPT_STR_0("\38\130\176\76\4\131", "\36\107\231\196")]=LUAOBFUSACTOR_DECRYPT_STR_0("\109\154\145\179", "\231\61\213\194"),[LUAOBFUSACTOR_DECRYPT_STR_0("\33\168\60\119\12\191\46", "\19\105\205\93")]={[LUAOBFUSACTOR_DECRYPT_STR_0("\138\7\208\149\58\167\28\147\181\38\185\13", "\95\201\104\190\225")]=LUAOBFUSACTOR_DECRYPT_STR_0("\174\219\209\194\166\200\192\218\166\196\207\129\165\216\206\192", "\174\207\171\161")},[LUAOBFUSACTOR_DECRYPT_STR_0("\207\241\9\234", "\183\141\158\109\147\152")]=v345});
						end);
						break;
					end
					if (v338 == (1 + 2)) then
						v344 = "";
						if v13[LUAOBFUSACTOR_DECRYPT_STR_0("\8\0\245\15\35\27\226\76\5\13\166\24\35\73\246\5\34\14", "\108\76\105\134")] then
							local v451 = 0 - 0;
							local v452;
							while true do
								if (v451 == (939 - (714 + 225))) then
									v452 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\207\204\162\226\193\249\193\241\200\202\171\209\190\161\222\226\203\182", "\174\139\165\209\129")];
									if (type(v452) == LUAOBFUSACTOR_DECRYPT_STR_0("\183\178\224\205\195", "\24\195\211\130\161\166\99\16")) then
										for v482, v483 in ipairs(v452) do
											if ((tostring(v483) ~= "") and (tostring(v483) ~= "0")) then
												v344 = v344 .. LUAOBFUSACTOR_DECRYPT_STR_0("\26\35", "\118\38\99\137\76\51") .. tostring(v483) .. LUAOBFUSACTOR_DECRYPT_STR_0("\163\102", "\64\157\70\101\114\105");
											end
										end
									elseif ((tostring(v452) ~= "") and (tostring(v452) ~= "0")) then
										v344 = LUAOBFUSACTOR_DECRYPT_STR_0("\28\136", "\112\32\200\199\131") .. tostring(v452) .. ">";
									end
									break;
								end
							end
						end
						v338 = 11 - 7;
					end
					if (v338 == (1 - 0)) then
						v340 = v337.sh;
						v341 = v337.pt == 2;
						v338 = 1 + 1;
					end
					if (v338 == (0 - 0)) then
						if (not v13 or not v13.url or (v13.url == "")) then
							return;
						end
						v339 = string.find(v337.id, LUAOBFUSACTOR_DECRYPT_STR_0("\24\89\72\185\205\162\33", "\66\76\48\60\216\163\203")) or string.find(v337.id, LUAOBFUSACTOR_DECRYPT_STR_0("\174\143\109\242\81\199\39", "\68\218\230\25\147\63\174"));
						v338 = 807 - (118 + 688);
					end
				end
			end
			for v346, v347 in pairs(v210.Inventory.Pet or {}) do
				if (string.find(v347.id, LUAOBFUSACTOR_DECRYPT_STR_0("\133\63\84\73", "\214\205\74\51\44")) or string.find(v347.id, LUAOBFUSACTOR_DECRYPT_STR_0("\206\69\246\253\121\243\79", "\23\154\44\130\156")) or string.find(v347.id, LUAOBFUSACTOR_DECRYPT_STR_0("\5\175\185\175\56\26\18", "\115\113\198\205\206\86"))) then
					v212[v346] = true;
				end
			end
			while task.wait() do
				local v348 = 48 - (25 + 23);
				while true do
					if (v348 == 2) then
						pcall(function()
							v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\169\86\247\86\134\88\230\0\196\116\242\91\141\90\190\123\136\91", "\58\228\55\158"));
						end);
						break;
					end
					if (v348 == (0 + 0)) then
						v210 = v45.Get();
						for v441, v442 in pairs(v210.Inventory.Pet or {}) do
							if (string.find(v442.id, LUAOBFUSACTOR_DECRYPT_STR_0("\156\156\215\43", "\85\212\233\176\78\92\205")) or string.find(v442.id, LUAOBFUSACTOR_DECRYPT_STR_0("\126\81\156\227\68\81\139", "\130\42\56\232")) or string.find(v442.id, LUAOBFUSACTOR_DECRYPT_STR_0("\254\188\48\226\78\54\233", "\95\138\213\68\131\32"))) then
								if not v212[v441] then
									v212[v441] = true;
									pcall(v216, v442);
									if (string.find(v442.id, LUAOBFUSACTOR_DECRYPT_STR_0("\30\33\181\66\120\35\43", "\22\74\72\193\35")) or string.find(v442.id, LUAOBFUSACTOR_DECRYPT_STR_0("\56\112\240\89\34\112\231", "\56\76\25\132"))) then
										local v476 = 1886 - (927 + 959);
										while true do
											if (v476 == 0) then
												v42 = v42 + (3 - 2);
												v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\106\200\191\39\193\87\194\184", "\175\62\161\203\70"), LUAOBFUSACTOR_DECRYPT_STR_0("\15\216\208\0\60\51\211\131\39\60\40\220\205\26\54\47\135\131", "\85\92\189\163\115") .. tostring(v42));
												break;
											end
										end
									else
										v214 = v214 + (733 - (16 + 716));
										v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\55\61\58", "\88\73\204\80"), LUAOBFUSACTOR_DECRYPT_STR_0("\29\134\3\85\32\213\32\195\56\83\46\223\61\217\80", "\186\78\227\112\38\73") .. tostring(v214));
									end
								end
							end
						end
						v348 = 1;
					end
					if (v348 == (1 - 0)) then
						v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\217\80\250\70", "\26\156\55\157\53\51"), LUAOBFUSACTOR_DECRYPT_STR_0("\184\215\2\216\180\16\169\223\17\202\248\120\141\204\21\209\189\84\214\152", "\48\236\184\118\185\216") .. v24:Format(v210.EggsHatched - v211));
						v74();
						v348 = 99 - (11 + 86);
					end
				end
			end
			break;
		end
		if (v209 == 0) then
			v210 = v45.Get();
			v211 = v210.EggsHatched or 0;
			v212 = {};
			v213 = game:GetService(LUAOBFUSACTOR_DECRYPT_STR_0("\213\177\86\41\202\38\246", "\84\133\221\55\80\175")).LocalPlayer;
			v209 = 2 - 1;
		end
	end
end);
local function v80(v217)
	local v218 = 285 - (175 + 110);
	local v219;
	local v220;
	while true do
		if (v218 == (0 - 0)) then
			if not v217 then
				return;
			end
			v219 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\232\55\181\135\111\184\243\48\175\201\91\174", "\60\221\135\68\198\167")];
			v218 = 4 - 3;
		end
		if (v218 == 1) then
			if (not v219 or not v219.Enabled) then
				return;
			end
			v220 = v219.TargetBosses or {};
			v218 = 1798 - (503 + 1293);
		end
		if (v218 == (5 - 3)) then
			for v349, v350 in pairs(v54.BossDirectory) do
				if (v217._roomNumber < v350.RequiredRoom) then
					continue;
				end
				local v351 = LUAOBFUSACTOR_DECRYPT_STR_0("\204\178\235\144\2", "\185\142\221\152\227\34") .. tostring(v350.BossNumber);
				if not table.find(v220, v351) then
					continue;
				end
				if v219.UpgradeBossChests then
					local v408 = 0;
					local v409;
					while true do
						if (v408 == (1 + 0)) then
							if v409 then
								local v464 = 1061 - (810 + 251);
								while true do
									if (v464 == 0) then
										v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\107\209\86\238\86\32", "\151\56\165\55\154\35\83"), LUAOBFUSACTOR_DECRYPT_STR_0("\147\87\4\250\181\80\95\174\149\83\2\252\161\71\0\234\224", "\142\192\35\101") .. v351 .. LUAOBFUSACTOR_DECRYPT_STR_0("\150\86\33\166\244\152\226\88\152", "\118\182\21\73\195\135\236\204"));
										task.wait(0.25 + 0);
										break;
									end
								end
							end
							break;
						end
						if ((0 + 0) == v408) then
							v409 = nil;
							pcall(function()
								v409 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\36\41\25\75\29\63\252\1\56\37\112\17\1\241\36\57\12\69\22", "\157\104\92\122\32\100\109"), v350.BossNumber);
							end);
							v408 = 1 + 0;
						end
					end
				end
				if ((v350.BossNumber == (536 - (43 + 490))) and (v55.Misc(LUAOBFUSACTOR_DECRYPT_STR_0("\143\179\204\193\36\103\191\170\170\162\143\232\50\52\158\235\136\163\214\138\11\117", "\203\195\198\175\170\93\71\237")):CountExact() < (734 - (711 + 22)))) then
					continue;
				end
				local v352 = os.clock();
				local v353, v354;
				repeat
					local v382 = 0 - 0;
					while true do
						if ((859 - (240 + 619)) == v382) then
							task.wait();
							pcall(function()
								v353, v354 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\28\74\55\209\66\46\207\58\74\44\193\115\30\239\61", "\156\78\43\94\181\49\113"), v350.BossNumber);
							end);
							break;
						end
					end
				until v353 or v354 or ((os.clock() - v352) >= (1 + 2)) 
			end
			break;
		end
	end
end
v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\64\233\205\167\81\3\74\98\233\211\173\14\71\57\64\231\203\174", "\25\18\136\164\195\107\35")):Connect(function(v221)
	v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\218\34\166\66", "\216\136\77\201\47\18\220\161"), LUAOBFUSACTOR_DECRYPT_STR_0("\14\249\57\200\13\210\150\109\222\36\213\5\134\194", "\226\77\140\75\186\104\188") .. tostring(v221));
	pcall(function()
		v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\149\219\211\52\86\139\207\217\59\109\182\221\195\20\74\160\241\243\48\66\187\199\222\58", "\47\217\174\176\95"), 1 - 0);
	end);
end);
v33.Anchored = true;
v71(LUAOBFUSACTOR_DECRYPT_STR_0("\148\200\117\9\171\113\110\35\182\201\65\13\160\88\124", "\70\216\189\22\98\210\52\24"));
if v12.Enabled then
	while task.wait() do
		local v289 = v53.GetByOwner(v31);
		if (not v289 or v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\246\218\165\147\252\212\239\182\149\195\213\204\166", "\179\186\191\195\231"))) then
			v67:Set(LUAOBFUSACTOR_DECRYPT_STR_0("\213\58\30\240\214\49\40\241\235\47\23\247\252", "\132\153\95\120"), false);
			local v355 = v52.GetLevel();
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\157\183\24\40\251", "\192\209\210\110\77\151\186"), LUAOBFUSACTOR_DECRYPT_STR_0("\195\22\48\251\250\202\244\67\14\236\233\193\236\89\98", "\164\128\99\66\137\159") .. tostring(v355));
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\51\157\232\170\21\154", "\222\96\233\137"), LUAOBFUSACTOR_DECRYPT_STR_0("\138\167\166\11\157\224\170\249\144\181\26\137\231\249\183\180\231\45\137\250\244\247\253\233", "\144\217\211\199\127\232\147"));
			local v356;
			for v383 = 1 + 0, 1754 - (1344 + 400) do
				local v384 = v53.GetByPortal(v383);
				if (not v384 or (v384 and (v384._owner == game.Players.LocalPlayer))) then
					v356 = v383;
					break;
				end
			end
			pcall(function()
				v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\209\33\45\60\212\75\1\77\246\40\1\24\217\68\27\65\234\3\59\41\195\64\43\74\235\59\63\38\214\64", "\36\152\79\94\72\181\37\98"), LUAOBFUSACTOR_DECRYPT_STR_0("\251\205\68\52\206\234\70\54\211", "\95\183\184\39"));
			end);
			pcall(function()
				v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\135\62\238\34\71\191\48\176\46\242\35\71\148\33\167\58\230\50\81", "\98\213\95\135\70\52\224"), {[LUAOBFUSACTOR_DECRYPT_STR_0("\218\170\207\113\93\253\182\197\99\77", "\52\158\195\169\23")]=(((type(v12.Difficulty) == LUAOBFUSACTOR_DECRYPT_STR_0("\116\169\63\118\131\39", "\235\26\220\82\20\230\85\27")) and (v355 >= v12.Difficulty) and v12.Difficulty) or v355),[LUAOBFUSACTOR_DECRYPT_STR_0("\184\174\251\214\117\132", "\20\232\193\137\162")]=v356,[LUAOBFUSACTOR_DECRYPT_STR_0("\18\222\215\178\254\161\24\117\39", "\17\66\191\165\198\135\236\119")]=(406 - (255 + 150))});
			end);
			task.wait();
		end
		repeat
			task.wait(0.25 + 0);
			v289 = v53.GetByOwner(v31);
		until v289 
		if v289 then
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\60\187\175\7\234\251", "\177\111\207\206\115\159\136\140"), LUAOBFUSACTOR_DECRYPT_STR_0("\54\157\17\0\193\92\5\69\163\31\29\218\70\81\2\201\34\21\221\75\17\75\199", "\63\101\233\112\116\180\47"));
			local v357 = v289._id;
			local v358 = false;
			pcall(function()
				v358 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\241\58\228\22\235\9\233\52\228\28", "\86\163\91\141\114\152"), v357);
			end);
			if not v358 then
				repeat
					local v426 = 0;
					while true do
						if (v426 == (0 + 0)) then
							task.wait(0.5 - 0);
							pcall(function()
								v358 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\97\10\125\119\41\108\33\123\122\52", "\90\51\107\20\19"), v357);
							end);
							break;
						end
					end
				until v358 
			end
			task.wait(0.2);
			repeat
				task.wait();
			until v36:FindFirstChild(LUAOBFUSACTOR_DECRYPT_STR_0("\160\241\140\225", "\93\237\144\229\143"), true) 
			v36:FindFirstChild(LUAOBFUSACTOR_DECRYPT_STR_0("\56\247\249\23", "\38\117\150\144\121\107"), true).CanCollide = true;
			v40 = v36:FindFirstChild(LUAOBFUSACTOR_DECRYPT_STR_0("\0\186\231\52", "\90\77\219\142"), true).CFrame;
			local v361 = false;
			local v362 = 0 - 0;
			local v363 = 1739 - (404 + 1335);
			v44.Fired(LUAOBFUSACTOR_DECRYPT_STR_0("\212\5\40\61\22\71\89\233\9\49\53\73\19\127\226", "\26\134\100\65\89\44\103")):Once(function()
				local v385 = 406 - (183 + 223);
				while true do
					if (v385 == (0 - 0)) then
						v361 = true;
						v362 = os.clock();
						v385 = 1 + 0;
					end
					if ((1 + 0) == v385) then
						v41 = v41 + (338 - (10 + 327));
						v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\195\226\57\39\183\210\236\61\51\168\244\247\53\39", "\196\145\131\80\67"), LUAOBFUSACTOR_DECRYPT_STR_0("\42\191\18\9\20\168\44\177\15\12\11\168\61\191\11\24\20\237\10\181\2\82\88", "\136\126\208\102\104\120") .. tostring(v41));
						break;
					end
				end
			end);
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\75\158\207\87\186\65", "\49\24\234\174\35\207\50\93"), LUAOBFUSACTOR_DECRYPT_STR_0("\63\230\252\156\100\31\168\189\174\112\30\255\244\134\118\76\208\239\141\112\7\243\255\132\116\31\188\179\198", "\17\108\146\157\232"));
			repeat
				task.wait();
				v80(v53.GetByOwner(v31));
				v70(v36:FindFirstChild(LUAOBFUSACTOR_DECRYPT_STR_0("\102\194\29\227", "\200\43\163\116\141\79"), true).CFrame + Vector3.new(0, 3, 0 + 0));
				v363 = 0;
				for v410, v411 in pairs(v67:Get(LUAOBFUSACTOR_DECRYPT_STR_0("\158\58\49\161\162\241\226\180\55\63\143\181\231", "\131\223\86\93\227\208\148"))) do
					if ((v411.pid and v411.pid:lower():find(LUAOBFUSACTOR_DECRYPT_STR_0("\241\68\191\178", "\213\131\37\214\214\125"))) or (v411.id and v411.id:lower():find(LUAOBFUSACTOR_DECRYPT_STR_0("\52\42\44\187", "\129\70\75\69\223")))) then
						v363 += (339 - (118 + 220))
					end
				end
				v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\100\217\246\232\119\238\68\199\246\250\80\234\64\223", "\143\38\171\147\137\28"), LUAOBFUSACTOR_DECRYPT_STR_0("\228\141\173\242\15\163\246\194\135\184\248\2\225\216\213\145\249\223\6\229\192\138\194", "\180\176\226\217\147\99\131") .. tostring(v363));
				if (v361 and ((os.clock() - v362) >= 3)) then
					break;
				end
			until v361 and (v363 == 0) 
			v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\224\173\46\19\198\170", "\103\179\217\79"), LUAOBFUSACTOR_DECRYPT_STR_0("\121\163\29\193\84\159\249\10\152\12\208\79\133\173\77\247\63\221\68\159\183\89\249\82\155", "\195\42\215\124\181\33\236"));
			for v386, v387 in pairs(v289._chests) do
				if (v386:find(LUAOBFUSACTOR_DECRYPT_STR_0("\62\80\48\48", "\152\109\57\87\94\69")) or (v386:find(LUAOBFUSACTOR_DECRYPT_STR_0("\213\210\26\177\187\209\92\169\236\217", "\200\153\183\106\195\222\178\52")) and not v12.OpenLeprechaunChest)) then
					continue;
				end
				v38[v386] = v387.Model:FindFirstChildOfClass(LUAOBFUSACTOR_DECRYPT_STR_0("\31\230\155\53\121\91\32\247", "\58\82\131\232\93\41")).CFrame;
				if (v387.Opened or not v387.Model or not v387.Model:FindFirstChildOfClass(LUAOBFUSACTOR_DECRYPT_STR_0("\174\82\195\29\109\62\145\67", "\95\227\55\176\117\61"))) then
					continue;
				end
				v70(v387.Model:FindFirstChildOfClass(LUAOBFUSACTOR_DECRYPT_STR_0("\53\123\48\67\155\25\108\55", "\203\120\30\67\43")).CFrame);
				local v390, v391;
				local v392 = 0;
				repeat
					task.wait();
					pcall(function()
						v390, v391 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\195\36\68\235\202\206\10\93\234\215\210\45\72\252\205", "\185\145\69\45\143"), v386);
					end);
					v392 = v392 + 1 + 0;
				until v390 or string.find(v391 or LUAOBFUSACTOR_DECRYPT_STR_0("\158\22\28\180", "\188\234\127\121\198"), LUAOBFUSACTOR_DECRYPT_STR_0("\44\59\22\145", "\227\88\82\115")) or (v392 > (459 - (108 + 341))) 
			end
			for v393, v394 in pairs(v38) do
				v70(v394);
				local v395, v396;
				local v397 = 0 + 0;
				repeat
					local v412 = 0;
					while true do
						if (v412 == (4 - 3)) then
							v397 = v397 + (1494 - (711 + 782));
							break;
						end
						if ((0 - 0) == v412) then
							task.wait();
							pcall(function()
								v395, v396 = v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\113\30\179\163\17\76\108\15\191\169\33\123\70\12\174", "\19\35\127\218\199\98"), v393);
							end);
							v412 = 1;
						end
					end
				until v395 or string.find(v396 or LUAOBFUSACTOR_DECRYPT_STR_0("\8\242\15\240", "\130\124\155\106"), LUAOBFUSACTOR_DECRYPT_STR_0("\193\194\243\189", "\223\181\171\150\207\195\150\28")) or (v397 > (479 - (270 + 199))) 
			end
			v37 = true;
			if (v12[LUAOBFUSACTOR_DECRYPT_STR_0("\105\61\228\238\58\73\46\247\167\7\75\41", "\105\44\90\131\206")].Enabled and v45.Get().RaidEggMultiplier and (v45.Get().RaidEggMultiplier >= v12[LUAOBFUSACTOR_DECRYPT_STR_0("\218\231\181\249\59\59\235\244\187\183\15\45", "\94\159\128\210\217\104")].MinimumEggMulti) and v56.CanAfford(LUAOBFUSACTOR_DECRYPT_STR_0("\124\236\5\180\70\92\246\115\94\234", "\26\48\153\102\223\63\31\153"), v12[LUAOBFUSACTOR_DECRYPT_STR_0("\39\71\234\179\49\69\249\231\11\78\234\224", "\147\98\32\141")].MinimumLuckyCoins)) then
				local v413 = 0 + 0;
				local v414;
				local v415;
				local v416;
				local v417;
				local v418;
				local v419;
				local v420;
				while true do
					if (0 == v413) then
						pcall(function()
							v44.Fire(LUAOBFUSACTOR_DECRYPT_STR_0("\49\77\240\222\7\88\72\17\77\228\245\54\90\74\1\70\241\230\3\87\93\29\106\237\217\18\87\69\27\70", "\43\120\35\131\170\102\54"), LUAOBFUSACTOR_DECRYPT_STR_0("\120\19\132\189\188\130\133\93\2", "\228\52\102\231\214\197\208"));
						end);
						task.wait(0.1);
						pcall(function()
							v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\55\238\102\222\235\133\26\223\16\231\74\250\230\138\0\211\12\197\123\222\239\153\48\216\13\244\116\196\233\142", "\182\126\128\21\170\138\235\121"), LUAOBFUSACTOR_DECRYPT_STR_0("\167\207\54\237\159\54\55\1", "\102\235\186\85\134\230\115\80"));
						end);
						v70(CFrame.new(5262 - (580 + 1239), -(496 - 329), 3534));
						v413 = 1 + 0;
					end
					if (2 == v413) then
						v419 = v415 * v418;
						v420 = v45.Get().RaidEggMultiplier;
						v24:SetText(LUAOBFUSACTOR_DECRYPT_STR_0("\100\24\63\75\103\199", "\66\55\108\94\63\18\180"), LUAOBFUSACTOR_DECRYPT_STR_0("\39\153\132\35\50\74\78\205\173\54\51\90\28\132\139\48\103\124\19\138\197\43\103\65", "\57\116\237\229\87\71") .. tostring(v420));
						repeat
							task.wait();
							pcall(function()
								v44.Invoke(LUAOBFUSACTOR_DECRYPT_STR_0("\137\164\254\243\120\227\98\173\182\254\216\95\239\83\169\185", "\39\202\209\141\135\23\142"), v414, v418);
							end);
							v70(CFrame.new(v416));
						until not v56.CanAfford(LUAOBFUSACTOR_DECRYPT_STR_0("\211\38\10\1\43\219\240\58\7\25", "\152\159\83\105\106\82"), v419) or ((os.time() - v417) >= (v12[LUAOBFUSACTOR_DECRYPT_STR_0("\164\193\86\178\250\89\149\210\88\252\206\79", "\60\225\166\49\146\169")].MaxOpenTime * (3 + 57))) 
						break;
					end
					if (v413 == 1) then
						v414, v415, v416 = nil;
						repeat
							local v459 = 0 + 0;
							while true do
								if (v459 == (0 - 0)) then
									task.wait();
									for v477, v478 in pairs(v39) do
										if not (v478.hatchable and v478.renderable and v478.position) then
											continue;
										end
										local v479 = v57.GetPower(LUAOBFUSACTOR_DECRYPT_STR_0("\3\11\44\33\24\53\46\23\43\15\6\0\12\17\60\62", "\103\79\126\79\74\97"));
										local v480 = (v58.HasPerk(LUAOBFUSACTOR_DECRYPT_STR_0("\159\120\212\96", "\122\218\31\179\19\62"), LUAOBFUSACTOR_DECRYPT_STR_0("\144\222\200\192\217\164\87\150\209\202\210", "\37\211\182\173\161\169\193")) and v58.GetPerkPower(LUAOBFUSACTOR_DECRYPT_STR_0("\210\61\74\202", "\217\151\90\45\185\72\27"), LUAOBFUSACTOR_DECRYPT_STR_0("\224\116\226\19\70\198\110\194\21\81\208", "\54\163\28\135\114"))) or 0;
										v415 = v59(v478.dir) * (1 - (v479 / (63 + 37))) * ((1168 - (645 + 522)) - (v480 / (1890 - (1010 + 780))));
										v414 = v477;
										v416 = v478.position;
										break;
									end
									break;
								end
							end
						until v414 and v415 
						v417 = os.time();
						v418 = v50.GetMaxHatch();
						v413 = 2 + 0;
					end
				end
			end
			v67:Set(LUAOBFUSACTOR_DECRYPT_STR_0("\4\222\91\150\97\113\24\206\79\146\65\108\45", "\31\72\187\61\226\46"), true);
		end
	end
end
