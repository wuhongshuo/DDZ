-- GameScene=require("GameScene")
dictionary = require("DictionaryCommon")
Player = require("Player")

PokerManager = { }

 

-- ���Ƶ�����   �������ԣ�����һ��˳��   ����1����ǵ��ƣ�2�����һ�ԣ�3�����ţ�4��ը��5��˳�ӣ�6����1��7���Ŵ����� 8���Ŵ����� 9 ���� ��10��˳ ��11�ɻ���12��ը
PokerManager._ChuPaiType = -1
-- ���͵����ֵ
PokerManager._MaxValue = -1
-- һ�����˶�������
PokerManager._Count = -1
-- �Ƿ��ǵ�һ�γ���
PokerManager._isFirstChuPai = true
-- �Ƿ���Գ���
PokerManager._isCanChuPai = false

-- ��ų��ƾ���
PokerManager._recordSprites = { { }, { }, { } }

-- ��һ����ҳ���
PokerManager._nextPlayer = false

-- ���Id
PokerManager._playerId = { 1, 2, 3 }

-- ��ÿһ����ҵ��˿��Ƶľ���
PokerManager._pokerSprites = { { }, { }, { } }


-- ���˿��Ƶ�valueֵ,��1��ʼ��1��ʾ������3��2�ǵڶ������
PokerManager._playerPokers = { { }, { }, { } }

-- ��һ�γ��Ƶ����������ͣ����ֵ
PokerManager._lastCount = -1
PokerManager._lastMaxPokerValue = -1
PokerManager._lastType = -1

-- �Ƿ���ʾ��һ��ʱ��
PokerManager._isShowNextTime = false;

-- ������
PokerManager._diZhuPokers = { }
-- �����ƾ���
PokerManager._diZhuPokerSprites = { }


-- �Ƴ������flag
PokerManager._removeFlag = false

-- ÿ���״γ��Ƶ�flag
PokerManager._isFirstChuPai = true;

-- ��¼���Ƶ�ֵ
PokerManager._recordPokers = { }

-- ����id
PokerManager._touchId = { { }, { }, { } }

-- ��¼������
PokerManager._mainScene = nil

-- ��¼AI����
PokerManager._recordPokerAI = { }
PokerManager._recordSpritesAI = { }

--��¼����˿��Ƶ�flag
local clickFlag={{},{},{}}

function PokerManager:getFlag()
     return clickFlag
end

function PokerManager:setFlag(playerId,key,flag)
     clickFlag[playerId][key]=flag
end

function PokerManager:initManage()
    
    --��ʼ��flag
    function initFlag()

         for i=1,3 do
             for j=1,20 do
                 clickFlag[i][j]=false
             end
         end
    end

    initFlag()


    -- �����˿�������
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("poker_card.plist", "poker_card.png")

    self._pokers = { }

    -- ��ʼ����ž����tabel
    for id = 1, 3 do
        for i = 1, 20 do

            PokerManager._recordSprites[id][i] = -1
        end
    end

end


-- ����   ����������Ʒ�����ͬ�����
function PokerManager:fapaiPoker()

    -- ��54���Ƶ�ֵ�浽_pokers������
    for i = 1, 54 do
        self._pokers[i] = i;
    end

    -- ����54���Ƶ�˳��
    --    for i = 1, 54 do
    --        local rand = math.random(54)
    --        self._pokers[i], self._pokers[rand] = self._pokers[rand], self._pokers[i]
    --    end

    -- ��ǰ17�ŷ������һ
    for i = 1, 17 do

        self._playerPokers[1][i] = self._pokers[i]
    end

    -- ��ǰ18-34�ŷ�����Ҷ�
    for i = 1, 17 do

        self._playerPokers[2][i] = self._pokers[i + 17]
    end

    -- ��ǰ35-51�ŷ��������
    for i = 1, 17 do

        self._playerPokers[3][i] = self._pokers[i + 34]

    end

end


