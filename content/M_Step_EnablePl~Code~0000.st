// METHOD: M_Step_EnablePlaceTracking
// DESCRIPTION: Activates conveyor tracking for Feed Out.

// 1. Entry
IF NOT bStepInitialized THEN
   // Configure the conveyor tracking function block
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[1] := FeedOut_FrameOffset.X;
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[2] := FeedOut_FrameOffset.Y;
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[3] := FeedOut_FrameOffset.Z;
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[4] := FeedOut_FrameOffset.Rx;
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[5] := FeedOut_FrameOffset.Ry;
	TrackConveyorBelt_FeedOut.ConveyorBeltOrigin[6] := FeedOut_FrameOffset.Rz;
    
	TrackConveyorBelt_FeedOut.InitialObjectPosition[1] := ActProdX_Place; // Initial object position, x-coordinate
	TrackConveyorBelt_FeedOut.InitialObjectPosition[2] := ActProdY_Place; // Initial object position, y-coordinate
	TrackConveyorBelt_FeedOut.InitialObjectPosition[6] := -FeedOut_FrameOffset.Rz; //ActProdRz_Place; // Initial object position, z-coordinate

	// Configure synchronization options for tracking
	TrackConveyorBelt_FeedOut.TrackOptions.SyncIn.Mode := Yt_TrackProfileMode#MasterDistance;
	TrackConveyorBelt_FeedOut.TrackOptions.SyncIn.ConveyorDistance := 10.0; // Defines the distance traveled by conveyor during SyncIn
	TrackConveyorBelt_FeedOut.TrackOptions.SyncIn.TCPDistance := TrackConveyorBelt_FeedOut.TrackOptions.SyncIn.ConveyorDistance / 2.0; // Defines the distance the TCP travels during SyncIn
	TrackConveyorBelt_FeedOut.TrackOptions.SyncOut.ConveyorDistance := 15.0;
	
	// Select the conveyor belt axis and tracking distances based on the active mode
	TrackConveyorBelt_FeedOut.ConveyorBelt := FeedOut_Ref;
	TrackConveyorBelt_FeedOut.StartDistance := 10.0; // Start tracking distance on the conveyor
	TrackConveyorBelt_FeedOut.EndDistance := 200.0; // End tracking distance on the conveyor
	TrackConveyorBelt_FeedOut.RecordedPosition := DATA_FeedOutAxis.Feedback.ActualPosition; // Use the actual rotary axis position as the recorded position
        	
    TrackConveyorBelt_FeedOut.Execute := TRUE;
    
    bStepInitialized := TRUE;
    M_Step_EnablePlaceTracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic
IF TrackConveyorBelt_FeedOut.Active THEN
    M_Step_EnablePlaceTracking := E_StepStatus#DONE;
ELSIF TrackConveyorBelt_FeedOut.Error THEN
    M_Step_EnablePlaceTracking := E_StepStatus#ERROR;
ELSE
    M_Step_EnablePlaceTracking := E_StepStatus#BUSY;
END_IF;