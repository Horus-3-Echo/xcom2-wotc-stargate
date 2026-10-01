class XComGameState_StargateProgram extends XComGameState_BaseObject;

// Persisted guard for the one prototype offer. Later milestones may extend this
// state with expedition outcome and reward fields without replacing mission IDs.
var bool bPrototypeMissionCreated;
var StateObjectReference PrototypeMissionRef;
