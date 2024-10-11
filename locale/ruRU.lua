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


L["HELP_list_1"] = "Here you can access the settings to make a variety of adjustments."
L["HELP_list_2"] = "Click here to open the vault and check the status of your current character."
L["HELP_list_3"] = "Use this filter button to select which characters should be displayed and which should not. \n\nPlease note that only characters with the maximum level will be displayed."
L["HELP_list_4"] = "Here you can search for your character names."
L["HELP_list_5"] = "In this table, your characters will be displayed if they have reached the maximum level and have not been filtered out by you. \n\nPlease note that characters will only appear here if you have already logged in with them while the addon is active."


L["HELP_DelvesLoot_1"] = "Here, the number of %s you have is displayed. You need %s to open the chest at the end of a Bountiful Depth."
L["HELP_Loot_table"] = "This table shows the item level of the possible rewards. \n\nIf the number is red, the item level is lower than the equipment you are currently wearing."