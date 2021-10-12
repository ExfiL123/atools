script_name('atools') -- название скрипта
script_author('exfil') -- автор скрипта
script_description('Command') -- описание скрипта

require "lib.moonloader" -- подключение библиотеки
local dlstatus = require('moonloader').download_statuslocal
local keys = require 'vkeys'
local hook = require 'lib.samp.events'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tag = "[Atools]:" -- локальная переменная
local label = 0
local main_color = 0x9A2EFE
local main_color_text = "{9A2EFE}"
local second_main_color_text = "{1C6EB2}"
local white_color = "{1C6EB2}"
local arr_str = {u8"Первый", u8"Второй", u8"Третий", u8"Четвертый", u8"Пятый", u8"Шестой"}

latest = "0.0.2"
script_version ("0.0.2")

local main_window_state = imgui.ImBool(false)
local second_window_state = imgui.ImBool(false)

local text_buffer = imgui.ImBuffer(256)
local text_buffer_name = imgui.ImBuffer(256)

local checked_test = imgui.ImBool(false)
local checked_test_2 = imgui.ImBool(false)

local checked_radio = imgui.ImInt(1)

local combo_select = imgui.ImInt(0)

local sw, sh = getScreenResolution()



local win_state = {}
win_state['main'] = imgui.ImBool (false)
win_state['settings'] = imgui.ImBool (false)
win_state['cmds'] = imgui.ImBool (false)
win_state['table'] = imgui.ImBool (false)
win_state['fast'] = imgui.ImBool (false)
win_state['stat'] = imgui.ImBool (false)
win_state['show_log'] = imgui.ImBool(false)
win_state['admin'] = imgui.ImBool(false)
win_state['change_color_box'] = imgui.ImBool(false)
win_state['checker'] = imgui.ImBool(false)
win_state['upd'] = imgui.ImBool(false)
win_state['change_color_achat'] = imgui.ImBool(false)
win_state['show_adm_stat'] = imgui.ImBool(false)
win_state['con_log'] = imgui.ImBool(true)

local cmds = {
	['/oskr %d']='/ban %d 30 Оскорбление родных',
	['/upom %d']='/mute %d 180 Упоминание родных',
	['/ch %d']='/ban %d 30 cheat',
	['/ne %d']='/pm %d Нарушений не обнаружено',
	['/na %d']='/pm %d Начинаю работу по вашей жалобе',
	['/gets %d']='/getstats %d',
	['/osk %d']='/mute %d 30 Оскорбление игроков',
	['/vred %d']='/ban %d 30 vred',
	['/ca %d']='/mute %d 10 caps',
	['/fl %d']='/mute %d 10 flood',
	['/neuv %d']='/mute %d 120 Неуважение к администрации',
	['/nead %d']='/mute %d 30 Неадекватное поведение',
	['/sk %d']='/jail %d 30 SpawnKill',
	['/tk %d']='/jail %d 30 TeamKill',
	['/zab %d']='/mute %d 60 Введение в заблуждение.',
        ['/mpj %d']='/jail %d 10 pomeha mp',
        ['/stor %d']='/mute %d 180 упоминание сторонних проектов.',
        ['/db %d']='/jail %d 20 db',
        ['/ukaz %d']='/mute %d 10 ukaz adm',
        ['/oskpr %d']='/ban %d 30 Оскорбление проекта',
        ['/noesc %d']='/kick %d afk w/o esc',
}

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
	"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
	"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
	"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
	"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
	"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
	"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
	"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
	"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
	"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
	"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
	"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
	"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
	"UtilityTrailer"}
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
	54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
	29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
	17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
	43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
	39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
	36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
	3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
	1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
	1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
	1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
	1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
	1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}