-- ����չʾ����Ϸ��  ��������Ϸ����
function PokerManager:showPokers(scene)

    -- self._mainScene=scene

    -- print(tolua.isnull(self._mainScene))

    -- �����򣬺������˿���
    for s = 1, 3 do
        for i = 1, 17, 1 do
            for j = i, 17, 1 do
                if self._playerPokers[s][j] > self._playerPokers[s][i] then

                    self._playerPokers[s][j], self._playerPokers[s][i] = self._playerPokers[s][i], self._playerPokers[s][j]
                end
            end
        end
    end

    -- ��ʾ�ĵ�����
    local diZhuSprites = { }
    local coverSprites = { }
    for i = 1, 3 do

        -- ���ɵ�����   3��
        self._diZhuPokers[i] = self._pokers[51 + i]
        local index = self._pokers[51 + i] -1
        self._diZhuPokerSprites[i] = display.newSprite("#poke" .. index .. ".png")
        diZhuSprites[i] = display.newSprite("#poke" .. index .. ".png")
        local x = display.width * 0.5 +(i - 2) * 40
        local y = display.height - 25
        diZhuSprites[i]:setPosition(ccp(x, y))
        diZhuSprites[i]:setScale(0.3)
        self._mainScene:addChild(diZhuSprites[i], 0, i * 10)
        self._diZhuPokerSprites[i]:setScale(0.3)
        self._diZhuPokerSprites[i]:setPosition(diZhuSprites[i]:getPosition())
        self._mainScene:addChild(self._diZhuPokerSprites[i])
        -- ���������ڵ��˿��Ƶ���
        coverSprites[i] = display.newSprite("main_shoupai.png")
        coverSprites[i]:setPosition(diZhuSprites[i]:getPosition())
        self._mainScene:addChild(coverSprites[i], 0, i * 100)

        -- ����ÿ����ҵ��˿���
        for key, var in ipairs(self._playerPokers[i]) do

            local frameNameIndex = self._playerPokers[i][key] -1;

            -- ��CCSprite�������˿���
            self._pokerSprites[i][key] = display.newSprite("#poke" .. frameNameIndex .. ".png")
            self._mainScene:addChild(self._pokerSprites[i][key])
            self._pokerSprites[i][key]:setPosition(150, 100)


            if i == 3 then
                self._pokerSprites[i][key]:setPosition(ccp(150, 600))
            elseif i == 2 then

                self._pokerSprites[i][key]:setPosition(ccp(150, 300))
            elseif i == 1 then
                self._pokerSprites[i][key]:setPosition(ccp(150, 100))
            end

        end
        -- ����
        self:sortPoker(self._mainScene, i);
    end
end


-- pokersΪ��ҵ��ƣ��ڶ�������Ϊ��Ϸ����������������Ϊ��ҵ�ID
function PokerManager:sortPoker(mainScene, playerId)

    if self._removeFlag then

        -- ���������˿���
        for key, var in ipairs(self._pokerSprites[self._playerId]) do
            if var ~= -1 and tolua.isnull(var) ~= true then
                var:removeFromParentAndCleanup(true)
                var = nil
            end
        end

        for key, var in ipairs(self._playerPokers[self._playerId]) do
            local index = var - 1
            self._pokerSprites[self._playerId][key] = display.newSprite("#poke" .. index .. ".png")
            mainScene:addChild(self._pokerSprites[self._playerId][key])
        end

    end


    -- ֻ�����һ����չ������
    if playerId == 1 and self._removeFlag == false then
        
        --������Ч
        require("GameEffect").playFaPai()

        -- ִ��һ��������չ���˿���
        for key, var in ipairs(self._pokerSprites[playerId]) do

            local showSeq = transition.sequence( { CCMoveTo:create(1, ccp((key - 1) * 44 + 150, 200 *(playerId - 1) + 100)) })
            var:runAction(showSeq)

        end
    end


    -- �ӳټ�ʱ���������ı��˿��Ƶ�����   ����                ���ڻ�����������Բ��ı��˿��Ƶ�������
    local scheduler = require("framework.scheduler");

    scheduler.performWithDelayGlobal( function(dt)

        -- �ı��Ƶ�����
        for key, var in ipairs(self._pokerSprites[playerId]) do

            if playerId == 3 then
                var:setPosition(ccp(150 +(key - 1) * 10, 500))
                var:setScale(0.35)
            elseif playerId == 2 then
                var:setPosition(ccp(750 +(key - 1) * 10, 400))
                var:setScale(0.35);
            elseif playerId == 1 then
                var:setPosition(ccp(150 +(key - 1) * 44, 100))
            end


            self:setPokerTouch(playerId, key, var)

        end
        -- ����������е��˿��ƽ�����end  for

    end , 1.5)

end



