
-- local PokerManager = require("PokerManager")
dictionary = require("DictionaryCommon")


local Player = { }


Player._People = { 1, 2, 3 }        
-- 隐藏起来的控制按钮
Player._controlButton = { }
-- 隐藏按钮上的标签
Player._btnFirstLabel = { }
Player._btnSecondLabel = { }

-- 初始化玩家出盘倒计时
Player._currentTime = { 20, 20, 20 };
Player._timeLabel = { nil, nil, nil }

-- 时钟的精灵
Player._timeSprites = { }


-- 初始化玩家牌数量的标签
Player._pokerLabel = { }
-- 初始化玩家扑克牌的数量
Player._pokersCount = { 17, 17, 17 }


-- 记录玩家是否点击了不出牌
Player._recordClickedBuChu = { - 1, - 1, - 1 }


-- 胜  负  低分  倍数
Player._winCount = 0
Player._loserCount = 0
Player._diFenCount = 0
Player._multipleCount = 1

-- 存放胜  负  低分  倍数 label的数组
Player._dataLabel = { }

Player._schedulerId = nil

-- 玩家的名字
Player._playerNameRand = { }


-- 火箭炸弹 标志，用于判断是否播放帧动画
Player._huoJian = false
-- Player._zhaDan=false

-- label   不要，不叫，一分，两分，三分
Player._labelSprites = { }


-- 是否是第一轮出牌
Player._isFirstChuPai = true

-- 地主玩家id
Player._diZhuId = -1


-- 点击了提示按钮
Player._tiShi = false

-- 点击不叫地主按钮的次数
Player._clickBuJiaoCount = 0
--
Player._clickOneScoreCount = 0
Player._clickTwoScoreCount = 0

--点击一分的玩家id
Player._clickOneId=0
Player._clickTwoId=0


-- 初始化玩家
function Player:initPlays(mainScene)


    -- 初始化主角
    local playSprite0 = display.newSprite("my_head_0.jpg");
    playSprite0:setScale(0.5)
    playSprite0:setPosition(playSprite0:getContentSize().width / 2 + 20, display.height / 2 - 50);
    mainScene:addChild(playSprite0, 1);
    -- 为主角设置触摸监听
    playSprite0:setTouchEnabled(true);
    playSprite0:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE);
    local playerInfo1 = require("InfoLayer").new()
    playerInfo1:showPlayerInfo(0)
    mainScene:addChild(playerInfo1, 50)
    playerInfo1:setVisible(false)
    playerInfo1:setTouchEnabled(false)
    playSprite0:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        print "playSprite0 is touched"
        playerInfo1:setVisible(true)
        playerInfo1:setTouchEnabled(true)
    end )

    -- 初始化主角边框   head_nm.png 农民的边框
    local borderSprite0 = display.newSprite("head_nm.png");
    borderSprite0:setPosition(playSprite0:getPosition());
    borderSprite0:setScale(1.5);
    mainScene:addChild(borderSprite0, 0, 1);


    -- 初始化主角农民的帽子
    local capSprite0 = display.newSprite("nm_cap.png")
    capSprite0:setPosition(cc.p(playSprite0:getPositionX() - playSprite0:getContentSize().width / 2 + 20, playSprite0:getPositionY() + playSprite0:getContentSize().height / 2 - 20));
    mainScene:addChild(capSprite0, 0, 11);

    -- 初始化主角的名字背景
    local playNameBg0 = display.newSprite("main_name_bg.png")
    playNameBg0:setPosition(playSprite0:getPositionX(), playSprite0:getPositionY() -80)
    mainScene:addChild(playNameBg0);
    -- 初始化主角名字
    local playStr0 = require("DictionaryCommon").getGameStr("succeed_name")
    local label = ui.newTTFLabel( { text = playStr0, size = 30, align = ui.TEXT_ALIGN_CENTER })
    label:setPosition(playNameBg0:getPosition())
    mainScene:addChild(label)


    -- 随机玩家2和玩家3   rand表示玩家名的索引
    local rand1;
    local rand2;
    repeat
        rand1 = math.random(8);
        self._playerNameRand[1] = rand1
        rand2 = math.random(8);
        self._playerNameRand[2] = rand2
    until rand1 ~= rand2


    -- 初始化玩家2边框
    local borderSprite1 = display.newSprite("head_nm.png")
    borderSprite1:setPosition(display.width - 70, display.height - 70)
    borderSprite1:setScale(1.5);
    mainScene:addChild(borderSprite1, 0, 2)

    -- 初始化玩家2
    local playSprite1 = display.newSprite("head_" .. rand1 .. ".jpg")
    playSprite1:setPosition(display.width - 70, display.height - 70)
    playSprite1:setScale(0.5)
    mainScene:addChild(playSprite1, 1)


    -- 初始化玩家2农民帽子
    local capSprite1 = display.newSprite("nm_cap.png")
    capSprite1:setPosition(playSprite1:getPositionX() -50, playSprite1:getPositionY() + 50);
    mainScene:addChild(capSprite1, 0, 22);

    -- 初始化玩家2名字标签背景
    local playNameBg1 = display.newSprite("main_name_bg.png")
    playNameBg1:setPosition(playSprite1:getPositionX(), playSprite1:getPositionY() -80)
    mainScene:addChild(playNameBg1);
    -- 初始化玩家2名字标签
    local playNameStr1 = dictionary.getGameStr("name_" .. rand1)
    -- local playNameLabel1=cc.ui.UILabel.new({UILabelType=2,text=playNameStr1,size=30})     --锚点位置是从（0，0.5)好像
    local playNameLabel1 = ui.newTTFLabel( { text = playNameStr1, size = 30 })
    playNameLabel1:setPosition(playNameBg1:getPosition())
    mainScene:addChild(playNameLabel1)

    -- 玩家2触摸监听
    playSprite1:setTouchEnabled(true)
    playSprite1:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE);
    local playerInfo2 = require("InfoLayer").new()
    playerInfo2:showPlayerInfo(rand1)
    mainScene:addChild(playerInfo2, 50)
    playerInfo2:setVisible(false)
    playerInfo2:setTouchEnabled(false)
    playSprite1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        print "playSprite1 is clicked"

        playerInfo2:setVisible(true)
        playerInfo2:setTouchEnabled(true)
    end )


    -- 初始化玩家3边框
    local borderSprite2 = display.newSprite("head_nm.png")
    borderSprite2:setPosition(70, display.height - 70)
    borderSprite2:setScale(1.5);
    mainScene:addChild(borderSprite2, 0, 3)

    -- 初始化玩家3
    local playSprite2 = display.newSprite("head_" .. rand2 .. ".jpg")
    playSprite2:setPosition(70, display.height - 70)
    playSprite2:setScale(0.5)
    mainScene:addChild(playSprite2, 1)



    -- 初始化玩家3农民帽子
    local capSprite2 = display.newSprite("nm_cap.png", 0, 3)
    capSprite2:setPosition(playSprite2:getPositionX() -50, playSprite2:getPositionY() + 50);
    mainScene:addChild(capSprite2, 0, 33);

    -- 初始化玩家3名字标签背景
    local playNameBg2 = display.newSprite("main_name_bg.png")
    playNameBg2:setPosition(playSprite2:getPositionX(), playSprite2:getPositionY() -80)
    mainScene:addChild(playNameBg2);
    -- 初始化玩家3名字标签
    local playNameStr2 = dictionary.getGameStr("name_" .. rand2)
    -- local playNameLabel1=cc.ui.UILabel.new({UILabelType=2,text=playNameStr1,size=30})     --锚点位置是从（0，0.5)好像
    local playNameLabel2 = ui.newTTFLabel( { text = playNameStr2, size = 30 })
    playNameLabel2:setPosition(playNameBg2:getPosition())
    mainScene:addChild(playNameLabel2)

    -- 玩家3触摸监听
    playSprite2:setTouchEnabled(true)
    playSprite2:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE);
    local playerInfo3 = require("InfoLayer").new()
    playerInfo3:showPlayerInfo(rand2)
    mainScene:addChild(playerInfo3, 50)
    playerInfo3:setVisible(false)
    playerInfo3:setTouchEnabled(false)
    playSprite2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        print "playSprite2 is clicked"
        playerInfo3:setVisible(true)
        playerInfo3:setTouchEnabled(true)
    end )

