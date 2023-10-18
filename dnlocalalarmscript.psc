ScriptName DNLocalAlarmScript Extends ObjectReference
{ Script for a localized alarm system that wakes linked robots and turrets. }

;-- Variables ---------------------------------------
Int CONST_AlarmState_Armed = 0 Const
Int CONST_AlarmState_Disarmed = 1 Const
Int CONST_AlarmState_Triggered = 2 Const
Int CONST_CombatState_IsInCombat = 1 Const
Int alarmSFXID = -1

;-- Properties --------------------------------------
Group OptionalProperties
  Quest Property AlarmQuest Auto Const
  Int Property AlarmPrereqStage = -1 Auto Const
  Int Property AlarmTurnOffStage = -1 Auto Const
  Int Property AlarmStageToSet = -1 Auto Const
  Float Property TargetTriggerDelayMin = 0.0 Auto Const
  Float Property TargetTriggerDelayMax = 1.0 Auto Const
  Bool Property ShouldSkipAlarmSFX = False Auto Const
EndGroup

Group AutofillProperties
  Keyword Property DNLocalAlarmSourceLinkKeyword Auto Const mandatory
  Keyword Property DNLocalAlarmTargetLinkKeyword Auto Const mandatory
  wwiseevent Property AlarmSound Auto Const
EndGroup

Int Property AlarmState Auto conditional hidden

;-- Functions ---------------------------------------

Event OnTimer(Int timerID)
  ; Empty function
EndEvent

Event Actor.OnCombatStateChanged(Actor akSource, ObjectReference akTarget, Int aeCombatState)
  ; Empty function
EndEvent

Event OnGainLoS(ObjectReference akViewer, ObjectReference akTarget)
  ; Empty function
EndEvent

Event ObjectReference.OnTriggerEnter(ObjectReference akSource, ObjectReference akActionRef)
  ; Empty function
EndEvent

Function Arm()
  If AlarmQuest == None || !AlarmQuest.GetStageDone(AlarmTurnOffStage) ; #DEBUG_LINE_NO:93
    Self.GoToState("Armed") ; #DEBUG_LINE_NO:94
    Self.SetAlarmSourceObjectState(Self.GetLinkedRefChain(DNLocalAlarmSourceLinkKeyword, 100), True) ; #DEBUG_LINE_NO:95
    Self.SetAlarmSourceObjectState(Self.GetRefsLinkedToMe(DNLocalAlarmSourceLinkKeyword, None), True) ; #DEBUG_LINE_NO:96
  EndIf
EndFunction

Function TriggerAlarm()
  Self.TryToTriggerAlarm(None) ; #DEBUG_LINE_NO:101
EndFunction

