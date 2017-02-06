
-- local PokerManager = require("PokerManager")
dictionary = require("DictionaryCommon")


local Player = { }


Player._People = { 1, 2, 3 }        
-- ���������Ŀ��ư�ť
Player._controlButton = { }
-- ���ذ�ť�ϵı�ǩ
Player._btnFirstLabel = { }
Player._btnSecondLabel = { }

-- ��ʼ����ҳ��̵���ʱ
Player._currentTime = { 20, 20, 20 };
Player._timeLabel = { nil, nil, nil }

-- ʱ�ӵľ���
Player._timeSprites = { }


-- ��ʼ������������ı�ǩ
Player._pokerLabel = { }
-- ��ʼ������˿��Ƶ�����
Player._pokersCount = { 17, 17, 17 }


-- ��¼����Ƿ����˲�����
Player._recordClickedBuChu = { - 1, - 1, - 1 }


-- ʤ  ��  �ͷ�  ����
Player._winCount = 0
Player._loserCount = 0
Player._diFenCount = 0
Player._multipleCount = 1

-- ���ʤ  ��  �ͷ�  ���� label������
Player._dataLabel = { }

Player._schedulerId = nil

-- ��ҵ�����
Player._playerNameRand = { }


-- ���ը�� ��־�������ж��Ƿ񲥷�֡����
Player._huoJian = false
-- Player._zhaDan=false

-- label   ��Ҫ�����У�һ�֣����֣�����
Player._labelSprites = { }


-- �Ƿ��ǵ�һ�ֳ���
Player._isFirstChuPai = true

-- �������id
Player._diZhuId = -1


-- �������ʾ��ť
Player._tiShi = false

-- ������е�����ť�Ĵ���
Player._clickBuJiaoCount = 0
--
Player._clickOneScoreCount = 0
Player._clickTwoScoreCount = 0

--���һ�ֵ����id
Player._clickOneId=0
Player._clickTwoId=0


