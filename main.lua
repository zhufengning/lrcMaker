require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "filechooser"
import "android.media.MediaPlayer"
import "android.text.InputType"
local utf8=require("utf8-simple")0

--activity.setTitle('AndroLua+')
activity.setTheme(android.R.style.Theme_Material_Light)
activity.setContentView(loadlayout(layout))

--print("\n")

b_choose.onClick=function()
  ChoiceFile("/storage/emulated/0/",function(a)
    t_file.text=a
    playMusic(a)
  end
  )
end

mp=MediaPlayer()
function playMusic(path)
  mp.reset()
  .setDataSource(path)
  .prepare()
  .start()
  .setOnCompletionListener({
    onCompletion=function()
      print("播放完毕")
    end})
  --print(mp.getDuration())
  p_pro.max=mp.getDuration()
  ti=Ticker()
  ti.Period=1
  ti.onTick=function() 
    --事件

    fen=""..math.modf(mp.getCurrentPosition()/1000/60)
    if #fen==1 then
      fen="0"..fen
    end
    miao=""..math.modf(mp.getCurrentPosition()/1000)%60
    if #miao==1 then
      miao="0"..miao
    end
    hao=mp.getCurrentPosition()%1000
    hao=hao/10
    hao=math.floor(hao)
    if hao<10 then
      hao="0"..hao
    end
    time="["..fen..":"..miao.."."..hao.."]"
    t_time.text=time
    p_pro.progress=mp.getCurrentPosition()
    --e_lrc.clearFocus();
  end
  --启动Ticker定时器
  ti.start()
  --停止Ticker定时器
  ti.stop()
end

function onStop()
  mp.pause()
end

function onDestroy()
  mp.stop()
  mp.release()
  ti.stop()
end

function onResume()
  mp.start()
end

b_add.onClick=function ()

  n=e_lrc.getSelectionStart()
  t=e_lrc.text
  --print(t)

  for i,j,l in utf8.chars(t) do

    --print(n..string.sub(t,i,1))
    if j=="\n" or j==[[
]] or j==[[
]] or j==[[
]] then
      --print(l.." "..n)
      if i<=n then
        k=i

      end

    end
    if k==nil then
      k=0
    end
  end
  t1=utf8.sub(t,1,k)
  t2=utf8.sub(t,k+1,utf8.len(t))
  e_lrc.text=t1..time..t2
  e_lrc.setSelection(n)
end

b_zuo.onClick=function ()
  mp.seekTo(mp.getCurrentPosition()-5000)
end

b_you.onClick=function ()
  mp.seekTo(mp.getCurrentPosition()+5000)
end

b_pause.onClick=function ()
  if mp.isPlaying() then
    mp.pause()
    b_pause.text="→"
  else
    mp.start()
    b_pause.text="||"
  end
end