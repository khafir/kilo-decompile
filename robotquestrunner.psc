ScriptName RobotQuestRunner Extends Actor

;-- Variables ---------------------------------------
Float AcceptableDistance = 2.299999952
Float AcceptableDistanceSpace = 100.0
Int CombatState = 3
ObjectReference CombatTarget
Quest CurrentQuest
ObjectReference CurrentTarget
Int CurrentTimePassedInDialog = 0
Int CurrentTimePassedSelectingQuest = 0
Int CurrentTimePassedSelectingTarget = 0
Int DialogueState = 2
Int DialogueStateIterator = 0
inputenablelayer DisableForTesting
Int FailedInteractionThreshold = 10
Int IdleState = 0
Int InteractState = 4
Int MaxQuestsToComplete = 1
Int MaxTimeBeforeDialogFailure = 240
Int MaxTimeBeforeFailureSelectingQuest = 150
Int MaxTimeBeforeFailureSelectingTarget = 300
Int MaxTimeBeforeKillAllSelectingTarget = 180
Int MenuState = 5
Int PathingState = 1
Int QuestsComplete = 0
Bool TestPaused = False
Bool TestSuccessful = False
Int WaitDuration = 1
String lastState = "None"
Int previousStage = -1
Int previousTarget = 0

;-- Properties --------------------------------------
Int Property Dialogue_Substate_Exit = 0 AutoReadOnly
Int Property Dialogue_Substate_Skip = 1 AutoReadOnly
Int Property Dialogue_Substate_MAX = 2 AutoReadOnly

;-- Functions ---------------------------------------

Function UpdateState()
  ; Empty function
EndFunction

Bool Function StateRequestsFinish()
  Return False ; #DEBUG_LINE_NO:320
EndFunction

Bool Function IsValidState(String asState)
  If asState == "None" ; #DEBUG_LINE_NO:328
    Return False ; #DEBUG_LINE_NO:329
  ElseIf asState != "PlayerInDialogue" || asState != "PlayerInMessageBox" || asState != "Inert" || asState != "TestCompleted" || asState != "SelectingTarget" || asState != "SelectingQuest" ; #DEBUG_LINE_NO:330
    Return False ; #DEBUG_LINE_NO:331
  Else
    Return True ; #DEBUG_LINE_NO:333
  EndIf
EndFunction

Function MakeGameplayBotRequest(ObjectReference Target, Int aiState)
  If Self.GetState() != "CodeControlled" ; #DEBUG_LINE_NO:340
    Game.RequestGameplayBotState(Target, aiState) ; #DEBUG_LINE_NO:341
  EndIf
EndFunction

Function RequestToggleCodeControl(Bool abCodeWantsControl, String NewState)
  String currentState = Self.GetState() ; #DEBUG_LINE_NO:346
  If currentState == "CodeControlled" && !abCodeWantsControl ; #DEBUG_LINE_NO:347
    If Game.IsPlayerInDialogue() ; #DEBUG_LINE_NO:349
      Self.GotoState("PlayerInDialogue") ; #DEBUG_LINE_NO:350
    ElseIf Game.IsPlayerInMessageBox() ; #DEBUG_LINE_NO:351
      Self.GotoState("PlayerInMessageBox") ; #DEBUG_LINE_NO:352
    ElseIf Self.IsValidQuestTarget(CurrentQuest, CurrentTarget) && Self.IsValidState(NewState) ; #DEBUG_LINE_NO:353
      Self.GotoState(NewState) ; #DEBUG_LINE_NO:354
    ElseIf Self.IsValidQuestTarget(CurrentQuest, CurrentTarget) ; #DEBUG_LINE_NO:357
      If !Self.IsBestInteractionTarget() ; #DEBUG_LINE_NO:358
        Self.GotoState("SelectingTarget") ; #DEBUG_LINE_NO:359
      ElseIf Self.GetDistance(CurrentTarget) < AcceptableDistance ; #DEBUG_LINE_NO:360
        Game.RequestGameplayBotState(CurrentTarget, InteractState) ; #DEBUG_LINE_NO:362
      Else
        Game.RequestGameplayBotState(CurrentTarget, PathingState) ; #DEBUG_LINE_NO:365
      EndIf
    Else
      Self.CheckTransitionToNewQuestOrTarget() ; #DEBUG_LINE_NO:368
    EndIf
  ElseIf currentState != "CodeControlled" && abCodeWantsControl ; #DEBUG_LINE_NO:372
    Self.GotoState("CodeControlled") ; #DEBUG_LINE_NO:373
  EndIf