-- �ж��Ƿ���Գ���   recordPokers��һ����ҳ����� ���ߵ�ǰ��ҵ�����ƣ���Ҫ�ǿ�lastType�ǲ��ǿ���������˭�����ƣ�lastType��һ����ҳ��Ƶ�����  ,maxPokerValue����һ����ҳ������͵����ֵ  ��55522   ֵ����5
function PokerManager:judgeChuPai(recordPokers, lastType, maxPokerValue)

    -- ���ǵ�һ�γ���

    if lastType ~= -1 and maxPokerValue ~= -1 then

        -- �����Ƿ��ǵ�һ�γ���
        Player._isFirstChuPai = false

        local pokersCount = 0;
        local count = { { }, { } }
        -- ��һ��������0��13�����飬count[0]�洢������ҵ�����Ƶ�����3�ĸ���   count[13]�洢���Ǵ����ĸ���
        for i = 1, 14 do
            count[1][i - 1] = 0
        end


        if recordPokers == self._playerPokers[self._playerId] then

            for key, var in pairs(recordPokers) do

                pokersCount = pokersCount + 1;
                count[1][math.floor((var - 1) / 4)] = count[1][math.floor((var - 1) / 4)] + 1
                count[2][math.floor((var - 1) / 4)] = var % 4 + 1
            end

        else
            for key, var in pairs(recordPokers) do

                pokersCount = pokersCount + 1;
                -- print(math.floor(var / 4 + 3))
                count[1][math.floor(var / 4)] = count[1][math.floor(var / 4)] + 1
                count[2][math.floor(var / 4)] = var % 4 + 1
            end
        end

        if Player._tiShi then
            pokersCount = self._Count
        end

        -- �ж��Ƿ���Գ���
        if self:isCanChuPai(recordPokers, count, pokersCount) then

            -- ����ֻ���������
            print(self._lastCount .. ":lastCount--------------" .. self._Count .. ":self._Count")
            print(self._lastType .. ":lastType--------------" .. self._ChuPaiType .. ":self._ChuPaiType")
            print(self._lastMaxPokerValue .. ":lastMaxPokerValue--------------" .. self._MaxValue .. ":self._maxValue")

            -- �������ը
            if self._Count == 2 and self._ChuPaiType == 12 then

                Player._huaJian = true
                return true

                -- �����ը������һ����ҵ��Ʋ���ը��
            elseif self._Count == 4 and self._ChuPaiType == 4 and self._lastType ~= 4 then

                -- Player._zhaDan=true
                return true;

            elseif self._lastCount == self._Count then
                if self._lastType == self._ChuPaiType then
                    if self._lastMaxPokerValue < self._MaxValue then

                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

                        self._isCanChuPai = true
                        print("is Can ChuPai")

                        Player:setControlButtonEnable(4)

                        return true;
                    end
                end
            end

            return false
        end



        -- ��һ�γ���
    else

        local pokersCount = 0;
        local count = { { }, { } }
        -- ��һ��������0��13�����飬count[0]�洢������ҵ�����Ƶ�����3�ĸ���   count[13]�洢���Ǵ����ĸ���
        for i = 1, 14 do
            count[1][i - 1] = 0
        end

        for key, var in pairs(recordPokers) do

            pokersCount = pokersCount + 1;
            -- print(math.floor(var / 4 + 3))
            count[1][math.floor(var / 4)] = count[1][math.floor(var / 4)] + 1

        end


        if self:isCanChuPai(recordPokers, count, pokersCount) then


            return true
        end

    end


    return false;
end


