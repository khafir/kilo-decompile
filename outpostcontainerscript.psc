ScriptName OutpostContainerScript Extends ObjectReference
{ put this on containers that we want to update linked containers when the player modifies inventory }

;-- Functions ---------------------------------------

Event OnLoad()
  Self.RegisterForEvents(True) ; #DEBUG_LINE_NO:5
EndEvent

Event OnUnload()
  Self.RegisterForEvents(False) ; #DEBUG_LINE_NO:9
EndEvent

Event OnWorkshopObjectRemoved(ObjectReference akReference)
  Self.RegisterForEvents(False) ; #DEBUG_LINE_NO:13
EndEvent

Function RegisterForEvents(Bool bRegister)
  If bRegister ; #DEBUG_LINE_NO:61
    Self.RegisterForMenuOpenCloseEvent("ContainerMenu") ; #DEBUG_LINE_NO:62
    Self.AddInventoryEventFilter(None) ; #DEBUG_LINE_NO:63
    Self.gotoState("ready") ; #DEBUG_LINE_NO:64
  Else
    Self.UnregisterForMenuOpenCloseEvent("ContainerMenu") ; #DEBUG_LINE_NO:66
    Self.RemoveAllInventoryEventFilters() ; #DEBUG_LINE_NO:67
  EndIf
EndFunction

;-- State -------------------------------------------
State busy

  Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer, Int aiTransferReason)
    ; Empty function
  EndEvent

  Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer, Int aiTransferReason)
    ; Empty function
  EndEvent

  Event OnMenuOpenCloseEvent(String asMenuName, Bool abOpening)
    If abOpening == False ; #DEBUG_LINE_NO:45
      Self.MoveContainerContentToUnfilledContainers() ; #DEBUG_LINE_NO:47
      Self.gotoState("ready") ; #DEBUG_LINE_NO:48
    EndIf
  EndEvent
EndState

;-- State -------------------------------------------
Auto State ready

  Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer, Int aiTransferReason)
    If akDestContainer == Game.GetPlayer() as ObjectReference
      Self.gotoState("busy")
      Self.MoveContainerContentToUnfilledContainers()
      Self.gotoState("ready")
    EndIf
  EndEvent

  Event OnMenuOpenCloseEvent(String asMenuName, Bool abOpening)
    If abOpening
      Self.gotoState("busy")
    EndIf
  EndEvent

  Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer, Int aiTransferReason)
    If akSourceContainer == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:18
      Self.gotoState("busy") ; #DEBUG_LINE_NO:19
      Self.MoveContainerContentToUnfilledContainers() ; #DEBUG_LINE_NO:21
      Self.gotoState("ready") ; #DEBUG_LINE_NO:22
    EndIf
  EndEvent
EndState