function SetStyle()
		imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		style.ScrollbarSize = 13.0
		style.ScrollbarRounding = 0
		style.ChildWindowRounding = 4.0
		colors[clr.PopupBg]										= ImVec4(0.08, 0.08, 0.08, 0.94)
		colors[clr.ComboBg]										= colors[clr.PopupBg]
		colors[clr.Button]										= ImVec4(0.26, 0.59, 0.98, 0.40)
		colors[clr.ButtonHovered]					    =	ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.ButtonActive]							= ImVec4(0.06, 0.53, 0.98, 1.00)
		colors[clr.TitleBg]										= ImVec4(0.04, 0.04, 0.04, 1.00)
		colors[clr.TitleBgActive]							= ImVec4(0.16, 0.29, 0.48, 0.51)
		colors[clr.TitleBgCollapsed]					= ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[clr.CloseButton]								= ImVec4(0.41, 0.41, 0.41, 0.50)
		colors[clr.CloseButtonHovered]				= ImVec4(0.98, 0.39, 0.36, 1.00)
		colors[clr.CloseButtonActive]					= ImVec4(0.98, 0.39, 0.36, 1.00)
		colors[clr.TextSelectedBg]						= ImVec4(0.26, 0.50, 0.98, 0.35)
		colors[clr.Text]											= ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.FrameBg]										= ImVec4(0.16, 0.29, 0.48, 0.54)
		colors[clr.FrameBgHovered]						= ImVec4(0.26, 0.59, 0.98, 0.40)
		colors[clr.FrameBgActivited]					= ImVec4(0.26, 0.59, 0.98, 0.67)
		colors[clr.MenuBarBg]									= ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[clr.ScrollbarBg]								= ImVec4(0.02, 0.02, 0.02, 0.53)
		colors[clr.ScrollbarGrab]							= ImVec4(0.31, 0.31, 0.31, 1.00)
		colors[clr.ScrollbarGrabHovered]			= ImVec4(0.41, 0.41, 0.41, 1.00)
		colors[clr.ScrollbarGrabActive]				= ImVec4(0.51, 0.51, 0.51, 1.00)
		colors[clr.CheckMark]									= ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.Header]										= ImVec4(0.26, 0.59, 0.98, 0.31)
		colors[clr.HeaderHovered]							= ImVec4(0.26, 0.59, 0.98, 0.80)
		colors[clr.HeaderActive]							= ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.SlideGrab]									= ImVec4(0.24, 0.52, 0.88, 1.00)
		colors[clr.SliderGrabActive]					= ImVec4(0.26, 0.59, 0.98, 1.00)
end

local directIni = "moonloader//settings.ini"

