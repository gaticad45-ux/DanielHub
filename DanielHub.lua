local player = game.Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local volando = false
local velocidadVuelo = 50
local caminarActivo = false
local velocidadCaminar = 16
local saltoInfinito = false
local noclip = false
local espActivo = false

local colorON = Color3.fromRGB(0,170,0)
local colorOFF = Color3.fromRGB(170,0,0)

-- SISTEMA TP
local archivoTP1 = "DeltaTP1.txt"
local archivoTP2 = "DeltaTP2.txt"
local archivoTP3 = "DeltaTP3.txt"
local archivoTP4 = "DeltaTP4.txt"
local archivoTP5 = "DeltaTP5.txt"

local function guardarTP(archivo)
	if writefile then
		local p = hrp.Position
		writefile(archivo,p.X..","..p.Y..","..p.Z)
	end
end

local function borrarTP(archivo)
	if delfile and isfile and isfile(archivo) then
		delfile(archivo)
	end
end

local function teleportTP(archivo)
	if readfile and isfile and isfile(archivo) then
		local data = readfile(archivo)
		local s = string.split(data,",")
		local x = tonumber(s[1])
		local y = tonumber(s[2])
		local z = tonumber(s[3])
		hrp.CFrame = CFrame.new(x,y,z)
	end
end

local gui = Instance.new("ScreenGui")
gui.Parent = CoreGui

-- BOTON FLOTANTE
local botonAbrir = Instance.new("TextButton")
botonAbrir.Size = UDim2.new(0,50,0,50)
botonAbrir.Position = UDim2.new(0.5,-25,0.75,0)
botonAbrir.Text = "⚡"
botonAbrir.Parent = gui
botonAbrir.BackgroundColor3 = Color3.fromRGB(25,25,25)
botonAbrir.TextScaled = true
botonAbrir.Draggable = true

-- MENU
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,240,0,400)
menu.Position = UDim2.new(0.5,-120,0.5,-200)
menu.BackgroundColor3 = Color3.fromRGB(20,20,20)
menu.Visible = false
menu.Parent = gui
menu.Draggable = true

botonAbrir.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- PESTAÑAS
local tabP1 = Instance.new("TextButton")
tabP1.Size = UDim2.new(0,120,0,30)
tabP1.Position = UDim2.new(0,0,0,0)
tabP1.Text = "P1"
tabP1.Parent = menu

local tabTP = Instance.new("TextButton")
tabTP.Size = UDim2.new(0,120,0,30)
tabTP.Position = UDim2.new(0,120,0,0)
tabTP.Text = "TP"
tabTP.Parent = menu

local tabPlayers = Instance.new("TextButton")
tabPlayers.Size = UDim2.new(0,120,0,30)
tabPlayers.Position = UDim2.new(0,240,0,0)
tabPlayers.Text = "Players"
tabPlayers.Parent = menu

-- FRAMES
local frameP1 = Instance.new("Frame")
frameP1.Size = UDim2.new(1,0,1,-30)
frameP1.Position = UDim2.new(0,0,0,30)
frameP1.BackgroundTransparency = 1
frameP1.Parent = menu

local frameTP = Instance.new("ScrollingFrame")
frameTP.Size = UDim2.new(1,0,1,-30)
frameTP.Position = UDim2.new(0,0,0,30)
frameTP.BackgroundTransparency = 1
frameTP.Visible = false
frameTP.Parent = menu

frameTP.CanvasSize = UDim2.new(0,0,0,800)
frameTP.ScrollBarThickness = 6

local framePlayers = Instance.new("Frame")
framePlayers.Size = UDim2.new(1,0,1,-30)
framePlayers.Position = UDim2.new(0,0,0,30)
framePlayers.BackgroundTransparency = 1
framePlayers.Visible = false
framePlayers.Parent = menu

tabP1.MouseButton1Click:Connect(function()
	frameP1.Visible = true
	frameTP.Visible = false
	framePlayers.Visible = false
end)

tabTP.MouseButton1Click:Connect(function()
	frameP1.Visible = false
	frameTP.Visible = true
	framePlayers.Visible = false
end)

tabPlayers.MouseButton1Click:Connect(function()
	frameP1.Visible = false
	frameTP.Visible = false
	framePlayers.Visible = true
end)