EndFunction

Function StartTest()
  Actor currentCombatTarget = None ; #DEBUG_LINE_NO:383
  If Self.IsInCombat() ; #DEBUG_LINE_NO:384
    currentCombatTarget = Self.GetCombatTarget() ; #DEBUG_LINE_NO:385
    Self.StopCombat() ; #DEBUG_LINE_NO:386
  EndIf
  Self.SetupPlayerForRobotTest() ; #DEBUG_LINE_NO:389
  TestSuccessful = True ; #DEBUG_LINE_NO:390
  If currentCombatTarget != None ; #DEBUG_LINE_NO:392
    Self.StartCombat(currentCombatTarget as ObjectReference, False) ; #DEBUG_LINE_NO:393
    CombatTarget = currentCombatTarget as ObjectReference ; #DEBUG_LINE_NO:394
    Game.RequestGameplayBotState(CombatTarget, CombatState) ; #DEBUG_LINE_NO:395
    Self.GotoState("CodeControlled") ; #DEBUG_LINE_NO:396
  Else
    Self.GotoState("SelectingQuest") ; #DEBUG_LINE_NO:398
  EndIf
  While !Self.StateRequestsFinish() ; #DEBUG_LINE_NO:401
    String currentState = Self.GetState() ; #DEBUG_LINE_NO:402
    If currentState != lastState ; #DEBUG_LINE_NO:404
      lastState = currentState ; #DEBUG_LINE_NO:406
    EndIf
    If !TestPaused && Self.GetState() != "CodeControlled" ; #DEBUG_LINE_NO:408
      If Game.IsPlayerInDialogue() && Self.GetState() != "PlayerInDialogue" ; #DEBUG_LINE_NO:409
        Self.GotoState("PlayerInDialogue") ; #DEBUG_LINE_NO:410
      EndIf
      If Game.IsPlayerInMessageBox() && Self.GetState() != "PlayerInMessageBox" ; #DEBUG_LINE_NO:412
        Self.GotoState("PlayerInMessageBox") ; #DEBUG_LINE_NO:413
      EndIf
    EndIf
    Self.UpdateState() ; #DEBUG_LINE_NO:416
    Utility.WaitMenuPause(WaitDuration as Float) ; #DEBUG_LINE_NO:417
  EndWhile
EndFunction

Quest Function SelectQuest()
  Quest[] activeQuestList = Game.GetPlayerActiveQuests() ; #DEBUG_LINE_NO:423
  Quest selectedQuest = None ; #DEBUG_LINE_NO:424
  If activeQuestList.Length > 0 ; #DEBUG_LINE_NO:425
    selectedQuest = activeQuestList[0] ; #DEBUG_LINE_NO:427
  EndIf
  Return selectedQuest ; #DEBUG_LINE_NO:429
EndFunction

ObjectReference Function SelectQuestTarget(Quest aQuest)
  ObjectReference returnTarget = None ; #DEBUG_LINE_NO:435
  If aQuest != None ; #DEBUG_LINE_NO:436
    Int currStage = aQuest.GetStage() ; #DEBUG_LINE_NO:437
    Int Target = 0 ; #DEBUG_LINE_NO:438
    ObjectReference[] targets = aQuest.GetCurrentStageTargets() ; #DEBUG_LINE_NO:440
    If previousStage != currStage ; #DEBUG_LINE_NO:442
      previousStage = currStage ; #DEBUG_LINE_NO:443
    ElseIf targets.Length > 1 ; #DEBUG_LINE_NO:444
      Target = previousTarget + 1 ; #DEBUG_LINE_NO:445
      If Target > targets.Length ; #DEBUG_LINE_NO:447
        Target = 0 ; #DEBUG_LINE_NO:448
      EndIf
    EndIf
    If targets.Length > 0 ; #DEBUG_LINE_NO:452
      returnTarget = targets[Target] ; #DEBUG_LINE_NO:454
    EndIf
    previousTarget = Target ; #DEBUG_LINE_NO:457
  EndIf
  Return returnTarget ; #DEBUG_LINE_NO:459