function PokerManager:isCanChuPai(recordPokers, count, pokersCount)


    -- ���жϵ�������
    if count[1][13] == 1 and pokersCount == 1 then

        print(pokersCount .. ":dan pai wang")
        -- ��¼��ҵĳ������ͣ������������������͵����ֵ
        if self._playerPokers[self._playerId][1] == 54 then
            self._MaxValue = 14
        elseif self._playerPokers[self._playerId][1] == 53 then
            self._MaxValue = 13
        end

        self._ChuiPaiType = 1
        self._Count = 1

        return true
    elseif count[1][13] == 2 and pokersCount == 2 then
        print(pokersCount .. ":wangzha")
        self._ChuPaiType = 12
        self._Count = 2
        -- ��Ϊ100��ʾ���
        self._MaxValue = 100

        Player._huoJian = true

        return true
    end


    -------------------------------------------------------

    if pokersCount == 1 then

        print(pokersCount .. ":dan pai")
        local temp = -1

        -- ����count���飬�ҳ���ֵ��������
        for key, var in pairs(count[1]) do
            if var ~= 0 then
                self._ChuPaiType = 1
                self._Count = 1
                self._MaxValue = key
            end
        end

        return true;


        -------------------------------------------------------

        -- ����Ϊһ��
    elseif pokersCount == 2 then
        if Player._tiShi == false then
            for key, var in pairs(count[1]) do
                if var == 2 then
                    self._Count = 2
                    self._ChuPaiType = 2
                    self._MaxValue = key
                    print "yi dui"
                    return true
                end
            end
        else
            -- �������ʾ��ť
            local flag = false
            for key, var in ipairs(count[1]) do

                if var == 2 then
                    for k, v in ipairs(self._playerPokers[self._playerId]) do

                        if (v - 1) >= key * 4 and(v - 1) <(key * 4 + 4) and key > self._lastMaxPokerValue then
                            self._recordPokerAI[k] = v - 1
                            self._recordSpritesAI[k] = self._pokerSprites[self._playerId][k]
                            self._MaxValue = key
                            self._Count = 2
                            self._ChuPaiType = 2
                            flag = true
                        end
                    end
                    if flag then
                        Player._tiShi = false
                        return flag
                    end
                end
            end
            Player._tiShi = false
            return flag
        end
        -------------------------------------------------------

        -- ����Ϊ3��
    elseif pokersCount == 3 then

        for key, var in pairs(count[1]) do
            if var == 3 then
                print "sanzhang"
                self._Count = 3
                self._MaxValue = key
                self._ChuPaiType = 3
                return true
            end
        end

        -------------------------------------------------------


        -- ������ը������������һ
    elseif pokersCount == 4 then

        for key, var in pairs(count[1]) do
            if var == 4 then
                print("zhadan" .. var)
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 4

                -- ��һ�ֳ���
                --                if Player._isFirstChuPai then

                --                else

                --                   Player._zhaDan=true
                --                end

                return true
            end
            if var == 3 then
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 6
                print "sanzhang dai yi"
                return true
            end
        end

        -------------------------------------------------------

        -- ������  ������˳��
    elseif pokersCount == 5 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- �����������
        local sss = false
        local ss = false

        for key, var in pairs(count[1]) do

            if var == 3 then
                sss = true
                self._MaxValue = key
            elseif var == 2 then
                ss = true
            end

        end
        if sss and ss then
            print "sanzhang dai yidui "
            self._Count = pokersCount

            self._ChuPaiType = 7
        end
        return sss and ss


        -------------------------------------------------------

        -- �Ĵ���   ������˳��    ��������˳     ������˫˳
    elseif pokersCount == 6 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ���Ŵ�2��
        local sss = false
        local temp = 0
        for key, var in pairs(count[1]) do
            if var == 4 then
                sss = true
                self._MaxValue = key
            elseif var <= 2 then
                temp = temp + var
            end
        end
        if sss and temp == 2 then
            print("4 dai 2")
            self._Count = 6
            self._ChuPaiType = 8

            return true
        end


        -- �ж��Ƿ�Ϊ��˳
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


        -- �п�����˳��
    elseif pokersCount == 7 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


        -- �п�����˫˳ ���� ˳�� ���� �ɻ�
    elseif pokersCount == 8 then

        -- �ж��Ƿ�Ϊ��˳
        if self:judgeSanShun(pokersCount, count[1]) == true then
            print(pokersCount .. ":fei ji")
            return true
        end

        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) then
            return true
        end


        -- �ж��Ƿ�Ϊ�ɻ�
        return self:judgeIsFeiJi(pokersCount, count[1])


        -------------------------------------------------------

    elseif pokersCount == 9 then

        -- �ж��Ƿ�Ϊ��˳
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -------------------------------------------------------

    elseif pokersCount == 10 then
        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ�ɻ�
        return self:judgeIsFeiJi(pokersCount, count[1])

        -------------------------------------------------------

    elseif pokersCount == 11 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


    elseif pokersCount == 12 then
        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ��˳
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ�ɻ�
        return self:judgeIsFeiJi(pokersCount, count[1])


        -------------------------------------------------------

    elseif pokersCount == 13 then
        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------

    elseif pokersCount == 14 then
        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end
        -------------------------------------------------------

    elseif pokersCount == 15 then


        -- �ж��Ƿ�Ϊ��˳
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ�ɻ�
        return self:judgeIsFeiJi(pokersCount, count[1])

        -------------------------------------------

    elseif pokersCount == 16 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- �ж��Ƿ�Ϊ˫˳
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- �ж��ǲ��Ƿɻ�
        return self:judgeIsFeiJi(pokersCount, count[1])
        -------------------------------------------------------

    elseif pokersCount == 17 then

        -- �ж��Ƿ�Ϊ˳��
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -------------------------------------------------------
    end


    -- ��������Ϸ���ƹ���
    return false;