end

function Player:initHideButton(scene)


    -------------------------------------------------------------------------------------------------
    -- 初始化第一个button
    self._controlButton[1] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[1]:setPosition(336, 250);
    scene:addChild(self._controlButton[1]);
    self._controlButton[1]:onButtonClicked( function()
        self:firstButtonCallBack(scene)
    end )
    -- 初始化按钮上面的文字标签
    local btnStr01 = dictionary.getGameStr("main_bujiao")
    btnStr02 = dictionary.getGameStr("main_buchu")
    self._btnFirstLabel[1] = ui.newTTFLabel( { text = btnStr01, size = 30 })
    self._btnFirstLabel[1]:setVisible(false);
    self._controlButton[1]:addChild(self._btnFirstLabel[1]);
    self._btnSecondLabel[1] = ui.newTTFLabel( { text = btnStr02, size = 30 })
    self._btnSecondLabel[1]:setVisible(false);
    self._controlButton[1]:addChild(self._btnSecondLabel[1]);
    -- 按钮设置不可见
    self._controlButton[1]:setVisible(false);



    -- 第二个按钮的回调函数
    -------------------------------------------------------------------------------------------------
    function secondButtonCallBack()
        print "button2 is clicked"
        if self._btnFirstLabel[2]:isVisible() then

            self:setControlButtonDisable(2)


            -- 显示一分
            self:showLabelSprite(PokerManager._playerId, 1, true)
            --点击次数加1
            self._clickOneScoreCount = self._clickOneScoreCount + 1
            --记录点击一分的玩家id
            self._clickOneId=PokerManager._playerId
            if self:judgeDiZhu(scene) then
                -- 保存地主id
                self._diZhuId = PokerManager._playerId

                -- 设置地主的背景和帽子
                self:setDiZhuSprite(scene)

                -- 重新生成当前玩家的牌
                PokerManager:removeSprites(scene)

               -- 添加地主的扑克牌数
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- 更新扑克牌数的标签
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

            else
                self:nextPlayer(PokerManager._playerId)

                -- 显示下一个玩家的时间
                PokerManager._isShowNextTime = true
            end

        else

            -- 重置选择的牌
            PokerManager:resetRecordSprite(PokerManager._playerId)

            --
            self:setControlButtonDisable(2)
            self:setControlButtonDisable(4)

        end
    end



    -- 初始化第2个button
    self._controlButton[2] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[2]:setPosition(456, 250);
    scene:addChild(self._controlButton[2]);
    self._controlButton[2]:onButtonClicked(secondButtonCallBack)
    -- 初始化按钮上面的文字标签
    local btnStr11 = dictionary.getGameStr("main_chongxuan")
    local btnStr12 = dictionary.getGameStr("main_score_1")
    self._btnSecondLabel[2] = ui.newTTFLabel( { text = btnStr11, size = 30 })
    self._btnSecondLabel[2]:setVisible(false)
    self._btnFirstLabel[1]:setVisible(false);
    self._controlButton[2]:addChild(self._btnSecondLabel[2]);
    self._btnFirstLabel[2] = ui.newTTFLabel( { text = btnStr12, size = 30 })
    self._btnFirstLabel[2]:setVisible(false);
    self._controlButton[2]:addChild(self._btnFirstLabel[2]);
    -- 按钮设置不可见
    self._controlButton[2]:setVisible(false);



    -- 点中第三个按钮的回调函数
    function controlButton3CallBack()

        print("controlButton3 is clicked")
        -- 点中两分的按钮
        if self._btnFirstLabel[3]:isVisible() then
            
            -- 显示两分
            self:showLabelSprite(PokerManager._playerId, 2, true) 

            self._clickTwoScoreCount = self._clickTwoScoreCount + 1

            self._clickTwoId=PokerManager._playerId

            if self:judgeDiZhu(scene) then
                -- 保存地主id
                self._diZhuId = PokerManager._playerId
                -- 设置地主的背景和帽子
                self:setDiZhuSprite(scene)

                -- 重新生成当前玩家的牌
                PokerManager:removeSprites(scene)


            else

                -- 转到下一个玩家选地主
                self:nextPlayer(PokerManager._playerId)

                -- 显示下一个玩家的时间
                PokerManager._isShowNextTime = true

                self:setControlButtonDisable(2)
                self:setControlButtonDisable(3)
            end


            -- 点中提示按钮
        else
            self._tiShi = true

            if PokerManager:judgeChuPai(PokerManager._playerPokers[PokerManager._playerId], PokerManager._lastType, PokerManager._lastMaxPokerValue) then

                -- 设置出牌按钮可用
                self:setControlButtonEnable(4)

                PokerManager._recordPokers = PokerManager._recordPokerAI
                dump(PokerManager._recordSpritesAI)

                for key, var in pairs(PokerManager._recordSpritesAI) do

                    PokerManager._recordSprites[PokerManager._playerId][key] = var

                    PokerManager._recordSprites[PokerManager._playerId][key]:runAction(CCMoveBy:create(0.3, ccp(0, 30)))
                    
                    -- 清楚之前的监听
                    -- clickFlag[PokerManager._playerId][key]=true
                    --                    clickFlag=PokerManager:getFlag()
                    --                    clickFlag[PokerManager._playerId][key]=true

                    --PokerManager:setFlag(PokerManager._playerId,key,true)

                    -- 重新注册监听事件
                    --PokerManager:setPokerTouch(PokerManager._playerId, key, var)

                    PokerManager:setFlag(PokerManager._playerId,key,true)

                end
            end
        end

        --          --测试，手动跑点击提示    测试失败
        --          self:clicktiShiCallBack()
        -- end
    end

    -- 初始化第3个button
    self._controlButton[3] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[3]:setPosition(576, 250);
    scene:addChild(self._controlButton[3]);
    self._controlButton[3]:onButtonClicked(controlButton3CallBack)
    -- 设置按钮文字标签
    local btnStr21 = dictionary.getGameStr("main_tishi")
    local btnStr22 = dictionary.getGameStr("main_score_2")
    self._btnSecondLabel[3] = ui.newTTFLabel( { text = btnStr21, size = 30 })
    self._btnSecondLabel[3]:setVisible(false);
    self._controlButton[3]:addChild(self._btnSecondLabel[3]);

    self._btnFirstLabel[3] = ui.newTTFLabel( { text = btnStr22, size = 30 })
    self._btnFirstLabel[3]:setVisible(false);
    self._controlButton[3]:addChild(self._btnFirstLabel[3]);
    -- 按钮设置不可见
    self._controlButton[3]:setVisible(false);


    -- 初始化第4个button
    self._controlButton[4] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[4]:setPosition(696, 250);
    scene:addChild(self._controlButton[4]);


    self._controlButton[4]:onButtonClicked( function()
        self:clickedControlButton4(scene)
    end )
    -- 设置按钮文字标签
    local btnStr31 = dictionary.getGameStr("main_chupai")
    local btnStr32 = dictionary.getGameStr("main_score_3")
    self._btnSecondLabel[4] = ui.newTTFLabel( { text = btnStr31, size = 30 })
    self._btnSecondLabel[4]:setVisible(false)
    self._controlButton[4]:addChild(self._btnSecondLabel[4]);
    self._btnFirstLabel[4] = ui.newTTFLabel( { text = btnStr32, size = 30 })
    self._btnFirstLabel[4]:setVisible(false)
    self._controlButton[4]:addChild(self._btnFirstLabel[4])
    -- 按钮设置不可见
    self._controlButton[4]:setVisible(false);