-- ��ʼ�����
function Player:initPlays(mainScene)


    -- ��ʼ������
    local playSprite0 = display.newSprite("my_head_0.jpg");
    playSprite0:setScale(0.5)
    playSprite0:setPosition(playSprite0:getContentSize().width / 2 + 20, display.height / 2 - 50);
    mainScene:addChild(playSprite0, 1);
    -- Ϊ�������ô�������
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

    -- ��ʼ�����Ǳ߿�   head_nm.png ũ��ı߿�
    local borderSprite0 = display.newSprite("head_nm.png");
    borderSprite0:setPosition(playSprite0:getPosition());
    borderSprite0:setScale(1.5);
    mainScene:addChild(borderSprite0, 0, 1);


    -- ��ʼ������ũ���ñ��
    local capSprite0 = display.newSprite("nm_cap.png")
    capSprite0:setPosition(cc.p(playSprite0:getPositionX() - playSprite0:getContentSize().width / 2 + 20, playSprite0:getPositionY() + playSprite0:getContentSize().height / 2 - 20));
    mainScene:addChild(capSprite0, 0, 11);

    -- ��ʼ�����ǵ����ֱ���
    local playNameBg0 = display.newSprite("main_name_bg.png")
    playNameBg0:setPosition(playSprite0:getPositionX(), playSprite0:getPositionY() -80)
    mainScene:addChild(playNameBg0);
    -- ��ʼ����������
    local playStr0 = require("DictionaryCommon").getGameStr("succeed_name")
    local label = ui.newTTFLabel( { text = playStr0, size = 30, align = ui.TEXT_ALIGN_CENTER })
    label:setPosition(playNameBg0:getPosition())
    mainScene:addChild(label)


    -- ������2�����3   rand��ʾ�����������
    local rand1;
    local rand2;
    repeat
        rand1 = math.random(8);
        self._playerNameRand[1] = rand1
        rand2 = math.random(8);
        self._playerNameRand[2] = rand2
    until rand1 ~= rand2


    -- ��ʼ�����2�߿�
    local borderSprite1 = display.newSprite("head_nm.png")
    borderSprite1:setPosition(display.width - 70, display.height - 70)
    borderSprite1:setScale(1.5);
    mainScene:addChild(borderSprite1, 0, 2)

    -- ��ʼ�����2
    local playSprite1 = display.newSprite("head_" .. rand1 .. ".jpg")
    playSprite1:setPosition(display.width - 70, display.height - 70)
    playSprite1:setScale(0.5)
    mainScene:addChild(playSprite1, 1)


    -- ��ʼ�����2ũ��ñ��
    local capSprite1 = display.newSprite("nm_cap.png")
    capSprite1:setPosition(playSprite1:getPositionX() -50, playSprite1:getPositionY() + 50);
    mainScene:addChild(capSprite1, 0, 22);

    -- ��ʼ�����2���ֱ�ǩ����
    local playNameBg1 = display.newSprite("main_name_bg.png")
    playNameBg1:setPosition(playSprite1:getPositionX(), playSprite1:getPositionY() -80)
    mainScene:addChild(playNameBg1);
    -- ��ʼ�����2���ֱ�ǩ
    local playNameStr1 = dictionary.getGameStr("name_" .. rand1)
    -- local playNameLabel1=cc.ui.UILabel.new({UILabelType=2,text=playNameStr1,size=30})     --ê��λ���Ǵӣ�0��0.5)����
    local playNameLabel1 = ui.newTTFLabel( { text = playNameStr1, size = 30 })
    playNameLabel1:setPosition(playNameBg1:getPosition())
    mainScene:addChild(playNameLabel1)

    -- ���2��������
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


    -- ��ʼ�����3�߿�
    local borderSprite2 = display.newSprite("head_nm.png")
    borderSprite2:setPosition(70, display.height - 70)
    borderSprite2:setScale(1.5);
    mainScene:addChild(borderSprite2, 0, 3)

    -- ��ʼ�����3
    local playSprite2 = display.newSprite("head_" .. rand2 .. ".jpg")
    playSprite2:setPosition(70, display.height - 70)
    playSprite2:setScale(0.5)
    mainScene:addChild(playSprite2, 1)



    -- ��ʼ�����3ũ��ñ��
    local capSprite2 = display.newSprite("nm_cap.png", 0, 3)
    capSprite2:setPosition(playSprite2:getPositionX() -50, playSprite2:getPositionY() + 50);
    mainScene:addChild(capSprite2, 0, 33);

    -- ��ʼ�����3���ֱ�ǩ����
    local playNameBg2 = display.newSprite("main_name_bg.png")
    playNameBg2:setPosition(playSprite2:getPositionX(), playSprite2:getPositionY() -80)
    mainScene:addChild(playNameBg2);
    -- ��ʼ�����3���ֱ�ǩ
    local playNameStr2 = dictionary.getGameStr("name_" .. rand2)
    -- local playNameLabel1=cc.ui.UILabel.new({UILabelType=2,text=playNameStr1,size=30})     --ê��λ���Ǵӣ�0��0.5)����
    local playNameLabel2 = ui.newTTFLabel( { text = playNameStr2, size = 30 })
    playNameLabel2:setPosition(playNameBg2:getPosition())
    mainScene:addChild(playNameLabel2)

    -- ���3��������
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
    -- ��ʼ����һ��button
    self._controlButton[1] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[1]:setPosition(336, 250);
    scene:addChild(self._controlButton[1]);
    self._controlButton[1]:onButtonClicked( function()
        self:firstButtonCallBack(scene)
    end )
    -- ��ʼ����ť��������ֱ�ǩ
    local btnStr01 = dictionary.getGameStr("main_bujiao")
    btnStr02 = dictionary.getGameStr("main_buchu")
    self._btnFirstLabel[1] = ui.newTTFLabel( { text = btnStr01, size = 30 })
    self._btnFirstLabel[1]:setVisible(false);
    self._controlButton[1]:addChild(self._btnFirstLabel[1]);
    self._btnSecondLabel[1] = ui.newTTFLabel( { text = btnStr02, size = 30 })
    self._btnSecondLabel[1]:setVisible(false);
    self._controlButton[1]:addChild(self._btnSecondLabel[1]);
    -- ��ť���ò��ɼ�
    self._controlButton[1]:setVisible(false);



    -- �ڶ�����ť�Ļص�����
    -------------------------------------------------------------------------------------------------
    function secondButtonCallBack()
        print "button2 is clicked"
        if self._btnFirstLabel[2]:isVisible() then

            self:setControlButtonDisable(2)


            -- ��ʾһ��
            self:showLabelSprite(PokerManager._playerId, 1, true)
            --���������1
            self._clickOneScoreCount = self._clickOneScoreCount + 1
            --��¼���һ�ֵ����id
            self._clickOneId=PokerManager._playerId
            if self:judgeDiZhu(scene) then
                -- �������id
                self._diZhuId = PokerManager._playerId

                -- ���õ����ı�����ñ��
                self:setDiZhuSprite(scene)

                -- �������ɵ�ǰ��ҵ���
                PokerManager:removeSprites(scene)

               -- ��ӵ������˿�����
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- �����˿������ı�ǩ
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

            else
                self:nextPlayer(PokerManager._playerId)

                -- ��ʾ��һ����ҵ�ʱ��
                PokerManager._isShowNextTime = true
            end

        else

            -- ����ѡ�����
            PokerManager:resetRecordSprite(PokerManager._playerId)

            --
            self:setControlButtonDisable(2)
            self:setControlButtonDisable(4)

        end
    end



    -- ��ʼ����2��button
    self._controlButton[2] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[2]:setPosition(456, 250);
    scene:addChild(self._controlButton[2]);
    self._controlButton[2]:onButtonClicked(secondButtonCallBack)
    -- ��ʼ����ť��������ֱ�ǩ
    local btnStr11 = dictionary.getGameStr("main_chongxuan")
    local btnStr12 = dictionary.getGameStr("main_score_1")
    self._btnSecondLabel[2] = ui.newTTFLabel( { text = btnStr11, size = 30 })
    self._btnSecondLabel[2]:setVisible(false)
    self._btnFirstLabel[1]:setVisible(false);
    self._controlButton[2]:addChild(self._btnSecondLabel[2]);
    self._btnFirstLabel[2] = ui.newTTFLabel( { text = btnStr12, size = 30 })
    self._btnFirstLabel[2]:setVisible(false);
    self._controlButton[2]:addChild(self._btnFirstLabel[2]);
    -- ��ť���ò��ɼ�
    self._controlButton[2]:setVisible(false);



    -- ���е�������ť�Ļص�����
    function controlButton3CallBack()

        print("controlButton3 is clicked")
        -- �������ֵİ�ť
        if self._btnFirstLabel[3]:isVisible() then
            
            -- ��ʾ����
            self:showLabelSprite(PokerManager._playerId, 2, true) 

            self._clickTwoScoreCount = self._clickTwoScoreCount + 1

            self._clickTwoId=PokerManager._playerId

            if self:judgeDiZhu(scene) then
                -- �������id
                self._diZhuId = PokerManager._playerId
                -- ���õ����ı�����ñ��
                self:setDiZhuSprite(scene)

                -- �������ɵ�ǰ��ҵ���
                PokerManager:removeSprites(scene)


            else

                -- ת����һ�����ѡ����
                self:nextPlayer(PokerManager._playerId)

                -- ��ʾ��һ����ҵ�ʱ��
                PokerManager._isShowNextTime = true

                self:setControlButtonDisable(2)
                self:setControlButtonDisable(3)
            end


            -- ������ʾ��ť
        else
            self._tiShi = true

            if PokerManager:judgeChuPai(PokerManager._playerPokers[PokerManager._playerId], PokerManager._lastType, PokerManager._lastMaxPokerValue) then

                -- ���ó��ư�ť����
                self:setControlButtonEnable(4)

                PokerManager._recordPokers = PokerManager._recordPokerAI
                dump(PokerManager._recordSpritesAI)

                for key, var in pairs(PokerManager._recordSpritesAI) do

                    PokerManager._recordSprites[PokerManager._playerId][key] = var

                    PokerManager._recordSprites[PokerManager._playerId][key]:runAction(CCMoveBy:create(0.3, ccp(0, 30)))
                    
                    -- ���֮ǰ�ļ���
                    -- clickFlag[PokerManager._playerId][key]=true
                    --                    clickFlag=PokerManager:getFlag()
                    --                    clickFlag[PokerManager._playerId][key]=true

                    --PokerManager:setFlag(PokerManager._playerId,key,true)

                    -- ����ע������¼�
                    --PokerManager:setPokerTouch(PokerManager._playerId, key, var)

                    PokerManager:setFlag(PokerManager._playerId,key,true)

                end
            end
        end

        --          --���ԣ��ֶ��ܵ����ʾ    ����ʧ��
        --          self:clicktiShiCallBack()
        -- end
    end

    -- ��ʼ����3��button
    self._controlButton[3] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[3]:setPosition(576, 250);
    scene:addChild(self._controlButton[3]);
    self._controlButton[3]:onButtonClicked(controlButton3CallBack)
    -- ���ð�ť���ֱ�ǩ
    local btnStr21 = dictionary.getGameStr("main_tishi")
    local btnStr22 = dictionary.getGameStr("main_score_2")
    self._btnSecondLabel[3] = ui.newTTFLabel( { text = btnStr21, size = 30 })
    self._btnSecondLabel[3]:setVisible(false);
    self._controlButton[3]:addChild(self._btnSecondLabel[3]);

    self._btnFirstLabel[3] = ui.newTTFLabel( { text = btnStr22, size = 30 })
    self._btnFirstLabel[3]:setVisible(false);
    self._controlButton[3]:addChild(self._btnFirstLabel[3]);
    -- ��ť���ò��ɼ�
    self._controlButton[3]:setVisible(false);


    -- ��ʼ����4��button
    self._controlButton[4] = cc.ui.UIPushButton.new( { normal = "button_bg.png", pressed = "button_bg_pressed.png", disabled = "button_disable_bg.png" }, { scale9 = false })
    self._controlButton[4]:setPosition(696, 250);
    scene:addChild(self._controlButton[4]);


    self._controlButton[4]:onButtonClicked( function()
        self:clickedControlButton4(scene)
    end )
    -- ���ð�ť���ֱ�ǩ
    local btnStr31 = dictionary.getGameStr("main_chupai")
    local btnStr32 = dictionary.getGameStr("main_score_3")
    self._btnSecondLabel[4] = ui.newTTFLabel( { text = btnStr31, size = 30 })
    self._btnSecondLabel[4]:setVisible(false)
    self._controlButton[4]:addChild(self._btnSecondLabel[4]);
    self._btnFirstLabel[4] = ui.newTTFLabel( { text = btnStr32, size = 30 })
    self._btnFirstLabel[4]:setVisible(false)
    self._controlButton[4]:addChild(self._btnFirstLabel[4])
    -- ��ť���ò��ɼ�
    self._controlButton[4]:setVisible(false);



