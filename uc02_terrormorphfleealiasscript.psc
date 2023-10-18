ScriptName UC02_TerrormorphFleeAliasScript Extends ReferenceAlias Const

;-- Variables ---------------------------------------
Int iCheckTimerID = 1 Const

;-- Properties --------------------------------------
Faction Property TerrormorphFaction Auto Const mandatory
{ Terrormorph faction }
RefCollectionAlias Property FleeingTerrormorph Auto Const mandatory
{ Collection for fleeing Terrormorphs }
Int Property CheckTimerLength Auto Const mandatory
{ How frequently we check to see if the Terrormorph is out of range of the target }
GlobalVariable Property UC02_TerrormorphFleeDistance Auto Const mandatory
{ Global used to know how far Terrormorphs need to flee from this alias }

;-- Functions ---------------------------------------

Event OnTriggerEnter(ObjectReference akActionRef)
  Actor TriggerACT = akActionRef as Actor ; #DEBUG_LINE_NO:18
  If TriggerACT as Bool && TriggerACT.IsInFaction(TerrormorphFaction) ; #DEBUG_LINE_NO:19
    If FleeingTerrormorph.GetCount() <= 0 ; #DEBUG_LINE_NO:20
      Self.StartTimerCheck() ; #DEBUG_LINE_NO:21
    EndIf
    FleeingTerrormorph.Addref(TriggerACT as ObjectReference) ; #DEBUG_LINE_NO:24
    TriggerACT.EvaluatePackage(False) ; #DEBUG_LINE_NO:25
  EndIf
EndEvent

Function StartTimerCheck()
  Self.StartTimer(CheckTimerLength as Float, iCheckTimerID) ; #DEBUG_LINE_NO:30
EndFunction

Function CleanUpCollection()
  Int I = 0 ; #DEBUG_LINE_NO:34
  Int iCount = FleeingTerrormorph.GetCount() ; #DEBUG_LINE_NO:35
  While I < iCount ; #DEBUG_LINE_NO:37
    ObjectReference currMorph = FleeingTerrormorph.GetAt(I) ; #DEBUG_LINE_NO:38
    If currMorph.GetDistance(Self.GetRef()) <= UC02_TerrormorphFleeDistance.GetValue() ; #DEBUG_LINE_NO:40
      FleeingTerrormorph.RemoveRef(currMorph) ; #DEBUG_LINE_NO:41
    EndIf
    I += 1 ; #DEBUG_LINE_NO:44
  EndWhile
  If FleeingTerrormorph.GetCount() > 0 ; #DEBUG_LINE_NO:47
    Self.StartTimerCheck() ; #DEBUG_LINE_NO:48
  EndIf
EndFunction

Event OnTimer(Int aiTimerID)
  If aiTimerID == iCheckTimerID ; #DEBUG_LINE_NO:53
    Self.CleanUpCollection() ; #DEBUG_LINE_NO:54
  EndIf
EndEvent

Event OnUnload()
  Self.CancelTimer(iCheckTimerID) ; #DEBUG_LINE_NO:59
  FleeingTerrormorph.RemoveAll() ; #DEBUG_LINE_NO:60
EndEvent
