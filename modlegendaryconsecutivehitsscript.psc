ScriptName ModLegendaryConsecutiveHitsScript Extends LegendaryMagicEffectEventListenScript

;-- Variables ---------------------------------------
Int ConsecutiveHitCount
Actor LastConsecutiveHitActor

;-- Functions ---------------------------------------

Function HandleEvent(MagicEffect EventMagicEffect, Actor TargetActor, Actor CasterActor, Int EventType, Var EventArg1, Var EventArg2, Var EventArg3)
  ActorValue ModLegendaryWeaponConsecutiveHits = EventArg2 as ActorValue ; #DEBUG_LINE_NO:27
  Actor myActor = Self.GetTargetActor() ; #DEBUG_LINE_NO:29
  If myActor ; #DEBUG_LINE_NO:30
    If EventType == LegendaryItemQuest.iEventType_Starting || EventType == LegendaryItemQuest.iEventType_OnHit ; #DEBUG_LINE_NO:31
      If TargetActor == LastConsecutiveHitActor ; #DEBUG_LINE_NO:33
        myActor.SetValue(ModLegendaryWeaponConsecutiveHits, myActor.GetValue(ModLegendaryWeaponConsecutiveHits) + 1.0) ; #DEBUG_LINE_NO:36
      Else
        myActor.SetValue(ModLegendaryWeaponConsecutiveHits, 0.0) ; #DEBUG_LINE_NO:41
      EndIf
      LastConsecutiveHitActor = TargetActor ; #DEBUG_LINE_NO:44
    ElseIf EventType == LegendaryItemQuest.iEventType_Finishing ; #DEBUG_LINE_NO:46
      If TargetActor == LastConsecutiveHitActor ; #DEBUG_LINE_NO:47
        myActor.SetValue(ModLegendaryWeaponConsecutiveHits, 0.0) ; #DEBUG_LINE_NO:50
      EndIf
    EndIf
  EndIf
EndFunction
