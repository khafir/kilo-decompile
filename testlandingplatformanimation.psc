ScriptName TestLandingPlatformAnimation Extends ObjectReference
{ Test script for animating the landing platform in New Atlantis. }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property PlatformRef Auto Const
String Property sAnimEvent Auto Const
String Property sWakeAnimEvent Auto Const

;-- Functions ---------------------------------------

Event OnLoad()
  If !Self.IsDisabled() ; #DEBUG_LINE_NO:12
    If Self.Is3DLoaded() ; #DEBUG_LINE_NO:13
      If !Self.RegisterForAnimationEvent(Self as ObjectReference, sWakeAnimEvent) ; #DEBUG_LINE_NO:14
        
      EndIf
    EndIf
  EndIf
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
  If asEventName == sWakeAnimEvent ; #DEBUG_LINE_NO:24
    Self.RegisterForAnimationEvent(Self as ObjectReference, sAnimEvent) ; #DEBUG_LINE_NO:25
  EndIf
  If asEventName == sAnimEvent ; #DEBUG_LINE_NO:27
    PlatformRef.PlayAnimation("Stage2") ; #DEBUG_LINE_NO:28
  EndIf
EndEvent