EndFunction

Bool Function IsBestInteractionTarget()
  Bool isBest = True ; #DEBUG_LINE_NO:463
  If CurrentQuest != None ; #DEBUG_LINE_NO:464
    ObjectReference[] targets = CurrentQuest.GetCurrentStageTargets() ; #DEBUG_LINE_NO:465
    isBest = targets.Length == 1 ; #DEBUG_LINE_NO:466
  EndIf
  Return isBest ; #DEBUG_LINE_NO:468
EndFunction

Actor Function SelectCombatTarget()
  Actor returnTarget = None ; #DEBUG_LINE_NO:472
  Actor player = Game.GetPlayer() ; #DEBUG_LINE_NO:474
  Actor[] allActors = player.GetCurrentLocation().GetActors(None, None) ; #DEBUG_LINE_NO:475
  Float closestDistance = -1.0 ; #DEBUG_LINE_NO:477
  Int actorToTest = 0 ; #DEBUG_LINE_NO:478
  While actorToTest < allActors.Length ; #DEBUG_LINE_NO:479
    If !allActors[actorToTest].IsDead() && !allActors[actorToTest].IsUnconscious() && allActors[actorToTest].IsHostileToActor(player) ; #DEBUG_LINE_NO:480
      Float checkDistance = Self.GetDistance(allActors[actorToTest] as ObjectReference) ; #DEBUG_LINE_NO:481
      If closestDistance < 0.0 || checkDistance < closestDistance ; #DEBUG_LINE_NO:482
        closestDistance = checkDistance ; #DEBUG_LINE_NO:483
        returnTarget = allActors[actorToTest] ; #DEBUG_LINE_NO:484
      EndIf
    EndIf
    actorToTest += 1 ; #DEBUG_LINE_NO:487
  EndWhile
  If returnTarget != None ; #DEBUG_LINE_NO:490
    
  EndIf
  Return returnTarget ; #DEBUG_LINE_NO:496
EndFunction

Bool Function IsValidQuestTarget(Quest aQuest, ObjectReference aQuestTarget)
  Bool returnValue = False ; #DEBUG_LINE_NO:500
  If aQuest != None && aQuestTarget != None ; #DEBUG_LINE_NO:501
    ObjectReference[] targets = aQuest.GetCurrentStageTargets() ; #DEBUG_LINE_NO:502
    Int targetToTest = 0 ; #DEBUG_LINE_NO:503
    While targetToTest < targets.Length && !returnValue ; #DEBUG_LINE_NO:504
      returnValue = targets[targetToTest] == aQuestTarget ; #DEBUG_LINE_NO:505
      targetToTest += 1 ; #DEBUG_LINE_NO:506
    EndWhile
  EndIf
  Return returnValue ; #DEBUG_LINE_NO:509
EndFunction

; Fixup hacks for debug-only function: MakeQuestNameSave
Function MakeQuestNameSave(String asStringToInsertToName)
  String questName = "NoQuest" ; #DEBUG_LINE_NO:513
  Int questStage = 0 ; #DEBUG_LINE_NO:514
  If CurrentQuest != None ; #DEBUG_LINE_NO:515
    questName = questName ; #DEBUG_LINE_NO:516
    questStage = CurrentQuest.GetStage() ; #DEBUG_LINE_NO:517
  EndIf
  String saveName = "RobotTest" + asStringToInsertToName + "_" + questName + "_" + questStage as String ; #DEBUG_LINE_NO:519
EndFunction

Function CheckTransitionToNewQuestOrTarget()
  If Self.GetState() != "Inert" ; #DEBUG_LINE_NO:524
    If CurrentQuest == None || CurrentQuest.IsCompleted() ; #DEBUG_LINE_NO:525
      Self.GotoState("SelectingQuest") ; #DEBUG_LINE_NO:526
    Else
      CurrentTarget = None ; #DEBUG_LINE_NO:528
      Self.GotoState("SelectingTarget") ; #DEBUG_LINE_NO:529
    EndIf
  EndIf
EndFunction

