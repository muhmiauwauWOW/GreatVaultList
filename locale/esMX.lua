local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "esMX")

if not L then
	return
end


L["character"] = "Personaje"
L["ilevel"] = "Nivel de objeto"
L["keystone"] = "Piedra angular"

L["OpenVault"] = "Ver bóveda"

L["opt_lines_name"] = "Líneas"
L["opt_lines_desc"] = "Cantidad de líneas a mostrar"

L["opt_scale_name"] = "Escala"
L["opt_scale_desc"] = "Escala de la ventana"

L["opt_column_order_name"] = "Orden de las columnas"
L["opt_column_order_desc"] = "Arrastra y suelta elementos para cambiar el orden de las columnas"

L["opt_position_name"] = "Posición"
L["opt_position_desc"] = "Cambiar la posición de la columna de este módulo"

L["opt_minimap_name"] = "Ocultar botón del minimapa"
L["opt_minimap_desc"] = "Activar o desactivar la visibilidad del botón del minimapa"

L["ResultsText"] = "No hay personajes para mostrar"

-- tabs loot general
L["tabLoot_name"] = "Botín de %s"

L["tabLoot_greatVault"] = "Gran Bóveda"
L["tabLoot_upgradelvl"] = "Nivel de mejora"

-- delves loot tab
L["delvesLoot_col1"] = "Nivel"
L["delvesLoot_col2"] = "pródigas" 

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Nivel"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "Dificultad y tipo"
L["raidLoot_bosses"] = "Jefes %s"
L["raidLoot_Regular"] = "Regular"
L["raidLoot_VeryRare"] = "Muy raro"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "Aventurero"
L["gearTrack_Explorer"] = "Expedicionario"
L["gearTrack_Veteran"] = "Veterano"
L["gearTrack_Champion"] = "Campeón"
L["gearTrack_Hero"] = "Héroe"
L["gearTrack_Myth"] = "Mito"



L["HELP_list_1"] = "Here you can access the settings to make a variety of adjustments."
L["HELP_list_2"] = "Click here to open the vault and check the status of your current character."
L["HELP_list_3"] = "Use this filter button to select which characters should be displayed and which should not. \n\nPlease note that only characters with the maximum level will be displayed."
L["HELP_list_4"] = "Here you can search for your character names."
L["HELP_list_5"] = "In this table, your characters will be displayed if they have reached the maximum level and have not been filtered out by you. \n\nPlease note that characters will only appear here if you have already logged in with them while the addon is active."


L["HELP_DelvesLoot_1"] = "Here, the number of %s you have is displayed. You need %s to open the chest at the end of a Bountiful Depth."
L["HELP_Loot_table"] = "This table shows the item level of the possible rewards. \n\nIf the number is red, the item level is lower than the equipment you are currently wearing."