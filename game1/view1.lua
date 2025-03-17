-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require("physics")
physics.start()

-- 전역 변수(예: 점수, 낙하 속도)
local score = 0
local fallSpeed = 200  -- 초기 낙하 속도 (숫자가 클수록 빠름)


function scene:create( event )
	local sceneGroup = self.view
	
	-- 배경 설정
	local background = display.newImageRect("image/background.png",display.contentWidth,display.contentHeight)
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	-- start 버튼 삽입, 위치 설정
	local startBotten = display.newImage("image/start.png")
	startBotten.x, startBotten.y = display.contentCenterX, display.contentHeight*0.7

	-- startBotten 펄스 효과 함수
	local function pulse()
		transition.to(startBotten, { 
			time = 500, 
			xScale = 1.03,
			yScale = 1.03,
			transition = easing.inOutQuad,
			onComplete = function()
				transition.to(startBotten, { 
					time = 500, 
					xScale = 1.0, 
					yScale = 1.0, 
					transition = easing.inOutQuad,
					onComplete = pulse  -- 효과를 계속 반복
				})
			end
		})
	end
	
	pulse()  -- 펄스 효과 시작

	-- start 버튼 터치시 삭제
	-- 터치 이벤트 리스너 함수
	local function onImageTap(event)
    	-- 터치된 이미지(event.target)를 삭제합니다.
    	display.remove(event.target)
    	event.target = nil  -- 선택 사항: 메모리 해제를 돕기 위해 nil로 설정
    	return true  -- 이벤트 전파 중단
	end

	startBotten:addEventListener("tap", onImageTap)

	-- 와인, 플레이어, 바구니 생성
	local playerGroup = display.newGroup()

	local basket = display.newImage("image/basket.png")
	basket.x, basket.y = display.contentWidth*0.61, display.contentHeight*0.827
	playerGroup:insert(basket)

	local player = display.newImage("image/player.png")
	player.x, player.y = display.contentCenterX, display.contentHeight*0.88
	playerGroup:insert(player)

	-- 터치 이벤트로 그룹 이동 예시
	local offsetX = 0  -- 터치 시작 시 플레이어 그룹과 터치 위치 간의 차이를 저장할 변수

local function movePlayer(event)
    if event.phase == "began" then
        -- 터치가 시작될 때 플레이어 그룹의 x좌표와 터치 x좌표의 차이를 저장합니다.
        offsetX = playerGroup.x - event.x
    elseif event.phase == "moved" then
        -- 터치가 이동할 때, 저장한 offset을 더해줍니다.
        playerGroup.x = event.x + offsetX
    end
    return true
end

background:addEventListener("touch", movePlayer)

	-- 와인 위치 랜덤 설정(y축 고정)

	-- 와인 하강 속도 점점 증가

	-- p 좌우 이동 가능(y축 고정)

	-- 바구니에 와인 닿을 시 점수 증가, 와인 삭제

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene