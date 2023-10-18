ScriptName ATMScript Extends ObjectReference
{ script for hackable ATM script }

;-- Variables ---------------------------------------
Int tempStealCount = 0

;-- Guards ------------------------------------------
;*** WARNING: Guard declaration syntax is EXPERIMENTAL, subject to change
Guard stealGuard

;-- Properties --------------------------------------
Keyword Property ATMLink_Door Auto Const mandatory
{ keyword for linked ref to fake locked door to hack }
Keyword Property ATMLink_Container Auto Const mandatory
{ keyword for linked ref to container holding credits }

;-- Functions ---------------------------------------

Event ObjectReference.OnLockStateChanged(ObjectReference akSource)
  If akSource.IsLocked() ; #DEBUG_LINE_NO:36
    Self.GotoState("locked")
  EndIf
EndEvent

Function StealFromATM()
  tempStealCount += 1 ; #DEBUG_LINE_NO:58
  Guard stealGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:60
    If Self.GetState() == "locked" ; #DEBUG_LINE_NO:61
      ObjectReference myDoor = Self.GetLinkedRef(ATMLink_Door) ; #DEBUG_LINE_NO:63
      If myDoor as Bool && myDoor.IsLocked() == False ; #DEBUG_LINE_NO:65
        Self.GotoState("hacked") ; #DEBUG_LINE_NO:67
        ObjectReference myContainer = Self.GetLinkedRef(ATMLink_Container) ; #DEBUG_LINE_NO:70
        If myContainer ; #DEBUG_LINE_NO:71
          MiscObject credits = Game.GetCredits() ; #DEBUG_LINE_NO:72
          Int creditsAmount = myContainer.GetItemCount(credits as Form) ; #DEBUG_LINE_NO:73
          myContainer.SendStealAlarm(Game.GetPlayer()) ; #DEBUG_LINE_NO:76
          myContainer.RemoveAllItems(Game.GetPlayer() as ObjectReference, True, False) ; #DEBUG_LINE_NO:78
          ObjectReference stealRef = myContainer.PlaceAtMe(credits as Form, creditsAmount, False, False, True, None, None, True) ; #DEBUG_LINE_NO:80
          stealRef.SetFactionOwner(myContainer.GetFactionOwner(), False) ; #DEBUG_LINE_NO:82
          stealRef.SendStealAlarm(Game.GetPlayer()) ; #DEBUG_LINE_NO:83
          stealRef.Disable(False) ; #DEBUG_LINE_NO:84
        EndIf
      EndIf
    EndIf
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Function SetupLockedState()
  ObjectReference myDoor = Self.GetLinkedRef(ATMLink_Door) ; #DEBUG_LINE_NO:93
  If myDoor as Bool && myDoor.IsLocked() ; #DEBUG_LINE_NO:95
    Self.RegisterForRemoteEvent(myDoor as ScriptObject, "OnLockStateChanged") ; #DEBUG_LINE_NO:96
  Else
    Self.GotoState("hacked") ; #DEBUG_LINE_NO:100
  EndIf
  Self.BlockActivation(True, False) ; #DEBUG_LINE_NO:102
EndFunction

;-- State -------------------------------------------
State hacked

  Event OnBeginState(String asOldState)
    Self.BlockActivation(True, True) ; #DEBUG_LINE_NO:43
  EndEvent
EndState

;-- State -------------------------------------------
Auto State locked

  Event ObjectReference.OnLockStateChanged(ObjectReference akSource)
    Self.StealFromATM()
  EndEvent

  Event OnActivate(ObjectReference akActionRef)
    If akActionRef == Game.GetPlayer() as ObjectReference
      ObjectReference myDoor = Self.GetLinkedRef(ATMLink_Door)
      If myDoor
        If myDoor.IsLocked()
          myDoor.Activate(akActionRef, False)
        Else
          Self.GotoState("hacked")
        EndIf
      EndIf
    EndIf
  EndEvent

  Event OnBeginState(String asOldState)
    Self.SetupLockedState()
  EndEvent

  Event OnInit()
    Self.SetupLockedState() ; #DEBUG_LINE_NO:12
  EndEvent
EndState