end



-- 初始化时间
function Player:initTime(mainScene)


    -- 初始化主角时钟
    self._timeSprites[1] = CCSprite:create("clock.png")
    self._timeSprites[1]:setPosition(200, 200)
    mainScene:addChild(self._timeSprites[1]);
    local timeLabel1 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel1:setPosition(self._timeSprites[1]:getContentSize().width / 2, self._timeSprites[1]:getContentSize().height / 2 - 5)
    self._timeSprites[1]:addChild(timeLabel1);
    -- 设置时钟不可见
    self._timeSprites[1]:setVisible(false);
    -- 设置self._timeLabel中的标签
    self._timeLabel[1] = timeLabel1


    -- 初始化玩家2时钟
    self._timeSprites[2] = display.newSprite("clock.png")
    self._timeSprites[2]:setPosition(780, 530)
    mainScene:addChild(self._timeSprites[2]);
    local timeLabel2 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel2:setPosition(self._timeSprites[2]:getContentSize().width / 2, self._timeSprites[2]:getContentSize().height / 2 - 5)
    self._timeSprites[2]:addChild(timeLabel2);
    -- 设置时钟不可见
    self._timeSprites[2]:setVisible(false);
    -- 设置self._timeLabel中的标签
    self._timeLabel[2] = timeLabel2


    -- 初始化玩家3时钟
    self._timeSprites[3] = display.newSprite("clock.png")
    self._timeSprites[3]:setPosition(180, 580)
    mainScene:addChild(self._timeSprites[3]);
    local timeLabel3 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel3:setPosition(self._timeSprites[2]:getContentSize().width / 2, self._timeSprites[2]:getContentSize().height / 2 - 5)
    self._timeSprites[3]:addChild(timeLabel3);
    -- 设置时钟不可见
    self._timeSprites[3]:setVisible(false);
    -- 设置self._timeLabel中的标签
    self._timeLabel[3] = timeLabel3


    for key, var in ipairs(self._timeSprites) do

        if key == PokerManager._playerId then

            var:setVisible(true)
        end

    end
