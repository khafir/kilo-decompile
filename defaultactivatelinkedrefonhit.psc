ScriptName DefaultActivateLinkedRefOnHit Extends DefaultRefOnHit default
{ Activates the specified linked ref when THIS object is hit.
<RefToCheck> is the reference hitting THIS Object.
<LocationToCheck> is the current location of THIS object. }

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Group Quest_Properties collapsedonbase collapsedonref
{ Double-Click to EXPAND }
  Bool Property xxxPlaceHolderForEmptyGroup2xxx Auto Const hidden
  { `TTP-27034: Papyrus: Need a way to manage groups across parents and children` }
EndGroup

Group Script_Specific_Properties
  Keyword Property LinkedRefKeyword Auto Const
  { The Keyword of the LinkedRef you want to activate when this activated. }
  Bool Property ShouldUseLinkedRefChain = False Auto Const
  { (Default: false) If true, will execute over the entire Linked Ref Chain. }
  Bool Property ActivatorIsRefToCheck = True Auto Const
  { If true (default), Activate function's akActivator param will be <RefToCheck>. If false, akActivator param will be THIS object. }
EndGroup


;-- Functions ---------------------------------------

ObjectReference[] Function GetRefsToDoSpecificThingsWith()
  If ShouldUseLinkedRefChain ; #DEBUG_LINE_NO:25
    Return Self.GetLinkedRefChain(LinkedRefKeyword, 100) ; #DEBUG_LINE_NO:27
  Else
    Return Self.GetLinkedRef(LinkedRefKeyword).GetSingleRefArray() ; #DEBUG_LINE_NO:29
  EndIf
EndFunction

Function DoSpecificThing(defaultscriptfunctions:parentscriptfunctionparams ParentScriptFunctionParams, ObjectReference RefToDoThingWith, Bool LastRefToDoThingWith)
  ObjectReference ActivatorRef = Self as ObjectReference ; #DEBUG_LINE_NO:35
  If ActivatorIsRefToCheck ; #DEBUG_LINE_NO:36
    ActivatorRef = ParentScriptFunctionParams.RefToCheck ; #DEBUG_LINE_NO:37
  EndIf
  RefToDoThingWith.Activate(ActivatorRef, False) ; #DEBUG_LINE_NO:41
EndFunction