-- =====================
-- BOTONES TP
-- =====================
local autoTP = {
	[archivoTP1] = 0,
	[archivoTP2] = 0,
	[archivoTP3] = 0,
	[archivoTP4] = 0,
	[archivoTP5] = 0
}

local function crearControlAutoTP(archivo, yPos)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0,100,0,30)
	label.Position = UDim2.new(0,20,0,yPos)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Text = "← 0 →"
	label.Parent = frameTP

	local menos = Instance.new("TextButton")
	menos.Size = UDim2.new(0,30,0,30)
	menos.Position = UDim2.new(0,130,0,yPos)
	menos.Text = "<"
	menos.Parent = frameTP

	local mas = Instance.new("TextButton")
	mas.Size = UDim2.new(0,30,0,30)
	mas.Position = UDim2.new(0,170,0,yPos)
	mas.Text = ">"
	mas.Parent = frameTP

	local running = false

	local function actualizarTexto()
		label.Text = "← "..autoTP[archivo].." →"
	end

	local function loopAutoTP()

		if running then return end
		running = true

		task.spawn(function()

			while autoTP[archivo] > 0 do
				task.wait(autoTP[archivo])

				if autoTP[archivo] > 0 then
					teleportTP(archivo)
				end

			end

			running = false

		end)

	end

	mas.MouseButton1Click:Connect(function()

		autoTP[archivo] += 1
		actualizarTexto()

		if autoTP[archivo] > 0 then
			loopAutoTP()
		end

	end)

	menos.MouseButton1Click:Connect(function()

		autoTP[archivo] = math.max(0, autoTP[archivo] - 1)
		actualizarTexto()

	end)

end


-- =====================
-- TP1
-- =====================

local botonTP1 = Instance.new("TextButton")
botonTP1.Size = UDim2.new(0,200,0,30)
botonTP1.Position = UDim2.new(0,20,0,20)
botonTP1.Text = "TP1: OFF"
botonTP1.Parent = frameTP
botonTP1.BackgroundColor3 = colorOFF
botonTP1.Style = Enum.ButtonStyle.Custom
botonTP1.AutoButtonColor = false

if isfile and isfile(archivoTP1) then
	botonTP1.Text = "TP1: ON"
	botonTP1.BackgroundColor3 = colorON
end

botonTP1.MouseButton1Click:Connect(function()

	if isfile and isfile(archivoTP1) then

		borrarTP(archivoTP1)
		botonTP1.Text = "TP1: OFF"
		botonTP1.BackgroundColor3 = colorOFF

	else

		guardarTP(archivoTP1)
		botonTP1.Text = "TP1: ON"
		botonTP1.BackgroundColor3 = colorON

	end

end)

local botonTeleport1 = Instance.new("TextButton")
botonTeleport1.Size = UDim2.new(0,200,0,30)
botonTeleport1.Position = UDim2.new(0,20,0,60)
botonTeleport1.Text = "Teleport 1"
botonTeleport1.Parent = frameTP

botonTeleport1.MouseButton1Click:Connect(function()
	teleportTP(archivoTP1)
end)

crearControlAutoTP(archivoTP1, 100)


-- =====================
-- TP2
-- =====================

local botonTP2 = Instance.new("TextButton")
botonTP2.Size = UDim2.new(0,200,0,30)
botonTP2.Position = UDim2.new(0,20,0,150)
botonTP2.Text = "TP2: OFF"
botonTP2.Parent = frameTP
botonTP2.BackgroundColor3 = colorOFF
botonTP2.Style = Enum.ButtonStyle.Custom
botonTP2.AutoButtonColor = false

if isfile and isfile(archivoTP2) then
	botonTP2.Text = "TP2: ON"
	botonTP2.BackgroundColor3 = colorON
end

botonTP2.MouseButton1Click:Connect(function()

	if isfile and isfile(archivoTP2) then

		borrarTP(archivoTP2)
		botonTP2.Text = "TP2: OFF"
		botonTP2.BackgroundColor3 = colorOFF

	else

		guardarTP(archivoTP2)
		botonTP2.Text = "TP2: ON"
		botonTP2.BackgroundColor3 = colorON

	end

end)

