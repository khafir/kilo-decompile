ScriptName LandingPadBlastShields Extends ObjectReference
{ Handle the opening and closing of the landing pad blast shields. }

;-- Variables ---------------------------------------
Int BeforeOpenTimerID = 3 Const
Int OpenToCloseTimerID = 2 Const

;-- Properties --------------------------------------
Float Property BaseAnimSpeed = 1.0 Auto Const
Float Property AnimSpeedVariance = 0.0 Auto Const
Float Property BeforeOpenTimer = 12.0 Auto Const
Float Property OpenToCloseTimer = 13.0 Auto Const
Keyword Property LinkedRef_LandingPadShield_EnableMarker Auto Const mandatory
String Property blastShieldOpen = "Play01" Auto Const
String Property blastShieldClose = "Play02" Auto Const
String Property blastShieldInstantClose = "StateA_Idle" Auto Const

;-- Functions ---------------------------------------

Event SpaceshipReference.OnShipTakeOff(spaceshipreference akSender, Bool abComplete)
  ; Empty function
EndEvent

Function ActivateBlastShields(Bool isLanding)
  Self.GoToState("Busy") ; #DEBUG_LINE_NO:18
  If isLanding ; #DEBUG_LINE_NO:19
    Self.StartTimer(BeforeOpenTimer, BeforeOpenTimerID) ; #DEBUG_LINE_NO:20
  Else
    Self.StartTimer(0.0, BeforeOpenTimerID) ; #DEBUG_LINE_NO:22
  EndIf
EndFunction

Event OnCellLoad()
  Self.AnimateBlastShields(blastShieldInstantClose) ; #DEBUG_LINE_NO:33
EndEvent

Function AnimateBlastShields(String animationString)
  ObjectReference[] linkedrefs = Self.GetLinkedRefChain(None, 100) ; #DEBUG_LINE_NO:93
  Int index = 0 ; #DEBUG_LINE_NO:94
  While index < linkedrefs.Length ; #DEBUG_LINE_NO:95
    ObjectReference blastShield = linkedrefs[index] ; #DEBUG_LINE_NO:96
    Self.AnimateBlastShield(blastShield, animationString) ; #DEBUG_LINE_NO:97
    index += 1 ; #DEBUG_LINE_NO:98
  EndWhile
EndFunction

Function AnimateBlastShield(ObjectReference blastShield, String animationString)
  If blastShield as Bool && blastShield.Is3DLoaded() ; #DEBUG_LINE_NO:103
    blastShield.SetAnimationVariableFloat("AnimSpeed", BaseAnimSpeed + Utility.RandomFloat(-AnimSpeedVariance, AnimSpeedVariance)) ; #DEBUG_LINE_NO:105
    blastShield.PlayAnimation(animationString) ; #DEBUG_LINE_NO:107
  EndIf
EndFunction

;-- State -------------------------------------------
State Busy

  Event SpaceshipReference.OnShipTakeOff(spaceshipreference akSender, Bool abComplete)
    ; Empty function
  EndEvent

  Event OnTimer(Int aiTimerID)
    If aiTimerID == OpenToCloseTimerID
      Self.AnimateBlastShields(blastShieldClose)
      ObjectReference EnableMarker = Self.GetLinkedRef(LinkedRef_LandingPadShield_EnableMarker)
      If EnableMarker
        EnableMarker.Disable(False)
      EndIf
      Self.GoToState("Idle")
    ElseIf aiTimerID == BeforeOpenTimerID
      Self.AnimateBlastShields(blastShieldOpen)
      ObjectReference enablemarker = Self.GetLinkedRef(LinkedRef_LandingPadShield_EnableMarker)
      If enablemarker
        enablemarker.Enable(False)
      EndIf
      Self.StartTimer(OpenToCloseTimer, OpenToCloseTimerID)
    EndIf
  EndEvent

  Event OnUnload()
    Self.CancelTimer(OpenToCloseTimerID) ; #DEBUG_LINE_NO:63
    Self.CancelTimer(BeforeOpenTimerID) ; #DEBUG_LINE_NO:64
    Self.GoToState("Idle") ; #DEBUG_LINE_NO:65
  EndEvent
EndState

;-- State -------------------------------------------
Auto State Idle

  Event SpaceshipReference.OnShipTakeOff(spaceshipreference akSender, Bool abComplete)
    If !abComplete
      Self.ActivateBlastShields(False)
      Self.UnregisterForRemoteEvent(akSender as ScriptObject, "OnShipTakeOff")
    EndIf
  EndEvent

  Event OnActivate(ObjectReference akActionRef)
    ObjectReference[] linkedrefs = Self.GetLinkedRefChain(None, 100) ; #DEBUG_LINE_NO:40
    If linkedrefs.Length > 0 ; #DEBUG_LINE_NO:41
      spaceshipreference spaceshipRef = akActionRef as spaceshipreference ; #DEBUG_LINE_NO:42
      If spaceshipRef ; #DEBUG_LINE_NO:43
        Self.RegisterForRemoteEvent(spaceshipRef as ScriptObject, "OnShipTakeOff") ; #DEBUG_LINE_NO:44
        Self.ActivateBlastShields(True) ; #DEBUG_LINE_NO:45
      EndIf
    EndIf
  EndEvent
EndState
