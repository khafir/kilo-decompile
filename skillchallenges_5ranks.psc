ScriptName SkillChallenges_5Ranks Extends ReferenceAlias

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorValue Property SkillActorValue Auto Const
ReferenceAlias Property PlayerRef Auto Const
Float Property Rank_1_Goal Auto Const
Float Property Rank_2_Goal Auto Const
Float Property Rank_3_Goal Auto Const
Float Property Rank_4_Goal Auto Const

;-- Functions ---------------------------------------

Event OnKill(ObjectReference akVictim)
  If Self.GetOwningQuest().GetStage() == 100 ; #DEBUG_LINE_NO:13
    
  ElseIf Self.GetOwningQuest().GetStage() == 200 ; #DEBUG_LINE_NO:15
    
  ElseIf Self.GetOwningQuest().GetStage() == 300 ; #DEBUG_LINE_NO:17
    
  ElseIf Self.GetOwningQuest().GetStage() == 400 ; #DEBUG_LINE_NO:19
    
  EndIf
EndEvent