end


-- �ж��Ƿ���˳��
function PokerManager:judgeIsShunZi(pokersCount, count)

    -- �����˳��
    local start = -1
    local endd = -1
    -- �ж��Ƿ����3
    if count[0] == 1 then

        for key, var in ipairs(count) do

            -- ˳�Ӳ�����2
            if key == 12 and count[12] == 1 then
                return false
            end

            if var == 1 then
                if start == -1 then
                    start = key
                else
                    endd = key
                end
            end
        end

        if endd - start == pokersCount - 2 then
            print(pokersCount .. ": had 3 shunzi")
            self._Count = pokersCount
            self._MaxValue = endd
            self._ChuPaiType = 5
            return true
        end
        -- ������3��˳��
    else
        for key, var in ipairs(count) do

            -- ˳�Ӳ�����2
            if key == 12 and count[12] == 1 then
                return false
            end

            if var == 1 then
                if start == -1 then
                    start = key
                else
                    endd = key
                end
            end
        end

        if endd - start == pokersCount - 1 then
            print(pokersCount .. ": shunzi")
            self._Count = pokersCount
            self._MaxValue = endd
            self._ChuPaiType = 5
            return true
        end
    end

    return false
end


-- �ж�����˳   
function PokerManager:judgeSanShun(pokersCount, count)

    -- �ж��Ƿ�Ϊ��˳
    local temp = 0
    local start = -1
    local endd = -1

    for key, var in pairs(count) do


        -- ��˳������2
        if key == 12 and count[12] == 3 then
            return false
        end


        -- ���ж���˳�����Ƿ���3
        if count[0] == 3 then

            if start == -1 and count[key] == 3 then
                start = key
            else
                endd = key
            end

            if var == 3 then
                temp = temp + 1
            end

            -- ������Ƶ���������12
            --            if pokersCount%3==0 then

            --            end

            if endd - start == math.floor(pokersCount / 3 - 1) and temp == math.floor(pokersCount / 3 - 1) then
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 10
                print(pokersCount .. ":sanshun have 3")
                return true
            end

            -- ����3����˳
        else
            -- Ϊ�˵ó��Ƿ�����������
            if start == -1 and count[key] == 3 then
                start = key
            else
                endd = key
            end
            -- �Ƿ���3����һ������
            if var == 3 then
                temp = temp + 1
            end

            if endd - start == math.floor(pokersCount / 3 - 1) and temp == math.floor(pokersCount / 3) then
                print(pokersCount .. ":sanshun")
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 10
                return true
            end

        end

    end


    return false

end




-- �ж��Ƿ�Ϊ˫˳
function PokerManager:judgeIsShuangShun(pokersCount, count)


    -- �ж��Ƿ�Ϊ˫˳
    local temp = 0
    local start = -1
    local endd = -1
    for key, var in pairs(count) do


        -- ˫˳������2
        if key == 12 and count[12] == 2 then
            return false
        end

        -- �ж��Ƿ������3��˫˳
        if count[0] == 2 then

            if var == 2 then
                temp = temp + 1
            end

            if start == -1 and count[key] == 2 then

                start = key
            else
                endd = key
            end

            if endd - start == pokersCount / 2 - 2 and temp == pokersCount / 2 - 1 then
                print(pokersCount .. ": shuangshun hava 3")
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 9
                return true
            end

        else

            if var == 2 then
                temp = temp + 1
            end

            if start == -1 and count[key] == 2 then

                start = key
            else
                endd = key
            end

            if endd - start == pokersCount / 2 - 1 and temp == pokersCount / 2 then
                print(pokersCount .. ": shuangshun")
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 9
                return true
            end
        end
    end
end