end



-- ��ʼ��ʱ��
function Player:initTime(mainScene)


    -- ��ʼ������ʱ��
    self._timeSprites[1] = CCSprite:create("clock.png")
    self._timeSprites[1]:setPosition(200, 200)
    mainScene:addChild(self._timeSprites[1]);
    local timeLabel1 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel1:setPosition(self._timeSprites[1]:getContentSize().width / 2, self._timeSprites[1]:getContentSize().height / 2 - 5)
    self._timeSprites[1]:addChild(timeLabel1);
    -- ����ʱ�Ӳ��ɼ�
    self._timeSprites[1]:setVisible(false);
    -- ����self._timeLabel�еı�ǩ
    self._timeLabel[1] = timeLabel1


    -- ��ʼ�����2ʱ��
    self._timeSprites[2] = display.newSprite("clock.png")
    self._timeSprites[2]:setPosition(780, 530)
    mainScene:addChild(self._timeSprites[2]);
    local timeLabel2 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel2:setPosition(self._timeSprites[2]:getContentSize().width / 2, self._timeSprites[2]:getContentSize().height / 2 - 5)
    self._timeSprites[2]:addChild(timeLabel2);
    -- ����ʱ�Ӳ��ɼ�
    self._timeSprites[2]:setVisible(false);
    -- ����self._timeLabel�еı�ǩ
    self._timeLabel[2] = timeLabel2


    -- ��ʼ�����3ʱ��
    self._timeSprites[3] = display.newSprite("clock.png")
    self._timeSprites[3]:setPosition(180, 580)
    mainScene:addChild(self._timeSprites[3]);
    local timeLabel3 = ui.newTTFLabel( { text = "20", size = 20, color = ccc3(255, 0, 0) })
    timeLabel3:setPosition(self._timeSprites[2]:getContentSize().width / 2, self._timeSprites[2]:getContentSize().height / 2 - 5)
    self._timeSprites[3]:addChild(timeLabel3);
    -- ����ʱ�Ӳ��ɼ�
    self._timeSprites[3]:setVisible(false);
    -- ����self._timeLabel�еı�ǩ
    self._timeLabel[3] = timeLabel3


    for key, var in ipairs(self._timeSprites) do

        if key == PokerManager._playerId then

            var:setVisible(true)
        end

    end
