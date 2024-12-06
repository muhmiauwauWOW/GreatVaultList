local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "zhTW")

if not L then
	return
end

L["Bindings_toggle_window"] = "切換視窗"

L["highestReward_tooltip_title"] = "最高獎勵"
L["highestReward_tooltip_desc"] = "已解鎖的最高大秘境寶庫獎勵的物品等級" 


L["character"] = "角色"
L["realm"] = "伺服器"
L["ilevel"] = "裝備等級"
L["keystone"] = "大秘境鑰石"

L["OpenVault"] = "查看寶庫"

L["opt_lines_name"] = "行數"
L["opt_lines_desc"] = "顯示的行數"

L["opt_scale_name"] = "縮放"
L["opt_scale_desc"] = "視窗縮放"

L["opt_column_order_name"] = "欄位順序"
L["opt_column_order_desc"] = "拖放項目以變更欄位的順序"

L["opt_position_name"] = "位置"
L["opt_position_desc"] = "變更此模組欄的位置"

L["opt_minimap_name"] = "隱藏小地圖按鈕"
L["opt_minimap_desc"] = "啟用或停用小地圖按鈕的顯示"


L["opt_ElvUiSkin_name"] = "使用ElvUI介面";
L["opt_ElvUiSkin_desc"] = "更改此設定需要重新載入才能生效";


-- Character Delete
L["opt_CharacterDelete_title"] = "刪除角色資料";
L["opt_CharacterDelete_slider_name"] = "選擇要刪除的角色";
L["opt_CharacterDelete_slider_desc"] = "從列表中選擇要刪除的角色。";
L["opt_CharacterDelete_btn_name"] = "刪除已選角色";
L["opt_CharacterDelete_confirm_text"] = "您確定要刪除所選角色的資料嗎？此動作無法復原。";


-- Columns
L["opt_columns_character_useClassColors_name"] = "使用職業顏色"
L["opt_columns_character_useClassColors_desc"] = "使用預設或自訂職業顏色顯示角色名稱 \n\n自訂顏色請使用 'ColorTools Class Colors' 插件。"


L["opt_columns_ilevel_floatNumber_name"] = "浮點數"
L["opt_columns_ilevel_floatNumber_desc"] = "控制小數點後顯示的位數。"


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "啟用或停用此分頁 \n\n名稱: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "顯示鑰匙資訊"
L["opt_tab_delvesLoot_showKeys_desc"] = "切換鑰匙資訊的顯示"





L["ResultsText"] = "沒有角色顯示"

-- tabs loot general
L["tabLoot_name"] = "%s 戰利品"

L["tabLoot_greatVault"] = "大秘境寶庫"
L["tabLoot_upgradelvl"] = "升級等級"

L["List"] = "List"

-- delves loot tab
L["delvesLoot_col1"] = "等級"
L["delvesLoot_col2"] = "豐富"

-- dungeon loot tab 
L["dungeonLoot_col1"] = "等級"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "難度和類型"
L["raidLoot_bosses"] = "%s BOSS"
L["raidLoot_Regular"] = "普通"
L["raidLoot_VeryRare"] = "極稀有"





-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "冒险者"
L["gearTrack_Explorer"] = "探索者"
L["gearTrack_Veteran"] = "老兵"
L["gearTrack_Champion"] = "勇士"
L["gearTrack_Hero"] = "英雄"
L["gearTrack_Myth"] = "神话"




L["HELP_list_1"] = "在這裡，您可以訪問設置以進行各種調整。"
L["HELP_list_2"] = "單擊此處打開寶庫並檢查當前角色的狀態。"
L["HELP_list_3"] = "使用此篩選器按鈕選擇應顯示哪些角色以及不應顯示哪些角色。\n\n請注意，僅顯示等級最高的角色。"
L["HELP_list_4"] = "您可以在此處搜索角色名稱。"
L["HELP_list_5"] = "如果您的角色已達到最高等級且未被您過濾掉，則會在此表中顯示。\n\n請注意，只有在插件處於活動狀態時已登錄的角色才會在此處顯示。"


L["HELP_DelvesLoot_1"] = "此處顯示您擁有的 %s 數量。您需要 %s 才能在豐厚深淵的盡頭打開寶箱。"
L["HELP_Loot_table"] = "此表顯示了可能獎勵的物品等級。\n\n如果數字為紅色，則物品等級低於您當前裝備的等級。"