-- �ж��Ƿ��Ƿɻ�
function PokerManager:judgeIsFeiJi(pokersCount, count)

    if pokersCount == 8 then

        local flag = false

        local temp = 0
        for key, var in pairs(count) do

            -- �ɻ�����������2
            if key == 12 and count[12] >= 3 then
                return false
            end

            if var == 4 then
                temp = temp + 1
            end

            -- ���ж��Ƿ�������������
            -- ���жϴ�3����˳
            if count[0] >= 3 and count[1] >= 3 then
                self._MaxValue = 0
                flag = true
                -- ����������˳
            elseif count[key] >= 3 and count[key + 1] >= 3 then
                self._MaxValue = key
                flag = true
            end

            -- �жϷɻ���������
            if count[key] < 3 then
                temp = temp + count[key]
            end
        end

        if temp == 2 and flag == true then
            print(pokersCount .. ":fei ji")
            self._Count = pokersCount
            self._ChuPaiType = 11
            return true
        end

    elseif pokersCount == 10 then

        local temp = 0
        local flag = false
        for key, var in pairs(count) do


            -- �ɻ�����������2
            if key == 12 and count[12] == 3 then
                return false
            end


            -- ���жϴ�3�ķɻ�
            if count[0] == 3 and count[1] == 3 then
                self._MaxValue = 0
                flag = true
                -- �������ķɻ�
            elseif count[key] == 3 and count[key + 1] == 3 then
                self._MaxValue = key
                flag = true
            end

            if count[key] ~= 3 and count[key] == 2 then
                temp = temp + count[key]
            end
        end

        if temp == 4 and flag then
            print(pokersCount .. ":fei ji")
            self._Count = pokersCount
            self._ChuPaiType = 11
            return true
        end

    elseif pokersCount == 12 then

        local temp = 0
        local flag = false
        for key, var in pairs(count) do


            -- �ɻ�����������2
            if key == 12 and count[12] >= 3 then
                return false
            end


            if var == 4 then
                temp = temp + 1
            end

            -- ���жϴ�3�ķɻ�

            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- �������ķɻ�
            elseif count[key] >= 3 and count[key + 1] >= 3 and count[key + 2] >= 3 then
                self._MaxValue = key
                flag = true
            end

            if count[key] < 3 then

                temp = temp + count[key]
            end
        end

        if temp == 3 and flag == true then
            print(pokersCount .. ":fei ji")
            self._Count = pokersCount
            self._ChuPaiType = 11
            return true
        end

    elseif pokersCount == 15 then

        local temp = 0

        for key, var in pairs(count) do

            -- �ɻ�����������2
            if key == 12 and count[12] == 3 then
                return false
            end



            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- �������ķɻ�
            elseif count[key] >= 3 and count[key + 1] >= 3 and count[key + 2] >= 3 then
                self._MaxValue = key
                flag = true
            end

            if count[key] < 3 then

                temp = temp + count[key]
            end

        end



    elseif pokersCount == 16 then

        local temp = 0

        for key, var in pairs(count) do

            -- �ɻ�����������2
            if key == 12 and count[12] >= 3 then
                return false
            end


            -- ���жϴ�3�ķɻ�

            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- �������ķɻ�
            elseif count[key] >= 3 and count[key + 1] >= 3 and count[key + 2] >= 3 then
                self._MaxValue = key
                flag = true
            end

            if count[key] < 3 then

                temp = temp + count[key]
            end

            if var == 4 then
                temp = temp + 1
            end

        end


        if temp == 4 and flag == true then
            print(pokersCount .. ":fei ji")
            self._Count = pokersCount
            self._ChuPaiType = 11
            return true
        end
    end

    self._ChuPaiType = -1
    self._MaxValue = -1
    self._Count = -1

    return false
end


-------------------------------------------------------
function PokerManager:removeSprites(scene)

    for i = 1, 3 do

        local sprite = scene:getChildByTag(i * 10)

        self._playerPokers[self._playerId][17 + i] = self._diZhuPokers[i]
        self._pokerSprites[self._playerId][17 + i] = sprite
    end

    for key, var in ipairs(self._playerPokers[self._playerId]) do

        for i = 1, 20, 1 do
            for j = i, 20, 1 do
                if self._playerPokers[self._playerId][j] > self._playerPokers[self._playerId][i] then

                    self._playerPokers[self._playerId][j], self._playerPokers[self._playerId][i] = self._playerPokers[self._playerId][i], self._playerPokers[self._playerId][j]
                end
            end
        end
    end


    self._removeFlag = true

    -- ����   ������������
    self:sortPoker(scene, self._playerId)


    -- �Ƴ��ڵ�
    for i = 1, 3 do
        local coverSprite = scene:getChildByTag(i * 100)
        coverSprite:removeFromParent(true)
    end
end


