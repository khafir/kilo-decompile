ScriptName Quest Extends Form Native hidden

;-- Structs -----------------------------------------
Struct QuestStage
  Quest QuestToSet
  Int StageToSet
EndStruct


;-- Functions ---------------------------------------

Function CompleteAllObjectives() Native

Function CompleteQuest() Native

Function FailAllObjectives() Native

Alias Function GetAlias(Int aiAliasID) Native

Int Function GetCurrentStageID() Native

ObjectReference[] Function GetCurrentStageTargets() Native

Float Function GetQuestTimeRemaining() Native

Bool Function HasObjective(Int aiObjective) Native

Bool Function IsActive() Native

Bool Function IsCompleted() Native

Bool Function IsObjectiveCompleted(Int aiObjective) Native

Bool Function IsObjectiveDisplayed(Int aiObjective) Native

Bool Function IsObjectiveFailed(Int aiObjective) Native

Bool Function IsQuestTimerPaused() Native

Bool Function IsRunning() Native

Bool Function IsStageDone(Int aiStage) Native

Bool Function IsStarting() Native

Bool Function IsStopped() Native

Bool Function IsStopping() Native

Function ModQuestTimer(Float afModValue) Native

Event OnMissionAccepted()
  ; Empty function
EndEvent

Event OnQuestInit()
  ; Empty function
EndEvent

Event OnQuestRejected()
  ; Empty function
EndEvent

Event OnQuestShutdown()
  ; Empty function
EndEvent

Event OnQuestStarted()
  ; Empty function
EndEvent

Event OnQuestTimerEnd(Int aiReason)
  ; Empty function
EndEvent

Event OnQuestTimerMod(Int aiReason)
  ; Empty function
EndEvent

Event OnQuestTimerPause(Int aiReason)
  ; Empty function
EndEvent

Event OnQuestTimerResume(Int aiReason)
  ; Empty function
EndEvent

Event OnQuestTimerStart(Int aiReason)
  ; Empty function
EndEvent

Event OnReset()
  ; Empty function
EndEvent

Event OnSpeechChallengeCompletion(speechchallengeobject akSpeechChallenge, Bool abSuccess)
  ; Empty function
EndEvent

Event OnStageSet(Int auiStageID, Int auiItemID)
  ; Empty function
EndEvent

Event OnStoryActivateActor(Location akLocation, ObjectReference akActor)
  ; Empty function
EndEvent

Event OnStoryActorAttach(ObjectReference akActor, Location akLocation)
  ; Empty function
EndEvent

Event OnStoryAddToPlayer(ObjectReference akOwner, ObjectReference akContainer, Location akLocation, Form akItemBase, Int aiAcquireType, Int aiValue)
  ; Empty function
EndEvent

Event OnStoryArrest(ObjectReference akArrestingGuard, ObjectReference akCriminal, Location akLocation, Int aiCrime)
  ; Empty function
EndEvent

Event OnStoryAssaultActor(ObjectReference akVictim, ObjectReference akAttacker, Location akLocation, Bool abCrime)
  ; Empty function
EndEvent

Event OnStoryAttractionObject(ObjectReference akActor, ObjectReference akObject, Location akLocation, Bool abCommanded)
  ; Empty function
EndEvent

Event OnStoryBribeNPC(ObjectReference akActor)
  ; Empty function
EndEvent

Event OnStoryCastMagic(ObjectReference akCastingActor, ObjectReference akSpellTarget, Location akLocation, Form akSpell)
  ; Empty function
EndEvent

Event OnStoryChangeLocation(ObjectReference akActor, Location akOldLocation, Location akNewLocation)
  ; Empty function
EndEvent

Event OnStoryCraftItem(ObjectReference akBench, Location akLocation, Form akCreatedItem)
  ; Empty function
EndEvent

Event OnStoryCrimeGold(ObjectReference akVictim, ObjectReference akCriminal, Form akFaction, Int aiGoldAmount, Int aiCrime)
  ; Empty function
EndEvent

Event OnStoryCure(Form akInfection)
  ; Empty function
EndEvent

Event OnStoryDialogue(Location akLocation)
  ; Empty function
EndEvent

Event OnStoryDiscoverDeadBody(ObjectReference akActor, ObjectReference akDeadActor, Location akLocation)
  ; Empty function
EndEvent

Event OnStoryEscapeJail(Location akLocation, Form akCrimeGroup)
  ; Empty function
EndEvent

Event OnStoryExploredLocation(Location akOldLocation)
  ; Empty function
EndEvent

Event OnStoryFlatterNPC(ObjectReference akActor)
  ; Empty function
