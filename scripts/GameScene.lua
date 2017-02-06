dictionary = require("DictionaryCommon")
PokerManager = require("PokerManager")
Player = require("Player")



local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end )


-- 构造函数初始化
function GameScene:ctor()

    PokerManager._mainScene = self


    -- 设置随机种子
    math.randomseed(os.time())
    -- 生成一个随机数   来判断是谁先出牌
    PokerManager._playerId = math.random(1, 3)
    -- PokerManager._playerId = 1

    -- 加载纹理
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("HJ.plist", "HJ.png")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ZD.plist", "ZD.png")

    -- 初始化背景图片
    local mainBg = display.newSprite("main_bg.jpg")
    mainBg:setPosition(display.cx, display.cy)
    self:addChild(mainBg)

    -- 初始化top层
    Player:initTopLayer(self);

    -- 初始化任务按钮和道具按钮
    self:initTaskAndPokerBtn()

    -- 初始化扑克牌
    PokerManager:initManage();
    PokerManager:fapaiPoker()
    PokerManager:showPokers(self)

    -- 初始化玩家
    Player:initPlays(self);
    Player:initHideButton(self)
    -- 初始化时钟
    Player:initTime(self);
    -- 初始化每个玩家牌数量的标签
    Player:initPokersLabel(self)
    -- 初始化不出
    Player:initLabelSprite(self)

    -- 展示第一次选地主的控制按钮标签
    Player:showFirstControlButton()
    -- 全局计时器
    self._scheduler = require("framework.scheduler")

    -- 2秒后取消玩家对牌的触摸监听
    self._scheduler.performWithDelayGlobal(function()
        self.setTouchInvlid()
    end , 2)

    self:registerScheduler(self._scheduler)

    --    dump(PokerManager._pokerSprites[PokerManager._playerId])
--        table.sort(PokerManager._pokerSprites[PokerManager._playerId], function(a, b)
--            return PokerManager._pokerSprites[PokerManager._playerId][a] > PokerManager._pokerSprites[PokerManager._playerId][b]
--        end )
    --    print(PokerManager._pokerSprites[PokerManager._playerId][1])
    --    PokerManager._pokerSprites[PokerManager._playerId][8]=nil
    --    for k,v in pairs(PokerManager._pokerSprites[PokerManager._playerId]) do
    --         print(k)
    --    end

--    t={}
--    function t:a() print(111)  end
--    b=t.a
--    print(b)
      
--      t={a,"d"=2,c}
--      print(t[-1])
      --print(PokerManager._pokerSprites[PokerManager._playerId][-1])

end

function GameScene:onEnterTransitionDidFinish()
    print "onEnterTransitionDidFinish"
end



-- 初始化中间最右边的按钮
function GameScene:initTaskAndPokerBtn()
    -- 初始化任务按钮
    local taskStr = dictionary.getGameStr("label_task")
    local taskBtn = cc.ui.UIPushButton.new( { normal = "button_task.png" }, { scale9 = false })
    taskBtn:setAnchorPoint(ccp(0.5, 0))
    taskBtn:setPosition(display.width - taskBtn:getContentSize().width / 2 - 10, display.height / 2)
    taskBtn:setButtonLabel("normal", cc.ui.UILabel.new( { UILabelType = 2, text = taskStr, size = 30 }))

    local task_sprite=display.newSprite("transparent_task_bg.png")
    task_sprite:setPosition(display.width+task_sprite:getContentSize().width*0.5,display.cy+35)
    self:addChild(task_sprite)
    local task_label=ui.newTTFLabel({text=dictionary.getGameStr("task0"),size=30})
    task_sprite:addChild(task_label)
    task_label:setPosition(320,100)
    local task_label2=ui.newTTFLabel({text=dictionary.getGameStr("task0"),size=30})
    task_sprite:addChild(task_label2)
    task_label2:setPosition(320,50)
    local flag=true
    taskBtn:onButtonClicked( function(event)
        print "taskBtn isClicked"
        if flag then
            task_sprite:runAction(CCMoveBy:create(0.3,ccp(-(task_sprite:getContentSize().width),0)))
            flag=false
        else
            task_sprite:runAction(CCMoveBy:create(0.3,ccp((task_sprite:getContentSize().width),0)))
            flag=true
        end
    end )
    self:addChild(taskBtn)


    -- 初始化道具按钮
    local pokerStr = dictionary.getGameStr("label_poker")
    local pokerBtn = cc.ui.UIPushButton.new( { normal = "button_poker.png" }, { scale9 = false })
    pokerBtn:setAnchorPoint(ccp(0.5, 1))
    pokerBtn:setPosition(display.width - pokerBtn:getContentSize().width / 2 - 10, display.height / 2)
    pokerBtn:setButtonLabel("normal", cc.ui.UILabel.new( { UILabelType = 2, text = pokerStr, size = 30 }))
    pokerBtn:onButtonClicked( function(event)
        print "pokerBtn isClicked"
    end )
    self:addChild(pokerBtn)
end



-- 叫地主的时候不能点击牌  设置触摸监听为false
function GameScene:setTouchInvlid()

    for i = 1, 3 do
        for key, var in ipairs(PokerManager._pokerSprites[i]) do

            var:setTouchEnabled(false)
        end
    end
end



function GameScene:registerScheduler(scheduler)

    -- self._scheduler=require("framework.scheduler")
    Player._schedulerId = scheduler.scheduleUpdateGlobal( function(dt)

        -- 显示时间
        if PokerManager._isShowNextTime then
            for key, var in ipairs(Player._timeSprites) do
                if key == PokerManager._playerId then

                    var:setVisible(true)
                else
                    var:setVisible(false)
                end
            end
        end


        -- 持续更新玩家的出牌时间  控制在20秒以内
        Player._currentTime[PokerManager._playerId] = Player._currentTime[PokerManager._playerId] - dt
        Player._timeLabel[PokerManager._playerId]:setString(math.floor(Player._currentTime[PokerManager._playerId]) .. "'")

        -- 如果时间为0是则自动出牌，然后跳转到下一个玩家
        if Player._currentTime[PokerManager._playerId] <= 0 then

            -- 自动出牌    如果是第一轮出牌则自动出牌
            if PokerManager._lastType == -1 and PokerManager._lastMaxPokerValue == -1 then

                -- 重置当前玩家的时间
                Player._currentTime[PokerManager._playerId] = 20
                Player._timeLabel[PokerManager._playerId]:setString("20")
                

                PokerManager._recordPokers[#PokerManager._playerPokers[PokerManager._playerId]]=PokerManager._playerPokers[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]]
                PokerManager._recordSprites[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]] = PokerManager._pokerSprites[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]]
                Player:clickedControlButton4(self)

                PokerManager._isShowNextTime = true

            else

                -- 时间到了就像点击了不出按钮
                Player:firstButtonCallBack()
            end


            --            for key,var in ipairs(PokerManager._pokerSprites[PokerManager._playerId]) do

            --                if key==5 then
            --                PokerManager._recordPokers[key]=PokerManager._playerPokers[PokerManager._playerId][key]
            --                PokerManager._recordSprites[PokerManager._playerId][key] =PokerManager._pokerSprites[PokerManager._playerId][key]
            --                Player:clickedControlButton4(self)
            --                break
            --                end
            --            end
        end
    end )
end


return GameScene