ScriptName Fragments:Scenes:SF_MQ207C_610_FacilitiesArea_00226536 Extends Scene Const hidden

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ReferenceAlias Property Alias_AnnouncementMarker Auto Const

;-- Functions ---------------------------------------

Function Fragment_Begin()
  Alias_AnnouncementMarker.TryToMoveTo(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:7
EndFunction
