--
-- Abstract: embeddablescrollview Library Plugin Test Project
--
-- This is an example Corona Project documenting how
-- to use the Embeddable Scrollview library.
--
-- Created by Joseph Hinkle
--
------------------------------------------------------------

-- Load plugin library
local embeddableScrollview = require "plugin.embeddablescrollview"

local widget = require "widget"

-------------------------------------------------------------------------------
-- BEGIN (Insert your sample test starting here)
-------------------------------------------------------------------------------

-- screen positioning
local screenW = display.contentWidth
local screenH = display.contentHeight
local screenAW = display.actualContentWidth
local screenAH = display.actualContentHeight
local screenCX = display.contentCenterX
local screenCY = display.contentCenterY
local screenL = -(screenAW-screenW)*.5
local screenR = screenAW-(screenAW-screenW)*.5
local screenT = -(screenAH-screenH)*.5
local screenB = screenAH-(screenAH-screenH)*.5

-- main scrollview
local scrollView = widget.newScrollView(
    {
        top = screenT,
        left = screenL,
        width = screenAW,
        height = screenAH,
        horizontalScrollDisabled = true
    }
)

-- add shapes to scrollview
for i=1, 50 do
    local line = display.newLine( screenL, i*50, screenR, i*50 )
    line.strokeWidth = 3
    line:setStrokeColor( .85 )
    scrollView:insert(line)

    if i % 3 == 1 then
        local embeddedScrollView = embeddableScrollview.create(
            {
                top = i*50,
                left = screenL,
                width = screenAW,
                height = 50,
                verticalScrollDisabled = true,
                hideBackground = true,
                displayObjectToGiveTouchFocusFromVerticalScroll = scrollView
            }
        )
        scrollView:insert(embeddedScrollView)
        for i=1, 20 do
            local circle = display.newCircle( screenL + (i-.5)*50, 23, 20 )
            local num = math.random( 1, 3 )
            if num == 1 then
                circle:setFillColor( .85, .85, 1 )
            elseif num == 2 then
                circle:setFillColor( .85, 1, .85 )
            else
                circle:setFillColor( 1, .85, .85 )
            end
            embeddedScrollView:insert( circle )
        end
    elseif i % 3 == 2 then
        local embeddedScrollView
        local embeddableScrollViewHeight = 50
        embeddedScrollView = embeddableScrollview.create(
            {
                top = i*50,
                left = screenL,
                width = screenAW,
                height = embeddableScrollViewHeight,
                horizontalScrollDisabled = true,
                hideBackground = true,
                displayObjectToGiveTouchFocusFromHorizontalScroll = scrollView,
                displayObjectToGiveTouchFocusFromFunctionCall = scrollView,
                listener = function( event )
                    local view = embeddedScrollView:getView()
                    local y = view.y
                    if event.phase == "moved" then
                        if y > 0 then
                            view.y = 0
                            embeddedScrollView:giveFocusAway()
                        elseif y < -(view.height - embeddableScrollViewHeight) then
                            view.y = math.min(0,-(view.height - embeddableScrollViewHeight))
                            embeddedScrollView:giveFocusAway()
                        end
                    end
                end
            }
        )
        scrollView:insert(embeddedScrollView)
        for i=1, 10 do
            for j=1, 10 do
                local rect = display.newRoundedRect( screenL + (i-1)*(screenAW/9), (j-.5)*20, 10, 10, 1 )
                local num = math.random( 1, 3 )
                if num == 1 then
                    rect:setFillColor( .85, .85, 1 )
                elseif num == 2 then
                    rect:setFillColor( .85, 1, .85 )
                else
                    rect:setFillColor( 1, .85, .85 )
                end
                embeddedScrollView:insert( rect )
            end
        end
    else
        local poly = display.newPolygon( screenCX, i*50 + 25, {-20,10,0,-10,20,10} )
        local num = math.random( 1, 3 )
        if num == 1 then
            poly:setFillColor( .85, .85, 1 )
        elseif num == 2 then
            poly:setFillColor( .85, 1, .85 )
        else
            poly:setFillColor( 1, .85, .85 )
        end
        scrollView:insert(poly)
    end
end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------
