local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "frFR")

if not L then
	return
end


L["character"] = "Personnage"
L["ilevel"] = "Niveau d'objet"
L["keystone"] = "Pierre angulaire"

L["OpenVault"] = "Voir le coffre"

L["opt_lines_name"] = "Lignes"
L["opt_lines_desc"] = "Nombre de lignes à afficher"

L["opt_scale_name"] = "Échelle"
L["opt_scale_desc"] = "Échelle de la fenêtre"

L["opt_column_order_name"] = "Ordre des colonnes"
L["opt_column_order_desc"] = "Glisser-déposer des éléments pour modifier l'ordre des colonnes"

L["opt_position_name"] = "Position"
L["opt_position_desc"] = "Changer la position de la colonne de ce module"

L["opt_minimap_name"] = "Cacher le bouton de la mini-carte"
L["opt_minimap_desc"] = "Activer ou désactiver la visibilité du bouton de la mini-carte"

L["ResultsText"] = "Aucun personnage à afficher"

-- tabs loot general
L["tabLoot_name"] = "Butin de %s"

L["tabLoot_greatVault"] = "Grand coffre"
L["tabLoot_upgradelvl"] = "Niveau de mise à niveau"

-- delves loot tab
L["delvesLoot_col1"] = "Niveau"
L["delvesLoot_col2"] = "Abondants" 

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Niveau"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "Difficulté et type"
L["raidLoot_bosses"] = "Boss %s"
L["raidLoot_Regular"] = "Régulier"
L["raidLoot_VeryRare"] = "Très rare"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "Aventurier"
L["gearTrack_Explorer"] = "Explorateur"
L["gearTrack_Veteran"] = "Vétéran"
L["gearTrack_Champion"] = "Champion"
L["gearTrack_Hero"] = "Héros"
L["gearTrack_Myth"] = "Mythe"


L["HELP_list_1"] = "Here you can access the settings to make a variety of adjustments."
L["HELP_list_2"] = "Click here to open the vault and check the status of your current character."
L["HELP_list_3"] = "Use this filter button to select which characters should be displayed and which should not. \n\nPlease note that only characters with the maximum level will be displayed."
L["HELP_list_4"] = "Here you can search for your character names."
L["HELP_list_5"] = "In this table, your characters will be displayed if they have reached the maximum level and have not been filtered out by you. \n\nPlease note that characters will only appear here if you have already logged in with them while the addon is active."


L["HELP_DelvesLoot_1"] = "Here, the number of %s you have is displayed. You need %s to open the chest at the end of a Bountiful Depth."
L["HELP_Loot_table"] = "This table shows the item level of the possible rewards. \n\nIf the number is red, the item level is lower than the equipment you are currently wearing."