Function SaveAndCheckTransitionToNewQuestOrTarget()
  If Self.GetState() != "Inert" ; #DEBUG_LINE_NO:535
    Self.MakeQuestNameSave("") ; #DEBUG_LINE_NO:536
    Self.CheckTransitionToNewQuestOrTarget() ; #DEBUG_LINE_NO:537
  EndIf
EndFunction

Function SucceedAutomatedTest()
  TestSuccessful = True ; #DEBUG_LINE_NO:543
  Self.GotoState("TestCompleted") ; #DEBUG_LINE_NO:544
EndFunction

Function FailAutomatedTest()
  TestSuccessful = False ; #DEBUG_LINE_NO:550
  Self.GotoState("TestCompleted") ; #DEBUG_LINE_NO:551
EndFunction

Event OnInit()
  ActorValue playerConfidence = Game.GetForm(701) as ActorValue ; #DEBUG_LINE_NO:559
  If playerConfidence != None ; #DEBUG_LINE_NO:560
    Self.SetValue(playerConfidence, 4.0) ; #DEBUG_LINE_NO:561
  EndIf
  Self.GotoState("Idle") ; #DEBUG_LINE_NO:563
EndEvent

; WARNING: possibly inoperative debug function OnPlayerLoadGame
Event OnPlayerLoadGame()
  If !::temp221 ; #DEBUG_LINE_NO:568
    If Self.IsInCombat() ; #DEBUG_LINE_NO:570
      Self.StopCombat() ; #DEBUG_LINE_NO:571
    EndIf
    TestPaused = False ; #DEBUG_LINE_NO:573
    Self.GotoState("Inert") ; #DEBUG_LINE_NO:574
  Else
    Self.CheckTransitionToNewQuestOrTarget() ; #DEBUG_LINE_NO:576
  EndIf
EndEvent

Function DebugTraceAndLogError(String asTextToPrint)
  Debug.AutomatedTestLogError(asTextToPrint) ; #DEBUG_LINE_NO:583
  Debug.Trace((Self as String + " ") + asTextToPrint, 0) ; #DEBUG_LINE_NO:584
EndFunction

Function DebugTraceAndLogProgress(String asTextToPrint)
  Debug.AutomatedTestLogProgress(asTextToPrint) ; #DEBUG_LINE_NO:588
  Debug.Trace((Self as String + " ") + asTextToPrint, 0) ; #DEBUG_LINE_NO:589
EndFunction

Function TogglePauseTest()
  If TestPaused ; #DEBUG_LINE_NO:593
    Self.SetupPlayerForRobotTest() ; #DEBUG_LINE_NO:595
    TestPaused = False ; #DEBUG_LINE_NO:596
    If CurrentQuest == None || CurrentQuest.IsCompleted() ; #DEBUG_LINE_NO:597
      Self.GotoState("SelectingQuest") ; #DEBUG_LINE_NO:598
    Else
      CurrentTarget = None ; #DEBUG_LINE_NO:600
      Self.GotoState("SelectingTarget") ; #DEBUG_LINE_NO:601
    EndIf
  Else
    Self.ResetPlayerStateFromRobotTest() ; #DEBUG_LINE_NO:605
    TestPaused = True ; #DEBUG_LINE_NO:607
    Self.GotoState("Inert") ; #DEBUG_LINE_NO:608
  EndIf
EndFunction

Function SetupPlayerForRobotTest()
  If DisableForTesting == None ; #DEBUG_LINE_NO:613
    DisableForTesting = inputenablelayer.Create() ; #DEBUG_LINE_NO:614
    DisableForTesting.DisablePlayerControls(False, True, True, False, True, False, False, True, True, True, False) ; #DEBUG_LINE_NO:615
  EndIf
EndFunction

Function ResetPlayerStateFromRobotTest()
  DisableForTesting = None ; #DEBUG_LINE_NO:620
EndFunction

