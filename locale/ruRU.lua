local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "ruRU")

if not L then
	return
end


L["character"] = "Персонаж"
L["ilevel"] = "ilvl"
L["keystone"] = "Ключ"

L["OpenVault"] = "Открыть Хранилище"

L["opt_lines_name"] = "Линии"
L["opt_lines_desc"] = "Количество строк для отображения"

L["opt_column_order_name"] = "Порядок столбцов"
L["opt_column_order_desc"] = "Перетащите элементы, чтобы изменить порядок столбцов"

L["opt_position_name"] = "Позиция"
L["opt_position_desc"] = "Изменить положение столбца этого модуля"

L["opt_minimap_name"] = "Скрыть кнопку мини-карты"
L["opt_minimap_desc"] = "Включить или выключить видимость кнопки мини-карты"


-- Columns
L["opt_columns_character_useClassColors_name"] = "Использовать цвета классов"
L["opt_columns_character_useClassColors_desc"] = "Использовать стандартные или пользовательские цвета классов для имени персонажа \n\nДля пользовательских цветов используйте аддон 'ColorTools Class Colors'."


L["opt_columns_ilevel_floatNumber_name"] = "Числа с плавающей точкой"
L["opt_columns_ilevel_floatNumber_desc"] = "Управление количеством цифр, отображаемых после десятичной точки."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Включить или отключить эту вкладку \n\nИмя: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "Показать информацию о ключе"
L["opt_tab_delvesLoot_showKeys_desc"] = "Переключить отображение информации о ключе"





L["ResultsText"] = "Нет персонажей для отображения"

-- tabs loot general
L["tabLoot_name"] = "Добыча %s"

L["tabLoot_greatVault"] = "Великий Хранилище"
L["tabLoot_upgradelvl"] = "Уровень улучшения"

-- delves loot tab
L["delvesLoot_col1"] = "Уровень"
L["delvesLoot_col2"] = "Обильный"

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Уровень"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "Сложность и тип"
L["raidLoot_bosses"] = "Боссы %s"
L["raidLoot_Regular"] = "Обычный"
L["raidLoot_VeryRare"] = "Очень редкий"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "Искатель приключений"
L["gearTrack_Explorer"] = "Исследователь"
L["gearTrack_Veteran"] = "Ветеран"
L["gearTrack_Champion"] = "Защитник"
L["gearTrack_Hero"] = "Герой"
L["gearTrack_Myth"] = "Легенда"


L["HELP_list_1"] = "Здесь вы можете получить доступ к настройкам, чтобы внести различные изменения."
L["HELP_list_2"] = "Нажмите здесь, чтобы открыть хранилище и проверить состояние вашего текущего персонажа."
L["HELP_list_3"] = "Используйте эту кнопку фильтра, чтобы выбрать, какие персонажи должны отображаться, а какие нет. \n\nОбратите внимание, что будут отображаться только персонажи с максимальным уровнем."
L["HELP_list_4"] = "Здесь вы можете искать имена своих персонажей."
L["HELP_list_5"] = "В этой таблице ваши персонажи будут отображаться, если они достигли максимального уровня и не были отфильтрованы вами. \n\nОбратите внимание, что персонажи будут отображаться здесь, только если вы уже вошли в систему с их помощью, пока аддон активен."


L["HELP_DelvesLoot_1"] = "Здесь отображается количество %s, которое у вас есть. Вам нужно %s, чтобы открыть сундук в конце Обильной Глубины."
L["HELP_Loot_table"] = "В этой таблице показан уровень предметов возможных наград. \n\nЕсли число красное, уровень предмета ниже, чем у экипировки, которую вы носите в данный момент."
