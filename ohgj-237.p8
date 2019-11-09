pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
objs = {}
money = 0
busted = false

function _init()
 sfx(3)

 add(objs, create_player())

 add(objs, create_money()) 
  
end

function _update()
 if (busted) then
  if btnp(5) then
   busted = false
   objs = {}
   money = 0
   _init()
  end
  return
 end

 for obj in all(objs) do
  obj.update()
 end
end

function _draw()
 rectfill(0, 0, 128, 128, 6)

 for obj in all(objs) do
  obj.draw()
 end
 
 print("money: $"..money, 44, 5, 1)
 
 if (busted) then
  print ("busted!", 50, 55, 0)
  print ("press x to restart", 25, 65, 0)
 end
end
-->8
function create_player()
 local obj = {}
 obj.type = "player"
 obj.sprite = 0
 obj.x = 64
 obj.y = 64
 obj.w = 8
 obj.h = 8
 obj.angle = 0
 obj.speed = 0
 
 obj.draw = function()
  spr_r(obj.sprite, obj.x, obj.y, -obj.angle)
 end
 
 obj.update = function()
  obj.x += obj.speed * cos(obj.angle)
  obj.y += obj.speed * sin(obj.angle)
  
  if (btn(2)) then
   obj.speed = 1
   sfx(0)
  elseif (btn(3)) then
   obj.speed = -1
   sfx(0)
  else
   obj.speed = 0
  end
  
  if (btn(0)) then
   obj.angle += 0.02
  end
  
  if (btn(1)) then
   obj.angle -= 0.02
  end
  
  for obj2 in all(objs) do
   if (collision(obj, obj2)) then
    if (obj2.type == "money") then
     money += 100
     obj2.reset_pos()
     sfx(1)
     
     if (money % 300 == 0) then
      add(objs, create_police())
     end
    end
    if (obj2.type == "police") then
     game_over()
    end
   end
  end
  
  if (obj.x <= 0) then
   obj.x = 0
  end
  
  if (obj.y <= 0) then
   obj.y = 0
  end
  
  if (obj.x >= 120) then
   obj.x = 120
  end
  
  if (obj.y >= 120) then
   obj.y = 120
  end
  
 end
 
 return obj
end
-->8

 function spr_r(s,x,y,a,w,h)
  sw=(w or 1)*8
  sh=(h or 1)*8
  sx=(s%8)*8
  sy=flr(s/8)*8
  x0=flr(0.5*sw)
  y0=flr(0.5*sh)
  sa=sin(a)
  ca=cos(a)
  for ix=0,sw-1 do
   for iy=0,sh-1 do
    dx=ix-x0
    dy=iy-y0
    xx=flr(dx*ca-dy*sa+x0)
    yy=flr(dx*sa+dy*ca+y0)
    if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
     pset(x+ix,y+iy,sget(sx+xx,sy+yy))
    end
   end
  end
 end
-->8
function create_money()
 local obj = {}
 obj.type = "money"
 obj.sprite = 2
 obj.x = 0
 obj.y = 0
 obj.w = 8
 obj.h = 8
 
 obj.draw = function()
  spr(obj.sprite, obj.x, obj.y)
 end
 
 obj.update = function()
  
 end
 
 obj.reset_pos = function()
  obj.x = rnd(120)
  obj.y = 20 + rnd(20)
 end
 
 obj.reset_pos()
 
 return obj
end
-->8
function collision(ent1, ent2)
 if (ent1.x <= ent2.x + ent2.w and
       ent1.x + ent1.w >= ent2.x and
       ent1.y <= ent2.y + ent2.h and
       ent1.h + ent1.y >= ent2.y) then
  return true
 else
 	return false
 end
end
-->8
function create_police()
 local obj = {}
 obj.type = "police"
 obj.sprite = 4
 obj.x = rnd(120)
 obj.y = 0
 obj.w = 8
 obj.h = 8
 obj.angle = 0
 obj.speed = 0
 
 obj.draw = function()
  spr_r(obj.sprite, obj.x, obj.y, -obj.angle)
 end
 
 obj.update = function()
  obj.x += obj.speed * cos(obj.angle)
  obj.y += obj.speed * sin(obj.angle)
  
  obj.speed = 1
  
  if (obj.x <= 0) then
   obj.x = 0
   obj.angle += 0.4 - rnd(0.2)
  end
  
  if (obj.y <= 0) then
   obj.y = 0
   obj.angle += 0.4 - rnd(0.2)
  end
  
  if (obj.x >= 120) then
   obj.x = 120
   obj.angle += 0.4 - rnd(0.2)
  end
  
  if (obj.y >= 120) then
   obj.y = 120
   obj.angle += 0.4 - rnd(0.2)
  end
  
  for obj2 in all(objs) do
   if (collision(obj, obj2)) then
    if (obj2.type == "police" and obj != obj2) then
     obj.angle += 0.4 - rnd(0.2)
     obj2.angle += 0.4 - rnd(0.2)
    end
   end
  end
  
 end
 
 return obj
end
-->8

function game_over()
 sfx(2)
 busted = true
end
__gfx__
66666666666666660004400000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
6dd66dd6666666660044a440000000006dd66dd66666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
5555555566666666044aaa4000000000555555556666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
588888c56666666644a4a4a400000000511111c56666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
588888c566666666444aa44400000000511111c56666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555666666664444aa4400000000555555556666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
6dd66dd66666666644a4a4a4000000006dd66dd66666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
6666666666666666044aaa4000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666660000000000000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666111661161166111616166666666611161666111611166666666666666666666666666666666666666666
66666666666666666666666666666666666666666666111616161616166616166166666611661666161616166666666666666666666666666666666666666666
66666666666666666666666666666666666666666666161616161616116611166666666661161116161616166666666666666666666666666666666666666666
66666666666666666666666666666666666666666666161616161616166666166166666611161616161616166666666666666666666666666666666666666666
66666666666666666666666666666666666666666666161611661616111611166666666661661116111611166666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666664466666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666644a44666666666666666666666666666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666666666666644aaa4666666666666666666666666666666666666666666666666666666666666666666666666666666
666666666666666666666666666666666666666666644a4a4a466666666666666666666666666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666666666666444aa44466666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666664444aa4466666666666666666666666666666666666666666666666666666666666666666666666666666
666666666666666666666666666666666666666666644a4a4a466666666666666666666666666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666666666666644aaa4666666666666666666666666666666666666666666666666666666666666666666666666666666
666666666666666666666666666666666666666666666666666666666666666666665ddd66666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666666666666666666666666666666666666655556dd66666666666666666666666666666666666666666666666666666
666666666666666666666666666666666666666666666666666666666666666666665c8855d66666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666665588888566666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666d55888566666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666dd6555566666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666ddd566666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666655666
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666655c5d66
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d5c15d66
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d5115666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665111566
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665115d6
6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d5115d6
6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d515566
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666666dd66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
666666666666666666666666666666666dd655556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666555511c56666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
666666666666666666666666666666665111111c6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666651115556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666655556dd6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
6666666666666666666666666666666666dd66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666

__sfx__
010200000e130111300e130111300e130111300e13011130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700001015013150171501715000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001715017150131501315011150101500e1500e1500c1500c15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700000e1500e1500e1501115011150111501315013150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
