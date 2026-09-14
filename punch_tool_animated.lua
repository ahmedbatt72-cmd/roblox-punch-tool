-- Guest 1337 Punch (Animated Version with Lunge and Hitbox)
-- Roblox 2014-style Tool script

local tool = script.Parent
local handle = tool:FindFirstChild("Handle")

local attacking = false
local coolingDown = false
local alreadyHit = nil

local DAMAGE = 20
local ATTACK_TIME = 0.30
local COOLDOWN = 0.70

local hitbox = nil

-- Create hitbox as SelectionBox
local function createHitbox()
	if hitbox then
		hitbox:Destroy()
	end
	
	hitbox = Instance.new("SelectionBox")
	hitbox.Adornee = handle
	hitbox.Color = BrickColor.new("Really red")
	hitbox.Parent = handle
	hitbox.Visible = false
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

if handle then

	-- Create hitbox on load
	createHitbox()

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

		-- The punch can damage during this short window
		wait(ATTACK_TIME)

		attacking = false

		-- Hide hitbox
		hideHitbox()

		-- Remaining cooldown
		wait(COOLDOWN)

		coolingDown = false
	end)

	-- Cleanup when tool is unequipped
	tool.Unequipped:connect(function()
		hideHitbox()
		attacking = false
	end)

end
