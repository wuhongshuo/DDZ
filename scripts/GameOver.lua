require("Tag")

local GameOver=class("GameOver",function()
     return display.newLayer()
end)

function GameOver:ctor()

     local overBg=display.newSprite("score_bg.png")
     overBg:setPosition(self:getContentSize().width*0.5,self:getContentSize().height*0.5)
     --overBg:setScale(0.01)
     self:addChild(overBg,0,OVERGAMEBG)
     self:setScale(0.01)

     local title0=display.newSprite("score_text0.png")
     title0:setPosition(overBg:getPositionX(),overBg:getPositionY()+150)
     self:addChild(title0,0,DIZHUWIN)

     local title1=display.newSprite("score_text1.png")
     title1:setPosition(overBg:getPositionX(),overBg:getPositionY()+150)
     self:addChild(title1,0,NOMINGWIN)

     --返回主菜单
     local backButton=cc.ui.UIPushButton.new({normal="score_button.png",pressed=="score_button_pressed.png"},{scale9=false})
     local backStr=dictionary.getGameStr("main_back")
     backButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=backStr,size=20}))
     backButton:setPosition(overBg:getPositionX()-150,overBg:getPositionY()-180)
     backButton:onButtonClicked(function()   
           
           PokerManager:removeAllData()
           --PokerManager:resetLastData()
           self:removeFromParentAndCleanup(true)
           local gameIndex=require("GameIndex").new()
           display.replaceScene(gameIndex,"rotoZoom",0.5)
     end)
     self:addChild(backButton)


     --再来一局
     local playAgainButton=cc.ui.UIPushButton.new({normal="score_button.png",pressed="score_button_pressed.png"},{scale9=false})
     playAgainButton:setPosition(ccp(overBg:getPositionX()+150,overBg:getPositionY()-180))
     playAgainButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=dictionary.getGameStr("main_again"),size=20}))
     playAgainButton:onButtonClicked(function()
          
          --初始化
          --display.replaceScene(require("GameScene").new())
          --CCDirector:sharedDirector():resume()

          PokerManager:removeAllData()

          self:removeFromParentAndCleanup(true)

          local scheudler=require("framework.scheduler")
          require("GameScene"):registerScheduler(scheudler)
     end)
     self:addChild(playAgainButton)


     --底分
     local diFenLabel=ui.newTTFLabel({text=dictionary.getGameStr("main_score"),size=20})
     diFenLabel:setPosition(overBg:getPositionX()-200,overBg:getPositionY()+40)
     self:addChild(diFenLabel)
     local diFenCount=ui.newTTFLabel({text=Player._diFenCount,size=20})
     diFenCount:setPosition(diFenLabel:getPositionX()+50,diFenLabel:getPositionY())
     self:addChild(diFenCount)

     --倍数
     local multipleLabel=ui.newTTFLabel({text=dictionary.getGameStr("main_multiple"),size=20})
     multipleLabel:setPosition(diFenLabel:getPositionX(),diFenLabel:getPositionY()-50)
     self:addChild(multipleLabel)
     local multipleCount=ui.newTTFLabel({text=Player._multipleCount,size=20})
     multipleCount:setPosition(multipleLabel:getPositionX()+50,multipleLabel:getPositionY())
     self:addChild(multipleCount)

     --玩家
     local playerLabel=ui.newTTFLabel({text=dictionary.getGameStr("succeed_name"),size=30})
     playerLabel:setPosition(overBg:getPositionX()-60,overBg:getPositionY()+85)
     self:addChild(playerLabel)

     local player1=ui.newTTFLabel({text=dictionary.getGameStr("succeed_name"),size=30,color=cc.c3b(255,0,0)})
     player1:setPosition(playerLabel:getPositionX(),playerLabel:getPositionY()-50)
     self:addChild(player1)
     
     local player2=ui.newTTFLabel({text=dictionary.getGameStr("name_" .. Player._playerNameRand[1]),size=30})
     player2:setPosition(player1:getPositionX(),player1:getPositionY()-50)
     self:addChild(player2)
     local player3=ui.newTTFLabel({text=dictionary.getGameStr("name_" .. Player._playerNameRand[2]),size=30})
     player3:setPosition(player2:getPositionX(),player2:getPositionY()-50)
     self:addChild(player3)

     --胜负
     local winLabel=ui.newTTFLabel({text=dictionary.getGameStr("succeed_win"),size=30})
     winLabel:setPosition(playerLabel:getPositionX()+160,playerLabel:getPositionY())
     self:addChild(winLabel)

     self:discribeWinLabel(PokerManager._playerId,Player._diZhuId)


     --暂停游戏
     --CCDirector:sharedDirector():pause()

  
