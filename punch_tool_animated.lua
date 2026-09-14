-- Guest 1337 Punch (Animated Version with Lunge and Hitbox)
-- Roblox 2014-style Tool script with animations

local tool = script.Parent
local handle = tool:FindFirstChild("Handle")

local attacking = false
local coolingDown = false
local alreadyHit = nil

local DAMAGE = 20
local ATTACK_TIME = 0.30
local COOLDOWN = 0.70
local LUNGE_SPEED = 100
local LUNGE_TIME = 0.25

local punchAnimation = nil
local animationTrack = nil
local hitbox = nil

-- Create hitbox as SelectionBox
local function createHitbox()
	if hitbox then
		hitbox:Destroy()
	end
	
	hitbox = Instance.new("SelectionBox")
	hitbox.Adornee = handle
	hitbox.Color3 = Color3.new(1, 0, 0) -- Red
	hitbox.LineThickness = 0.1
	hitbox.Parent = handle
end

-- Show hitbox during attack
local function showHitbox()
	if hitbox then
		hitbox.Visible = true
	end
end

-- Hide hitbox after attack
local function hideHitbox()
	if hitbox then
		hitbox.Visible = false
	end
end

-- Lunge forward with CFrame animation
local function lungePunch(character)
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	local startCFrame = humanoidRootPart.CFrame
	local direction = humanoidRootPart.CFrame.lookVector
	local endCFrame = startCFrame + direction * LUNGE_SPEED * LUNGE_TIME
	
	local startTime = tick()
	
	while tick() - startTime < LUNGE_TIME and attacking do
		local elapsed = tick() - startTime
		local progress = elapsed / LUNGE_TIME
		
		-- Linear interpolation of CFrame
		humanoidRootPart.CFrame = startCFrame:lerp(endCFrame, progress)
		
		wait()
	end
end

-- Initialize animations
local function setupAnimations()
	local character = tool.Parent
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	-- Create or get Animator
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	
	local animator = humanoid:FindFirstChild("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
end

-- Play punch animation
local function playPunchAnimation()
	-- Animation playback would go here if using AnimationTrack
end

-- Stop punch animation
local function stopPunchAnimation()
	-- Animation stop would go here
end

if handle then

	-- Create hitbox on load
	createHitbox()
	hideHitbox()

	handle.Touched:connect(function(part)

		if attacking == false then
			return
		end

		if not part then
			return
		end

		local targetCharacter = part.Parent

		if not targetCharacter then
			return
		end

		-- Do not punch yourself
		if targetCharacter == tool.Parent then
			return
		end

		local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")

		if targetHumanoid and targetHumanoid ~= alreadyHit then
			alreadyHit = targetHumanoid

			-- Damage the other player
			targetHumanoid:TakeDamage(DAMAGE)
		end
	end)


	tool.Activated:connect(function()

		if coolingDown == true then
			return
		end

		coolingDown = true
		attacking = true
		alreadyHit = nil

		-- Show hitbox
		showHitbox()

		-- Play the punch animation
		playPunchAnimation()

		-- Start lunge
		local character = tool.Parent
		if character then
			spawn(function()
				lungePunch(character)
			end)
		end

		-- The punch can damage during this short window
		wait(ATTACK_TIME)

		attacking = false

		-- Hide hitbox
		hideHitbox()

		-- Remaining cooldown
		wait(COOLDOWN)

		coolingDown = false
	end)

	-- Setup animations when tool is equipped
	tool.Equipped:connect(function()
		setupAnimations()
	end)

	-- Cleanup when tool is unequipped
	tool.Unequipped:connect(function()
		stopPunchAnimation()
		hideHitbox()
	end)

end
