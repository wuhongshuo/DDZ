local GameIndex=class("GameIndex",function()
    return display.newScene("GameIndex")
end)

function GameIndex:ctor()
     --初始化背景图片
     local indexBg=display.newSprite("index_bg.jpg");
     self:addChild(indexBg)
     indexBg:setPosition(display.cx,display.cy);

     --初始化背景音乐按钮
     local musicButton=display.newSprite("open_music.png");
     self:addChild(musicButton)
     musicButton:setPosition(display.width-25,display.height-25)
     --点击音乐按钮图片回调
     local function musicButtonCallBack(event)
                 
          if event.name=="began" then
               return true;
          end
          if event.name=="ended" then  
               
               local textureCache=CCTextureCache:sharedTextureCache()
               if self._isPlayMusic then
                  
                  local texture=textureCache:addImage("close_music.png")
                  musicButton:setTexture(texture)
                  audio.pauseMusic();
                  self._isPlayMusic=false
               else
                  local texture=textureCache:addImage("open_music.png");
                  musicButton:setTexture(texture);
                  audio.resumeMusic();
                  self._isPlayMusic=true;
               end
          end
     end
     musicButton:setTouchEnabled(true);
     musicButton:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE);
     musicButton:addNodeEventListener(cc.NODE_TOUCH_EVENT,musicButtonCallBack)


     --成果.资料初始化
     local feedBack=cc.ui.UIPushButton.new({normal="feedback.png",pressed="feedback_pressed.png"},{scale9=false})
     feedBack:setPosition(display.width-90,display.height-25);
     self:addChild(feedBack);


     --得到字典，用于设置按钮上的文字
     local dic=CCDictionary:createWithContentsOfFile("strings.xml");
     

     --开始游戏按钮
     local startButton=cc.ui.UIPushButton.new({normal="index_button.png",pressed="index_button_pressed.png"},{scale9=false})
     self:addChild(startButton)
     startButton:setPosition(800,500);
     --local startLabel=CCLabelTTF:create(str,"",40)
     --self:addChild(startLabel);
     --startLabel:setPosition(startButton:getPosition())
     local startStr=dic:objectForKey("index_start"):getCString();
     startButton:setButtonLabel("pressed",cc.ui.UILabel.new({UILabelType=2,text=startStr,size=50}));
     startButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=startStr,size=40}))
     startButton:onButtonClicked(function(event)
           
           print(startStr)
           display.replaceScene(require("GameScene").new(),"crossFade",0.5);
           --local gameScene=
     end)
     
     --继续游戏
     local setPeopleButton=cc.ui.UIPushButton.new({normal="index_button.png",pressed="index_button_pressed.png"},{scale9=false})
     local setPeopleStr=dic:objectForKey("index_setting"):getCString();
     setPeopleButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=setPeopleStr,size=40}))
     setPeopleButton:setButtonLabel("pressed",cc.ui.UILabel.new({UILabelType=2,text=setPeopleStr,size=50}))
     setPeopleButton:setPosition(800,400);
     self:addChild(setPeopleButton);
     setPeopleButton:onButtonClicked(function(event)
           print(setPeopleStr);
     end)

     --更多推荐按钮
     local recommendButton=cc.ui.UIPushButton.new({normal="index_button.png",pressed="index_button_pressed.png"},{scale9=false})
     local recommendStr=dic:objectForKey("index_more"):getCString();
     recommendButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=recommendStr,size=40}))
     recommendButton:setButtonLabel("pressed",cc.ui.UILabel.new({UILabelType=2,text=recommendStr,size=50}))
     recommendButton:setPosition(800,300)
     self:addChild(recommendButton);

     --退出游戏按钮
     local exitButton=cc.ui.UIPushButton.new({normal="index_button.png",pressed="index_button_pressed.png"},{scale9=false})
     local exitStr=dic:objectForKey("index_exit"):getCString()
     exitButton:setButtonLabel("normal",cc.ui.UILabel.new({UILabelType=2,text=exitStr,size=40}))
     exitButton:setButtonLabel("pressed",cc.ui.UILabel.new({UILabelType=2,text=exitStr,size=50}))
     exitButton:setPosition(800,200)
     self:addChild(exitButton)
     exitButton:onButtonClicked(function()
            print(exitStr)
            os.exit();
            --CCDirector:shardDirector():end();
     end)

end


function GameIndex:onEnter()
      
      self._isPlayMusic=true
end

return GameIndex