ScriptName DelayedAmbushScript Extends Actor
{ script for actors who enable and come out of ambush
when their linked actor dies
(e.g. molerats) }

;-- Variables ---------------------------------------
Bool bInitialized = False
ObjectReference myAmbushChild

;-- Properties --------------------------------------
Keyword Property LinkAmbushChild Auto Const
Bool Property TopLevelActor = False Auto
{ Set this if the actor is the top actor }
Float Property fActorVariable = 1.0 Auto hidden
{ By default this property is set to 1. }
Float Property fActorVariableOnReset = 0.0 Auto hidden
Float Property fAggression = 2.0 Auto
{ By default this property is set to 2 (very aggressive).
0 - Unaggressive - will not initiate combat
1 - Aggressive - will attack enemies on sight
2 - Very Aggressive - Will attack enemies and neutrals on sight
3 - Frenzied - Will attack anyone else }
Float Property fAggressionOnReset = 0.0 Auto hidden
Keyword Property linkKeyword Auto Const
{ if this has a linkedRef with this keyword, we will activate it once when hit, activated, or on combat begin }
Bool Property ambushOnTrigger = True Auto Const
{ By default, this is set to false. Set to true if you want encounter to come out of ambush when player enters trigger }
ActorValue Property Aggression Auto Const
ActorValue Property Suspicious Auto Const

;-- Functions ---------------------------------------

Function Initialize()
  If !bInitialized ; #DEBUG_LINE_NO:15
    bInitialized = True ; #DEBUG_LINE_NO:16
    myAmbushChild = Self.GetLinkedRef(LinkAmbushChild) ; #DEBUG_LINE_NO:18
    If !myAmbushChild || !TopLevelActor ; #DEBUG_LINE_NO:19
      Self.Disable(False) ; #DEBUG_LINE_NO:20
    EndIf
  EndIf
EndFunction

Event OnDeath(ObjectReference akKiller)
  If myAmbushChild ; #DEBUG_LINE_NO:26
    myAmbushChild.Activate(myAmbushChild, False) ; #DEBUG_LINE_NO:27
  EndIf
EndEvent

Event onReset()
  Self.setValue(Suspicious, fActorVariableOnReset) ; #DEBUG_LINE_NO:38
  Self.setValue(Aggression, fAggressionOnReset) ; #DEBUG_LINE_NO:39
  Self.evaluatePackage(False) ; #DEBUG_LINE_NO:40
EndEvent

;-- State -------------------------------------------
State allDone
EndState

;-- State -------------------------------------------
Auto State waiting

  Event OnCombatStateChanged(ObjectReference actorRef, Int aeCombatState)
    If aeCombatState != 0
      Self.gotoState("allDone")
    EndIf
  EndEvent

  Event OnUnload()
    Self.UnregisterForAllHitEvents(None)
  EndEvent

  Event onActivate(ObjectReference triggerRef)
    Actor actorRef = triggerRef as Actor
    Self.Enable(False)
    If actorRef == Game.getPlayer() || ambushOnTrigger == True
      Self.gotoState("allDone")
    Else
      Self.setValue(Aggression, fAggression)
      Self.evaluatePackage(False)
    EndIf
  EndEvent

  Event onEndState(String asNewState)
    If Self.GetLinkedRef(None)
      Self.GetLinkedRef(None).Activate(Self as ObjectReference, False)
    EndIf
    If Self.getNthLinkedRef(1, None)
      Self.getNthLinkedRef(1, None).Activate(Self as ObjectReference, False)
    EndIf
    If Self.getNthLinkedRef(2, None)
      Self.getNthLinkedRef(2, None).Activate(Self as ObjectReference, False)
    EndIf
    Self.setValue(Suspicious, fActorVariable)
    Self.setValue(Aggression, fAggression)
    Self.evaluatePackage(False)
    If Self.GetLinkedRef(linkKeyword)
      Self.GetLinkedRef(linkKeyword).Activate(Self as ObjectReference, False)
    EndIf
  EndEvent

  Event onGetUp(ObjectReference myFurniture)
    Cell parentCell = Self.GetParentCell()
    If (parentCell as Bool && parentCell.IsAttached()) && Self.Is3DLoaded()
      Self.gotoState("allDone")
    EndIf
  EndEvent

  Event onHit(ObjectReference akTarget, ObjectReference akAggressor, Form akWeapon, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked, String asMaterialName)
    Self.gotoState("allDone")
  EndEvent

  Event OnLoad()
    Self.Initialize() ; #DEBUG_LINE_NO:51
    If Self.Is3DLoaded() ; #DEBUG_LINE_NO:52
      Self.RegisterForHitEvent(Self as ScriptObject, None, None, None, -1, -1, -1, -1, True) ; #DEBUG_LINE_NO:53
    EndIf
  EndEvent
EndState
