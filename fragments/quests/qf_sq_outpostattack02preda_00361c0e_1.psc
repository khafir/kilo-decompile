ScriptName Fragments:Quests:QF_SQ_OutpostAttack02Preda_00361C0E_1 Extends Quest Const hidden

;-- Functions ---------------------------------------

Function Fragment_Stage_0050_Item_00()
  Quest __temp = Self as Quest ; #DEBUG_LINE_NO:7
  sq_outpostattackscript kmyQuest = __temp as sq_outpostattackscript ; #DEBUG_LINE_NO:8
  kmyQuest.StartAttack(True) ; #DEBUG_LINE_NO:11
EndFunction
