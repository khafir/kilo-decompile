ScriptName Fragments:TopicInfos:TIF_DialogueFCNeon_00160145 Extends TopicInfo Const hidden

;-- Functions ---------------------------------------

Function Fragment_Begin(ObjectReference akSpeakerRef)
  Actor akSpeaker = akSpeakerRef as Actor ; #DEBUG_LINE_NO:6
  fcneon_kosmosorgresourcesscript kmyQuest = Self.GetOwningQuest() as fcneon_kosmosorgresourcesscript ; #DEBUG_LINE_NO:8
  kmyQuest.UpdatePlayerResourceCounts() ; #DEBUG_LINE_NO:11
EndFunction
