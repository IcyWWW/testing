local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

local clientConfig = {
	Flying = false,
	FlyingSpeed = 50,
	BaseplateTransparency = 0
}

local Window = Fluent:CreateWindow({
	Title = "Gold's Easy Hub v2 " --[[.. Fluent.Version]],
	SubTitle = "by lvasion",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "home" }),
	Players = Window:AddTab({ Title = "Players", Icon = "users" }),
	Universals = Window:AddTab({ Title = "Universals", Icon = "umbrella" }),
	VC = Window:AddTab({ Title = "Voice Chat", Icon = "disc" }),
	Animations = Window:AddTab({ Title = "Animations", Icon = "book" }),
	Exploits = Window:AddTab({ Title = "Exploits", Icon = "hammer" }),
	Lighting = Window:AddTab({ Title = "Lighting", Icon = "sun" }),
	Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "crown" }),
	Beta = Window:AddTab({ Title = "Beta", Icon = "download" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
	Fluent:Notify({
		Title = "Notification",
		Content = "Loading",
		SubContent = "We are currently loading the hub, please wait...", -- Optional
		Duration = 5 -- Set to nil to make the notification not disappear
	})

	Tabs.Main:AddParagraph({
		Title = "Gold's Easy Hub Version 2",
		Content = "Welcome to Gold's Easy Hub Version 2, this script was built for Mic Up.\nIf you wish to report any bugs, please join our discord server."
	})

	Tabs.Main:AddParagraph({
		Title = "Discord Server",
		Content = "Invite: "
	})

	Tabs.Main:AddButton({
		Title = "Flight",
		Description = "Toggle client flight",
		Callback = function()
			Window:Dialog({
				Title = "Flight Mode",
				Content = "Would you like to enable or disable flight?",
				Buttons = {
					{
						Title = "Enable",
						Callback = function()

						end
					},
					{
						Title = "Disable",
						Callback = function()

						end
					}
				}
			})
		end
	})

	local FlightKeybind = Tabs.Main:AddKeybind("Keybind", {
		Title = "QuickFlight Keybind",
		Mode = "Toggle",
		Default = "X",

		Callback = function(Value)
			if Value then

			else

			end
		end,

		ChangedCallback = function(New) end
	})

	local FlyspeedSlider = Tabs.Main:AddSlider("Slider", {
		Title = "Flight Speed",
		Description = "Set current fly speed",
		Default = 50,
		Min = 0,
		Max = 200,
		Rounding = 1,
		Callback = function(Value)
			clientConfig.FlyingSpeed = Value
		end
	})

	FlyspeedSlider:OnChanged(function(Value)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if char then
			clientConfig.FlyingSpeed = Value
		end
	end)

	FlyspeedSlider:SetValue(50)

	Tabs.Main:AddButton({
		Title = "Baseplate",
		Description = "Toggle extended baseplate",
		Callback = function()
			Window:Dialog({
				Title = "Load Baseplate",
				Content = "Would you like to enable or disable the extended baseplate?",
				Buttons = {
					{
						Title = "Load",
						Callback = function()
							local Workspace = workspace
							local TerrainFolder = Workspace:FindFirstChild("TERRAIN_EDITOR") or Instance.new("Folder", Workspace)
							TerrainFolder.Name = "TERRAIN_EDITOR"

							local position = Vector3.new(66, -2.5, 72.5)
							local size = Vector3.new(40000, 5, 40000)
							local maxPartSize = 2048
							local material = Enum.Material.Asphalt
							local color = Color3.fromRGB(50, 50, 50)
							local transparency = 0

							local function createPart(pos, partSize)
								local part = Instance.new("Part")
								part.Size = partSize
								part.Position = pos
								part.Anchored = true
								part.Material = material
								part.Color = color
								part.Transparency = transparency
								part.Parent = TerrainFolder
								return part
							end

							if size.X > maxPartSize or size.Z > maxPartSize then
								local divisionsX = math.ceil(size.X / maxPartSize)
								local divisionsZ = math.ceil(size.Z / maxPartSize)

								local partSize = Vector3.new(size.X / divisionsX, size.Y, size.Z / divisionsZ)

								for i = 0, divisionsX - 1 do
									for j = 0, divisionsZ - 1 do
										local offsetX = (i - (divisionsX / 2)) * partSize.X + (partSize.X / 2)
										local offsetZ = (j - (divisionsZ / 2)) * partSize.Z + (partSize.Z / 2)
										createPart(position + Vector3.new(offsetX, 0, offsetZ), partSize)
									end
								end
							else
								createPart(position, size)
							end
						end
					},
					{
						Title = "Destroy",
						Callback = function()
							local Workspace = workspace

							if Workspace:FindFirstChild("TERRAIN_EDITOR") then
								Workspace["TERRAIN_EDITOR"]:Destroy()
							end
						end
					}
				}
			})
		end
	})

	local BaseplateSlider = Tabs.Main:AddSlider("Slider", {
		Title = "Baseplate Transparency",
		Description = "Set current baseplate transparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)
			clientConfig.BaseplateTransparency = Value

			local Workspace = workspace

			if Workspace:FindFirstChild("TERRAIN_EDITOR") then
				for _,v in pairs(Workspace["TERRAIN_EDITOR"]:GetChildren()) do
					if v:IsA("BasePart") then
						v.Transparency = clientConfig.BaseplateTransparency
					end
				end
			end
		end
	})

	BaseplateSlider:OnChanged(function(Value)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if char then
			clientConfig.BaseplateTransparency = Value

			local Workspace = workspace

			if Workspace:FindFirstChild("TERRAIN_EDITOR") then
				for _,v in pairs(Workspace["TERRAIN_EDITOR"]:GetChildren()) do
					if v:IsA("BasePart") then
						v.Transparency = clientConfig.BaseplateTransparency
					end
				end
			end
		end
	end)

	BaseplateSlider:SetValue(0)

	local WalkspeedSlider = Tabs.Main:AddSlider("Slider", {
		Title = "WalkSpeed",
		Description = "Set current walkspeed",
		Default = 17,
		Min = 0,
		Max = 200,
		Rounding = 1,
		Callback = function(Value)
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

			if char then
				if char:FindFirstChild("Humanoid") then
					char.Humanoid.WalkSpeed = Value
				end
			end
		end
	})

	local BaseplateColor = Tabs.Main:AddColorpicker("Colorpicker", {
		Title = "Baseplate Color",
		Description = "Set the current baseplate color",
		Default = Color3.fromRGB(50, 50, 50)
	})

	BaseplateColor:OnChanged(function()
		local Workspace = workspace

		if Workspace:FindFirstChild("TERRAIN_EDITOR") then
			for _,v in pairs(Workspace["TERRAIN_EDITOR"]:GetChildren()) do
				if v:IsA("BasePart") then
					v.Color = BaseplateColor.Value
				end
			end
		end
	end)

	BaseplateColor:SetValueRGB(Color3.fromRGB(50, 50, 50))

	WalkspeedSlider:OnChanged(function(Value)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if char then
			if char:FindFirstChild("Humanoid") then
				char.Humanoid.WalkSpeed = Value
			end
		end
	end)

	WalkspeedSlider:SetValue(17)

	local JumppowerSlider = Tabs.Main:AddSlider("Slider", {
		Title = "JumpPower",
		Description = "Set current jumppower",
		Default = 55,
		Min = 0,
		Max = 200,
		Rounding = 1,
		Callback = function(Value)
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

			if char then
				if char:FindFirstChild("Humanoid") then
					char.Humanoid.JumpPower = Value
					char.Humanoid.UseJumpPower = true
				end
			end
		end
	})

	JumppowerSlider:OnChanged(function(Value)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if char then
			if char:FindFirstChild("Humanoid") then
				char.Humanoid.JumpPower = Value
				char.Humanoid.UseJumpPower = true
			end
		end
	end)

	JumppowerSlider:SetValue(55)

	-- players tab

	function getPlayer(short)
		short = string.lower(short)

		local matchedPlayer = nil

		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			if player.Name:lower():sub(1, #short) == short or player.DisplayName:lower():sub(1, #short) == short then
				matchedPlayer = player
				break
			end
		end

		return matchedPlayer
	end

	Tabs.Players:AddParagraph({
		Title = "Server Player",
		Content = "Ensure when inputting, you either input a username or displayname.\nNote: You do not require the full username."
	})

	local SpectateInput = Tabs.Players:AddInput("Input", {
		Title = "Spectate",
		Default = "",
		Placeholder = "Player",
		Numeric = false, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local player = getPlayer(Value)

			if player then
				local currentCamera = game.Workspace.CurrentCamera
				currentCamera.CameraSubject = player.Character:FindFirstChild("Humanoid")
				currentCamera.CameraType = Enum.CameraType.Follow
			end
		end
	})

	Tabs.Players:AddButton({
		Title = "Spectating",
		Description = "Stop specting a player",
		Callback = function()
			Window:Dialog({
				Title = "Stop Spectating",
				Content = "Would you like to stop spectating this user?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local currentCamera = game.Workspace.CurrentCamera
							currentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
							currentCamera.CameraType = Enum.CameraType.Follow
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	local TeleportInput = Tabs.Players:AddInput("Input", {
		Title = "Teleport",
		Default = "",
		Placeholder = "Player",
		Numeric = false, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local player = getPlayer(Value)

			if player and player.Character then
				if LocalPlayer.Character then
					LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				end
			end
		end
	})

	-- universals tab

	Tabs.Universals:AddButton({
		Title = "Infinite Yield",
		Description = "Execute Infinite Yield",
		Callback = function()
			Window:Dialog({
				Title = "Execution",
				Content = "Would you like to inject infinite yield?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet("https://raw.githubusercontent.com/ZLens/micuphub/refs/heads/main/infprem.lua", true))()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Universals:AddButton({
		Title = "System Broken",
		Description = "Execute System Broken",
		Callback = function()
			Window:Dialog({
				Title = "Execution",
				Content = "Would you like to inject system broken?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Universals:AddButton({
		Title = "Face Fuck",
		Description = "Execute Face Fuck (Z)",
		Callback = function()
			Window:Dialog({
				Title = "Execution",
				Content = "Would you like to inject face fuck?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/bruhlolw/refs/heads/main/face_bang_script.lua'))()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Universals:AddButton({
		Title = "Reanimations",
		Description = "Execute Reanimations",
		Callback = function()
			Window:Dialog({
				Title = "Execution",
				Content = "Would you like to inject reanimations?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet('https://raw.githubusercontent.com/ZLens/TheRobloxExperience/refs/heads/main/misc/reanimations.lua'))()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Universals:AddButton({
		Title = "Rewind",
		Description = "Execute Rewind (Hold C)",
		Callback = function()
			Window:Dialog({
				Title = "Execution",
				Content = "Would you like to inject rewind?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet("https://raw.githubusercontent.com/platinum-ViniVX/mic-up-script-pack/refs/heads/main/rewind%20script"))()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	-- voice chat tab

	Tabs.VC:AddButton({
		Title = "Reconnect",
		Description = "Connect to voice chat",
		Callback = function()
			Window:Dialog({
				Title = "Voice Chat",
				Content = "Would you like to connect to voice chat, this may be detected.",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local _vc = game:GetService("VoiceChatInternal")
							_vc:JoinByGroupId('', false)
							_vc:JoinByGroupIdToken('', false, true)
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.VC:AddButton({
		Title = "Disconnect",
		Description = "Disconnect from voice chat",
		Callback = function()
			Window:Dialog({
				Title = "Voice Chat",
				Content = "Would you like to disconnect from voice chat, this may be detected.",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local _vc = game:GetService("VoiceChatInternal")
							_vc:Leave()
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.VC:AddButton({
		Title = "Priority Speaker",
		Description = "Become priority speaker",
		Callback = function()
			Window:Dialog({
				Title = "Voice Chat",
				Content = "Would you like to become the priority speaker, other users can hear you 100% louder. (Warning: You can banned for earrape if you abuse this)",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local _vc = game:GetService("VoiceChatInternal")
							_vc:PublishPause(false)
							task.wait()
							_vc:SetSpeakerDevice('Default', '')
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	local function removeSuspension()
		task.wait(3)
		local _vc = game:GetService("VoiceChatInternal")
		_vc:JoinByGroupIdToken("", false, true)
		task.wait(0.5)
	end

	game:GetService("VoiceChatInternal").LocalPlayerModerated:Connect(removeSuspension)

	Fluent:Notify({
		Title = "Voice Chat",
		Content = "We have loaded voice chat internal, you will no longer get suspended.",
		Duration = 5
	})

	-- animations tab

	local AnimationIdInput = Tabs.Animations:AddInput("Input", {
		Title = "Play animationId",
		Default = "",
		Placeholder = "Animation Id",
		Numeric = true, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local succ, err = pcall(function()
				LocalPlayer.Character.Humanoid:PlayEmoteAndGetAnimTrackById(tonumber(Value))
			end)

			if succ then
				LocalPlayer.Character.Humanoid:PlayEmoteAndGetAnimTrackById(tonumber(Value))
			else
				Fluent:Notify({
					Title = "Script Error",
					Content = "Failed to load animation, " .. err .. ".",
					Duration = 5
				})
				return 
			end
		end
	})

	local Animations = {
		{"Salute", "http://www.roblox.com/asset/?id=10714389988"},
		{"Applaud", "http://www.roblox.com/asset/?id=10713966026"},
		{"Tilt", "http://www.roblox.com/asset/?id=10714338461"},
		{"Baby Queen - Bouncy Twirl", "http://www.roblox.com/asset/?id=14352343065"},
		{"Yungblud Happier Jump", "http://www.roblox.com/asset/?id=15609995579"},
		{"Baby Queen - Face Frame", "http://www.roblox.com/asset/?id=14352340648"},
		{"Baby Queen - Strut", "http://www.roblox.com/asset/?id=14352362059"},
		{"KATSEYE - Touch", "http://www.roblox.com/asset/?id=135876612109535"},
		{"Secret Handshake Dance", "http://www.roblox.com/asset/?id=71243990877913"},
		{"Godlike", "http://www.roblox.com/asset/?id=10714347256"},
		{"Mae Stephens - Piano Hands", "http://www.roblox.com/asset/?id=16553163212"},
		{"Alo Yoga Pose - Lotus Position", "http://www.roblox.com/asset/?id=12507085924"},
		{"d4vd - Backflip", "http://www.roblox.com/asset/?id=15693621070"},
		{"Bored", "http://www.roblox.com/asset/?id=10713992055"},
		{"Cuco - Levitate", "http://www.roblox.com/asset/?id=15698404340"},
		{"Hero Landing", "http://www.roblox.com/asset/?id=10714360164"},
		{"Sleep", "http://www.roblox.com/asset/?id=10714360343"},
		{"Shrug", "http://www.roblox.com/asset/?id=10714374484"},
		{"Shy", "http://www.roblox.com/asset/?id=10714369325"},
		{"Festive Dance", "http://www.roblox.com/asset/?id=15679621440"},
		{"V Pose - Tommy Hilfiger", "http://www.roblox.com/asset/?id=10214319518"},
		{"Olivia Rodrigo Head Bop", "http://www.roblox.com/asset/?id=15517864808"},
		{"Elton John - Heart Shuffle", "http://www.roblox.com/asset/?id=17748314784"},
		{"Bone Chillin Bop", "http://www.roblox.com/asset/?id=15122972413"},
		{"Curtsy", "http://www.roblox.com/asset/?id=10714061912"},
		{"Floss Dance", "http://www.roblox.com/asset/?id=10714340543"},
		{"Hello", "http://www.roblox.com/asset/?id=10714359093"},
		{"Victory Dance", "http://www.roblox.com/asset/?id=15505456446"},
		{"Monkey", "http://www.roblox.com/asset/?id=10714388352"},
		{"TWICE Feel Special", "http://www.roblox.com/asset/?id=14899980745"},
		{"Point2", "http://www.roblox.com/asset/?id=10714395441"},
		{"Quiet Waves", "http://www.roblox.com/asset/?id=10714390497"},
		{"HIPMOTION - Amaarae", "http://www.roblox.com/asset/?id=16572740012"},
		{"Frosty Flair - Tommy Hilfiger", "http://www.roblox.com/asset/?id=10214311282"},
		{"Chappell Roan HOT TO GO!", "http://www.roblox.com/asset/?id=85267023718407"},
		{"Stadium", "http://www.roblox.com/asset/?id=10714356920"},
		{"Skibidi Toilet - Titan Speakerman Laser Spin", "http://www.roblox.com/asset/?id=134283166482394"},
		{"Sad", "http://www.roblox.com/asset/?id=10714392876"},
		{"Greatest", "http://www.roblox.com/asset/?id=10714349037"},
		{"Sturdy Dance - Ice Spice", "http://www.roblox.com/asset/?id=17746180844"},
		{"Elton John - Heart Skip", "http://www.roblox.com/asset/?id=11309255148"},
		{"Paris Hilton - Iconic IT-Grrrl", "http://www.roblox.com/asset/?id=15392756794"},
		{"Fashion Roadkill", "http://www.roblox.com/asset/?id=136831243854748"},
		{"Nicki Minaj Starships", "http://www.roblox.com/asset/?id=15571453761"},
		{"TWICE LIKEY", "http://www.roblox.com/asset/?id=14899979575"},
		{"Nicki Minaj Boom Boom Boom", "http://www.roblox.com/asset/?id=15571448688"},
		{"Sol de Janeiro - Samba", "http://www.roblox.com/asset/?id=16270690701"},
		{"HUGO Lets Drive!", "http://www.roblox.com/asset/?id=17360699557"},
		{"Paris Hilton - Sliving For The Groove", "http://www.roblox.com/asset/?id=15392759696"},
		{"Tommy - Archer", "http://www.roblox.com/asset/?id=13823324057"},
		{"Beauty Touchdown", "http://www.roblox.com/asset/?id=16302968986"},
		{"Cower", "http://www.roblox.com/asset/?id=4940563117"},
		{"Happy", "http://www.roblox.com/asset/?id=10714352626"},
		{"Flex Walk", "http://www.roblox.com/asset/?id=15505459811"},
		{"Team USA Breaking Emote", "http://www.roblox.com/asset/?id=18526288497"},
		{"Zombie", "http://www.roblox.com/asset/?id=10714089137"},
		{"Olivia Rodrigo Fall Back to Float", "http://www.roblox.com/asset/?id=15549124879"},
		{"Stray Kids Walkin On Water", "http://www.roblox.com/asset/?id=125064469983655"},
		{"Haha", "http://www.roblox.com/asset/?id=10714350889"},
		{"Baby Queen - Air Guitar & Knee Slide", "http://www.roblox.com/asset/?id=14352335202"},
		{"Dizzy", "http://www.roblox.com/asset/?id=10714066964"},
		{"High Wave", "http://www.roblox.com/asset/?id=10714362852"},
		{"Beckon", "http://www.roblox.com/asset/?id=10713984554"},
		{"Show Dem Wrists - KSI", "http://www.roblox.com/asset/?id=10714377090"},
		{"Jumping Wave", "http://www.roblox.com/asset/?id=10714378156"},
		{"Baby Queen - Dramatic Bow", "http://www.roblox.com/asset/?id=14352337694"},
		{"Fast Hands", "http://www.roblox.com/asset/?id=10714100539"},
		{"Dolphin Dance", "http://www.roblox.com/asset/?id=10714068222"},
		{"Wake Up Call - KSI", "http://www.roblox.com/asset/?id=10714168145"},
		{"Jawny - Stomp", "http://www.roblox.com/asset/?id=16392075853"},
		{"Elton John - Rock Out", "http://www.roblox.com/asset/?id=11753474067"},
		{"Paris Hilton - Checking My Angles", "http://www.roblox.com/asset/?id=15392752812"},
		{"Power Blast", "http://www.roblox.com/asset/?id=10714389396"},
		{"Bodybuilder", "http://www.roblox.com/asset/?id=10713990381"},
		{"Line Dance", "http://www.roblox.com/asset/?id=10714383856"},
		{"Rock n Roll", "http://www.roblox.com/asset/?id=15505458452"},
		{"Agree", "http://www.roblox.com/asset/?id=10713954623"},
		{"Celebrate", "http://www.roblox.com/asset/?id=10714016223"},
		{"Mini Kong", "http://www.roblox.com/asset/?id=17000021306"},
		{"TMNT Dance", "http://www.roblox.com/asset/?id=18665811005"},
		{"ALTÉGO - Couldn’t Care Less", "http://www.roblox.com/asset/?id=107875941017127"},
		{"Rolling Stones Guitar Strum", "http://www.roblox.com/asset/?id=18148804340"},
		{"Rock Out - Bebe Rexha", "http://www.roblox.com/asset/?id=18225053113"},
		{"ericdoa - dance", "http://www.roblox.com/asset/?id=15698402762"},
		{"Confused", "http://www.roblox.com/asset/?id=4940561610"},
		{"Ay-Yo Dance Move - NCT 127", "http://www.roblox.com/asset/?id=12804157977"},
		{"Rock On", "http://www.roblox.com/asset/?id=10714403700"},
		{"Imagine Dragons - “Bones” Dance", "http://www.roblox.com/asset/?id=15689279687"},
		{"Mae Stephens – Arm Wave", "http://www.roblox.com/asset/?id=16584481352"},
		{"Uprise - Tommy Hilfiger", "http://www.roblox.com/asset/?id=10275008655"},
		{"Sidekicks - George Ezra", "http://www.roblox.com/asset/?id=10370362157"},
		{"Boxing Punch - KSI", "http://www.roblox.com/asset/?id=10717116749"},
		{"Fashionable", "http://www.roblox.com/asset/?id=10714091938"},
		{"Paris Hilton Sanasa", "http://www.roblox.com/asset/?id=16126469463"},
		{"Baby Dance", "http://www.roblox.com/asset/?id=10713983178"},
		{"Mean Girls Dance Break", "http://www.roblox.com/asset/?id=15963314052"},
		{"Samba", "http://www.roblox.com/asset/?id=10714386947"},
		{"NBA Monster Dunk", "http://www.roblox.com/asset/?id=132748833449150"},
	}

	local AnimationsDropdown = Tabs.Animations:AddDropdown("Dropdown", {
		Title = "Animations List",
		Values = {
			"",
			"Salute",
			"Applaud",
			"Tilt",
			"Baby Queen - Bouncy Twirl",
			"Yungblud Happier Jump",
			"Baby Queen - Face Frame",
			"Baby Queen - Strut",
			"KATSEYE - Touch",
			"Secret Handshake Dance",
			"Godlike",
			"Mae Stephens - Piano Hands",
			"Alo Yoga Pose - Lotus Position",
			"d4vd - Backflip",
			"Bored",
			"Cuco - Levitate",
			"Hero Landing",
			"Sleep",
			"Shrug",
			"Shy",
			"Festive Dance",
			"V Pose - Tommy Hilfiger",
			"Olivia Rodrigo Head Bop",
			"Elton John - Heart Shuffle",
			"Bone Chillin Bop",
			"Curtsy",
			"Floss Dance",
			"Hello",
			"Victory Dance",
			"Monkey",
			"TWICE Feel Special",
			"Point2",
			"Quiet Waves",
			"HIPMOTION - Amaarae",
			"Frosty Flair - Tommy Hilfiger",
			"Chappell Roan HOT TO GO!",
			"Stadium",
			"Skibidi Toilet - Titan Speakerman Laser Spin",
			"Sad",
			"Greatest",
			"Sturdy Dance - Ice Spice",
			"Elton John - Heart Skip",
			"Paris Hilton - Iconic IT-Grrrl",
			"Fashion Roadkill",
			"Nicki Minaj Starships",
			"TWICE LIKEY",
			"Nicki Minaj Boom Boom Boom",
			"Sol de Janeiro - Samba",
			"HUGO Lets Drive!",
			"Paris Hilton - Sliving For The Groove",
			"Tommy - Archer",
			"Beauty Touchdown",
			"Cower",
			"Happy",
			"Flex Walk",
			"Team USA Breaking Emote",
			"Zombie",
			"Olivia Rodrigo Fall Back to Float",
			"Stray Kids Walkin On Water",
			"Haha",
			"Baby Queen - Air Guitar & Knee Slide",
			"Dizzy",
			"High Wave",
			"Beckon",
			"Show Dem Wrists - KSI",
			"Jumping Wave",
			"Baby Queen - Dramatic Bow",
			"Fast Hands",
			"Dolphin Dance",
			"Wake Up Call - KSI",
			"Jawny - Stomp",
			"Elton John - Rock Out",
			"Paris Hilton - Checking My Angles",
			"Power Blast",
			"Bodybuilder",
			"Line Dance",
			"Rock n Roll",
			"Agree",
			"Celebrate",
			"Mini Kong",
			"TMNT Dance",
			"ALTÉGO - Couldn’t Care Less",
			"Rolling Stones Guitar Strum",
			"Rock Out - Bebe Rexha",
			"ericdoa - dance",
			"Confused",
			"Ay-Yo Dance Move - NCT 127",
			"Rock On",
			"Imagine Dragons - “Bones” Dance",
			"Mae Stephens – Arm Wave",
			"Uprise - Tommy Hilfiger",
			"Sidekicks - George Ezra",
			"Boxing Punch - KSI",
			"Fashionable",
			"Paris Hilton Sanasa",
			"Baby Dance",
			"Mean Girls Dance Break",
			"Samba",
			"NBA Monster Dunk"
		},
		Multi = false,
		Default = 1,
	})

	AnimationsDropdown:OnChanged(function(Value)
		local matchedId = ""

		for _,v in pairs(Animations) do
			if v[1] == Value then
				matchedId = v[2]
				break
			end
		end

		if matchedId ~= "" then
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

			if char then
				for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					track:Stop()
				end

				local animationNew = Instance.new("Animation")
				animationNew.AnimationId = matchedId
				local track = char.Humanoid:LoadAnimation(animationNew)
				track.Priority = Enum.AnimationPriority.Action
				track:Play()
			end
		end
	end)

	local AnimationSpeedSlider = Tabs.Animations:AddSlider("Slider", {
		Title = "Animation Speed",
		Description = "Set current animation speed",
		Default = 1,
		Min = 0,
		Max = 300,
		Rounding = 1,
		Callback = function(Value)
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

			if char and char:FindFirstChild("Humanoid") then
				local speed = tonumber(Value) or 1
				for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					track:AdjustSpeed(speed)
				end
			end
		end
	})

	FlyspeedSlider:OnChanged(function(Value)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		if char and char:FindFirstChild("Humanoid") then
			local speed = tonumber(Value) or 1
			for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
				track:AdjustSpeed(speed)
			end
		end
	end)

	Tabs.Animations:AddButton({
		Title = "Stop Animations",
		Description = "Force stop all animations",
		Callback = function()
			Window:Dialog({
				Title = "Animations",
				Content = "Are you sure you would like to force stop all animations?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

							if char then
								for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
									track:Stop()
								end
							end
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	-- exploits tab

	local exploitsData = {
		headSit = {
			enabled = false,
			target = nil
		},
		backPack = {
			enabled = false,
			target = nil
		}
	}

	local isHeadsitting = false
	local isBackpacking = false
	local weld = nil
	local sittingAnim = nil

	local function playSitAnimation()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		local sitAnim = Instance.new("Animation")
		sitAnim.AnimationId = "rbxassetid://2506281703"
		sittingAnim = hum:LoadAnimation(sitAnim)
		sittingAnim:Play()
	end

	local function stopSitting()
		if sittingAnim then
			sittingAnim:Stop()
			sittingAnim = nil
		end

		if weld then
			weld:Destroy()
			weld = nil
		end
	end

	local function sitOnBack(targetPlayer)
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local targetChar = targetPlayer.Character
		local targetTorso = targetChar and (targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso"))
		if not root or not targetTorso then return end

		root.CFrame = targetTorso.CFrame * CFrame.new(0, 1, 1) * CFrame.Angles(0, math.rad(180), 0)
		weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = targetTorso
		weld.Parent = root

		playSitAnimation()
	end

	_G.StopHeadsit = stopSitting

	local function sitOnHead(targetPlayer)
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local targetChar = targetPlayer.Character
		local targetHead = targetChar and targetChar:FindFirstChild("Head")
		if not root or not targetHead then return end

		root.CFrame = targetHead.CFrame * CFrame.new(0, 1.2, 0)
		weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = targetHead
		weld.Parent = root

		playSitAnimation()
	end

	game:GetService("RunService").RenderStepped:Connect(function()
		local headTarget = exploitsData.headSit.target
		local backTarget = exploitsData.backPack.target

		if exploitsData.headSit.enabled and headTarget then
			if not isHeadsitting then
				isHeadsitting = true
				isBackpacking = false
				sitOnHead(headTarget)
			end
		elseif exploitsData.backPack.enabled and backTarget then
			if not isBackpacking then
				isBackpacking = true
				isHeadsitting = false
				sitOnBack(backTarget)
			end
		else
			if isHeadsitting or isBackpacking then
				stopSitting()
				isHeadsitting = false
				isBackpacking = false
			end
		end
	end)

	local function setupProximityPrompt(stall)
		local ProximityPrompt = stall:FindFirstChild("Activate"):FindFirstChildOfClass("ProximityPrompt")
		if ProximityPrompt then
			ProximityPrompt.Enabled = true
			ProximityPrompt.ClickablePrompt = true
			ProximityPrompt.MaxActivationDistance = 15
			ProximityPrompt.RequiresLineOfSight = false
			ProximityPrompt.HoldDuration = 0
		end
	end

	local HeadSitInput = Tabs.Exploits:AddInput("Input", {
		Title = "Head Sit",
		Description = "Sit on a players head",
		Default = "",
		Placeholder = "Player",
		Numeric = false, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local player = getPlayer(Value)

			if player then
				exploitsData.headSit.enabled = true
				exploitsData.headSit.target = player
			end
		end
	})

	local HeadSitInput = Tabs.Exploits:AddInput("Input", {
		Title = "Back Pack",
		Description = "Sit on a players back",
		Default = "",
		Placeholder = "Player",
		Numeric = false, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local player = getPlayer(Value)

			if player then
				exploitsData.backPack.enabled = true
				exploitsData.backPack.target = player
			end
		end
	})

	Tabs.Exploits:AddButton({
		Title = "Headsit Connection",
		Description = "Force stop headsit connection",
		Callback = function()
			Window:Dialog({
				Title = "Connection",
				Content = "Are you sure you would like to force stop this connection?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							exploitsData.headSit.target = nil
							exploitsData.headSit.enabled = false
							if _G.StopHeadsit then _G.StopHeadsit() end
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Exploits:AddButton({
		Title = "Backpack Connection",
		Description = "Force stop backpack connection",
		Callback = function()
			Window:Dialog({
				Title = "Connection",
				Content = "Are you sure you would like to force stop this connection?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							exploitsData.backPack.target = nil
							exploitsData.backPack.enabled = false
							if _G.StopHeadsit then _G.StopHeadsit() end
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	local BoothSnatchInput = Tabs.Exploits:AddInput("Input", {
		Title = "Unclaim a booth",
		Description = "Steal a players booth",
		Default = "",
		Placeholder = "Player",
		Numeric = false, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local Folder = workspace.Booth
			local getPlayer = getPlayer(Value)

			if getPlayer == LocalPlayer then
				return game.ReplicatedStorage:WaitForChild("DeleteBoothOwnership"):FireServer()
			end

			if not getPlayer then
				return 
			end

			local function getStall()
				for i,v in pairs(workspace.Booth:GetChildren()) do
					if v ~= LocalPlayer and v:FindFirstChild("Username"):FindFirstChild("BillboardGui").TextLabel.Text == "Owned by: "..tostring(getPlayer) then
						return v
					end
				end
				return nil
			end

			local plr_booth = getStall()

			if not plr_booth and getPlayer then
				return
			end

			local Folder = workspace.Booth
			local OldCF = LocalPlayer.Character.HumanoidRootPart.CFrame

			local stalls = {
				Folder:FindFirstChild("Booth01"),
				Folder:FindFirstChild("Booth02"),
				Folder:FindFirstChild("Booth03"),
				Folder:FindFirstChild("Booth04"),
				Folder:FindFirstChild("Booth05")
			}

			local function setupProximityPrompt(stall)
				local ProximityPrompt = stall:FindFirstChild("Activate"):FindFirstChildOfClass("ProximityPrompt")
				if ProximityPrompt and not ProximityPrompt.Enabled then
					ProximityPrompt.Enabled = true
					ProximityPrompt.ClickablePrompt = true
					ProximityPrompt.MaxActivationDistance = 15
					ProximityPrompt.RequiresLineOfSight = false
					ProximityPrompt.HoldDuration = 0
				end
			end

			local function Claim_A_Booth()
				local OldCF = LocalPlayer.Character.HumanoidRootPart.CFrame

				local stall = plr_booth
				local ProximityPrompt = stall:FindFirstChild("Activate"):FindFirstChildOfClass("ProximityPrompt")

				if stall then
					setupProximityPrompt(stall)
					LocalPlayer.Character:PivotTo(stall:GetPivot())
					task.wait(0.3)
					fireproximityprompt(ProximityPrompt)
					local args = {
						[1] = "",
						[2] = "Gray",
						[3] = "SourceSans"
					}

					game.ReplicatedStorage:WaitForChild("UpdateBoothText"):FireServer(unpack(args))
					game.ReplicatedStorage:WaitForChild("DeleteBoothOwnership"):FireServer()
					LocalPlayer.Character:SetPrimaryPartCFrame(OldCF)

					if plr_booth then
						return 
					end
				end
			end

			local stall = plr_booth
			setupProximityPrompt(stall)
			wait(0.3)
			Claim_A_Booth()
		end
	})

	-- lighting tab

	Tabs.Lighting:AddButton({
		Title = "RTX Lighting",
		Description = "Load preset in lighting",
		Callback = function()
			Window:Dialog({
				Title = "Lighting Preset",
				Content = "Are you sure you would like to alter your lighting settings? This may cause performance issues.",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local Lighting = game:GetService("Lighting")
							local StarterGui = game:GetService("StarterGui")
							local Bloom = Instance.new("BloomEffect")
							local Blur = Instance.new("BlurEffect")
							local ColorCor = Instance.new("ColorCorrectionEffect")
							local SunRays = Instance.new("SunRaysEffect")
							local Sky = Instance.new("Sky")
							local Atm = Instance.new("Atmosphere")

							for i, v in pairs(Lighting:GetChildren()) do
								if v then
									v:Destroy()
								end
							end

							Bloom.Parent = Lighting
							Blur.Parent = Lighting
							ColorCor.Parent = Lighting
							SunRays.Parent = Lighting
							Sky.Parent = Lighting
							Atm.Parent = Lighting

							Bloom.Intensity = 0.3
							Bloom.Size = 10
							Bloom.Threshold = 0.8

							Blur.Size = 5

							ColorCor.Brightness = 0.1
							ColorCor.Contrast = 0.5
							ColorCor.Saturation = -0.3
							ColorCor.TintColor = Color3.fromRGB(255, 235, 203)

							SunRays.Intensity = 0.075
							SunRays.Spread = 0.727

							Sky.SkyboxBk = "http://www.roblox.com/asset/?id=151165214"
							Sky.SkyboxDn = "http://www.roblox.com/asset/?id=151165197"
							Sky.SkyboxFt = "http://www.roblox.com/asset/?id=151165224"
							Sky.SkyboxLf = "http://www.roblox.com/asset/?id=151165191"
							Sky.SkyboxRt = "http://www.roblox.com/asset/?id=151165206"
							Sky.SkyboxUp = "http://www.roblox.com/asset/?id=151165227"
							Sky.SunAngularSize = 10

							Lighting.Ambient = Color3.fromRGB(2,2,2)
							Lighting.Brightness = 2.25
							Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
							Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
							Lighting.EnvironmentDiffuseScale = 0.2
							Lighting.EnvironmentSpecularScale = 0.2
							Lighting.GlobalShadows = true
							Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
							Lighting.ShadowSoftness = 0.2
							Lighting.ClockTime = 7
							Lighting.GeographicLatitude = 25
							Lighting.ExposureCompensation = 0.5

							Atm.Density = 0
							Atm.Offset = 0.556
							Atm.Color = Color3.fromRGB(0, 0, 0)
							Atm.Decay = Color3.fromRGB(0, 0, 0)
							Atm.Glare = 0
							Atm.Haze = 1.72
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	Tabs.Lighting:AddButton({
		Title = "Advanced Lighting",
		Description = "Load preset in lighting",
		Callback = function()
			Window:Dialog({
				Title = "Lighting Preset",
				Content = "Are you sure you would like to alter your lighting settings? This may cause performance issues.",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local Lighting = game:GetService("Lighting")
							local Sky = Instance.new("Sky")
							local Bloom = Instance.new("BloomEffect")
							local ColorC = Instance.new("ColorCorrectionEffect")
							local SunRays = Instance.new("SunRaysEffect")

							for i, v in pairs(Lighting:GetChildren()) do
								if v then
									v:Destroy()
								end
							end

							Sky.MoonAngularSize = 11
							Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
							Sky.SkyboxBk = "rbxassetid://17843929750"
							Sky.SkyboxDn = "rbxassetid://17843931996"
							Sky.SkyboxFt = "rbxassetid://17843931265"
							Sky.SkyboxLf = "rbxassetid://17843929139"
							Sky.SkyboxRt = "rbxassetid://17843930617"
							Sky.SkyboxUp = "rbxassetid://17843932671"
							Sky.StarCount = 3000
							Sky.SunAngularSize = 21
							Sky.SunTextureId = "rbxasset://sky/sun.jpg"

							Bloom.Enabled = true
							Bloom.Intensity = 0.65
							Bloom.Size = 8
							Bloom.Threshold = 0.9

							ColorC.Brightness = 0
							ColorC.Contrast = 0.05
							ColorC.Enabled = true
							ColorC.Saturation = 0.2
							ColorC.TintColor = Color3.new(1, 1, 1)

							SunRays.Intensity = 0.25
							SunRays.Spread = 1
							SunRays.Enabled = true

							Sky.Parent = Lighting
							Bloom.Parent = Lighting
							ColorC.Parent = Lighting
							SunRays.Parent = Lighting

							Lighting.Brightness = 1.43
							Lighting.Ambient = Color3.new(0.243137, 0.243137, 0.243137)
							Lighting.ShadowSoftness = 0.4
							Lighting.ClockTime = 13.4
							Lighting.OutdoorAmbient = Color3.new	(0.243137, 0.243137, 0.243137)

							if Lighting.GlobalShadows == false then
								Lighting.GlobalShadows = true
							end
						end
					},
					{
						Title = "Cancel",
						Callback = function() 

						end
					}
				}
			})
		end
	})

	-- exclusives tab

	Tabs.Exclusive:AddParagraph({
		Title = "Whoops!",
		Content = "It appears you do not yet have permissions to view this page, sorry.."
	})

	-- beta tab

	Tabs.Beta:AddParagraph({
		Title = "Whoops!",
		Content = "It appears you do not yet have permissions to view this page, sorry.."
	})

	--Dropdown:SetValue("four")

	--[[Dropdown:OnChanged(function(Value)
		print("Dropdown changed:", Value)
	end)]]

	--[[local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
		Title = "Dropdown",
		Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
		Multi = false,
		Default = 1,
	})]]

	--Dropdown:SetValue("four")

	--[[Dropdown:OnChanged(function(Value)
		print("Dropdown changed:", Value)
	end)]]



	--[[local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
		Title = "Dropdown",
		Description = "You can select multiple values.",
		Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
		Multi = true,
		Default = {"seven", "twelve"},
	})

	MultiDropdown:SetValue({
		three = true,
		five = true,
		seven = false
	})

	MultiDropdown:OnChanged(function(Value)
		local Values = {}
		for Value, State in next, Value do
			table.insert(Values, Value)
		end
		print("Mutlidropdown changed:", table.concat(Values, ", "))
	end)]]

	--[[local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
		Title = "Colorpicker",
		Description = "but you can change the transparency.",
		Transparency = 0,
		Default = Color3.fromRGB(96, 205, 255)
	})

	TColorpicker:OnChanged(function()
		print(
			"TColorpicker changed:", TColorpicker.Value,
			"Transparency:", TColorpicker.Transparency
		)
	end)

	-- OnClick is only fired when you press the keybind and the mode is Toggle
	-- Otherwise, you will have to use Keybind:GetState()
	Keybind:OnClick(function()
		print("Keybind clicked:", Keybind:GetState())
	end)

	Keybind:OnChanged(function()
		print("Keybind changed:", Keybind.Value)
	end)

	task.spawn(function()
		while true do
			wait(1)

			-- example for checking if a keybind is being pressed
			local state = Keybind:GetState()
			if state then
				print("Keybind is being held down")
			end

			if Fluent.Unloaded then break end
		end
	end)

	Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


	local Input = Tabs.Main:AddInput("Input", {
		Title = "Input",
		Default = "Default",
		Placeholder = "Placeholder",
		Numeric = false, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(Value)
			print("Input changed:", Value)
		end
	})

	Input:OnChanged(function()
		print("Input updated:", Input.Value)
	end)]]
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
	Title = "Baseplate Warning",
	Content = "The baseplate does not load automatically, check the main panel if you wish to enable this.",
	Duration = 8
})

Fluent:Notify({
	Title = "Gold's Easy Hub",
	Content = "Our system has loaded successfully, attempting to send webhook data...",
	Duration = 8
})

local function headtag(plr)
	local groupId = 0
	local classAccess = "Unknown"
	local tagColor = Color3.new(1, 1, 1) -- default white color

	local permissions = {
		owners = {
			"starsorbitspace",
			"lvasion"
		},
		developers = {
			"BOL012307",
		},
		staff = {
			"Goodhelper12345",
			"Sophieloveuu",
			"auralinker",
			"bliblu1099",
			"bliblu10999",
			"prfctz",
			"kursedmes",
			"ToshiroHina",
			"captainalex1678",
			"kittycatmad0",
			"SlayersXoff",
			"gigaultw",
			"dq_bh",
			"devTWTCHGR"
		},
		contributors = {
			"ikDebris",
			"NitroNukexYT",
			"restaxts"
		},
		customTags = {
			{"lvasion", Color3.new(1, 0.666667, 1), "Head Developer"},
		}
	}

	local function isInList(list, name)
		for _, v in ipairs(list) do
			if v == name then
				return true
			end
		end
		return false
	end

	local function getCustomTag(name)
		for _, tag in ipairs(permissions.customTags) do
			if tag[1] == name then
				return tag
			end
		end
		return nil
	end

	if plr:IsInGroup(groupId) then
		classAccess = "Script User"
	end

	if isInList(permissions.owners, plr.Name) then
		classAccess = "Owner"
		tagColor = Color3.fromRGB(255, 85, 85)
	elseif isInList(permissions.developers, plr.Name) then
		classAccess = "Developer"
		tagColor = Color3.fromRGB(255, 170, 0)
	elseif isInList(permissions.staff, plr.Name) then
		classAccess = "Staff"
		tagColor = Color3.fromRGB(0, 170, 255)
	elseif isInList(permissions.contributors, plr.Name) then
		classAccess = "Contributor"
		tagColor = Color3.fromRGB(170, 0, 255)
	end

	local customTag = getCustomTag(plr.Name)
	if customTag then
		tagColor = customTag[2]
		classAccess = customTag[3]
	end

	local char = plr.Character or plr.CharacterAdded:Wait()
	local head = char:FindFirstChild("Head")
	if not head then
		head = char:WaitForChild("Head", 5)
		if not head then return end
	end

	if head:FindFirstChild("NameTag") then
		head:FindFirstChild("NameTag"):Destroy()
	end

	if classAccess == "Unknown" then
		return
	end

	local Rank = Instance.new("BillboardGui")
	local Frame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local Name1 = Instance.new("TextLabel")
	local UICorner = Instance.new("UICorner")
	local UIPadding = Instance.new("UIPadding")
	local UIStroke = Instance.new("UIStroke")

	Rank.Name = "Rank"
	Rank.Parent = head
	Rank.Active = true
	Rank.Size = UDim2.new(4, 0, 1, 0)
	Rank.StudsOffset = Vector3.new(0, 2, 0)

	Frame.Parent = Rank
	Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Frame.BackgroundTransparency = 1.000
	Frame.BorderColor3 = Color3.fromRGB(31, 31, 31)
	Frame.BorderSizePixel = 5
	Frame.Position = UDim2.new(0.100000001, 0, 0, 0)
	Frame.Size = UDim2.new(1, 0, 0.5, 0)
	Frame.ZIndex = 2

	UIListLayout.Parent = Frame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	Name1.Name = "Name1"
	Name1.Parent = Frame
	Name1.Active = true
	Name1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Name1.BorderColor3 = tagColor
	Name1.BorderSizePixel = 0
	Name1.Size = UDim2.new(0.699999988, 0, 1, 0)
	Name1.Font = Enum.Font.Unknown
	Name1.Text = classAccess
	Name1.TextColor3 = tagColor
	Name1.TextScaled = true
	Name1.TextSize = 28.000
	Name1.TextStrokeColor3 = tagColor
	Name1.TextWrapped = true

	UICorner.CornerRadius = UDim.new(0.200000003, 0)
	UICorner.Parent = Name1

	UIPadding.Parent = Name1
	UIPadding.PaddingBottom = UDim.new(0.150000006, 0)
	UIPadding.PaddingTop = UDim.new(0.150000006, 0)

	UIStroke.Parent = Name1
	UIStroke.Thickness = 1
	UIStroke.Color = tagColor
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local Players = game:GetService("Players")

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		headtag(player)
	end)

	if player.Character then
		task.spawn(function()
			task.wait(1)
			headtag(player)
		end)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

SaveManager:LoadAutoloadConfig()

--RELOAD GUI
if game.CoreGui:FindFirstChild("SysBroker") then
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = "System Broken",Text = "GUI Already loaded, rejoin to re-execute",Duration = 5;})
	return
end
local version = 2
--VARIABLES
_G.AntiFlingToggled = false
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Light = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local mouse = plr:GetMouse()
local ScriptWhitelist = {}
local ForceWhitelist = {}
local TargetedPlayer = nil
local FlySpeed = 50
local PotionTool = nil
local SavedCheckpoint = nil
local MinesFolder = nil
local FreeEmotesEnabled = false
local CannonsFolders = {}

pcall(function()
	MinesFolder = game:GetService("Workspace").Landmines
	for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
		if v.Name == "Cannons" then
			table.insert(CannonsFolders, v)
		end
	end
end)
--FUNCTIONS
_G.shield = function(id)
	if not table.find(ForceWhitelist,id) then
		table.insert(ForceWhitelist, id)
	end
end

local function RandomChar()
	local length = math.random(1,5)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local function ChangeToggleColor(Button)
	led = Button.Ticket_Asset
	if led.ImageColor3 == Color3.fromRGB(255, 0, 0) then
		led.ImageColor3 = Color3.fromRGB(0, 255, 0)
	else
		led.ImageColor3 = Color3.fromRGB(255, 0, 0)
	end
end

local function GetPing()
	return (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())/1000
end

local function GetPlayer(UserDisplay)
	if UserDisplay ~= "" then
        for i,v in pairs(Players:GetPlayers()) do
            if v.Name:lower():match(UserDisplay) or v.DisplayName:lower():match(UserDisplay) then
                return v
            end
        end
		return nil
	else
		return nil
    end
end

local function GetCharacter(Player)
	if Player.Character then
		return Player.Character
	end
end

local function GetRoot(Player)
	if GetCharacter(Player):FindFirstChild("HumanoidRootPart") then
		return GetCharacter(Player).HumanoidRootPart
	end
end

local function TeleportTO(posX,posY,posZ,player,method)
	pcall(function()
		if method == "safe" then
			task.spawn(function()
				for i = 1,30 do
					task.wait()
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
					if player == "pos" then
						GetRoot(plr).CFrame = CFrame.new(posX,posY,posZ)
					else
						GetRoot(plr).CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0)
					end
				end
			end)
		else
			GetRoot(plr).Velocity = Vector3.new(0,0,0)
			if player == "pos" then
				GetRoot(plr).CFrame = CFrame.new(posX,posY,posZ)
			else
				GetRoot(plr).CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0)
			end
		end
	end)
end

local function PredictionTP(player,method)
	local root = GetRoot(player)
	local pos = root.Position
	local vel = root.Velocity
	GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
	if method == "safe" then
		task.wait()
		GetRoot(plr).CFrame = CFrame.new(pos)
		task.wait()
		GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
	end
end

local function Touch(x,root)
	pcall(function()
		x = x:FindFirstAncestorWhichIsA("Part")
		if x then
			if firetouchinterest then
				task.spawn(function()
					firetouchinterest(x, root, 1)
					task.wait()
					firetouchinterest(x, root, 0)
				end)
			end
		end
	end)
end


local function GetPush()
	local TempPush = nil
	pcall(function()
		if plr.Backpack:FindFirstChild("Push") then
			PushTool = plr.Backpack.Push
			PushTool.Parent = plr.Character
			TempPush = PushTool
		end
		for i,v in pairs(Players:GetPlayers()) do
			if v.Character:FindFirstChild("Push") then
				TempPush = v.Character.Push
			end
		end
	end)
	return TempPush
end

local function CheckPotion()
	if plr.Backpack:FindFirstChild("potion") then
		PotionTool = plr.Backpack:FindFirstChild("potion")
		return true
	elseif plr.Character:FindFirstChild("potion") then
		PotionTool = plr.Character:FindFirstChild("potion")
		return true
	else
		return false
	end
end

local function Push(Target)
	local Push = GetPush()
	local FixTool = nil
	if Push ~= nil then
		local args = {[1] = Target.Character}
		GetPush().PushTool:FireServer(unpack(args))
	end
	if plr.Character:FindFirstChild("Push") then
		plr.Character.Push.Parent = plr.Backpack
	end
	if plr.Character:FindFirstChild("ModdedPush") then
		FixTool = plr.Character:FindFirstChild("ModdedPush")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
	if plr.Character:FindFirstChild("ClickTarget") then
		FixTool = plr.Character:FindFirstChild("ClickTarget")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
	if plr.Character:FindFirstChild("potion") then
		FixTool = plr.Character:FindFirstChild("potion")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
end

local function ToggleRagdoll(bool)
	pcall(function()
		plr.Character["Falling down"].Disabled = bool
		plr.Character["Swimming"].Disabled = bool
		plr.Character["StartRagdoll"].Disabled = bool
		plr.Character["Pushed"].Disabled = bool
		plr.Character["RagdollMe"].Disabled = bool
	end)
end

local function ToggleVoidProtection(bool)
	if bool then
		game.Workspace.FallenPartsDestroyHeight = 0/0
	else
		game.Workspace.FallenPartsDestroyHeight = -500
	end
end

local function PlayAnim(id,time,speed)
	pcall(function()
		plr.Character.Animate.Disabled = false
		local hum = plr.Character.Humanoid
		local animtrack = hum:GetPlayingAnimationTracks()
		for i,track in pairs(animtrack) do
			track:Stop()
		end
		plr.Character.Animate.Disabled = true
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..id
		local loadanim = hum:LoadAnimation(Anim)
		loadanim:Play()
		loadanim.TimePosition = time
		loadanim:AdjustSpeed(speed)
		loadanim.Stopped:Connect(function()
			plr.Character.Animate.Disabled = false
			for i, track in pairs (animtrack) do
        		track:Stop()
    		end
		end)
	end)
end

local function StopAnim()
	plr.Character.Animate.Disabled = false
    local animtrack = plr.Character.Humanoid:GetPlayingAnimationTracks()
    for i, track in pairs (animtrack) do
        track:Stop()
    end
end

local function SendNotify(title, message, duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = title,Text = message,Duration = duration;})
end

--LOAD GUI
task.wait(0.1)
local SysBroker = Instance.new("ScreenGui")
local Background = Instance.new("ImageLabel")
local TitleBarLabel = Instance.new("TextLabel")
local SectionList = Instance.new("Frame")
local Home_Section_Button = Instance.new("TextButton")
local Game_Section_Button = Instance.new("TextButton")
local Character_Section_Button = Instance.new("TextButton")
local Target_Section_Button = Instance.new("TextButton")
local Animations_Section_Button = Instance.new("TextButton")
local Misc_Section_Button = Instance.new("TextButton")
local Credits_Section_Button = Instance.new("TextButton")
local Game_Section = Instance.new("ScrollingFrame")
local AntiRagdoll_Button = Instance.new("TextButton")
local PotionFling_Button = Instance.new("TextButton")
local SpamMines_Button = Instance.new("TextButton")
local PushAura_Button = Instance.new("TextButton")
local BreakCannons_Button = Instance.new("TextButton")
local LethalCannons_Button = Instance.new("TextButton")
local ChatAlert_Button = Instance.new("TextButton")
local PotionDi_Button = Instance.new("TextButton")
local VoidProtection_Button = Instance.new("TextButton")
local PushAll_Button = Instance.new("TextButton")
local TouchFling_Button = Instance.new("TextButton")
local CMDBar = Instance.new("TextBox")
local CannonTP1_Button = Instance.new("TextButton")
local CannonTP2_Button = Instance.new("TextButton")
local CannonTP3_Button = Instance.new("TextButton")
local MinefieldTP_Button = Instance.new("TextButton")
local BallonTP_Button = Instance.new("TextButton")
local NormalStairsTP_Button = Instance.new("TextButton")
local MovingStairsTP_Button = Instance.new("TextButton")
local SpiralStairsTP_Button = Instance.new("TextButton")
local SkyscraperTP_Button = Instance.new("TextButton")
local PoolTP_Button = Instance.new("TextButton")
local FreePushTool_Button = Instance.new("TextButton")
local Home_Section = Instance.new("ScrollingFrame")
local Profile_Image = Instance.new("ImageLabel")
local Welcome_Label = Instance.new("TextLabel")
local Announce_Label = Instance.new("TextLabel")
local Character_Section = Instance.new("ScrollingFrame")
local WalkSpeed_Button = Instance.new("TextButton")
local WalkSpeed_Input = Instance.new("TextBox")
local ClearCheckpoint_Button = Instance.new("TextButton")
local JumpPower_Input = Instance.new("TextBox")
local JumpPower_Button = Instance.new("TextButton")
local SaveCheckpoint_Button = Instance.new("TextButton")
local Respawn_Button = Instance.new("TextButton")
local FlySpeed_Button = Instance.new("TextButton")
local FlySpeed_Input = Instance.new("TextBox")
local Fly_Button = Instance.new("TextButton")
local Target_Section = Instance.new("ScrollingFrame")
local TargetImage = Instance.new("ImageLabel")
local ClickTargetTool_Button = Instance.new("ImageButton")
local TargetName_Input = Instance.new("TextBox")
local UserIDTargetLabel = Instance.new("TextLabel")
local ViewTarget_Button = Instance.new("TextButton")
local FlingTarget_Button = Instance.new("TextButton")
local FocusTarget_Button = Instance.new("TextButton")
local BenxTarget_Button = Instance.new("TextButton")
local PushTarget_Button = Instance.new("TextButton")
local WhitelistTarget_Button = Instance.new("TextButton")
local TeleportTarget_Button = Instance.new("TextButton")
local HeadsitTarget_Button = Instance.new("TextButton")
local StandTarget_Button = Instance.new("TextButton")
local BackpackTarget_Button = Instance.new("TextButton")
local DoggyTarget_Button = Instance.new("TextButton")
local DragTarget_Button = Instance.new("TextButton")
local Animations_Section = Instance.new("ScrollingFrame")
local VampireAnim_Button = Instance.new("TextButton")
local HeroAnim_Button = Instance.new("TextButton")
local ZombieClassicAnim_Button = Instance.new("TextButton")
local MageAnim_Button = Instance.new("TextButton")
local GhostAnim_Button = Instance.new("TextButton")
local ElderAnim_Button = Instance.new("TextButton")
local LevitationAnim_Button = Instance.new("TextButton")
local AstronautAnim_Button = Instance.new("TextButton")
local NinjaAnim_Button = Instance.new("TextButton")
local WerewolfAnim_Button = Instance.new("TextButton")
local CartoonAnim_Button = Instance.new("TextButton")
local PirateAnim_Button = Instance.new("TextButton")
local SneakyAnim_Button = Instance.new("TextButton")
local ToyAnim_Button = Instance.new("TextButton")
local KnightAnim_Button = Instance.new("TextButton")
--NEWS
local ConfidentAnim_Button = Instance.new("TextButton")
local PopstarAnim_Button = Instance.new("TextButton")
local PrincessAnim_Button = Instance.new("TextButton")
local CowboyAnim_Button = Instance.new("TextButton")
local PatrolAnim_Button = Instance.new("TextButton")
local ZombieFEAnim_Button = Instance.new("TextButton")
--NEWS
local Misc_Section = Instance.new("ScrollingFrame")
local AntiFling_Button = Instance.new("TextButton")
local AntiChatSpy_Button = Instance.new("TextButton")
local AntiAFK_Button = Instance.new("TextButton")
local Shaders_Button = Instance.new("TextButton")
local Day_Button = Instance.new("TextButton")
local Night_Button = Instance.new("TextButton")
local Rejoin_Button = Instance.new("TextButton")
local CMDX_Button = Instance.new("TextButton")
local InfYield_Button = Instance.new("TextButton")
local Serverhop_Button = Instance.new("TextButton")
local Explode_Button = Instance.new("TextButton")
local FreeEmotes_Button = Instance.new("TextButton")
local ChatBox_Input = Instance.new("TextBox")
local Credits_Section = Instance.new("ScrollingFrame")
local Credits_Label = Instance.new("TextLabel")
local Crown = Instance.new("ImageLabel")
local Assets = Instance.new("Folder")
local Ticket_Asset = Instance.new("ImageButton")
local Click_Asset = Instance.new("ImageButton")
local Velocity_Asset = Instance.new("BodyAngularVelocity")
local Fly_Pad = Instance.new("ImageButton")
local UIGradient = Instance.new("UIGradient")
local FlyAButton = Instance.new("TextButton")
local FlyDButton = Instance.new("TextButton")
local FlyWButton = Instance.new("TextButton")
local FlySButton = Instance.new("TextButton")
local OpenClose = Instance.new("ImageButton")
local UICornerOC = Instance.new("UICorner")

local function CreateToggle(Button)
	local NewToggle = Ticket_Asset:Clone()
	NewToggle.Parent = Button
end

local function CreateClicker(Button)
	local NewClicker = Click_Asset:Clone()
	NewClicker.Parent = Button
end

SysBroker.Name = "SysBroker"
SysBroker.Parent = game.CoreGui
SysBroker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background.Name = "Background"
Background.Parent = SysBroker
Background.AnchorPoint = Vector2.new(0.5, 0.5)
Background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Background.BorderColor3 = Color3.fromRGB(0, 255, 255)
Background.Position = UDim2.new(0.5, 0, 0.5, 0)
Background.Size = UDim2.new(0, 500, 0, 350)
Background.ZIndex = 9
Background.Image = "rbxassetid://159991693"
Background.ImageColor3 = Color3.fromRGB(0, 255, 255)
Background.ImageTransparency = 0.600
Background.ScaleType = Enum.ScaleType.Tile
Background.SliceCenter = Rect.new(0, 256, 0, 256)
Background.TileSize = UDim2.new(0, 30, 0, 30)
Background.Active = true
Background.Draggable = true

TitleBarLabel.Name = "TitleBarLabel"
TitleBarLabel.Parent = Background
TitleBarLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBarLabel.BackgroundTransparency = 0.250
TitleBarLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TitleBarLabel.BorderSizePixel = 0
TitleBarLabel.Size = UDim2.new(1, 0, 0, 30)
TitleBarLabel.Font = Enum.Font.Unknown
TitleBarLabel.Text = "____/SYSTEMBROKEN\\___"
TitleBarLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleBarLabel.TextScaled = true
TitleBarLabel.TextSize = 14.000
TitleBarLabel.TextWrapped = true
TitleBarLabel.TextXAlignment = Enum.TextXAlignment.Left

SectionList.Name = "SectionList"
SectionList.Parent = Background
SectionList.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SectionList.BackgroundTransparency = 0.500
SectionList.BorderColor3 = Color3.fromRGB(0, 0, 0)
SectionList.BorderSizePixel = 0
SectionList.Position = UDim2.new(0, 0, 0, 30)
SectionList.Size = UDim2.new(0, 105, 0, 320)

Home_Section_Button.Name = "Home_Section_Button"
Home_Section_Button.Parent = SectionList
Home_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Home_Section_Button.BackgroundTransparency = 0.500
Home_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Home_Section_Button.BorderSizePixel = 0
Home_Section_Button.Position = UDim2.new(0, 0, 0, 25)
Home_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Home_Section_Button.Font = Enum.Font.Oswald
Home_Section_Button.Text = "Home"
Home_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Home_Section_Button.TextScaled = true
Home_Section_Button.TextSize = 14.000
Home_Section_Button.TextWrapped = true

Game_Section_Button.Name = "Game_Section_Button"
Game_Section_Button.Parent = SectionList
Game_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Game_Section_Button.BackgroundTransparency = 0.500
Game_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Game_Section_Button.BorderSizePixel = 0
Game_Section_Button.Position = UDim2.new(0, 0, 0, 65)
Game_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Game_Section_Button.Font = Enum.Font.Oswald
Game_Section_Button.Text = "Game"
Game_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Game_Section_Button.TextScaled = true
Game_Section_Button.TextSize = 14.000
Game_Section_Button.TextWrapped = true

Character_Section_Button.Name = "Character_Section_Button"
Character_Section_Button.Parent = SectionList
Character_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Character_Section_Button.BackgroundTransparency = 0.500
Character_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Character_Section_Button.BorderSizePixel = 0
Character_Section_Button.Position = UDim2.new(0, 0, 0, 105)
Character_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Character_Section_Button.Font = Enum.Font.Oswald
Character_Section_Button.Text = "Character"
Character_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Character_Section_Button.TextScaled = true
Character_Section_Button.TextSize = 14.000
Character_Section_Button.TextWrapped = true

Target_Section_Button.Name = "Target_Section_Button"
Target_Section_Button.Parent = SectionList
Target_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Target_Section_Button.BackgroundTransparency = 0.500
Target_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Target_Section_Button.BorderSizePixel = 0
Target_Section_Button.Position = UDim2.new(0, 0, 0, 145)
Target_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Target_Section_Button.Font = Enum.Font.Oswald
Target_Section_Button.Text = "Target"
Target_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Target_Section_Button.TextScaled = true
Target_Section_Button.TextSize = 14.000
Target_Section_Button.TextWrapped = true

Animations_Section_Button.Name = "Animations_Section_Button"
Animations_Section_Button.Parent = SectionList
Animations_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Animations_Section_Button.BackgroundTransparency = 0.500
Animations_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Animations_Section_Button.BorderSizePixel = 0
Animations_Section_Button.Position = UDim2.new(0, 0, 0, 185)
Animations_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Animations_Section_Button.Font = Enum.Font.Oswald
Animations_Section_Button.Text = "Animations"
Animations_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Animations_Section_Button.TextScaled = true
Animations_Section_Button.TextSize = 14.000
Animations_Section_Button.TextWrapped = true

Misc_Section_Button.Name = "Misc_Section_Button"
Misc_Section_Button.Parent = SectionList
Misc_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Misc_Section_Button.BackgroundTransparency = 0.500
Misc_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Misc_Section_Button.BorderSizePixel = 0
Misc_Section_Button.Position = UDim2.new(0, 0, 0, 225)
Misc_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Misc_Section_Button.Font = Enum.Font.Oswald
Misc_Section_Button.Text = "Misc"
Misc_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Misc_Section_Button.TextScaled = true
Misc_Section_Button.TextSize = 14.000
Misc_Section_Button.TextWrapped = true

Credits_Section_Button.Name = "Credits_Section_Button"
Credits_Section_Button.Parent = SectionList
Credits_Section_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Credits_Section_Button.BackgroundTransparency = 0.500
Credits_Section_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Credits_Section_Button.BorderSizePixel = 0
Credits_Section_Button.Position = UDim2.new(0, 0, 0, 265)
Credits_Section_Button.Size = UDim2.new(0, 105, 0, 30)
Credits_Section_Button.Font = Enum.Font.Oswald
Credits_Section_Button.Text = "Credits"
Credits_Section_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Credits_Section_Button.TextScaled = true
Credits_Section_Button.TextSize = 14.000
Credits_Section_Button.TextWrapped = true

Game_Section.Name = "Game_Section"
Game_Section.Parent = Background
Game_Section.Active = true
Game_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Game_Section.BackgroundTransparency = 1.000
Game_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Game_Section.BorderSizePixel = 0
Game_Section.Position = UDim2.new(0, 105, 0, 30)
Game_Section.Size = UDim2.new(0, 395, 0, 320)
Game_Section.Visible = false
Game_Section.CanvasSize = UDim2.new(0, 0, 1.85, 0)
Game_Section.ScrollBarThickness = 5

AntiRagdoll_Button.Name = "AntiRagdoll_Button"
AntiRagdoll_Button.Parent = Game_Section
AntiRagdoll_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
AntiRagdoll_Button.BackgroundTransparency = 0.500
AntiRagdoll_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
AntiRagdoll_Button.BorderSizePixel = 0
AntiRagdoll_Button.Position = UDim2.new(0, 25, 0, 25)
AntiRagdoll_Button.Size = UDim2.new(0, 150, 0, 30)
AntiRagdoll_Button.Font = Enum.Font.Oswald
AntiRagdoll_Button.Text = "Anti ragdoll"
AntiRagdoll_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiRagdoll_Button.TextScaled = true
AntiRagdoll_Button.TextSize = 14.000
AntiRagdoll_Button.TextWrapped = true

PotionFling_Button.Name = "PotionFling_Button"
PotionFling_Button.Parent = Game_Section
PotionFling_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PotionFling_Button.BackgroundTransparency = 0.500
PotionFling_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PotionFling_Button.BorderSizePixel = 0
PotionFling_Button.Position = UDim2.new(0, 210, 0, 75)
PotionFling_Button.Size = UDim2.new(0, 150, 0, 30)
PotionFling_Button.Font = Enum.Font.Oswald
PotionFling_Button.Text = "Potion Fling"
PotionFling_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PotionFling_Button.TextScaled = true
PotionFling_Button.TextSize = 14.000
PotionFling_Button.TextWrapped = true

SpamMines_Button.Name = "SpamMines_Button"
SpamMines_Button.Parent = Game_Section
SpamMines_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SpamMines_Button.BackgroundTransparency = 0.500
SpamMines_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpamMines_Button.BorderSizePixel = 0
SpamMines_Button.Position = UDim2.new(0, 25, 0, 75)
SpamMines_Button.Size = UDim2.new(0, 150, 0, 30)
SpamMines_Button.Font = Enum.Font.Oswald
SpamMines_Button.Text = "Spam mines"
SpamMines_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
SpamMines_Button.TextScaled = true
SpamMines_Button.TextSize = 14.000
SpamMines_Button.TextWrapped = true

PushAura_Button.Name = "PushAura_Button"
PushAura_Button.Parent = Game_Section
PushAura_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PushAura_Button.BackgroundTransparency = 0.500
PushAura_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PushAura_Button.BorderSizePixel = 0
PushAura_Button.Position = UDim2.new(0, 210, 0, 25)
PushAura_Button.Size = UDim2.new(0, 150, 0, 30)
PushAura_Button.Font = Enum.Font.Oswald
PushAura_Button.Text = "Push aura"
PushAura_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PushAura_Button.TextScaled = true
PushAura_Button.TextSize = 14.000
PushAura_Button.TextWrapped = true

BreakCannons_Button.Name = "BreakCannons_Button"
BreakCannons_Button.Parent = Game_Section
BreakCannons_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
BreakCannons_Button.BackgroundTransparency = 0.500
BreakCannons_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
BreakCannons_Button.BorderSizePixel = 0
BreakCannons_Button.Position = UDim2.new(0, 25, 0, 225)
BreakCannons_Button.Size = UDim2.new(0, 150, 0, 30)
BreakCannons_Button.Font = Enum.Font.Oswald
BreakCannons_Button.Text = "Break Cannons"
BreakCannons_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
BreakCannons_Button.TextScaled = true
BreakCannons_Button.TextSize = 14.000
BreakCannons_Button.TextWrapped = true

LethalCannons_Button.Name = "LethalCannons_Button"
LethalCannons_Button.Parent = Game_Section
LethalCannons_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LethalCannons_Button.BackgroundTransparency = 0.500
LethalCannons_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
LethalCannons_Button.BorderSizePixel = 0
LethalCannons_Button.Position = UDim2.new(0, 25, 0, 275)
LethalCannons_Button.Size = UDim2.new(0, 150, 0, 30)
LethalCannons_Button.Font = Enum.Font.Oswald
LethalCannons_Button.Text = "Lethal Cannons"
LethalCannons_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
LethalCannons_Button.TextScaled = true
LethalCannons_Button.TextSize = 14.000
LethalCannons_Button.TextWrapped = true

ChatAlert_Button.Name = "ChatAlert_Button"
ChatAlert_Button.Parent = Game_Section
ChatAlert_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ChatAlert_Button.BackgroundTransparency = 0.500
ChatAlert_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChatAlert_Button.BorderSizePixel = 0
ChatAlert_Button.Position = UDim2.new(0, 210, 0, 275)
ChatAlert_Button.Size = UDim2.new(0, 150, 0, 30)
ChatAlert_Button.Font = Enum.Font.Oswald
ChatAlert_Button.Text = "Chat alert"
ChatAlert_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ChatAlert_Button.TextScaled = true
ChatAlert_Button.TextSize = 14.000
ChatAlert_Button.TextWrapped = true

PotionDi_Button.Name = "PotionDi_Button"
PotionDi_Button.Parent = Game_Section
PotionDi_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PotionDi_Button.BackgroundTransparency = 0.500
PotionDi_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PotionDi_Button.BorderSizePixel = 0
PotionDi_Button.Position = UDim2.new(0, 210, 0, 125)
PotionDi_Button.Size = UDim2.new(0, 150, 0, 30)
PotionDi_Button.Font = Enum.Font.Oswald
PotionDi_Button.Text = "Potion dick"
PotionDi_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PotionDi_Button.TextScaled = true
PotionDi_Button.TextSize = 14.000
PotionDi_Button.TextWrapped = true

VoidProtection_Button.Name = "VoidProtection_Button"
VoidProtection_Button.Parent = Game_Section
VoidProtection_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
VoidProtection_Button.BackgroundTransparency = 0.500
VoidProtection_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
VoidProtection_Button.BorderSizePixel = 0
VoidProtection_Button.Position = UDim2.new(0, 25, 0, 175)
VoidProtection_Button.Size = UDim2.new(0, 150, 0, 30)
VoidProtection_Button.Font = Enum.Font.Oswald
VoidProtection_Button.Text = "Void protection"
VoidProtection_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
VoidProtection_Button.TextScaled = true
VoidProtection_Button.TextSize = 14.000
VoidProtection_Button.TextWrapped = true

PushAll_Button.Name = "PushAll_Button"
PushAll_Button.Parent = Game_Section
PushAll_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PushAll_Button.BackgroundTransparency = 0.500
PushAll_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PushAll_Button.BorderSizePixel = 0
PushAll_Button.Position = UDim2.new(0, 210, 0, 225)
PushAll_Button.Size = UDim2.new(0, 150, 0, 30)
PushAll_Button.Font = Enum.Font.Oswald
PushAll_Button.Text = "Push all"
PushAll_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PushAll_Button.TextScaled = true
PushAll_Button.TextSize = 14.000
PushAll_Button.TextWrapped = true

TouchFling_Button.Name = "TouchFling_Button"
TouchFling_Button.Parent = Game_Section
TouchFling_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TouchFling_Button.BackgroundTransparency = 0.500
TouchFling_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
TouchFling_Button.BorderSizePixel = 0
TouchFling_Button.Position = UDim2.new(0, 25, 0, 125)
TouchFling_Button.Size = UDim2.new(0, 150, 0, 30)
TouchFling_Button.Font = Enum.Font.Oswald
TouchFling_Button.Text = "Touch fling"
TouchFling_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
TouchFling_Button.TextScaled = true
TouchFling_Button.TextSize = 14.000
TouchFling_Button.TextWrapped = true

CMDBar.Name = "CMDBar"
CMDBar.Parent = Game_Section
CMDBar.AnchorPoint = Vector2.new(0.5, 0.5)
CMDBar.BackgroundColor3 = Color3.fromRGB(0, 140, 140)
CMDBar.BackgroundTransparency = 0.300
CMDBar.BorderColor3 = Color3.fromRGB(0, 255, 255)
CMDBar.Position = UDim2.new(0.5, 0, 0, 350)
CMDBar.Size = UDim2.new(0, 275, 0, 40)
CMDBar.Font = Enum.Font.Gotham
CMDBar.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
CMDBar.PlaceholderText = "CMD BAR..."
CMDBar.Text = ""
CMDBar.TextColor3 = Color3.fromRGB(20, 20, 20)
CMDBar.TextSize = 14.000
CMDBar.TextWrapped = true

CannonTP1_Button.Name = "CannonTP1_Button"
CannonTP1_Button.Parent = Game_Section
CannonTP1_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CannonTP1_Button.BackgroundTransparency = 0.500
CannonTP1_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CannonTP1_Button.BorderSizePixel = 0
CannonTP1_Button.Position = UDim2.new(0, 25, 0, 400)
CannonTP1_Button.Size = UDim2.new(0, 150, 0, 30)
CannonTP1_Button.Font = Enum.Font.Oswald
CannonTP1_Button.Text = "TP Cannon 1"
CannonTP1_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CannonTP1_Button.TextScaled = true
CannonTP1_Button.TextSize = 14.000
CannonTP1_Button.TextWrapped = true

CannonTP2_Button.Name = "CannonTP2_Button"
CannonTP2_Button.Parent = Game_Section
CannonTP2_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CannonTP2_Button.BackgroundTransparency = 0.500
CannonTP2_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CannonTP2_Button.BorderSizePixel = 0
CannonTP2_Button.Position = UDim2.new(0, 210, 0, 400)
CannonTP2_Button.Size = UDim2.new(0, 150, 0, 30)
CannonTP2_Button.Font = Enum.Font.Oswald
CannonTP2_Button.Text = "TP Cannon 2"
CannonTP2_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CannonTP2_Button.TextScaled = true
CannonTP2_Button.TextSize = 14.000
CannonTP2_Button.TextWrapped = true

CannonTP3_Button.Name = "CannonTP3_Button"
CannonTP3_Button.Parent = Game_Section
CannonTP3_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CannonTP3_Button.BackgroundTransparency = 0.500
CannonTP3_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CannonTP3_Button.BorderSizePixel = 0
CannonTP3_Button.Position = UDim2.new(0, 25, 0, 450)
CannonTP3_Button.Size = UDim2.new(0, 150, 0, 30)
CannonTP3_Button.Font = Enum.Font.Oswald
CannonTP3_Button.Text = "TP Cannon 3"
CannonTP3_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CannonTP3_Button.TextScaled = true
CannonTP3_Button.TextSize = 14.000
CannonTP3_Button.TextWrapped = true

MinefieldTP_Button.Name = "MinefieldTP_Button"
MinefieldTP_Button.Parent = Game_Section
MinefieldTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
MinefieldTP_Button.BackgroundTransparency = 0.500
MinefieldTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
MinefieldTP_Button.BorderSizePixel = 0
MinefieldTP_Button.Position = UDim2.new(0, 210, 0, 450)
MinefieldTP_Button.Size = UDim2.new(0, 150, 0, 30)
MinefieldTP_Button.Font = Enum.Font.Oswald
MinefieldTP_Button.Text = "TP Minefield"
MinefieldTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
MinefieldTP_Button.TextScaled = true
MinefieldTP_Button.TextSize = 14.000
MinefieldTP_Button.TextWrapped = true

BallonTP_Button.Name = "BallonTP_Button"
BallonTP_Button.Parent = Game_Section
BallonTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
BallonTP_Button.BackgroundTransparency = 0.500
BallonTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
BallonTP_Button.BorderSizePixel = 0
BallonTP_Button.Position = UDim2.new(0, 25, 0, 500)
BallonTP_Button.Size = UDim2.new(0, 150, 0, 30)
BallonTP_Button.Font = Enum.Font.Oswald
BallonTP_Button.Text = "TP Ballon"
BallonTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
BallonTP_Button.TextScaled = true
BallonTP_Button.TextSize = 14.000
BallonTP_Button.TextWrapped = true

NormalStairsTP_Button.Name = "NormalStairsTP_Button"
NormalStairsTP_Button.Parent = Game_Section
NormalStairsTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
NormalStairsTP_Button.BackgroundTransparency = 0.500
NormalStairsTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
NormalStairsTP_Button.BorderSizePixel = 0
NormalStairsTP_Button.Position = UDim2.new(0, 210, 0, 500)
NormalStairsTP_Button.Size = UDim2.new(0, 150, 0, 30)
NormalStairsTP_Button.Font = Enum.Font.Oswald
NormalStairsTP_Button.Text = "TP Stairs"
NormalStairsTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
NormalStairsTP_Button.TextScaled = true
NormalStairsTP_Button.TextSize = 14.000
NormalStairsTP_Button.TextWrapped = true

MovingStairsTP_Button.Name = "MovingStairsTP_Button"
MovingStairsTP_Button.Parent = Game_Section
MovingStairsTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
MovingStairsTP_Button.BackgroundTransparency = 0.500
MovingStairsTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
MovingStairsTP_Button.BorderSizePixel = 0
MovingStairsTP_Button.Position = UDim2.new(0, 25, 0, 550)
MovingStairsTP_Button.Size = UDim2.new(0, 150, 0, 30)
MovingStairsTP_Button.Font = Enum.Font.Oswald
MovingStairsTP_Button.Text = "TP Moving Stairs"
MovingStairsTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
MovingStairsTP_Button.TextScaled = true
MovingStairsTP_Button.TextSize = 14.000
MovingStairsTP_Button.TextWrapped = true

SpiralStairsTP_Button.Name = "SpiralStairsTP_Button"
SpiralStairsTP_Button.Parent = Game_Section
SpiralStairsTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SpiralStairsTP_Button.BackgroundTransparency = 0.500
SpiralStairsTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpiralStairsTP_Button.BorderSizePixel = 0
SpiralStairsTP_Button.Position = UDim2.new(0, 210, 0, 550)
SpiralStairsTP_Button.Size = UDim2.new(0, 150, 0, 30)
SpiralStairsTP_Button.Font = Enum.Font.Oswald
SpiralStairsTP_Button.Text = "TP Spiral Stairs"
SpiralStairsTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
SpiralStairsTP_Button.TextScaled = true
SpiralStairsTP_Button.TextSize = 14.000
SpiralStairsTP_Button.TextWrapped = true

SkyscraperTP_Button.Name = "SkyscraperTP_Button"
SkyscraperTP_Button.Parent = Game_Section
SkyscraperTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SkyscraperTP_Button.BackgroundTransparency = 0.500
SkyscraperTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
SkyscraperTP_Button.BorderSizePixel = 0
SkyscraperTP_Button.Position = UDim2.new(0, 25, 0, 600)
SkyscraperTP_Button.Size = UDim2.new(0, 150, 0, 30)
SkyscraperTP_Button.Font = Enum.Font.Oswald
SkyscraperTP_Button.Text = "TP Skyscraper"
SkyscraperTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
SkyscraperTP_Button.TextScaled = true
SkyscraperTP_Button.TextSize = 14.000
SkyscraperTP_Button.TextWrapped = true

PoolTP_Button.Name = "PoolTP_Button"
PoolTP_Button.Parent = Game_Section
PoolTP_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PoolTP_Button.BackgroundTransparency = 0.500
PoolTP_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PoolTP_Button.BorderSizePixel = 0
PoolTP_Button.Position = UDim2.new(0, 210, 0, 600)
PoolTP_Button.Size = UDim2.new(0, 150, 0, 30)
PoolTP_Button.Font = Enum.Font.Oswald
PoolTP_Button.Text = "TP Pool"
PoolTP_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PoolTP_Button.TextScaled = true
PoolTP_Button.TextSize = 14.000
PoolTP_Button.TextWrapped = true

FreePushTool_Button.Name = "FreePushTool_Button"
FreePushTool_Button.Parent = Game_Section
FreePushTool_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FreePushTool_Button.BackgroundTransparency = 0.500
FreePushTool_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
FreePushTool_Button.BorderSizePixel = 0
FreePushTool_Button.Position = UDim2.new(0, 210, 0, 175)
FreePushTool_Button.Size = UDim2.new(0, 150, 0, 30)
FreePushTool_Button.Font = Enum.Font.Oswald
FreePushTool_Button.Text = "Modded push"
FreePushTool_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
FreePushTool_Button.TextScaled = true
FreePushTool_Button.TextSize = 14.000
FreePushTool_Button.TextWrapped = true

Home_Section.Name = "Home_Section"
Home_Section.Parent = Background
Home_Section.Active = true
Home_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Home_Section.BackgroundTransparency = 1.000
Home_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Home_Section.BorderSizePixel = 0
Home_Section.Position = UDim2.new(0, 105, 0, 30)
Home_Section.Size = UDim2.new(0, 395, 0, 320)
Home_Section.CanvasSize = UDim2.new(0, 0, 0, 0)
Home_Section.ScrollBarThickness = 5

Profile_Image.Name = "Profile_Image"
Profile_Image.Parent = Home_Section
Profile_Image.BackgroundColor3 = Color3.fromRGB(30,30,30)
Profile_Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
Profile_Image.BorderSizePixel = 0
Profile_Image.Position = UDim2.new(0, 25, 0, 25)
Profile_Image.Size = UDim2.new(0, 100, 0, 100)
Profile_Image.Image = Players:GetUserThumbnailAsync(plr.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)

Welcome_Label.Name = "Welcome_Label"
Welcome_Label.Parent = Home_Section
Welcome_Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Welcome_Label.BackgroundTransparency = 1.000
Welcome_Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Welcome_Label.BorderSizePixel = 0
Welcome_Label.Position = UDim2.new(0, 150, 0, 25)
Welcome_Label.Size = UDim2.new(0, 200, 0, 100)
Welcome_Label.Font = Enum.Font.SourceSans
Welcome_Label.Text = ("¡Hello @"..plr.Name.."!\nPress [B] to open/close gui.")
Welcome_Label.TextColor3 = Color3.fromRGB(0, 255, 255)
Welcome_Label.TextSize = 24.000
Welcome_Label.TextWrapped = true
Welcome_Label.TextXAlignment = Enum.TextXAlignment.Left
Welcome_Label.TextYAlignment = Enum.TextYAlignment.Top

Announce_Label.Name = "Announce_Label"
Announce_Label.Parent = Home_Section
Announce_Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Announce_Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Announce_Label.BorderSizePixel = 0
Announce_Label.Position = UDim2.new(0, 25, 0, 150)
Announce_Label.Size = UDim2.new(0, 350, 0, 150)
Announce_Label.Font = Enum.Font.SourceSans
Announce_Label.Text = loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/announce"))()
Announce_Label.TextColor3 = Color3.fromRGB(0, 255, 255)
Announce_Label.TextSize = 24.000
Announce_Label.TextWrapped = true
Announce_Label.TextXAlignment = Enum.TextXAlignment.Left
Announce_Label.TextYAlignment = Enum.TextYAlignment.Top

Character_Section.Name = "Character_Section"
Character_Section.Parent = Background
Character_Section.Active = true
Character_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Character_Section.BackgroundTransparency = 1.000
Character_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Character_Section.BorderSizePixel = 0
Character_Section.Position = UDim2.new(0, 105, 0, 30)
Character_Section.Size = UDim2.new(0, 395, 0, 320)
Character_Section.Visible = false
Character_Section.CanvasSize = UDim2.new(0, 0, 1, 0)
Character_Section.ScrollBarThickness = 5

WalkSpeed_Button.Name = "WalkSpeed_Button"
WalkSpeed_Button.Parent = Character_Section
WalkSpeed_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
WalkSpeed_Button.BackgroundTransparency = 0.500
WalkSpeed_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
WalkSpeed_Button.BorderSizePixel = 0
WalkSpeed_Button.Position = UDim2.new(0, 25, 0, 25)
WalkSpeed_Button.Size = UDim2.new(0, 150, 0, 30)
WalkSpeed_Button.Font = Enum.Font.Oswald
WalkSpeed_Button.Text = "Walk Speed"
WalkSpeed_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
WalkSpeed_Button.TextScaled = true
WalkSpeed_Button.TextSize = 14.000
WalkSpeed_Button.TextWrapped = true

WalkSpeed_Input.Name = "WalkSpeed_Input"
WalkSpeed_Input.Parent = Character_Section
WalkSpeed_Input.BackgroundColor3 = Color3.fromRGB(0, 140, 140)
WalkSpeed_Input.BackgroundTransparency = 0.300
WalkSpeed_Input.BorderColor3 = Color3.fromRGB(0, 255, 255)
WalkSpeed_Input.Position = UDim2.new(0, 210, 0, 25)
WalkSpeed_Input.Size = UDim2.new(0, 175, 0, 30)
WalkSpeed_Input.Font = Enum.Font.Gotham
WalkSpeed_Input.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
WalkSpeed_Input.PlaceholderText = "Number [1-99999]"
WalkSpeed_Input.Text = ""
WalkSpeed_Input.TextColor3 = Color3.fromRGB(20, 20, 20)
WalkSpeed_Input.TextSize = 14.000
WalkSpeed_Input.TextWrapped = true

ClearCheckpoint_Button.Name = "ClearCheckpoint_Button"
ClearCheckpoint_Button.Parent = Character_Section
ClearCheckpoint_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ClearCheckpoint_Button.BackgroundTransparency = 0.500
ClearCheckpoint_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearCheckpoint_Button.BorderSizePixel = 0
ClearCheckpoint_Button.Position = UDim2.new(0, 210, 0, 225)
ClearCheckpoint_Button.Size = UDim2.new(0, 150, 0, 30)
ClearCheckpoint_Button.Font = Enum.Font.Oswald
ClearCheckpoint_Button.Text = "Clear checkpoint"
ClearCheckpoint_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearCheckpoint_Button.TextScaled = true
ClearCheckpoint_Button.TextSize = 14.000
ClearCheckpoint_Button.TextWrapped = true

JumpPower_Input.Name = "JumpPower_Input"
JumpPower_Input.Parent = Character_Section
JumpPower_Input.BackgroundColor3 = Color3.fromRGB(0, 140, 140)
JumpPower_Input.BackgroundTransparency = 0.300
JumpPower_Input.BorderColor3 = Color3.fromRGB(0, 255, 255)
JumpPower_Input.Position = UDim2.new(0, 210, 0, 75)
JumpPower_Input.Size = UDim2.new(0, 175, 0, 30)
JumpPower_Input.Font = Enum.Font.Gotham
JumpPower_Input.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
JumpPower_Input.PlaceholderText = "Number [1-99999]"
JumpPower_Input.Text = ""
JumpPower_Input.TextColor3 = Color3.fromRGB(20, 20, 20)
JumpPower_Input.TextSize = 14.000
JumpPower_Input.TextWrapped = true

JumpPower_Button.Name = "JumpPower_Button"
JumpPower_Button.Parent = Character_Section
JumpPower_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
JumpPower_Button.BackgroundTransparency = 0.500
JumpPower_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
JumpPower_Button.BorderSizePixel = 0
JumpPower_Button.Position = UDim2.new(0, 25, 0, 75)
JumpPower_Button.Size = UDim2.new(0, 150, 0, 30)
JumpPower_Button.Font = Enum.Font.Oswald
JumpPower_Button.Text = "Jump power"
JumpPower_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
JumpPower_Button.TextScaled = true
JumpPower_Button.TextSize = 14.000
JumpPower_Button.TextWrapped = true

SaveCheckpoint_Button.Name = "SaveCheckpoint_Button"
SaveCheckpoint_Button.Parent = Character_Section
SaveCheckpoint_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SaveCheckpoint_Button.BackgroundTransparency = 0.500
SaveCheckpoint_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
SaveCheckpoint_Button.BorderSizePixel = 0
SaveCheckpoint_Button.Position = UDim2.new(0, 210, 0, 175)
SaveCheckpoint_Button.Size = UDim2.new(0, 150, 0, 30)
SaveCheckpoint_Button.Font = Enum.Font.Oswald
SaveCheckpoint_Button.Text = "Save checkpoint"
SaveCheckpoint_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
SaveCheckpoint_Button.TextScaled = true
SaveCheckpoint_Button.TextSize = 14.000
SaveCheckpoint_Button.TextWrapped = true

Respawn_Button.Name = "Respawn_Button"
Respawn_Button.Parent = Character_Section
Respawn_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Respawn_Button.BackgroundTransparency = 0.500
Respawn_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Respawn_Button.BorderSizePixel = 0
Respawn_Button.Position = UDim2.new(0, 25, 0, 225)
Respawn_Button.Size = UDim2.new(0, 150, 0, 30)
Respawn_Button.Font = Enum.Font.Oswald
Respawn_Button.Text = "Respawn"
Respawn_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Respawn_Button.TextScaled = true
Respawn_Button.TextSize = 14.000
Respawn_Button.TextWrapped = true

FlySpeed_Button.Name = "FlySpeed_Button"
FlySpeed_Button.Parent = Character_Section
FlySpeed_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FlySpeed_Button.BackgroundTransparency = 0.500
FlySpeed_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlySpeed_Button.BorderSizePixel = 0
FlySpeed_Button.Position = UDim2.new(0, 25, 0, 125)
FlySpeed_Button.Size = UDim2.new(0, 150, 0, 30)
FlySpeed_Button.Font = Enum.Font.Oswald
FlySpeed_Button.Text = "Fly speed"
FlySpeed_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
FlySpeed_Button.TextScaled = true
FlySpeed_Button.TextSize = 14.000
FlySpeed_Button.TextWrapped = true

FlySpeed_Input.Name = "FlySpeed_Input"
FlySpeed_Input.Parent = Character_Section
FlySpeed_Input.BackgroundColor3 = Color3.fromRGB(0, 140, 140)
FlySpeed_Input.BackgroundTransparency = 0.300
FlySpeed_Input.BorderColor3 = Color3.fromRGB(0, 255, 255)
FlySpeed_Input.Position = UDim2.new(0, 210, 0, 125)
FlySpeed_Input.Size = UDim2.new(0, 175, 0, 30)
FlySpeed_Input.Font = Enum.Font.Gotham
FlySpeed_Input.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
FlySpeed_Input.PlaceholderText = "Number [1-99999]"
FlySpeed_Input.Text = ""
FlySpeed_Input.TextColor3 = Color3.fromRGB(20, 20, 20)
FlySpeed_Input.TextSize = 14.000
FlySpeed_Input.TextWrapped = true

Fly_Button.Name = "Fly_Button"
Fly_Button.Parent = Character_Section
Fly_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Fly_Button.BackgroundTransparency = 0.500
Fly_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Fly_Button.BorderSizePixel = 0
Fly_Button.Position = UDim2.new(0, 25, 0, 175)
Fly_Button.Size = UDim2.new(0, 150, 0, 30)
Fly_Button.Font = Enum.Font.Oswald
Fly_Button.Text = "Fly"
Fly_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Fly_Button.TextScaled = true
Fly_Button.TextSize = 14.000
Fly_Button.TextWrapped = true

Target_Section.Name = "Target_Section"
Target_Section.Parent = Background
Target_Section.Active = true
Target_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Target_Section.BackgroundTransparency = 1.000
Target_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Target_Section.BorderSizePixel = 0
Target_Section.Position = UDim2.new(0, 105, 0, 30)
Target_Section.Size = UDim2.new(0, 395, 0, 320)
Target_Section.Visible = false
Target_Section.CanvasSize = UDim2.new(0, 0, 1.25, 0)
Target_Section.ScrollBarThickness = 5

TargetImage.Name = "TargetImage"
TargetImage.Parent = Target_Section
TargetImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetImage.BorderColor3 = Color3.fromRGB(0, 255, 255)
TargetImage.Position = UDim2.new(0, 25, 0, 25)
TargetImage.Size = UDim2.new(0, 100, 0, 100)
TargetImage.Image = "rbxassetid://10818605405"

TargetName_Input.Name = "TargetName_Input"
TargetName_Input.Parent = Target_Section
TargetName_Input.BackgroundColor3 = Color3.fromRGB(0, 140, 140)
TargetName_Input.BackgroundTransparency = 0.300
TargetName_Input.BorderColor3 = Color3.fromRGB(0, 255, 255)
TargetName_Input.Position = UDim2.new(0, 150, 0, 30)
TargetName_Input.Size = UDim2.new(0, 175, 0, 30)
TargetName_Input.Font = Enum.Font.Gotham
TargetName_Input.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
TargetName_Input.PlaceholderText = "@target..."
TargetName_Input.Text = ""
TargetName_Input.TextColor3 = Color3.fromRGB(20, 20, 20)
TargetName_Input.TextSize = 14.000
TargetName_Input.TextWrapped = true

ClickTargetTool_Button.Name = "ClickTargetTool_Button"
ClickTargetTool_Button.Parent = TargetName_Input
ClickTargetTool_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClickTargetTool_Button.BackgroundTransparency = 1.000
ClickTargetTool_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClickTargetTool_Button.BorderSizePixel = 0
ClickTargetTool_Button.Position = UDim2.new(0, 180, 0, 0)
ClickTargetTool_Button.Size = UDim2.new(0, 30, 0, 30)
ClickTargetTool_Button.Image = "rbxassetid://2716591855"

UserIDTargetLabel.Name = "UserIDTargetLabel"
UserIDTargetLabel.Parent = Target_Section
UserIDTargetLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UserIDTargetLabel.BackgroundTransparency = 1.000
UserIDTargetLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UserIDTargetLabel.BorderSizePixel = 0
UserIDTargetLabel.Position = UDim2.new(0, 150, 0, 70)
UserIDTargetLabel.Size = UDim2.new(0, 300, 0, 75)
UserIDTargetLabel.Font = Enum.Font.Oswald
UserIDTargetLabel.Text = "UserID: \nDisplay: \nJoined: "
UserIDTargetLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
UserIDTargetLabel.TextSize = 18.000
UserIDTargetLabel.TextWrapped = true
UserIDTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
UserIDTargetLabel.TextYAlignment = Enum.TextYAlignment.Top

ViewTarget_Button.Name = "ViewTarget_Button"
ViewTarget_Button.Parent = Target_Section
ViewTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ViewTarget_Button.BackgroundTransparency = 0.500
ViewTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ViewTarget_Button.BorderSizePixel = 0
ViewTarget_Button.Position = UDim2.new(0, 210, 0, 150)
ViewTarget_Button.Size = UDim2.new(0, 150, 0, 30)
ViewTarget_Button.Font = Enum.Font.Oswald
ViewTarget_Button.Text = "View"
ViewTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ViewTarget_Button.TextScaled = true
ViewTarget_Button.TextSize = 14.000
ViewTarget_Button.TextWrapped = true

FlingTarget_Button.Name = "FlingTarget_Button"
FlingTarget_Button.Parent = Target_Section
FlingTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FlingTarget_Button.BackgroundTransparency = 0.500
FlingTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlingTarget_Button.BorderSizePixel = 0
FlingTarget_Button.Position = UDim2.new(0, 25, 0, 150)
FlingTarget_Button.Size = UDim2.new(0, 150, 0, 30)
FlingTarget_Button.Font = Enum.Font.Oswald
FlingTarget_Button.Text = "Fling"
FlingTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
FlingTarget_Button.TextScaled = true
FlingTarget_Button.TextSize = 14.000
FlingTarget_Button.TextWrapped = true

FocusTarget_Button.Name = "FocusTarget_Button"
FocusTarget_Button.Parent = Target_Section
FocusTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FocusTarget_Button.BackgroundTransparency = 0.500
FocusTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
FocusTarget_Button.BorderSizePixel = 0
FocusTarget_Button.Position = UDim2.new(0, 25, 0, 200)
FocusTarget_Button.Size = UDim2.new(0, 150, 0, 30)
FocusTarget_Button.Font = Enum.Font.Oswald
FocusTarget_Button.Text = "Focus"
FocusTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
FocusTarget_Button.TextScaled = true
FocusTarget_Button.TextSize = 14.000
FocusTarget_Button.TextWrapped = true

BenxTarget_Button.Name = "BenxTarget_Button"
BenxTarget_Button.Parent = Target_Section
BenxTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
BenxTarget_Button.BackgroundTransparency = 0.500
BenxTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
BenxTarget_Button.BorderSizePixel = 0
BenxTarget_Button.Position = UDim2.new(0, 210, 0, 200)
BenxTarget_Button.Size = UDim2.new(0, 150, 0, 30)
BenxTarget_Button.Font = Enum.Font.Oswald
BenxTarget_Button.Text = "Bang"
BenxTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
BenxTarget_Button.TextScaled = true
BenxTarget_Button.TextSize = 14.000
BenxTarget_Button.TextWrapped = true

PushTarget_Button.Name = "PushTarget_Button"
PushTarget_Button.Parent = Target_Section
PushTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PushTarget_Button.BackgroundTransparency = 0.500
PushTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PushTarget_Button.BorderSizePixel = 0
PushTarget_Button.Position = UDim2.new(0, 25, 0, 400)
PushTarget_Button.Size = UDim2.new(0, 150, 0, 30)
PushTarget_Button.Font = Enum.Font.Oswald
PushTarget_Button.Text = "Push"
PushTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PushTarget_Button.TextScaled = true
PushTarget_Button.TextSize = 14.000
PushTarget_Button.TextWrapped = true

WhitelistTarget_Button.Name = "WhitelistTarget_Button"
WhitelistTarget_Button.Parent = Target_Section
WhitelistTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
WhitelistTarget_Button.BackgroundTransparency = 0.500
WhitelistTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
WhitelistTarget_Button.BorderSizePixel = 0
WhitelistTarget_Button.Position = UDim2.new(0, 210, 0, 400)
WhitelistTarget_Button.Size = UDim2.new(0, 150, 0, 30)
WhitelistTarget_Button.Font = Enum.Font.Oswald
WhitelistTarget_Button.Text = "Whitelist"
WhitelistTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
WhitelistTarget_Button.TextScaled = true
WhitelistTarget_Button.TextSize = 14.000
WhitelistTarget_Button.TextWrapped = true

TeleportTarget_Button.Name = "TeleportTarget_Button"
TeleportTarget_Button.Parent = Target_Section
TeleportTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TeleportTarget_Button.BackgroundTransparency = 0.500
TeleportTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeleportTarget_Button.BorderSizePixel = 0
TeleportTarget_Button.Position = UDim2.new(0, 210, 0, 350)
TeleportTarget_Button.Size = UDim2.new(0, 150, 0, 30)
TeleportTarget_Button.Font = Enum.Font.Oswald
TeleportTarget_Button.Text = "Teleport"
TeleportTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportTarget_Button.TextScaled = true
TeleportTarget_Button.TextSize = 14.000
TeleportTarget_Button.TextWrapped = true

HeadsitTarget_Button.Name = "HeadsitTarget_Button"
HeadsitTarget_Button.Parent = Target_Section
HeadsitTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
HeadsitTarget_Button.BackgroundTransparency = 0.500
HeadsitTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeadsitTarget_Button.BorderSizePixel = 0
HeadsitTarget_Button.Position = UDim2.new(0, 210, 0, 250)
HeadsitTarget_Button.Size = UDim2.new(0, 150, 0, 30)
HeadsitTarget_Button.Font = Enum.Font.Oswald
HeadsitTarget_Button.Text = "Headsit"
HeadsitTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
HeadsitTarget_Button.TextScaled = true
HeadsitTarget_Button.TextSize = 14.000
HeadsitTarget_Button.TextWrapped = true

StandTarget_Button.Name = "StandTarget_Button"
StandTarget_Button.Parent = Target_Section
StandTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
StandTarget_Button.BackgroundTransparency = 0.500
StandTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
StandTarget_Button.BorderSizePixel = 0
StandTarget_Button.Position = UDim2.new(0, 25, 0, 250)
StandTarget_Button.Size = UDim2.new(0, 150, 0, 30)
StandTarget_Button.Font = Enum.Font.Oswald
StandTarget_Button.Text = "Stand"
StandTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
StandTarget_Button.TextScaled = true
StandTarget_Button.TextSize = 14.000
StandTarget_Button.TextWrapped = true

BackpackTarget_Button.Name = "BackpackTarget_Button"
BackpackTarget_Button.Parent = Target_Section
BackpackTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
BackpackTarget_Button.BackgroundTransparency = 0.500
BackpackTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
BackpackTarget_Button.BorderSizePixel = 0
BackpackTarget_Button.Position = UDim2.new(0, 210, 0, 300)
BackpackTarget_Button.Size = UDim2.new(0, 150, 0, 30)
BackpackTarget_Button.Font = Enum.Font.Oswald
BackpackTarget_Button.Text = "Backpack"
BackpackTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
BackpackTarget_Button.TextScaled = true
BackpackTarget_Button.TextSize = 14.000
BackpackTarget_Button.TextWrapped = true

DoggyTarget_Button.Name = "DoggyTarget_Button"
DoggyTarget_Button.Parent = Target_Section
DoggyTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
DoggyTarget_Button.BackgroundTransparency = 0.500
DoggyTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
DoggyTarget_Button.BorderSizePixel = 0
DoggyTarget_Button.Position = UDim2.new(0, 25, 0, 300)
DoggyTarget_Button.Size = UDim2.new(0, 150, 0, 30)
DoggyTarget_Button.Font = Enum.Font.Oswald
DoggyTarget_Button.Text = "Doggy"
DoggyTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
DoggyTarget_Button.TextScaled = true
DoggyTarget_Button.TextSize = 14.000
DoggyTarget_Button.TextWrapped = true

DragTarget_Button.Name = "DragTarget_Button"
DragTarget_Button.Parent = Target_Section
DragTarget_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
DragTarget_Button.BackgroundTransparency = 0.500
DragTarget_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
DragTarget_Button.BorderSizePixel = 0
DragTarget_Button.Position = UDim2.new(0, 25, 0, 350)
DragTarget_Button.Size = UDim2.new(0, 150, 0, 30)
DragTarget_Button.Font = Enum.Font.Oswald
DragTarget_Button.Text = "Drag"
DragTarget_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
DragTarget_Button.TextScaled = true
DragTarget_Button.TextSize = 14.000
DragTarget_Button.TextWrapped = true

Animations_Section.Name = "Animations_Section"
Animations_Section.Parent = Background
Animations_Section.Active = true
Animations_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Animations_Section.BackgroundTransparency = 1.000
Animations_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Animations_Section.BorderSizePixel = 0
Animations_Section.Position = UDim2.new(0, 105, 0, 30)
Animations_Section.Size = UDim2.new(0, 395, 0, 320)
Animations_Section.Visible = false
Animations_Section.CanvasSize = UDim2.new(0, 0, 1.6, 0)
Animations_Section.ScrollBarThickness = 5

VampireAnim_Button.Name = "VampireAnim_Button"
VampireAnim_Button.Parent = Animations_Section
VampireAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
VampireAnim_Button.BackgroundTransparency = 0.500
VampireAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
VampireAnim_Button.BorderSizePixel = 0
VampireAnim_Button.Position = UDim2.new(0, 25, 0, 25)
VampireAnim_Button.Size = UDim2.new(0, 150, 0, 30)
VampireAnim_Button.Font = Enum.Font.Oswald
VampireAnim_Button.Text = "Vampire"
VampireAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
VampireAnim_Button.TextScaled = true
VampireAnim_Button.TextSize = 14.000
VampireAnim_Button.TextWrapped = true

HeroAnim_Button.Name = "HeroAnim_Button"
HeroAnim_Button.Parent = Animations_Section
HeroAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
HeroAnim_Button.BackgroundTransparency = 0.500
HeroAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeroAnim_Button.BorderSizePixel = 0
HeroAnim_Button.Position = UDim2.new(0, 210, 0, 25)
HeroAnim_Button.Size = UDim2.new(0, 150, 0, 30)
HeroAnim_Button.Font = Enum.Font.Oswald
HeroAnim_Button.Text = "Hero"
HeroAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
HeroAnim_Button.TextScaled = true
HeroAnim_Button.TextSize = 14.000
HeroAnim_Button.TextWrapped = true

ZombieClassicAnim_Button.Name = "ZombieClassicAnim_Button"
ZombieClassicAnim_Button.Parent = Animations_Section
ZombieClassicAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ZombieClassicAnim_Button.BackgroundTransparency = 0.500
ZombieClassicAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ZombieClassicAnim_Button.BorderSizePixel = 0
ZombieClassicAnim_Button.Position = UDim2.new(0, 25, 0, 75)
ZombieClassicAnim_Button.Size = UDim2.new(0, 150, 0, 30)
ZombieClassicAnim_Button.Font = Enum.Font.Oswald
ZombieClassicAnim_Button.Text = "Zombie Classic"
ZombieClassicAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ZombieClassicAnim_Button.TextScaled = true
ZombieClassicAnim_Button.TextSize = 14.000
ZombieClassicAnim_Button.TextWrapped = true

MageAnim_Button.Name = "MageAnim_Button"
MageAnim_Button.Parent = Animations_Section
MageAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
MageAnim_Button.BackgroundTransparency = 0.500
MageAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
MageAnim_Button.BorderSizePixel = 0
MageAnim_Button.Position = UDim2.new(0, 210, 0, 75)
MageAnim_Button.Size = UDim2.new(0, 150, 0, 30)
MageAnim_Button.Font = Enum.Font.Oswald
MageAnim_Button.Text = "Mage"
MageAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
MageAnim_Button.TextScaled = true
MageAnim_Button.TextSize = 14.000
MageAnim_Button.TextWrapped = true

GhostAnim_Button.Name = "GhostAnim_Button"
GhostAnim_Button.Parent = Animations_Section
GhostAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
GhostAnim_Button.BackgroundTransparency = 0.500
GhostAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
GhostAnim_Button.BorderSizePixel = 0
GhostAnim_Button.Position = UDim2.new(0, 25, 0, 125)
GhostAnim_Button.Size = UDim2.new(0, 150, 0, 30)
GhostAnim_Button.Font = Enum.Font.Oswald
GhostAnim_Button.Text = "Ghost"
GhostAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
GhostAnim_Button.TextScaled = true
GhostAnim_Button.TextSize = 14.000
GhostAnim_Button.TextWrapped = true

ElderAnim_Button.Name = "ElderAnim_Button"
ElderAnim_Button.Parent = Animations_Section
ElderAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ElderAnim_Button.BackgroundTransparency = 0.500
ElderAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ElderAnim_Button.BorderSizePixel = 0
ElderAnim_Button.Position = UDim2.new(0, 210, 0, 125)
ElderAnim_Button.Size = UDim2.new(0, 150, 0, 30)
ElderAnim_Button.Font = Enum.Font.Oswald
ElderAnim_Button.Text = "Elder"
ElderAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ElderAnim_Button.TextScaled = true
ElderAnim_Button.TextSize = 14.000
ElderAnim_Button.TextWrapped = true

LevitationAnim_Button.Name = "LevitationAnim_Button"
LevitationAnim_Button.Parent = Animations_Section
LevitationAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LevitationAnim_Button.BackgroundTransparency = 0.500
LevitationAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
LevitationAnim_Button.BorderSizePixel = 0
LevitationAnim_Button.Position = UDim2.new(0, 25, 0, 175)
LevitationAnim_Button.Size = UDim2.new(0, 150, 0, 30)
LevitationAnim_Button.Font = Enum.Font.Oswald
LevitationAnim_Button.Text = "Levitation"
LevitationAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
LevitationAnim_Button.TextScaled = true
LevitationAnim_Button.TextSize = 14.000
LevitationAnim_Button.TextWrapped = true

AstronautAnim_Button.Name = "AstronautAnim_Button"
AstronautAnim_Button.Parent = Animations_Section
AstronautAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
AstronautAnim_Button.BackgroundTransparency = 0.500
AstronautAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
AstronautAnim_Button.BorderSizePixel = 0
AstronautAnim_Button.Position = UDim2.new(0, 210, 0, 175)
AstronautAnim_Button.Size = UDim2.new(0, 150, 0, 30)
AstronautAnim_Button.Font = Enum.Font.Oswald
AstronautAnim_Button.Text = "Astronaut"
AstronautAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
AstronautAnim_Button.TextScaled = true
AstronautAnim_Button.TextSize = 14.000
AstronautAnim_Button.TextWrapped = true

NinjaAnim_Button.Name = "NinjaAnim_Button"
NinjaAnim_Button.Parent = Animations_Section
NinjaAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
NinjaAnim_Button.BackgroundTransparency = 0.500
NinjaAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
NinjaAnim_Button.BorderSizePixel = 0
NinjaAnim_Button.Position = UDim2.new(0, 25, 0, 225)
NinjaAnim_Button.Size = UDim2.new(0, 150, 0, 30)
NinjaAnim_Button.Font = Enum.Font.Oswald
NinjaAnim_Button.Text = "Ninja"
NinjaAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
NinjaAnim_Button.TextScaled = true
NinjaAnim_Button.TextSize = 14.000
NinjaAnim_Button.TextWrapped = true

WerewolfAnim_Button.Name = "WerewolfAnim_Button"
WerewolfAnim_Button.Parent = Animations_Section
WerewolfAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
WerewolfAnim_Button.BackgroundTransparency = 0.500
WerewolfAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
WerewolfAnim_Button.BorderSizePixel = 0
WerewolfAnim_Button.Position = UDim2.new(0, 210, 0, 225)
WerewolfAnim_Button.Size = UDim2.new(0, 150, 0, 30)
WerewolfAnim_Button.Font = Enum.Font.Oswald
WerewolfAnim_Button.Text = "Werewolf"
WerewolfAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
WerewolfAnim_Button.TextScaled = true
WerewolfAnim_Button.TextSize = 14.000
WerewolfAnim_Button.TextWrapped = true

CartoonAnim_Button.Name = "CartoonAnim_Button"
CartoonAnim_Button.Parent = Animations_Section
CartoonAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CartoonAnim_Button.BackgroundTransparency = 0.500
CartoonAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CartoonAnim_Button.BorderSizePixel = 0
CartoonAnim_Button.Position = UDim2.new(0, 25, 0, 275)
CartoonAnim_Button.Size = UDim2.new(0, 150, 0, 30)
CartoonAnim_Button.Font = Enum.Font.Oswald
CartoonAnim_Button.Text = "Cartoon"
CartoonAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CartoonAnim_Button.TextScaled = true
CartoonAnim_Button.TextSize = 14.000
CartoonAnim_Button.TextWrapped = true

PirateAnim_Button.Name = "PirateAnim_Button"
PirateAnim_Button.Parent = Animations_Section
PirateAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PirateAnim_Button.BackgroundTransparency = 0.500
PirateAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PirateAnim_Button.BorderSizePixel = 0
PirateAnim_Button.Position = UDim2.new(0, 210, 0, 275)
PirateAnim_Button.Size = UDim2.new(0, 150, 0, 30)
PirateAnim_Button.Font = Enum.Font.Oswald
PirateAnim_Button.Text = "Pirate"
PirateAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PirateAnim_Button.TextScaled = true
PirateAnim_Button.TextSize = 14.000
PirateAnim_Button.TextWrapped = true

SneakyAnim_Button.Name = "SneakyAnim_Button"
SneakyAnim_Button.Parent = Animations_Section
SneakyAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SneakyAnim_Button.BackgroundTransparency = 0.500
SneakyAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
SneakyAnim_Button.BorderSizePixel = 0
SneakyAnim_Button.Position = UDim2.new(0, 25, 0, 325)
SneakyAnim_Button.Size = UDim2.new(0, 150, 0, 30)
SneakyAnim_Button.Font = Enum.Font.Oswald
SneakyAnim_Button.Text = "Sneaky"
SneakyAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
SneakyAnim_Button.TextScaled = true
SneakyAnim_Button.TextSize = 14.000
SneakyAnim_Button.TextWrapped = true

ToyAnim_Button.Name = "ToyAnim_Button"
ToyAnim_Button.Parent = Animations_Section
ToyAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ToyAnim_Button.BackgroundTransparency = 0.500
ToyAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToyAnim_Button.BorderSizePixel = 0
ToyAnim_Button.Position = UDim2.new(0, 210, 0, 325)
ToyAnim_Button.Size = UDim2.new(0, 150, 0, 30)
ToyAnim_Button.Font = Enum.Font.Oswald
ToyAnim_Button.Text = "Toy"
ToyAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ToyAnim_Button.TextScaled = true
ToyAnim_Button.TextSize = 14.000
ToyAnim_Button.TextWrapped = true

KnightAnim_Button.Name = "KnightAnim_Button"
KnightAnim_Button.Parent = Animations_Section
KnightAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
KnightAnim_Button.BackgroundTransparency = 0.500
KnightAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
KnightAnim_Button.BorderSizePixel = 0
KnightAnim_Button.Position = UDim2.new(0, 25, 0, 375)
KnightAnim_Button.Size = UDim2.new(0, 150, 0, 30)
KnightAnim_Button.Font = Enum.Font.Oswald
KnightAnim_Button.Text = "Knight"
KnightAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
KnightAnim_Button.TextScaled = true
KnightAnim_Button.TextSize = 14.000
KnightAnim_Button.TextWrapped = true

ConfidentAnim_Button.Name = "ConfidentAnim_Button"
ConfidentAnim_Button.Parent = Animations_Section
ConfidentAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ConfidentAnim_Button.BackgroundTransparency = 0.500
ConfidentAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ConfidentAnim_Button.BorderSizePixel = 0
ConfidentAnim_Button.Position = UDim2.new(0, 210, 0, 375)
ConfidentAnim_Button.Size = UDim2.new(0, 150, 0, 30)
ConfidentAnim_Button.Font = Enum.Font.Oswald
ConfidentAnim_Button.Text = "Confident"
ConfidentAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ConfidentAnim_Button.TextScaled = true
ConfidentAnim_Button.TextSize = 14.000
ConfidentAnim_Button.TextWrapped = true

PopstarAnim_Button.Name = "PopstarAnim_Button"
PopstarAnim_Button.Parent = Animations_Section
PopstarAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PopstarAnim_Button.BackgroundTransparency = 0.500
PopstarAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PopstarAnim_Button.BorderSizePixel = 0
PopstarAnim_Button.Position = UDim2.new(0, 25, 0, 425)
PopstarAnim_Button.Size = UDim2.new(0, 150, 0, 30)
PopstarAnim_Button.Font = Enum.Font.Oswald
PopstarAnim_Button.Text = "Popstar"
PopstarAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PopstarAnim_Button.TextScaled = true
PopstarAnim_Button.TextSize = 14.000
PopstarAnim_Button.TextWrapped = true

PrincessAnim_Button.Name = "PrincessAnim_Button"
PrincessAnim_Button.Parent = Animations_Section
PrincessAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PrincessAnim_Button.BackgroundTransparency = 0.500
PrincessAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PrincessAnim_Button.BorderSizePixel = 0
PrincessAnim_Button.Position = UDim2.new(0, 210, 0, 425)
PrincessAnim_Button.Size = UDim2.new(0, 150, 0, 30)
PrincessAnim_Button.Font = Enum.Font.Oswald
PrincessAnim_Button.Text = "Princess"
PrincessAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PrincessAnim_Button.TextScaled = true
PrincessAnim_Button.TextSize = 14.000
PrincessAnim_Button.TextWrapped = true

CowboyAnim_Button.Name = "CowboyAnim_Button"
CowboyAnim_Button.Parent = Animations_Section
CowboyAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CowboyAnim_Button.BackgroundTransparency = 0.500
CowboyAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CowboyAnim_Button.BorderSizePixel = 0
CowboyAnim_Button.Position = UDim2.new(0, 25, 0, 475)
CowboyAnim_Button.Size = UDim2.new(0, 150, 0, 30)
CowboyAnim_Button.Font = Enum.Font.Oswald
CowboyAnim_Button.Text = "Cowboy"
CowboyAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CowboyAnim_Button.TextScaled = true
CowboyAnim_Button.TextSize = 14.000
CowboyAnim_Button.TextWrapped = true

PatrolAnim_Button.Name = "PatrolAnim_Button"
PatrolAnim_Button.Parent = Animations_Section
PatrolAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
PatrolAnim_Button.BackgroundTransparency = 0.500
PatrolAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
PatrolAnim_Button.BorderSizePixel = 0
PatrolAnim_Button.Position = UDim2.new(0, 210, 0, 475)
PatrolAnim_Button.Size = UDim2.new(0, 150, 0, 30)
PatrolAnim_Button.Font = Enum.Font.Oswald
PatrolAnim_Button.Text = "Patrol"
PatrolAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
PatrolAnim_Button.TextScaled = true
PatrolAnim_Button.TextSize = 14.000
PatrolAnim_Button.TextWrapped = true

ZombieFEAnim_Button.Name = "ZombieFEAnim_Button"
ZombieFEAnim_Button.Parent = Animations_Section
ZombieFEAnim_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ZombieFEAnim_Button.BackgroundTransparency = 0.500
ZombieFEAnim_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
ZombieFEAnim_Button.BorderSizePixel = 0
ZombieFEAnim_Button.Position = UDim2.new(0, 25, 0, 525)
ZombieFEAnim_Button.Size = UDim2.new(0, 150, 0, 30)
ZombieFEAnim_Button.Font = Enum.Font.Oswald
ZombieFEAnim_Button.Text = "FE Zombie"
ZombieFEAnim_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
ZombieFEAnim_Button.TextScaled = true
ZombieFEAnim_Button.TextSize = 14.000
ZombieFEAnim_Button.TextWrapped = true

Misc_Section.Name = "Misc_Section"
Misc_Section.Parent = Background
Misc_Section.Active = true
Misc_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Misc_Section.BackgroundTransparency = 1.000
Misc_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Misc_Section.BorderSizePixel = 0
Misc_Section.Position = UDim2.new(0, 105, 0, 30)
Misc_Section.Size = UDim2.new(0, 395, 0, 320)
Misc_Section.Visible = false
Misc_Section.CanvasSize = UDim2.new(0, 0, 1.1, 0)
Misc_Section.ScrollBarThickness = 5

AntiFling_Button.Name = "AntiFling_Button"
AntiFling_Button.Parent = Misc_Section
AntiFling_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
AntiFling_Button.BackgroundTransparency = 0.500
AntiFling_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
AntiFling_Button.BorderSizePixel = 0
AntiFling_Button.Position = UDim2.new(0, 25, 0, 25)
AntiFling_Button.Size = UDim2.new(0, 150, 0, 30)
AntiFling_Button.Font = Enum.Font.Oswald
AntiFling_Button.Text = "Anti fling"
AntiFling_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiFling_Button.TextScaled = true
AntiFling_Button.TextSize = 14.000
AntiFling_Button.TextWrapped = true

AntiAFK_Button.Name = "AntiAFK_Button"
AntiAFK_Button.Parent = Misc_Section
AntiAFK_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
AntiAFK_Button.BackgroundTransparency = 0.500
AntiAFK_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
AntiAFK_Button.BorderSizePixel = 0
AntiAFK_Button.Position = UDim2.new(0, 25, 0, 75)
AntiAFK_Button.Size = UDim2.new(0, 150, 0, 30)
AntiAFK_Button.Font = Enum.Font.Oswald
AntiAFK_Button.Text = "Anti AFK"
AntiAFK_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiAFK_Button.TextScaled = true
AntiAFK_Button.TextSize = 14.000
AntiAFK_Button.TextWrapped = true

AntiChatSpy_Button.Name = "AntiChatSpy_Button"
AntiChatSpy_Button.Parent = Misc_Section
AntiChatSpy_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
AntiChatSpy_Button.BackgroundTransparency = 0.500
AntiChatSpy_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
AntiChatSpy_Button.BorderSizePixel = 0
AntiChatSpy_Button.Position = UDim2.new(0, 210, 0, 25)
AntiChatSpy_Button.Size = UDim2.new(0, 150, 0, 30)
AntiChatSpy_Button.Font = Enum.Font.Oswald
AntiChatSpy_Button.Text = "Anti chat spy"
AntiChatSpy_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiChatSpy_Button.TextScaled = true
AntiChatSpy_Button.TextSize = 14.000
AntiChatSpy_Button.TextWrapped = true

Shaders_Button.Name = "Shaders_Button"
Shaders_Button.Parent = Misc_Section
Shaders_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Shaders_Button.BackgroundTransparency = 0.500
Shaders_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Shaders_Button.BorderSizePixel = 0
Shaders_Button.Position = UDim2.new(0, 210, 0, 75)
Shaders_Button.Size = UDim2.new(0, 150, 0, 30)
Shaders_Button.Font = Enum.Font.Oswald
Shaders_Button.Text = "Shaders"
Shaders_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Shaders_Button.TextScaled = true
Shaders_Button.TextSize = 14.000
Shaders_Button.TextWrapped = true

Day_Button.Name = "Day_Button"
Day_Button.Parent = Misc_Section
Day_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Day_Button.BackgroundTransparency = 0.500
Day_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Day_Button.BorderSizePixel = 0
Day_Button.Position = UDim2.new(0, 25, 0, 125)
Day_Button.Size = UDim2.new(0, 150, 0, 30)
Day_Button.Font = Enum.Font.Oswald
Day_Button.Text = "Day"
Day_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Day_Button.TextScaled = true
Day_Button.TextSize = 14.000
Day_Button.TextWrapped = true

Night_Button.Name = "Night_Button"
Night_Button.Parent = Misc_Section
Night_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Night_Button.BackgroundTransparency = 0.500
Night_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Night_Button.BorderSizePixel = 0
Night_Button.Position = UDim2.new(0, 210, 0, 125)
Night_Button.Size = UDim2.new(0, 150, 0, 30)
Night_Button.Font = Enum.Font.Oswald
Night_Button.Text = "Night"
Night_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Night_Button.TextScaled = true
Night_Button.TextSize = 14.000
Night_Button.TextWrapped = true

Explode_Button.Name = "Explode_Button"
Explode_Button.Parent = Misc_Section
Explode_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Explode_Button.BackgroundTransparency = 0.500
Explode_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Explode_Button.BorderSizePixel = 0
Explode_Button.Position = UDim2.new(0, 25, 0, 225)
Explode_Button.Size = UDim2.new(0, 150, 0, 30)
Explode_Button.Font = Enum.Font.Oswald
Explode_Button.Text = "Explode"
Explode_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Explode_Button.TextScaled = true
Explode_Button.TextSize = 14.000
Explode_Button.TextWrapped = true

Rejoin_Button.Name = "Rejoin_Button"
Rejoin_Button.Parent = Misc_Section
Rejoin_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Rejoin_Button.BackgroundTransparency = 0.500
Rejoin_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Rejoin_Button.BorderSizePixel = 0
Rejoin_Button.Position = UDim2.new(0, 25, 0, 275)
Rejoin_Button.Size = UDim2.new(0, 150, 0, 30)
Rejoin_Button.Font = Enum.Font.Oswald
Rejoin_Button.Text = "Rejoin"
Rejoin_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Rejoin_Button.TextScaled = true
Rejoin_Button.TextSize = 14.000
Rejoin_Button.TextWrapped = true

CMDX_Button.Name = "CMDX_Button"
CMDX_Button.Parent = Misc_Section
CMDX_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CMDX_Button.BackgroundTransparency = 0.500
CMDX_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMDX_Button.BorderSizePixel = 0
CMDX_Button.Position = UDim2.new(0, 210, 0, 175)
CMDX_Button.Size = UDim2.new(0, 150, 0, 30)
CMDX_Button.Font = Enum.Font.Oswald
CMDX_Button.Text = "CMDX"
CMDX_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
CMDX_Button.TextScaled = true
CMDX_Button.TextSize = 14.000
CMDX_Button.TextWrapped = true

InfYield_Button.Name = "InfYield_Button"
InfYield_Button.Parent = Misc_Section
InfYield_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
InfYield_Button.BackgroundTransparency = 0.500
InfYield_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
InfYield_Button.BorderSizePixel = 0
InfYield_Button.Position = UDim2.new(0, 25, 0, 175)
InfYield_Button.Size = UDim2.new(0, 150, 0, 30)
InfYield_Button.Font = Enum.Font.Oswald
InfYield_Button.Text = "Infinite Yield"
InfYield_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
InfYield_Button.TextScaled = true
InfYield_Button.TextSize = 14.000
InfYield_Button.TextWrapped = true

FreeEmotes_Button.Name = "FreeEmotes_Button"
FreeEmotes_Button.Parent = Misc_Section
FreeEmotes_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FreeEmotes_Button.BackgroundTransparency = 0.500
FreeEmotes_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
FreeEmotes_Button.BorderSizePixel = 0
FreeEmotes_Button.Position = UDim2.new(0, 210, 0, 225)
FreeEmotes_Button.Size = UDim2.new(0, 150, 0, 30)
FreeEmotes_Button.Font = Enum.Font.Oswald
FreeEmotes_Button.Text = "Free emotes"
FreeEmotes_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
FreeEmotes_Button.TextScaled = true
FreeEmotes_Button.TextSize = 14.000
FreeEmotes_Button.TextWrapped = true

Serverhop_Button.Name = "Serverhop_Button"
Serverhop_Button.Parent = Misc_Section
Serverhop_Button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Serverhop_Button.BackgroundTransparency = 0.500
Serverhop_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Serverhop_Button.BorderSizePixel = 0
Serverhop_Button.Position = UDim2.new(0, 210, 0, 275)
Serverhop_Button.Size = UDim2.new(0, 150, 0, 30)
Serverhop_Button.Font = Enum.Font.Oswald
Serverhop_Button.Text = "Server hop"
Serverhop_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Serverhop_Button.TextScaled = true
Serverhop_Button.TextSize = 14.000
Serverhop_Button.TextWrapped = true

ChatBox_Input.Name = "ChatBox_Input"
ChatBox_Input.Parent = Misc_Section
ChatBox_Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ChatBox_Input.BorderColor3 = Color3.fromRGB(0, 255, 255)
ChatBox_Input.Position = UDim2.new(0, 25, 0, 325)
ChatBox_Input.Size = UDim2.new(0, 335, 0, 50)
ChatBox_Input.Font = Enum.Font.Oswald
ChatBox_Input.PlaceholderText = "Chat bypass [You won't get banned for your messages]"
ChatBox_Input.Text = ""
ChatBox_Input.TextColor3 = Color3.fromRGB(0, 255, 255)
ChatBox_Input.TextSize = 14.000
ChatBox_Input.TextWrapped = true
ChatBox_Input.TextXAlignment = Enum.TextXAlignment.Left
ChatBox_Input.TextYAlignment = Enum.TextYAlignment.Top

Credits_Section.Name = "Credits_Section"
Credits_Section.Parent = Background
Credits_Section.Active = true
Credits_Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credits_Section.BackgroundTransparency = 1.000
Credits_Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
Credits_Section.BorderSizePixel = 0
Credits_Section.Position = UDim2.new(0, 105, 0, 30)
Credits_Section.Size = UDim2.new(0, 395, 0, 320)
Credits_Section.Visible = false
Credits_Section.CanvasSize = UDim2.new(0, 0, 0.8, 0)
Credits_Section.ScrollBarThickness = 5

Credits_Label.Name = "Credits_Label"
Credits_Label.Parent = Credits_Section
Credits_Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Credits_Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Credits_Label.BorderSizePixel = 0
Credits_Label.Position = UDim2.new(0, 25, 0, 150)
Credits_Label.Size = UDim2.new(0, 350, 0, 150)
Credits_Label.Font = Enum.Font.SourceSans
Credits_Label.Text = "Made by: MalwareHUB \nDiscord: system_calix\nVersion: "..version
Credits_Label.TextColor3 = Color3.fromRGB(0, 255, 255)
Credits_Label.TextSize = 24.000
Credits_Label.TextWrapped = true
Credits_Label.TextXAlignment = Enum.TextXAlignment.Left
Credits_Label.TextYAlignment = Enum.TextYAlignment.Top

Crown.Name = "Crown"
Crown.Parent = Background
Crown.AnchorPoint = Vector2.new(0.300000012, 0.800000012)
Crown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Crown.BackgroundTransparency = 1.000
Crown.BorderColor3 = Color3.fromRGB(0, 0, 0)
Crown.BorderSizePixel = 0
Crown.Rotation = -20.000
Crown.Size = UDim2.new(0, 75, 0, 75)
Crown.Image = "rbxassetid://12298407748"
Crown.ImageColor3 = Color3.fromRGB(0, 255, 255)

Assets.Name = "Assets"
Assets.Parent = SysBroker

Ticket_Asset.Name = "Ticket_Asset"
Ticket_Asset.Parent = Assets
Ticket_Asset.AnchorPoint = Vector2.new(0, 0.5)
Ticket_Asset.BackgroundTransparency = 1.000
Ticket_Asset.BorderSizePixel = 0
Ticket_Asset.LayoutOrder = 5
Ticket_Asset.Position = UDim2.new(1, 5, 0.5, 0)
Ticket_Asset.Size = UDim2.new(0, 25, 0, 25)
Ticket_Asset.ZIndex = 2
Ticket_Asset.Image = "rbxassetid://3926305904"
Ticket_Asset.ImageColor3 = Color3.fromRGB(255, 0, 0)
Ticket_Asset.ImageRectOffset = Vector2.new(424, 4)
Ticket_Asset.ImageRectSize = Vector2.new(36, 36)

Click_Asset.Name = "Click_Asset"
Click_Asset.Parent = Assets
Click_Asset.AnchorPoint = Vector2.new(0, 0.5)
Click_Asset.BackgroundTransparency = 1.000
Click_Asset.BorderSizePixel = 0
Click_Asset.Position = UDim2.new(1, 5, 0.5, 0)
Click_Asset.Size = UDim2.new(0, 25, 0, 25)
Click_Asset.ZIndex = 2
Click_Asset.Image = "rbxassetid://3926305904"
Click_Asset.ImageColor3 = Color3.fromRGB(100, 100, 100)
Click_Asset.ImageRectOffset = Vector2.new(204, 964)
Click_Asset.ImageRectSize = Vector2.new(36, 36)

Velocity_Asset.AngularVelocity = Vector3.new(0,0,0)
Velocity_Asset.MaxTorque = Vector3.new(50000,50000,50000)
Velocity_Asset.P = 1250
Velocity_Asset.Name = "BreakVelocity"
Velocity_Asset.Parent = Assets

Fly_Pad.Name = "Fly_Pad"
Fly_Pad.Parent = Assets
Fly_Pad.BackgroundTransparency = 1.000
Fly_Pad.Position = UDim2.new(0.1, 0, 0.6, 0)
Fly_Pad.Size = UDim2.new(0, 100, 0, 100)
Fly_Pad.ZIndex = 2
Fly_Pad.Image = "rbxassetid://6764432293"
Fly_Pad.ImageRectOffset = Vector2.new(713, 315)
Fly_Pad.ImageRectSize = Vector2.new(75, 75)
Fly_Pad.Visible = false

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 255))}
UIGradient.Rotation = 45
UIGradient.Parent = Fly_Pad

FlyAButton.Name = "FlyAButton"
FlyAButton.Parent = Fly_Pad
FlyAButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyAButton.BackgroundTransparency = 1.000
FlyAButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlyAButton.BorderSizePixel = 0
FlyAButton.Position = UDim2.new(0, 0, 0, 30)
FlyAButton.Size = UDim2.new(0, 30, 0, 40)
FlyAButton.Font = Enum.Font.Oswald
FlyAButton.Text = ""
FlyAButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyAButton.TextSize = 25.000
FlyAButton.TextWrapped = true

FlyDButton.Name = "FlyDButton"
FlyDButton.Parent = Fly_Pad
FlyDButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyDButton.BackgroundTransparency = 1.000
FlyDButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlyDButton.BorderSizePixel = 0
FlyDButton.Position = UDim2.new(0, 70, 0, 30)
FlyDButton.Size = UDim2.new(0, 30, 0, 40)
FlyDButton.Font = Enum.Font.Oswald
FlyDButton.Text = ""
FlyDButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyDButton.TextSize = 25.000
FlyDButton.TextWrapped = true

FlyWButton.Name = "FlyWButton"
FlyWButton.Parent = Fly_Pad
FlyWButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyWButton.BackgroundTransparency = 1.000
FlyWButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlyWButton.BorderSizePixel = 0
FlyWButton.Position = UDim2.new(0, 30, 0, 0)
FlyWButton.Size = UDim2.new(0, 40, 0, 30)
FlyWButton.Font = Enum.Font.Oswald
FlyWButton.Text = ""
FlyWButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyWButton.TextSize = 25.000
FlyWButton.TextWrapped = true

FlySButton.Name = "FlySButton"
FlySButton.Parent = Fly_Pad
FlySButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlySButton.BackgroundTransparency = 1.000
FlySButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FlySButton.BorderSizePixel = 0
FlySButton.Position = UDim2.new(0, 30, 0, 70)
FlySButton.Size = UDim2.new(0, 40, 0, 30)
FlySButton.Font = Enum.Font.Oswald
FlySButton.Text = ""
FlySButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlySButton.TextSize = 25.000
FlySButton.TextWrapped = true

OpenClose.Name = "OpenClose"
OpenClose.Parent = SysBroker
OpenClose.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
OpenClose.BorderSizePixel = 0
OpenClose.Position = UDim2.new(0, 0, 0.5, 0)
OpenClose.Size = UDim2.new(0, 30, 0, 30)
OpenClose.Image = "rbxassetid://12298407748"
OpenClose.ImageColor3 = Color3.fromRGB(0, 255, 255)

UICornerOC.CornerRadius = UDim.new(1, 0)
UICornerOC.Parent = OpenClose

CreateToggle(AntiRagdoll_Button)
CreateToggle(PushAura_Button)
CreateToggle(SpamMines_Button)
CreateToggle(PotionFling_Button)
CreateToggle(TouchFling_Button)
CreateToggle(PotionDi_Button)
CreateToggle(VoidProtection_Button)
CreateClicker(PushAll_Button)
CreateClicker(BreakCannons_Button)
CreateClicker(LethalCannons_Button)
CreateClicker(ChatAlert_Button)
CreateClicker(FreePushTool_Button)
CreateClicker(CannonTP1_Button)
CreateClicker(CannonTP2_Button)
CreateClicker(CannonTP3_Button)
CreateClicker(MinefieldTP_Button)
CreateClicker(BallonTP_Button)
CreateClicker(NormalStairsTP_Button)
CreateClicker(MovingStairsTP_Button)
CreateClicker(SpiralStairsTP_Button)
CreateClicker(SkyscraperTP_Button)
CreateClicker(PoolTP_Button)

CreateToggle(Fly_Button)
CreateClicker(WalkSpeed_Button)
CreateClicker(ClearCheckpoint_Button)
CreateClicker(JumpPower_Button)
CreateClicker(SaveCheckpoint_Button)
CreateClicker(Respawn_Button)
CreateClicker(FlySpeed_Button)

CreateToggle(ViewTarget_Button)
CreateToggle(FlingTarget_Button)
CreateToggle(FocusTarget_Button)
CreateToggle(BenxTarget_Button)
CreateToggle(HeadsitTarget_Button)
CreateToggle(StandTarget_Button)
CreateToggle(BackpackTarget_Button)
CreateToggle(DoggyTarget_Button)
CreateToggle(DragTarget_Button)
CreateClicker(PushTarget_Button)
CreateClicker(WhitelistTarget_Button)
CreateClicker(TeleportTarget_Button)

CreateClicker(VampireAnim_Button)
CreateClicker(HeroAnim_Button)
CreateClicker(ZombieClassicAnim_Button)
CreateClicker(MageAnim_Button)
CreateClicker(GhostAnim_Button)
CreateClicker(ElderAnim_Button)
CreateClicker(LevitationAnim_Button)
CreateClicker(AstronautAnim_Button)
CreateClicker(NinjaAnim_Button)
CreateClicker(WerewolfAnim_Button)
CreateClicker(CartoonAnim_Button)
CreateClicker(PirateAnim_Button)
CreateClicker(SneakyAnim_Button)
CreateClicker(ToyAnim_Button)
CreateClicker(KnightAnim_Button)
CreateClicker(ConfidentAnim_Button)
CreateClicker(PopstarAnim_Button)
CreateClicker(PrincessAnim_Button)
CreateClicker(CowboyAnim_Button)
CreateClicker(PatrolAnim_Button)
CreateClicker(ZombieFEAnim_Button)

CreateToggle(AntiFling_Button)
CreateToggle(AntiChatSpy_Button)
CreateToggle(AntiAFK_Button)
CreateToggle(Shaders_Button)
CreateClicker(Day_Button)
CreateClicker(Night_Button)
CreateClicker(Rejoin_Button)
CreateClicker(CMDX_Button)
CreateClicker(Explode_Button)
CreateClicker(FreeEmotes_Button)
CreateClicker(InfYield_Button)
CreateClicker(Serverhop_Button)

local function ChangeSection(SectionClicked)
	SectionClickedName = string.split(SectionClicked.Name,"_")[1]
	for i,v in pairs(SectionList:GetChildren()) do
		if v.Name ~= SectionClicked.Name then
			v.Transparency = 0.5
		else
			v.Transparency = 0
		end
	end
	for i,v in pairs(Background:GetChildren()) do
		if v:IsA("ScrollingFrame") then
			SectionForName = string.split(v.Name,"_")[1]
			if string.find(SectionClickedName, SectionForName) then
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end
end

local function UpdateTarget(player)
	pcall(function()
		if table.find(ForceWhitelist,player.UserId) then
			SendNotify("System Broken","You cant target this player: @"..player.Name.." / "..player.DisplayName,5)
			player = nil
		end
	end)
	if (player ~= nil) then
		TargetedPlayer = player.Name
		TargetName_Input.Text = player.Name
		UserIDTargetLabel.Text = ("UserID: "..player.UserId.."\nDisplay: "..player.DisplayName.."\nJoined: "..os.date("%d-%m-%Y", os.time()-player.AccountAge * 24 * 3600).." [Day/Month/Year]")
		TargetImage.Image = Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
	else
		TargetName_Input.Text = "@target..."
		UserIDTargetLabel.Text = "UserID: \nDisplay: \nJoined: "
		TargetImage.Image = "rbxassetid://10818605405"
		TargetedPlayer = nil
		if FlingTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			FlingTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
			TouchFling_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		end
		ViewTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		FocusTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		BenxTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		HeadsitTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		StandTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		BackpackTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		DoggyTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		DragTarget_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
	end
end

local function ToggleFling(bool)
	task.spawn(function()
		if bool then
			local RVelocity = nil
			repeat
				pcall(function()
					RVelocity = GetRoot(plr).Velocity 
					GetRoot(plr).Velocity = Vector3.new(math.random(-150,150),-25000,math.random(-150,150))
					RunService.RenderStepped:wait()
					GetRoot(plr).Velocity = RVelocity
				end)
				RunService.Heartbeat:wait()
			until TouchFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
		else
			TouchFling_Button.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
		end
	end)
end

--CHANGE SECTION BUTTONS
ChangeSection(Home_Section_Button)
Home_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Home_Section_Button)
end)

Game_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Game_Section_Button)
end)

Character_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Character_Section_Button)
end)

Target_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Target_Section_Button)
end)

Animations_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Animations_Section_Button)
end)

Misc_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Misc_Section_Button)
end)

Credits_Section_Button.MouseButton1Click:Connect(function()
	ChangeSection(Credits_Section_Button)
end)

--GAME SECTION BUTTONS
AntiRagdollFunction = nil
AntiRagdoll_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(AntiRagdoll_Button)
	ToggleRagdoll(true)
	if AntiRagdoll_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		AntiRagdollFunction = GetRoot(plr).ChildAdded:Connect(function(Force)
			if Force.Name == "PushForce" then
				Force.MaxForce = Vector3.new(0,0,0)
				Force.Velocity = Vector3.new(0,0,0)
			end
		end)
	else
		ToggleRagdoll(false)
		AntiRagdollFunction:Disconnect()
	end
end)

PushAura_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(PushAura_Button)
	if PushAura_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		repeat
			task.wait(0.3)
			pcall(function()
				for i,v in pairs(Players:GetPlayers()) do
					if (v ~= plr) and (not table.find(ScriptWhitelist,v.UserId)) and (not table.find(ForceWhitelist,v.UserId)) then
						Push(v)
					end
				end
			end)
		until PushAura_Button.Ticket_Asset.ImageColor3 ~= Color3.fromRGB(0,255,0)
	end
end)

AntiMinesFunction = nil
SpamMines_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(SpamMines_Button)
	if SpamMines_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		AntiMinesFunction = plr.Character.Head.ChildAdded:Connect(function(Force)
			if Force.Name == "BodyVelocity" then
				Force.MaxForce = Vector3.new(0,0,0)
				Force.Velocity = Vector3.new(0,0,0)
			end
		end)
		repeat task.wait(1)
			for i,v in pairs(MinesFolder:GetChildren()) do
				if v.Name == "Landmine" and v:FindFirstChild("HitPart") then
					pcall(function()
						Touch(v.HitPart.TouchInterest,GetRoot(plr))
					end)
				end
			end
		until SpamMines_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
	else
		AntiMinesFunction:Disconnect()
	end
end)

PotionFling_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(PotionFling_Button)
	if PotionFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		if CheckPotion() then
			if PotionDi_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
				ChangeToggleColor(PotionDi_Button)
			end
			PotionTool.Parent = plr.Character
			local PFS, PFF = pcall(function()
				PotionTool.InSide.Massless = true
				PotionTool.Cap.Massless = true
				PotionTool.Handle.Massless = true
				PotionTool.GripUp = Vector3.new(0,1,0)
				PotionTool.GripPos = Vector3.new(5000,-25,5000)
				PotionTool.Parent = plr.Backpack
				PotionTool.Parent = plr.Character
			end)
		else
			ChangeToggleColor(PotionFling_Button)
		end
	else
		PotionTool.Parent = plr.Character
		local PFS, PFF = pcall(function()
			PotionTool.InSide.Massless = false
			PotionTool.Cap.Massless = false
			PotionTool.Handle.Massless = false
			PotionTool.GripUp = Vector3.new(0,1,0)
			PotionTool.GripPos = Vector3.new(0.1,-0.5,0)
			PotionTool.Parent = plr.Backpack
			PotionTool.Parent = plr.Character
		end)
	end
end)

TouchFling_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(TouchFling_Button)
	if TouchFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		local fixpos = GetRoot(plr).Position
		ToggleVoidProtection(true)
		ToggleFling(true)
		TeleportTO(fixpos.X,fixpos.Y,fixpos.Z,"pos","safe")
		ToggleVoidProtection(false)
		if VoidProtection_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			ToggleVoidProtection(true)
		end
	else
		if FlingTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			ChangeToggleColor(FlingTarget_Button)
		end
	end
end)

PotionDi_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(PotionDi_Button)
	if PotionDi_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		if CheckPotion() then
			if PotionFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
				ChangeToggleColor(PotionFling_Button)
			end
			PotionTool.Parent = plr.Character
			PotionTool.GripUp = Vector3.new(1,0,0)
			PotionTool.GripPos = Vector3.new(1.5, 0.5, -1.5)
			PotionTool.Parent = plr.Backpack
			PotionTool.Parent = plr.Character
		else
			ChangeToggleColor(PotionDi_Button)
		end
	else
		PotionTool.Parent = plr.Character
		PotionTool.GripUp = Vector3.new(0,1,0)
		PotionTool.GripPos = Vector3.new(0.1,-0.5,0)
		PotionTool.Parent = plr.Backpack
		PotionTool.Parent = plr.Character
	end
end)

VoidProtection_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(VoidProtection_Button)
	if VoidProtection_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ToggleVoidProtection(true)
	else
		ToggleVoidProtection(false)
	end
end)

FreePushTool_Button.MouseButton1Click:Connect(function()
	local ModdedPush = Instance.new("Tool")
	ModdedPush.Name = "ModdedPush"
	ModdedPush.RequiresHandle = false
	ModdedPush.TextureId = "rbxassetid://14478599909"
	ModdedPush.ToolTip = "Modded push"

	local function ActivateTool()
		local root = GetRoot(plr)
		local hit = mouse.Target
		local person = nil
		if hit and hit.Parent then
			if hit.Parent:IsA("Model") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent)
			elseif hit.Parent:IsA("Accessory") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
			end
			if person then
				local pushpos = root.CFrame
				PredictionTP(person)
				task.wait(GetPing()+0.05)
				Push(person)
				root.CFrame = pushpos
			end
		end
	end

	ModdedPush.Activated:Connect(function()
		ActivateTool()
	end)
	ModdedPush.Parent = plr.Backpack
end)

BreakCannons_Button.MouseButton1Click:Connect(function()
	ToggleVoidProtection(true)
	TeleportTO(0,-10000,0,"pos")
	task.wait(GetPing()+0.1)
	ToggleVoidProtection(false)
	task.wait(GetPing()+0.1)
	for i,v in pairs(CannonsFolders[1]:GetChildren()) do
		if v.Name == "Cannon" then
			pcall(function()
				fireclickdetector(v.Cannon_Part.ClickDetector)
			end)
		end
	end
	for i,v in pairs(CannonsFolders[2]:GetChildren()) do
		if v.Name == "Cannon" then
			pcall(function()
				fireclickdetector(v.Cannon_Part.ClickDetector)
			end)
		end
	end

	if VoidProtection_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ToggleVoidProtection(true)
	end
end)

PushAll_Button.MouseButton1Click:Connect(function()
	local oldpos = GetRoot(plr).Position
	for i,v in pairs(Players:GetPlayers()) do
		pcall(function()
			if (v ~= plr) and (not table.find(ScriptWhitelist,v.UserId)) and (not table.find(ForceWhitelist,v.UserId)) then
				PredictionTP(v)
				task.wait(GetPing()+0.05)
				Push(v)
			end
		end)
	end
	TeleportTO(oldpos.X,oldpos.Y,oldpos.Z,"pos","safe")
end)

LethalCannons_Button.MouseButton1Click:Connect(function()
	for i,v in pairs(CannonsFolders[1]:GetChildren()) do
		if v.Name == "Cannon" then
			pcall(function()
				plr.Character.Humanoid:ChangeState(15)
				task.wait(GetPing())
				fireclickdetector(v.Cannon_Part.ClickDetector)
				plr.CharacterAdded:Wait()
				task.wait(1)
			end)
		end
	end
	for i,v in pairs(CannonsFolders[2]:GetChildren()) do
		if v.Name == "Cannon" then
			pcall(function()
				plr.Character.Humanoid:ChangeState(15)
				task.wait(GetPing())
				fireclickdetector(v.Cannon_Part.ClickDetector)
				plr.CharacterAdded:Wait()
				task.wait(1)
			end)
		end
	end
end)

ChatAlert_Button.MouseButton1Click:Connect(function()
	for i = 1,3 do
		local args = {[1] = "\u{205F}",[2] = "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
	end
end)

CannonTP1_Button.MouseButton1Click:Connect(function()
	TeleportTO(-61, 34, -228,"pos","safe")
end)

CannonTP2_Button.MouseButton1Click:Connect(function()
	TeleportTO(50, 34, -228,"pos","safe")
end)

CannonTP3_Button.MouseButton1Click:Connect(function()
	TeleportTO(-6, 35, -106,"pos","safe")
end)

MinefieldTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(-65, 23, -151,"pos","safe")
end)

BallonTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(-118, 23, -126,"pos","safe")
end)

NormalStairsTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(-6, 203, -496,"pos","safe")
end)

MovingStairsTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(-210, 87, -224,"pos","safe")
end)

SpiralStairsTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(151, 847, -306,"pos","safe")
end)

SkyscraperTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(142, 1033, -192,"pos","safe")
end)

PoolTP_Button.MouseButton1Click:Connect(function()
	TeleportTO(-133, 65, -321,"pos","safe")
end)

CMDBar.FocusLost:Connect(function()
	command = CMDBar.Text
	Players:Chat(command)
	SendNotify("System Broken",("Executed "..command),5)
	CMDBar.Text = ""
end)

--CHARACTER SECTION

WalkSpeed_Button.MouseButton1Click:Connect(function()
	pcall(function()
		local Speed = WalkSpeed_Input.Text:gsub("%D", "")
		if Speed == "" then
			Speed = 16
		end
		plr.Character.Humanoid.WalkSpeed = tonumber(Speed)
		SendNotify("System Broken","Walk speed updated.",5)
	end)
end)

JumpPower_Button.MouseButton1Click:Connect(function()
	pcall(function()
		local Power = JumpPower_Input.Text:gsub("%D", "")
		if Power == "" then
			Power = 50
		end
		plr.Character.Humanoid.JumpPower = tonumber(Power)
		SendNotify("System Broken","Jump power updated.",5)
	end)
end)

FlySpeed_Button.MouseButton1Click:Connect(function()
	pcall(function()
		local Speed = FlySpeed_Input.Text:gsub("%D", "")
		if Speed == "" then
			Speed = 50
		end
		FlySpeed = tonumber(Speed)
		SendNotify("System Broken","Fly speed updated.",5)
	end)
end)

Respawn_Button.MouseButton1Click:Connect(function()
	local RsP = GetRoot(plr).Position
	plr.Character.Humanoid.Health = 0
	plr.CharacterAdded:wait(); task.wait(GetPing()+0.1)
	TeleportTO(RsP.X,RsP.Y,RsP.Z,"pos","safe")
end)

SaveCheckpoint_Button.MouseButton1Click:Connect(function()
	SavedCheckpoint = GetRoot(plr).Position
	SendNotify("System Broken","Checkpoint saved.",5)
end)

ClearCheckpoint_Button.MouseButton1Click:Connect(function()
	SavedCheckpoint = nil
	SendNotify("System Broken","Checkpoint cleared.",5)
end)

local flying = true
local deb = true
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local KeyDownFunction = nil
local KeyUpFunction = nil
Fly_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(Fly_Button)
	if Fly_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		flying = true
		if game:GetService("UserInputService").TouchEnabled then
			Fly_Pad.Visible = true
		end
		local UpperTorso = plr.Character.UpperTorso
		local speed = 0
		local function Fly()
			local bg = Instance.new("BodyGyro", UpperTorso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = UpperTorso.CFrame
			local bv = Instance.new("BodyVelocity", UpperTorso)
			bv.velocity = Vector3.new(0,0.1,0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			PlayAnim(10714347256,4,0)
			repeat task.wait()
				plr.Character.Humanoid.PlatformStand = true
				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed+FlySpeed*0.10
					if speed > FlySpeed then
						speed = FlySpeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed-FlySpeed*0.10
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
					lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				else
					bv.velocity = Vector3.new(0,0.1,0)
				end
				bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/FlySpeed),0,0)
			until not flying
			ctrl = {f = 0, b = 0, l = 0, r = 0}
			lastctrl = {f = 0, b = 0, l = 0, r = 0}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			plr.Character.Humanoid.PlatformStand = false
		end

		KeyDownFunction = mouse.KeyDown:connect(function(key)
			if key:lower() == "w" then
				ctrl.f = 1
				PlayAnim(10714177846,4.65,0)
			elseif key:lower() == "s" then
				ctrl.b = -1
				PlayAnim(10147823318,4.11,0)
			elseif key:lower() == "a" then
				ctrl.l = -1
				PlayAnim(10147823318,3.55,0)
			elseif key:lower() == "d" then
				ctrl.r = 1
				PlayAnim(10147823318,4.81,0)
			end
		end)

		KeyUpFunction = mouse.KeyUp:connect(function(key)
			if key:lower() == "w" then
				ctrl.f = 0
				PlayAnim(10714347256,4,0)
			elseif key:lower() == "s" then
				ctrl.b = 0
				PlayAnim(10714347256,4,0)
			elseif key:lower() == "a" then
				ctrl.l = 0
				PlayAnim(10714347256,4,0)
			elseif key:lower() == "d" then
				ctrl.r = 0
				PlayAnim(10714347256,4,0)
			end
		end)
		Fly()
	else
		flying = false
		Fly_Pad.Visible = false
		KeyDownFunction:Disconnect()
		KeyUpFunction:Disconnect()
		StopAnim()
	end
end)

FlyAButton.MouseButton1Down:Connect(function()
	keypress("0x41")
end)
FlyAButton.MouseButton1Up:Connect(function ()
	keyrelease("0x41")
end)

FlySButton.MouseButton1Down:Connect(function()
	keypress("0x53")
end)
FlySButton.MouseButton1Up:Connect(function ()
	keyrelease("0x53")
end)

FlyDButton.MouseButton1Down:Connect(function()
	keypress("0x44")
end)
FlyDButton.MouseButton1Up:Connect(function ()
	keyrelease("0x44")
end)

FlyWButton.MouseButton1Down:Connect(function()
	keypress("0x57")
end)
FlyWButton.MouseButton1Up:Connect(function ()
	keyrelease("0x57")
end)

--TARGET
ClickTargetTool_Button.MouseButton1Click:Connect(function()
	local GetTargetTool = Instance.new("Tool")
	GetTargetTool.Name = "ClickTarget"
	GetTargetTool.RequiresHandle = false
	GetTargetTool.TextureId = "rbxassetid://2716591855"
	GetTargetTool.ToolTip = "Select Target"

	local function ActivateTool()
		local root = GetRoot(plr)
		local hit = mouse.Target
		local person = nil
		if hit and hit.Parent then
			if hit.Parent:IsA("Model") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent)
			elseif hit.Parent:IsA("Accessory") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
			end
			if person then
				UpdateTarget(person)
			end
		end
	end

	GetTargetTool.Activated:Connect(function()
		ActivateTool()
	end)
	GetTargetTool.Parent = plr.Backpack
end)

FlingTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(FlingTarget_Button)
		if FlingTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			if TouchFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0) then
				ChangeToggleColor(TouchFling_Button)
			end
			local OldPos = GetRoot(plr).Position
			ToggleFling(true)
			repeat task.wait()
				pcall(function()
					PredictionTP(Players[TargetedPlayer],"safe")
				end)
				task.wait()
			until FlingTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			TeleportTO(OldPos.X,OldPos.Y,OldPos.Z,"pos","safe")
		else
			ToggleFling(false)
		end
	end
end)

ViewTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(ViewTarget_Button)
		if ViewTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			repeat
				pcall(function()
					game.Workspace.CurrentCamera.CameraSubject = Players[TargetedPlayer].Character.Humanoid
				end)
				task.wait(0.5)
			until ViewTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
		end
	end
end)

FocusTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(FocusTarget_Button)
		if FocusTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			repeat
				pcall(function()
					local target = Players[TargetedPlayer]
					TeleportTO(0,0,0,target)
					Push(Players[TargetedPlayer])
				end)
				task.wait(0.2)
			until FocusTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
		end
	end
end)

BenxTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(BenxTarget_Button)
		if BenxTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			PlayAnim(5918726674,0,1)
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local otherRoot = GetRoot(Players[TargetedPlayer])
					GetRoot(plr).CFrame = otherRoot.CFrame * CFrame.new(0,0,1.1)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until BenxTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			StopAnim()
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

HeadsitTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(HeadsitTarget_Button)
		if HeadsitTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local targethead = Players[TargetedPlayer].Character.Head
					plr.Character.Humanoid.Sit = true
					GetRoot(plr).CFrame = targethead.CFrame * CFrame.new(0,2,0)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until HeadsitTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

StandTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(StandTarget_Button)
		if StandTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			PlayAnim(13823324057,4,0)
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local root = GetRoot(Players[TargetedPlayer])
					GetRoot(plr).CFrame = root.CFrame * CFrame.new(-3,1,0)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until StandTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			StopAnim()
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

BackpackTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(BackpackTarget_Button)
		if BackpackTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local root = GetRoot(Players[TargetedPlayer])
					plr.Character.Humanoid.Sit = true
					GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,0,1.2) * CFrame.Angles(0, -3, 0)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until BackpackTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

DoggyTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(DoggyTarget_Button)
		if DoggyTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			PlayAnim(13694096724,3.4,0)
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local root = Players[TargetedPlayer].Character.LowerTorso
					GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,0.23,0)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until DoggyTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			StopAnim()
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

DragTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		ChangeToggleColor(DragTarget_Button)
		if DragTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
			PlayAnim(10714360343,0.5,0)
			repeat
				pcall(function()
					if not GetRoot(plr):FindFirstChild("BreakVelocity") then
						pcall(function()
							local TempV = Velocity_Asset:Clone()
							TempV.Parent = GetRoot(plr)
						end)
					end
					local root = Players[TargetedPlayer].Character.RightHand
					GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,-2.5,1) * CFrame.Angles(-2, -3, 0)
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
				end)
				task.wait()
			until DragTarget_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
			StopAnim()
			if GetRoot(plr):FindFirstChild("BreakVelocity") then
				GetRoot(plr).BreakVelocity:Destroy()
			end
		end
	end
end)

PushTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		local pushpos = GetRoot(plr).CFrame
		PredictionTP(Players[TargetedPlayer])
		task.wait(GetPing()+0.05)
		Push(Players[TargetedPlayer])
		GetRoot(plr).CFrame = pushpos
	end
