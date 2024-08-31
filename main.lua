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
        color = {255, 255, 255}
    }

    opponents = {
        {
            x = 100,
            y = player.y - 120,
            width = 50,
            height = 100,
            speed = 0,
            maxSpeed = math.random(300, 450),
            acceleration = math.random(80, 120),
            color = {255, 0, 0}
        },
        {
            x = 100,
            y = player.y + 120,
            width = 50,
            height = 100,
            speed = 0,
            maxSpeed = math.random(300, 450),
            acceleration = math.random(80, 120),
            color = {0, 0, 255}
        }
    }

    finishLine = {
        x = 700,
        width = 10
    }

    startTime = 3
    time = 0
    gameover = false
    winner = nil
end

function love.update(dt)
    if startTime > 0 then
        startTime = startTime - dt
        return
    end

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

        for _, opponent in ipairs(opponents) do
            if opponent.speed < opponent.maxSpeed then
                opponent.speed = opponent.speed + opponent.acceleration * dt
            end
            opponent.x = opponent.x + opponent.speed * dt

            if opponent.x + opponent.width >= finishLine.x and not gameover then
                gameover = true
                winner = "Opponent"
            end
        end

        if player.x + player.width >= finishLine.x and not gameover then
            gameover = true
            winner = "Player"
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(135, 206, 235)
    love.graphics.setColor(34, 139, 34)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)

    if startTime > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Get Ready: " .. math.ceil(startTime), 350, 250, 0, 3, 3)
        return
    end

    love.graphics.setColor(player.color)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    for _, opponent in ipairs(opponents) do
        love.graphics.setColor(opponent.color)
        love.graphics.rectangle("fill", opponent.x, opponent.y, opponent.width, opponent.height)
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", finishLine.x, 0, finishLine.width, love.graphics.getHeight())

    if gameover then
        love.graphics.setColor(255, 255, 0)
        love.graphics.print(winner .. " Wins! Time: " .. string.format("%.2f", time) .. "s", 300, 200, 0, 2, 2)
    end
end
