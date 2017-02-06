-- GameScene=require("GameScene")
dictionary = require("DictionaryCommon")
Player = require("Player")

PokerManager = { }

 

-- 出牌的类型   比如连对，三带一，顺子   索引1存的是单牌，2存的是一对，3是三张，4是炸，5是顺子，6三代1，7三张带两张 8四张带两张 9 连对 ，10三顺 ，11飞机，12王炸
PokerManager._ChuPaiType = -1
-- 类型的最大值
PokerManager._MaxValue = -1
-- 一共出了多少张牌
PokerManager._Count = -1
-- 是否是第一次出牌
PokerManager._isFirstChuPai = true
-- 是否可以出牌
PokerManager._isCanChuPai = false

-- 存放出牌精灵
PokerManager._recordSprites = { { }, { }, { } }

-- 下一个玩家出牌
PokerManager._nextPlayer = false

-- 玩家Id
PokerManager._playerId = { 1, 2, 3 }

-- 存每一个玩家的扑克牌的精灵
PokerManager._pokerSprites = { { }, { }, { } }


-- 存扑克牌的value值,从1开始，1表示是最大的3，2是第二大的三
PokerManager._playerPokers = { { }, { }, { } }

-- 上一次出牌的数量，类型，最大值
PokerManager._lastCount = -1
PokerManager._lastMaxPokerValue = -1
PokerManager._lastType = -1

-- 是否显示下一个时钟
PokerManager._isShowNextTime = false;

-- 地主牌
PokerManager._diZhuPokers = { }
-- 地主牌精灵
PokerManager._diZhuPokerSprites = { }


-- 移除玩家牌flag
PokerManager._removeFlag = false

-- 每轮首次出牌的flag
PokerManager._isFirstChuPai = true;

-- 记录出牌的值
PokerManager._recordPokers = { }

-- 触摸id
PokerManager._touchId = { { }, { }, { } }

-- 记录主场景
PokerManager._mainScene = nil

-- 记录AI出牌
PokerManager._recordPokerAI = { }
PokerManager._recordSpritesAI = { }

--记录点击扑克牌的flag
local clickFlag={{},{},{}}

function PokerManager:getFlag()
     return clickFlag
end

function PokerManager:setFlag(playerId,key,flag)
     clickFlag[playerId][key]=flag
end

function PokerManager:initManage()
    
    --初始化flag
    function initFlag()

         for i=1,3 do
             for j=1,20 do
                 clickFlag[i][j]=false
             end
         end
    end

    initFlag()


    -- 加载扑克牌纹理
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("poker_card.plist", "poker_card.png")

    self._pokers = { }

    -- 初始化存放精灵的tabel
    for id = 1, 3 do
        for i = 1, 20 do

            PokerManager._recordSprites[id][i] = -1
        end
    end

end


-- 发牌   生成随机的牌发给不同的玩家
function PokerManager:fapaiPoker()

    -- 把54张牌的值存到_pokers数组中
    for i = 1, 54 do
        self._pokers[i] = i;
    end

    -- 打乱54张牌的顺序
    --    for i = 1, 54 do
    --        local rand = math.random(54)
    --        self._pokers[i], self._pokers[rand] = self._pokers[rand], self._pokers[i]
    --    end

    -- 把前17张发给玩家一
    for i = 1, 17 do

        self._playerPokers[1][i] = self._pokers[i]
    end

    -- 把前18-34张发给玩家二
    for i = 1, 17 do

        self._playerPokers[2][i] = self._pokers[i + 17]
    end

    -- 把前35-51张发给玩家三
    for i = 1, 17 do

        self._playerPokers[3][i] = self._pokers[i + 34]

    end

end


-- 把牌展示到游戏中  参数是游戏场景
function PokerManager:showPokers(scene)

    -- self._mainScene=scene

    -- print(tolua.isnull(self._mainScene))

    -- 先排序，后生成扑克牌
    for s = 1, 3 do
        for i = 1, 17, 1 do
            for j = i, 17, 1 do
                if self._playerPokers[s][j] > self._playerPokers[s][i] then

                    self._playerPokers[s][j], self._playerPokers[s][i] = self._playerPokers[s][i], self._playerPokers[s][j]
                end
            end
        end
    end

    -- 显示的地主牌
    local diZhuSprites = { }
    local coverSprites = { }
    for i = 1, 3 do

        -- 生成地主牌   3张
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
        -- 生成三张遮挡扑克牌的牌
        coverSprites[i] = display.newSprite("main_shoupai.png")
        coverSprites[i]:setPosition(diZhuSprites[i]:getPosition())
        self._mainScene:addChild(coverSprites[i], 0, i * 100)

        -- 生成每个玩家的扑克牌
        for key, var in ipairs(self._playerPokers[i]) do

            local frameNameIndex = self._playerPokers[i][key] -1;

            -- 用CCSprite来生成扑克牌
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
        -- 排序
        self:sortPoker(self._mainScene, i);
    end