end


-- ת���ɵڶ��ֱ�ǩ

function Player:convertSecondLabel()

    -- ��ѡ�����ı�ǩ����Ϊ���ɼ�
    for key, var in ipairs(self._btnFirstLabel) do

        if var:isVisible() then
            var:setVisible(false)
        end
    end

    -- ��ʾ���Ƶı�ǩ
    for key, var in ipairs(self._btnSecondLabel) do
        if var:isVisible() == false then
            var:setVisible(true)
        end
    end

    -- �����ư�ť������ı�
    for key, var in ipairs(self._controlButton) do

        if key == 1 or key == 3 then

        else
            var:setButtonImage("normal", "button_disable_bg.png")
        end
    end
end


-- ���õ�ǰ�����ı�����ñ��
function Player:setDiZhuSprite(scene)

    -- ����
    local bgSprite = scene:getChildByTag(PokerManager._playerId)
    self._dzBgSprite = display.newSprite("head_dz.png")
    self._dzBgSprite:setPosition(bgSprite:getPosition())
    -- bgSprite:removeFromParentAndCleanup(true)
    self._dzBgSprite:setScale(1.5)
    scene:addChild(self._dzBgSprite)


    -- ñ��
    local capSprite = scene:getChildByTag(PokerManager._playerId + PokerManager._playerId * 10)
    self._dzCapSprite = display.newSprite("dz_cap.png")
    self._dzCapSprite:setPosition(capSprite:getPosition())
    scene:addChild(self._dzCapSprite)
    -- capSprite:removeFromParentAndCleanup(true)
end


-- ��ʼ������������ı�ǩ
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


