--========================================
-- HEAD SNAP HUB - AIMBOT ARSENAL
-- DRAG + COLLAPSE | AIMBOT + ESP + GUI FOV
-- WORK 100% (NO DRAWING CIRCLE)
-- FIXED 100% WALL CHECK + ALL ERRORS
--========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--================ SETTINGS =================
local ESP_ENABLED = true
local ESP_COLOR = Color3.fromRGB(0,255,0)
local ESP_THICKNESS = 1.5
local FOV_ENABLED = true
local FOV_RADIUS = 300
local FOV_COLOR = Color3.fromRGB(255,0,0)
local WALLCHECK_ENABLED = true
local aimbot = false
local ESP_Boxes = {}

--================ UI ROOT =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--================ FOV GUI =================
local FOVFrame = Instance.new("Frame", ScreenGui)
FOVFrame.Size = UDim2.fromOffset(FOV_RADIUS*2, FOV_RADIUS*2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = FOV_ENABLED
FOVFrame.ZIndex = 1e6
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Color = FOV_COLOR
FOVStroke.Thickness = 2

local FOVCorner = Instance.new("UICorner", FOVFrame)
FOVCorner.CornerRadius = UDim.new(1, 0)

--================ MAIN UI =================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,260,0,350)
MainFrame.Position = UDim2.new(0.5,-130,0.5,-165)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)  -- Bo góc MainFrame

-- Viền xanh cho MainFrame
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 100, 255)
MainStroke.Thickness = 2.5
MainStroke.Transparency = 0  -- Hiện khi bình thường
-- HEADER (BO GÓC)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1,0,0,42)
Header.BackgroundColor3 = Color3.fromRGB(30,30,30)
Header.BorderSizePixel = 0
Header.Active = true

-- BO GÓC NHẸ CHO HEADER (LUÔN CÓ)
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)  -- Bo góc 8px (nhẹ hơn MainFrame)

-- KHÔNG VIỀN (sẽ thêm khi thu gọn)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1,-50,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "HEAD SNAP HUB - ARSENAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CollapseBtn = Instance.new("TextButton", Header)
CollapseBtn.Size = UDim2.new(0,40,1,0)
CollapseBtn.Position = UDim2.new(1,-42,0,0)
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.Text = "−"
CollapseBtn.TextColor3 = Color3.new(1,1,1)
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.TextSize = 22

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1,0,1,-42)
Content.Position = UDim2.new(0,0,0,42)
Content.BackgroundColor3 = Color3.fromRGB(15,15,15)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,12)
-- THANH TAB (CAO 40px)
local TabBar = Instance.new("Frame", Content)
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(20,20,20)  -- Màu đậm
TabBar.BorderSizePixel = 0

-- Bo góc trên cho TabBar
local TabBarCorner = Instance.new("UICorner", TabBar)
TabBarCorner.CornerRadius = UDim.new(0, 12)

-- TẠO NÚT TAB "MAIN"
local MainTab = Instance.new("TextButton", TabBar)
MainTab.Size = UDim2.new(0, 100, 0, 30)  -- Rộng 100px, cao 30px
MainTab.Position = UDim2.new(0, 10, 0, 5)  -- Cách trái 10px, cách trên 5px
MainTab.BackgroundColor3 = Color3.fromRGB(60,60,60)  -- Màu xám (đang chọn)
MainTab.BorderSizePixel = 0
MainTab.Text = "MAIN"
MainTab.TextColor3 = Color3.new(1,1,1)
MainTab.Font = Enum.Font.SourceSansBold
MainTab.TextSize = 16
Instance.new("UICorner", MainTab).CornerRadius = UDim.new(0, 6)

-- (CÓ THỂ THÊM TAB KHÁC NẾU MUỐN, NHƯNG MÀY CHỈ CẦN 1 TAB)
-- ========== CONTAINER CỦA TAB MAIN ==========
local MainContainer = Instance.new("Frame", Content)
MainContainer.Size = UDim2.new(1, 0, 1, -40)     -- Cao = Content - 40px (trừ phần TabBar)
MainContainer.Position = UDim2.new(0, 0, 0, 40)  -- Đặt ngay dưới TabBar
MainContainer.BackgroundColor3 = Color3.fromRGB(15,15,15)  -- Cùng màu với Content
MainContainer.BackgroundTransparency = 0
MainContainer.BorderSizePixel = 0
-- KHÔNG bo góc vì đã có Content bo rồi
local function MakeButton(text, y)
    local b = Instance.new("TextButton", MainContainer)
    b.Size = UDim2.new(1,-20,0,42)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local AimBtn = MakeButton("Aimbot : OFF", 10)
local EspBtn = MakeButton("ESP : ON", 62)
local FovBtn = MakeButton("FOV : ON", 114)
local WallCheckBtn = MakeButton("Wall Check : ON", 218)