Function TryToTriggerAlarm(Actor akSource)
  If AlarmQuest == None || (AlarmPrereqStage < 0 || AlarmQuest.GetStageDone(AlarmPrereqStage)) && (AlarmTurnOffStage < 0 || !AlarmQuest.GetStageDone(AlarmTurnOffStage)) ; #DEBUG_LINE_NO:105
    If akSource == None || !akSource.IsDead() && akSource.GetCombatState() == CONST_CombatState_IsInCombat && akSource.HasDetectionLOS(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:106
      Self.GoToState("Triggered") ; #DEBUG_LINE_NO:108
      Self.Private_TriggerAlarm(akSource) ; #DEBUG_LINE_NO:109
    EndIf
  EndIf
  If Self.GetState() == "Busy" ; #DEBUG_LINE_NO:112
    Self.GoToState("Armed") ; #DEBUG_LINE_NO:114
  EndIf
EndFunction

Function Disarm()
  Self.GoToState("Disarmed") ; #DEBUG_LINE_NO:119
  Self.SetAlarmSourceObjectState(Self.GetLinkedRefChain(DNLocalAlarmSourceLinkKeyword, 100), False) ; #DEBUG_LINE_NO:120
  Self.SetAlarmSourceObjectState(Self.GetRefsLinkedToMe(DNLocalAlarmSourceLinkKeyword, None), False) ; #DEBUG_LINE_NO:121
EndFunction

Function SetAlarmSourceObjectState(ObjectReference[] sources, Bool isArmed)
  Actor player = Game.GetPlayer() ; #DEBUG_LINE_NO:130
  Int I = 0 ; #DEBUG_LINE_NO:131
  While I < sources.Length ; #DEBUG_LINE_NO:132
    Actor sourceAsActor = sources[I] as Actor ; #DEBUG_LINE_NO:133
    If sourceAsActor != None ; #DEBUG_LINE_NO:134
      Self.RegisterForRemoteEvent(sourceAsActor as ScriptObject, "OnCombatStateChanged") ; #DEBUG_LINE_NO:135
      Self.RegisterForDetectionLOSGain(sourceAsActor, player as ObjectReference) ; #DEBUG_LINE_NO:136
      If isArmed ; #DEBUG_LINE_NO:137
        sourceAsActor.SetUnconscious(False) ; #DEBUG_LINE_NO:138
      Else
        sourceAsActor.SetUnconscious(True) ; #DEBUG_LINE_NO:140
      EndIf
    Else
      Self.RegisterForRemoteEvent(sources[I] as ScriptObject, "OnTriggerEnter") ; #DEBUG_LINE_NO:143
    EndIf
    I += 1 ; #DEBUG_LINE_NO:145
  EndWhile
EndFunction

Function StopAlarmSFX()
  If alarmSFXID >= 0 ; #DEBUG_LINE_NO:150
    wwiseevent.StopInstance(alarmSFXID) ; #DEBUG_LINE_NO:151
    alarmSFXID = -1 ; #DEBUG_LINE_NO:152
  EndIf
EndFunction

Function Private_TriggerAlarm(Actor source)
  If !ShouldSkipAlarmSFX && AlarmSound != None ; #DEBUG_LINE_NO:158
    If source == None ; #DEBUG_LINE_NO:159
      source == Game.GetPlayer() ; #DEBUG_LINE_NO:160
    EndIf
    alarmSFXID = AlarmSound.Play(source as ObjectReference, None, None) ; #DEBUG_LINE_NO:162
  EndIf
  Self.Private_TriggerAlarmForRefs(Self.GetLinkedRefChain(DNLocalAlarmTargetLinkKeyword, 100)) ; #DEBUG_LINE_NO:164
  Self.Private_TriggerAlarmForRefs(Self.GetRefsLinkedToMe(DNLocalAlarmTargetLinkKeyword, None)) ; #DEBUG_LINE_NO:165
EndFunction

Function Private_TriggerAlarmForRefs(ObjectReference[] alarmedRefs)
  Int I = 0 ; #DEBUG_LINE_NO:169
  While I < alarmedRefs.Length && Self.GetState() != "Disarmed" ; #DEBUG_LINE_NO:170
    Actor currentAsActor = alarmedRefs[I] as Actor ; #DEBUG_LINE_NO:171
    If currentAsActor != None ; #DEBUG_LINE_NO:172
      robotpodscript currentAsRobotActor = currentAsActor as robotpodscript ; #DEBUG_LINE_NO:173
      If currentAsRobotActor != None ; #DEBUG_LINE_NO:174
        currentAsRobotActor.WakeRobotFromPod() ; #DEBUG_LINE_NO:175
      Else
        currentAsActor.SetUnconscious(False) ; #DEBUG_LINE_NO:177
      EndIf
      If TargetTriggerDelayMax > 0.0 ; #DEBUG_LINE_NO:179
        Utility.Wait(Utility.RandomFloat(TargetTriggerDelayMin, TargetTriggerDelayMax)) ; #DEBUG_LINE_NO:180
      EndIf
    Else
      DNLocalAlarmScript currentAsAlarmScript = alarmedRefs[I] as DNLocalAlarmScript ; #DEBUG_LINE_NO:183
      If currentAsAlarmScript != None ; #DEBUG_LINE_NO:184
        currentAsAlarmScript.TriggerAlarm() ; #DEBUG_LINE_NO:185
      EndIf
    EndIf
    I += 1 ; #DEBUG_LINE_NO:188
  EndWhile
EndFunction

;-- State -------------------------------------------
State Armed

  Event Actor.OnCombatStateChanged(Actor akSource, ObjectReference akTarget, Int aeCombatState)
    Self.GoToState("Busy")
    Self.TryToTriggerAlarm(akSource)
  EndEvent

  Event ObjectReference.OnTriggerEnter(ObjectReference akSource, ObjectReference akActionRef)
    Self.GoToState("Busy")
    Self.TryToTriggerAlarm(akSource as Actor)
  EndEvent

  Event OnGainLoS(ObjectReference akViewer, ObjectReference akTarget)
    Self.GoToState("Busy")
    Self.TryToTriggerAlarm(akViewer as Actor)
  EndEvent

  Event OnBeginState(String oldStateName)
    AlarmState = CONST_AlarmState_Armed ; #DEBUG_LINE_NO:49
  EndEvent
EndState

;-- State -------------------------------------------
State Busy
EndState

;-- State -------------------------------------------
State Disarmed

  Event OnBeginState(String oldStateName)
    AlarmState = CONST_AlarmState_Disarmed ; #DEBUG_LINE_NO:77
    Self.UnregisterForAllEvents() ; #DEBUG_LINE_NO:78
  EndEvent
EndState

;-- State -------------------------------------------
Auto State Initial

  Event OnCellLoad()
    Self.GoToState("Armed") ; #DEBUG_LINE_NO:41
    Self.SetAlarmSourceObjectState(Self.GetLinkedRefChain(DNLocalAlarmSourceLinkKeyword, 100), True) ; #DEBUG_LINE_NO:42
    Self.SetAlarmSourceObjectState(Self.GetRefsLinkedToMe(DNLocalAlarmSourceLinkKeyword, None), True) ; #DEBUG_LINE_NO:43
  EndEvent
EndState

;-- State -------------------------------------------
State Triggered

  Event OnBeginState(String oldStateName)
    AlarmState = CONST_AlarmState_Triggered ; #DEBUG_LINE_NO:84
    If AlarmQuest != None && AlarmStageToSet >= 0 ; #DEBUG_LINE_NO:85
      AlarmQuest.SetStage(AlarmStageToSet) ; #DEBUG_LINE_NO:86
    EndIf
  EndEvent
EndState
