local GameEffect = { }

local audio = SimpleAudioEngine:sharedEngine()

-- 播放出单张牌的音效
function GameEffect.playChuDanZhang(card, sex)

    SimpleAudioEngine:sharedEngine():playEffect("sound/card/card_single_" .. card  .. "_" .. sex .. ".mp3")
end

-- 播放出一对的音效
function GameEffect.playChuYiDui(card, sex)

    audio:playEffect("sound/card/card_double_" .. card .. "_" .. sex .. ".mp3")
end

-- 播放顺子的音效
function GameEffect.playChuShunZi(sex)

    audio:playEffect("sound/card/card_shunzi_" .. sex .. ".mp3")
end

-- 播放连队的音效
function GameEffect.playChuLianDui(sex)

    audio:playEffect("sound/card/card_doubleline_" .. sex .. ".mp3")
end

-- 播放火箭的音效
function GameEffect.playChuHuoJian(sex)

    audio:playEffect("sound/card/card_rocket_" .. sex .. ".mp3")
end

-- 播放飞机的音效
function GameEffect.playChuFeiJi(sex)

    audio:playEffect("sound/card/card_plane_" .. sex .. ".mp3")
end

-- 播放出三个的音效
function GameEffect.playChuSanZhang(sex)

    audio:playEffect("sound/card/card_three_" .. sex .. ".mp3")
end

-- 播放出三个带一个的音效
function GameEffect.playChuSanDaiYi(sex)

    audio:playEffect("sound/card/card_three_1_" .. sex .. ".mp3")
end

-- 播放出三个带一对的音效
function GameEffect.playChuSanDaiYiDui(sex)

    audio:playEffect("sound/card/card_three_2_" .. sex .. ".mp3")
end

-- 播放出炸弹的音效
function GameEffect.playChuZhaDan(sex)

    audio:playEffect("sound/card/card_bomb_" .. sex .. ".mp3")
end


-- 点击不要
function GameEffect.playBuChu(sex)

    audio:playEffect("sound/card/card_pass_" .. sex .. ".mp3")
end

-- 只剩一张牌
function GameEffect.playLastCard(sex)

    audio:playEffect("sound/card/card_last_1_" .. sex .. ".mp3")
end

-- 只剩两张牌了
function GameEffect.playLast2Card(sex)

   audio:playEffect("sound/card/card_last_2_" .. sex .. ".mp3")
end

--点击牌的音效
function GameEffect.playClick()
   
   audio:playEffect("sound/card/card_click.mp3")
end

--发牌的音效
function GameEffect.playFaPai()
    
   audio:playEffect("sound/card/card_deal.mp3")
end


--比如连对，三带一，顺子   索引1存的是单牌，2存的是一对，3是三张，4是炸，5是顺子，6三代1，7三张带两张 8四张带两张 9 连对 ，10三顺 ，11飞机，12王炸
--播放音效
function GameEffect:playEffect(cardtype,sex,card)

    if cardtype==1 then
         
         self.playChuDanZhang(card,sex)

    elseif cardtype==2 then
         
         self.playChuYiDui(card,sex)

    elseif cardtype==3 then

         self.playChuSanZhang(sex)

    elseif cardtype==4 then
         
         self.playChuZhaDan(sex)

    elseif cardtype==5 then

         self.playChuShunZi(sex)

    elseif cardtype==6 then
         
         self.playChuSanDaiYi(sex)

    elseif cardtype==7 then
         
         self.playChuSanDaiYiDui(sex)

    elseif cardtype==8 then


    elseif cardtype==9 then

         self.playChuLianDui(sex)

    elseif cardtype==10 then

         self.playChuFeiJi(sex)

    elseif cardtype==11 then

         self.playChuFeiJi(sex)

    elseif cardtype==12 then
         
         self.playChuHuoJian(sex)
    end
end

return GameEffect