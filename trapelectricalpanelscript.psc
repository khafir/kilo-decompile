ScriptName TrapElectricalPanelScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Group TrapElectricityDefaults
  Keyword Property TrapStartUnbrokenKeyword Auto Const mandatory
  { If the trap has this keyword it will start inactive and will need to be damaged to start }
  Keyword Property TrapElectricityCanArcToKeyword Auto Const mandatory
  { Keyword for object references that electricity will arc to }
  Keyword Property TrapRequiresPower Auto Const mandatory
  { Keyword for object references that electricity will arc to }
  Keyword Property ActorTypeRobot Auto Const mandatory
  { Keyword for robots, so electricity will arc to them }
  Keyword Property ActorTypeHuman Auto Const mandatory
  { Keyword for humans, so electricity will arc to them }
  Keyword Property ActorTypeCreature Auto Const mandatory
  { Keyword for humans, so electricity will arc to them }
  Keyword Property LinkCustom01 Auto Const mandatory
  { Keyword for link to point where projectile comes out }
  Float Property DamageToStartDestroyed = 1000.0 Auto Const
EndGroup

Group TrapElectricityArcData
  Spell Property ElectricitySpell Auto Const mandatory
  { Spell Cast by trap at each interval }
  Float Property fDistanceToArc = 12.0 Auto
  { Distance from arc start point that electricity will arc }
  Float Property arcMinTime = 1.899999976 Auto Const
  { Minimum base time between strikes }
  Float Property arcMaxTime = 2.5 Auto Const
  { Maximum base time between strikes }
EndGroup

Group TrapElectricityArcPanelSounds
  wwiseevent Property WwiseEvent_OBJ_ElectricalPanel_Destroyed Auto Const mandatory
  wwiseevent Property WwiseEvent_State_Switches_PowerOff Auto Const mandatory
  wwiseevent Property WwiseEvent_State_Switches_PowerOn Auto Const mandatory
EndGroup


;-- Functions ---------------------------------------

Function ArcElectricityToTarget(ObjectReference target)
  If target ; #DEBUG_LINE_NO:92
    ElectricitySpell.Cast(Self.GetLinkedRef(LinkCustom01), target) ; #DEBUG_LINE_NO:93
  EndIf
EndFunction

ObjectReference Function FindTarget()
  ObjectReference ArcTarget = None ; #DEBUG_LINE_NO:99
  ArcTarget = Self.FindRobotTarget() ; #DEBUG_LINE_NO:100
  If ArcTarget == None ; #DEBUG_LINE_NO:101
    ArcTarget = Self.FindHumanOrCreatureTarget() ; #DEBUG_LINE_NO:102
  EndIf
  If ArcTarget == None ; #DEBUG_LINE_NO:104
    ArcTarget = Self.FindStaticArcTarget() ; #DEBUG_LINE_NO:105
  EndIf
  Return ArcTarget ; #DEBUG_LINE_NO:108
EndFunction

ObjectReference Function FindRobotTarget()
{ Get a list of robots in range, find the ones in LOS, get the closest one of those. }
  ObjectReference RobotTarget = Self.ClosestTarget(Self.TargetsInLOS(Self.FindAllReferencesWithKeyword(ActorTypeRobot as Form, fDistanceToArc))) ; #DEBUG_LINE_NO:113
  Return RobotTarget ; #DEBUG_LINE_NO:114
EndFunction

ObjectReference Function FindHumanOrCreatureTarget()
{ Get a list of creatures and humans in range, find the ones in LOS, get the closest one of those. }
  ObjectReference CreatureTarget = Self.ClosestTarget(Self.TargetsInLOS(Self.FindAllReferencesWithKeyword(ActorTypeCreature as Form, fDistanceToArc))) ; #DEBUG_LINE_NO:119
  ObjectReference HumanTarget = Self.ClosestTarget(Self.TargetsInLOS(Self.FindAllReferencesWithKeyword(ActorTypeHuman as Form, fDistanceToArc))) ; #DEBUG_LINE_NO:120
  ObjectReference target = None ; #DEBUG_LINE_NO:121
  If HumanTarget as Bool && CreatureTarget as Bool ; #DEBUG_LINE_NO:123
    If Self.GetDistance(HumanTarget) < Self.GetDistance(CreatureTarget) ; #DEBUG_LINE_NO:124
      target = HumanTarget ; #DEBUG_LINE_NO:125
    Else
      target = CreatureTarget ; #DEBUG_LINE_NO:127
    EndIf
  ElseIf HumanTarget
    target = HumanTarget ; #DEBUG_LINE_NO:130
  ElseIf CreatureTarget
    target = CreatureTarget ; #DEBUG_LINE_NO:132
  EndIf
  Return target ; #DEBUG_LINE_NO:134
EndFunction