end


-- 转换成第二种标签

function Player:convertSecondLabel()

    -- 将选地主的标签设置为不可见
    for key, var in ipairs(self._btnFirstLabel) do

        if var:isVisible() then
            var:setVisible(false)
        end
    end

    -- 显示出牌的标签
    for key, var in ipairs(self._btnSecondLabel) do
        if var:isVisible() == false then
            var:setVisible(true)
        end
    end

    -- 将控制按钮的纹理改变
    for key, var in ipairs(self._controlButton) do

        if key == 1 or key == 3 then

        else
            var:setButtonImage("normal", "button_disable_bg.png")
        end
    end
end


-- 设置当前地主的背景和帽子
function Player:setDiZhuSprite(scene)

    -- 背景
    local bgSprite = scene:getChildByTag(PokerManager._playerId)
    self._dzBgSprite = display.newSprite("head_dz.png")
    self._dzBgSprite:setPosition(bgSprite:getPosition())
    -- bgSprite:removeFromParentAndCleanup(true)
    self._dzBgSprite:setScale(1.5)
    scene:addChild(self._dzBgSprite)


    -- 帽子
    local capSprite = scene:getChildByTag(PokerManager._playerId + PokerManager._playerId * 10)
    self._dzCapSprite = display.newSprite("dz_cap.png")
    self._dzCapSprite:setPosition(capSprite:getPosition())
    scene:addChild(self._dzCapSprite)
    -- capSprite:removeFromParentAndCleanup(true)
end


-- 初始化玩家牌数量的标签
function Player:initPokersLabel(mainScene)

    for i = 1, 3 do
        self._pokerLabel[i] = ui.newTTFLabel( { text = 17, size = 30 });
        if i == 1 then
            self._pokerLabel[i]:setPosition(70, 100)
        elseif i == 2 then
            self._pokerLabel[i]:setPosition(ccp(780, 620))
        else
            self._pokerLabel[i]:setPosition(ccp(180, 620))
        end
        mainScene:addChild(self._pokerLabel[i])
    end
end


-- 计算每一个玩家的牌
function Player:updatePokerLabel(count, playerId)

    self._pokersCount[playerId] = self._pokersCount[playerId] - count
    self._pokerLabel[playerId]:setString("" .. self._pokersCount[playerId])
end

-- 下一个玩家，改变当前玩家的id
function Player:nextPlayer()

    if PokerManager._playerId == 3 then
        PokerManager._playerId = 1
    else
        PokerManager._playerId = PokerManager._playerId + 1
    end
end



-- 显示玩家的第一次控制按钮  选地主
function Player:showFirstControlButton()

    for key, var in ipairs(Player._controlButton) do

        var:setVisible(true)
        var:setScale(0.75)
        self._btnFirstLabel[key]:setVisible(true);
    end
end


