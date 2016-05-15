
	-- grass setup
grass_controller 		= {}
grass_controller.cuts 	= {}
grass_controller.image  = love.graphics.newImage("images/cut.png")

	-- Level setup
 -- level_controller 			  = {}
 -- level_controller.currentLevel = 1
 -- levels 		  	 			  = {}
 -- levels.level1 	 			  = { 0, -1, -1, -1, -1,  1, -1, -1,  1,  3 }
 -- levels.level2 			      = { 0, -1,  1, -1, -1,  1, -1, -1,  1,  3 }
 -- levels.level3				  = { 0,  1, -1,  1, -1, -1,  1,  2, -2,  3 }
 -- levels.level4	 			  = { 0,  2, -1,  2, -1,  1,  1,  1,  1,  3 }
 -- levels.level5	 			  = { 0,  2,  1,  2,  1,  2,  1,  2,  1,  3 }

	-- Point to point collision detection
function detectCollision(Player, entity)
    local dx = entity.x - (player.x)
    local dy = entity.y - (player.y)
    return dx^2 + dy^2 <= (player.rad + entity.rad)^2
end

	-- enemy_controller setup
firstSpawn					   = true
-- enemiesSpawned				   = 0
nextEnemy					   = 1
enemy_controller 		  	   = {}  -- Controls enemies
enemy_controller.spawnTimer	   = 200 -- Countdown to next enemy spawn
enemy_controller.enemies  	   = {}  -- Contains enemies
enemy_controller.bossImage	   = love.graphics.newImage("images/boss.png") 	   -- Enemy Image: Boss
enemy_controller.hedgehogImage = love.graphics.newImage("images/hedgehog.png") -- Enemy Image: Hedgehog
enemy_controller.moleImage1    = love.graphics.newImage("images/mole1.png")	   -- Enemy Image: Mole
enemy_controller.moleImage2    = love.graphics.newImage("images/mole2.png")	   -- Enemy Image: Mole
enemy_controller.moleImage3    = love.graphics.newImage("images/mole3.png")	   -- Enemy Image: Mole
enemy_controller.hitImage	   = love.graphics.newImage("images/hitImage.png") -- Enemy Image: Hit

	-- breadcrumb
breadcrumb = {}

	--enemy setup
function enemy_controller:spawn(enemyType)
	enemy 	     	 = {}
	enemy.r 		 = 0
	enemy.rad 		 = 16
	enemy.type   	 = enemyType
	enemy.speed		 = 250
	enemy.timer   	 = 0
	enemy.collides	 = true
	enemy.hit 		 = false
	enemy.unresolved = true
	breadcrumb.x 	 = 0
	breadcrumb.y 	 = cvsHeight - 16
	breadcrumb.timer = 0
	
	if enemyType == 0 then
			-- Boss spawn
		enemy.image  	 = enemy_controller.bossImage
		enemy.x 	 	 = 32
		enemy.y 		 = cvsHeight -32
		angle 			 = math.angle(enemy.x, enemy.y, player.x, player.y)
		breadcrumb.timer = 50

	elseif enemyType == 1 then
			-- hedgehog spawn
		enemy.image = enemy_controller.hedgehogImage
		enemy.x = -15
		enemy.y = love.math.random(8, cvsHeight-8)
		enemy.r = math.rad(90)
	elseif enemyType == 2 then
			-- mole spawn
		enemy.image  = enemy_controller.moleImage1
		enemy.image1 = enemy_controller.moleImage1
		enemy.image2 = enemy_controller.moleImage2
		enemy.image3 = enemy_controller.moleImage3
		enemy.phase  = 1
		enemy.phaseT = 300
		enemy.x 	 = love.math.random(8, cvsWidth-8)
		enemy.y 	 = love.math.random(8, cvsHeight-8)
		enemy.r 	 = love.math.random(0, 360)
	end	

	table.insert(self.enemies, enemy)	
	enemy_controller.timer = 250
	
end

-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.deg(math.atan2(y2-y1, x2-x1)) end

	--enemy update