-- �����˿��Ƶ�λ��
function PokerManager:adjustPosition(pokerSprites, chuPaiCount, playerId, points)

    for k, v in pairs(points) do
        -- �õ��˿��Ƶļ��    44   10   10
        if playerId == 1 then

            for key, var in ipairs(pokerSprites[playerId]) do
                if var ~= -1 and tolua.isnull(var) ~= true then
                    -- �����ƶ�
                    if key < v then
                        var:runAction(CCMoveBy:create(0.5, ccp(0.5 * 44, 0)))
                    end
                    -- �����ƶ�
                    if v < key then
                        var:runAction(CCMoveBy:create(0.5, ccp(-0.5 * 44, 0)))
                    end
                end
            end
        else

            for key, var in ipairs(self._pokerSprites[playerId]) do

                if var ~= -1 and tolua.isnull(var) ~= true then
                    -- �����ƶ�
                    if key < v then

                        var:runAction(CCMoveBy:create(0.5, ccp(0.5 * 10, 0)))
                    end

                    -- �����ƶ�
                    if v < key then
                        var:runAction(CCMoveBy:create(0.5, ccp(-0.5 * 10, 0)))
                    end
                end
            end
        end
    end
end


-- �Ƴ����ϸ���ҳ�����   Ҳ�����Լ��ĵļ�¼�ƾ���
function PokerManager:removeSelfRecords(recordPokers, playerId)

    for key, var in ipairs(recordPokers[playerId]) do

        if var ~= -1 and tolua.isnull(var) ~= true then

            -- ����Ϸ���Ƴ�
            var:removeFromParentAndCleanup(true)
            recordPokers[playerId][key] = -1

            -- �Ƴ���ҵ���
            -- self._pokerSprites[playerId][key]=-1

            -- self._playerPokers[playerId][key]=-1
        end
    end

    -- dump(self._playerPokers[playerId])
end



-- ���last��ҵ�����
function PokerManager:resetLastData()

    self._lastCount = -1
    self._lastMaxPokerValue = -1
    self._lastType = -1
end


-- ����ѡ�е���  �����ѡ��ִ�иò���
function PokerManager:resetRecordSprite(playerId)


    for key, var in pairs(self._recordPokers) do
        self._recordPokers[key] = nil
    end

    for key, var in ipairs(self._recordSprites[playerId]) do

        if var ~= -1 and tolua.isnull(var) ~= true then
            
            self.setFlag(self,playerId,key,false)

            var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))

            var:removeNodeEventListener(self._touchId[playerId][key])
            -- ����var�Ĵ�������
            self:setPokerTouch(playerId, key, var)

            self._recordSprites[playerId][key] = -1
        end
    end

end


-- �����˿��ƵĴ���
function PokerManager:setPokerTouch(playerId, key, var)

    -- Ϊÿһ���˿������һ�����������¼�
    var:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)

    var:setTouchEnabled(true);

    -- ��һ��flag���ж��˿����Ƿ������ƶ���

    --local flag = false;
    
    self._touchId[playerId][key] = var:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)       
        
        --���ŵ���Ƶ���Ч
        require("GameEffect").playClick()


        -- ���AI��ʾ
        self._recordPokerAI = { }
        self._recordSpritesAI = { }


        -- �������ð�ť����
        Player:setControlButtonEnable(2)


        -- ��¼���е��˿��Ƶ�ֵ
        if clickFlag[playerId][key] == false then

            self._recordPokers[key] = self._playerPokers[self._playerId][key] -1

            var:runAction(CCMoveBy:create(0.1, ccp(0, 30)))


            -- ���������˿��Ƶľ���
            self._recordSprites[self._playerId][key] = var

            clickFlag[playerId][key] = true

        else

            self._recordPokers[key] = nil;
            -- �����˿����ǰѾ����ֵ��ֵΪ-1
            self._recordSprites[self._playerId][key] = -1

            var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))
            clickFlag[playerId][key] = false;
        end


        -- �ж��Ƿ���Գ���
        if self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue) == true then



            self._isCanChuPai = true
            print("is Can ChuPai")

            Player:setControlButtonEnable(4)

            -- ���ܳ���
        else
            self._isCanChuPai = false

            if Player._btnSecondLabel[4]:isVisible() then
                Player:setControlButtonDisable(4)
            end
        end


    end )
    -- addNodeEventListener�Ľ�β
end



-- ����������е���
-- function PokerManager:analyzePokers(playId)

--    local count = { }
--    for i = 1, 14 do

--        count[i] = 0
--    end

--    for key, var in ipairs(self._playerPokers[playId]) do

