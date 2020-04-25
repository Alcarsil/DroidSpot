-- Alessandro Carvalho Silva <AlephC>, 2019 for Droid Spot desktop game - Windows version © 

local push = require "push"

local gameWidth, gameHeight = 1080, 720 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

widthScreen = love.graphics.getWidth()
heightScreen = love.graphics.getHeight()

local videoPlaying = true


function love.load()
    --splashScreen
    video = love.graphics.newVideo( "flowLoad.ogv", {false} )
	video:getWidth()
	video:getHeight()
    video:getSource():setLooping( true )
	video:play()
    --splashScreen
    
    --soundtrack
    soundtrack = love.audio.newSource( "sound.ogg", "static" )
    soundtrack:setVolume(1.0)
    soundtrack:setLooping( true )
    soundtrack:play()
    --soundtrack
    
    --droid
    droid = love.graphics.newImage( 'droidHero.png' )
    droidScreen = { droid, posX = 300, posY = 500, spd = 10 }
    --droid
    
    --missiles
    shooting = true
    delayMissile = 0.1
    timeShooting = delayMissile
    shootings = {}
    missileImg = love.graphics.newImage( 'missile.png' )
    --missiles
    
    --bitcoin
    delayBitcoin = 0.7
    timeBitcoin = delayBitcoin
    imgBitcoin = love.graphics.newImage( 'btc.png' )
    bitcoins = {}
    --bitcoin
    
    --eth
    delayEth = 0.7
    timeEth = delayEth
    imgEth = love.graphics.newImage( 'eth.png' )
    eths = {}
    --eth
    
    --enemies
    delayEnemyOne = 0.2
    timeEnemyOne = delayEnemyOne
    imgEnemyOne = love.graphics.newImage( 'alienOne.png' )
    enemiesOne = {}
    
    delayEnemyTwo = 0.4
    timeEnemyTwo = delayEnemyTwo
    imgEnemyTwo = love.graphics.newImage( 'alienTwo.png' )
    enemiesTwo = {}
    
    delayEnemy3 = 0.4
    timeEnemy3 = delayEnemy3
    imgEnemy3 = love.graphics.newImage( 'alien3.png' )
    enemies3 = {}
    --enemies
    
    --alive and score
    aLive = true
    score = 0
    highscore = 0
    --maxScor = score
    --alive and score
    
    --font
    fontImg = love.graphics.newImageFont( 'font.png', " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .. "123456789.,!?-+/():;%&`'*#=[]\"" )
    --font
    
    --game sounds
    missileSound = love.audio.newSource( "missile.wav", "static" )
    missileSound:setVolume(0.3)
    enemyBoom = love.audio.newSource( "boom.wav", "static" )
    enemyBoom:setVolume(0.3)
    enemyTwoBoom = love.audio.newSource( "enemyloss.wav", "static" )
    enemyTwoBoom:setVolume(0.2)
    droidEnd = love.audio.newSource( "gameOver.wav", "static" )
    droidEnd:setVolume(0.2)
    bitcoinSound = love.audio.newSource( "bitcoin.wav", "static" )
    bitcoinSound:setVolume(0.2)
    --game sounds
    
    --score effects
    scaleX = 1
    scaleY = 1
    --score effects
    
    --highscore
    highscores = { }
    if not love.filesystem.getInfo( 'scores.lua' ) then
        scores = love.filesystem.newFile( 'scores.lua' )
    end
    
    love.filesystem.write( 'scores.lua', 'highscore\n=\n' ..highscore )
    
    for lines in love.filesystem.lines( 'scores.lua' ) do
        table.insert( highscores, lines )
    end
    
    highscore = highscores[ 3 ]
    --highscore
end

function love.update( dt )
    
    droidMovements( dt )
    shootingMissiles( dt )
    enemyOneComing( dt )
    enemyTwoComing( dt )
    enemy3Coming( dt )
    bitcoinComing( dt )
    ethComing( dt )
    collisions()
    reset()
    scoreEffects( dt )
    
    if score > tonumber( highscore ) then
        highscore = score
    end
    
end

function shootingMissiles( dt )

    timeShooting = timeShooting - ( 0.7 * dt )
    if timeShooting < 0 then
        shooting = true
    end
    if aLive then
        if love.keyboard.isDown( "space" ) and shooting then
            newMissile = { x = droidScreen.posX, y = droidScreen.posY, img = missileImg }
            table.insert( shootings, newMissile )
            missileSound:stop()
            missileSound:play()
            shooting = false
            timeShooting = delayMissile
        end
    end
    for i, missileShoot in ipairs( shootings ) do
        missileShoot.y = missileShoot.y - ( 500 * dt )
        if missileShoot.y < 0 then
            table.remove( shootings, i )
        end
    end
    
end

function openVideo()

    love.graphics.draw( video, -450, -200 )
    love.graphics.setFont( fontImg, 60 )
    love.graphics.printf( "press 'enter' to go on", 760, 600, 250, "center" )
    droidEnd:stop()
    
end

function startFirstScreen()

    if videoPlaying and love.keyboard.isDown( 'return' ) then
        videoPlaying = false
        aLive = true
        droidEnd:stop()
    end
    
end

function love.draw()
    push:start()
    
    if videoPlaying then
        openVideo()
        startFirstScreen()
        --if firstScreen then
            --openGame()
            --startGame()
        --end
    elseif aLive then
        love.graphics.draw( droid, droidScreen.posX, droidScreen.posY ) --droid img
        --missiles
        for i, missileShoot in ipairs( shootings ) do
            love.graphics.draw( missileShoot.img, missileShoot.x + 36, missileShoot.y )
        end
        --missiles
        --enemiesOne
        for i, enemyOneHead in ipairs( enemiesOne ) do
            love.graphics.draw( enemyOneHead.img, enemyOneHead.x, enemyOneHead.y )
        end
        --enemiesOne
        --enemiesTwo
        for i, enemyTwoHead in ipairs( enemiesTwo ) do
            love.graphics.draw( enemyTwoHead.img, enemyTwoHead.x, enemyTwoHead.y )
        end
        --enemiesTwo
        --enemies3
        for i, enemy3Head in ipairs( enemies3 ) do
            love.graphics.draw( enemy3Head.img, enemy3Head.x, enemy3Head.y )
        end
        --enemies3
        --bitcoin
        for i, bitcoinHead in ipairs( bitcoins ) do
            love.graphics.draw( bitcoinHead.img, bitcoinHead.x, bitcoinHead.y )
        end
        --bitcoin
        --eth
        for i, ethHead in ipairs( eths ) do
            love.graphics.draw( ethHead.img, ethHead.x, ethHead.y )
        end
        --eth
        --score on screen
        love.graphics.setFont( fontImg )
        love.graphics.print( "Score: ", 5, 10, 0, 1, 1, 0, 2, 0, 0 )
        love.graphics.print( score, 75, 15, 0, scaleX, scaleY, 5, 5, 0, 0 )
        love.graphics.print( "Highscore: " ..highscore, 5, 25 )
        --score on screen
    else
    --game over and reset
        love.graphics.printf( "GAME OVER\n\n\npress 'enter' to restart or press 'esc' to quit", 420, 300, 250, "center" )
    --game over and reset
    end
    
    push:finish()
end

function droidMovements( dt )

    if love.keyboard.isDown( "right" ) and droidScreen.posX < ( gameWidth - droid:getWidth() ) then
        droidScreen.posX = droidScreen.posX + 1 * droidScreen.spd
    end
    if love.keyboard.isDown( "left" ) and droidScreen.posX > 0 then
        droidScreen.posX = droidScreen.posX - 1 * droidScreen.spd
    end
    if love.keyboard.isDown( "up" ) and droidScreen.posY > 0 then
        droidScreen.posY = droidScreen.posY - 1 * droidScreen.spd
    end
    if love.keyboard.isDown( "down" ) and droidScreen.posY < ( gameHeight - droid:getHeight() ) then
        droidScreen.posY = droidScreen.posY + 1 * droidScreen.spd
    end
    
end

function enemyOneComing( dt )

    if score <= 100 then
        timeEnemyOne = timeEnemyOne - ( 0.3 * dt )
    elseif score > 100 and score <= 500 then
        timeEnemyOne = timeEnemyOne - ( 0.6 * dt )
    elseif score > 500 and score <= 1000 then
        timeEnemyOne = timeEnemyOne - ( 0.8 * dt )
    else
        timeEnemyOne = timeEnemyOne - ( 0.9 * dt )
    end
    
    if timeEnemyOne < 0 then
        timeEnemyOne = delayEnemyOne
        numRandom = math.random( 7, love.graphics.getWidth() - ( ( imgEnemyOne:getWidth() ) + 7 ) )
        if numRandom < gameWidth - 80 then
            newEnemyOne = { x = numRandom, y = -3, img = imgEnemyOne }
            table.insert( enemiesOne, newEnemyOne )
        end
    end
    for i, enemyOneHead in ipairs( enemiesOne ) do
        enemyOneHead.y = enemyOneHead.y + ( 200 * dt )
        if enemyOneHead.y > 600 then
            table.remove( enemiesOne, i )
        end
    end
    
end

function enemyTwoComing( dt )

    if score <= 100 then
        timeEnemyTwo = timeEnemyTwo - ( 0.5 * dt )
    elseif score > 100 and score <= 500 then
        timeEnemyTwo = timeEnemyTwo - ( 0.6 * dt )
    elseif score > 500 and score <= 1000 then
        timeEnemyTwo = timeEnemyTwo - ( 0.7 * dt )
    else
        timeEnemyTwo = timeEnemyTwo - ( 0.8 * dt )
    end
    
    if timeEnemyTwo < 0 then
        timeEnemyTwo = delayEnemyTwo
        numRandom = math.random( 5, love.graphics.getWidth() - ( ( imgEnemyTwo:getWidth() ) + 5 ) )
        if numRandom < gameWidth - 80 then
            newEnemyTwo = { x = numRandom, y = -1, img = imgEnemyTwo } --y value mustbe negative
            table.insert( enemiesTwo, newEnemyTwo )
        end
    end
    for i, enemyTwoHead in ipairs( enemiesTwo ) do
        enemyTwoHead.y = enemyTwoHead.y + ( 200 * dt )
        if enemyTwoHead.y > 600 then
            table.remove( enemiesTwo, i )
        end
    end
    
end

function enemy3Coming( dt )
    timeEnemy3 = timeEnemy3 - ( 0.2 * dt ) --(as > the number * dt, as much difficult)
    if timeEnemy3 < 0 then
        timeEnemy3 = delayEnemy3
        numRandom = math.random( 3, love.graphics.getWidth() - ( ( imgEnemy3:getWidth() ) + 3 ) )
        if numRandom < gameWidth - 80 then
            newEnemy3 = { x = numRandom, y = -8, img = imgEnemy3 } --y value mustbe negative
            table.insert( enemies3, newEnemy3 )
        end
    end
    for i, enemy3Head in ipairs( enemies3 ) do
        enemy3Head.y = enemy3Head.y + ( 200 * dt )
        if enemy3Head.y > 600 then
            table.remove( enemies3, i )
        end
    end
end

function bitcoinComing( dt )
    timeBitcoin = timeBitcoin - ( 0.05 * dt )
    if timeBitcoin < 0 then
        timeBitcoin = delayBitcoin
        numRandom = math.random( 7, love.graphics.getWidth() - ( ( imgBitcoin:getWidth() ) + 7 ) )
        if numRandom < gameWidth - 50 then
            newBitcoin = { x = numRandom, y = -10, img = imgBitcoin }
            table.insert( bitcoins, newBitcoin )
        end
    end
    for i, bitcoinHead in ipairs( bitcoins ) do
        bitcoinHead.y = bitcoinHead.y + ( 200 * dt )
        if bitcoinHead.y > 600 then
            table.remove( bitcoins, i )
        end
    end
end

function ethComing( dt )
    timeEth = timeEth - ( 0.1 * dt )
    if timeEth < 0 then
        timeEth = delayEth
        numRandom = math.random( 7, love.graphics.getWidth() - ( ( imgEth:getWidth() ) + 7 ) )
        if numRandom < gameWidth - 80 then
            newEth = { x = numRandom, y = -5, img = imgEth }
            table.insert( eths, newEth )
        end
    end
    for i, ethHead in ipairs( eths ) do
        ethHead.y = ethHead.y + ( 200 * dt )
        if ethHead.y > 600 then
            table.remove( eths, i )
        end
    end
end

function collisions()
    for i, enemyOneHead in ipairs( enemiesOne ) do
        for j, missileShoot in ipairs( shootings ) do
            if checkCollisions( enemyOneHead.x, enemyOneHead.y, imgEnemyOne:getWidth(), imgEnemyOne:getHeight(), missileShoot.x, missileShoot.y, missileImg:getWidth(), missileImg:getHeight() ) then
                table.remove( shootings, j )
                table.remove( enemiesOne, i )
                enemyBoom:stop()
                enemyBoom:play()
                scaleX = 1.5
                scaleY = 1.5
                score = score + 1
            end
        end
        if checkCollisions( enemyOneHead.x, enemyOneHead.y, imgEnemyOne:getWidth(), imgEnemyOne:getHeight(), droidScreen.posX, droidScreen.posY, droid:getWidth(), droid:getHeight() ) then
            table.remove( enemiesOne, i )
            aLive = false
        end
    end
    for i, enemyTwoHead in ipairs( enemiesTwo ) do
        for j, missileShoot in ipairs( shootings ) do
            if checkCollisions( enemyTwoHead.x, enemyTwoHead.y, imgEnemyTwo:getWidth(), imgEnemyTwo:getHeight(), missileShoot.x, missileShoot.y, missileImg:getWidth(), missileImg:getHeight() ) then
                table.remove( shootings, j )
                table.remove( enemiesTwo, i )
                enemyTwoBoom:stop()
                enemyTwoBoom:play()
                scaleX = 1.5
                scaleY = 1.5
                score = score - 1
            end
        end
        if checkCollisions( enemyTwoHead.x, enemyTwoHead.y, imgEnemyTwo:getWidth(), imgEnemyTwo:getHeight(), droidScreen.posX, droidScreen.posY, droid:getWidth(), droid:getHeight() ) then
            table.remove( enemiesTwo, i )
            aLive = false
        end
    end
    for i, enemy3Head in ipairs( enemies3 ) do
        for j, missileShoot in ipairs( shootings ) do
            if checkCollisions( enemy3Head.x, enemy3Head.y, imgEnemy3:getWidth(), imgEnemy3:getHeight(), missileShoot.x, missileShoot.y, missileImg:getWidth(), missileImg:getHeight() ) then
                table.remove( shootings, j )
                table.remove( enemies3, i )
                enemyBoom:stop()
                enemyBoom:play()
                scaleX = 1.5
                scaleY = 1.5
                score = score + 2
            end
        end
        if checkCollisions( enemy3Head.x, enemy3Head.y, imgEnemy3:getWidth(), imgEnemy3:getHeight(), droidScreen.posX, droidScreen.posY, droid:getWidth(), droid:getHeight() ) then
            table.remove( enemies3, i )
            aLive = false
        end
    end
    for i, bitcoinHead in ipairs ( bitcoins ) do
        if checkCollisions( bitcoinHead.x, bitcoinHead.y, imgBitcoin:getWidth(), imgBitcoin:getHeight(), droidScreen.posX, droidScreen.posY, droid:getWidth(), droid:getHeight() ) then
            table.remove( bitcoins, i )
            bitcoinSound:stop()
            bitcoinSound:play()
            score = score + 6
        end
    end
    for i, ethHead in ipairs ( eths ) do
        if checkCollisions( ethHead.x, ethHead.y, imgEth:getWidth(), imgEth:getHeight(), droidScreen.posX, droidScreen.posY, droid:getWidth(), droid:getHeight() ) then
            table.remove( eths, i )
            bitcoinSound:stop()
            bitcoinSound:play()
            score = score + 3
        end
    end
end

function checkCollisions( x1, y1, w1, h1, x2, y2, w2, h2 )
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function reset()
    if not aLive and love.keyboard.isDown( 'return' ) then
        droidEnd:play()
        droidEnd:setLooping( false )
        shootings = {}
        enemies = {}
            
        shooting = timeShooting
        timeEnemy = delayEnemy
            
        droidScreen.posX = 300
        droidScreen.posY = 500
            
        score = 0
        aLive = true
    end
    if not aLive and love.keyboard.isDown( 'escape' ) then
        love.quit()
    end
end

function scoreEffects( dt )
    scaleX = scaleX - 1 * dt
    scaleY = scaleY - 1 * dt
    if scaleX <= 1 then
        scaleX = 1
        scaleY = 1
    end
end

function love.keypressed()
    if love.keyboard.isDown( 'escape' ) then
		love.event.quit()
	end
end

function love.quit()
    love.event.quit()
    love.filesystem.write( 'scores.lua', 'highscore\n=\n' ..highscore )
end