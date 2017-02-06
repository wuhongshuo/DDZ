local WelcomeScene=class("WelcomeScene",function()
       return display.newScene("WelcomeScene");
end)

function WelcomeScene:ctor()
       --��ʼ������ͼƬ
       local bg=display.newSprite("wellcome_bg.jpg");
       self:addChild(bg);
       bg:setPosition(display.cx,display.cy);
       
       --���ű�������
       audio.preloadMusic("sound/music/game_music.mp3");
       audio.playMusic("sound/music/game_music.mp3");

       --��ʱ����1.5���ת������Ϸ��������
       local scheduler=require("framework.scheduler");
       self.schedulerId=scheduler.performWithDelayGlobal(function(dt)
       
          scheduler.unscheduleGlobal(self.schedulerId)

          local gameIndexScene=require("GameIndex").new();
          display.replaceScene(gameIndexScene,"flipX",0.4);
       end,1.5)
end


return WelcomeScene;