local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "zhCN")

if not L then
	return
end


L["character"] = "角色"
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

L["ResultsText"] = "没有角色显示"

-- tabs loot general
L["tabLoot_name"] = "%s 战利品"

L["tabLoot_greatVault"] = "大秘境宝库"
L["tabLoot_upgradelvl"] = "升级等级"

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