-- 点击第四个按钮的函数
function Player:clickedControlButton4(scene)
    print "button4 is clicked"


    -- 点击3分抢地主
    if self._btnFirstLabel[4]:isVisible() then

        -- 显示三分
        self:showLabelSprite(PokerManager._playerId, 2, true)

        -- 保存地主id
        self._diZhuId = PokerManager._playerId

        -- 转换成第二种标签
        self:convertSecondLabel()

        -- 移除不叫 一分 两分的精灵
        self:setSpriteHide()

        -- 设置底分
        self._diFenCount = 3
        self._dataLabel[3]:setString(self._diFenCount)

        -- 设置地主的背景和帽子
        self:setDiZhuSprite(scene)

        ---------------------------------------------------------------
        -- 重新生成当前玩家的牌
        PokerManager:removeSprites(scene)

        ---------------------------------------------------------------

        -- 添加地主的扑克牌数
        self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
        -- 更新扑克牌数的标签
        self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

        -- 设置所有玩家的扑克牌可触摸
        for i = 1, 3 do

            if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            end
        end


        -- 设置标签不可见
        self._btnFirstLabel[4]:setVisible(false)


        -- 更新玩家的出牌时间
        self._currentTime[PokerManager._playerId] = 20

    else


        local i = 0;
        local y = 0
        local x = 0



        --播放音效
        require("GameEffect"):playEffect(PokerManager._ChuPaiType,self:getCurrentSex(PokerManager._playerId),PokerManager._MaxValue+3)


        -- 执行一个动作，把扑克牌移动到中间
        for key, var in ipairs(PokerManager._recordSprites[PokerManager._playerId]) do

            if var ~= -1 and tolua.isnull(var) ~= true then
                if PokerManager._playerId == 1 then
                    y = display.height * 0.5
                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 60

                elseif PokerManager._playerId == 2 then
                    y = display.height * 0.5 + 200
                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 30 + 200
                elseif PokerManager._playerId == 3 then
                    y = display.height * 0.5 + 100
                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 30 - 200
                end

                local spawn = CCSpawn:createWithTwoActions(CCMoveTo:create(0.7, ccp(x, y)), CCScaleTo:create(0.7, 0.5))

                var:runAction(spawn)
                i = i + 1

            end
        end

        -- 出牌的时候判断是否是火箭，是则播放火箭的帧动画
        if self._huoJian then
            self:playHuoJianAnimation(scene)
        end
        if PokerManager._ChuPaiType == 4 then
            self:playZhaDanAnimation(scene)
            -- self._zhaDan=false
        end


        -- 把记录的牌的位置记录下来 方便下面的调整牌的位置
        local points = { }

        for key, var in pairs(PokerManager._recordPokers) do

            points[key] = key
            PokerManager._recordPokers[key] = nil

        end

        -- 设置不可出牌
        PokerManager._isCanChuPai = false
        self:setControlButtonDisable(4)
        -- 设置重选按钮不可用
        self:setControlButtonDisable(2)

        -- 跳转到下一个玩家出牌
        -- PokerManager._nextPlayer = true

        -- 隐藏按钮
        if PokerManager._isCanChuPai == false then
            self._controlButton[4]:setButtonImage("normal", "button_disable_bg.png")
        end


        -- 出牌后调整玩家扑克牌的位置
        PokerManager:adjustPosition(PokerManager._pokerSprites, PokerManager._Count, PokerManager._playerId, points)


        -- 更新玩家牌数的label
        self:updatePokerLabel(PokerManager._Count, PokerManager._playerId)


        -- 判断手中的牌是否出完
        if self._pokersCount[PokerManager._playerId] == 0 then

            print("------------------------------------------------------------------")
            print("you win the game")
            print("------------------------------------------------------------------")
            -- void    setIntegerForKey(const char* pKey, int value);
            local flag = false
            if PokerManager._playerId == self._diZhuId then
                flag = true
                local winCount = CCUserDefault:sharedUserDefault():getIntegerForKey("winCount")
                winCount = winCount + 1
                CCUserDefault:sharedUserDefault():setIntegerForKey("winCount", winCount)
            else
                local loseCount = CCUserDefault:sharedUserDefault():getIntegerForKey("loseCount")
                loseCount = loseCount + 1
                CCUserDefault:sharedUserDefault():setIntegerForKey("loseCount", loseCount)
            end

            -- 停止计时器
            self:stopScheduler(self._schedulerId)

            -- 显示胜利的层
            local gameOver = require("GameOver").new()
            gameOver:Resize(flag);
            scene:addChild(gameOver)

        elseif self._pokersCount[PokerManager._playerId]==1 then
            --播放音效
            require("GameEffect").playLastCard(self:getCurrentSex(PokerManager._playerId))
        elseif self._pokersCount[PokerManager._playerId]==2 then
            --播放音效
            require("GameEffect").playLast2Card(self:getCurrentSex(PokerManager._playerId))
        end



        -- 下一个玩家出牌
        self:nextPlayer()

        -- 重置下一个玩家的时间
        self._currentTime[PokerManager._playerId] = 20

        -- 移除下一个玩家显示的牌
        PokerManager:removeSelfRecords(PokerManager._recordSprites, PokerManager._playerId)

        -- 如果有不出sprite 则设置为不可见
        if self._labelSprites[PokerManager._playerId]:isVisible() then

            self:showLabelSprite(PokerManager._playerId, 4, false)
        end

        -- 保存上一个玩家出牌的数据
        PokerManager._lastCount = PokerManager._Count
        PokerManager._lastMaxPokerValue = PokerManager._MaxValue
        PokerManager._lastType = PokerManager._ChuPaiType


        -- 显示下一个玩家的时钟
        PokerManager._isShowNextTime = true


        -- 清空记录的ai牌
        PokerManager._recordPokerAI = { }
        PokerManager._recordSpritesAI = { }
    end
end


-- 是否有两个连续的玩家选择了不出牌
function Player:isClickedTwice(recordClicks)

    if recordClicks[1] == 1 and recordClicks[2] == 1 then
        return true
    elseif recordClicks[2] == 1 and recordClicks[3] == 1 then

        return true
    elseif recordClicks[3] == 1 and recordClicks[1] == 1 then

        return true
    else
        return false
    end

end


-- 设置控制按钮为可用
function Player:setControlButtonEnable(buttonId)

    if self._btnSecondLabel[buttonId]:isVisible() then
        self._controlButton[buttonId]:setButtonEnabled(true)
        self._controlButton[buttonId]:setButtonImage("normal", "button_bg.png")
    end
end

-- 设置按钮不可用
function Player:setControlButtonDisable(buttonId)

    if self._btnSecondLabel[buttonId]:isVisible() then
        self._controlButton[buttonId]:setButtonEnabled(false)
        self._controlButton[buttonId]:setButtonImage("normal", "button_disable_bg.png")
    else
        self._controlButton[buttonId]:setButtonEnabled(false)
        self._controlButton[buttonId]:setButtonImage("normal", "button_disable_bg.png")
    end
end