Function RoboKillAllHostile()
  Actor player = Game.GetPlayer() ; #DEBUG_LINE_NO:635
  Actor[] allCombatTargetActors = player.GetAllCombatTargets() ; #DEBUG_LINE_NO:636
  Int actorToTest = 0 ; #DEBUG_LINE_NO:638
  While actorToTest < allCombatTargetActors.Length ; #DEBUG_LINE_NO:639
    If !allCombatTargetActors[actorToTest].IsDead() && !allCombatTargetActors[actorToTest].IsUnconscious() ; #DEBUG_LINE_NO:640
      allCombatTargetActors[actorToTest].Kill(None) ; #DEBUG_LINE_NO:642
    EndIf
    actorToTest += 1 ; #DEBUG_LINE_NO:644
  EndWhile
  spaceshipreference playerSpaceship = Self.GetCurrentShipRef() ; #DEBUG_LINE_NO:648
  spaceshipreference[] allCombatTargetShips = playerSpaceship.GetAllCombatTargets() ; #DEBUG_LINE_NO:649
  Int shipToTest = 0 ; #DEBUG_LINE_NO:651
  While shipToTest < allCombatTargetShips.Length ; #DEBUG_LINE_NO:652
    allCombatTargetShips[shipToTest].Kill(None) ; #DEBUG_LINE_NO:654
    shipToTest += 1 ; #DEBUG_LINE_NO:655
  EndWhile
EndFunction

;-- State -------------------------------------------
State CodeControlled

  Event OnBeginState(String asOldState)
    ; Empty function
  EndEvent

  Bool Function StateRequestsFinish()
    Return False
  EndFunction
EndState

;-- State -------------------------------------------
State Idle

  Event OnBeginState(String asOldState)
    ; Empty function
  EndEvent

  Event OnEndState(String asNewState)
    ; Empty function
  EndEvent
EndState

;-- State -------------------------------------------
State Inert

  Bool Function StateRequestsFinish()
    Return !TestPaused
  EndFunction

  Event OnBeginState(String asOldState)
    Self.ResetPlayerStateFromRobotTest() ; #DEBUG_LINE_NO:307
  EndEvent
EndState

;-- State -------------------------------------------
State PlayerInDialogue

  Event OnEndState(String asNewState)
    ; Empty function
  EndEvent

  ; Fixup hacks for debug-only function: UpdateState
  Function UpdateState()
    If CurrentTimePassedInDialog > MaxTimeBeforeDialogFailure
      Self.FailAutomatedTest()
    Else
      CurrentTimePassedInDialog += WaitDuration
      Bool IsPlayerInDialogue = Game.IsPlayerInDialogue()
      If IsPlayerInDialogue
        Actor dialogueActor = None
        If dialogueActor != None && Self.GetParentCell() != dialogueActor.GetParentCell()
          Self.FailAutomatedTest()
        EndIf
        Int[] topics = Game.GetPlayerActiveDialogueUnsaidInfo()
        Int choiceIndex = -1
        Int topicIndex = 0
        While choiceIndex == -1 && topicIndex < topics.Length
          If topics[topicIndex] > 0
            choiceIndex = topicIndex
          EndIf
          topicIndex += 1
        EndWhile
        If choiceIndex != -1
          Game.RequestDialogueSelect(choiceIndex)
        ElseIf DialogueStateIterator == Self.Dialogue_Substate_Exit
          Game.RequestDialogueExit()
        ElseIf DialogueStateIterator == Self.Dialogue_Substate_Skip
          Game.RequestDialogueSkip()
        EndIf
        DialogueStateIterator = (DialogueStateIterator + 1) % Self.Dialogue_Substate_MAX
      Else
        Self.SaveAndCheckTransitionToNewQuestOrTarget()
      EndIf
    EndIf
  EndFunction

  Event OnBeginState(String asOldState)
    CurrentTimePassedInDialog = 0 ; #DEBUG_LINE_NO:218
    DialogueStateIterator = Self.Dialogue_Substate_Exit ; #DEBUG_LINE_NO:219
  EndEvent
EndState

;-- State -------------------------------------------
State PlayerInMessageBox

  Event OnBeginState(String asOldState)
    ; Empty function
  EndEvent

  Event OnEndState(String asNewState)
    ; Empty function
  EndEvent

  Function UpdateState()
    If Game.IsPlayerInMessageBox()
      Game.RequestMessageBoxSelect(1)
    Else
      Self.CheckTransitionToNewQuestOrTarget()
    EndIf
  EndFunction
EndState

