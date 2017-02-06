require("Tag")

local InfoLayer = class("InfoLayer", function()

    return display.newLayer()
end )


function InfoLayer:ctor()

    local bg = display.newSprite("dialog_person_bg.png")
    bg:setPosition(display.cx, display.cy)
    self:addChild(bg)

    local closeBtn = cc.ui.UIPushButton.new( { normal = "close.png", pressed = "close_pressed.png" }, { scale9 = true })
    closeBtn:setPosition(display.cx + 190, display.cy + 180)
    self:addChild(closeBtn)
    closeBtn:onButtonClicked( function(event)
        print("closeBtn is clicked")
        self:setVisible(false)
        self:setTouchEnabled(false)
    end )

    local infotitle = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_title"), size = 40 })
    infotitle:setPosition(display.cx, display.height * 0.5 + bg:getContentSize().height * 0.5 - 30)
    self:addChild(infotitle)



end

function InfoLayer:showPlayerInfo(playId)


    if playId == 0 then

        local playerSprite = display.newSprite("my_head_0.jpg")
        playerSprite:setPosition(display.cx - 100, display.cy + 50)
        self:addChild(playerSprite)

        local name = ui.newTTFLabel( { text = dictionary.getGameStr("succeed_name"), size = 30 })
        name:setPosition(display.cx + 100, display.cy + 80)
        self:addChild(name)

        local score_label = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_score"), szie = 30 })
        score_label:setPosition(display.cx + 100, display.cy + 30)
        self:addChild(score_label)

        local person_score = ui.newTTFLabel( { text = CCUserDefault:sharedUserDefault():getIntegerForKey("totalScore"), szie = 30 })
        person_score:setPosition(display.cx + 150, display.cy + 30)
        self:addChild(person_score,0,20)
        
        local money_label = ui.newTTFLabel( { text = dictionary.getGameStr("shop_coin_num"), szie = 30 })
        money_label:setPosition(display.cx + 50, display.cy)
        self:addChild(money_label)

        local money_label = ui.newTTFLabel( { text =20000, szie = 30 })
        money_label:setPosition(display.cx + 150, display.cy)
        self:addChild(money_label)

        local winning_label=ui.newTTFLabel({text=dictionary.getGameStr("dialog_person_win"),size=30})
        winning_label:setPosition(display.cx-100,display.cy-50)
        self:addChild(winning_label)

        local winCount=CCUserDefault:sharedUserDefault():getIntegerForKey("winCount")
        local loseCount=CCUserDefault:sharedUserDefault():getIntegerForKey("loseCount")
        local win=math.floor(winCount/(winCount+loseCount)*100)
        local winrate_label=ui.newTTFLabel({text=win .. " %",size=30})
        winrate_label:setPosition(display.cx-30,display.cy-50)
        self:addChild(winrate_label)

        local win_label=ui.newTTFLabel({text=("(" .. dictionary.getGameStr("main_win") .. winCount .. "/"  .. dictionary.getGameStr("main_lose") .. loseCount .. ")"),size=30})
        win_label:setPosition(display.cx+100,display.cy-50)
        self:addChild(win_label)


        -- local sting=CCString:createWithFormat("sd%d",13)
        --        local score=ui.newTTFLabel({text=string,size=30})
        --        score:setPosition(display.cx + 100, display.cy + 20)
        --        self:addChild(score)

        --        local scorelabel = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_score0"), size = 30 })
        --        scorelabel:setPosition(display.cx - 140, display.cy - 60)
        --        self:addChild(scorelabel)

        --        local winlabel = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_win0"), size = 30 })
        --        winlabel:setPosition(display.cx + 80, display.cy - 60)
        --        self:addChild(winlabel)

    else
        local playerSprite = display.newSprite("head_" .. playId .. ".jpg")
        playerSprite:setPosition(display.cx - 100, display.cy + 50)
        self:addChild(playerSprite)

        local name = ui.newTTFLabel( { text = dictionary.getGameStr("name_" .. playId), size = 30 })
        name:setPosition(display.cx + 100, display.cy + 80)
        self:addChild(name)

        local introduce = ui.newTTFLabel( { text = dictionary.getGameStr("introduce_" .. playId), size = 25 })
        introduce:setPosition(display.cx + 100, display.cy + 20)
        self:addChild(introduce)

        local content = ui.newTTFLabel( { text = dictionary.getGameStr("content_" .. playId), size = 30 })
        content:setPosition(display.cx, display.cy - 150)
        self:addChild(content)

        local win = ui.newTTFLabel( { text = dictionary.getGameStr("win_" .. playId), size = 30 })
        win:setPosition(display.cx + 150, display.cy - 60)
        self:addChild(win)

        local score = ui.newTTFLabel( { text = dictionary.getGameStr("score_" .. playId), size = 30 })
        score:setPosition(display.cx - 80, display.cy - 60)
        self:addChild(score)

        local scorelabel = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_score"), size = 30 })
        scorelabel:setPosition(display.cx - 140, display.cy - 60)
        self:addChild(scorelabel)

        local winlabel = ui.newTTFLabel( { text = dictionary.getGameStr("dialog_person_win"), size = 30 })
        winlabel:setPosition(display.cx + 80, display.cy - 60)
        self:addChild(winlabel)
    end
end

--更新积分
function InfoLayer:updateJiFen()

     local jifen=self:getChildByTag(20)
     jifen:setString(CCUserDefault:sharedUserDefault():getIntegerForKey("totalScore"))
end

return InfoLayer