-- 初始化Top层
function Player:initTopLayer(mainScene)
    -- 初始化top背景
    local topLayer = display.newLayer()
    topLayer:setPosition(display.width / 2, display.height - 20);
    mainScene:addChild(topLayer);
    local topSprite = display.newSprite("main_top.png")
    topSprite:setScale(0.7);
    topLayer:setContentSize(topSprite:getContentSize());
    topLayer:addChild(topSprite);

    -- 初始化返回主界面按钮
    local backBtn = cc.ui.UIPushButton.new( { normal = "main_tuic.png", pressed = "main_tuic_pressed.png" }, { scale9 = false })
    backBtn:setPosition(topSprite:getPositionX() -170, topSprite:getPositionY())
    backBtn:onButtonClicked( function(event)
        print "backBtn clicked"

        -- 停止计时器
        self:stopScheduler(self._schedulerId)

        display.replaceScene(require("GameIndex").new(), "moveInL", 0.3)
    end )
    topLayer:addChild(backBtn);

    -- 设置界面按钮
    local setBtn = cc.ui.UIPushButton.new( { normal = "main_shez.png", pressed = "main_shez_pressed.png" }, { scale9 = false })
    setBtn:setPosition(topSprite:getPositionX() + 170, topSprite:getPositionY())
    setBtn:onButtonClicked( function(event)
        print "setBtn isCilcked"


        local settingLayer = require("SettingLayer"):new()
        mainScene:addChild(settingLayer)

        -- self:stopScheduler(self._schedulerId)

        -- local scheduler=

    end )
    topLayer:addChild(setBtn);


    -- 设置胜标签
    local winStr = require("DictionaryCommon").getGameStr("main_win");
    local winLabel = ui.newTTFLabel( { text = winStr, size = 20 });
    winLabel:setPosition(topSprite:getPositionX() -130, topSprite:getPositionY() + 10)
    topLayer:addChild(winLabel);
    -- 胜
    local winCount = CCUserDefault:sharedUserDefault():getIntegerForKey("winCount")
    self._dataLabel[1] = ui.newTTFLabel( { text = winCount, size = 20 })
    self._dataLabel[1]:setPosition(ccp(winLabel:getPositionX() + 30, winLabel:getPositionY()))
    topLayer:addChild(self._dataLabel[1])

    -- 设置负标签
    local loseStr = require("DictionaryCommon").getGameStr("main_lose");
    local loseLabel = ui.newTTFLabel( { text = loseStr, size = 20 })
    loseLabel:setPosition(topSprite:getPositionX() -130, topSprite:getPositionY() -10)
    topLayer:addChild(loseLabel);
    -- 负
    local loseCount = CCUserDefault:sharedUserDefault():getIntegerForKey("loseCount")
    self._dataLabel[2] = ui.newTTFLabel( { text = loseCount, size = 20 })
    self._dataLabel[2]:setPosition(ccp(loseLabel:getPositionX() + 30, loseLabel:getPositionY()))
    topLayer:addChild(self._dataLabel[2])

    -- 设置底分标签    UILabel可以
    local diScoreStr = dictionary.getGameStr("main_score")
    local scoreLabel = cc.ui.UILabel.new( { UILabelType = 2, text = diScoreStr, size = 20 })
    scoreLabel:setPosition(topSprite:getPositionX() + 70, topSprite:getPositionY() + 10)
    topLayer:addChild(scoreLabel);
    -- 底分
    self._dataLabel[3] = ui.newTTFLabel( { text = "0", size = 20 })
    self._dataLabel[3]:setPosition(scoreLabel:getPositionX() + 60, scoreLabel:getPositionY())
    topLayer:addChild(self._dataLabel[3])


    -- 设置倍数标签
    local multipleStr = dictionary.getGameStr("main_multiple")
    local multipleLabel = cc.ui.UILabel.new( { UILabelType = 2, text = multipleStr, size = 20 })
    multipleLabel:setPosition(topSprite:getPositionX() + 70, topSprite:getPositionY() -10)
    topLayer:addChild(multipleLabel);

    -- 倍数
    self._dataLabel[4] = ui.newTTFLabel( { text = "1", size = 20 })
    self._dataLabel[4]:setPosition(multipleLabel:getPositionX() + 60, multipleLabel:getPositionY())
    topLayer:addChild(self._dataLabel[4])

end

-- 停止计时器
function Player:stopScheduler(schedulerId)

    local ss = require("framework.scheduler")
    ss.unscheduleGlobal(schedulerId)
end




-- 初始化数据
function Player:resetData()

    -- 初始化玩家扑克牌的数量
    for i = 1, 3 do

        self._pokersCount[i] = 17
        self._currentTime[i] = 20
        self._timeLabel[i]:setString(self._currentTime[i])
        self._pokerLabel[i]:setString(self._pokersCount[i])
    end

    self._winCount = CCUserDefault:sharedUserDefault():getIntegerForKey("winCount")
    self._loserCount = CCUserDefault:sharedUserDefault():getIntegerForKey("loseCount")

    self._diFenCount = 0
    self._multipleCount = 1

    self._dataLabel[1]:setString(self._winCount)
    self._dataLabel[2]:setString(self._loserCount)
    self._dataLabel[3]:setString(self._diFenCount)
    self._dataLabel[4]:setString(self._multipleCount)

    self._diZhuId = -1

    -- 重新选地主
    self:converToFirestLabel()


    -- 移除当前地主
    self._dzBgSprite:removeFromParentAndCleanup(true)
    self._dzCapSprite:removeFromParentAndCleanup(true)

    -- 移除不出精灵
    self:setBuChuSpriteHide()

    --更新积分
    --require("InfoLayer"):updateJiFen()
end


-- 火箭动画
function Player:playHuoJianAnimation(mainScene)

    local huojian = display.newSprite("#huojianji.png")
    huojian:setPosition(display.cx, display.cy + 150)
    mainScene:addChild(huojian)

    local huo = display.newSprite("#huo0001.png")
    huo:setPosition(display.cx, display.height * 0.5 - 150 + 150)
    mainScene:addChild(huo)
    local huoframes = display.newFrames("huo000%d.png", 1, 6)
    local huoanimation = display.newAnimation(huoframes, 0.3)
    huo:playAnimationOnce(huoanimation, true, function()
        huojian:removeFromParent(true)
        self._huoJian = false
    end )

    local yang = display.newSprite("#yang-1.png")
    yang:setPosition(display.cx, display.cy - 200 + 150)
    mainScene:addChild(yang)
    local yangframes = display.newFrames("yang-%d.png", 1, 9)
    local yanganimation = display.newAnimation(yangframes, 0.3 * 6 / 9)
    yang:playAnimationOnce(yanganimation, true)

    local move = CCMoveBy:create(0.3 * 6, ccp(0, 100))
    local move2 = CCMoveBy:create(0.3 * 6, ccp(0, 100))
    local move3 = CCMoveBy:create(0.3 * 6, ccp(0, 100))
    huojian:runAction(move)
    huo:runAction(move2)
    yang:runAction(move3)

    -- 倍数增加
    self._multipleCount = self._multipleCount * 2
    self._dataLabel[4]:setString(self._multipleCount)
