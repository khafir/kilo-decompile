ScriptName RL036MusicControl Extends ObjectReference Const

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property RL036_EnableMusic Auto Const
Keyword Property LinkedRefKeywordMusic Auto Const
Keyword Property LinkedRefKeywordEnemies Auto Const

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  If Self.GetLinkedRef(LinkedRefKeywordEnemies).IsDisabled() ; #DEBUG_LINE_NO:9
    Self.GetLinkedRef(LinkedRefKeywordEnemies).Enable(False) ; #DEBUG_LINE_NO:10
  EndIf
  If Self.GetLinkedRef(LinkedRefKeywordMusic).IsDisabled() ; #DEBUG_LINE_NO:13
    Self.GetLinkedRef(LinkedRefKeywordMusic).Enable(False) ; #DEBUG_LINE_NO:14
  Else
    Self.GetLinkedRef(LinkedRefKeywordMusic).Disable(False) ; #DEBUG_LINE_NO:16
  EndIf
EndEvent