end)

TeleportTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		TeleportTO(0,0,0,Players[TargetedPlayer],"safe")
	end
end)

WhitelistTarget_Button.MouseButton1Click:Connect(function()
	if TargetedPlayer ~= nil then
		if table.find(ScriptWhitelist, Players[TargetedPlayer].UserId) then
			for i,v in pairs(ScriptWhitelist) do
				if v == Players[TargetedPlayer].UserId then
					table.remove(ScriptWhitelist, i)
				end
			end
			SendNotify("System Broken",TargetedPlayer.." removed from whitelist.",5)
		else
			table.insert(ScriptWhitelist, Players[TargetedPlayer].UserId)
			SendNotify("System Broken",TargetedPlayer.." added to whitelist.", 5)
		end
	end
end)

TargetName_Input.FocusLost:Connect(function()
	local LabelText = TargetName_Input.Text
	local LabelTarget = GetPlayer(LabelText)
	UpdateTarget(LabelTarget)
end)

--ANIMATIONS

VampireAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

HeroAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

ZombieClassicAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

MageAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

GhostAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

ElderAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

LevitationAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

AstronautAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=891621366"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=891633237"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=891667138"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=891636393"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=891627522"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=891609353"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=891617961"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

NinjaAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

WerewolfAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083178339"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083216690"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083189019"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

CartoonAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

PirateAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

SneakyAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1132473842"
    Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1132477671"
    Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1132510133"
    Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1132494274"
    Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1132489853"
    Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1132461372"
    Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1132469004"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

ToyAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

KnightAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

--NEWS
ConfidentAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1069977950"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1069987858"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1070017263"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1070001516"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1069984524"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1069946257"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1069973677"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

PopstarAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1212900985"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1212900985"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980338"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980348"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1212954642"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1213044953"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1212900995"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

PrincessAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=941003647"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=941013098"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=941028902"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=941015281"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=941008832"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=940996062"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=941000007"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

CowboyAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1014390418"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1014398616"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1014421541"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1014401683"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1014394726"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1014380606"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1014384571"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

PatrolAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1149612882"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1150842221"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1151231493"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1150967949"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1150944216"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1148811837"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1148863382"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

ZombieFEAnim_Button.MouseButton1Click:Connect(function()
	local Animate = plr.Character.Animate
	Animate.Disabled = true
	StopAnim()
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=3489171152"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=3489171152"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=3489174223"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=3489173414"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
	plr.Character.Humanoid:ChangeState(3)
	Animate.Disabled = false
end)

--MISC

AntiFling_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(AntiFling_Button)
	if AntiFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		_G.AntiFlingToggled = true
		loadstring(game:HttpGet('https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AntiFling'))()
	else
		_G.AntiFlingToggled = false
	end
