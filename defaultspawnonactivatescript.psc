ScriptName defaultSpawnOnActivateSCRIPT Extends ObjectReference hidden

;-- Variables ---------------------------------------
Bool done = False

;-- Properties --------------------------------------
ActorBase Property ActorToSpawn Auto
ObjectReference Property SpawnAtReference Auto
Bool Property PlayerActivateOnly Auto
Bool Property DoOnce Auto

;-- Functions ---------------------------------------

Event onACTIVATE(ObjectReference akActionRef)
  If !done ; #DEBUG_LINE_NO:16
    If PlayerActivateOnly ; #DEBUG_LINE_NO:19
      If akActionRef == Game.getPlayer() as ObjectReference ; #DEBUG_LINE_NO:21
        SpawnAtReference.placeAtMe(ActorToSpawn as Form, 1, False, False, True, None, None, True) ; #DEBUG_LINE_NO:22
      EndIf
    ElseIf !PlayerActivateOnly ; #DEBUG_LINE_NO:26
      SpawnAtReference.placeAtMe(ActorToSpawn as Form, 1, False, False, True, None, None, True) ; #DEBUG_LINE_NO:27
    EndIf
    If DoOnce ; #DEBUG_LINE_NO:32
      done = True ; #DEBUG_LINE_NO:33
    EndIf
  EndIf
EndEvent
