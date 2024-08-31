function love.load()
    love.window.setTitle("Sprinter Game")
    love.window.setMode(800, 600)
    
    player = {
        x = 100,
        y = love.graphics.getHeight() - 150,
        width = 50,
        height = 100,
        speed = 0,
        maxSpeed = 500,
        acceleration = 100,
        deceleration = 50,
        animationFrame = 1,
        animationSpeed = 10
    }
    
    finishLine = {
        x = 700,
        width = 10
    }
    
    time = 0
    gameover = false
end

function love.update(dt)
    if not gameover then
        time = time + dt
        if love.keyboard.isDown("space") then
            if player.speed < player.maxSpeed then
                player.speed = player.speed + player.acceleration * dt
            end
        else
            if player.speed > 0 then
                player.speed = player.speed - player.deceleration * dt
            end
        end

        player.x = player.x + player.speed * dt
        player.animationFrame = player.animationFrame + player.animationSpeed * dt

        if player.x + player.width >= finishLine.x then
            gameover = true
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(135, 206, 235)
    love.graphics.setColor(34, 139, 34)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)
    
    if not gameover then
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    else
        love.graphics.setColor(255, 0, 0)
        love.graphics.print("Finished! Time: " .. string.format("%.2f", time) .. "s", 300, 200, 0, 2, 2)
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", finishLine.x, 0, finishLine.width, love.graphics.getHeight())
end
