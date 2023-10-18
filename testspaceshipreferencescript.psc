ScriptName TestSpaceshipReferenceScript Extends SpaceshipReference Const

;-- Functions ---------------------------------------

Event OnCombatStateChanged(ObjectReference akTarget, Int aeCombatState)
  ; Empty function
EndEvent

Event OnDestroyed(ObjectReference akDestroyer)
  ; Empty function
EndEvent

Event OnUnload()
  ; Empty function
EndEvent

Function TestFaction(Faction akFaction)
  ; Empty function
EndFunction

Function TestLanding()
  ; Empty function
EndFunction

Function TestDocking()
  SpaceshipReference dockedShip = Self.GetFirstDockedShip() ; #DEBUG_LINE_NO:25
  If dockedShip != None ; #DEBUG_LINE_NO:26
    
  EndIf
EndFunction

String Function GetPartName(Int aiPartIndex)
  If aiPartIndex == 0 ; #DEBUG_LINE_NO:37
    Return "weapon" ; #DEBUG_LINE_NO:38
  ElseIf aiPartIndex == 1 ; #DEBUG_LINE_NO:39
    Return "engine" ; #DEBUG_LINE_NO:40
  ElseIf aiPartIndex == 2 ; #DEBUG_LINE_NO:41
    Return "shields" ; #DEBUG_LINE_NO:42
  ElseIf aiPartIndex == 3 ; #DEBUG_LINE_NO:43
    Return "grav drive" ; #DEBUG_LINE_NO:44
  EndIf
EndFunction

Function TestPowerAllocation()
  Int partType = 0 ; #DEBUG_LINE_NO:54
  While partType < 4 ; #DEBUG_LINE_NO:55
    Int partCount = Self.GetPartCount(partType) ; #DEBUG_LINE_NO:56
    Int partIndex = 0 ; #DEBUG_LINE_NO:57
    While partIndex < partCount ; #DEBUG_LINE_NO:58
      Int power = Self.GetPartPower(partType, partIndex) ; #DEBUG_LINE_NO:59
      partIndex += 1 ; #DEBUG_LINE_NO:61
    EndWhile
    partType += 1 ; #DEBUG_LINE_NO:63
  EndWhile
EndFunction
