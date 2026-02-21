--========================================

-- AIMBOT ARSENAL UI (ROUNDED)

-- DRAG + COLLAPSE

-- AIMBOT + ESP + GUI FOV

-- WORK 100% (NO DRAWING CIRCLE)

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

local FOV_RADIUS = 300 -- pixel

local FOV_COLOR = Color3.fromRGB(255,0,0)

--================ STORAGE =================

local Boxes = {}

--================ UI ROOT =================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.ResetOnSpawn = false

ScreenGui.Parent = player:WaitForChild("PlayerGui")

--================ FOV GUI (FIX 100%) =================

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

MainFrame.Size = UDim2.new(0,260,0,330)

MainFrame.Position = UDim2.new(0.5,-130,0.5,-165)

MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)

MainFrame.BorderSizePixel = 0

MainFrame.Active = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60,60,60)

local Header = Instance.new("Frame", MainFrame)

Header.Size = UDim2.new(1,0,0,42)

Header.BackgroundColor3 = Color3.fromRGB(30,30,30)

Header.BorderSizePixel = 0

Header.Active = true

Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)

Header.Active = true

Header.Selectable = true

local Title = Instance.new("TextLabel", Header)

Title.Size = UDim2.new(1,-50,1,0)

Title.Position = UDim2.new(0,12,0,0)

Title.BackgroundTransparency = 1

Title.Text = "Aimbot Arsenal"

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

local function MakeButton(text, y)

	local b = Instance.new("TextButton", Content)	b.Size = UDim2.new(1,-20,0,42)

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
FovBtn.MouseButton1Click:Connect(function()
    FOV_ENABLED = not FOV_ENABLED
    FovBtn.Text = FOV_ENABLED and "FOV : ON" or "FOV : OFF"
    FOVFrame.Visible = FOV_ENABLED  -- Set trực tiếp
end)
--================ FOV +/- BUTTON =================

local FovPlus = Instance.new("TextButton", Content)
FovPlus.Size = UDim2.new(0.5,-15,0,36)
FovPlus.Position = UDim2.new(0,10,0,166)
FovPlus.BackgroundColor3 = Color3.fromRGB(55,55,55)
FovPlus.Text = "+"
FovPlus.TextColor3 = Color3.new(1,1,1)
FovPlus.Font = Enum.Font.SourceSansBold
FovPlus.TextSize = 22
Instance.new("UICorner", FovPlus).CornerRadius = UDim.new(0,8)

local FovMinus = Instance.new("TextButton", Content)
FovMinus.Size = UDim2.new(0.5,-15,0,36)
FovMinus.Position = UDim2.new(0.5,5,0,166)
FovMinus.BackgroundColor3 = Color3.fromRGB(55,55,55)
FovMinus.Text = "−"
FovMinus.TextColor3 = Color3.new(1,1,1)
FovMinus.Font = Enum.Font.SourceSansBold
FovMinus.TextSize = 22
Instance.new("UICorner", FovMinus).CornerRadius = UDim.new(0,8)
--================ DRAG FIX (WORK 100%) =================

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

	TweenService:Create(MainFrame, TweenInfo.new(0.25), {

		Size = collapsed and UDim2.new(0,260,0,42) or UDim2.new(0,260,0,330)

	}):Play()

end)

--================ AIMBOT (HEAD) =================

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
                    
                    -- KIỂM TRA FOV
                    if FOV_ENABLED and dist <= FOV_RADIUS and dist < shortest then
                        
                        -- 🔥 WALL CHECK - LUÔN BẬT, KHÔNG CÓ NÚT 🔥
                        local canAim = true
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        rayParams.FilterDescendantsInstances = {player.Character, plr.Character}
                        
                        local rayResult = workspace:Raycast(
                            Camera.CFrame.Position,
                            (head.Position - Camera.CFrame.Position).Unit * 1000,
                            rayParams
                        )
                        
                        -- Nếu có raycast và không trúng địch => có tường
                        if rayResult then
                            local hitPart = rayResult.Instance
                            if hitPart and not hitPart:IsDescendantOf(plr.Character) then
                                canAim = false -- Có tường, không aim
                            end
                        end
                        
                        -- CHỈ AIM NẾU CAN AIM = TRUE
                        if canAim then
                            shortest, closest = dist, head
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

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

