ScriptName TrapBase Extends ObjectReference conditional
{ base script for all trap scripts }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Group TrapBaseData
  Keyword Property TrapStartInactiveKeyword Auto Const mandatory
  { keyword to indicate if the trap should start in the inactive state }
  Bool Property bActive = True Auto conditional hidden
  Bool Property bDisarmed = False Auto conditional hidden
EndGroup


;-- Functions ---------------------------------------

Function BecomeActive()
  ; Empty function
EndFunction

Function BecomeInactive()
  ; Empty function
EndFunction

Function HandleOnLoad()
  ; Empty function
EndFunction

Function HandleOnUnload()
  ; Empty function
EndFunction

Event OnCellLoad()
  Self.HandleOnLoad() ; #DEBUG_LINE_NO:14
  If bDisarmed ; #DEBUG_LINE_NO:15
    Self.GotoState("unloaded") ; #DEBUG_LINE_NO:16
  ElseIf Self.HasKeyword(TrapStartInactiveKeyword) ; #DEBUG_LINE_NO:18
    Self.GotoState("Inactive") ; #DEBUG_LINE_NO:19
  Else
    Self.GotoState("Active") ; #DEBUG_LINE_NO:21
  EndIf
EndEvent

Event OnUnload()
  Self.HandleOnUnload() ; #DEBUG_LINE_NO:27
  Self.GotoState("unloaded") ; #DEBUG_LINE_NO:28
EndEvent

Function SetActive(Bool bSetActive)
  ; Empty function
EndFunction

Function Disarm()
  bDisarmed = True ; #DEBUG_LINE_NO:94
  Self.GotoState("unloaded") ; #DEBUG_LINE_NO:95
EndFunction

;-- State -------------------------------------------
State Active

  Event OnActivate(ObjectReference akActionRef)
    Self.SetActive(False)
  EndEvent

  Function SetActive(Bool bSetActive)
    If bSetActive == False
      Self.GotoState("Inactive")
    EndIf
  EndFunction

  Event OnBeginState(String asOldState)
    bActive = True ; #DEBUG_LINE_NO:39
    Self.BecomeActive() ; #DEBUG_LINE_NO:40
  EndEvent
EndState

;-- State -------------------------------------------
State Inactive

  Event OnActivate(ObjectReference akActionRef)
    Self.SetActive(True)
  EndEvent

  Function SetActive(Bool bSetActive)
    If bSetActive
      Self.GotoState("Active")
    EndIf
  EndFunction

  Event OnBeginState(String asOldState)
    bActive = False ; #DEBUG_LINE_NO:59
    Self.BecomeInactive() ; #DEBUG_LINE_NO:60
  EndEvent
EndState

;-- State -------------------------------------------
Auto State unloaded

  Function SetActive(Bool bSetActive)
    ; Empty function
  EndFunction
EndState