local botonTeleport2 = Instance.new("TextButton")
botonTeleport2.Size = UDim2.new(0,200,0,30)
botonTeleport2.Position = UDim2.new(0,20,0,190)
botonTeleport2.Text = "Teleport 2"
botonTeleport2.Parent = frameTP

botonTeleport2.MouseButton1Click:Connect(function()
	teleportTP(archivoTP2)
end)

crearControlAutoTP(archivoTP2, 230)


-- =====================
-- TP3
-- =====================

local botonTP3 = Instance.new("TextButton")
botonTP3.Size = UDim2.new(0,200,0,30)
botonTP3.Position = UDim2.new(0,20,0,280)
botonTP3.Text = "TP3: OFF"
botonTP3.Parent = frameTP
botonTP3.BackgroundColor3 = colorOFF
botonTP3.Style = Enum.ButtonStyle.Custom
botonTP3.AutoButtonColor = false

if isfile and isfile(archivoTP3) then
	botonTP3.Text = "TP3: ON"
	botonTP3.BackgroundColor3 = colorON
end

botonTP3.MouseButton1Click:Connect(function()

	if isfile and isfile(archivoTP3) then

		borrarTP(archivoTP3)
		botonTP3.Text = "TP3: OFF"
		botonTP3.BackgroundColor3 = colorOFF

	else

		guardarTP(archivoTP3)
		botonTP3.Text = "TP3: ON"
		botonTP3.BackgroundColor3 = colorON

	end

end)

local botonTeleport3 = Instance.new("TextButton")
botonTeleport3.Size = UDim2.new(0,200,0,30)
botonTeleport3.Position = UDim2.new(0,20,0,320)
botonTeleport3.Text = "Teleport 3"
botonTeleport3.Parent = frameTP

botonTeleport3.MouseButton1Click:Connect(function()
	teleportTP(archivoTP3)
end)

crearControlAutoTP(archivoTP3, 360)


-- =====================
-- TP4
-- =====================

local botonTP4 = Instance.new("TextButton")
botonTP4.Size = UDim2.new(0,200,0,30)
botonTP4.Position = UDim2.new(0,20,0,410)
botonTP4.Text = "TP4: OFF"
botonTP4.Parent = frameTP
botonTP4.BackgroundColor3 = colorOFF
botonTP4.Style = Enum.ButtonStyle.Custom
botonTP4.AutoButtonColor = false

if isfile and isfile(archivoTP4) then
	botonTP4.Text = "TP4: ON"
	botonTP4.BackgroundColor3 = colorON
end

botonTP4.MouseButton1Click:Connect(function()

	if isfile and isfile(archivoTP4) then

		borrarTP(archivoTP4)
		botonTP4.Text = "TP4: OFF"
		botonTP4.BackgroundColor3 = colorOFF

	else

		guardarTP(archivoTP4)
		botonTP4.Text = "TP4: ON"
		botonTP4.BackgroundColor3 = colorON

	end

end)

local botonTeleport4 = Instance.new("TextButton")
botonTeleport4.Size = UDim2.new(0,200,0,30)
botonTeleport4.Position = UDim2.new(0,20,0,450)
botonTeleport4.Text = "Teleport 4"
botonTeleport4.Parent = frameTP

botonTeleport4.MouseButton1Click:Connect(function()
	teleportTP(archivoTP4)
end)

crearControlAutoTP(archivoTP4, 490)


-- =====================
-- TP5
-- =====================

local botonTP5 = Instance.new("TextButton")
botonTP5.Size = UDim2.new(0,200,0,30)
botonTP5.Position = UDim2.new(0,20,0,540)
botonTP5.Text = "TP5: OFF"
botonTP5.Parent = frameTP
botonTP5.BackgroundColor3 = colorOFF
botonTP5.Style = Enum.ButtonStyle.Custom
botonTP5.AutoButtonColor = false

if isfile and isfile(archivoTP5) then
	botonTP5.Text = "TP5: ON"
	botonTP5.BackgroundColor3 = colorON
end

botonTP5.MouseButton1Click:Connect(function()

	if isfile and isfile(archivoTP5) then

		borrarTP(archivoTP5)
		botonTP5.Text = "TP5: OFF"
		botonTP5.BackgroundColor3 = colorOFF

	else

		guardarTP(archivoTP5)
		botonTP5.Text = "TP5: ON"
		botonTP5.BackgroundColor3 = colorON

	end

end)