-- ����ÿһ����ҵ���
function Player:updatePokerLabel(count, playerId)

    self._pokersCount[playerId] = self._pokersCount[playerId] - count
    self._pokerLabel[playerId]:setString("" .. self._pokersCount[playerId])
end

-- ��һ����ң��ı䵱ǰ��ҵ�id
function Player:nextPlayer()

    if PokerManager._playerId == 3 then
        PokerManager._playerId = 1
    else
        PokerManager._playerId = PokerManager._playerId + 1
    end
end



-- ��ʾ��ҵĵ�һ�ο��ư�ť  ѡ����
function Player:showFirstControlButton()

    for key, var in ipairs(Player._controlButton) do

        var:setVisible(true)
        var:setScale(0.75)
        self._btnFirstLabel[key]:setVisible(true);
    end
end


-- ������ĸ���ť�ĺ���
function Player:clickedControlButton4(scene)
    print "button4 is clicked"


    -- ���3��������
    if self._btnFirstLabel[4]:isVisible() then

        -- ��ʾ����
        self:showLabelSprite(PokerManager._playerId, 2, true)

        -- �������id
        self._diZhuId = PokerManager._playerId

        -- ת���ɵڶ��ֱ�ǩ
        self:convertSecondLabel()

        -- �Ƴ����� һ�� ���ֵľ���
        self:setSpriteHide()

        -- ���õ׷�
        self._diFenCount = 3
        self._dataLabel[3]:setString(self._diFenCount)

        -- ���õ����ı�����ñ��
        self:setDiZhuSprite(scene)

        ---------------------------------------------------------------
        -- �������ɵ�ǰ��ҵ���
        PokerManager:removeSprites(scene)

        ---------------------------------------------------------------

        -- ��ӵ������˿�����
        self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
        -- �����˿������ı�ǩ
        self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

        -- ����������ҵ��˿��ƿɴ���
        for i = 1, 3 do

            if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            end
        end


        -- ���ñ�ǩ���ɼ�
        self._btnFirstLabel[4]:setVisible(false)


        -- ������ҵĳ���ʱ��
        self._currentTime[PokerManager._playerId] = 20

    else


        local i = 0;
        local y = 0
        local x = 0



        --������Ч
        require("GameEffect"):playEffect(PokerManager._ChuPaiType,self:getCurrentSex(PokerManager._playerId),PokerManager._MaxValue+3)


        -- ִ��һ�����������˿����ƶ����м�
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

        -- ���Ƶ�ʱ���ж��Ƿ��ǻ�������򲥷Ż����֡����
        if self._huoJian then
            self:playHuoJianAnimation(scene)
        end
        if PokerManager._ChuPaiType == 4 then
            self:playZhaDanAnimation(scene)
            -- self._zhaDan=false
        end


        -- �Ѽ�¼���Ƶ�λ�ü�¼���� ��������ĵ����Ƶ�λ��
        local points = { }

        for key, var in pairs(PokerManager._recordPokers) do

            points[key] = key
            PokerManager._recordPokers[key] = nil

        end

        -- ���ò��ɳ���
        PokerManager._isCanChuPai = false
        self:setControlButtonDisable(4)
        -- ������ѡ��ť������
        self:setControlButtonDisable(2)

        -- ��ת����һ����ҳ���
        -- PokerManager._nextPlayer = true

        -- ���ذ�ť
        if PokerManager._isCanChuPai == false then
            self._controlButton[4]:setButtonImage("normal", "button_disable_bg.png")
        end


        -- ���ƺ��������˿��Ƶ�λ��
        PokerManager:adjustPosition(PokerManager._pokerSprites, PokerManager._Count, PokerManager._playerId, points)


        -- �������������label
        self:updatePokerLabel(PokerManager._Count, PokerManager._playerId)


        -- �ж����е����Ƿ����
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

            -- ֹͣ��ʱ��
            self:stopScheduler(self._schedulerId)

            -- ��ʾʤ���Ĳ�
            local gameOver = require("GameOver").new()
            gameOver:Resize(flag);
            scene:addChild(gameOver)

        elseif self._pokersCount[PokerManager._playerId]==1 then
            --������Ч
            require("GameEffect").playLastCard(self:getCurrentSex(PokerManager._playerId))
        elseif self._pokersCount[PokerManager._playerId]==2 then
            --������Ч
            require("GameEffect").playLast2Card(self:getCurrentSex(PokerManager._playerId))
        end



        -- ��һ����ҳ���
        self:nextPlayer()

        -- ������һ����ҵ�ʱ��
        self._currentTime[PokerManager._playerId] = 20

        -- �Ƴ���һ�������ʾ����
        PokerManager:removeSelfRecords(PokerManager._recordSprites, PokerManager._playerId)

        -- ����в���sprite ������Ϊ���ɼ�
        if self._labelSprites[PokerManager._playerId]:isVisible() then

            self:showLabelSprite(PokerManager._playerId, 4, false)
        end

        -- ������һ����ҳ��Ƶ�����
        PokerManager._lastCount = PokerManager._Count
        PokerManager._lastMaxPokerValue = PokerManager._MaxValue
        PokerManager._lastType = PokerManager._ChuPaiType


        -- ��ʾ��һ����ҵ�ʱ��
        PokerManager._isShowNextTime = true


        -- ��ռ�¼��ai��
        PokerManager._recordPokerAI = { }
        PokerManager._recordSpritesAI = { }
    end
