script_name("Reloader")
script_author("Cosmo")

function main()
	repeat wait(0) until isSampAvailable()
	while true do
		if isKeyDown(0x11) and isKeyJustPressed(0x52) then -- \\ CTRL + R
			if isKeyDown(0x10) then -- \\ SHIFT
				show_dialog()
			else
				printString("~y~~h~Reloading all scripts..", 2000)
				reloadScripts()
			end
		end

		local result, button, list, input = sampHasDialogRespond(0)
		if result and scripts ~= nil then
			if button == 1 then
				if list == 0 then
					printString("~y~Reloading all scripts..", 2000)
					reloadScripts()
				else
					local s = scripts[list]
					if s ~= nil then
						if s.is_loaded then
							printString(("~y~Reloading %s.."):format(s.filename), 2000)
							s.handle:reload()
						else
							printString(("~g~~h~~h~Loading %s.."):format(s.filename), 2000)
							script.load(s.filename)
						end
					else
						printString("~r~Loading error!", 2000)
					end
				end
				addOneOffSound(0, 0, 0, 1059)
				scripts = nil
			elseif button == 0 then
				scripts = nil
			end
		end
		wait(0)
	end
end

function show_dialog()
	scripts = {}

	local search, filename = findFirstFile(getWorkingDirectory() .. "\\*.lua")
	while search and filename do
		table.insert(scripts, {
			is_loaded = false,
			filename = filename,
			handle = nil
		})

		for _, scr in ipairs(script.list()) do
			if scr.filename == filename then
				scripts[#scripts].is_loaded = true
				scripts[#scripts].handle = scr
				break
			end
		end

		filename = findNextFile(search)
		if filename == nil then
			findClose(search)
			break
		end
	end
	
	local text = "{77FF77}Полная перезагрузка\t\n"  
	for i, data in ipairs(scripts) do
		local is_loaded = data.is_loaded and "{70AA70}[ Загружен ]" or "{AA7070}[ Не загружен ]"
		text = string.format("%s{EEEEEE}%s\t%s", text, data.filename, is_loaded)
		if i ~= #scripts then
			text = text .. "\n"
		end
	end

	sampShowDialog(0, "Список скриптов", text, "Выбрать", "Отмена", 4)
end