function enemy_controller:update()
	for _,e in pairs(enemy_controller.enemies) do
		if e.type == 0 then -- boss logic

			--[[
			if breadcrumb.timer <= 0 then
				angle = math.angle(e.x, e.y, player.x, player.y)
				breadcrumb.timer = 50
			else
				breadcrumb.timer = breadcrumb.timer - 1
			end
			 ]]--
			-- print(angle)
			angle = math.angle(e.x, e.y, player.x, player.y)
			e.x = e.x + (math.sin(angle))
			e.y = e.y - (math.cos(angle))
			e.r = angle
			-- check breadcrumb timer, get breadcrumb
			--[[ if breadcrumb.timer <= 0 then
				breadcrumb.x 	 = player.x
				breadcrumb.y 	 = player.y
				breadcrumb.timer = 50

			else
					-- Reduce timer
				breadcrumb.timer = breadcrumb.timer - 1
			end
					-- Boss movement
					-- Get the angle between breadcrumb and enemy
				local angle = math.angle(enemy.x, enemy.y, player.x, player.y)
					-- Determine how far to move
				-- dx = math.cos(angle) * (e.speed)
				-- dy = math.sin(angle) * (e.speed)

				e.x = e.x + (math.cos(angle))
		    	e.y = e.y - (math.cos(angle))

					-- Move
				--e.x = e.x + (dx/4)
				--e.y = e.y + (dy/4) ]]--
		elseif e.type == 1 then -- hedgehog logic
			if (e.x < (cvsWidth + 16) and e.hit == false) then
				e.x = e.x + 1
			else
				table.remove(self.enemies, _)
				enemy_controller:spawn(1)
			end	
		elseif e.type == 2 then -- mole logic
			-- Phase 1, 2, 3
			-- Only phase 3 collides
			if e.phaseT >= 200 then
				e.phase = 1
			elseif e.phaseT < 200 and e.phaseT >= 100  then
				e.phase = 2
			elseif e.phaseT < 100 and e.phaseT >= -100 then
				e.phase = 3
			elseif e.phaseT <-100 and e.phaseT >= -200 then
				e.phase = 4
			elseif e.phaseT <-200 then
				e.phase = 5
			end

			if e.phase == 1 then
				-- Just draw
				e.collides = false
			elseif e.phase == 2 then
				-- Change image
				e.image = e.image2
				-- Then just draw
				e.collides = false
			elseif e.phase == 3 then
				-- Change image
				e.image = e.image3
				-- Draw and collision
				e.collides = true
			elseif e.phase == 4 then
				-- Change image
				e.image = e.image2
			elseif e.phase == 5 then
				-- Delete from table
				table.remove(self.enemies, _)
				enemy_controller:spawn(2)
			end

			e.phaseT = e.phaseT - 1
		end

		-- Detect collision
		if (detectCollision(player, e)) then
			if e.unresolved then
				-- Resolve effects
				if 	   e.type == 0 then
					jobOver()
				elseif e.type == 1 then
					player.speed = player.speed - 75
					player.fuel  = player.fuel  - 100
					e.image 	 = enemy_controller.hitImage
					e.hit 		 = true
					e.unresolved = false
				elseif (e.type == 2 and e.phase == 3) then
					player.speed = player.speed - 25
					player.fuel  = player.fuel  - 300
					e.image 	 = enemy_controller.hitImage
					e.hit 		 = true
					e.unresolved = false
				end
			end
		end
	end
end

function enemy_controller:draw()
	for _,e in pairs(enemy_controller.enemies) do
		-- print("drawing enemy")
		love.graphics.draw(e.image, e.x, e.y, e.r, 1.5, 1.5)
	end
end

	--power-up controller setup
powerUp_controller 				 = {}
powerUp_controller.timer 		 = 500
powerUp_controller.powerUps 	 = {}
powerUp_controller.moreFuelImage = love.graphics.newImage("images/moreFuel.png")  -- Power-up Image: More Fuel
powerUp_controller.goFasterImage = love.graphics.newImage("images/goFaster.png")  -- Power-up Image: Go Faster
powerUp_controller.moreMoney	 = love.graphics.newImage("images/moreMoney.png") -- Power-up Image: More Money