end


-- �Ƿ����������������ѡ���˲�����
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


-- ���ÿ��ư�ťΪ����
function Player:setControlButtonEnable(buttonId)

    if self._btnSecondLabel[buttonId]:isVisible() then
        self._controlButton[buttonId]:setButtonEnabled(true)
        self._controlButton[buttonId]:setButtonImage("normal", "button_bg.png")
    end
end

-- ���ð�ť������
function Player:setControlButtonDisable(buttonId)

    if self._btnSecondLabel[buttonId]:isVisible() then
        self._controlButton[buttonId]:setButtonEnabled(false)
        self._controlButton[buttonId]:setButtonImage("normal", "button_disable_bg.png")
    else
        self._controlButton[buttonId]:setButtonEnabled(false)
        self._controlButton[buttonId]:setButtonImage("normal", "button_disable_bg.png")
    end
end



-- ��ʼ��Top��
function Player:initTopLayer(mainScene)
    -- ��ʼ��top����
    local topLayer = display.newLayer()
    topLayer:setPosition(display.width / 2, display.height - 20);
    mainScene:addChild(topLayer);
    local topSprite = display.newSprite("main_top.png")
    topSprite:setScale(0.7);
    topLayer:setContentSize(topSprite:getContentSize());
    topLayer:addChild(topSprite);

    -- ��ʼ�����������水ť
    local backBtn = cc.ui.UIPushButton.new( { normal = "main_tuic.png", pressed = "main_tuic_pressed.png" }, { scale9 = false })
    backBtn:setPosition(topSprite:getPositionX() -170, topSprite:getPositionY())
    backBtn:onButtonClicked( function(event)
        print "backBtn clicked"

        -- ֹͣ��ʱ��
        self:stopScheduler(self._schedulerId)

        display.replaceScene(require("GameIndex").new(), "moveInL", 0.3)
    end )
    topLayer:addChild(backBtn);

    -- ���ý��水ť
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


    -- ����ʤ��ǩ
    local winStr = require("DictionaryCommon").getGameStr("main_win");
    local winLabel = ui.newTTFLabel( { text = winStr, size = 20 });
    winLabel:setPosition(topSprite:getPositionX() -130, topSprite:getPositionY() + 10)
    topLayer:addChild(winLabel);
    -- ʤ
    local winCount = CCUserDefault:sharedUserDefault():getIntegerForKey("winCount")
    self._dataLabel[1] = ui.newTTFLabel( { text = winCount, size = 20 })
    self._dataLabel[1]:setPosition(ccp(winLabel:getPositionX() + 30, winLabel:getPositionY()))
    topLayer:addChild(self._dataLabel[1])

    -- ���ø���ǩ
    local loseStr = require("DictionaryCommon").getGameStr("main_lose");
    local loseLabel = ui.newTTFLabel( { text = loseStr, size = 20 })
    loseLabel:setPosition(topSprite:getPositionX() -130, topSprite:getPositionY() -10)
    topLayer:addChild(loseLabel);
    -- ��
    local loseCount = CCUserDefault:sharedUserDefault():getIntegerForKey("loseCount")
    self._dataLabel[2] = ui.newTTFLabel( { text = loseCount, size = 20 })
    self._dataLabel[2]:setPosition(ccp(loseLabel:getPositionX() + 30, loseLabel:getPositionY()))
    topLayer:addChild(self._dataLabel[2])

    -- ���õ׷ֱ�ǩ    UILabel����
    local diScoreStr = dictionary.getGameStr("main_score")
    local scoreLabel = cc.ui.UILabel.new( { UILabelType = 2, text = diScoreStr, size = 20 })
    scoreLabel:setPosition(topSprite:getPositionX() + 70, topSprite:getPositionY() + 10)
    topLayer:addChild(scoreLabel);
    -- �׷�
    self._dataLabel[3] = ui.newTTFLabel( { text = "0", size = 20 })
    self._dataLabel[3]:setPosition(scoreLabel:getPositionX() + 60, scoreLabel:getPositionY())
    topLayer:addChild(self._dataLabel[3])


    -- ���ñ�����ǩ
    local multipleStr = dictionary.getGameStr("main_multiple")
    local multipleLabel = cc.ui.UILabel.new( { UILabelType = 2, text = multipleStr, size = 20 })
    multipleLabel:setPosition(topSprite:getPositionX() + 70, topSprite:getPositionY() -10)
    topLayer:addChild(multipleLabel);

    -- ����
    self._dataLabel[4] = ui.newTTFLabel( { text = "1", size = 20 })
    self._dataLabel[4]:setPosition(multipleLabel:getPositionX() + 60, multipleLabel:getPositionY())
    topLayer:addChild(self._dataLabel[4])

