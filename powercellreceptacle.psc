ScriptName PowerCellReceptacle Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
MiscObject Property Power_Cell Auto Const
Message Property PowerCellRequiredMessage Auto Const mandatory
Message Property PowerCellActiveMessage Auto Const mandatory
Message Property PowerCellMissingMessage Auto Const
Message Property PowerCellFullMessage Auto Const
wwiseevent Property SoundPowerUp Auto Const mandatory
ActorValue Property PowerCellReceptacleAV Auto Const

;-- Functions ---------------------------------------

Function InsertPowerCell(ObjectReference akActionRef)
  akActionRef.RemoveItem(Power_Cell as Form, 1, False, None) ; #DEBUG_LINE_NO:46
  Self.BlockActivation(False, False) ; #DEBUG_LINE_NO:47
  Self.Activate(Self as ObjectReference, False) ; #DEBUG_LINE_NO:48
  Self.BlockActivation(True, False) ; #DEBUG_LINE_NO:49
  Self.SetActivateTextOverride(PowerCellActiveMessage) ; #DEBUG_LINE_NO:50
  SoundPowerUp.Play(akActionRef, None, None) ; #DEBUG_LINE_NO:51
  Self.GotoState("HasPowerCell") ; #DEBUG_LINE_NO:52
  If PowerCellReceptacleAV ; #DEBUG_LINE_NO:53
    Self.SetValue(PowerCellReceptacleAV, 1.0) ; #DEBUG_LINE_NO:54
  EndIf
EndFunction

;-- State -------------------------------------------
State Busy
EndState

;-- State -------------------------------------------
State HasPowerCell

  Event OnActivate(ObjectReference akActionRef)
    PowerCellFullMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:37
  EndEvent
EndState

;-- State -------------------------------------------
Auto State NoPowerCell

  Event OnActivate(ObjectReference akActionRef)
    Self.GotoState("Busy")
    If akActionRef == Game.getplayer() as ObjectReference
      If akActionRef.GetItemCount(Power_Cell as Form) >= 1
        Self.InsertPowerCell(akActionRef)
      Else
        PowerCellMissingMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Self.GotoState("NoPowerCell")
      EndIf
    EndIf
  EndEvent

  Event OnLoad()
    Self.SetActivateTextOverride(PowerCellRequiredMessage) ; #DEBUG_LINE_NO:15
    Self.BlockActivation(True, False) ; #DEBUG_LINE_NO:16
  EndEvent
EndState
