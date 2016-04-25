

function titleState_load()
	-- Enter fullscreen
	-- success = love.window.setFullscreen( true )

	-- Title screen set up
	title1 		= love.graphics.newImage("images/slTitle1.png")
	title2 		= love.graphics.newImage("images/slTitle2.png")
	instructions= love.graphics.newImage("images/instructions.png")

	-- Title music and sounds
	titleMusic = love.audio.newSource("sounds/Adventure_Meme.mp3")
	menuSelect = love.audio.newSource("sounds/menu_select.mp3", "static")
	-- TitleMusic:play()

	-- Instruction panel control
	showInstructions = false
	keySpeedLimiter	 = 0

	-- Canvas and ground setup
	cvsWidth 	= love.window.getWidth()
	cvsHeight	= love.window.getHeight()
	uncut 		= love.graphics.newImage("images/uncut.png")
	quad 		= love.graphics.newQuad(0, 0, cvsWidth, cvsHeight, 64, 64)
	uncut:setWrap("repeat", "repeat")
end

function titleState_update(dt)
	-- Keyboard controls
	if(keySpeedLimiter > 0) then
		keySpeedLimiter = keySpeedLimiter - 1
	end

	-- Show instructions
	if love.keyboard.isDown('h') and showInstructions == false and keySpeedLimiter == 0 then
		showInstructions = true
		keySpeedLimiter = 10
	elseif love.keyboard.isDown('h') and showInstructions == true and keySpeedLimiter == 0 then
		showInstructions = false
		keySpeedLimiter = 10
	end

	-- Start game
	if love.keyboard.isDown('return') then 
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
	love.graphics.draw(title1, 64, 10 , 0, 2)
    love.graphics.draw(title2, 64, 70, 0, 2)

    -- Check if showInstructions == true then show/don't show instructions
    if showInstructions then
        love.graphics.draw(instructions, cvsWidth/2-32, cvsHeight/2-32, 0, 5)
    else
    	love.graphics.print("Press enter to begin", cvsWidth/2-32, cvsHeight/2-32)
    end

    love.graphics.print("Press h for help", cvsWidth/2-64, cvsHeight - 16)
end