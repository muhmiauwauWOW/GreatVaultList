local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "zhCN")

if not L then
	return
end


L["Bindings_toggle_window"] = "切换窗口"

L["highestReward_tooltip_title"] = "最高奖励"
L["highestReward_tooltip_desc"] = "已解锁的最高大秘境宝库奖励的物品等级" 



L["character"] = "角色"
L["realm"] = "服务器";
L["ilevel"] = "装备等级"
L["keystone"] = "大秘境钥匙"

L["OpenVault"] = "查看宝库"

L["opt_lines_name"] = "行数"
L["opt_lines_desc"] = "显示的行数"

L["opt_scale_name"] = "缩放"
L["opt_scale_desc"] = "窗口缩放"

L["opt_column_order_name"] = "列顺序"
L["opt_column_order_desc"] = "拖放项目以更改列的顺序"

L["opt_position_name"] = "位置"
L["opt_position_desc"] = "更改此模块列的位置"

L["opt_minimap_name"] = "隐藏小地图按钮"
L["opt_minimap_desc"] = "启用或禁用小地图按钮的可见性"


L["opt_ElvUiSkin_name"] = "使用ElvUI皮肤";
L["opt_ElvUiSkin_desc"] = "更改此设置需要重新加载才能生效";


-- Character Delete
L["opt_CharacterDelete_title"] = "删除角色数据";
L["opt_CharacterDelete_slider_name"] = "选择要删除的角色";
L["opt_CharacterDelete_slider_desc"] = "从列表中选择要删除的角色。";
L["opt_CharacterDelete_btn_name"] = "删除所选角色";
L["opt_CharacterDelete_confirm_text"] = "您确定要删除所选角色数据吗？此操作无法撤消。";


-- Columns
L["opt_columns_character_useClassColors_name"] = "使用职业颜色"
L["opt_columns_character_useClassColors_desc"] = "使用默认或自定义职业颜色显示角色名称 \n\n自定义颜色请使用 'ColorTools Class Colors' 插件。"


L["opt_columns_ilevel_floatNumber_name"] = "浮点数"
L["opt_columns_ilevel_floatNumber_desc"] = "控制小数点后显示的位数。"


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "启用或禁用此选项卡 \n\n名称: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "显示钥匙信息"
L["opt_tab_delvesLoot_showKeys_desc"] = "切换钥匙信息的显示"





L["ResultsText"] = "没有角色显示"


L["Tabs"] = "標籤"

-- tabs loot general
L["tabLoot_name"] = "%s 战利品"

L["tabLoot_greatVault"] = "大秘境宝库"
L["tabLoot_upgradelvl"] = "升级等级"

L["tabLoot_crests"] = "奖励的徽章"
L["tabLoot_crests_desc"] = "通过限时完成获得的徽章数量"

L["List"] = "List"

-- delves loot tab
L["delvesLoot_col1"] = "等级"
L["delvesLoot_col2"] = "丰厚"

-- dungeon loot tab 
L["dungeonLoot_col1"] = "等级"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "难度和类型"
L["raidLoot_bosses"] = "%s 首领"
L["raidLoot_Regular"] = "普通"
L["raidLoot_VeryRare"] = "极稀有"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "冒险者"
L["gearTrack_Explorer"] = "探索者"
L["gearTrack_Veteran"] = "老兵"
L["gearTrack_Champion"] = "勇士"
L["gearTrack_Hero"] = "英雄"
L["gearTrack_Myth"] = "神话"


L["HELP_list_1"] = "在这里，您可以访问设置以进行各种调整。"
L["HELP_list_2"] = "单击此处打开宝库并检查当前角色的状态。"
L["HELP_list_3"] = "使用此筛选器按钮选择应显示哪些角色以及不应显示哪些角色。\n\n请注意，仅显示等级最高的角色。"
L["HELP_list_4"] = "您可以在此处搜索角色名称。"
L["HELP_list_5"] = "如果您的角色已达到最高等级且未被您过滤掉，则会在此表中显示。\n\n请注意，只有在插件处于活动状态时已登录的角色才会在此处显示。"


L["HELP_DelvesLoot_1"] = "此处显示您拥有的 %s 数量。您需要 %s 才能在丰厚深渊的尽头打开宝箱。"
L["HELP_Loot_table"] = "此表显示了可能奖励的物品等级。\n\n如果数字为红色，则物品等级低于您当前装备的等级。"
