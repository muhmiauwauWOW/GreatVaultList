local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "ruRU")

if not L then
	return
end


L["Bindings_toggle_window"] = "Открыть/закрыть окно"

L["highestReward"] = ""
L["highestReward_tooltip_title"] = "Наивысшая награда"
L["highestReward_tooltip_desc"] = "Уровень предмета наивысшей разблокированной награды Великого Хранилища" 

L["class"] = "Класс"
L["character"] = "Персонаж"
L["realm"] = "Игровой мир"
L["ilevel"] = "ilvl"
L["keystone"] = "Ключ"
L["highestReward"] = "Наивысшая награда"

L["vaultStatus"] = "Невостребованные награды"

L["OpenVault"] = "Открыть Хранилище"

L["opt_category_columns"] = "Столбцы"

L["opt_lines_name"] = "Линии"
L["opt_lines_desc"] = "Количество строк для отображения"

L["opt_scale_name"] = "Масштаб"
L["opt_scale_desc"] = "Масштаб окна"

L["opt_column_order_name"] = "Порядок столбцов"
L["opt_column_order_desc"] = "Перетащите элементы, чтобы изменить порядок столбцов"

L["opt_position_name"] = "Позиция"
L["opt_position_desc"] = "Изменить положение столбца этого модуля"

L["opt_minimap_name"] = "Скрыть кнопку миникарты"
L["opt_minimap_desc"] = "Вкл/выкл кнопку миникарты"

L["opt_ElvUiSkin_name"] = "Использовать скин ElvUI"
L["opt_ElvUiSkin_desc"] = "Для вступления изменений в силу необходима перезагрузка интерфейса"


-- Character Delete
L["opt_CharacterDelete_title"] = "Удалить данные персонажа"

L["opt_CharacterDelete_slider_name"] = "Выберите персонажа для удаления"
L["opt_CharacterDelete_slider_desc"] = "Выберите персонажа для удаления из списка."

L["opt_CharacterDelete_btn_name"] = "Удалить выбранного персонажа"

L["opt_CharacterDelete_confirm_text"] = "Вы уверены, что хотите удалить выбранные данные персонажа? Это действие не может быть отменено."


-- Columns
L["opt_columns_character_useClassColors_name"] = "Использовать цвета классов"
L["opt_columns_character_useClassColors_desc"] = "Использовать стандартные или пользовательские цвета классов для имени персонажа \n\nДля пользовательских цветов используйте аддон 'ColorTools Class Colors'."

L["opt_columns_character_showRealmName_name"] = "Показать название игрового мира"
L["opt_columns_character_showRealmName_desc"] = "Показать название игрового мира персонажа"

L["opt_columns_ilevel_floatNumber_name"] = "Числа с плавающей точкой"
L["opt_columns_ilevel_floatNumber_desc"] = "Управление количеством цифр, отображаемых после десятичной точки."

-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Включить или отключить эту вкладку \n\nИмя: %s\nID: %s"

L["opt_tab_delvesLoot_showKeys_name"] = "Показать информацию о ключе"
L["opt_tab_delvesLoot_showKeys_desc"] = "Вкл/выкл отображение информации о ключе"

L["ResultsText"] = "Нет персонажей для отображения"

-- tabs loot general
L["tabLoot_name"] = "Добыча %s"

L["tabLoot_greatVault"] = "Великое Хранилище"
L["tabLoot_upgradelvl"] = "Уровень улучшения"

L["tabLoot_ilvl"] = "ilvl"

L["List"] = "Персонажи"

-- delves loot tab
L["delvesLoot_col1"] = "Уровень"
L["delvesLoot_col2"] = "Щедрый"

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Уровень"
L["dungeonLoot_col2"] = "Конец подземелья"

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

L["HELP_list_1"] = "Здесь Вы можете получить доступ к настройкам, чтобы внести различные изменения."
L["HELP_list_2"] = "Нажмите здесь, чтобы открыть Хранилище и проверить состояние Вашего текущего персонажа."
L["HELP_list_3"] = "Используйте эту кнопку фильтра, чтобы выбрать, какие персонажи должны отображаться, а какие нет. \n\nОбратите внимание, что будут отображаться только персонажи с максимальным уровнем."
L["HELP_list_4"] = "Здесь Вы можете искать имена своих персонажей."
L["HELP_list_5"] = "В этой таблице Ваши персонажи будут отображаться, если они достигли максимального уровня и не были отфильтрованы Вами. \n\nОбратите внимание, что персонажи будут отображаться здесь, только если Вы уже вошли в систему с их помощью, пока аддон активен."

L["HELP_DelvesLoot_1"] = "Здесь отображается количество %s, которое у Вас есть. Вам нужно %s, чтобы открыть сундук в конце Многообещающих Вылазок."
L["HELP_Loot_table"] = "В этой таблице показан уровень предметов возможных наград. \n\nЕсли число красное, уровень предмета ниже, чем у экипировки, которую Вы носите в данный момент."