end


function Player:playZhaDanAnimation(mianScene)
    
    --audio.playSound("card_bomb_M.mp3")
    --SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()


    local zhadan = display.newSprite("#zhad-1.png")
    zhadan:setPosition(display.cx, display.cy)
    mianScene:addChild(zhadan)

    local zhadanframes = display.newFrames("zhad-%d.png", 2, 13)
    local zhadanAnimation = display.newAnimation(zhadanframes, 0.1)
    zhadan:playAnimationOnce(zhadanAnimation, true, function()

        print("zha dan play animation")
        --audio.playSound("card_bomb_M.mp3",true)
        
    end )

    -- 倍数增加
    self._multipleCount = self._multipleCount * 2
    self._dataLabel[4]:setString(self._multipleCount)

end


-- 初始化控制label精灵
function Player:initLabelSprite(mainScene)

    local texture = CCTextureCache:sharedTextureCache():addImage("score_fold.png")
    self._labelSprites[1] = CCSprite:createWithTexture(texture)
    self._labelSprites[1]:setPosition(display.cx - 280, display.cy - 50)
    self._labelSprites[1]:setVisible(false)
    mainScene:addChild(self._labelSprites[1])

    self._labelSprites[2] = CCSprite:createWithTexture(texture)
    self._labelSprites[2]:setPosition(display.width - 180, display.height - 80)
    self._labelSprites[2]:setVisible(false)
    mainScene:addChild(self._labelSprites[2])

    self._labelSprites[3] = CCSprite:createWithTexture(texture)
    self._labelSprites[3]:setPosition(display.cx - 300, display.height - 80)
    self._labelSprites[3]:setVisible(false)
    mainScene:addChild(self._labelSprites[3])
end


-- 改变控制label精灵的纹理和显示
function Player:showLabelSprite(playerId, _type, flag)
    if _type == 0 then
        self._labelSprites[playerId]:setTexture(CCTextureCache:sharedTextureCache():addImage("score_fold.png"))
    elseif _type == 1 then
        self._labelSprites[playerId]:setTexture(CCTextureCache:sharedTextureCache():addImage("score_one.png"))
    elseif _type == 2 then
        self._labelSprites[playerId]:setTexture(CCTextureCache:sharedTextureCache():addImage("score_two.png"))
    elseif _type == 3 then
        self._labelSprites[playerId]:setTexture(CCTextureCache:sharedTextureCache():addImage("score_three.png"))
    else
        self._labelSprites[playerId]:setTexture(CCTextureCache:sharedTextureCache():addImage("text_buchu.png"))
    end

    self._labelSprites[playerId]:setVisible(flag)
end


-- 第一个按钮的回调函数
-------------------------------------------------------------------------------------------------
function Player:firstButtonCallBack(scene)

    print "button1 is clicked"

    -- 先判断是不是选地主
    if self._btnFirstLabel[1]:isVisible() then

        -- 显示不叫
        self:showLabelSprite(PokerManager._playerId, 0, true)

        -- 显示下一个玩家的时间
        PokerManager._isShowNextTime = true

        -- 每次点击都加一
        self._clickBuJiaoCount = self._clickBuJiaoCount + 1

        -- 点击了三次不叫地主  第一个不叫的人为地主，底分为一
        if self:judgeDiZhu(scene) then
           
           if self._clickOneId~=0 and self._clickTwoId==0 then
                -- 保存地主id
                PokerManager._playerId=self._clickOneId
                self._diZhuId = self._clickOneId
                -- 设置地主的背景和帽子
                self:setDiZhuSprite(scene)

                -- 重新生成当前玩家的牌
                PokerManager:removeSprites(scene)

               -- 添加地主的扑克牌数
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- 更新扑克牌数的标签
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

            elseif  self._clickTwoId~=0 then

                 -- 保存地主id
                PokerManager._playerId=self._clickTwoId
                self._diZhuId = self._clickTwoId
                -- 设置地主的背景和帽子
                self:setDiZhuSprite(scene)

                -- 重新生成当前玩家的牌
                PokerManager:removeSprites(scene)

               -- 添加地主的扑克牌数
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- 更新扑克牌数的标签
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])
            else


            end
        else
            self:nextPlayer(PokerManager._playerId)
        end
    else
        
        --播放音效
        --得到当前玩家的性别
        local sex=self:getCurrentSex(PokerManager._playerId)
        require("GameEffect").playBuChu(sex)

        self:showLabelSprite(PokerManager._playerId, 4, true)

        self._recordClickedBuChu[PokerManager._playerId] = 1

        -- 转到下一个玩家出牌
        self:nextPlayer(PokerManager._playerId)

        -- 判断是否有连续两个玩家点击了不出
        if self:isClickedTwice(self._recordClickedBuChu) then

            -- 清空记录点击
            for i = 1, 3 do
                self._recordClickedBuChu[i] = -1
            end

            -- 清空last玩家的数据
            PokerManager:resetLastData()

            -- 恢复为第一轮出牌
            self._isFirstChuPai = true
        end

        -- 显示下一个玩家的时间
        PokerManager._isShowNextTime = true

        -- 记录玩家没有出牌
        self._recordClickedBuChu[PokerManager._playerId] = 1

        -- 移除下一个玩家显示的牌
        PokerManager:removeSelfRecords(PokerManager._recordSprites, PokerManager._playerId)

        -- 重置玩家的时间
        self._currentTime[PokerManager._playerId] = 20

        -- 如果有不出sprite 则设置为不可见
        if self._labelSprites[PokerManager._playerId]:isVisible() then

            self:showLabelSprite(PokerManager._playerId, 4, false)
        end
    end

