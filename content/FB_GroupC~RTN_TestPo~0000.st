if DATA_GROUP.Command.TestGroup then
	DATA_GROUP.Status.TestGroupRunning := true;
	case IDX_TestGroup_State of
	    E_TestGroupState#IDLE:
            IDX_TestGroup_Index := 0;
            IDX_TestGroup_State := E_TestGroupState#LOAD_PARAMS;
            
		E_TestGroupState#LOAD_PARAMS: (*	Load Index Data And Set The Mission *)
			DATA_GROUP.Setting.MoveLinearAbsolute.Position := DATA_GROUP.Setting.TestGroupSetting[IDX_TestGroup_Index].Position;
			DATA_GROUP.Setting.MoveLinearAbsolute.Velocity := DATA_GROUP.Setting.TestGroupSetting[IDX_TestGroup_Index].Speed;
			DATA_GROUP.Setting.MoveLinearAbsolute.Acceleration :=DATA_GROUP.Setting.TestGroupSetting[IDX_TestGroup_Index].Acc;
			DATA_GROUP.Setting.MoveLinearAbsolute.Deceleration :=DATA_GROUP.Setting.TestGroupSetting[IDX_TestGroup_Index].Dec;
			DATA_GROUP.Setting.MoveLinearAbsolute.CoordSystem := MC_CoordinateSystem#MCS;
			IDX_TestGroup_State:=E_TestGroupState#EXECUTE_MOVE;

		E_TestGroupState#EXECUTE_MOVE: (*	Execute Positioning *)
			DATA_GROUP.Command.En_MoveLinearAbsolute := true;
			if DATA_GROUP.Status.MoveLinearAbsolute.Done then			
				DATA_GROUP.Command.En_MoveLinearAbsolute := false;
				IDX_TestGroup_State := E_TestGroupState#WAIT_DELAY;
			end_if;

		E_TestGroupState#WAIT_DELAY: (*	Wait For Delay (ticks releated to the communication cycle) *)
			IDX_Count001 := IDX_Count001 + 1;
			if IDX_Count001 >= DATA_GROUP.Setting.TestGroupSetting[IDX_TestGroup_Index].Delay then
				IDX_Count001 := 0;
				IDX_TestGroup_State := E_TestGroupState#ADVANCE_INDEX;
			end_if;
		E_TestGroupState#ADVANCE_INDEX: (*	Increase The Index And Restart *)
			IDX_TestGroup_Index := IDX_TestGroup_Index + 1;
			if IDX_TestGroup_Index >= 6 then
				IDX_TestGroup_Index := 0;
			end_if;
			IDX_TestGroup_State := E_TestGroupState#LOAD_PARAMS;
	end_case;
else
	if DATA_GROUP.Status.TestGroupRunning then
		DATA_GROUP.Status.TestGroupRunning := false;
		DATA_GROUP.Command.En_MoveLinearAbsolute := false;
	end_if;
	IDX_TestGroup_State := E_TestGroupState#IDLE;
	IDX_Count001 := 0;
	IDX_TestGroup_Index := 0;
end_if;