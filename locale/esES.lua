local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "esES")

if not L then
	return
end


L["character"] = "Personaje"
L["ilevel"] = "Nivel de objeto"
L["keystone"] = "Piedra angular"

L["OpenVault"] = "Ver bóveda"

L["opt_category_columns"] = "Columnas"

L["opt_lines_name"] = "Líneas"
L["opt_lines_desc"] = "Cantidad de líneas a mostrar"

L["opt_scale_name"] = "Escala"
L["opt_scale_desc"] = "Escala de la ventana"

L["opt_column_order_name"] = "Column Order"
L["opt_column_order_desc"] = "Drag and Drop items to change the order of the columns"

L["opt_position_name"] = "Posición"
L["opt_position_desc"] = "Cambiar la posición de la columna de este módulo"

L["opt_minimap_name"] = "Ocultar botón del minimapa"
L["opt_minimap_desc"] = "Activar o desactivar la visibilidad del botón del minimapa"

L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Activar esta pestaña"

L["opt_tab_delvesLoot_showKeys_name"] = "Mostrar información clave"
L["opt_tab_delvesLoot_showKeys_desc"] = "Alternar la visualización de la información clave"


-- Columns
L["opt_columns_character_useClassColors_name"] = "Usar colores de clase"
L["opt_columns_character_useClassColors_desc"] = "Usar colores de clase predeterminados o personalizados para el nombre del personaje \n\nPara personalizar, usa el addon 'ColorTools Class Colors'."


L["opt_columns_ilevel_floatNumber_name"] = "Números decimales"
L["opt_columns_ilevel_floatNumber_desc"] = "Controla cuántos números se deben mostrar después del punto decimal."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Activar o desactivar esta pestaña \n\nNombre: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "Mostrar información clave"
L["opt_tab_delvesLoot_showKeys_desc"] = "Alternar la visualización de la información clave"





L["ResultsText"] = "No hay personajes que mostrar"

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




L["HELP_list_1"] = "Aquí puedes acceder a la configuración para realizar una variedad de ajustes."
L["HELP_list_2"] = "Haz clic aquí para abrir la cámara y comprobar el estado de tu personaje actual."
L["HELP_list_3"] = "Utiliza este botón de filtro para seleccionar qué personajes deben mostrarse y cuáles no. \n\nTen en cuenta que solo se mostrarán los personajes con el nivel máximo."
L["HELP_list_4"] = "Aquí puedes buscar los nombres de tus personajes."
L["HELP_list_5"] = "En esta tabla, tus personajes se mostrarán si han alcanzado el nivel máximo y no han sido filtrados por ti. \n\nTen en cuenta que los personajes solo aparecerán aquí si ya has iniciado sesión con ellos mientras el addon está activo."


L["HELP_DelvesLoot_1"] = "Aquí se muestra el número de %s que tienes. Necesitas %s para abrir el cofre al final de una Profundidad Abundante."
L["HELP_Loot_table"] = "Esta tabla muestra el nivel de objeto de las posibles recompensas. \n\nSi el número es rojo, el nivel de objeto es inferior al del equipo que llevas actualmente."