end)

AntiChatSpy_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(AntiChatSpy_Button)
	if AntiChatSpy_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		repeat task.wait()
			Players:Chat(RandomChar())
		until AntiChatSpy_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
	end
end)

local AntiAFKFunction = nil
AntiAFK_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(AntiAFK_Button)
	if AntiAFK_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		AntiAFKFunction = plr.Idled:Connect(function()
			local VirtualUser = game:GetService("VirtualUser")
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	else
		AntiAFKFunction:Disconnect()
	end
end)

Shaders_Button.MouseButton1Click:Connect(function()
	ChangeToggleColor(Shaders_Button)
	if Shaders_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		local Sky = Instance.new("Sky")
		local Bloom = Instance.new("BloomEffect")
		local Blur = Instance.new("BlurEffect")
		local ColorC = Instance.new("ColorCorrectionEffect")
		local SunRays = Instance.new("SunRaysEffect")

		Light.Brightness = 2.25
		Light.ExposureCompensation = 0.1
		Light.ClockTime = 17.55

		Sky.SkyboxBk = "http://www.roblox.com/asset/?id=144933338"
		Sky.SkyboxDn = "http://www.roblox.com/asset/?id=144931530"
		Sky.SkyboxFt = "http://www.roblox.com/asset/?id=144933262"
		Sky.SkyboxLf = "http://www.roblox.com/asset/?id=144933244"
		Sky.SkyboxRt = "http://www.roblox.com/asset/?id=144933299"
		Sky.SkyboxUp = "http://www.roblox.com/asset/?id=144931564"
		Sky.StarCount = 5000
		Sky.SunAngularSize = 5
		Sky.Parent = Light

		Bloom.Intensity = 0.3
		Bloom.Size = 10
		Bloom.Threshold = 0.8
		Bloom.Parent = Light

		Blur.Size = 5
		Blur.Parent = Light

		ColorC.Brightness = 0
		ColorC.Contrast = 0.1
		ColorC.Saturation = 0.25
		ColorC.TintColor = Color3.fromRGB(255, 255, 255)
		ColorC.Parent = Light

		SunRays.Intensity = 0.1
		SunRays.Spread = 0.8
		SunRays.Parent = Light
	else
		for i,v in pairs(Light:GetChildren()) do
			v:Destroy()
		end
		Light.Brightness = 2
		Light.ExposureCompensation = 0
	end
end)