function powerUp_controller:spawn(powerUpType)
	powerUp  	 = {}
	powerUp.rad  = 16
	powerUp.type = powerUpType

	if powerUpType == 0 then
		-- More Fuel
		powerUp.image = powerUp_controller.moreFuelImage
		-- despawn timer?
	elseif powerUpType == 1 then
		-- Go Faster
		powerUp.image = powerUp_controller.goFasterImage
	elseif powerUpType == 2 then
		-- More Money
		powerUp.image = powerUp_controller.moreMoney
	end

	powerUp.x = love.math.random(128, cvsWidth-128)
	powerUp.y = love.math.random(128, cvsHeight-128)

	table.insert(self.powerUps, powerUp)	
	powerUp_controller.timer = 300

end

function powerUp_controller:update()	
	for _,p in pairs(powerUp_controller.powerUps) do
		-- collision detection
		if (detectCollision(player, p)) then
				-- power up get
				-- resolve effects, remove power-up
			if p.type == 0 then
					-- more fuel
				player.fuel  = player.fuel + 250
				player.score = player.score + 100
				table.remove(powerUp_controller.powerUps, _)
			elseif p.type == 1 then
					-- go faster
				player.speed = player.speed + 25
				table.remove(self.powerUps, _)
			elseif p.type == 2 then
					-- more money
				player.money = player.money + 100
				table.remove(self.powerUps, _)
			end
		end
	end
end

function powerUp_controller:draw()
	for _,p in pairs(powerUp_controller.powerUps) do
		-- print("1")
		love.graphics.draw(p.image, p.x, p.y)
	end
end

function jobState_load()
	cut = love.graphics.newImage("images/cut.png")

	-- Determines what to do when job ends
	jobOverType = null
	-- ^ == 0 : Player quit
	--	 == 1 : Out of fuel
	-- 	 == 2 : Hit by enemy/object

	-- Controls job difficulty 
	difficulty = 0

	-- Sound and music
	jobMusic = love.audio.newSource("sounds/music/Overworld.mp3")
	playing = false
end

