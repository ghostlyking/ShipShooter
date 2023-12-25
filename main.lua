
-- Objects
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
    return self.x + self.img:getWidth()/2 , self.y - self.img:getHeight()/2, 16
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
    self:setPosition(self.x, self.y-1)
    if (self.y<0-self.img:getHeight()) then
        return false
    end
    return true
end

function Missile.getCentroid(self)
    return self.x + self.img:getWidth()/2 , self.y + self.img:getHeight()/2, 8
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

    love.mouse.setVisible(false)

    player = Player.new(20,love.graphics.getHeight() - ship:getHeight(),ship)

    alien = Alien.new(100,0,alien1)
end

function love.keypressed( key, scancode, isrepeat )
    local dx, dy = 0, 0

    if scancode == "space" then -- move right
       m = Missile.new(player.x,player.y,missile)
       table.insert(missiles, m)
    end
 end

 function collission(thingA, thingB)
    x1,y1,r1 = thingA:getCentroid()
    x2,y2,r2 = thingB:getCentroid()

    if (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) < (r1+r2)*(r1+r2) then
        return true
    end
    
    return false
 end
 

function love.update()
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
        if (collission(alien, m)) then
            score = score + 100
            table.remove(missiles, key)
            alien:reset()
        end

        local dead = m:update()
        if (dead == false) then
            -- Remove missiles that flew off the top
            table.remove(missiles, key)
        end
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

    -- draw the alien
    alien:draw()

    love.graphics.print(score, 0, 0)

end