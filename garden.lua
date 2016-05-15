-- After game over

function resetGame()

	-- player setup
	--player			 = {}
	--player.image 	 = love.graphics.newImage("images/player.png")
	player.x 		 = 128
	player.y 		 = cvsHeight - 128
	player.r 		 = 0
	player.rad 		 = 12
	--player.lives 	 = 5
	player.fuel 	 = 750
	player.speed 	 = 300
	--player.score 	 = 0
	--player.money	 = 0
	--player.bonus	 = 0
	--player.highScore = 0
	--player.finalScore= 0

	-- game loop setup
	--currentLevel = 1
	--gameOver 	 = false
	--gameComplete = false
	--gameStarted	 = false
	--state 		 = 0

	grass_controller.cuts = {}
	enemy_controller.enemies = {}
	powerUp_controller.powerUps = {}

	firstSpawn = true

	--titleState_load()	-- state 0
	--jobState_load()		-- state 1
	--gardenState_load()	-- state 2
end

function catchGameOver()

	player.finalScore = player.score

	if player.finalScore > player.highScore then
		player.highScore = player.finalScore
	end

	player.score = 0

	gameOver 	 = false
	musicPlaying = false
	playing 	 = false
end

function gardenState_load()

	GOmusic = love.audio.newSource("sounds/music/Wagon_Wheel.mp3")
	GOmusic:setVolume(0.4)
	musicPlaying = false

end

function gardenState_update(dt)

	-- Catch Game Over
	if gameOver then
		catchGameOver()
	end

	if musicPlaying == false then
		GOmusic:play()
		musicPlaying = true
	end

	-- Controls
	-- Return to menu
	if (love.keyboard.isDown('x') or (joystick ~= nil and joystick:isGamepadDown('x'))) then
		GOmusic:stop()
		titleMusic:play()
		resetGame()
		state_controller = 0
	end

	-- Play again
	if (love.keyboard.isDown('return') or (joystick ~= nil and joystick:isGamepadDown('start'))) then
		GOmusic:stop()
		jobMusic:play()
		resetGame()
		state_controller = 1
	end

	-- Quit game
	if love.keyboard.isDown('escape') or (joystick ~= nil and joystick:isGamepadDown('back')) then
		love.event.quit()
	end
end

function gardenState_draw()
	--  Draw ground
	love.graphics.draw(uncut, quad, 0, 0, 0, 1, 1)

	love.graphics.print("GAME OVER", cvsWidth/2-128, cvsHeight/3, r, 3, 3)

	love.graphics.print("Score: " .. player.finalScore, cvsWidth/2-128, cvsHeight/3+32, 0, 3, 3)

	-- Display high score
	love.graphics.print("High Score: " .. player.highScore, cvsWidth/2-128, cvsHeight/3+64, 0, 3, 3)

	-- Instructions
	love.graphics.print("Press X to return to Title\nPress Start to play again", cvsWidth/2-128, cvsHeight-32)
end