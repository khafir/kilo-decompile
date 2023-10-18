ScriptName EnableOnActivate Extends ObjectReference Const
{ On activate, toggles enable/disable of linked refs }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Bool Property toggleEnabled = True Auto Const
{ Set LinkedRef to opposite enable/disable state. }
Bool Property onlyEnable = True Auto Const
{ If true this will only enable, if false only disable. Ignored if toggleEnabled }

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  If toggleEnabled ; #DEBUG_LINE_NO:10
    If Self.GetLinkedRef(None).IsEnabled() ; #DEBUG_LINE_NO:12
      Self.GetLinkedRef(None).Disable(False) ; #DEBUG_LINE_NO:13
    Else
      Self.GetLinkedRef(None).Enable(False) ; #DEBUG_LINE_NO:16
    EndIf
  ElseIf onlyEnable
    Self.GetLinkedRef(None).Enable(False) ; #DEBUG_LINE_NO:19
  Else
    Self.GetLinkedRef(None).Disable(False) ; #DEBUG_LINE_NO:21
  EndIf
EndEvent
