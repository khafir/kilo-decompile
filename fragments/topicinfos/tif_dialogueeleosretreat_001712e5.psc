ScriptName Fragments:TopicInfos:TIF_DialogueEleosRetreat_001712E5 Extends TopicInfo Const hidden

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property City_ER_Dead Auto Const mandatory

;-- Functions ---------------------------------------

Function Fragment_End(ObjectReference akSpeakerRef)
  Actor akSpeaker = akSpeakerRef as Actor ; #DEBUG_LINE_NO:6
  City_ER_Dead.Start() ; #DEBUG_LINE_NO:8
EndFunction
