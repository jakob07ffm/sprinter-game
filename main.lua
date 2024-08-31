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
        sprintBoost = 2,
        boostDuration = 0.5,
        boostCooldown = 3,
        boostTimer = 0,
        boostActive = false,
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
            color = {255, 0, 0},
            finished = false
        },
        {
            x = 100,
            y = player.y + 120,
            width = 50,
            height = 100,
            speed = 0,
            maxSpeed = math.random(300, 450),
            acceleration = math.random(80, 120),
            color = {0, 0, 255},
            finished = false
        }
    }

    finishLine = {
        x = 700,
        width = 10
    }

    obstacles = {}
    for i = 1, 5 do
        table.insert(obstacles, {
            x = math.random(200, finishLine.x - 50),
            y = math.random(100, love.graphics.getHeight() - 150),
            width = 20,
            height = 20,
            color = {139, 69, 19}
        })
    end

    startTime = 3
    time = 0
    gameover = false
    winner = nil
    leaderboard = {}
end

function love.update(dt)
    if startTime > 0 then
        startTime = startTime - dt
        return
    end

    if not gameover then
        time = time + dt

        if player.boostActive then
            player.speed = player.maxSpeed * player.sprintBoost
            player.boostTimer = player.boostTimer + dt
            if player.boostTimer >= player.boostDuration then
                player.boostActive = false
                player.boostTimer = 0
            end
        elseif love.keyboard.isDown("space") then
            if player.speed < player.maxSpeed then
                player.speed = player.speed + player.acceleration * dt
            end
            if love.keyboard.isDown("lshift") and player.boostCooldown <= 0 then
                player.boostActive = true
                player.boostCooldown = 3
            end
        else
            if player.speed > 0 then
                player.speed = player.speed - player.deceleration * dt
            end
        end

        player.boostCooldown = player.boostCooldown - dt
        player.x = player.x + player.speed * dt

        for i, opponent in ipairs(opponents) do
            if not opponent.finished then
                if opponent.speed < opponent.maxSpeed then
                    opponent.speed = opponent.speed + opponent.acceleration * dt
                end
                opponent.x = opponent.x + opponent.speed * dt

                if opponent.x + opponent.width >= finishLine.x and not gameover then
                    opponent.finished = true
                    table.insert(leaderboard, {name = "Opponent " .. i, time = time})
                end
            end
        end

        if player.x + player.width >= finishLine.x and not gameover then
            gameover = true
            winner = "Player"
            table.insert(leaderboard, {name = "Player", time = time})
            for i, opponent in ipairs(opponents) do
                if not opponent.finished then
                    opponent.finished = true
                    table.insert(leaderboard, {name = "Opponent " .. i, time = time})
                end
            end
            table.sort(leaderboard, function(a, b) return a.time < b.time end)
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

    for _, obstacle in ipairs(obstacles) do
        love.graphics.setColor(obstacle.color)
        love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", finishLine.x, 0, finishLine.width, love.graphics.getHeight())

    if gameover then
        love.graphics.setColor(255, 255, 0)
        love.graphics.print(winner .. " Wins! Time: " .. string.format("%.2f", time) .. "s", 300, 150, 0, 2, 2)
        love.graphics.print("Leaderboard:", 300, 200, 0, 2, 2)
        for i, entry in ipairs(leaderboard) do
            love.graphics.print(i .. ". " .. entry.name .. ": " .. string.format("%.2f", entry.time) .. "s", 300, 200 + i * 30, 0, 2, 2)
        end
    end
end
