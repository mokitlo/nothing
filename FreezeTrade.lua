--!strict
-- MM2 MENU — UI ONLY
-- Адаптировано под телефон:
--   • компактный автоматический размер;
--   • кнопки нажимаются мышью и касанием;
--   • окно перетаскивается за верхнюю часть;
--   • размер автоматически подбирается отдельно для телефона и ПК.
--
-- Внутри нет функций трейда, автоматического принятия или вмешательства в игру.
-- Для Roblox Studio: помести как LocalScript в StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local OLD_NAME = "MM2ResponsiveMenu"
local oldGui = playerGui:FindFirstChild(OLD_NAME)
if oldGui then
	oldGui:Destroy()
end

local BASE_WIDTH = 500
local BASE_HEIGHT = 610

-- Размеры взяты из h.txt: компактный вариант для телефона и немного крупнее для ПК.
local TARGET_WIDTH = isMobile and 300 or 340
local TARGET_HEIGHT = isMobile and 370 or 400
local MIN_AUTO_SCALE = 0.35

local COLORS = {
	Panel = Color3.fromRGB(5, 8, 18),
	PanelTop = Color3.fromRGB(8, 17, 36),
	PanelBottom = Color3.fromRGB(17, 8, 34),
	Card = Color3.fromRGB(7, 10, 21),
	Text = Color3.fromRGB(244, 247, 255),
	Muted = Color3.fromRGB(112, 121, 166),
	Blue = Color3.fromRGB(43, 168, 255),
	Purple = Color3.fromRGB(143, 65, 255),
	ToggleOff = Color3.fromRGB(48, 29, 92),
	ToggleOn = Color3.fromRGB(62, 104, 225),
}

local function corner(parent: Instance, radius: number)
	local object = Instance.new("UICorner")
	object.CornerRadius = UDim.new(0, radius)
	object.Parent = parent
	return object
end

local function stroke(parent: Instance, thickness: number, transparency: number, color: Color3)
	local object = Instance.new("UIStroke")
	object.Thickness = thickness
	object.Transparency = transparency
	object.Color = color
	object.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	object.Parent = parent
	return object
end

local function gradient(parent: Instance, first: Color3, second: Color3, rotation: number)
	local object = Instance.new("UIGradient")
	object.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, first),
		ColorSequenceKeypoint.new(1, second),
	})
	object.Rotation = rotation
	object.Parent = parent
	return object
end

local gui = Instance.new("ScreenGui")
gui.Name = OLD_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(BASE_WIDTH, BASE_HEIGHT)
main.BackgroundColor3 = COLORS.Panel
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui
corner(main, 27)

local uiScale = Instance.new("UIScale")
uiScale.Name = "MenuScale"
uiScale.Scale = 0.75
uiScale.Parent = main

local mainStroke = stroke(main, 2, 0.05, COLORS.Blue)
gradient(mainStroke, COLORS.Blue, COLORS.Purple, 0)
gradient(main, COLORS.PanelTop, COLORS.PanelBottom, 115)

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 8, 0.5, 10)
shadow.Size = UDim2.fromOffset(BASE_WIDTH, BASE_HEIGHT)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.48
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = main
corner(shadow, 27)

local header = Instance.new("Frame")
header.Name = "DragHeader"
header.Position = UDim2.fromOffset(22, 18)
header.Size = UDim2.new(1, -44, 0, 116)
header.BackgroundTransparency = 1
header.Active = true
header.Parent = main

local logo = Instance.new("Frame")
logo.Name = "Logo"
logo.Position = UDim2.fromOffset(0, 4)
logo.Size = UDim2.fromOffset(72, 72)
logo.BackgroundColor3 = Color3.fromRGB(16, 31, 72)
logo.BorderSizePixel = 0
logo.Parent = header
corner(logo, 19)