-- Thay thế toàn bộ phần ESP (từ dòng "--================ ESP =================" trở đi) bằng code này:

--================ ESP FIX (DÙNG BILLBOARD GUI) =================
local ESP_Boxes = {} -- Lưu các GUI cho mỗi player

-- Hàm tạo ESP Box bằng GUI
local function CreateESP_Player(plr)
    if plr == player then return end
    
    -- Tạo BillboardGui
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_"..plr.Name
    Billboard.AlwaysOnTop = true
    Billboard.LightInfluence = 0
    Billboard.Size = UDim2.new(0, 50, 0, 100) -- Kích thước sẽ được điều chỉnh sau
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") or nil
    
    -- Tạo Frame chính (vẽ box)
    local Box = Instance.new("Frame", Billboard)
    Box.Name = "Box"
    Box.BackgroundColor3 = ESP_COLOR
    Box.BackgroundTransparency = 1 -- Trong suốt để chỉ thấy viền
    Box.BorderSizePixel = 0
    Box.Size = UDim2.new(1, 0, 1, 0)
    
    -- Tạo viền (UIStroke)
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = ESP_COLOR
    Stroke.Thickness = ESP_THICKNESS
    Stroke.Transparency = 0
    
    -- Tạo góc bo tròn (tùy chọn)
    local Corner = Instance.new("UICorner", Box)
    Corner.CornerRadius = UDim.new(0, 4)
    
    -- Kết nối với nhân vật (phòng khi nhân vật thay đổi)
    local function onCharacterAdded(char)
        task.wait(0.1) -- Chờ để load
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            Billboard.Adornee = hrp
        end
    end
    
    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    plr.CharacterAdded:Connect(onCharacterAdded)
    
    -- Lưu lại
    ESP_Boxes[plr] = Billboard
    Billboard.Parent = game:GetService("CoreGui") -- Hoặc player.PlayerGui tùy executer
end

-- Xóa ESP khi player rời
local function RemoveESP_Player(plr)
    local billboard = ESP_Boxes[plr]
    if billboard then
        billboard:Destroy()
        ESP_Boxes[plr] = nil
    end
end

-- Tạo ESP cho các player hiện tại
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        CreateESP_Player(plr)
    end
end

-- Kết nối sự kiện
Players.PlayerAdded:Connect(CreateESP_Player)
Players.PlayerRemoving:Connect(RemoveESP_Player)

-- Update kích thước box dựa trên khoảng cách
RunService.RenderStepped:Connect(function()
    if not ESP_ENABLED then
        -- Ẩn tất cả nếu tắt ESP
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
        if billboard and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                -- Tính khoảng cách để điều chỉnh kích thước
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                local sizeMultiplier = math.clamp(2000 / dist, 0.5, 3)
                
                -- Điều chỉnh kích thước Billboard
                billboard.Size = UDim2.new(0, 40 * sizeMultiplier, 0, 80 * sizeMultiplier)
                
                -- Hiện box
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
        end
    end
end)

-- Thêm chức năng bật/tắt màu sắc (tùy chọn)
EspBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    EspBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"
    
    -- Cập nhật trạng thái hiển thị
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
--================ FOV UPDATE (GUI) =================
RunService.RenderStepped:Connect(function()
    if not Camera then return end
    
    -- Cập nhật vị trí và kích thước (không set visibility ở đây nữa)
    FOVFrame.Position = UDim2.new(
        0.5, 0,
        0.5, -35
    )
    
    FOVFrame.Size = UDim2.fromOffset(FOV_RADIUS*2, FOV_RADIUS*2)
    
    -- KHÔNG set FOVFrame.Visible ở đây nữa, để nó giữ nguyên trạng thái từ nút bấm
    -- FOVFrame.Visible = FOV_ENABLED  <-- XÓA DÒNG NÀY
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
