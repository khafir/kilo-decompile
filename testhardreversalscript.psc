ScriptName TestHardReversalScript Extends ObjectReference
{ sets an actor value on actor that enters }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorValue Property myAV Auto Const mandatory
{ First Actor Value to set. }
Float Property myAV_Value Auto Const mandatory
{ First Actor Value's new value. }

;-- Functions ---------------------------------------

Event OnTriggerEnter(ObjectReference akActionRef)
  If akActionRef != Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:13
    Actor myActor = akActionRef as Actor ; #DEBUG_LINE_NO:14
    If myActor.getValue(myAV) == 0.0 ; #DEBUG_LINE_NO:15
      myActor.SetValue(myAV, 1.0) ; #DEBUG_LINE_NO:16
    Else
      myActor.SetValue(myAV, 0.0) ; #DEBUG_LINE_NO:18
    EndIf
    myActor.EvaluatePackage(False) ; #DEBUG_LINE_NO:20
  EndIf
EndEvent