end


-- pokers为玩家的牌，第二个参数为游戏场景，第三个参数为玩家的ID
function PokerManager:sortPoker(mainScene, playerId)

    if self._removeFlag then

        -- 重新生成扑克牌
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


    -- 只有玩家一才有展开动作
    if playerId == 1 and self._removeFlag == false then
        
        --播放音效
        require("GameEffect").playFaPai()

        -- 执行一个动作来展开扑克牌
        for key, var in ipairs(self._pokerSprites[playerId]) do

            local showSeq = transition.sequence( { CCMoveTo:create(1, ccp((key - 1) * 44 + 150, 200 *(playerId - 1) + 100)) })
            var:runAction(showSeq)

        end
    end


    -- 延迟计时器，两秒后改变扑克牌的纹理   主角                由于会产生错误，所以不改变扑克牌的纹理了
    local scheduler = require("framework.scheduler");

    scheduler.performWithDelayGlobal( function(dt)

        -- 改变牌的纹理
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
        -- 便利玩家手中的扑克牌结束的end  for

    end , 1.5)

end



-- 判断是否可以出牌   recordPokers上一个玩家出的牌 或者当前玩家点击的牌，主要是看lastType是不是空来决定是谁出的牌，lastType上一个玩家出牌的类型  ,maxPokerValue是上一个玩家出牌类型的最大值  如55522   值则是5
function PokerManager:judgeChuPai(recordPokers, lastType, maxPokerValue)

    -- 不是第一次出牌

    if lastType ~= -1 and maxPokerValue ~= -1 then

        -- 设置是否是第一次出牌
        Player._isFirstChuPai = false

        local pokersCount = 0;
        local count = { { }, { } }
        -- 是一个索引从0到13的数组，count[0]存储的是玩家点击出牌的牌中3的个数   count[13]存储的是大王的个数
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

        -- 判断是否可以出牌
        if self:isCanChuPai(recordPokers, count, pokersCount) then

            -- 这里只做测试输出
            print(self._lastCount .. ":lastCount--------------" .. self._Count .. ":self._Count")
            print(self._lastType .. ":lastType--------------" .. self._ChuPaiType .. ":self._ChuPaiType")
            print(self._lastMaxPokerValue .. ":lastMaxPokerValue--------------" .. self._MaxValue .. ":self._maxValue")

            -- 如果是王炸
            if self._Count == 2 and self._ChuPaiType == 12 then

                Player._huaJian = true
                return true

                -- 如果是炸弹，上一个玩家的牌不是炸弹
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



        -- 第一次出牌
    else

        local pokersCount = 0;
        local count = { { }, { } }
        -- 是一个索引从0到13的数组，count[0]存储的是玩家点击出牌的牌中3的个数   count[13]存储的是大王的个数
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


    -- 先判断点中了王
    if count[1][13] == 1 and pokersCount == 1 then

        print(pokersCount .. ":dan pai wang")
        -- 记录玩家的出牌类型，出牌数量，出牌类型的最大值
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
        -- 设为100表示最大
        self._MaxValue = 100

        Player._huoJian = true

        return true
    end


    -------------------------------------------------------

    if pokersCount == 1 then

        print(pokersCount .. ":dan pai")
        local temp = -1

        -- 便利count数组，找出有值数的索引
        for key, var in pairs(count[1]) do
            if var ~= 0 then
                self._ChuPaiType = 1
                self._Count = 1
                self._MaxValue = key
            end
        end

        return true;


        -------------------------------------------------------

        -- 类型为一对
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
            -- 点击了提示按钮
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

        -- 类型为3条
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


        -- 可能是炸弹或者是三带一
    elseif pokersCount == 4 then

        for key, var in pairs(count[1]) do
            if var == 4 then
                print("zhadan" .. var)
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 4

                -- 第一轮出牌
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

        -- 三带二  或者是顺子
    elseif pokersCount == 5 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- 如果是三带二
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

        -- 四带二   或者是顺子    或者是三顺     或者是双顺
    elseif pokersCount == 6 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为四张带2张
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


        -- 判断是否为三顺
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


        -- 有可能是顺子
    elseif pokersCount == 7 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


        -- 有可能是双顺 或者 顺子 或者 飞机
    elseif pokersCount == 8 then

        -- 判断是否为三顺
        if self:judgeSanShun(pokersCount, count[1]) == true then
            print(pokersCount .. ":fei ji")
            return true
        end

        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) then
            return true
        end


        -- 判断是否为飞机
        return self:judgeIsFeiJi(pokersCount, count[1])


        -------------------------------------------------------

    elseif pokersCount == 9 then

        -- 判断是否为三顺
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -------------------------------------------------------

    elseif pokersCount == 10 then
        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为飞机
        return self:judgeIsFeiJi(pokersCount, count[1])

        -------------------------------------------------------

    elseif pokersCount == 11 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------


    elseif pokersCount == 12 then
        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为三顺
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为飞机
        return self:judgeIsFeiJi(pokersCount, count[1])


        -------------------------------------------------------

    elseif pokersCount == 13 then
        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -------------------------------------------------------

    elseif pokersCount == 14 then
        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end
        -------------------------------------------------------

    elseif pokersCount == 15 then


        -- 判断是否为三顺
        if self:judgeSanShun(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为飞机
        return self:judgeIsFeiJi(pokersCount, count[1])

        -------------------------------------------

    elseif pokersCount == 16 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end


        -- 判断是否为双顺
        if self:judgeIsShuangShun(pokersCount, count[1]) == true then
            return true
        end

        -- 判断是不是飞机
        return self:judgeIsFeiJi(pokersCount, count[1])
        -------------------------------------------------------

    elseif pokersCount == 17 then

        -- 判断是否为顺子
        if self:judgeIsShunZi(pokersCount, count[1]) == true then
            return true
        end

        -------------------------------------------------------
    end


    -- 不符合游戏出牌规则
    return false;


end


-- 判断是否是顺子
function PokerManager:judgeIsShunZi(pokersCount, count)

    -- 如果是顺子
    local start = -1
    local endd = -1
    -- 判断是否包含3
    if count[0] == 1 then

        for key, var in ipairs(count) do

            -- 顺子不包含2
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
        -- 不包含3的顺子
    else
        for key, var in ipairs(count) do

            -- 顺子不包含2
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


-- 判断是三顺   
function PokerManager:judgeSanShun(pokersCount, count)

    -- 判断是否为三顺
    local temp = 0
    local start = -1
    local endd = -1

    for key, var in pairs(count) do


        -- 三顺不包含2
        if key == 12 and count[12] == 3 then
            return false
        end


        -- 先判断三顺里面是否有3
        if count[0] == 3 then

            if start == -1 and count[key] == 3 then
                start = key
            else
                endd = key
            end

            if var == 3 then
                temp = temp + 1
            end

            -- 如果出牌的数量大于12
            --            if pokersCount%3==0 then

            --            end

            if endd - start == math.floor(pokersCount / 3 - 1) and temp == math.floor(pokersCount / 3 - 1) then
                self._Count = pokersCount
                self._MaxValue = key
                self._ChuPaiType = 10
                print(pokersCount .. ":sanshun have 3")
                return true
            end

            -- 不带3的三顺
        else
            -- 为了得出是否是连续的牌
            if start == -1 and count[key] == 3 then
                start = key
            else
                endd = key
            end
            -- 是否有3张牌一样的牌
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




-- 判断是否为双顺
function PokerManager:judgeIsShuangShun(pokersCount, count)


    -- 判断是否为双顺
    local temp = 0
    local start = -1
    local endd = -1
    for key, var in pairs(count) do


        -- 双顺不包含2
        if key == 12 and count[12] == 2 then
            return false
        end

        -- 判断是否包含了3的双顺
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


-- 判断是否是飞机
function PokerManager:judgeIsFeiJi(pokersCount, count)

    if pokersCount == 8 then

        local flag = false

        local temp = 0
        for key, var in pairs(count) do

            -- 飞机不包含三张2
            if key == 12 and count[12] >= 3 then
                return false
            end

            if var == 4 then
                temp = temp + 1
            end

            -- 先判断是否有连续的三个
            -- 先判断带3的三顺
            if count[0] >= 3 and count[1] >= 3 then
                self._MaxValue = 0
                flag = true
                -- 不带三的三顺
            elseif count[key] >= 3 and count[key + 1] >= 3 then
                self._MaxValue = key
                flag = true
            end

            -- 判断飞机带的牌数
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


            -- 飞机不包含三张2
            if key == 12 and count[12] == 3 then
                return false
            end


            -- 先判断带3的飞机
            if count[0] == 3 and count[1] == 3 then
                self._MaxValue = 0
                flag = true
                -- 不带三的飞机
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


            -- 飞机不包含三张2
            if key == 12 and count[12] >= 3 then
                return false
            end


            if var == 4 then
                temp = temp + 1
            end

            -- 先判断带3的飞机

            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- 不带三的飞机
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

            -- 飞机不包含三张2
            if key == 12 and count[12] == 3 then
                return false
            end



            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- 不带三的飞机
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

            -- 飞机不包含三张2
            if key == 12 and count[12] >= 3 then
                return false
            end


            -- 先判断带3的飞机

            if count[0] >= 3 and count[1] >= 3 and count[2] >= 3 then
                self._MaxValue = 0
                flag = true
                -- 不带三的飞机
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

    -- 排序   重新生成纹理
    self:sortPoker(scene, self._playerId)


    -- 移除遮挡
    for i = 1, 3 do
        local coverSprite = scene:getChildByTag(i * 100)
        coverSprite:removeFromParent(true)
    end
end


-- 调整扑克牌的位置
function PokerManager:adjustPosition(pokerSprites, chuPaiCount, playerId, points)

    for k, v in pairs(points) do
        -- 得到扑克牌的间距    44   10   10
        if playerId == 1 then

            for key, var in ipairs(pokerSprites[playerId]) do
                if var ~= -1 and tolua.isnull(var) ~= true then
                    -- 向右移动
                    if key < v then
                        var:runAction(CCMoveBy:create(0.5, ccp(0.5 * 44, 0)))
                    end
                    -- 向左移动
                    if v < key then
                        var:runAction(CCMoveBy:create(0.5, ccp(-0.5 * 44, 0)))
                    end
                end
            end
        else

            for key, var in ipairs(self._pokerSprites[playerId]) do

                if var ~= -1 and tolua.isnull(var) ~= true then
                    -- 向右移动
                    if key < v then

                        var:runAction(CCMoveBy:create(0.5, ccp(0.5 * 10, 0)))
                    end

                    -- 向左移动
                    if v < key then
                        var:runAction(CCMoveBy:create(0.5, ccp(-0.5 * 10, 0)))
                    end
                end
            end
        end
    end
end


-- 移除上上个玩家出的牌   也就是自己的的记录牌精灵
function PokerManager:removeSelfRecords(recordPokers, playerId)

    for key, var in ipairs(recordPokers[playerId]) do

        if var ~= -1 and tolua.isnull(var) ~= true then

            -- 从游戏中移除
            var:removeFromParentAndCleanup(true)
            recordPokers[playerId][key] = -1

            -- 移除玩家的牌
            -- self._pokerSprites[playerId][key]=-1

            -- self._playerPokers[playerId][key]=-1
        end
    end

    -- dump(self._playerPokers[playerId])
end



-- 清空last玩家的数据
function PokerManager:resetLastData()

    self._lastCount = -1
    self._lastMaxPokerValue = -1
    self._lastType = -1
end


-- 退下选中的牌  点击重选后执行该步骤
function PokerManager:resetRecordSprite(playerId)


    for key, var in pairs(self._recordPokers) do
        self._recordPokers[key] = nil
    end

    for key, var in ipairs(self._recordSprites[playerId]) do

        if var ~= -1 and tolua.isnull(var) ~= true then
            
            self.setFlag(self,playerId,key,false)

            var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))

            var:removeNodeEventListener(self._touchId[playerId][key])
            -- 重置var的触摸监听
            self:setPokerTouch(playerId, key, var)

            self._recordSprites[playerId][key] = -1
        end
    end

