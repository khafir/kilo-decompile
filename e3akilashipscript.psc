ScriptName E3AkilaShipScript Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property AkilaLandingMarker Auto Const mandatory
Keyword Property SpaceshipEnabledLandingLink Auto Const mandatory
spaceshipbase Property DefaultShip Auto Const mandatory

;-- Functions ---------------------------------------

Function SpawnAkilaShip(spaceshipbase ShiptoSpawn, Int shipTakeOffTimer, Bool StartLanded)
  If ShiptoSpawn == None ; #DEBUG_LINE_NO:9
    ShiptoSpawn = DefaultShip ; #DEBUG_LINE_NO:10
  EndIf
  spaceshipreference SpaceshipREF = AkilaLandingMarker.PlaceShipAtMe(ShiptoSpawn as Form, 4, True, False, True, True, None, None, None, True) ; #DEBUG_LINE_NO:14
  If StartLanded ; #DEBUG_LINE_NO:17
    SpaceshipREF.SetLinkedRef(AkilaLandingMarker, None, True) ; #DEBUG_LINE_NO:18
  Else
    SpaceshipREF.SetLinkedRef(AkilaLandingMarker, SpaceshipEnabledLandingLink, True) ; #DEBUG_LINE_NO:20
  EndIf
  SpaceshipREF.EnableNoWait(False) ; #DEBUG_LINE_NO:23
  While SpaceshipREF.IsLanded() == False ; #DEBUG_LINE_NO:25
    Utility.Wait(0.5) ; #DEBUG_LINE_NO:26
  EndWhile
  If shipTakeOffTimer == 0 ; #DEBUG_LINE_NO:29
    shipTakeOffTimer = 5 ; #DEBUG_LINE_NO:30
  EndIf
  Utility.Wait(shipTakeOffTimer as Float) ; #DEBUG_LINE_NO:33
  SpaceshipREF.TakeOff() ; #DEBUG_LINE_NO:34
EndFunction
