local fCount = 0

-- Objects
local Animation = {}
Animation.__index = Animation
animations = {}

function Animation.new(_x,_y, _xs, _ys, _xc, _yc,  _count, _img)
    local self = setmetatable({}, Animation)

    self.x = _x
    self.y = _y
    self.xw = _xs
    self.yh = _ys  
    self.count = _count
    self.frame = 0
    self.frames = {}
    self.img = _img

    local counter = 0
    for fy=0, _yc-1, 1 do
        for fx=0, _xc-1, 1 do
            if counter == _count then
                goto AnimationNewExit
            end
            counter = counter + 1
            local f = love.graphics.newQuad(fx*_xs, fy*_ys, _xs, _ys, _img)
            table.insert(self.frames, f)
        end
    end
    
    ::AnimationNewExit::

    return self
end

function Animation.draw(self)
    love.graphics.draw(self.img, self.frames[self.frame%self.count+1], self.x, self.y, 0,0.3,0.3)
    self.frame = self.frame + 1
end

function Animation.done(self)
    if (self.frame >= self.count) then
        return true
    end
    return false
end

function Animation.setPosition(self, _x, _y)
    self.x = _x
    self.y = _y
end


--[[
    ######                                        
    #     # #        ##   #   # ###### #####  
    #     # #       #  #   # #  #      #    # 
    ######  #      #    #   #   #####  #    # 
    #       #      ######   #   #      #####  
    #       #      #    #   #   #      #   #  
    #       ###### #    #   #   ###### #    #
--]]
local Player = {}
Player.__index = Player

function Player.new(_x,_y, _img)
    local self = setmetatable({}, Player)

    self.x = _x
    self.y = _y
    self.img = _img
    return self
end

function Player.draw(self)
    love.graphics.draw(self.img, self.x, self.y)
end

function Player.setPosition(self, _x, _y)
    if _x > (love.graphics.getWidth() - self.img:getWidth()) then
        _x = love.graphics.getWidth() - self.img:getWidth()
    end

    self.x = _x
    self.y = _y
end
function Player.getCentroid(self)
    return self.x + self.img:getWidth()/2 +10 , self.y , 16
end

--[[
    #                           
   # #   #      # ###### #    # 
  #   #  #      # #      ##   # 
 #     # #      # #####  # #  # 
 ####### #      # #      #  # # 
 #     # #      # #      #   ## 
 #     # ###### # ###### #    #
--]]
local Alien = {}
Alien.__index = Alien

function Alien.new(_x,_y, _img)
    local self = setmetatable({}, Alien)

    self.x = _x
    self.y = _y
    self.img = _img

    return self
end

function Alien.draw(self)
    love.graphics.draw(self.img, self.x, self.y,0,1,-1)
end

function Alien.setPosition(self, _x, _y)
    if _x > (love.graphics.getWidth() - self.img:getWidth()) then
        _x = love.graphics.getWidth() - self.img:getWidth()
    end

    self.x = _x
    self.y = _y
end

function Alien.update(self)
    self.y = self.y + 1

    if (self.y > love.graphics.getHeight() + self.img:getHeight()) then
        self.y = 0
        score = score - 100
    end
end

function Alien.reset(self)
    self.y = 0
    self.x = math.random(0,love.graphics.getWidth() - self.img:getWidth())
end

function Alien.getCentroid(self)
    return self.x + self.img:getWidth()/2 , self.y - self.img:getHeight()/2, 28
end

--[[
 #####                             
 #     # #####   ##   #####   ####  
 #         #    #  #  #    # #      
  #####    #   #    # #    #  ####  
       #   #   ###### #####       # 
 #     #   #   #    # #   #  #    # 
  #####    #   #    # #    #  #### 
--]]
local Star = {}
Star.__index = Star
stars = {}

function Star.new(_x,_y, _size)
    local self = setmetatable({}, Star)

    self.x = _x
    self.y = _y
    self.size = _size

    return self
end

function Star.draw(self)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", self.x - self.size/2,self.y - self.size/2, self.size,self.size)
end

function Star.setPosition(self, _x, _y)
    self.x = _x
    self.y = _y
end

function Star.update(self)
    self:setPosition(self.x, self.y + self.size/2.0)
end

--[[
    #     #                                 
    ##   ## #  ####   ####  # #      ###### 
    # # # # # #      #      # #      #      
    #  #  # #  ####   ####  # #      #####  
    #     # #      #      # # #      #      
    #     # # #    # #    # # #      #      
    #     # #  ####   ####  # ###### ###### 
--]]
local Missile = {}
Missile.__index = Missile
missiles = {}

function Missile.new(_x,_y, _img)
    local self = setmetatable({}, Missile)

    self.x = _x
    self.y = _y
    self.img = _img
    if (math.random(1,2) == 2) then
        self.speedX = -3
    else
        self.speedX = 3
    end

    self.speedY = 0.8


    return self
end

function Missile.draw(self)
    love.graphics.draw(self.img, self.x, self.y)
end

function Missile.setPosition(self, _x, _y)
    if _x > (love.graphics.getWidth() - self.img:getWidth()) then
        _x = love.graphics.getWidth() - self.img:getWidth()
    end

    self.x = _x
    self.y = _y
end


function Missile.update(self)
    if (self.y<0-self.img:getHeight()) then
        return false
    end
    self:setPosition(self.x + self.speedX, self.y+self.speedY)

    self.speedY = self.speedY - 0.09

    self.speedX = self.speedX + (0 - (self.speedX / 10))

    return true
