// --- Trigger Management ---
// Detect simple button presses from HMI
trigExec(CLK := Execute);

IF trigExec.Q THEN
    CASE PointSelect OF
        eFrame#NONE:
            FramesData.aFrameResult[FrameIndex].OO := FramesData.aTeachFrame[FrameIndex].OO;
            FramesData.aFrameResult[FrameIndex].XX := FramesData.aTeachFrame[FrameIndex].XX;
            FramesData.aFrameResult[FrameIndex].XY := FramesData.aTeachFrame[FrameIndex].XY;
        eFrame#OO:
            FramesData.aFrameResult[FrameIndex].OO := CurrentPos;
            FramesData.aFrameResult[FrameIndex].XX := FramesData.aTeachFrame[FrameIndex].XX;
            FramesData.aFrameResult[FrameIndex].XY := FramesData.aTeachFrame[FrameIndex].XY;
        eFrame#XX:
            FramesData.aFrameResult[FrameIndex].OO := FramesData.aTeachFrame[FrameIndex].OO;
            FramesData.aFrameResult[FrameIndex].XX := CurrentPos;
            FramesData.aFrameResult[FrameIndex].XY := FramesData.aTeachFrame[FrameIndex].XY;
        eFrame#XY:
            FramesData.aFrameResult[FrameIndex].OO := FramesData.aTeachFrame[FrameIndex].OO;
            FramesData.aFrameResult[FrameIndex].XX := FramesData.aTeachFrame[FrameIndex].XX;
            FramesData.aFrameResult[FrameIndex].XY := CurrentPos;
    END_CASE;
END_IF;                
    