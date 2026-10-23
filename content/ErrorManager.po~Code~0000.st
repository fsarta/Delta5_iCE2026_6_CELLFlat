// 1. HMI Control Mapping
// G_bResetAllErrors := HMI_bResetButton;
// G_bAcknowledgeAllErrors := HMI_bAckButton;

// 2. Call to the Update method (Consumer)
// Clear all queues (related to tasks number)) and update the history array
fbErrorHandler.Update();
