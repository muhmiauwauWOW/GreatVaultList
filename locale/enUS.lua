local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "enUS", true)

if not L then
	return
end



L["Bindings_toggle_window"] = "Toggle window"

L["highestReward"] = ""
L["highestReward_tooltip_title"] = "Highest Reward"
L["highestReward_tooltip_desc"] = "Item Level of the highest unlocked great vault reward" 


L["character"] = "Character"
L["realm"] = "Realm"
L["ilevel"] = "iLevel"
L["keystone"] = "Keystone"


L["OpenVault"] = "View Vault"

L["opt_category_columns"] = "Columns"

L["opt_lines_name"] = "Lines"
L["opt_lines_desc"] = "Amount of lines to display"

L["opt_scale_name"] = "Scale"
L["opt_scale_desc"] = "Scale of the window"

L["opt_column_order_name"] = "Column Order"
L["opt_column_order_desc"] = "Drag and Drop items to change the order of the columns"

L["opt_position_name"] = "Position"
L["opt_position_desc"] = "Change the position of the Column of this Module"

L["opt_minimap_name"] = "Hide minimap button"
L["opt_minimap_desc"] = "Toggle visibibity of minimap button"


L["opt_ElvUiSkin_name"] = "Use ElvUi Skin"
L["opt_ElvUiSkin_desc"] = "Changing this settings need a reload to take effect"



-- Character Delete
L["opt_CharacterDelete_title"] = "Delete character data"

L["opt_CharacterDelete_slider_name"] = "Select character to delete"
L["opt_CharacterDelete_slider_desc"] = "Select a character to delete from the list."

L["opt_CharacterDelete_btn_name"] = "Delete selected character"

L["opt_CharacterDelete_confirm_text"] = "Are you sure you want to delete the selected character data? This action cannot be undone."






-- Columns
L["opt_columns_character_useClassColors_name"] = "Use Class Colors"
L["opt_columns_character_useClassColors_desc"] = "Use default or custom Class Colors for character name \n\nFor custom use the addon 'ColorTools Class Colors'."

L["opt_columns_character_showRealmName_name"] = "Show realm name"
L["opt_columns_character_showRealmName_desc"] = "Show the realm name of the character"


L["opt_columns_ilevel_floatNumber_name"] = "Float numbers"
L["opt_columns_ilevel_floatNumber_desc"] = "Control how many numbers should be displayed after the decimal point."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "Enable or disable this tab \n\nName: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "Show key info"
L["opt_tab_delvesLoot_showKeys_desc"] = "Toggle display of the key infomation"





L["ResultsText"] = "No characters to display"



-- tabs loot general
L["tabLoot_name"] = "%s Loot"

L["tabLoot_greatVault"] = "Great Vault"
L["tabLoot_upgradelvl"] = "Gear Level"

L["tabLoot_ilvl"] = "ilvl"

-- delves loot tab
L["delvesLoot_col1"] = "Tier"
L["delvesLoot_col2"] = "Bountiful" -- no auto translate

-- dungeon loot tab 
L["dungeonLoot_col1"] = "Level"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "Difficulty and Type"
L["raidLoot_bosses"] = "Bosses %s"
L["raidLoot_Regular"] = "Regular"
L["raidLoot_VeryRare"] = "Very Rare"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "Adventurer"
L["gearTrack_Explorer"] = "Explorer"
L["gearTrack_Veteran"] = "Veteran"
L["gearTrack_Champion"] = "Champion"
L["gearTrack_Hero"] = "Hero"
L["gearTrack_Myth"] = "Myth"



L["HELP_list_1"] = "Here you can access the settings to make a variety of adjustments."
L["HELP_list_2"] = "Click here to open the vault and check the status of your current character."
L["HELP_list_3"] = "Use this filter button to select which characters should be displayed and which should not. \n\nPlease note that only characters with the maximum level will be displayed."
L["HELP_list_4"] = "Here you can search for your character names."
L["HELP_list_5"] = "In this table, your characters will be displayed if they have reached the maximum level and have not been filtered out by you. \n\nPlease note that characters will only appear here if you have already logged in with them while the addon is active."


L["HELP_DelvesLoot_1"] = "Here, the number of %s you have is displayed. You need %s to open the chest at the end of a Bountiful Depth."
L["HELP_Loot_table"] = "This table shows the item level of the possible rewards. \n\nIf the number is red, the item level is lower than the equipment you are currently wearing."