local botonTeleport5 = Instance.new("TextButton")
botonTeleport5.Size = UDim2.new(0,200,0,30)
botonTeleport5.Position = UDim2.new(0,20,0,580)
botonTeleport5.Text = "Teleport 5"
botonTeleport5.Parent = frameTP

botonTeleport5.MouseButton1Click:Connect(function()
	teleportTP(archivoTP5)
end)

crearControlAutoTP(archivoTP5, 620)

-- =====================
-- VOLAR
-- =====================

local botonVolar = Instance.new("TextButton")
botonVolar.Size = UDim2.new(0,200,0,30)
botonVolar.Position = UDim2.new(0,20,0,10)
botonVolar.Text = "Volar: OFF"
botonVolar.Parent = frameP1

local textoVuelo = Instance.new("TextLabel")
textoVuelo.Size = UDim2.new(0,120,0,30)
textoVuelo.Position = UDim2.new(0,60,0,45)
textoVuelo.Text = "Velocidad: 50"
textoVuelo.BackgroundTransparency = 1
textoVuelo.TextColor3 = Color3.new(1,1,1)
textoVuelo.Parent = frameP1

local menosVuelo = Instance.new("TextButton")
menosVuelo.Size = UDim2.new(0,30,0,30)
menosVuelo.Position = UDim2.new(0,20,0,45)
menosVuelo.Text = "<"
menosVuelo.Parent = frameP1

local masVuelo = Instance.new("TextButton")
masVuelo.Size = UDim2.new(0,30,0,30)
masVuelo.Position = UDim2.new(0,190,0,45)
masVuelo.Text = ">"
masVuelo.Parent = frameP1

-- CAMINAR
local botonCaminar = Instance.new("TextButton")
botonCaminar.Size = UDim2.new(0,200,0,30)
botonCaminar.Position = UDim2.new(0,20,0,90)
botonCaminar.Text = "Velocidad Caminar: OFF"
botonCaminar.Parent = frameP1

local textoCaminar = Instance.new("TextLabel")
textoCaminar.Size = UDim2.new(0,120,0,30)
textoCaminar.Position = UDim2.new(0,60,0,125)
textoCaminar.Text = "Velocidad: 16"
textoCaminar.BackgroundTransparency = 1
textoCaminar.TextColor3 = Color3.new(1,1,1)
textoCaminar.Parent = frameP1

local menosCaminar = Instance.new("TextButton")
menosCaminar.Size = UDim2.new(0,30,0,30)
menosCaminar.Position = UDim2.new(0,20,0,125)
menosCaminar.Text = "<"
menosCaminar.Parent = frameP1

local masCaminar = Instance.new("TextButton")
masCaminar.Size = UDim2.new(0,30,0,30)
masCaminar.Position = UDim2.new(0,190,0,125)
masCaminar.Text = ">"
masCaminar.Parent = frameP1

-- SALTO
local botonSalto = Instance.new("TextButton")
botonSalto.Size = UDim2.new(0,200,0,30)
botonSalto.Position = UDim2.new(0,20,0,170)
botonSalto.Text = "Salto Infinito: OFF"
botonSalto.Parent = frameP1

-- NOCLIP
local botonNoclip = Instance.new("TextButton")
botonNoclip.Size = UDim2.new(0,200,0,30)
botonNoclip.Position = UDim2.new(0,20,0,210)
botonNoclip.Text = "Atravesar paredes: OFF"
botonNoclip.Parent = frameP1

-- ESP
local botonESP = Instance.new("TextButton")
botonESP.Size = UDim2.new(0,200,0,30)
botonESP.Position = UDim2.new(0,20,0,250)
botonESP.Text = "Ver Jugadores: OFF"
botonESP.Parent = frameP1

local function aplicarESP(char)
	if not espActivo then return end
	if char:FindFirstChild("ESP_Highlight") then return end

local plr = Players:GetPlayerFromCharacter(char)
if not plr then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillColor = Color3.fromRGB(255,0,0)
	highlight.OutlineColor = Color3.fromRGB(255,255,255)
	highlight.FillTransparency = 0.5
	highlight.Parent = char
end

local function conectarJugador(plr)

	if plr == player then return end

	if plr.Character then
		aplicarESP(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		aplicarESP(char)
	end)