Day_Button.MouseButton1Click:Connect(function()
	if Shaders_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0) then
		game:GetService("Lighting").ClockTime = 14
	else
		SendNotify("System Broken","Please turn off shaders.",5)
	end
end)

Night_Button.MouseButton1Click:Connect(function()
	if Shaders_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0) then
		game:GetService("Lighting").ClockTime = 19
	else
		SendNotify("System Broken","Please turn off shaders.",5)
	end
end)

InfYield_Button.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

CMDX_Button.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))()
end)

Explode_Button.MouseButton1Click:Connect(function()
	ToggleRagdoll(false)
	task.wait()
	plr.Character.Humanoid:ChangeState(0)
	local bav = Instance.new("BodyAngularVelocity")
	bav.Parent = GetRoot(plr)
	bav.Name = "Spin"
	bav.MaxTorque = Vector3.new(0,math.huge,0)
	bav.AngularVelocity = Vector3.new(0,150,0)
	task.wait(3)
	plr.Character.Humanoid:ChangeState(15)
end)

FreeEmotes_Button.MouseButton1Click:Connect(function()
	if not FreeEmotesEnabled then
		FreeEmotesEnabled = true
		SendNotify("System Broken","Loading free emotes.\nCredits: Gi#7331")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AllEmotes"))()
	end
end)