end


-- 设置扑克牌的触摸
function PokerManager:setPokerTouch(playerId, key, var)

    -- 为每一张扑克牌添加一个触摸监听事件
    var:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)

    var:setTouchEnabled(true);

    -- 设一个flag，判断扑克牌是否向上移动了

    --local flag = false;
    
    self._touchId[playerId][key] = var:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)       
        
        --播放点击牌的音效
        require("GameEffect").playClick()


        -- 清空AI提示
        self._recordPokerAI = { }
        self._recordSpritesAI = { }


        -- 设置重置按钮可用
        Player:setControlButtonEnable(2)


        -- 记录点中的扑克牌的值
        if clickFlag[playerId][key] == false then

            self._recordPokers[key] = self._playerPokers[self._playerId][key] -1

            var:runAction(CCMoveBy:create(0.1, ccp(0, 30)))


            -- 存点击出牌扑克牌的精灵
            self._recordSprites[self._playerId][key] = var

            clickFlag[playerId][key] = true

        else

            self._recordPokers[key] = nil;
            -- 退下扑克牌是把精灵的值赋值为-1
            self._recordSprites[self._playerId][key] = -1

            var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))
            clickFlag[playerId][key] = false;
        end


        -- 判断是否可以出牌
        if self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue) == true then



            self._isCanChuPai = true
            print("is Can ChuPai")

            Player:setControlButtonEnable(4)

            -- 不能出牌
        else
            self._isCanChuPai = false

            if Player._btnSecondLabel[4]:isVisible() then
                Player:setControlButtonDisable(4)
            end
        end


    end )
    -- addNodeEventListener的结尾
