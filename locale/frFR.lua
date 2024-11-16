local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "frFR")

if not L then
	return
end

L["Bindings_toggle_window"] = "Basculer la fenêtre"

L["highestReward_tooltip_title"] = "Récompense la plus élevée"
L["highestReward_tooltip_desc"] = "Niveau d'objet de la meilleure récompense de coffre-fort débloquée"


L["character"] = "Personnage"
L["realm"] = "Royaume";
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


L["opt_ElvUiSkin_name"] = "Utiliser le thème ElvUI";
L["opt_ElvUiSkin_desc"] = "Un rechargement est nécessaire pour que les modifications prennent effet.";


-- Character Delete
L["opt_CharacterDelete_title"] = "Supprimer les données du personnage";
L["opt_CharacterDelete_slider_name"] = "Sélectionner le personnage à supprimer";
L["opt_CharacterDelete_slider_desc"] = "Sélectionnez un personnage dans la liste pour le supprimer.";
L["opt_CharacterDelete_btn_name"] = "Supprimer le personnage sélectionné";
L["opt_CharacterDelete_confirm_text"] = "Êtes-vous sûr de vouloir supprimer les données du personnage sélectionné ? Cette action est irréversible.";


-- Columns
L["opt_columns_character_useClassColors_name"] = "Utiliser les couleurs de classe"
L["opt_columns_character_useClassColors_desc"] = "Utiliser les couleurs de classe par défaut ou personnalisées pour le nom du personnage \n\nPour la personnalisation, utiliser l'addon 'ColorTools Class Colors'."


L["opt_columns_ilevel_floatNumber_name"] = "Nombres à virgule flottante"
L["opt_columns_ilevel_floatNumber_desc"] = "Contrôler le nombre de chiffres à afficher après la virgule."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Activer ou désactiver cet onglet \n\nNom : %s\nID : %s"


L["opt_tab_delvesLoot_showKeys_name"] = "Afficher les informations sur les clés"
L["opt_tab_delvesLoot_showKeys_desc"] = "Activer/désactiver l'affichage des informations sur les clés"





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


L["HELP_list_1"] = "Ici, vous pouvez accéder aux paramètres pour effectuer divers ajustements."
L["HELP_list_2"] = "Cliquez ici pour ouvrir le coffre-fort et vérifier l'état de votre personnage actuel."
L["HELP_list_3"] = "Utilisez ce bouton de filtre pour sélectionner les personnages à afficher et ceux à ne pas afficher. \n\nVeuillez noter que seuls les personnages ayant atteint le niveau maximum seront affichés."
L["HELP_list_4"] = "Ici, vous pouvez rechercher les noms de vos personnages."
L["HELP_list_5"] = "Dans ce tableau, vos personnages seront affichés s'ils ont atteint le niveau maximum et n'ont pas été filtrés par vous. \n\nVeuillez noter que les personnages n'apparaîtront ici que si vous vous êtes déjà connecté avec eux pendant que l'addon est actif."


L["HELP_DelvesLoot_1"] = "Ici, le nombre de %s que vous possédez est affiché. Vous avez besoin de %s pour ouvrir le coffre à la fin d'une Profondeur Généreuse."
L["HELP_Loot_table"] = "Ce tableau affiche le niveau d'objet des récompenses possibles. \n\nSi le nombre est rouge, le niveau d'objet est inférieur à celui de l'équipement que vous portez actuellement."
