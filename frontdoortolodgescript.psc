ScriptName FrontDoorToLodgeScript Extends ObjectReference

;-- Variables ---------------------------------------
Int FailsafeTimerID = 5
Int FailsafeTimerLength = 15
inputenablelayer LodgeDoorLayer
Armor StorePlayerArmor
Armor StorePlayerSuit

;-- Properties --------------------------------------
Message Property TestFrontDoorLodgeMSG Auto Const mandatory
Bool Property LodgeFrontDoorOpen Auto
ActorValue Property PlayerUnityTimesEntered Auto Const mandatory
Idle Property IdleDoorWatch Auto Const mandatory
Armor Property Clothes_Chronomark_Mq101 Auto Const mandatory
Quest Property MQ101 Auto Const mandatory
Int Property MQ101LodgeStage = 1510 Auto Const
Message Property NotAllowedDuringCombat Auto Const mandatory

;-- Functions ---------------------------------------

Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
  ; Empty function
EndEvent

Function WatchAnimFinished()
  Self.GotoState("HasBeenTriggered") ; #DEBUG_LINE_NO:113
  Self.CancelTimer(FailsafeTimerID) ; #DEBUG_LINE_NO:114
  Actor PlayerREF = Game.GetPlayer() ; #DEBUG_LINE_NO:115
  LodgeDoorLayer = None ; #DEBUG_LINE_NO:116
  If StorePlayerArmor != None ; #DEBUG_LINE_NO:119
    PlayerREF.EquipItem(StorePlayerArmor as Form, False, True) ; #DEBUG_LINE_NO:120
  EndIf
  If StorePlayerSuit != None ; #DEBUG_LINE_NO:123
    PlayerREF.EquipItem(StorePlayerSuit as Form, False, True) ; #DEBUG_LINE_NO:124
  EndIf
  PlayerREF.RemoveItem(Clothes_Chronomark_Mq101 as Form, 1, True, None) ; #DEBUG_LINE_NO:127
  Self.BlockActivation(False, False) ; #DEBUG_LINE_NO:130
  LodgeFrontDoorOpen = True ; #DEBUG_LINE_NO:131
  Self.Activate(PlayerREF as ObjectReference, False) ; #DEBUG_LINE_NO:132
  Self.UnRegisterForRemoteEvent(PlayerREF as ScriptObject, "OnItemUnequipped") ; #DEBUG_LINE_NO:133
EndFunction

;-- State -------------------------------------------
State HasBeenActivated

  Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
    ; Empty function
  EndEvent

  Event OnActivate(ObjectReference akActionRef)
    ; Empty function
  EndEvent

  Event OnLoad()
    ; Empty function
  EndEvent

  Event OnTimer(Int aiTimerID)
    ; Empty function
  EndEvent
EndState

;-- State -------------------------------------------
Auto State waitingforPlayer

  Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
    Actor PlayerREF = Game.GetPlayer()
    If akSender == PlayerREF
      If StorePlayerArmor == None
        StorePlayerArmor = akBaseObject as Armor
      Else
        StorePlayerSuit = akBaseObject as Armor
      EndIf
    EndIf
  EndEvent

  Event OnActivate(ObjectReference akActionRef)
    Actor PlayerREF = Game.GetPlayer()
    If akActionRef == PlayerREF as ObjectReference
      If PlayerREF.IsInCombat() || Game.IsGuardPursuingPlayer()
        NotAllowedDuringCombat.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
      ElseIf LodgeFrontDoorOpen == False && PlayerREF.GetValue(PlayerUnityTimesEntered) == 0.0 && MQ101.GetStageDone(MQ101LodgeStage) == False && MQ101.IsCompleted() == False
        LodgeDoorLayer = inputenablelayer.Create()
        LodgeDoorLayer.DisablePlayerControls(True, True, True, True, False, True, True, False, True, True, False)
        Self.RegisterForRemoteEvent(PlayerREF as ScriptObject, "OnItemUnequipped")
        Self.RegisterForAnimationEvent(PlayerREF as ObjectReference, "Activate")
        Game.ForceFirstPerson()
        If PlayerREF.IsWeaponDrawn()
          PlayerREF.SheatheWeapon()
          Utility.Wait(2.0)
        EndIf
        Utility.Wait(0.100000001)
        PlayerREF.UnequipItemSlot(3)
        PlayerREF.UnequipItemSlot(8)
        PlayerREF.UnequipItemSlot(35)
        PlayerREF.EquipItem(Clothes_Chronomark_Mq101 as Form, False, True)
        Utility.Wait(0.100000001)
        PlayerREF.PlayIdle(IdleDoorWatch)
        Utility.Wait(7.0)
        Self.PlayAnimation("Play01")
        Self.StartTimer(FailsafeTimerLength as Float, FailsafeTimerID)
      Else
        Self.GotoState("HasBeenTriggered")
        Self.BlockActivation(False, False)
        LodgeFrontDoorOpen = True
        Self.Activate(akActionRef, False)
      EndIf
    EndIf
  EndEvent

  Event OnAnimationEvent(ObjectReference akSource, String asEventName)
    Actor PlayerREF = Game.GetPlayer()
    If asEventName == "Activate"
      Self.WatchAnimFinished()
    EndIf
  EndEvent

  Event OnTimer(Int aiTimerID)
    Self.WatchAnimFinished()
  EndEvent

  Event OnLoad()
    Actor PlayerREF = Game.GetPlayer() ; #DEBUG_LINE_NO:19
    If LodgeFrontDoorOpen == False && PlayerREF.GetValue(PlayerUnityTimesEntered) == 0.0 && MQ101.GetStageDone(MQ101LodgeStage) == False && MQ101.IsCompleted() == False ; #DEBUG_LINE_NO:20
      Self.BlockActivation(True, False) ; #DEBUG_LINE_NO:21
    Else
      Self.GotoState("HasBeenTriggered") ; #DEBUG_LINE_NO:23
    EndIf
  EndEvent
EndState