end


-- 重置为第一种标签
function Player:converToFirestLabel()

    for i = 1, 4 do

        self._btnSecondLabel[i]:setVisible(false)
        self._btnFirstLabel[i]:setVisible(true)

        self._controlButton[i]:setButtonEnabled(true)
        self._controlButton[i]:setButtonImage("normal", "button_bg.png")
    end

end

-- 将不出的精灵设置为不可见
function Player:setBuChuSpriteHide()

    for key, var in ipairs(self._labelSprites) do

        if var:isVisible() then
            self:showLabelSprite(key, 4, false)
        end
    end
end

-- 将一分 两分 三分  不叫 的精灵都设置为不可见
function Player:setSpriteHide()
    for key, var in ipairs(self._labelSprites) do

        if var:isVisible() then
            var:setVisible(false)
        end
    end
end



---- 手动跑点中了提示按钮
-- function Player:clicktiShiCallBack()

--    self._tiShi = true

--    if PokerManager:judgeChuPai(PokerManager._playerPokers[PokerManager._playerId], PokerManager._lastType, PokerManager._lastMaxPokerValue) then

--        -- 设置出牌按钮可用
--        self:setControlButtonEnable(4)

--        -- PokerManager._recordPokers = PokerManager._recordPokerAI
--        -- dump(PokerManager._recordSpritesAI)

--        for key, var in pairs(PokerManager._recordSpritesAI) do

--            -- PokerManager._recordSprites[PokerManager._playerId][key] = var
--            --local flag=false
--            PokerManager:clickedPokerCallBack(key, var)

--        end
--    end
-- end


-- 判断到底是谁抢到了地主
function Player:judgeDiZhu(scene)

    if self._clickBuJiaoCount == 2 and self._clickOneScoreCount == 1 then

        self._clickOneScoreCount = 0
        -- 设置底分
        self._diFenCount = 1
        self._dataLabel[3]:setString(self._diFenCount)

        -- 移除不叫等精灵
        self:setSpriteHide()

        -- 重置点击次数
        self._clickBuJiaoCount = 0


        -- 转换成第二种标签
        self:convertSecondLabel()


        -- 设置所有玩家的扑克牌可触摸
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- 设置标签不可见
        self._btnFirstLabel[4]:setVisible(false)

        -- 更新玩家的出牌时间
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 2 and self._clickTwoScoreCount == 1 then

        self._clickTwoScoreCount = 0
        -- 设置底分
        self._diFenCount = 2
        self._dataLabel[3]:setString(self._diFenCount)

        -- 移除不叫等精灵
        self:setSpriteHide()

        -- 重置点击次数
        self._clickBuJiaoCount = 0


        -- 转换成第二种标签
        self:convertSecondLabel()


        -- 设置所有玩家的扑克牌可触摸
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- 设置标签不可见
        self._btnFirstLabel[4]:setVisible(false)

        -- 更新玩家的出牌时间
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 1 and self._clickTwoScoreCount == 1 and self._clickOneScoreCount == 1 then

        self._clickBuJiaoCount = 0
        -- 设置底分
        self._diFenCount = 2
        self._dataLabel[3]:setString(self._diFenCount)

        -- 移除不叫等精灵
        self:setSpriteHide()

        -- 重置点击次数
        self._clickBuJiaoCount = 0


        -- 转换成第二种标签
        self:convertSecondLabel()

        -- 添加地主的扑克牌数
        self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
        -- 更新扑克牌数的标签
        self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

        -- 设置所有玩家的扑克牌可触摸
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- 设置标签不可见
        self._btnFirstLabel[4]:setVisible(false)

        -- 更新玩家的出牌时间
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 3 then

        -- 下一个玩家
        self:nextPlayer(PokerManager._playerId)

        -- 移除不叫等精灵
        self:setSpriteHide()

        -- 重置点击次数
        self._clickBuJiaoCount = 0

        -- 保存地主id
        self._diZhuId = PokerManager._playerId

        -- 转换成第二种标签
        self:convertSecondLabel()

        -- 设置底分
        self._diFenCount = 1
        self._dataLabel[3]:setString(self._diFenCount)

        -- 设置地主的背景和帽子
        self:setDiZhuSprite(scene)

        -- 重新生成当前玩家的牌
        PokerManager:removeSprites(scene)


        -- 设置所有玩家的扑克牌可触摸
        for i = 1, 3 do

            if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            end
        end


        -- 设置标签不可见
        self._btnFirstLabel[4]:setVisible(false)


        -- 更新玩家的出牌时间
        self._currentTime[PokerManager._playerId] = 20
        return true
    end
    return false
end


--得到当前出牌玩家的性别
function Player:getCurrentSex(playerId)

      if playerId==1 then
           return "M"
      elseif playerId==2 then

           if self._playerNameRand[1]==2 or self._playerNameRand[1]==4 or self._playerNameRand[1]==6 then
                return "W"
           else
                return "M"
           end

      elseif playerId==3 then

           if self._playerNameRand[2]==2 or self._playerNameRand[2]==4 or self._playerNameRand[2]==6 then
                return "W"
           else
                return "M"
           end
      end
end

return Player;