EndEvent

Event OnStoryHackTerminal(ObjectReference akComputer, Bool abSucceeded)
  ; Empty function
EndEvent

Event OnStoryHello(Location akLocation, ObjectReference akActor1, ObjectReference akActor2)
  ; Empty function
EndEvent

Event OnStoryIncreaseLevel(Int aiNewLevel)
  ; Empty function
EndEvent

Event OnStoryInfection(ObjectReference akTransmittingActor, Form akInfection)
  ; Empty function
EndEvent

Event OnStoryIntimidateNPC(ObjectReference akActor)
  ; Empty function
EndEvent

Event OnStoryIronSights(ObjectReference akActor, Form akWeapon)
  ; Empty function
EndEvent

Event OnStoryJail(ObjectReference akGuard, Form akCrimeGroup, Location akLocation, Int aiCrimeGold)
  ; Empty function
EndEvent

Event OnStoryKillActor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, Int aiCrimeStatus, Int aiRelationshipRank)
  ; Empty function
EndEvent

Event OnStoryLocationLoaded(Location akLocation)
  ; Empty function
EndEvent

Event OnStoryMineExplosion(ObjectReference akVictim, ObjectReference akAttacker)
  ; Empty function
EndEvent

Event OnStoryNewVoicePower(ObjectReference akActor, Form akVoicePower)
  ; Empty function
EndEvent

Event OnStoryPayFine(ObjectReference akCriminal, ObjectReference akGuard, Form akCrimeGroup, Int aiCrimeGold)
  ; Empty function
EndEvent

Event OnStoryPickLock(ObjectReference akActor, ObjectReference akLock, Bool abCrime)
  ; Empty function
EndEvent

Event OnStoryPickPocket(ObjectReference akVictim, Bool abSuccess)
  ; Empty function
EndEvent

Event OnStoryPiracyActor(ObjectReference akVictim, ObjectReference akAttacker, Location akLocation, Bool abCrime)
  ; Empty function
EndEvent

Event OnStoryPlayerGetsFavor(ObjectReference akActor)
  ; Empty function
EndEvent

Event OnStoryRelationshipChange(ObjectReference akActor1, ObjectReference akActor2, Int aiOldRelationship, Int aiNewRelationship)
  ; Empty function
EndEvent

Event OnStoryRemoveFromPlayer(ObjectReference akOwner, ObjectReference akItem, Location akLocation, Form akItemBase, Int aiRemoveType, Int aiValue)
  ; Empty function
EndEvent

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, Int aiValue1, Int aiValue2)
  ; Empty function
EndEvent

Event OnStoryServedTime(Location akLocation, Form akCrimeGroup, Int aiCrimeGold, Int aiDaysJail)
  ; Empty function
EndEvent

Event OnStoryShipDock(ObjectReference akDockingShip, ObjectReference akDockTargetShip, Bool abDocking)
  ; Empty function
EndEvent

Event OnStoryShipLanding(ObjectReference akLandingShip, ObjectReference akLandingMarker)
  ; Empty function
EndEvent

Event OnStoryTrespass(ObjectReference akVictim, ObjectReference akTrespasser, Location akLocation, Bool abCrime)
  ; Empty function
EndEvent

Function PauseQuestTimer(Bool abPause) Native

Function Reset() Native

Function ResetSpeechChallenges() Native

Function SetActive(Bool abActive) Native

Bool Function SetCurrentStageID(Int aiStageID) Native

Function SetObjectiveCompleted(Int aiObjective, Bool abCompleted) Native

Function SetObjectiveDisplayed(Int aiObjective, Bool abDisplayed, Bool abForce) Native

Function SetObjectiveDisplayedAtTop(Int aiObjective) Native

Function SetObjectiveFailed(Int aiObjective, Bool abFailed) Native

Function SetStageNoWait(Int aiStage) Native

Bool Function Start() Native

Bool Function StartNoWait() Native

Function StartQuestTimer(Float afTimeInHours) Native

Function Stop() Native

Function StopQuestTimer() Native

Bool Function UpdateCurrentInstanceGlobal(GlobalVariable aUpdateGlobal) Native

