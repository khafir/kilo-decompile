ScriptName OutpostBuilderMenuScript Extends ObjectReference Const

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Keyword Property LinkOutpostBuilder Auto Const mandatory
{ linked ref keyword to builder }

;-- Functions ---------------------------------------

Event OnActivate(ObjectReference akActionRef)
  If akActionRef == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:7
    ObjectReference myBuilder = Self.GetLinkedRef(LinkOutpostBuilder) ; #DEBUG_LINE_NO:8
    If myBuilder ; #DEBUG_LINE_NO:10
      myBuilder.ShowWorkshopBuilderMenu() ; #DEBUG_LINE_NO:11
    Else
      Self.ShowWorkshopBuilderMenu() ; #DEBUG_LINE_NO:13
    EndIf
  EndIf
EndEvent