end

-- ֹͣ��ʱ��
function Player:stopScheduler(schedulerId)

    local ss = require("framework.scheduler")
    ss.unscheduleGlobal(schedulerId)
end




-- ��ʼ������
function Player:resetData()

    -- ��ʼ������˿��Ƶ�����
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

    -- ����ѡ����
    self:converToFirestLabel()


    -- �Ƴ���ǰ����
    self._dzBgSprite:removeFromParentAndCleanup(true)
    self._dzCapSprite:removeFromParentAndCleanup(true)

    -- �Ƴ���������
    self:setBuChuSpriteHide()

    --���»���
    --require("InfoLayer"):updateJiFen()
end


-- �������
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

    -- ��������
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

    -- ��������
    self._multipleCount = self._multipleCount * 2
    self._dataLabel[4]:setString(self._multipleCount)

end


-- ��ʼ������label����
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


-- �ı����label������������ʾ
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


-- ��һ����ť�Ļص�����
-------------------------------------------------------------------------------------------------
function Player:firstButtonCallBack(scene)

    print "button1 is clicked"

    -- ���ж��ǲ���ѡ����
    if self._btnFirstLabel[1]:isVisible() then

        -- ��ʾ����
        self:showLabelSprite(PokerManager._playerId, 0, true)

        -- ��ʾ��һ����ҵ�ʱ��
        PokerManager._isShowNextTime = true

        -- ÿ�ε������һ
        self._clickBuJiaoCount = self._clickBuJiaoCount + 1

        -- ��������β��е���  ��һ�����е���Ϊ�������׷�Ϊһ
        if self:judgeDiZhu(scene) then
           
           if self._clickOneId~=0 and self._clickTwoId==0 then
                -- �������id
                PokerManager._playerId=self._clickOneId
                self._diZhuId = self._clickOneId
                -- ���õ����ı�����ñ��
                self:setDiZhuSprite(scene)

                -- �������ɵ�ǰ��ҵ���
                PokerManager:removeSprites(scene)

               -- ��ӵ������˿�����
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- �����˿������ı�ǩ
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

            elseif  self._clickTwoId~=0 then

                 -- �������id
                PokerManager._playerId=self._clickTwoId
                self._diZhuId = self._clickTwoId
                -- ���õ����ı�����ñ��
                self:setDiZhuSprite(scene)

                -- �������ɵ�ǰ��ҵ���
                PokerManager:removeSprites(scene)

               -- ��ӵ������˿�����
               self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
               -- �����˿������ı�ǩ
               self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])
            else


            end
        else
            self:nextPlayer(PokerManager._playerId)
        end
    else
        
        --������Ч
        --�õ���ǰ��ҵ��Ա�
        local sex=self:getCurrentSex(PokerManager._playerId)
        require("GameEffect").playBuChu(sex)

        self:showLabelSprite(PokerManager._playerId, 4, true)

        self._recordClickedBuChu[PokerManager._playerId] = 1

        -- ת����һ����ҳ���
        self:nextPlayer(PokerManager._playerId)

        -- �ж��Ƿ�������������ҵ���˲���
        if self:isClickedTwice(self._recordClickedBuChu) then

            -- ��ռ�¼���
            for i = 1, 3 do
                self._recordClickedBuChu[i] = -1
            end

            -- ���last��ҵ�����
            PokerManager:resetLastData()

            -- �ָ�Ϊ��һ�ֳ���
            self._isFirstChuPai = true
        end

        -- ��ʾ��һ����ҵ�ʱ��
        PokerManager._isShowNextTime = true

        -- ��¼���û�г���
        self._recordClickedBuChu[PokerManager._playerId] = 1

        -- �Ƴ���һ�������ʾ����
        PokerManager:removeSelfRecords(PokerManager._recordSprites, PokerManager._playerId)

        -- ������ҵ�ʱ��
        self._currentTime[PokerManager._playerId] = 20

        -- ����в���sprite ������Ϊ���ɼ�
        if self._labelSprites[PokerManager._playerId]:isVisible() then

            self:showLabelSprite(PokerManager._playerId, 4, false)
        end
    end

end


-- ����Ϊ��һ�ֱ�ǩ
function Player:converToFirestLabel()

    for i = 1, 4 do

        self._btnSecondLabel[i]:setVisible(false)
        self._btnFirstLabel[i]:setVisible(true)

        self._controlButton[i]:setButtonEnabled(true)
        self._controlButton[i]:setButtonImage("normal", "button_bg.png")
    end

