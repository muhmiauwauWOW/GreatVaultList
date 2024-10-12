local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "deDE")

if not L then
	return
end


L["Bindings_toggle_window"] = "Fenster umschalten"

L["highestReward_tooltip_title"] = "Höchste Belohnung" 
L["highestReward_tooltip_desc"] = "Gegenstandsstufe der höchsten freigeschalteten Belohnung der großen Schatzkammer"


L["character"] = "Charakter"
L["ilevel"] = "iLevel"
L["keystone"] = "Schlüsselstein"

L["OpenVault"] = "Schatzkammer ansehen"

L["opt_category_columns"] = "Spalten"

L["opt_lines_name"] = "Zeilen"
L["opt_lines_desc"] = "Anzahl der anzuzeigenden Zeilen"

L["opt_scale_name"] = "Skalierung"
L["opt_scale_desc"] = "Skalierung des Fensters"

L["opt_column_order_name"] = "Spaltenreihenfolge"
L["opt_column_order_desc"] = "Ziehen Sie Elemente per Drag & Drop, um die Reihenfolge der Spalten zu ändern"


L["opt_position_name"] = "Position"
L["opt_position_desc"] = "Ändern der Position der Spalte dieses Moduls"

L["opt_minimap_name"] = "Minimap Button ausblenden"
L["opt_minimap_desc"] = "Ein- oder Ausblenden des Minikarte-Buttons"


-- Columns
L["opt_columns_character_useClassColors_name"] = "Klassenfarben verwenden"
L["opt_columns_character_useClassColors_desc"] = "Verwende Standard- oder benutzerdefinierte Klassenfarben für den Charakternamen \n\nFür benutzerdefinierte Farben verwende das Addon 'ColorTools Class Colors'."


L["opt_columns_ilevel_floatNumber_name"] = "Fließkommazahlen"
L["opt_columns_ilevel_floatNumber_desc"] = "Steuert, wie viele Zahlen nach dem Dezimalpunkt angezeigt werden sollen."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Aktiviert oder deaktiviert diesen Tab \n\nName: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "Schlüsselinfo anzeigen"
L["opt_tab_delvesLoot_showKeys_desc"] = "Anzeige der Schlüsselinformationen umschalten"





L["ResultsText"] = "Keine Charaktere zum anzeigen"


-- tabs loot general
L["tabLoot_name"] = "%s Beute"

L["tabLoot_greatVault"] = "Große Schatzkammer"
L["tabLoot_upgradelvl"] = "Rüstungsstufe"


-- delves loot tab
L["delvesLoot_col1"] = "Stufe"
L["delvesLoot_col2"] = "Großzügige"

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Stufe"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "Schwierigkeit und Typ"
L["raidLoot_bosses"] = "Bosse %s"
L["raidLoot_Regular"] = "Regelmäßig"
L["raidLoot_VeryRare"] = "Sehr selten"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "Abenteurer"
L["gearTrack_Explorer"] = "Forscher"
L["gearTrack_Veteran"] = "Veteran"
L["gearTrack_Champion"] = "Champion"
L["gearTrack_Hero"] = "Held"
L["gearTrack_Myth"] = "Mythos"


L["HELP_list_1"] = "Hier kannst du die Einstellungen aufrufen, um verschiedene Anpassungen vorzunehmen."
L["HELP_list_2"] = "Klicke hier, um die Vault zu öffnen und den Status deines aktuellen Charakters zu überprüfen."
L["HELP_list_3"] = "Verwende diese Filter-Schaltfläche, um auszuwählen, welche Charaktere angezeigt werden sollen und welche nicht. \n\nBitte beachte, dass nur Charaktere mit dem maximalen Level angezeigt werden."
L["HELP_list_4"] = "Hier kannst du nach deinen Charakternamen suchen."
L["HELP_list_5"] = "In dieser Tabelle werden deine Charaktere angezeigt, wenn sie das maximale Level erreicht haben und nicht von dir herausgefiltert wurden. \n\nBitte beachte, dass Charaktere nur hier angezeigt werden, wenn du dich bereits mit ihnen eingeloggt hast, während das Addon aktiv ist."


L["HELP_DelvesLoot_1"] = "Hier wird die Anzahl der %s angezeigt die du besitzt. %s werden um die Kiste am Ende einer Großzügigen Tiefe zu öffnen."
L["HELP_Loot_table"] = "Diese Tabelle zeigt die ItemLevel der möglichen Belohnungen an. \n\nIst die Zahl rot ist das ItemLevel geringer als die Ausrüstung die ihr gerade trägt."