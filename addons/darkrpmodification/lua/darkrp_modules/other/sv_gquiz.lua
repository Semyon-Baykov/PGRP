gquiz = {}

gquiz.time = 1800

gquiz.question = nil

gquiz.answer = nil

gquiz.winnermoney = 6500

gquiz.started = 0


function gquiz.makequestion()

  local a = math.random(1,255)
  local b = math.random(1,255)
  local c = math.random(1,4)

  local strong = "+-*"

  local char = strong[math.floor(math.random(1, #strong))]



  gquiz.question = 'Сколько будет '..a..char..b..' ? Ответ /answer число'

--далее будет пиздец

  if char == '+' then
    gquiz.answer = a + b
  elseif char == '-' then
    gquiz.answer = a - b
  elseif char == '*' then
    gquiz.answer = a*b
  end

end

function gquiz.print()
    if #player.GetAll() >= 10 then
          ChatAddText(Color(0, 186, 255), '[Викторина] ', Color(255,255,255), gquiz.question)
  else
        ChatAddText(Color(0, 186, 255), '[Викторина] ', Color(255,255,255),'Недостаточно игроков для запуска викторины.')
  end
end
function gquiz.start()
  if gquiz.started == 1 then return end

  gquiz.started = 1

  gquiz.makequestion()
  gquiz.print()

  timer.Simple(45,function()
    if gquiz.started == 1 then
		if #player.GetAll() >= 20 then
			ChatAddText(Color(255,255,0), '[Викторина] ', Color(255,255,255), 'Верных ответов нет. Викторина окончена.')
		end
      gquiz.stop()
    end
  end)

end

function gquiz.stop()

  if gquiz.started == 0 then return end

  gquiz.started = 0

  timer.Simple(gquiz.time,gquiz.start)

end

hook.Add( 'PlayerSay', 'GPortalRP_quiz',function(ply, text)

  if (string.sub(text, 1,7) == '/answer') and gquiz.started == 1 then
    print(string.sub(text, 9 ))
    if string.sub(text, 9 ) == tostring(gquiz.answer) then
      ChatAddText(Color(255,255,0), '[Викторина] ', Color(255,255,255), ply:Nick()..' ответил первый и получает '..DarkRP.formatMoney(gquiz.winnermoney)..'!')
      gquiz.stop()
      ply:addMoney(gquiz.winnermoney)
    else
      ply:ChatAddText(Color(255,255,0), '[Викторина] ', Color(255,255,255), 'Ответ неверный.')
  end
  return ""
end
end)


hook.Add('Initialize', 'GPortalRP_quizinit', function()
  timer.Simple(gquiz.time,gquiz.start)
end)
