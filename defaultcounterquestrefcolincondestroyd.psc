ScriptName DefaultCounterQuestRefColIncOnDestroyD Extends DefaultCounterQuestRefColIncOnDestroy default
{ Once this ALIAS dies it increments the counter on its Quest's DefaultCounterQuestA script. }

;-- Functions ---------------------------------------

Function Increment(ObjectReference akSenderRef)
  If MaintainTargetValue ; #DEBUG_LINE_NO:5
    (Self.GetOwningQuest() as defaultcounterquestd).TargetValue = Self.GetCount() ; #DEBUG_LINE_NO:6
  EndIf
  (Self.GetOwningQuest() as defaultcounterquestd).Increment() ; #DEBUG_LINE_NO:8
  If RemoveWhenDestroyed ; #DEBUG_LINE_NO:9
    Self.RemoveRef(akSenderRef) ; #DEBUG_LINE_NO:10
    If MaintainTargetValue ; #DEBUG_LINE_NO:11
      (Self.GetOwningQuest() as defaultcounterquestd).Decrement() ; #DEBUG_LINE_NO:12
    EndIf
  EndIf
  If Self.GetCount() <= TargetRemainingCount && RemainingStage > -1 ; #DEBUG_LINE_NO:15
    Self.GetOwningQuest().SetStage(RemainingStage) ; #DEBUG_LINE_NO:16
  EndIf
EndFunction
