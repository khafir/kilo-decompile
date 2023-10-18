ScriptName Fragments:TopicInfos:TIF_DialogueRedMile_0013E667 Extends TopicInfo Const hidden

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property DialogueShipServices Auto Const mandatory

;-- Functions ---------------------------------------

Function Fragment_Begin(ObjectReference akSpeakerRef)
  Actor akSpeaker = akSpeakerRef as Actor ; #DEBUG_LINE_NO:6
  (DialogueShipServices as dialogueshipservicesscript).RefuelPlayerShip() ; #DEBUG_LINE_NO:8
EndFunction
