
	-- grass setup
grass_controller 		= {}
grass_controller.cuts 	= {}
grass_controller.image  = love.graphics.newImage("images/cut.png")

	-- Level setup
level_controller 			  = {}
level_controller.currentLevel = 1
levels 		  	 			  = {}
levels.level1 	 			  = { 0, -1, -1, -1, -1,  1, -1, -1,  1,  3 }
levels.level2 			      = { 0, -1,  1, -1, -1,  1, -1, -1,  1,  3 }
levels.level3				  = { 0,  1, -1,  1, -1, -1,  1,  2, -2,  3 }
levels.level4	 			  = { 0,  2, -1,  2, -1,  1,  1,  1,  1,  3 }
levels.level5	 			  = { 0,  2,  1,  2,  1,  2,  1,  2,  1,  3 }

	-- Point to point collision detection
function detectCollision(Player, entity)
    local dx = entity.x - (player.x)
    local dy = entity.y - (player.y)
    return dx^2 + dy^2 <= (player.rad + entity.rad)^2
end

	-- enemy_controller setup
nextEnemy					   = 1
enemy_controller 		  	   = {}  -- Controls enemies
enemy_controller.spawnTimer	   = 100 -- Countdown to next enemy spawn
enemy_controller.enemies  	   = {}  -- Contains enemies
enemy_controller.bossImage	   = love.graphics.newImage("images/boss.png") 	   -- Enemy Image: Boss
enemy_controller.hedgehogImage = love.graphics.newImage("images/hedgehog.png") -- Enemy Image: Hedgehog
enemy_controller.moleImage1    = love.graphics.newImage("images/mole1.png")	   -- Enemy Image: Mole
enemy_controller.moleImage2    = love.graphics.newImage("images/mole2.png")	   -- Enemy Image: Mole
enemy_controller.moleImage3    = love.graphics.newImage("images/mole3.png")	   -- Enemy Image: Mole

	-- breadcrumb
breadcrumb = {}

	--enemy setup
function enemy_controller:spawn(enemyType)
	enemy 	     	 = {}
	enemy.rad 		 = 8
	enemy.type   	 = enemyType
	enemy.speed		 = 200
	enemy.timer   	 = 0
	breadcrumb.x 	 = 0
	breadcrumb.y 	 = cvsHeight
	breadcrumb.timer = 0
	
	if enemyType == 0 then
			-- Boss spawn
		enemy.image  	 = enemy_controller.bossImage
		enemy.x 	 	 = 0
		enemy.y 		 = cvsHeight
		breadcrumb.x 	 = player.x
		breadcrumb.y 	 = player.y
		breadcrumb.timer = 50

	elseif enemyType == 1 then
			-- hedgehog spawn
		enemy.image = enemy_controller.hedgehogImage
	elseif enemyType == 2 then
			-- mole spawn
		enemy.image = enemy_controller.moleImage1
	end	

	enemy.x = -15
	enemy.y = love.math.random(1, 600)
end

	--enemy update
function enemy_controller:update()
	for _,e in pairs(enemy_controller.enemies) do
		if e.type == 0 then -- boss logic
			-- check breadcrumb timer, get breadcrumb
			if breadcrumb.timer <= 0 then
				breadcrumb.x 	 = player.x
				breadcrumb.y 	 = player.y
				breadcrumb.timer = 50
					-- movement
					-- get thee angle between player and enemy
				local angle = math.getAngle(enemy.x, enemy.y, breadcrumb.x, breadcrumb.y)
					-- determine how far to move
				local dx = math.cos(angle) * (dt * e.speed)
				local dy = math.sin(angle) * (dt * e.speed)
			else
					-- move
				e.x = e.x + (dx/4)
				e.y = e.y + (dy/4)
					-- reset timer
				breadcrumb.timer = breadcrumb.timer - 1
			end

		elseif e.type == 1 then -- hedgehog logic
			if e.x < (cvsWidth + 16) then
				e.x = e.x + 1
			else
				table.remove(self.enemies, e.self)
				enemy_controller:spawn(1)
			end	
		elseif e.type == 2 then -- mole logic

		elseif e.type == 3 then -- level complete
			-- Do score stuff

			-- Advance level
			if 	   currentLevel == 1 then
				levelData = levels.level1
			elseif currentLevel == 2 then
				levelData = levels.level2
			elseif currentLevel == 3 then
			    levelData = levels.level3
			elseif currentLevel == 4 then
			    levelData = levels.level4
			elseif currentLevel == 5 then
			    levelData = levels.level5
			end

		end
	end