ObjectReference Function FindStaticArcTarget()
  ObjectReference[] ArcTargets = Self.TargetsInLOS(Self.FindAllReferencesWithKeyword(TrapElectricityCanArcToKeyword as Form, fDistanceToArc)) ; #DEBUG_LINE_NO:139
  If ArcTargets.Length > 0 ; #DEBUG_LINE_NO:140
    ObjectReference ArcTarget = ArcTargets[Utility.RandomInt(0, ArcTargets.Length - 1)] ; #DEBUG_LINE_NO:141
    Return ArcTarget ; #DEBUG_LINE_NO:142
  Else
    Return None ; #DEBUG_LINE_NO:144
  EndIf
EndFunction

ObjectReference[] Function TargetsInLOS(ObjectReference[] targets)
{ Returns an array of all targets from the passed in array that are in Line Of Sight }
  If targets.Length > 0 ; #DEBUG_LINE_NO:150
    ObjectReference[] TargetsInLOS = new ObjectReference[0] ; #DEBUG_LINE_NO:151
    Int I = 0 ; #DEBUG_LINE_NO:152
    While I < targets.Length ; #DEBUG_LINE_NO:153
      If Self.HasDirectLOS(targets[I], "", "") ; #DEBUG_LINE_NO:154
        TargetsInLOS.add(targets[I], 1) ; #DEBUG_LINE_NO:155
      EndIf
      I += 1 ; #DEBUG_LINE_NO:157
    EndWhile
    Return TargetsInLOS ; #DEBUG_LINE_NO:159
  Else
    Return None ; #DEBUG_LINE_NO:161
  EndIf
EndFunction

ObjectReference Function ClosestTarget(ObjectReference[] targets)
{ Returns the closest target from an array of targets }
  If targets.Length > 0 ; #DEBUG_LINE_NO:167
    ObjectReference currentTarget = targets[0] ; #DEBUG_LINE_NO:168
    Float currentTargetDistance = Self.GetDistance(currentTarget) ; #DEBUG_LINE_NO:169
    Int I = 1 ; #DEBUG_LINE_NO:170
    While I < targets.Length ; #DEBUG_LINE_NO:171
      Float nextTargetDistance = Self.GetDistance(targets[I]) ; #DEBUG_LINE_NO:172
      If nextTargetDistance < currentTargetDistance ; #DEBUG_LINE_NO:173
        currentTarget = targets[I] ; #DEBUG_LINE_NO:174
        currentTargetDistance = nextTargetDistance ; #DEBUG_LINE_NO:175
      EndIf
      I += 1 ; #DEBUG_LINE_NO:177
    EndWhile
    Return currentTarget ; #DEBUG_LINE_NO:179
  Else
    Return None ; #DEBUG_LINE_NO:181
  EndIf
EndFunction

;-- State -------------------------------------------
State Active

  Event OnPowerOff()
    WwiseEvent_State_Switches_PowerOff.Play(Self as ObjectReference, None, None)
    If Self.GetLinkedRef(None).HasKeyword(TrapRequiresPower)
      Self.GotoState("Inactive")
      Self.CancelTimer(0)
    EndIf
  EndEvent

  Event OnTimer(Int aiTimerID)
    Self.ArcElectricityToTarget(Self.FindTarget())
    Self.StartTimer(Utility.RandomFloat(arcMinTime, arcMaxTime), 0)
  EndEvent

  Event OnUnload()
    Self.GotoState("Inactive")
  EndEvent

  Event OnBeginState(String asOldState)
    Self.ArcElectricityToTarget(Self.FindTarget()) ; #DEBUG_LINE_NO:67
    Self.StartTimer(Utility.RandomFloat(arcMinTime, arcMaxTime), 0) ; #DEBUG_LINE_NO:68
  EndEvent
EndState

;-- State -------------------------------------------
Auto State Inactive

  Event OnDestroyed(ObjectReference akDestroyer)
    WwiseEvent_OBJ_ElectricalPanel_Destroyed.Play(Self as ObjectReference, None, None)
    If Self.GetLinkedRef(None).HasKeyword(TrapRequiresPower)
      If Self.IsPowered()
        Self.GotoState("Active")
      EndIf
    Else
      Self.GotoState("Active")
    EndIf
  EndEvent

  Event OnPowerOn(ObjectReference akPowerGenerator)
    WwiseEvent_State_Switches_PowerOn.Play(Self as ObjectReference, None, None)
    If Self.IsDestroyed() && Self.GetLinkedRef(None).HasKeyword(TrapRequiresPower)
      Self.GotoState("Active")
    EndIf
  EndEvent

  Event OnCellLoad()
    If !Self.GetLinkedRef(None).HasKeyword(TrapStartUnbrokenKeyword) ; #DEBUG_LINE_NO:40
      Self.DamageObject(DamageToStartDestroyed) ; #DEBUG_LINE_NO:41
    EndIf
    WwiseEvent_State_Switches_PowerOn.Play(Self as ObjectReference, None, None) ; #DEBUG_LINE_NO:43
  EndEvent
EndState
