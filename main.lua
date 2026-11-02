function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)

    local PADDLE_WIDTH = 20
    local PADDLE_HEIGHT = 100

    player1 = {
        x = 50,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    player2 = {
        x = 800 - 50 - PADDLE_WIDTH,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }
end


function love.draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Dashed center line from Part 1 video
    for y = 0, 600, 30 do
        love.graphics.rectangle("fill", 398, y, 4, 15)
    end

    -- Left paddle
    love.graphics.rectangle(
        "fill",
        player1.x,
        player1.y,
        player1.width,
        player1.height
    )

    -- Right paddle
    love.graphics.rectangle(
        "fill",
        player2.x,
        player2.y,
        player2.width,
        player2.height
    )
end


function love.update(dt)

    -- Left paddle: W / S
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    -- Right paddle: Up / Down
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Keep player 1 inside the window
    if player1.y < 0 then
        player1.y = 0
    elseif player1.y + player1.height > 600 then
        player1.y = 600 - player1.height
    end

    -- Keep player 2 inside the window
    if player2.y < 0 then
        player2.y = 0
    elseif player2.y + player2.height > 600 then
        player2.y = 600 - player2.height
    end
end