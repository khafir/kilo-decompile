ScriptName TestNPCChangeType Extends ObjectReference Const

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorBase[] Property NPCTypes Auto Const mandatory
ObjectReference Property SpawnController Auto Const mandatory

;-- Functions ---------------------------------------

Function CycleNPCType()
  Int index = NPCTypes.find((SpawnController as testnpcsimplespawn).ActorToSpawn, 0) ; #DEBUG_LINE_NO:9
  If index + 1 >= NPCTypes.Length - 1 ; #DEBUG_LINE_NO:11
    index = 0 ; #DEBUG_LINE_NO:12
  Else
    index += 1 ; #DEBUG_LINE_NO:14
  EndIf
  (SpawnController as testnpcsimplespawn).ActorToSpawn = NPCTypes[index] ; #DEBUG_LINE_NO:16
EndFunction
