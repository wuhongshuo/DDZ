local SettingLayer=class("SettingLayer",function()
    return display.newLayer()
end)


function SettingLayer:ctor()

    local settingBg=display.newSprite("dialog_person_bg.png")
    settingBg:setPosition(display.cx,display.cy)
    self:addChild(settingBg)

    local setTital=ui.newTTFLabel({text=dictionary.getGameStr("setting_title"),size=40})
    setTital:setPosition(display.cx,display.height*0.5+settingBg:getContentSize().height*0.5-30)
    self:addChild(setTital)


    local soundOffLabel=ui.newTTFLabel({text=dictionary.getGameStr("setting_mute"),size=30})
    soundOffLabel:setPosition(display.cx-150,display.cy+50)
    self:addChild(soundOffLabel)

    local swich=display.newSprite("switch-thumb.png")
    swich:setPosition(soundOffLabel:getPositionX()+50,soundOffLabel:getPositionY())
    self:addChild(swich,1)

    local soundOff=display.newSprite("switch-off.png")
    soundOff:setPosition(soundOffLabel:getPositionX()+80,soundOffLabel:getPositionY())
    self:addChild(soundOff)
    soundOff:setTouchEnabled(true)
    local offLabel=ui.newTTFLabel({text="off",size=20})
    soundOff:addChild(offLabel)
    offLabel:setPosition(25,15)


    local soundOn=display.newSprite("switch-on.png")
    soundOn:setPosition(soundOff:getPosition())
    self:addChild(soundOn)
    soundOn:setTouchEnabled(false)
    local onLabel=ui.newTTFLabel({text="on",size=20})
    onLabel:setPosition(10,15)
    soundOn:addChild(onLabel)
    soundOn:setVisible(false)


    soundOff:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()

          local seq=transition.sequence({CCMoveBy:create(0.3,ccp(60,0)),CCCallFunc:create(function()
               soundOn:setVisible(true)
               soundOn:setTouchEnabled(true)

               soundOff:setVisible(false)
               soundOff:setTouchEnabled(false)

               audio.pauseMusic();
          end)})

          swich:runAction(seq)
           -- CCSpawn* create(CCArray *arrayOfActions)
            
--            local array=CCArray:create()
--            array:addObject(CCMoveBy:create(0.3,ccp(60,0)))
--            array:addObject(CCCallFunc:create(function()

--                print(111) 
--            end))
--            local spawn=CCSpawn:create(array)
--            swich:runAction(spawn)
    end)
    
    soundOn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()

         swich:runAction(transition.sequence({CCMoveBy:create(0.3,ccp(-60,0)),CCCallFunc:create(function()
         
               soundOn:setVisible(false)
               soundOn:setTouchEnabled(false)

               soundOff:setVisible(true)
               soundOff:setTouchEnabled(true)

               audio.resumeMusic()
         end)}))
    end)
    

    local soundOnLabel=ui.newTTFLabel({text=dictionary.getGameStr("setting_shake"),size=30})
    soundOnLabel:setPosition(display.cx+100,display.cy+50)
    self:addChild(soundOnLabel)

    --音量label
    local musicLabel=ui.newTTFLabel({text=dictionary.getGameStr("setting_music"),size=30})
    musicLabel:setPosition(soundOffLabel:getPositionX(),soundOffLabel:getPositionY()-60)
    self:addChild(musicLabel)
    --音量滑动条
    local musicSlider=cc.ui.UISlider.new(display.LEFT_TO_RIGHT,{bar="sliderTrack.png",button="sliderThumb.png"},{scale9=true})
    musicSlider:setPosition(musicLabel:getPositionX()+70,musicLabel:getPositionY()-10)
    self:addChild(musicSlider,1)

    --musicSlider:setSliderSize(250,20)
    musicSlider:setSliderValue(100)

    local sprite=display.newSprite("sliderProgress.png")
    sprite:setPosition(musicLabel:getPositionX()+70,musicLabel:getPositionY()-10)
    self:addChild(sprite)
    sprite:setAnchorPoint(ccp(0,0))
    --sprite:setTextureRect(CCRect(0,0,250,20))

    musicSlider:onSliderValueChanged(function(event)
        
        print(event.value)
         audio.setMusicVolume(event.value)

         sprite:setTextureRect(CCRect(0,0,event.value*2.5,sprite:getContentSize().height))

    end)

    --音量图片
    local musicSoundMin=display.newSprite("music_0.png")
    musicSoundMin:setPosition(musicSlider:getPositionX()-20,musicSlider:getPositionY()+10)
    self:addChild(musicSoundMin)

    local musicSoundMax=display.newSprite("music_1.png")
    musicSoundMax:setPosition(musicSlider:getPositionX()+290,musicSlider:getPositionY()+10)
    self:addChild(musicSoundMax)


    --音效label
    local soundLabel=ui.newTTFLabel({text=dictionary.getGameStr("setting_sound"),size=30});
    soundLabel:setPosition(musicLabel:getPositionX(),musicLabel:getPositionY()-60)
    self:addChild(soundLabel)

    --音效图片
    local musicSoundMin=display.newSprite("music_0.png")
    musicSoundMin:setPosition(musicSlider:getPositionX()-20,musicSlider:getPositionY()-50)
    self:addChild(musicSoundMin)

    local musicSoundMax=display.newSprite("music_1.png")
    musicSoundMax:setPosition(musicSlider:getPositionX()+290,musicSlider:getPositionY()-50)
    self:addChild(musicSoundMax)

    --滑动条
    local soundSlider=cc.ui.UISlider.new(display.LEFT_TO_RIGHT,{bar="sliderTrack.png",button="sliderThumb.png"},{scale9=true})
    soundSlider:setPosition(musicSlider:getPositionX(),musicSlider:getPositionY()-60)
    self:addChild(soundSlider,1)
    soundSlider:setSliderValue(100)

    --滑动条背景
    local sliderBg=display.newSprite("sliderProgress.png")
    sliderBg:setAnchorPoint(0,0)
    sliderBg:setPosition(soundSlider:getPosition())
    self:addChild(sliderBg)

    soundSlider:onSliderValueChanged(function(event)
    
         sliderBg:setTextureRect(CCRect(0,0,event.value*2.5,20))

         --设置音效声音大小
         audio.setSoundsVolume(event.value)
    end)


    --关闭按钮
    local closeBtn=cc.ui.UIPushButton.new({normal="close.png",pressed="close_pressed.png"},{scale9=true})
    closeBtn:setPosition(settingBg:getPositionX()+190,settingBg:getPositionY()+180)
    self:addChild(closeBtn)
    closeBtn:onButtonClicked(function()
    
         self:removeFromParentAndCleanup(ture)
         --Player:stopScheduler(Player._schedulerId)
    end)
end




return SettingLayer