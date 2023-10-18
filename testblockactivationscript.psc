ScriptName TestBlockActivationScript Extends Actor Const

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  ; Empty function
EndEvent

Event OnLoad()
  Self.BlockActivation(True, False) ; #DEBUG_LINE_NO:8
EndEvent