local logoStroke = stroke(logo, 2, 0, COLORS.Blue)
gradient(logoStroke, COLORS.Blue, COLORS.Purple, 45)
gradient(logo, Color3.fromRGB(17, 59, 113), Color3.fromRGB(51, 19, 105), 135)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "MM2"
logoText.TextColor3 = COLORS.Text
logoText.TextSize = 24
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logo

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(91, 7)
title.Size = UDim2.new(1, -154, 0, 34)
title.BackgroundTransparency = 1
title.Text = "MM2 TRADE CONTROLLER"
title.TextColor3 = COLORS.Text
title.TextSize = 21
title.TextScaled = false
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header
gradient(title, COLORS.Blue, COLORS.Purple, 0)

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(91, 45)
subtitle.Size = UDim2.new(1, -154, 0, 25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "TRADE SCAM/FREEZE TRADE"
subtitle.TextColor3 = COLORS.Muted
subtitle.TextSize = 13
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.GothamMedium
subtitle.Parent = header

local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.AnchorPoint = Vector2.new(1, 0)
minimize.Position = UDim2.new(1, 0, 0, 7)
minimize.Size = UDim2.fromOffset(50, 50)
minimize.BackgroundColor3 = Color3.fromRGB(27, 17, 60)
minimize.AutoButtonColor = false
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(192, 207, 255)
minimize.TextSize = 25
minimize.Font = Enum.Font.GothamBold
minimize.ZIndex = 11
minimize.Parent = header
corner(minimize, 14)
stroke(minimize, 2, 0.18, COLORS.Purple)

-- Отдельная зона перетаскивания не перекрывает кнопку сворачивания.
local dragArea = Instance.new("TextButton")
dragArea.Name = "DragArea"
dragArea.Position = UDim2.fromOffset(0, 0)
dragArea.Size = UDim2.new(1, -64, 0, 100)
dragArea.BackgroundTransparency = 1
dragArea.BorderSizePixel = 0
dragArea.AutoButtonColor = false
dragArea.Text = ""
dragArea.Active = true
dragArea.Selectable = false
dragArea.ZIndex = 10
dragArea.Parent = header

local divider = Instance.new("Frame")
divider.Position = UDim2.fromOffset(0, 100)
divider.Size = UDim2.new(1, 0, 0, 2)
divider.BackgroundColor3 = COLORS.Blue
divider.BorderSizePixel = 0
divider.Parent = header
gradient(divider, COLORS.Blue, COLORS.Purple, 0)

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.fromOffset(22, 150)
content.Size = UDim2.new(1, -44, 0, 310)
content.BackgroundTransparency = 1
content.Parent = main

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Vertical
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.VerticalAlignment = Enum.VerticalAlignment.Top
list.Padding = UDim.new(0, 16)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

local function createToggleRow(order: number, rowName: string, symbol: string)
	local card = Instance.new("Frame")
	card.Name = rowName:gsub("%s+", "")
	card.LayoutOrder = order
	card.Size = UDim2.new(1, 0, 0, 142)
	card.BackgroundColor3 = COLORS.Card
	card.BackgroundTransparency = 0.07
	card.BorderSizePixel = 0
	card.Active = true
	card.Parent = content
	corner(card, 23)

	-- Небольшое сжатие всей ячейки при нажатии.
	local cardScale = Instance.new("UIScale")
	cardScale.Name = "PressScale"
	cardScale.Scale = 1
	cardScale.Parent = card

	-- Обычная слабая обводка становится яркой, когда пункт включен.
	local cardStroke = stroke(card, 2, 0.34, COLORS.Blue)
	gradient(cardStroke, COLORS.Blue, COLORS.Purple, 0)

	-- Невидимая кнопка делает кликабельной всю свободную область ячейки.
	local clickArea = Instance.new("TextButton")
	clickArea.Name = "ClickArea"
	clickArea.Size = UDim2.fromScale(1, 1)
	clickArea.BackgroundTransparency = 1
	clickArea.BorderSizePixel = 0
	clickArea.AutoButtonColor = false
	clickArea.Text = ""
	clickArea.Active = true
	clickArea.Selectable = true
	clickArea.ZIndex = 1
	clickArea.Parent = card
	corner(clickArea, 23)

	local icon = Instance.new("Frame")
	icon.Position = UDim2.fromOffset(20, 37)
	icon.Size = UDim2.fromOffset(66, 66)
	icon.BackgroundColor3 = Color3.fromRGB(17, 35, 82)
	icon.BorderSizePixel = 0
	icon.ZIndex = 2
	icon.Parent = card
	corner(icon, 18)

	local iconStroke = stroke(icon, 2, 0.05, COLORS.Blue)
	gradient(iconStroke, COLORS.Blue, COLORS.Purple, 45)
	gradient(icon, Color3.fromRGB(16, 64, 125), Color3.fromRGB(52, 20, 109), 135)

	local iconText = Instance.new("TextLabel")
	iconText.Size = UDim2.fromScale(1, 1)
	iconText.BackgroundTransparency = 1
	iconText.Text = symbol
	iconText.TextColor3 = Color3.fromRGB(155, 207, 255)
	iconText.TextSize = 35
	iconText.Font = Enum.Font.GothamBold
	iconText.ZIndex = 3
	iconText.Parent = icon

	local rowTitle = Instance.new("TextLabel")
	rowTitle.Position = UDim2.fromOffset(105, 38)
	rowTitle.Size = UDim2.new(1, -225, 0, 34)
	rowTitle.BackgroundTransparency = 1
	rowTitle.Text = rowName
	rowTitle.TextColor3 = COLORS.Text
	rowTitle.TextSize = 23
	rowTitle.TextXAlignment = Enum.TextXAlignment.Left
	rowTitle.Font = Enum.Font.GothamBold
	rowTitle.ZIndex = 2
	rowTitle.Parent = card

	local status = Instance.new("TextLabel")
	status.Position = UDim2.fromOffset(105, 76)
	status.Size = UDim2.new(1, -225, 0, 27)
	status.BackgroundTransparency = 1
	status.Text = "Inactive"
	status.TextColor3 = COLORS.Muted
	status.TextSize = 16
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Font = Enum.Font.GothamMedium
	status.ZIndex = 2
	status.Parent = card

	local toggle = Instance.new("TextButton")
	toggle.Name = "Toggle"
	toggle.AnchorPoint = Vector2.new(1, 0.5)
	toggle.Position = UDim2.new(1, -20, 0.5, 0)
	toggle.Size = UDim2.fromOffset(102, 52)
	toggle.BackgroundColor3 = COLORS.ToggleOff
	toggle.BorderSizePixel = 0
	toggle.AutoButtonColor = false
	toggle.Text = ""
	toggle.Active = true
	toggle.Selectable = true
	toggle.ZIndex = 4
	toggle.Parent = card
	corner(toggle, 26)
	stroke(toggle, 1.5, 0.35, COLORS.Purple)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position = UDim2.new(0, 6, 0.5, 0)
	knob.Size = UDim2.fromOffset(40, 40)
	knob.BackgroundColor3 = Color3.fromRGB(129, 120, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 5
	knob.Parent = toggle
	corner(knob, 20)
	stroke(knob, 2, 0.25, Color3.fromRGB(205, 212, 255))

	local active = false
	local pressTween: Tween? = nil
	local releaseTween: Tween? = nil

	local function playPressEffect()
		if pressTween then
			pressTween:Cancel()
		end
		if releaseTween then
			releaseTween:Cancel()
		end

		pressTween = TweenService:Create(
			cardScale,
			TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Scale = 0.975 }
		)
		pressTween:Play()

		TweenService:Create(
			card,
			TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = active
					and Color3.fromRGB(13, 22, 45)
					or Color3.fromRGB(11, 16, 31),
			}
		):Play()
	end

	local function playReleaseEffect()
		if pressTween then
			pressTween:Cancel()
		end
		if releaseTween then
			releaseTween:Cancel()
		end

		releaseTween = TweenService:Create(
			cardScale,
			TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1 }
		)
		releaseTween:Play()

		TweenService:Create(
			card,
			TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = active
					and Color3.fromRGB(10, 17, 35)
					or COLORS.Card,
			}
		):Play()
	end

	local function renderState()
		status.Text = active and "Active" or "Inactive"

		TweenService:Create(
			knob,
			TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				Position = active
					and UDim2.new(1, -46, 0.5, 0)
					or UDim2.new(0, 6, 0.5, 0),
			}
		):Play()

		TweenService:Create(
			toggle,
			TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = active and COLORS.ToggleOn or COLORS.ToggleOff,
			}
		):Play()

		TweenService:Create(
			status,
			TweenInfo.new(0.2),
			{
				TextColor3 = active and Color3.fromRGB(116, 209, 255) or COLORS.Muted,
			}
		):Play()

		-- Постоянная яркая обводка включенной ячейки.
		TweenService:Create(
			cardStroke,
			TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				Thickness = active and 3.5 or 2,
				Transparency = active and 0 or 0.34,
			}
		):Play()

		TweenService:Create(
			card,
			TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				BackgroundColor3 = active
					and Color3.fromRGB(10, 17, 35)
					or COLORS.Card,
			}
		):Play()

		TweenService:Create(
			iconStroke,
			TweenInfo.new(0.2),
			{
				Thickness = active and 3 or 2,
				Transparency = active and 0 or 0.05,
			}
		):Play()
	end

	local function activate()
		active = not active
		renderState()
	end

	-- Эффект работает и при нажатии на всю ячейку, и на сам переключатель.
	for _, button in { clickArea, toggle } do
		button.MouseButton1Down:Connect(playPressEffect)
		button.MouseButton1Up:Connect(playReleaseEffect)
		button.MouseLeave:Connect(playReleaseEffect)

		button.InputBegan:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.Touch then
				playPressEffect()
			end
		end)

		button.InputEnded:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.Touch then
				playReleaseEffect()
			end
		end)

		button.Activated:Connect(activate)
	end
