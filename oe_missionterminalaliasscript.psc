ScriptName OE_MissionTerminalAliasScript Extends ReferenceAlias

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  If akActionRef == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:9
    Self.GotoState("Done") ; #DEBUG_LINE_NO:10
    (Self.GetOwningQuest() as oe_missionterminalquestscript).PlayerActivateMissionTerminal() ; #DEBUG_LINE_NO:11
  EndIf
EndEvent

;-- State -------------------------------------------
State Done

  Event OnActivate(ObjectReference akActionRef)
    ; Empty function
  EndEvent
EndState
