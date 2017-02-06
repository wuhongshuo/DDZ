local WelcomeScene=class("WelcomeScene",function()
       return display.newScene("WelcomeScene");
end)

function WelcomeScene:ctor()
       --初始化背景图片
       local bg=display.newSprite("wellcome_bg.jpg");
       self:addChild(bg);
       bg:setPosition(display.cx,display.cy);
       
       --播放背景音乐
       audio.preloadMusic("sound/music/game_music.mp3");
       audio.playMusic("sound/music/game_music.mp3");

       --计时器，1.5秒后转换到游戏索引界面
       local scheduler=require("framework.scheduler");
       self.schedulerId=scheduler.performWithDelayGlobal(function(dt)
       
          scheduler.unscheduleGlobal(self.schedulerId)

          local gameIndexScene=require("GameIndex").new();
          display.replaceScene(gameIndexScene,"flipX",0.4);
       end,1.5)
end


return WelcomeScene;