Bool Function ModObjectiveGlobal(Float afModValue, GlobalVariable aModGlobal, Int aiObjectiveID, Float afTargetValue, Bool abCountingUp, Bool abCompleteObjective, Bool abRedisplayObjective, Bool abAllowRollbackObjective)
  aModGlobal.Mod(afModValue) ; #DEBUG_LINE_NO:14
  Self.UpdateCurrentInstanceGlobal(aModGlobal) ; #DEBUG_LINE_NO:15
  If aiObjectiveID >= 0 ; #DEBUG_LINE_NO:17
    If afTargetValue > -1.0 ; #DEBUG_LINE_NO:19
      If abCountingUp && aModGlobal.value >= afTargetValue || !abCountingUp && aModGlobal.value <= afTargetValue ; #DEBUG_LINE_NO:20
        If abCompleteObjective ; #DEBUG_LINE_NO:21
          Self.SetObjectiveCompleted(aiObjectiveID, True) ; #DEBUG_LINE_NO:24
          Return True ; #DEBUG_LINE_NO:25
        Else
          Self.SetObjectiveFailed(aiObjectiveID, True) ; #DEBUG_LINE_NO:29
          Return True ; #DEBUG_LINE_NO:30
        EndIf
      Else
        If abAllowRollbackObjective && Self.IsObjectiveCompleted(aiObjectiveID) ; #DEBUG_LINE_NO:34
          Self.SetObjectiveCompleted(aiObjectiveID, False) ; #DEBUG_LINE_NO:36
        EndIf
        If abRedisplayObjective ; #DEBUG_LINE_NO:38
          Self.SetObjectiveDisplayed(aiObjectiveID, True, True) ; #DEBUG_LINE_NO:40
        Else
          Self.SetObjectiveDisplayed(aiObjectiveID, True, False) ; #DEBUG_LINE_NO:42
        EndIf
      EndIf
    ElseIf abRedisplayObjective
      Self.SetObjectiveDisplayed(aiObjectiveID, True, True) ; #DEBUG_LINE_NO:47
    Else
      Self.SetObjectiveDisplayed(aiObjectiveID, True, False) ; #DEBUG_LINE_NO:49
    EndIf
  ElseIf abCountingUp && aModGlobal.value >= afTargetValue || !abCountingUp && aModGlobal.value <= afTargetValue ; #DEBUG_LINE_NO:53
    Return True ; #DEBUG_LINE_NO:54
  EndIf
  Return False ; #DEBUG_LINE_NO:57
EndFunction

Function SetAllStages(Int lastStage)
  Int I = 0 ; #DEBUG_LINE_NO:62
  While I <= lastStage ; #DEBUG_LINE_NO:63
    Self.setStage(I) ; #DEBUG_LINE_NO:64
    I += 1 ; #DEBUG_LINE_NO:65
  EndWhile
EndFunction

Function SetQuestStage(quest:queststage questStageToSet) Global
  questStageToSet.QuestToSet.setStage(questStageToSet.StageToSet) ; #DEBUG_LINE_NO:75
EndFunction

Bool Function GetQuestStageDone(quest:queststage questStageToCheck) Global
  Return questStageToCheck.QuestToSet.GetStageDone(questStageToCheck.StageToSet) ; #DEBUG_LINE_NO:79
EndFunction

Function SetObjectiveSkipped(Int aiObjectiveID)
  If Self.IsObjectiveCompleted(aiObjectiveID) == False ; #DEBUG_LINE_NO:84
    Self.SetObjectiveDisplayed(aiObjectiveID, False, False) ; #DEBUG_LINE_NO:85
  EndIf
EndFunction

Function SetObjectiveActive(Int aiObjective, Bool abForceRedisplay)
  If Self.IsObjectiveFailed(aiObjective) ; #DEBUG_LINE_NO:95
    Self.SetObjectiveFailed(aiObjective, False) ; #DEBUG_LINE_NO:96
  EndIf
  If Self.IsObjectiveCompleted(aiObjective) ; #DEBUG_LINE_NO:98
    Self.SetObjectiveCompleted(aiObjective, False) ; #DEBUG_LINE_NO:99
  EndIf
  Self.SetObjectiveDisplayed(aiObjective, True, abForceRedisplay) ; #DEBUG_LINE_NO:102
EndFunction

Int Function GetStage()
  Return Self.GetCurrentStageID() ; #DEBUG_LINE_NO:128
EndFunction

Bool Function GetStageDone(Int aiStage)
  Return Self.IsStageDone(aiStage) ; #DEBUG_LINE_NO:136
EndFunction

Function SetObjectiveFailedIfNotCompleted(Int aiObjective)
  If Self.IsObjectiveCompleted(aiObjective) == False ; #DEBUG_LINE_NO:210
    Self.SetObjectiveFailed(aiObjective, True) ; #DEBUG_LINE_NO:211
  EndIf
EndFunction

Bool Function setStage(Int aiStage)
  Return Self.SetCurrentStageID(aiStage) ; #DEBUG_LINE_NO:218
EndFunction
