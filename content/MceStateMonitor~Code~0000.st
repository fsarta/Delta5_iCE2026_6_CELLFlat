(*
 * -----------------------------------------------------------------------------
 * Name               : MceStateMonitoring
 * Version            : 0.2.0
 * Date               : 2026-02-18
 * Author             : deGroot
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Monitoring logic for a state machine, returns elapsed time [ms]
 * -----------------------------------------------------------------------------
 *)

// -----------------------------------------------------------------------------
// detect state change
// -----------------------------------------------------------------------------
IF nState <> stateData.nStateStored THEN
  stateData.nStatePrevious := stateData.nStateStored ;
  stateData.bOsrStateChange := TRUE;
  stateData.nStateStored := nState;
ELSE
  stateData.bOsrStateChange := FALSE;
END_IF;


// -----------------------------------------------------------------------------
// time state active
// -----------------------------------------------------------------------------
tNow := TO_LTIME(GET_MICROSECONDS(TRUE) * ULINT#1000); // system clock in ns resolution
IF (tNow > stateData.tStored) THEN
  nTdiff := TO_DINT(TO_TIME(tNow - stateData.tStored)) / 1000;
  IF (nState <> 0) AND (nTdiff > 0) AND NOT bFreezeTimer THEN
    stateData.nStateTimeUs := stateData.nStateTimeUs + nTdiff;
  END_IF;
END_IF;

stateData.tStored := tNow;
stateData.nStateTime := TO_DINT(TO_LREAL(stateData.nStateTimeUs) / 1000);

// store and reset timer at state change
IF stateData.bOsrStateChange THEN
  stateData.nStateTimePrevious := stateData.nStateTime;
  stateData.nStateTimeUs := 0;
  stateData.nStateTime := 0;
END_IF;

MceStateMonitoring := stateData.nStateTime;

