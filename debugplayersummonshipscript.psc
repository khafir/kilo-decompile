ScriptName DebugPlayerSummonShipScript Extends Actor Const

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property Frontier_ModularREF Auto Const mandatory
Keyword Property SpaceshipEnabledLandingLink Auto Const mandatory
Furniture Property ShipLandingMarker Auto Const mandatory
sq_playershipscript Property SQ_PlayerShip Auto Const mandatory

;-- Functions ---------------------------------------

Event OnHomeShipSet(spaceshipreference akShip, spaceshipreference akPrevious)
  ; Empty function
EndEvent

Event OnPlayerArrested(ObjectReference akGuard, Location akLocation, Int aeCrimeType)
  ; Empty function
EndEvent

Event OnPlayerAssaultActor(ObjectReference akVictim, Location akLocation, Bool aeCrime)
  ; Empty function
EndEvent

Event OnPlayerCompleteResearch(ObjectReference akBench, Location akLocation, researchproject akProject)
  ; Empty function
EndEvent

Event OnPlayerCrimeGold(ObjectReference akVictim, Form akFaction, Int aeCrimeGold, Int aeCrimeType)
  ; Empty function
EndEvent

Event OnPlayerJail(ObjectReference akGuard, Form akFaction, Location akLocation, Int aeCrimeGold)
  ; Empty function
EndEvent

Event OnPlayerPayFine(ObjectReference akGuard, Form akFaction, Int aeCrimeGold)
  ; Empty function
EndEvent

Event OnPlayerPlanetSurveyComplete(planet akPlanet)
  ; Empty function
EndEvent

Event OnPlayerScannedObject(ObjectReference akScannedRef)
  ; Empty function
EndEvent

Event OnPlayerTrespass(ObjectReference akVictim, Location akLocation, Bool aeCrime)
  ; Empty function
EndEvent

Function DebugSummonShip()
  ObjectReference markerRef = Self.PlaceAtMe(ShipLandingMarker as Form, 1, False, False, True, None, None, True) ; #DEBUG_LINE_NO:9
  Frontier_ModularREF.MoveTo(markerRef, 0.0, 0.0, 0.0, True, False) ; #DEBUG_LINE_NO:10
  Frontier_ModularREF.setlinkedref(markerRef, SpaceshipEnabledLandingLink, True) ; #DEBUG_LINE_NO:11
  Frontier_ModularREF.Enable(False) ; #DEBUG_LINE_NO:12
  SQ_PlayerShip.ResetHomeShip(Frontier_ModularREF as spaceshipreference) ; #DEBUG_LINE_NO:13
EndFunction

Function testGetDayLength()
  Self.GetDayLength() ; #DEBUG_LINE_NO:17
EndFunction