function jobState_update(dt)			-- MAIN JOB UPDATE

	if not playing then
		jobMusic:play()
		playing = true
	end

	--										CONTROLS

	-- movement
	if (gameOver ~= true) then 
		if (love.keyboard.isDown('up') or (joystick ~= nil and (joystick:isGamepadDown('dpup') or joystick:isGamepadDown('a'))) and player.fuel > 0) then

			if ((math.sin(player.r) * player.speed * dt) > 0) then
			    if player.x < (cvsWidth-32) then
			    	player.x = player.x + (math.sin(player.r) * player.speed * dt)
			    end
		    elseif ((math.sin(player.r) * player.speed * dt) < 0) then
		    	if player.x > 32 then
		    	    player.x = player.x + (math.sin(player.r) * player.speed * dt)
		    	end
			end

			if ((math.cos(player.r) * player.speed * dt) < 0) then
			    if player.y < (cvsHeight-32) then
			    	player.y = player.y - (math.cos(player.r) * player.speed * dt)
			    end
		    elseif ((math.cos(player.r) * player.speed * dt) > 0) then
		    	if player.y > 32 then
		    	    player.y = player.y - (math.cos(player.r) * player.speed * dt)
		    	end
			end

			-- increase score, decrease fuel
			if player.fuel > 0 then
				player.score = player.score + 1
				player.fuel = player.fuel - 1
			end

		elseif (love.keyboard.isDown('down') or (joystick ~= nil and (joystick:isGamepadDown('dpdown') or joystick:isGamepadDown('b')))) then

			if ((math.sin(player.r) * player.speed * dt) > 0) then
			    if player.x < (cvsWidth-32) then
			    	player.x = player.x - (math.sin(player.r) * player.speed * dt)
			    end
		    elseif ((math.sin(player.r) * player.speed * dt) < 0) then
		    	if player.x > 32 then
		    	    player.x = player.x - (math.sin(player.r) * player.speed * dt)
		    	end
			end

			if ((math.cos(player.r) * player.speed * dt) < 0) then
			    if player.y < (cvsHeight-32) then
			    	player.y = player.y + (math.cos(player.r) * player.speed * dt)
			    end
		    elseif ((math.cos(player.r) * player.speed * dt) > 0) then
		    	if player.y > 32 then
		    	    player.y = player.y + (math.cos(player.r) * player.speed * dt)
		    	end
			end

			-- increase score, decrease fuel
			if player.fuel > 0 then
				player.score = player.score + 1
				player.fuel = player.fuel - 1
			end
	    end

	    -- Player turning
	    if player.fuel > 0 then
		    if (love.keyboard.isDown('left') or (joystick ~= nil and (joystick:isGamepadDown('dpleft')))) then
		    	player.r = player.r - .1
		    elseif (love.keyboard.isDown('right') or (joystick ~= nil and (joystick:isGamepadDown('dpright')))) then
		    	player.r = player.r + .1
			end
		end

	elseif (gameOver == true) then	
		-- Move to GO screen
		-- if (love.keyboard.isDown('return')) or (joystick ~= null and (joystick:isGamepadDown('start'))) then
			state_controller = 2
		-- end
	end
	-- quit game
	if (love.keyboard.isDown('escape') or (joystick ~= nil and (joystick:isGamepadDown('back')))) then
		love.event.quit()
	end

	--				GRASS UPDATE

	-- cut grass function call
	grass_controller:cutGrass(player.x, player.y, player.r)

	--				POWER-UP UPDATE

	-- power-up update
	powerUp_controller:update()

	-- Alternate between power-up types
	if powerUp_controller.timer <= 0 then
		powerUp_controller:spawn(0)
		powerUp_controller:spawn(love.math.random(0, 2))
	else
		powerUp_controller.timer = powerUp_controller.timer - 1
	end

	--				ENEMY UPDATE

	enemy_controller:update()

	-- spawn enemies and power-ups calls
	if enemy_controller.spawnTimer <= 0 then

		if firstSpawn == true then
			enemy_controller:spawn(0)
			firstSpawn = false
		else
			nextEnemy = love.math.random(1, 2)
			enemy_controller:spawn(nextEnemy)
		end

		-- Set timer for next enemy spawn
		enemy_controller.spawnTimer = 50
		-- Count spawned enemies
		-- enemiesSpawned = enemiesSpawned + 1
	else
		-- Reduce spawn timer
		enemy_controller.spawnTimer = enemy_controller.spawnTimer - 1        
	end

	--				GAME LOOP UPDATE

	-- check if fuel is empty
	if player.fuel < 1 then
		jobOver()
	end

end

function jobState_draw()
	--  Draw ground
	love.graphics.draw(uncut, quad, 0, 0, 0, 1, 1)

	-- Draw cut grass
	for _,g in pairs(grass_controller.cuts) do
		love.graphics.draw(grass_controller.image, g.x, g.y, g.r, 1, 1, 15, 32)
	end

	-- Draw power-ups
	powerUp_controller:draw()

	-- Draw enemies
	enemy_controller:draw()

	-- Draw player
	love.graphics.draw(player.image, player.x, player.y, player.r, 1, 1, 32, 32)

	-- Check for GO
	if gameOver then
		-- love.graphics.print(GOString, 0, 0, 0, 25, 25)
	end

	-- Draw score
	--("Score: " .. player.score)
	love.graphics.print("Score: " .. player.score .. " Fuel: " .. player.fuel .. "								High Score: " .. player.highScore, x, y, r, 1.5, 1.5)
end

-- Controller for cut grass
function grass_controller:cutGrass(x, y, r)	
	cutGrass 		= {}
	cutGrass.image 	= cut
	cutGrass.x 		= x
	cutGrass.y 		= y
	cutGrass.r 		= r
	table.insert(self.cuts, cutGrass)
end

-- lawn mow game over
function jobOver()

	gameOver = true

	-- check for new high score
	-- if player.score > player.highScore then
		-- player.highScore = 0
		-- player.highScore = player.highScore + player.score
	-- end

	-- award the player for this round
	-- player.finalScore = player.finalScore + player.score

	-- Stop music
	jobMusic:stop()

	-- Play game over sound

	GOString = "GAME\nOVER"
end