end



-- 分析玩家手中的牌
-- function PokerManager:analyzePokers(playId)

--    local count = { }
--    for i = 1, 14 do

--        count[i] = 0
--    end

--    for key, var in ipairs(self._playerPokers[playId]) do

--        -- 索引从1开始   1位置存了3的个数
--        count[math.floor((var - 1) / 4) + 1] = count[math.floor((var - 1) / 4) + 1] + 1

--    end

--    --judgeChuPai(recordPokers, lastType, maxPokerValue)

--    --self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue)

--    -- lastPokers  count    lastCount

--    -- 上一次出牌的数量，类型，最大值
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


-- 重置扑克牌
function PokerManager:resetPoker()


    -- self:showPokers(self._mainScene)

    -- print(tolua.isnull(self._mainScene))
    -- 移除以前的牌
    for id = 1, 3 do
        for i = 1, 20 do

            PokerManager._recordSprites[id][i] = -1
        end
    end

    -- 存每一个玩家的扑克牌的精灵
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

    -- 初始化扑克牌
    self:initManage();
    self:fapaiPoker()

    self:showPokers(self._mianScene)
end


-- 初始化所有数据
function PokerManager:removeAllData()

    Player:resetData()

    self:resetPoker()
    self:resetLastData()
end



---- 手动跑点击牌的回调
--function PokerManager:clickedPokerCallBack(key,var,flag)

