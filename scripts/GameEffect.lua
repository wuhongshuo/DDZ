local GameEffect = { }

local audio = SimpleAudioEngine:sharedEngine()

-- ���ų������Ƶ���Ч
function GameEffect.playChuDanZhang(card, sex)

    SimpleAudioEngine:sharedEngine():playEffect("sound/card/card_single_" .. card  .. "_" .. sex .. ".mp3")
end

-- ���ų�һ�Ե���Ч
function GameEffect.playChuYiDui(card, sex)

    audio:playEffect("sound/card/card_double_" .. card .. "_" .. sex .. ".mp3")
end

-- ����˳�ӵ���Ч
function GameEffect.playChuShunZi(sex)

    audio:playEffect("sound/card/card_shunzi_" .. sex .. ".mp3")
end

-- �������ӵ���Ч
function GameEffect.playChuLianDui(sex)

    audio:playEffect("sound/card/card_doubleline_" .. sex .. ".mp3")
end

-- ���Ż������Ч
function GameEffect.playChuHuoJian(sex)

    audio:playEffect("sound/card/card_rocket_" .. sex .. ".mp3")
end

-- ���ŷɻ�����Ч
function GameEffect.playChuFeiJi(sex)

    audio:playEffect("sound/card/card_plane_" .. sex .. ".mp3")
end

-- ���ų���������Ч
function GameEffect.playChuSanZhang(sex)

    audio:playEffect("sound/card/card_three_" .. sex .. ".mp3")
end

-- ���ų�������һ������Ч
function GameEffect.playChuSanDaiYi(sex)

    audio:playEffect("sound/card/card_three_1_" .. sex .. ".mp3")
end

-- ���ų�������һ�Ե���Ч
function GameEffect.playChuSanDaiYiDui(sex)

    audio:playEffect("sound/card/card_three_2_" .. sex .. ".mp3")
end

-- ���ų�ը������Ч
function GameEffect.playChuZhaDan(sex)

    audio:playEffect("sound/card/card_bomb_" .. sex .. ".mp3")
end


-- �����Ҫ
function GameEffect.playBuChu(sex)

    audio:playEffect("sound/card/card_pass_" .. sex .. ".mp3")
end

-- ֻʣһ����
function GameEffect.playLastCard(sex)

    audio:playEffect("sound/card/card_last_1_" .. sex .. ".mp3")
end

-- ֻʣ��������
function GameEffect.playLast2Card(sex)

   audio:playEffect("sound/card/card_last_2_" .. sex .. ".mp3")
end

--����Ƶ���Ч
function GameEffect.playClick()
   
   audio:playEffect("sound/card/card_click.mp3")
end

--���Ƶ���Ч
function GameEffect.playFaPai()
    
   audio:playEffect("sound/card/card_deal.mp3")
end


--�������ԣ�����һ��˳��   ����1����ǵ��ƣ�2�����һ�ԣ�3�����ţ�4��ը��5��˳�ӣ�6����1��7���Ŵ����� 8���Ŵ����� 9 ���� ��10��˳ ��11�ɻ���12��ը
--������Ч
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