end

-- �������ľ�������Ϊ���ɼ�
function Player:setBuChuSpriteHide()

    for key, var in ipairs(self._labelSprites) do

        if var:isVisible() then
            self:showLabelSprite(key, 4, false)
        end
    end
end

-- ��һ�� ���� ����  ���� �ľ��鶼����Ϊ���ɼ�
function Player:setSpriteHide()
    for key, var in ipairs(self._labelSprites) do

        if var:isVisible() then
            var:setVisible(false)
        end
    end
end



---- �ֶ��ܵ�������ʾ��ť
-- function Player:clicktiShiCallBack()

--    self._tiShi = true

--    if PokerManager:judgeChuPai(PokerManager._playerPokers[PokerManager._playerId], PokerManager._lastType, PokerManager._lastMaxPokerValue) then

--        -- ���ó��ư�ť����
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


-- �жϵ�����˭�����˵���
function Player:judgeDiZhu(scene)

    if self._clickBuJiaoCount == 2 and self._clickOneScoreCount == 1 then

        self._clickOneScoreCount = 0
        -- ���õ׷�
        self._diFenCount = 1
        self._dataLabel[3]:setString(self._diFenCount)

        -- �Ƴ����еȾ���
        self:setSpriteHide()

        -- ���õ������
        self._clickBuJiaoCount = 0


        -- ת���ɵڶ��ֱ�ǩ
        self:convertSecondLabel()


        -- ����������ҵ��˿��ƿɴ���
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- ���ñ�ǩ���ɼ�
        self._btnFirstLabel[4]:setVisible(false)

        -- ������ҵĳ���ʱ��
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 2 and self._clickTwoScoreCount == 1 then

        self._clickTwoScoreCount = 0
        -- ���õ׷�
        self._diFenCount = 2
        self._dataLabel[3]:setString(self._diFenCount)

        -- �Ƴ����еȾ���
        self:setSpriteHide()

        -- ���õ������
        self._clickBuJiaoCount = 0


        -- ת���ɵڶ��ֱ�ǩ
        self:convertSecondLabel()


        -- ����������ҵ��˿��ƿɴ���
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- ���ñ�ǩ���ɼ�
        self._btnFirstLabel[4]:setVisible(false)

        -- ������ҵĳ���ʱ��
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 1 and self._clickTwoScoreCount == 1 and self._clickOneScoreCount == 1 then

        self._clickBuJiaoCount = 0
        -- ���õ׷�
        self._diFenCount = 2
        self._dataLabel[3]:setString(self._diFenCount)

        -- �Ƴ����еȾ���
        self:setSpriteHide()

        -- ���õ������
        self._clickBuJiaoCount = 0


        -- ת���ɵڶ��ֱ�ǩ
        self:convertSecondLabel()

        -- ��ӵ������˿�����
        self._pokersCount[PokerManager._playerId] = self._pokersCount[PokerManager._playerId] + 3
        -- �����˿������ı�ǩ
        self._pokerLabel[PokerManager._playerId]:setString(" " .. self._pokersCount[PokerManager._playerId])

        -- ����������ҵ��˿��ƿɴ���
        for i = 1, 3 do

            --if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            --end
        end


        -- ���ñ�ǩ���ɼ�
        self._btnFirstLabel[4]:setVisible(false)

        -- ������ҵĳ���ʱ��
        self._currentTime[PokerManager._playerId] = 20


        return true

    elseif self._clickBuJiaoCount == 3 then

        -- ��һ�����
        self:nextPlayer(PokerManager._playerId)

        -- �Ƴ����еȾ���
        self:setSpriteHide()

        -- ���õ������
        self._clickBuJiaoCount = 0

        -- �������id
        self._diZhuId = PokerManager._playerId

        -- ת���ɵڶ��ֱ�ǩ
        self:convertSecondLabel()

        -- ���õ׷�
        self._diFenCount = 1
        self._dataLabel[3]:setString(self._diFenCount)

        -- ���õ����ı�����ñ��
        self:setDiZhuSprite(scene)

        -- �������ɵ�ǰ��ҵ���
        PokerManager:removeSprites(scene)


        -- ����������ҵ��˿��ƿɴ���
        for i = 1, 3 do

            if i ~= PokerManager._playerId then
                for key, var in ipairs(PokerManager._pokerSprites[i]) do

                    var:setTouchEnabled(true)

                end
            end
        end


        -- ���ñ�ǩ���ɼ�
        self._btnFirstLabel[4]:setVisible(false)


        -- ������ҵĳ���ʱ��
        self._currentTime[PokerManager._playerId] = 20
        return true
    end
    return false
end


--�õ���ǰ������ҵ��Ա�
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