;-- State -------------------------------------------
State SelectingQuest

  Event OnEndState(String asNewState)
    ; Empty function
  EndEvent

  Function UpdateState()
    If CurrentQuest != None && CurrentQuest.IsCompleted()
      QuestsComplete += 1
      If QuestsComplete >= MaxQuestsToComplete
        Self.SucceedAutomatedTest()
        Return 
      EndIf
      CurrentQuest = None
    EndIf
    If CurrentQuest == None
      CurrentQuest = Self.SelectQuest()
    EndIf
    If CurrentQuest != None
      Self.GotoState("SelectingTarget")
    Else
      CurrentTimePassedSelectingQuest += WaitDuration
      If CurrentTimePassedSelectingQuest > MaxTimeBeforeFailureSelectingQuest
        Self.FailAutomatedTest()
      EndIf
    EndIf
  EndFunction

  Event OnBeginState(String asOldState)
    CurrentTimePassedSelectingQuest = 0 ; #DEBUG_LINE_NO:76
  EndEvent
EndState

;-- State -------------------------------------------
State SelectingTarget

  Event OnEndState(String asNewState)
    ; Empty function
  EndEvent

  Function UpdateState()
    ObjectReference prospectiveTarget = Self.SelectQuestTarget(CurrentQuest)
    If prospectiveTarget != None
      spaceshipreference playerSpaceship = Self.GetCurrentShipRef()
      Bool inCombatWithPlayer = False
      Actor targetActor = prospectiveTarget as Actor
      spaceshipreference targetShip = prospectiveTarget as spaceshipreference
      If targetActor != None
        Actor[] combatTargets = targetActor.GetAllCombatTargets()
        Int combatTargetIndex = 0
        While combatTargetIndex < combatTargets.Length && !inCombatWithPlayer
          inCombatWithPlayer = combatTargets[combatTargetIndex] == Self as Actor
          combatTargetIndex += 1
        EndWhile
      ElseIf targetShip != None
        spaceshipreference[] combattargets = targetShip.GetAllCombatTargets()
        Int combattargetindex = 0
        While combattargetindex < combattargets.Length && !inCombatWithPlayer
          inCombatWithPlayer = combattargets[combattargetindex] == playerSpaceship
          combattargetindex += 1
        EndWhile
      EndIf
      If inCombatWithPlayer
        If targetActor
          CombatTarget = targetActor as ObjectReference
        Else
          CombatTarget = targetShip as ObjectReference
        EndIf
        Self.MakeGameplayBotRequest(CombatTarget, CombatState)
        Self.GotoState("CodeControlled")
      ElseIf prospectiveTarget == Self.GetFurnitureUsing()
        Keyword PilotSeatKeyword = Game.GetForm(22055) as Keyword
        If prospectiveTarget.HasKeyword(PilotSeatKeyword)
          If playerSpaceship
            playerSpaceship.TakeOff()
          EndIf
        EndIf
      ElseIf Self.GetDistance(prospectiveTarget) < AcceptableDistance
        CurrentTarget = prospectiveTarget
        Self.MakeGameplayBotRequest(CurrentTarget, InteractState)
        Self.GotoState("CodeControlled")
      Else
        CurrentTarget = prospectiveTarget
        Self.MakeGameplayBotRequest(CurrentTarget, PathingState)
        Self.GotoState("CodeControlled")
      EndIf
    Else
      CombatTarget = Self.SelectCombatTarget() as ObjectReference
      If CombatTarget != None
        Self.MakeGameplayBotRequest(CombatTarget, CombatState)
        Self.GotoState("CodeControlled")
      Else
        CurrentTimePassedSelectingTarget += WaitDuration
        If CurrentTimePassedSelectingTarget > MaxTimeBeforeFailureSelectingTarget
          Self.FailAutomatedTest()
        ElseIf CurrentTimePassedSelectingTarget > MaxTimeBeforeKillAllSelectingTarget
          Self.RoboKillAllHostile()
        EndIf
      EndIf
    EndIf
  EndFunction

  Event OnBeginState(String asOldState)
    CurrentTimePassedSelectingTarget = 0 ; #DEBUG_LINE_NO:121
  EndEvent
EndState

;-- State -------------------------------------------
State TestCompleted

  Bool Function StateRequestsFinish()
    Return True
  EndFunction

  Event OnBeginState(String asOldState)
    Self.ResetPlayerStateFromRobotTest() ; #DEBUG_LINE_NO:298
  EndEvent
EndState
