-- After game over

function gardenState_load()

end

function gardenState_update(dt)
	-- Controls
	-- Return to menu
	if (love.keyboard.isDown('x') or joystick:isGamepadDown('x')) then

	end

	-- Play again
	if (love.keyboard.isDown('a') or joystick:isGamepadDown('a')) then 

	end

	-- Quit game
	if love.keyboard.isDown('escape') or joystick:isGamepadDown('back') then
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
end