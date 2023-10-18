ScriptName OpenStarMapOnActivate Extends ObjectReference
{ Opens the Star Map when this activator is used. }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property FailedActivationMessage Auto Const mandatory

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  Self.GoToState("Busy") ; #DEBUG_LINE_NO:7
  If Game.IsMenuControlsEnabled() ; #DEBUG_LINE_NO:8
    Game.ShowGalaxyStarMapMenu() ; #DEBUG_LINE_NO:9
  Else
    FailedActivationMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:11
  EndIf
  Self.GoToState("") ; #DEBUG_LINE_NO:13
EndEvent

;-- State -------------------------------------------
State Busy

  Event OnActivate(ObjectReference akActionRef)
    ; Empty function
  EndEvent
EndState
