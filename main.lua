require 'title'
require 'job'
require 'garden'

function love.load()
	-- Get saved high score
	if love.filesystem.exists( "Super_Landscaper_Save" ) then
		loadedScore = love.filesystem.read("Super_Landscaper_Save")
	else
		love.filesystem.setIdentity("Super_Landscaper_Save")
	end
	-- Canvas setup
	cvsWidth  = love.graphics.getWidth()
	cvsHeight = love.graphics.getHeight()

	-- Joystick setup
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1] 

	-- player setup
	player			 = {}
	player.image 	 = love.graphics.newImage("images/player.png")
	player.x 		 = 128
	player.y 		 = cvsHeight - 128
	player.r 		 = 0
	player.rad 		 = 16
	player.lives 	 = 5
	player.fuel 	 = 750
	player.speed 	 = 300
	player.score 	 = 0
	player.money	 = 0
	player.bonus	 = 0
	player.highScore = loadedScore or 0
	player.finalScore= 0

	-- game loop setup
	gameOver = false

	--gameComplete = false
	--gameStarted	 = false

	titleState_load()	-- state 0
	jobState_load()		-- state 1
	gardenState_load()	-- state 2

	state_controller = 0
end

function love.update (dt)
	if     state_controller == 0 then
		titleState_update(dt)
	elseif state_controller == 1 then
		jobState_update(dt)
	elseif state_controller == 2 then
		gardenState_update(dt)
	end
end

function love.draw()
	if     state_controller == 0 then
		titleState_draw()
	elseif state_controller == 1 then
		jobState_draw()
	elseif state_controller == 2 then
		gardenState_draw()
	end	
end