--        -- ������1��ʼ   1λ�ô���3�ĸ���
--        count[math.floor((var - 1) / 4) + 1] = count[math.floor((var - 1) / 4) + 1] + 1

--    end

--    --judgeChuPai(recordPokers, lastType, maxPokerValue)

--    --self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue)

--    -- lastPokers  count    lastCount

--    -- ��һ�γ��Ƶ����������ͣ����ֵ
--    --    PokerManager._lastCount = -1
--    --    PokerManager._lastMaxPokerValue = -1
--    --    PokerManager._lastType = -1
--    -- PokerManager:judgeChuPai(recordPokers, lastType, maxPokerValue)
--    if self:isCanChuPai(self._playerPokers[playId], count, PokerManager._lastCount) then

--        print("have jsfkejkwffffffffffffffffffffff")
--        print(self._lastCount .. ":lastCount--------------" .. self._Count .. ":self._Count")
--        print(self._lastType .. ":lastType--------------" .. self._ChuPaiType .. ":self._ChuPaiType")
--        print(self._lastMaxPokerValue .. ":lastMaxPokerValue--------------" .. self._MaxValue .. ":self._maxValue")

--        local i=0
--        local temp=0
--        dump(self._playerPokers[playId])
--        dump(count)
--        for key, var in ipairs(self._playerPokers[playId]) do



----            if count[key]==2 then

----                if playId == 1 then
----                    y = display.height * 0.5
----                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 60

----                elseif playId == 2 then
----                    y = display.height * 0.5 + 200
----                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 30 + 200
----                elseif playId == 3 then
----                    y = display.height * 0.5 + 100
----                    x = display.width * 0.5 +(i - PokerManager._Count * 0.5) * 30 - 200

----                end

----                local spawn = CCSpawn:createWithTwoActions(CCMoveTo:create(0.7, ccp(x, y)), CCScaleTo:create(0.7, 0.5))

----                self._pokerSprites[playId][key]:runAction(spawn)
----                self._pokerSprites[playId][key+1]:runAction(spawn)
----                i = i + 1

------                temp=temp+1
------                if temp==2 then
------                   break
------                end

----            end
--        end
--    end



-- end


-- �����˿���
function PokerManager:resetPoker()


    -- self:showPokers(self._mainScene)

    -- print(tolua.isnull(self._mainScene))
    -- �Ƴ���ǰ����
    for id = 1, 3 do
        for i = 1, 20 do

            PokerManager._recordSprites[id][i] = -1
        end
    end

    -- ��ÿһ����ҵ��˿��Ƶľ���
    -- se._pokerSprites = { { }, { }, { } }
    for i = 1, 3 do
        for key, var in ipairs(self._pokerSprites[i]) do
            if var ~= -1 and tolua.isnull(var) ~= true then
                var:removeFromParent(true)
            end
        end
        self._pokerSprites[i] = { }
        self._playerPokers[i] = { }
    end

    -- ��ʼ���˿���
    self:initManage();
    self:fapaiPoker()

    self:showPokers(self._mianScene)
end


-- ��ʼ����������
function PokerManager:removeAllData()

    Player:resetData()

    self:resetPoker()
    self:resetLastData()
end



---- �ֶ��ܵ���ƵĻص�
--function PokerManager:clickedPokerCallBack(key,var,flag)

--    -- ���AI��ʾ
--    --        self._recordPokerAI = { }
--    --        self._recordSpritesAI = { }


--    -- �������ð�ť����
--    Player:setControlButtonEnable(2)


--    -- ��¼���е��˿��Ƶ�ֵ
--    if flag == false then

--        self._recordPokers[key] = self._playerPokers[self._playerId][key] -1

--        var:runAction(CCMoveBy:create(0.1, ccp(0, 30)))


--        -- ���������˿��Ƶľ���
--        self._recordSprites[self._playerId][key] = var

--        flag = true

--    else

--        self._recordPokers[key] = nil;
--        -- �����˿����ǰѾ����ֵ��ֵΪ-1
--        self._recordSprites[self._playerId][key] = -1

--        var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))
--        flag = false;
--    end


--    -- �ж��Ƿ���Գ���
--    if self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue) == true then



--        self._isCanChuPai = true
--        print("is Can ChuPai")

--        Player:setControlButtonEnable(4)

--        -- ���ܳ���
--    else
--        self._isCanChuPai = false

--        if Player._btnSecondLabel[4]:isVisible() then
--            Player:setControlButtonDisable(4)
--        end
--    end


--end


return PokerManager