local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "koKR")

if not L then
	return
end


L["character"] = "캐릭터"
L["ilevel"] = "아이템 레벨"
L["keystone"] = "쐐기돌"

L["OpenVault"] = "금고 보기"

L["opt_lines_name"] = "줄 수"
L["opt_lines_desc"] = "표시할 줄 수"

L["opt_scale_name"] = "크기"
L["opt_scale_desc"] = "창 크기"

L["opt_column_order_name"] = "열 순서"
L["opt_column_order_desc"] = "열 순서를 변경하려면 항목을 끌어다 놓으세요."

L["opt_position_name"] = "위치"
L["opt_position_desc"] = "이 모듈의 열 위치 변경"

L["opt_minimap_name"] = "미니맵 버튼 숨기기"
L["opt_minimap_desc"] = "미니맵 버튼 표시 여부 토글"

L["ResultsText"] = "표시할 캐릭터가 없습니다"

-- tabs loot general
L["tabLoot_name"] = "%s 전리품"

L["tabLoot_greatVault"] = "대장장이의 금고"
L["tabLoot_upgradelvl"] = "업그레이드 레벨"

-- delves loot tab
L["delvesLoot_col1"] = "단계"
L["delvesLoot_col2"] = "풍부한" 

-- dungeon loot tab 
L["dungeonLoot_col1"] = "단계"
L["dungeonLoot_col2"] = "End of Dungeon"

-- raid loot tab 
L["raidLoot_col1"] = "난이도 및 유형"
L["raidLoot_bosses"] = "%s 우두머리"
L["raidLoot_Regular"] = "일반"
L["raidLoot_VeryRare"] = "매우 희귀"




-- no auto translate
-- gear tracks
L["gearTrack_Adventurer"] = "모험가"
L["gearTrack_Explorer"] = "탐험가"
L["gearTrack_Veteran"] = "노련가"
L["gearTrack_Champion"] = "챔피언"
L["gearTrack_Hero"] = "영웅"
L["gearTrack_Myth"] = "신화"


L["HELP_list_1"] = "Here you can access the settings to make a variety of adjustments."
L["HELP_list_2"] = "Click here to open the vault and check the status of your current character."
L["HELP_list_3"] = "Use this filter button to select which characters should be displayed and which should not. \n\nPlease note that only characters with the maximum level will be displayed."
L["HELP_list_4"] = "Here you can search for your character names."
L["HELP_list_5"] = "In this table, your characters will be displayed if they have reached the maximum level and have not been filtered out by you. \n\nPlease note that characters will only appear here if you have already logged in with them while the addon is active."


L["HELP_DelvesLoot_1"] = "Here, the number of %s you have is displayed. You need %s to open the chest at the end of a Bountiful Depth."
L["HELP_Loot_table"] = "This table shows the item level of the possible rewards. \n\nIf the number is red, the item level is lower than the equipment you are currently wearing."