end

function Missile.getCentroid(self)
    return self.x + self.img:getWidth()/2 , self.y + self.img:getHeight()/2, 8
end

--[[
########  ##     ## ##       ##       ######## ######## 
##     ## ##     ## ##       ##       ##          ##    
##     ## ##     ## ##       ##       ##          ##    
########  ##     ## ##       ##       ######      ##    
##     ## ##     ## ##       ##       ##          ##    
##     ## ##     ## ##       ##       ##          ##    
########   #######  ######## ######## ########    ##    
--]]
local Bullet = {}
Bullet.__index = Bullet
bullets = {}

function Bullet.new(_x,_y, _img)
    local self = setmetatable({}, Bullet)

    self.x = _x
    self.y = _y
    self.img = _img
    self.speedX = 0
    self.speedY = -2
 
    return self
end

function Bullet.draw(self)
    love.graphics.draw(self.img, self.x + math.sin(self.y  )*10, self.y, 1.6, 0.25, 0.25)
end

function Bullet.setPosition(self, _x, _y)
    self.x = _x
    self.y = _y
end


function Bullet.update(self)
    if (self.y<0-self.img:getHeight()) then
        return false
    end

    self:setPosition(self.x + self.speedX, self.y+self.speedY)
    return true
end

function Bullet.getCentroid(self)
    return self.x + 8 , self.y + 5, 8
end

--[[
    #     #                 
    ##   ##   ##   # #    # 
    # # # #  #  #  # ##   # 
    #  #  # #    # # # #  # 
    #     # ###### # #  # # 
    #     # #    # # #   ## 
    #     # #    # # #    # 
--]]

score = 0

function love.load(args)
    io.stdout:setvbuf("no")
    math.randomseed(os.time())
    font = love.graphics.newFont(20)
    love.graphics.setFont(font)

    success = love.window.setMode( 400, 600, {} )


    ship = love.graphics.newImage("images/GoodShip.png")
    missile = love.graphics.newImage("images/Missile.png")
    alien1 = love.graphics.newImage("images/BadShip.png")
    explosionImg = love.graphics.newImage("images/Explosion1.png")
    Bullet_purple = love.graphics.newImage("images/Bullet.png")

    love.mouse.setVisible(false)

    player = Player.new(20,love.graphics.getHeight() - ship:getHeight(),ship)

    alien = Alien.new(100,0,alien1)

end

--[[
function love.keypressed( key, scancode, isrepeat )
    local dx, dy = 0, 0

    if scancode == "space" then -- move right
       m = Missile.new(player.x,player.y,missile)
       table.insert(missiles, m)
    end
 end
--]]

 function collision(thingA, thingB)
    x1,y1,r1 = thingA:getCentroid()
    x2,y2,r2 = thingB:getCentroid()

    if (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) < (r1+r2)*(r1+r2) then
        return true
    end
    
    return false
 end
 

function love.update()
    fCount = fCount + 1
    player:setPosition(love.mouse.getX(), player.y) 
    
    alien:update()

    -- Missile updates
    s = Star.new(math.random(0,love.graphics.getWidth()), 0, math.random(1,3))
    table.insert(stars,s)

    for key,s in ipairs(stars) do
        if (s.y > love.graphics.getHeight()) then
            table.remove(stars, key)
        end
        s:update()
    end


    -- Handle missiles
    for key,m in ipairs(missiles) do

        -- Check if the missile hit an alien
        if (collision(alien, m)) then
            score = score + 100
            table.remove(missiles, key)
            local e = Animation.new(alien.x - 16, alien.y - 64, 355, 360, 9,7,45,explosionImg)

            alien:reset()
            table.insert(animations, e)

        end

        local dead = m:update()
        if (dead == false) then
            -- Remove missiles that flew off the top
            table.remove(missiles, key)
        end
    end

    -- Handle bullets
    for key,b in ipairs(bullets) do

        -- Check if the missile hit an alien
        if (collision(alien, b)) then
            score = score + 100
            table.remove(bullets, key)
            local e = Animation.new(alien.x - 16, alien.y - 64, 355, 360, 9,7,45,explosionImg)

            alien:reset()
            table.insert(animations, e)
        end

        local dead = b:update()
        if (dead == false) then
            -- Remove missiles that flew off the top
            table.remove(bullets, key)
        end
    end

    if love.keyboard.isDown("space") then
        if (fCount % 60 == 0) then
            m = Missile.new(player.x,player.y,missile)
            table.insert(missiles, m)
        else if (fCount % 10 == 0) then
            local cx
            local cy
            cx, cy = player:getCentroid()
            b = Bullet.new(cx,cy,Bullet_purple)
            table.insert(bullets, b)
        end end
    end

end

function love.draw()
    -- Draw stars
    for key,s in ipairs(stars) do
        s:draw()
    end

    -- Draw the player
    player:draw()

    -- Draw the missiles
    for key,m in ipairs(missiles) do
        m:draw()
    end
    for key,b in ipairs(bullets) do
        b:draw()
    end

    -- draw the alien
    alien:draw()

    -- handle animations
    for key,a in ipairs(animations) do
        a:draw()
        if a:done() then
            table.remove(animations, key)
        end
    end

    love.graphics.print(score, 0, 0)

end