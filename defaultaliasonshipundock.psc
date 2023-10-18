ScriptName DefaultAliasOnShipUndock Extends DefaultAlias default
{ Sets stage when this ship undocks from another ship.
<QuestToSetOrCheck> is THIS Alias's GetOwningQuest()
<RefToCheck> is based on the value of WhichShipToCheck - see below
<LocationToCheck> is the current location of THIS Alias's reference. }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Group Script_Specific_Properties
  Bool Property SetStageWhenUndockingComplete = True Auto Const
  { If true (default), stage will be set when undocking is complete; if false, stage will be set when undocking begins. }
  Int Property WhichShipToCheck = 0 Auto Const
  { 0 = check both docking ships
	 1 = check this ship only
	 2 = check the other ship only }
EndGroup


;-- Functions ---------------------------------------

Event OnShipUndock(Bool abComplete, spaceshipreference akUndocking, spaceshipreference akParent)
  If SetStageWhenUndockingComplete == abComplete ; #DEBUG_LINE_NO:20
    Location currentLocation = Self.TryToGetCurrentLocation() ; #DEBUG_LINE_NO:23
    spaceshipreference myShip = Self.GetShipRef() ; #DEBUG_LINE_NO:24
    spaceshipreference otherShip = None ; #DEBUG_LINE_NO:25
    If myShip == akUndocking ; #DEBUG_LINE_NO:26
      otherShip = akParent ; #DEBUG_LINE_NO:27
    Else
      otherShip = akUndocking ; #DEBUG_LINE_NO:29
    EndIf
    If WhichShipToCheck == 0 || WhichShipToCheck == 1 ; #DEBUG_LINE_NO:32
      defaultscriptfunctions:parentscriptfunctionparams ParentScriptFunctionParams = defaultscriptfunctions.BuildParentScriptFunctionParams(myShip as ObjectReference, currentLocation, None) ; #DEBUG_LINE_NO:34
      Self.CheckAndSetStageAndCallDoSpecificThing(ParentScriptFunctionParams) ; #DEBUG_LINE_NO:36
    EndIf
    If WhichShipToCheck == 0 || WhichShipToCheck == 2 ; #DEBUG_LINE_NO:39
      defaultscriptfunctions:parentscriptfunctionparams parentscriptfunctionparams = defaultscriptfunctions.BuildParentScriptFunctionParams(otherShip as ObjectReference, currentLocation, None) ; #DEBUG_LINE_NO:41
      Self.CheckAndSetStageAndCallDoSpecificThing(parentscriptfunctionparams) ; #DEBUG_LINE_NO:43
    EndIf
    If WhichShipToCheck < -1 || WhichShipToCheck > 2 ; #DEBUG_LINE_NO:46
      
    EndIf
  EndIf
EndEvent