--    -- 清空AI提示
--    --        self._recordPokerAI = { }
--    --        self._recordSpritesAI = { }


--    -- 设置重置按钮可用
--    Player:setControlButtonEnable(2)


--    -- 记录点中的扑克牌的值
--    if flag == false then

--        self._recordPokers[key] = self._playerPokers[self._playerId][key] -1

--        var:runAction(CCMoveBy:create(0.1, ccp(0, 30)))


--        -- 存点击出牌扑克牌的精灵
--        self._recordSprites[self._playerId][key] = var

--        flag = true

--    else

--        self._recordPokers[key] = nil;
--        -- 退下扑克牌是把精灵的值赋值为-1
--        self._recordSprites[self._playerId][key] = -1

--        var:runAction(CCMoveBy:create(0.1, ccp(0, -30)))
--        flag = false;
--    end


--    -- 判断是否可以出牌
--    if self:judgeChuPai(self._recordPokers, PokerManager._lastType, PokerManager._lastMaxPokerValue) == true then



--        self._isCanChuPai = true
--        print("is Can ChuPai")

--        Player:setControlButtonEnable(4)

--        -- 不能出牌
--    else
--        self._isCanChuPai = false

--        if Player._btnSecondLabel[4]:isVisible() then
--            Player:setControlButtonDisable(4)
--        end
--    end


--end


return PokerManager