local mainIni = inicfg.load(nill, directIni)
--local stateIni = inicfg.save(mainIni, directIni)

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end


	sampRegisterChatCommand("atools", cmd_atools)
	sampRegisterChatCommand("optimal", cmd_optimal)
	sampRegisterChatCommand("test", cmd_test)
	sampRegisterChatCommand("infa", cmd_infa)
	sampRegisterChatCommand("ahelper", cmd_ahelper)
	sampRegisterChatCommand("ahelper2", cmd_ahelper2)
	sampRegisterChatCommand("getinfo", cmd_getinfo)
	sampRegisterChatCommand("setinfo", cmd_setinfo)
	sampRegisterChatCommand("check", cmd_check)
	sampRegisterChatCommand("upd", cmd_upd)
	sampRegisterChatCommand("versioninfo", cmd_versioninfo)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

	sampAddChatMessage("[Atools] {FFFFFF}Скрипт {0097FF}atools {FFFFFF}успешно {0097FF}загружен", 0x0097FF)
	if label == 0 then
		-- условие 1
		sampAddChatMessage("[Atools] {FFFFFF}Разработчик скрипта - {0097FF}Matthew Exfil", 0x0097FF)
	else
		-- условие 2
		sampAddChatMessage("[Atools] {FFFFFF}Разработчик скрипта - {0097FF}Matthew Exfil", 0x0097FF)
	end

		sampAddChatMessage("[Atools] {FFFFFF}Если вы заметили ошибку в {0097FF}работоспособности, {FFFFFF}обращайтесь к {0097FF}создателю скрипта", 0x0097FF)

		if sampGetCurrentServerAddress() == "46.105.73.83" then
			gameServer = "New Story"
			srv = 1
		else
			sampAddChatMessage("[Atools]: {FFFFFF}Скрипт не поддерживается на данном сервере", 0x0097FF)
			thisScript():unload()
			return
		end

		autoupdate("https://raw.githubusercontent.com/ExfiL123/atools/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://github.com/ExfiL123/atools/blob/main/atools.luac?raw=true")

		while true do
			wait(-1)
			imgui.Process = main_window_state.v
		end
	end

	function hook.onSendCommand(com)
		for key, value in pairs(cmds) do
			if com:find(key) then
				local arg = com:match('%d+')
				if arg ~= nil then
					com = value:format(arg)
					break
				end
			end
		end
		return { com }
	end

	function cmd_optimal(arg)
		if #arg == 0 then
			sampAddChatMessage("Привет, вы ввели команду, но не ввели аргумент :(", main_color)
		else
			sampAddChatMessage("Привет, вы ввели команду и ввели аргумент: {FFFFFF}" .. arg, main_color)
		end
	end

	function cmd_getinfo(arg)
		local mainIni = inicfg.load(nill, directIni)
		sampAddChatMessage(mainIni.settings.version, -1)
	end

	function cmd_upd(arg)
			sampShowDialog(1000, "A-tools: ", "{FFFFFF}Version 0.0.1: Пофикшен баг при котором после закрытия imgui-окна оставалась мышка.\n{FFFFFF}Добавлены команды быстрой выдачи наказаний.\nИсправлен баг с локализацией", "Закрыть", "", 0)
	end

	function cmd_versioninfo(arg)
			sampAddChatMessage("Получилось! Версия скрипта: {FFFF00}"..thisScript().version.."", -1)
	end

	function cmd_atools(arg)
		sampAddChatMessage("Привет, вы создали команду {FFFFFF}/atools", main_color)
	end

	function cmd_setinfo(arg)
		mainIni.settings.age = arg
		if inicfg.save(mainIni, directIni) then
			sampAddChatMessage("Успешно", -1)
		end
	end

	function cmd_ahelper(arg)
		main_window_state.v = not main_window_state.v
		imgui.Process = main_window_state.v
	end

	function cmd_ahelper2(arg)
		second_window_state.v = not second_window_state.v
		imgui.Process = second_window_state.v
	end

	function cmd_check(arg)
			sampAddChatMessage(checked_radio.v, -1)

			if checked_test.v then
				sampAddChatMessage("Галочка стоит", -1)
			end
	end

	function imgui.OnDrawFrame()

	if not main_window_state.v and not second_window_state.v then
			imgui.Process = false
	end

		local screenX, screenY = getScreenResolution()

		if main_window_state.v then

			imgui.SetNextWindowPos(imgui.ImVec2(screenX / 2, screenY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
			imgui.Begin("Atools for Revon Project",	main_window_state)

			imgui.InputText("Version 0.1 beta", text_buffer)
			x, y, z = getCharCoordinates(PLAYER_PED)
			imgui.Text(u8("Ваша позиция: X:" .. math.floor(x) .. " | Y: " .. math.floor(y) .. " | Z:" .. math.floor(z)))
			imgui.Text (text_buffer.v)
			if imgui.Button('Press me') then
				sampAddChatMessage(u8:decode(text_buffer.v), -1)
			end
			imgui.Separator()

			imgui.RadioButton("Button 1", checked_radio, 1)
			imgui.SameLine()
			imgui.RadioButton("Button 2", checked_radio, 2)
			imgui.SameLine()
			imgui.RadioButton("Button 3", checked_radio, 3)

			imgui.Separator()

			imgui.Checkbox("Checkbox1", checked_test)
			imgui.Checkbox("Checkbox2", checked_test_2)

			imgui.PushItemWidth(120)
			imgui.SetCursorPosY(250)
			imgui.SetCursorPosX(200)

			imgui.Combo(u8"Выбор профиля", combo_select, arr_str, #arr_str)

			imgui.End()
		end

		if second_window_state.v then
			imgui.SetNextWindowPos(imgui.ImVec2(screenX / 2, screenY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
				imgui.Begin("Hello", second_window_state)
				if imgui.Button('Test button') then
				sampAddChatMessage(u8:decode("I'm fine"), -1)
			end
				imgui.Text("Hii!!!")
				imgui.End()
		end
	end

	function autoupdate(json_url, prefix, url)
	  local dlstatus = require('moonloader').download_status
	  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	  if doesFileExist(json) then os.remove(json) end
	  downloadUrlToFile(json_url, json,
	    function(id, status, p1, p2)
	      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
	        if doesFileExist(json) then
	          local f = io.open(json, 'r')
	          if f then
	            local info = decodeJson(f:read('*a'))
	            updatelink = info.updateurl
	            updateversion = info.latest
	            f:close()
	            os.remove(json)
	            if updateversion ~= thisScript().version then
	              lua_thread.create(function(prefix)
	                local dlstatus = require('moonloader').download_status
	                local color = -1
	                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
	                wait(250)
	                downloadUrlToFile(updatelink, thisScript().path,
	                  function(id3, status1, p13, p23)
	                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
	                      print(string.format('Загружено %d из %d.', p13, p23))
	                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	                      print('Загрузка обновления завершена.')
	                      sampAddChatMessage((prefix..'Если всё пошло не по пизде, то всё получилось версия 0.0.2!'), color)
	                      goupdatestatus = true
	                      lua_thread.create(function() wait(500) thisScript():reload() end)
	                    end
	                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
	                      if goupdatestatus == nil then
	                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
	                        update = false
	                      end
	                    end
	                  end
	                )
	                end, prefix
	              )
	            else
	              update = false
	              print('v'..thisScript().version..': Обновление не требуется.')
	            end
	          end
	        else
	          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
	          update = false
	        end
	      end
	    end
	  )
	  while update ~= false do wait(100) end
	end