Rejoin_Button.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

Serverhop_Button.MouseButton1Click:Connect(function()
	if httprequest then
		local servers = {}
		local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)})
		local body = HttpService:JSONDecode(req.Body)
		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, 1, v.id)
				end
			end
		end
		if #servers > 0 then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
		end
	end
end)

ChatBox_Input.FocusLost:Connect(function()
	local args = {[1] = ChatBox_Input.Text,[2] = "All"}
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
	ChatBox_Input.Text = ""
end)

--GUI Functions
Players.PlayerRemoving:Connect(function(player)
	pcall(function()
		if player.Name == TargetedPlayer then
			UpdateTarget(nil)
			SendNotify("System Broken","Targeted player left/rejoined.",5)
		end
	end)
end)

plr.CharacterAdded:Connect(function(x)
	task.wait(GetPing()+0.1)
	x:WaitForChild("Humanoid")
	if SavedCheckpoint ~= nil then
		TeleportTO(SavedCheckpoint.X,SavedCheckpoint.Y,SavedCheckpoint.Z,"pos","safe")
	end
	if PotionDi_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ChangeToggleColor(PotionDi_Button)
		SendNotify("System Broken","PotionDick was automatically disabled due to your character respawn",5)
	end
	if PotionFling_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ChangeToggleColor(PotionFling_Button)
		SendNotify("System Broken","PotionFling was automatically disabled due to your character respawn",5)
	end
	if AntiRagdoll_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ChangeToggleColor(AntiRagdoll_Button)
		SendNotify("System Broken","AntiRagdoll was automatically disabled due to your character respawn",5)
	end
	if SpamMines_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ChangeToggleColor(SpamMines_Button)
		SendNotify("System Broken","SpamMines was automatically disabled due to your character respawn",5)
	end
	if Fly_Button.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
		ChangeToggleColor(Fly_Button)
		flying = false
		Fly_Pad.Visible = false
		KeyDownFunction:Disconnect()
		KeyUpFunction:Disconnect()
		SendNotify("System Broken","Fly was automatically disabled due to your character respawn",5)
	end
	x.Humanoid.Died:Connect(function()
		pcall(function()
			x["Pushed"].Disabled = false
			x["RagdollMe"].Disabled = false
		end)
	end)
	task.wait(1)
	local appearance = players:GetCharacterAppearanceAsync(plr.UserId)
	local original_accs = {}
	local accs = {}
	for i,acc in pairs(appearance:GetChildren()) do --Save original accessoryes
		if acc:IsA("Accessory") then
			table.insert(original_accs, acc.Name)
		end
	end
	for i,acc in pairs(plr.Character:GetChildren()) do --Save player accessoryes
		if acc:IsA("Accessory") then
			table.insert(accs, acc.Name)
		end
	end
	
	local original_ammount = #original_accs
	local ammount = #accs
	if ammount == original_ammount then
		local count = 0
		for i,v in pairs(accs) do
			if table.find(original_accs, v) then
				count = count+1
			end
		end
		if not (count == original_ammount) then
			SysBroker:Destroy()
			SendNotify("System Broken","An unexpected error occurred, re-joining...")
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
		end
	else
		SysBroker:Destroy()
		SendNotify("System Broken","An unexpected error occurred, re-joining...")
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end
	appearance:Destroy()
end)

task.spawn(function()
	while task.wait(10) do
		pcall(function()
			local GuiVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/version"))()
			if version<GuiVersion then
				SendNotify("System Broken","You are not using the latest version, please run the script again.",5)
				task.wait(5)
				SysBroker:Destroy()
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
			end
		end)
	end
end)

OpenClose.MouseButton1Click:Connect(function()
	Background.Visible = not Background.Visible
end)

game:GetService("UserInputService").InputBegan:Connect(function(input,gameProcessedEvent)
	if gameProcessedEvent then return end
	if input.KeyCode == Enum.KeyCode.B then
		Background.Visible = not Background.Visible
	end
end)

task.spawn(function()
	while task.wait(60) do
		pcall(function()
			local age = plr.AccountAge
			local date_1 = os.date("%Y-%m-%d", os.time()-age * 24 * 3600)
			local date_2 = os.date("%Y-%m-%d", os.time()-(age+1) * 24 * 3600)
			local date_3 = os.date("%Y-%m-%d", os.time()-(age-1) * 24 * 3600)

			local info = game:HttpGet("https://users.roblox.com/v1/users/"..plr.UserId)
			local decode = game:GetService("HttpService"):JSONDecode(info)
			local original_name = decode["name"]
			local original_display = decode["displayName"]
			local original_date = decode["created"]:sub(1,10)

			if (plr.Name ~= original_name) or (plr.DisplayName ~= original_display) or (plr.UserId ~= plr.CharacterAppearanceId) then
				SysBroker:Destroy()
				SendNotify("System Broken","An unexpected error occurred, re-joining...")
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
			end
			if (date_1 ~= original_date) and (date_2 ~= original_date) and (date_3 ~= original_date) then
				SysBroker:Destroy()
				SendNotify("System Broken","An unexpected error occurred, re-joining...")
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
			end
		end)
	end
end)

SendNotify("System Broken","Gui developed by MalwareHub - Discord in your clipboard",10)
setclipboard("https://discord.gg/RkhpySwNR9")
loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/premium"))() -- load the premium
