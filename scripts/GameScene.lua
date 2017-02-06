dictionary = require("DictionaryCommon")
PokerManager = require("PokerManager")
Player = require("Player")



local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end )


-- ���캯����ʼ��
function GameScene:ctor()

    PokerManager._mainScene = self


    -- �����������
    math.randomseed(os.time())
    -- ����һ�������   ���ж���˭�ȳ���
    PokerManager._playerId = math.random(1, 3)
    -- PokerManager._playerId = 1

    -- ��������
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("HJ.plist", "HJ.png")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ZD.plist", "ZD.png")

    -- ��ʼ������ͼƬ
    local mainBg = display.newSprite("main_bg.jpg")
    mainBg:setPosition(display.cx, display.cy)
    self:addChild(mainBg)

    -- ��ʼ��top��
    Player:initTopLayer(self);

    -- ��ʼ������ť�͵��߰�ť
    self:initTaskAndPokerBtn()

    -- ��ʼ���˿���
    PokerManager:initManage();
    PokerManager:fapaiPoker()
    PokerManager:showPokers(self)

    -- ��ʼ�����
    Player:initPlays(self);
    Player:initHideButton(self)
    -- ��ʼ��ʱ��
    Player:initTime(self);
    -- ��ʼ��ÿ������������ı�ǩ
    Player:initPokersLabel(self)
    -- ��ʼ������
    Player:initLabelSprite(self)

    -- չʾ��һ��ѡ�����Ŀ��ư�ť��ǩ
    Player:showFirstControlButton()
    -- ȫ�ּ�ʱ��
    self._scheduler = require("framework.scheduler")

    -- 2���ȡ����Ҷ��ƵĴ�������
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



-- ��ʼ���м����ұߵİ�ť
function GameScene:initTaskAndPokerBtn()
    -- ��ʼ������ť
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


    -- ��ʼ�����߰�ť
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



-- �е�����ʱ���ܵ����  ���ô�������Ϊfalse
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

        -- ��ʾʱ��
        if PokerManager._isShowNextTime then
            for key, var in ipairs(Player._timeSprites) do
                if key == PokerManager._playerId then

                    var:setVisible(true)
                else
                    var:setVisible(false)
                end
            end
        end


        -- ����������ҵĳ���ʱ��  ������20������
        Player._currentTime[PokerManager._playerId] = Player._currentTime[PokerManager._playerId] - dt
        Player._timeLabel[PokerManager._playerId]:setString(math.floor(Player._currentTime[PokerManager._playerId]) .. "'")

        -- ���ʱ��Ϊ0�����Զ����ƣ�Ȼ����ת����һ�����
        if Player._currentTime[PokerManager._playerId] <= 0 then

            -- �Զ�����    ����ǵ�һ�ֳ������Զ�����
            if PokerManager._lastType == -1 and PokerManager._lastMaxPokerValue == -1 then

                -- ���õ�ǰ��ҵ�ʱ��
                Player._currentTime[PokerManager._playerId] = 20
                Player._timeLabel[PokerManager._playerId]:setString("20")
                

                PokerManager._recordPokers[#PokerManager._playerPokers[PokerManager._playerId]]=PokerManager._playerPokers[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]]
                PokerManager._recordSprites[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]] = PokerManager._pokerSprites[PokerManager._playerId][#PokerManager._playerPokers[PokerManager._playerId]]
                Player:clickedControlButton4(self)

                PokerManager._isShowNextTime = true

            else

                -- ʱ�䵽�˾������˲�����ť
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