--================ FOV +/- BUTTON =================
local FovPlus = Instance.new("TextButton", MainContainer)
FovPlus.Size = UDim2.new(0.5,-15,0,36)
FovPlus.Position = UDim2.new(0,10,0,166)
FovPlus.BackgroundColor3 = Color3.fromRGB(55,55,55)
FovPlus.Text = "+"
FovPlus.TextColor3 = Color3.new(1,1,1)
FovPlus.Font = Enum.Font.SourceSansBold
FovPlus.TextSize = 22
Instance.new("UICorner", FovPlus).CornerRadius = UDim.new(0,8)

local FovMinus = Instance.new("TextButton", MainContainer)
FovMinus.Size = UDim2.new(0.5,-15,0,36)
FovMinus.Position = UDim2.new(0.5,5,0,166)
FovMinus.BackgroundColor3 = Color3.fromRGB(55,55,55)
FovMinus.Text = "−"
FovMinus.TextColor3 = Color3.new(1,1,1)
FovMinus.Font = Enum.Font.SourceSansBold
FovMinus.TextSize = 22
Instance.new("UICorner", FovMinus).CornerRadius = UDim.new(0,8)

--================ BUTTON EVENTS =================
FovBtn.MouseButton1Click:Connect(function()
    FOV_ENABLED = not FOV_ENABLED
    FovBtn.Text = FOV_ENABLED and "FOV : ON" or "FOV : OFF"
    FOVFrame.Visible = FOV_ENABLED
end)

WallCheckBtn.MouseButton1Click:Connect(function()
    WALLCHECK_ENABLED = not WALLCHECK_ENABLED
    WallCheckBtn.Text = WALLCHECK_ENABLED and "Wall Check : ON" or "Wall Check : OFF"
end)

--================ DRAG FIX =================
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

--================ COLLAPSE =================
local collapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    Content.Visible = not collapsed
    CollapseBtn.Text = collapsed and "+" or "−"
    
    if collapsed then
        -- THU GỌN: Ẩn viền MainFrame, thêm viền cho Header
        MainStroke.Transparency = 1
        
        -- Thêm viền xanh cho Header (nếu chưa có)
        if not Header:FindFirstChild("HeaderStroke") then
            local HeaderStroke = Instance.new("UIStroke", Header)
            HeaderStroke.Name = "HeaderStroke"
            HeaderStroke.Color = Color3.fromRGB(0, 100, 255)
            HeaderStroke.Thickness = 2.5
        else
            Header.HeaderStroke.Transparency = 0
        end
        
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(0,260,0,42)
        }):Play()
        
    else
        -- MỞ RỘNG: Hiện viền MainFrame, xóa viền Header
        MainStroke.Transparency = 0
        
        if Header:FindFirstChild("HeaderStroke") then
            Header.HeaderStroke.Transparency = 1
        end
        
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(0,260,0,330)
        }):Play()
    end
end)
--================ AIMBOT =================
local function GetClosestTarget()
    local closest, shortest = nil, FOV_RADIUS
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            
            if hum and hum.Health > 0 and head then
                local pos, onscreen = Camera:WorldToViewportPoint(head.Position)
                
                if onscreen then
                    local dist = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) 
                        - Vector2.new(pos.X, pos.Y)).Magnitude
                    
                    if FOV_ENABLED and dist <= FOV_RADIUS and dist < shortest then
                        
                        local canAim = true
                        
                        if WALLCHECK_ENABLED then
                            local function IsVisible(target)
                                local origin = Camera.CFrame.Position
                                local direction = (target.Position - origin).Unit * (target.Position - origin).Magnitude
                                
                                local raycastParams = RaycastParams.new()
                                raycastParams.FilterDescendantsInstances = {player.Character, Camera}
                                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                
                                local result = workspace:Raycast(origin, direction, raycastParams)
                                
                                return result == nil or result.Instance:IsDescendantOf(target.Parent)
                            end
                            
                            if not IsVisible(head) then
                                canAim = false
                            end
                        end
                        
                        if canAim then
                            shortest, closest = dist, head
                        end
                        
                    end -- ĐÓNG if FOV_ENABLED
                    
                end -- ĐÓNG if onscreen
                
            end -- ĐÓNG if hum and head
            
        end -- ĐÓNG if plr ~= player
        
    end -- ĐÓNG for
    
    return closest
end -- ĐÓNG function

RunService.RenderStepped:Connect(function()
    if aimbot and FOV_ENABLED then
        local t = GetClosestTarget()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
        end
    end
end)

AimBtn.MouseButton1Click:Connect(function()
    aimbot = not aimbot
    AimBtn.Text = aimbot and "Aimbot : ON" or "Aimbot : OFF"
end)

--================ ESP FIX ALL =================
local ESP_Boxes = {}

local function CreateESP_Player(plr)
    if plr == player then return end
    
    -- Đợi character load với retry
    local char = plr.Character
    local retry = 0
    while not char and retry < 10 do
        task.wait(0.2)
        char = plr.Character
        retry = retry + 1
    end
    
    if not char then return end
    
    -- Lấy HumanoidRootPart với retry
    local hrp = char:FindFirstChild("HumanoidRootPart")
    retry = 0
    while not hrp and retry < 10 do
        task.wait(0.2)
        hrp = char:FindFirstChild("HumanoidRootPart")
        retry = retry + 1
    end
    
    if not hrp then return end
    
    -- Lấy Humanoid để check health
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    -- TÍNH KÍCH THƯỚC BOX THEO STUD
    local boxWidth = hrp.Size.X + 2
    local boxHeight = hrp.Size.Y * 2.5

    -- TẠO BILLBOARDGUI
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_"..plr.Name
    Billboard.AlwaysOnTop = true
    Billboard.LightInfluence = 0
    Billboard.Size = UDim2.fromScale(boxWidth, boxHeight)
    Billboard.StudsOffset = Vector3.new(0, hrp.Size.Y * 0.5, 0)
    Billboard.Adornee = hrp
    Billboard.Enabled = hum.Health > 0

    -- TẠO FRAME (BOX)
    local Box = Instance.new("Frame", Billboard)
    Box.Name = "Box"
    Box.BackgroundColor3 = ESP_COLOR
    Box.BackgroundTransparency = 1
    Box.BorderSizePixel = 0
    Box.Size = UDim2.new(1, 0, 1, 0)

    -- TẠO VIỀN
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = ESP_COLOR
    Stroke.Thickness = ESP_THICKNESS
    Stroke.Transparency = 0

    -- BO GÓC
    local Corner = Instance.new("UICorner", Box)
    Corner.CornerRadius = UDim.new(0, 4)

    -- XỬ LÝ KHI NHÂN VẬT ĐỔI (RETRY)
    local function onCharacterAdded(newChar)
        task.wait(0.5)
        local newHrp = newChar:FindFirstChild("HumanoidRootPart")
        if newHrp then
            Billboard.Adornee = newHrp
        else
            task.wait(1)
            newHrp = newChar:FindFirstChild("HumanoidRootPart")
            if newHrp then
                Billboard.Adornee = newHrp
            end
        end
    end

    plr.CharacterAdded:Connect(onCharacterAdded)

    ESP_Boxes[plr] = Billboard
    Billboard.Parent = game:GetService("CoreGui")
end

local function RemoveESP_Player(plr)
    local billboard = ESP_Boxes[plr]
    if billboard then
        billboard:Destroy()
        ESP_Boxes[plr] = nil
    end
end

-- Tạo ESP cho các player hiện tại
for _, plr in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        CreateESP_Player(plr)
    end)
end

-- Kết nối sự kiện
Players.PlayerAdded:Connect(function(plr)
    task.spawn(function()
        CreateESP_Player(plr)
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP_Player)

-- Update ESP mỗi frame
RunService.RenderStepped:Connect(function()
    if not ESP_ENABLED then
        for _, billboard in pairs(ESP_Boxes) do
            if billboard then
                local box = billboard:FindFirstChild("Box")
                if box then
                    local stroke = box:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Transparency = 1
                    end
                end
            end
        end
        return
    end

    for plr, billboard in pairs(ESP_Boxes) do
        if billboard then
            if plr.Character then
                local hum = plr.Character:FindFirstChild("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and hum and hum.Health > 0 then
                    -- Cập nhật vị trí (Billboard tự động scale)
                    local box = billboard:FindFirstChild("Box")
                    if box then
                        local stroke = box:FindFirstChildOfClass("UIStroke")
                        if stroke then
                            stroke.Transparency = 0
                            stroke.Color = ESP_COLOR
                        end
                    end
                    billboard.Enabled = true
                else
                    billboard.Enabled = false
                end
            else
                billboard.Enabled = false
            end
        end
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    EspBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"

    for _, billboard in pairs(ESP_Boxes) do
        if billboard then
            local box = billboard:FindFirstChild("Box")
            if box then
                local stroke = box:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Transparency = ESP_ENABLED and 0 or 1
                end
            end
        end
    end
end)
--================ FOV UPDATE =================
RunService.RenderStepped:Connect(function()
    if not Camera then return end
    FOVFrame.Position = UDim2.new(0.5, 0, 0.5, -35)
    FOVFrame.Size = UDim2.fromOffset(FOV_RADIUS*2, FOV_RADIUS*2)
end)

--================ FOV +/- LOGIC =================
local FOV_MIN = 50
local FOV_MAX = 600
local FOV_STEP = 25

FovPlus.MouseButton1Click:Connect(function()
    FOV_RADIUS = math.clamp(FOV_RADIUS + FOV_STEP, FOV_MIN, FOV_MAX)
end)

FovMinus.MouseButton1Click:Connect(function()
    FOV_RADIUS = math.clamp(FOV_RADIUS - FOV_STEP, FOV_MIN, FOV_MAX)
end)

--========================================
-- END OF SCRIPT - NO ERRORS
--========================================
