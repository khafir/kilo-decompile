ScriptName FX:ExplosionOnAnimEvent Extends ObjectReference Const
{ Place an explosion on an animation event }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
String[] Property sAnimEventList Auto Const mandatory
Explosion Property PlacedExplosion Auto Const mandatory

;-- Functions ---------------------------------------

Function PlaceExplosion(Explosion PlacedExplosionRef)
  Self.PlaceAtMe(PlacedExplosionRef as Form, 1, False, False, True, None, None, True) ; #DEBUG_LINE_NO:9
EndFunction

Event OnLoad()
  If Self.Is3DLoaded() ; #DEBUG_LINE_NO:13
    Int I = 0 ; #DEBUG_LINE_NO:14
    While I < sAnimEventList.Length ; #DEBUG_LINE_NO:15
      Self.RegisterForAnimationEvent(Self as ObjectReference, sAnimEventList[I]) ; #DEBUG_LINE_NO:16
      I += 1 ; #DEBUG_LINE_NO:17
    EndWhile
  EndIf
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
  If sAnimEventList.find(asEventName, 0) < 0 ; #DEBUG_LINE_NO:23
    Return  ; #DEBUG_LINE_NO:24
  Else
    Self.PlaceExplosion(PlacedExplosion) ; #DEBUG_LINE_NO:26
  EndIf
EndEvent

Event OnUnLoad()
  Int I = 0 ; #DEBUG_LINE_NO:31
  While I < sAnimEventList.Length ; #DEBUG_LINE_NO:32
    Self.UnRegisterForAnimationEvent(Self as ObjectReference, sAnimEventList[I]) ; #DEBUG_LINE_NO:33
    I += 1 ; #DEBUG_LINE_NO:34
  EndWhile
EndEvent
