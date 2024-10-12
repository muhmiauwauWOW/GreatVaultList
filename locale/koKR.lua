local L = LibStub("AceLocale-3.0"):NewLocale("GreatVaultList", "koKR")

if not L then
	return
end


L["Bindings_toggle_window"] = "창 전환"

L["highestReward_tooltip_title"] = "최고 보상"
L["highestReward_tooltip_desc"] = "잠금 해제된 가장 높은 대장장이의 금고 보상의 아이템 레벨" 


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


-- Columns
L["opt_columns_character_useClassColors_name"] = "직업 색상 사용"
L["opt_columns_character_useClassColors_desc"] = "캐릭터 이름에 기본 또는 사용자 지정 직업 색상을 사용합니다. \n\n사용자 지정의 경우 'ColorTools Class Colors' 애드온을 사용하세요."


L["opt_columns_ilevel_floatNumber_name"] = "소수점 이하 자릿수"
L["opt_columns_ilevel_floatNumber_desc"] = "소수점 뒤에 표시할 숫자의 수를 제어합니다."


-- Tabs
L["opt_tab_actve_name"] = "%s"
L["opt_tab_actve_desc"] = "이 탭을 활성화하거나 비활성화합니다. \n\n이름: %s\nID: %s"


L["opt_tab_delvesLoot_showKeys_name"] = "열쇠 정보 표시"
L["opt_tab_delvesLoot_showKeys_desc"] = "열쇠 정보 표시 여부 토글"





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


L["HELP_list_1"] = "여기에서 다양한 조정을 위한 설정에 액세스할 수 있습니다."
L["HELP_list_2"] = "여기를 클릭하여 금고를 열고 현재 캐릭터의 상태를 확인하세요."
L["HELP_list_3"] = "이 필터 버튼을 사용하여 표시할 캐릭터와 표시하지 않을 캐릭터를 선택하세요. \n\n최대 레벨의 캐릭터만 표시됩니다."
L["HELP_list_4"] = "여기에서 캐릭터 이름을 검색할 수 있습니다."
L["HELP_list_5"] = "이 표에는 최대 레벨에 도달했으며 필터링되지 않은 캐릭터가 표시됩니다. \n\n애드온이 활성화된 동안 이미 로그인한 캐릭터만 여기에 나타납니다."


L["HELP_DelvesLoot_1"] = "여기에 보유한 %s의 수가 표시됩니다. 풍요로운 깊이의 끝에 있는 상자를 열려면 %s가 필요합니다."
L["HELP_Loot_table"] = "이 표는 가능한 보상의 아이템 레벨을 보여줍니다. \n\n숫자가 빨간색이면 아이템 레벨이 현재 착용하고 있는 장비보다 낮습니다."
