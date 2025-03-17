-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

local physics = require("physics")
physics.start()

-- 전역 변수(예: 점수, 낙하 속도)
local score = 0
local fallSpeed = 200  -- 초기 낙하 속도 (숫자가 클수록 빠름)

-- 충돌 처리 함수
local function onCollision(event)
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2
        
        -- 만약 와인(태그 "wine")과 바구니(태그 "basket")가 충돌하면
        if (obj1.tag == "wine" and obj2.tag == "basket") or
           (obj1.tag == "basket" and obj2.tag == "wine") then
            score = score + 1
            print("점수: " .. score)
            -- 충돌한 와인 삭제
            if obj1.tag == "wine" then
                display.remove(obj1)
            else
                display.remove(obj2)
            end
        end
    end
end

Runtime:addEventListener("collision", onCollision)

function scene:create(event)
    local sceneGroup = self.view

    -- 배경 설정
    local background = display.newRect(display.contentCenterX, display.contentCenterY,
        display.actualContentWidth, display.actualContentHeight)
    background:setFillColor(0.9)
    sceneGroup:insert(background)

    -- 플레이어(바구니) 생성
    local basket = display.newImageRect("image/human.png", 120, 80)
    basket.x = display.contentCenterX
    basket.y = display.contentHeight - 50
    basket.tag = "human"
    sceneGroup:insert(basket)
    physics.addBody(basket, "static")  -- 고정체

    -- 터치로 좌우 이동
    local function moveBasket(event)
        if event.phase == "began" or event.phase == "moved" then
            basket.x = event.x
        end
        return true
    end
    background:addEventListener("touch", moveBasket)

    -- 와인 낙하 함수
    local function dropWine()
        local wine = display.newImageRect("image/wine.png", 40, 100)
        wine.x = math.random(40, display.contentWidth - 40)
        wine.y = -50  -- 화면 위쪽에서 시작
        wine.tag = "wine"
        sceneGroup:insert(wine)
        physics.addBody(wine, "dynamic", {bounce = 0})
        
        -- 와인 하강 속도는 fallSpeed 변수에 따라 조절됨
        wine:setLinearVelocity(0, fallSpeed)
    end

    -- 일정 간격으로 와인 생성
    timer.performWithDelay(1000, dropWine, 0)

    -- 일정 시간마다 낙하 속도 증가 (예: 10초마다 속도 증가)
    timer.performWithDelay(10000, function()
        fallSpeed = fallSpeed + 50  -- 속도 증가
        print("낙하 속도 증가: " .. fallSpeed)
    end, 0)
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        -- 게임 시작 시 필요한 이벤트나 타이머를 추가할 수 있음
    end
end

function scene:hide(event)
    -- 게임 중지, 타이머 정지 등의 작업
end

function scene:destroy(event)
    -- 씬 삭제 전 정리 작업
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