end

createToggleRow(1, "Freeze Trade", "❄")
createToggleRow(2, "Auto Accept", "✓")

local footer = Instance.new("TextLabel")
footer.Name = "Footer"
footer.AnchorPoint = Vector2.new(0.5, 1)
footer.Position = UDim2.new(0.5, 0, 1, -54)
footer.Size = UDim2.new(1, -80, 0, 42)
footer.BackgroundTransparency = 1
footer.Text = "Made By mokitlo"
footer.TextColor3 = COLORS.Text
footer.TextSize = 20
footer.Font = Enum.Font.GothamBold
footer.Parent = main
gradient(footer, COLORS.Blue, COLORS.Purple, 0)

local function viewportSize(): Vector2
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1280, 720)
end

local function fittedScale(): number
	local viewport = viewportSize()
	local preferredScale = math.min(TARGET_WIDTH / BASE_WIDTH, TARGET_HEIGHT / BASE_HEIGHT)
	local viewportScale = math.min(
		(viewport.X * 0.92) / BASE_WIDTH,
		(viewport.Y * 0.90) / BASE_HEIGHT
	)

	return math.max(math.min(preferredScale, viewportScale), MIN_AUTO_SCALE)
end

local cameraViewportConnection: RBXScriptConnection? = nil

local function applyFittedScale()
	uiScale.Scale = fittedScale()