end


function GameOver:Resize(flag)

     local scale=CCScaleBy:create(1,100)
     self:runAction(scale)

     if flag then
        local title1=self:getChildByTag(NOMINGWIN)
        title1:setVisible(false)

        local icon=display.newSprite("score_icon0.png")
        icon:setPosition(display.cx+200,display.cy+100)
        self:addChild(icon)
     else 
        local title0=self:getChildByTag(DIZHUWIN)
        title0:setVisible(false)

        local icon=display.newSprite("score_icon1.png")
        icon:setPosition(display.cx+200,display.cy+100)
        self:addChild(icon)
     end
end


--胜负
function GameOver:discribeWinLabel(playerId,diZhuId)    
    
    if playerId==diZhuId then

       local score=Player._diFenCount*Player._multipleCount
       
       local winLabel=ui.newTTFLabel({text="+" .. score,size=30})
       winLabel:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1)%3*50+40)
       self:addChild(winLabel)

       local loseScore=score*0.5
       local loseLabel=ui.newTTFLabel({text=("-" .. loseScore),size=30})
       loseLabel:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+1)%3*50+40)
       self:addChild(loseLabel)

       local loseLabel2=ui.newTTFLabel({text=("-" .. loseScore),size=30})
       loseLabel2:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+2)%3*50+40)
       self:addChild(loseLabel2)

       --local totalScore=Player.getScore()
       local totalScore=CCUserDefault:sharedUserDefault():getIntegerForKey("totalScore")
       if diZhuId==1 then            
            totalScore=totalScore+score
            CCUserDefault:sharedUserDefault():setIntegerForKey("totalScore",totalScore)
       else
            totalScore=totalScore-score*0.5
            CCUserDefault:sharedUserDefault():setIntegerForKey("totalScore",totalScore)
       end
    else

       local score=Player._diFenCount*Player._multipleCount     
       local winLabel=ui.newTTFLabel({text="+" .. score*0.5,size=30})
       winLabel:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1)%3*50+40)
       self:addChild(winLabel)

       if (playerId+1-1)%3==(diZhuId-1)%3 then
           local loseScore=score*0.5
           local loseLabel=ui.newTTFLabel({text=("-" .. score),size=30})
           loseLabel:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+1)%3*50+40)
           self:addChild(loseLabel)

           local loseLabel2=ui.newTTFLabel({text=("+" .. score*0.5),size=30})
           loseLabel2:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+2)%3*50+40)
           self:addChild(loseLabel2)

       else
           local loseScore=score*0.5
           local loseLabel=ui.newTTFLabel({text=("+" .. score*0.5),size=30})
           loseLabel:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+1)%3*50+40)
           self:addChild(loseLabel)

           local loseLabel2=ui.newTTFLabel({text=("-" .. score),size=30})
           loseLabel2:setPosition(display.width*0.5+90,display.height*0.5-(playerId-1+2)%3*50+40)
           self:addChild(loseLabel2)
       end


       local totalScore=CCUserDefault:sharedUserDefault():getIntegerForKey("totalScore")
       if diZhuId==1 then            
            totalScore=totalScore-score
            CCUserDefault:sharedUserDefault():setIntegerForKey("totalScore",totalScore)
       else
            totalScore=totalScore+score*0.5
            CCUserDefault:sharedUserDefault():setIntegerForKey("totalScore",totalScore)
       end
    end

    --显示我的总积分
    --local totalScore=Player.getScore()
    local totalScore=CCUserDefault:sharedUserDefault():getIntegerForKey("totalScore")
    local totalScoreLabel=ui.newTTFLabel({text=dictionary.getGameStr("dialog_person_score"),size=30})
    totalScoreLabel:setPosition(ccp(display.cx-50,display.cy-120))
    self:addChild(totalScoreLabel)

    local score=ui.newTTFLabel({text=totalScore,size=30})
    score:setPosition(ccp(totalScoreLabel:getPositionX()+100,totalScoreLabel:getPositionY()))
    self:addChild(score)
end



return GameOver