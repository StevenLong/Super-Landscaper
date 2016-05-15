

function titleState_load()
	-- Enter fullscreen
	success = love.window.setFullscreen( true )

	-- New title
	titlePhase		= 0
	titleDisplayed  = false
	titleLogo 	 	= love.graphics.newImage("images/slFullTitle.png")
	titleY			= 0 - (titleLogo:getHeight()*2)
	titleX 			= 0

	-- Display instructions image
	instructions 	= love.graphics.newImage("images/instructions.png")

	-- Title music and sounds
	titleMusic 		= love.audio.newSource("sounds/music/Blip_Stream.mp3")
	menuSelect 		= love.audio.newSource("sounds/effects/menu_select.mp3", "static")
	introSound 		= love.audio.newSource("sounds/effects/digital-bells-up-down.wav")

	-- Setting Volumes
	introSound:setVolume(0.8)
	titleMusic:setVolume(0.7)

	-- Instruction panel control
	showInstructions= false
	keySpeedLimiter	= 0

	-- Canvas and ground setup
	cvsWidth 		= love.graphics.getWidth()
	cvsHeight		= love.graphics.getHeight()
	uncut 			= love.graphics.newImage("images/uncut.png")
	quad 			= love.graphics.newQuad(0, 0, cvsWidth, cvsHeight, 64, 64)
	uncut:setWrap("repeat", "repeat")
end

-- Title display function
function titleDisplay()

	if titleDisplayed == false and titlePhase == 0 then
		introSound:play()
		titleY = titleY + 5

		if titleY > cvsHeight then
			titlePhase = 1
			introSound:stop()
			titleY = 0
			titleX = -1366
		end
	elseif  titleDisplayed == false and titlePhase == 1 then

		if (titleX < -5) then
			titleMusic:play()
			titleX = titleX + 5
		end
	end
end

function titleState_update(dt)

	-- Title manipulation
	if titleDisplayed == false then
		titleDisplay()
	end

	-- 										CONTROLS
	if(keySpeedLimiter > 0) then
		keySpeedLimiter = keySpeedLimiter - 1
	end

	-- Show instructions
	if (love.keyboard.isDown('y') or (joystick ~= nil and (joystick:isGamepadDown('y'))) and showInstructions == false and keySpeedLimiter == 0) then
		showInstructions = true
		keySpeedLimiter = 10
	elseif (love.keyboard.isDown('h') or (joystick ~= nil and (joystick:isGamepadDown('y'))) and showInstructions == true and keySpeedLimiter == 0) then
		showInstructions = false
		keySpeedLimiter = 10
	end

	-- Start game
	if (love.keyboard.isDown('return')) or (joystick ~= null and (joystick:isGamepadDown('start') or joystick:isGamepadDown('a'))) then
		introSound:stop() 
		titleMusic:stop()
		menuSelect:play()
		state_controller = 1
	end

	-- Quit game
	if love.keyboard.isDown('escape') then
		love.event.quit()
	end

end

function titleState_draw()
	-- Draw ground
	love.graphics.draw(uncut, quad, 0, 0, 0, 1, 1)

	-- Draw title
	love.graphics.draw(titleLogo, titleX, titleY , 0, 3.25)

    -- Check if showInstructions == true then show show instructions, else don't.
    if showInstructions then
        love.graphics.draw(instructions, cvsWidth/2-32, cvsHeight/2-32, 0, 3.5)
        love.graphics.print("Use arrow keys to move", cvsWidth/2, cvsHeight/2+12)
        love.graphics.print("Avoid touching enemies", cvsWidth/2, cvsHeight/2+24)
        love.graphics.print("Collect fuel and bonuses", cvsWidth/2, cvsHeight/2+36)
    else
    	love.graphics.print("Press A or Enter to begin", cvsWidth/2-64, cvsHeight/2 + 30)
    end

    love.graphics.print("Press Y for help", cvsWidth/2-64, cvsHeight - 16)
end