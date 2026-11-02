function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)

    local PADDLE_WIDTH = 20
    local PADDLE_HEIGHT = 100
    local BALL_SIZE = 20

    -- Scores
    score1 = 0
    score2 = 0

    -- Left paddle
    player1 = {
        x = 50,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    -- Right paddle
    player2 = {
        x = 800 - 50 - PADDLE_WIDTH,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    -- Ball
    ball = {
        x = 400 - BALL_SIZE / 2,
        y = 300 - BALL_SIZE / 2,
        size = BALL_SIZE,
        dx = 200,
        dy = 200
    }

    -- Own Change:
    -- Press Space to serve the ball
    gameStarted = false

    scoreFont = love.graphics.newFont(40)
end


function love.draw()

    -- Dark background
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Draw dashed center line
    for y = 0, 600, 30 do
        love.graphics.rectangle("fill", 398, y, 4, 15)
    end

    -- Draw left paddle
    love.graphics.rectangle(
        "fill",
        player1.x,
        player1.y,
        player1.width,
        player1.height
    )

    -- Draw right paddle
    love.graphics.rectangle(
        "fill",
        player2.x,
        player2.y,
        player2.width,
        player2.height
    )

    -- Draw ball
    love.graphics.rectangle(
        "fill",
        ball.x,
        ball.y,
        ball.size,
        ball.size
    )

    -- Draw scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(score1, 300, 50)
    love.graphics.print(score2, 470, 50)

    -- Own Change message
    if not gameStarted then
        love.graphics.print(
            "Press SPACE to Serve",
            220,
            520
        )
    end
end


-- AABB collision detection
local function checkCollision(ball, paddle)

    return ball.x < paddle.x + paddle.width
        and ball.x + ball.size > paddle.x
        and ball.y < paddle.y + paddle.height
        and ball.y + ball.size > paddle.y
end


-- Return ball to center after a point
local function resetBall()

    ball.x = 400 - ball.size / 2
    ball.y = 300 - ball.size / 2

    -- Random direction for next serve
    ball.dx = 200 * (math.random(2) == 1 and 1 or -1)
    ball.dy = 200 * (math.random(2) == 1 and 1 or -1)

    -- Wait for Space again
    gameStarted = false
end


function love.update(dt)

    -- PLAYER 1
    -- W = up
    -- S = down
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt

    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end


    -- PLAYER 2
    -- Up arrow = up
    -- Down arrow = down
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt

    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end


    -- Stop player 1 from leaving the screen
    if player1.y < 0 then
        player1.y = 0

    elseif player1.y + player1.height > 600 then
        player1.y = 600 - player1.height
    end


    -- Stop player 2 from leaving the screen
    if player2.y < 0 then
        player2.y = 0

    elseif player2.y + player2.height > 600 then
        player2.y = 600 - player2.height
    end


    -- Ball only moves after Space is pressed
    if gameStarted then

        -- Move ball using Delta Time
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt


        -- Bounce from top wall
        if ball.y <= 0 then

            ball.y = 0
            ball.dy = -ball.dy
        end


        -- Bounce from bottom wall
        if ball.y + ball.size >= 600 then

            ball.y = 600 - ball.size
            ball.dy = -ball.dy
        end


        -- Collision with left paddle
        if checkCollision(ball, player1) then

            -- Move ball outside paddle
            ball.x = player1.x + player1.width

            -- Reverse horizontal direction
            ball.dx = -ball.dx
        end


        -- Collision with right paddle
        if checkCollision(ball, player2) then

            -- Move ball outside paddle
            ball.x = player2.x - ball.size

            -- Reverse horizontal direction
            ball.dx = -ball.dx
        end


        -- Ball leaves the LEFT side
        -- Player 2 gets a point
        if ball.x + ball.size < 0 then

            score2 = score2 + 1
            resetBall()


        -- Ball leaves the RIGHT side
        -- Player 1 gets a point
        elseif ball.x > 800 then

            score1 = score1 + 1
            resetBall()
        end
    end
end


-- Own Change:
-- Press Space to serve
function love.keypressed(key)

    if key == "space" and not gameStarted then
        gameStarted = true
    end
end