ScriptName AirlockControl Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Keyword Property LinkKeyword1 Auto Const mandatory
Keyword Property LinkKeyword2 Auto Const mandatory
Keyword Property LinkPassOpenCloseEvent Auto Const mandatory
Message Property BusyActivatorMessage Auto Const mandatory

;-- Functions ---------------------------------------

Event OnInit()
  Self.RegisterForRemoteEvent(Self.GetLinkedRef(LinkKeyword1) as ScriptObject, "OnActivate") ; #DEBUG_LINE_NO:12
  Self.RegisterForRemoteEvent(Self.GetLinkedRef(LinkKeyword2) as ScriptObject, "OnActivate") ; #DEBUG_LINE_NO:13
  ObjectReference Link1 = Self.GetLinkedRef(LinkKeyword1) ; #DEBUG_LINE_NO:17
  ObjectReference[] LinkedRefs = Link1.GetLinkedRefChain(LinkPassOpenCloseEvent, 100) ; #DEBUG_LINE_NO:18
  ObjectReference Link2 = Self.GetLinkedRef(LinkKeyword2) ; #DEBUG_LINE_NO:19
  ObjectReference[] LinkedRefsToAdd = Link2.GetLinkedRefChain(LinkPassOpenCloseEvent, 100) ; #DEBUG_LINE_NO:20
  Int index = 0 ; #DEBUG_LINE_NO:22
  While index < LinkedRefsToAdd.Length ; #DEBUG_LINE_NO:23
    LinkedRefs.add(LinkedRefsToAdd[index], 1) ; #DEBUG_LINE_NO:24
    index += 1 ; #DEBUG_LINE_NO:25
  EndWhile
  LinkedRefs.add(Link1, 1) ; #DEBUG_LINE_NO:27
  LinkedRefs.add(Link2, 1) ; #DEBUG_LINE_NO:28
  index = 0 ; #DEBUG_LINE_NO:31
  While index < LinkedRefs.Length ; #DEBUG_LINE_NO:32
    ObjectReference item = LinkedRefs[index] ; #DEBUG_LINE_NO:33
    Self.RegisterForRemoteEvent(item as ScriptObject, "OnActivate") ; #DEBUG_LINE_NO:34
    index += 1 ; #DEBUG_LINE_NO:35
  EndWhile
EndEvent

Event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
  ; Empty function
EndEvent

;-- State -------------------------------------------
State Busy

  Event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    akSender.BlockActivation(True, False)
  EndEvent

  Event OnTimer(Int aiTimerID)
    ObjectReference Link1 = Self.GetLinkedRef(LinkKeyword1)
    ObjectReference[] LinkedRefs = Link1.GetLinkedRefChain(LinkPassOpenCloseEvent, 100)
    ObjectReference Link2 = Self.GetLinkedRef(LinkKeyword2)
    ObjectReference[] LinkedRefsToAdd = Link2.GetLinkedRefChain(LinkPassOpenCloseEvent, 100)
    Int index = 0
    While index < LinkedRefsToAdd.Length
      LinkedRefs.add(LinkedRefsToAdd[index], 1)
      index += 1
    EndWhile
    LinkedRefs.add(Link1, 1)
    LinkedRefs.add(Link2, 1)
    Bool readyToGoIdle = True
    index = 0
    While index < LinkedRefs.Length
      ObjectReference item = LinkedRefs[index]
      Int openState = item.GetOpenState()
      If openState == 2 || openState == 4
        readyToGoIdle = False
      EndIf
      index += 1
    EndWhile
    If readyToGoIdle
      Self.GotoState("Idle")
    Else
      Self.StartTimer(1.0, 0)
    EndIf
  EndEvent

  Event onBeginState(String asOldState)
    ; Empty function
  EndEvent
EndState

;-- State -------------------------------------------
Auto State Idle

  Event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    Self.GotoState("Busy")
    Self.StartTimer(3.0, 0)
    ObjectReference Sys1Link1 = Self.GetLinkedRef(LinkKeyword1)
    ObjectReference[] Sys1LinkedRefs = Sys1Link1.GetLinkedRefChain(LinkPassOpenCloseEvent, 100)
    Sys1LinkedRefs.add(Sys1Link1, 1)
    If Sys1LinkedRefs.find(akSender, 0) > -1
      If Self.GetLinkedRef(LinkKeyword2).GetOpenState() == 1
        Self.GetLinkedRef(LinkKeyword2).Activate(akActionRef, False)
      Else
        ObjectReference Sys2Link1 = Self.GetLinkedRef(LinkKeyword2)
        ObjectReference[] Sys2LinkedRefs = Sys2Link1.GetLinkedRefChain(LinkPassOpenCloseEvent, 100)
        Sys2LinkedRefs.add(Sys2Link1, 1)
        Int index = 0
        While index < Sys2LinkedRefs.Length
          ObjectReference item = Sys2LinkedRefs[index]
          item.BlockActivation(True, False)
          index += 1
        EndWhile
      EndIf
    ElseIf Self.GetLinkedRef(LinkKeyword1).GetOpenState() == 1
      Self.GetLinkedRef(LinkKeyword1).Activate(akActionRef, False)
    Else
      Int index = 0
      While index < Sys1LinkedRefs.Length
        ObjectReference item = Sys1LinkedRefs[index]
        item.BlockActivation(True, False)
        index += 1
      EndWhile
    EndIf
    akSender.BlockActivation(True, False)
  EndEvent

  Event onBeginState(String asOldState)
    ObjectReference Link1 = Self.GetLinkedRef(LinkKeyword1) ; #DEBUG_LINE_NO:51
    ObjectReference[] LinkedRefs = Link1.GetLinkedRefChain(LinkPassOpenCloseEvent, 100) ; #DEBUG_LINE_NO:52
    ObjectReference Link2 = Self.GetLinkedRef(LinkKeyword2) ; #DEBUG_LINE_NO:53
    ObjectReference[] LinkedRefsToAdd = Link2.GetLinkedRefChain(LinkPassOpenCloseEvent, 100) ; #DEBUG_LINE_NO:54
    Int index = 0 ; #DEBUG_LINE_NO:56
    While index < LinkedRefsToAdd.Length ; #DEBUG_LINE_NO:57
      LinkedRefs.add(LinkedRefsToAdd[index], 1) ; #DEBUG_LINE_NO:58
      index += 1 ; #DEBUG_LINE_NO:59
    EndWhile
    LinkedRefs.add(Link1, 1) ; #DEBUG_LINE_NO:61
    LinkedRefs.add(Link2, 1) ; #DEBUG_LINE_NO:62
    index = 0 ; #DEBUG_LINE_NO:65
    While index < LinkedRefs.Length ; #DEBUG_LINE_NO:66
      ObjectReference item = LinkedRefs[index] ; #DEBUG_LINE_NO:67
      item.BlockActivation(False, False) ; #DEBUG_LINE_NO:69
      index += 1 ; #DEBUG_LINE_NO:71
    EndWhile
  EndEvent
EndState