end

local function bindCurrentCamera()
	if cameraViewportConnection then
		cameraViewportConnection:Disconnect()
		cameraViewportConnection = nil
	end

	local camera = workspace.CurrentCamera
	if camera then
		cameraViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyFittedScale)
	end

	applyFittedScale()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCurrentCamera)
bindCurrentCamera()

-- Сворачивание
local minimized = false
local normalHeight = BASE_HEIGHT
local compactHeight = 128

minimize.Activated:Connect(function()
	minimized = not minimized
	minimize.Text = minimized and "+" or "−"

	content.Visible = not minimized
	footer.Visible = not minimized

	TweenService:Create(
		main,
		TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{
			Size = UDim2.fromOffset(BASE_WIDTH, minimized and compactHeight or normalHeight),
		}
	):Play()
end)

-- Перетаскивание окна мышью и пальцем.
-- Состояние принудительно сбрасывается при отпускании, отмене ввода
-- и потере фокуса, поэтому меню больше не "прилипает" к курсору.
local dragging = false
local activeDragInput: InputObject? = nil
local dragStart = Vector2.zero
local startPosition = main.Position

local function stopDragging()
	dragging = false
	activeDragInput = nil
end

local function updateDrag(pointerPosition: Vector2)
	local delta = pointerPosition - dragStart
	local scale = math.max(uiScale.Scale, 0.01)

	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X / scale,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y / scale
	)
end

dragArea.InputBegan:Connect(function(input: InputObject)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch
	then
		return
	end

	dragging = true
	activeDragInput = input
	dragStart = input.Position
	startPosition = main.Position

	input.Changed:Connect(function()
		if activeDragInput == input
			and (input.UserInputState == Enum.UserInputState.End
				or input.UserInputState == Enum.UserInputState.Cancel)
		then
			stopDragging()
		end
	end)
end)

UserInputService.InputChanged:Connect(function(input: InputObject)
	if not dragging or not activeDragInput then
		return
	end

	if activeDragInput.UserInputType == Enum.UserInputType.Touch then
		if input == activeDragInput then
			updateDrag(input.Position)
		end
	elseif input.UserInputType == Enum.UserInputType.MouseMovement then
		updateDrag(input.Position)
	end
end)

UserInputService.InputEnded:Connect(function(input: InputObject)
	if input == activeDragInput
		or (dragging and input.UserInputType == Enum.UserInputType.MouseButton1)
	then
		stopDragging()
	end
end)

UserInputService.WindowFocusReleased:Connect(stopDragging)