end

for _,plr in pairs(Players:GetPlayers()) do
	conectarJugador(plr)
end

Players.PlayerAdded:Connect(conectarJugador)

local playerButtons = {}
local y = 10

local function crearBotonJugador(plr)

	if plr == player then return end

	local boton = Instance.new("TextButton")
	boton.Size = UDim2.new(0,200,0,30)
	boton.Position = UDim2.new(0,20,0,y)
	boton.Text = "TP "..plr.Name
	boton.Parent = framePlayers

	playerButtons[plr] = boton
	y = y + 40

	boton.MouseButton1Click:Connect(function()

		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
		end

	end)

end


local function eliminarBotonJugador(plr)

	if playerButtons[plr] then
		playerButtons[plr]:Destroy()
		playerButtons[plr] = nil
	end

end


for _,plr in pairs(Players:GetPlayers()) do
	crearBotonJugador(plr)
end


Players.PlayerAdded:Connect(function(plr)
	crearBotonJugador(plr)
end)


Players.PlayerRemoving:Connect(function(plr)
	eliminarBotonJugador(plr)
end)

botonESP.MouseButton1Click:Connect(function()

	espActivo = not espActivo
	botonESP.Text = espActivo and "Ver Jugadores: ON" or "Ver Jugadores: OFF"

	if not espActivo then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character then
				local h = plr.Character:FindFirstChild("ESP_Highlight")
				if h then h:Destroy() end
			end
		end
	else
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character then
				aplicarESP(plr.Character)
			end
		end
	end

end)

-- VELOCIDADES
masVuelo.MouseButton1Click:Connect(function()
	velocidadVuelo += 50
	textoVuelo.Text = "Velocidad: "..velocidadVuelo
end)

menosVuelo.MouseButton1Click:Connect(function()
	velocidadVuelo = math.max(50, velocidadVuelo-50)
	textoVuelo.Text = "Velocidad: "..velocidadVuelo
end)

masCaminar.MouseButton1Click:Connect(function()
	velocidadCaminar += 50
	textoCaminar.Text = "Velocidad: "..velocidadCaminar
	if caminarActivo then humanoid.WalkSpeed = velocidadCaminar end
end)

menosCaminar.MouseButton1Click:Connect(function()
	velocidadCaminar = math.max(16, velocidadCaminar-50)
	textoCaminar.Text = "Velocidad: "..velocidadCaminar
	if caminarActivo then humanoid.WalkSpeed = velocidadCaminar end
end)

-- CAMINAR
botonCaminar.MouseButton1Click:Connect(function()
	caminarActivo = not caminarActivo
	humanoid.WalkSpeed = caminarActivo and velocidadCaminar or 16
	botonCaminar.Text = caminarActivo and "Velocidad Caminar: ON" or "Velocidad Caminar: OFF"
end)

-- SALTO
botonSalto.MouseButton1Click:Connect(function()
	saltoInfinito = not saltoInfinito
	botonSalto.Text = saltoInfinito and "Salto Infinito: ON" or "Salto Infinito: OFF"
end)

UIS.JumpRequest:Connect(function()
	if saltoInfinito then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- NOCLIP
botonNoclip.MouseButton1Click:Connect(function()
	noclip = not noclip
	botonNoclip.Text = noclip and "Atravesar paredes: ON" or "Atravesar paredes: OFF"
end)

RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide=false
			end
		end
	end
end)

-- VUELO
local bodyVel
local bodyGyro

botonVolar.MouseButton1Click:Connect(function()

	volando = not volando

	if volando then
		botonVolar.Text = "Volar: ON"

		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
		bodyVel.Parent = hrp

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bodyGyro.P = 10000
		bodyGyro.Parent = hrp

	else
		botonVolar.Text = "Volar: OFF"

		if bodyVel then bodyVel:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end

end)

RunService.RenderStepped:Connect(function()

	if volando and bodyVel then

		local cam = workspace.CurrentCamera
		bodyGyro.CFrame = cam.CFrame

		local direccion = humanoid.MoveDirection

		if direccion.Magnitude > 0 then
			bodyVel.Velocity = cam.CFrame.LookVector * velocidadVuelo
		else
			bodyVel.Velocity = Vector3.new(0,0,0)
		end

	end

end)