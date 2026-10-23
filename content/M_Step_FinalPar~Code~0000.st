// METHOD: M_Step_FinalParkingCompletition

FrameTypeTransform_FeedIn.Execute := FALSE;
FrameTypeTransform_FeedOut.Execute := FALSE;        
CalcFrameOffset_Group.Enable := FALSE;
GroupSetFrameOffset_FeedIn.Execute := FALSE;
GroupSetFrameOffset_FeedOut.Execute := FALSE;

M_Step_FinalParkingCompletition := E_StepStatus#DONE;