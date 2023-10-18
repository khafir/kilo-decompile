ScriptName MQ207HunterScript Extends ReferenceAlias

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ReferenceAlias Property KeeperAquilus Auto Const mandatory

;-- State -------------------------------------------
Auto State WaitingForPlayer

  Event OnUnload()
    ; Empty function
  EndEvent

  Event OnLoad()
    Self.gotostate("hasbeentriggered") ; #DEBUG_LINE_NO:7
    Actor HunterREF = Self.GetActorRef() ; #DEBUG_LINE_NO:8
    HunterREF.WaitFor3dLoad() ; #DEBUG_LINE_NO:9
    HunterREF.CopyAppearance(KeeperAquilus.GetActorRef()) ; #DEBUG_LINE_NO:10
  EndEvent
EndState

;-- State -------------------------------------------
State hasbeentriggered

  Event OnLoad()
    ; Empty function
  EndEvent

  Event OnUnload()
    Self.gotostate("WaitingForPlayer")
  EndEvent
EndState