end

function enemy_controller:draw()
	for _,e in pairs(enemy_controller.enemies) do
		print("drawing enemy")
		love.graphics.draw(e.image, e.x, e.y)
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
	powerUp.rad  = 8
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

	powerUp.x = love.math.random(1, 700)
	powerUp.y = love.math.random(1, 500)

	table.insert(self.powerUps, powerUp)	
	powerUp_controller.timer = 500

end

function powerUp_controller:update()	
	for _,p in pairs(powerUp_controller.powerUps) do
		-- collision detection
		if (detectCollision(player, p)) then
				-- power up get
				-- resolve effects, remove power-up
			if p.type == 0 then
					-- more fuel
				player.fuel  = player.fuel + 500
				player.score = player.score + 100
				table.remove(powerUp_controller.powerUps, p.self)
			elseif p.type == 1 then
					-- go faster
				player.speed = player.speed + 25
				table.remove(self.powerUps, p.self)
			elseif p.type == 2 then
					-- more money
				player.money = player.money + 100
				table.remove(self.powerUps, p)
			end
		end
	end
end

function powerUp_controller:draw()
	for _,p in pairs(powerUp_controller.powerUps) do
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
	jobMusic = love.audio.newSource("sounds/Enchanted_Valley.mp3")
	playing = false
end

function jobState_update(dt)

	if not playing then
		--jobMusic:play()
		playing = true
	end

	--				CONTROLS

	-- movement
	if love.keyboard.isDown('up') and player.fuel > 0 then

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
		player.score = player.score + 1
		player.fuel = player.fuel - 1

	elseif love.keyboard.isDown('down') then

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
		player.score = player.score + 1
		player.fuel = player.fuel - 1

    end

    -- Player turning
    if player.fuel > 0 then
	    if love.keyboard.isDown('left') then
	    	player.r = player.r - .1
	    elseif love.keyboard.isDown('right') then
	    	player.r = player.r + .1
		end
	end

	-- quit game
	if love.keyboard.isDown('escape') then
		love.event.quit()
	end

	--				GRASS UPDATE

	-- cut grass function call
	grass_controller:cutGrass(player.x, player.y, player.r)

	--				POWER UP UPDATE

	-- power-up update
	powerUp_controller:update(0)

	if powerUp_controller.timer <= 0 then
		powerUp_controller:spawn(0)
	else
		powerUp_controller.timer = powerUp_controller.timer - 1
	end

	--				ENEMY UPDATE

	-- spawn enemies and power-ups calls
	if enemy_controller.spawnTimer <= 0 then

		-- Spawn new enemy
		enemy_controller:spawn(nextEnemy)
		-- Set timer for next enemy spawn
		enemy_controller.spawnTimer = 250
		-- Increment nextEnemy
		nextEnemy = nextEnemy + 1
	else
		-- Reduce spawn timer
		enemy_controller.spawnTimer = enemy_controller.spawnTimer - 1        
	end

	--				GAME LOOP UPDATE

	-- check if fuel is empty
	if player.fuel < 1 then
		jobOver(1)
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

	-- Draw score
	--("Score: " .. player.score)
	love.graphics.print("Score: " .. player.score .. " Fuel: " .. player.fuel .. "								High Score: " .. player.highScore)
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
function jobOver(type)

	-- check for new high score
	if player.score > player.highScore then
		player.highScore = player.score
	end

	-- award the player for this round
	player.finalScore = player.finalScore + player.score
	player.score = 0

	--return to garden
	state_controller = 2
end