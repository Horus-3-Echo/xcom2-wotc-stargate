class X2StargateMissionFactory extends Object;

static function bool EnsurePrototypeMission()
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_StargateProgram ProgramState;
    local XComGameState_MissionSite MissionState;
    local X2StrategyElementTemplateManager StrategyManager;
    local X2MissionSourceTemplate MissionSource;
    local X2RewardTemplate RewardTemplate;
    local XComGameState_Reward RewardState;
    local array<XComGameState_Reward> MissionRewards;
    local StateObjectReference RegionRef;
    local Vector2D MissionLocation;

    History = `XCOMHISTORY;

    foreach History.IterateByClassType(class'XComGameState_StargateProgram', ProgramState)
    {
        break;
    }

    if (ProgramState != none && ProgramState.bPrototypeMissionCreated)
    {
        return false;
    }

    // Reconcile an already active site before creating anything. This protects
    // old saves and any previous partially installed source revision.
    foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
    {
        if (MissionState.Source == 'MissionSource_StargatePrototype' && MissionState.Available)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(
                "WSG: reconcile prototype mission");

            if (ProgramState == none)
            {
                ProgramState = XComGameState_StargateProgram(
                    NewGameState.CreateNewStateObject(class'XComGameState_StargateProgram'));
            }
            else
            {
                ProgramState = XComGameState_StargateProgram(
                    NewGameState.ModifyStateObject(class'XComGameState_StargateProgram', ProgramState.ObjectID));
            }

            ProgramState.bPrototypeMissionCreated = true;
            ProgramState.PrototypeMissionRef = MissionState.GetReference();
            `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
            `LOG("[WSG] prototype-mission-reconciled id=" $ MissionState.ObjectID, true, 'StargateWOTC');
            return true;
        }
    }

    StrategyManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    MissionSource = X2MissionSourceTemplate(
        StrategyManager.FindStrategyElementTemplate('MissionSource_StargatePrototype'));
    RewardTemplate = X2RewardTemplate(
        StrategyManager.FindStrategyElementTemplate('Reward_None'));

    if (MissionSource == none || RewardTemplate == none)
    {
        `LOG("[WSG] prototype-mission-deferred missing-template", true, 'StargateWOTC');
        return false;
    }

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(
        "WSG: create prototype mission");

    if (ProgramState == none)
    {
        ProgramState = XComGameState_StargateProgram(
            NewGameState.CreateNewStateObject(class'XComGameState_StargateProgram'));
    }
    else
    {
        ProgramState = XComGameState_StargateProgram(
            NewGameState.ModifyStateObject(class'XComGameState_StargateProgram', ProgramState.ObjectID));
    }

    RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
    MissionRewards.AddItem(RewardState);
    MissionState = XComGameState_MissionSite(
        NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));

    MissionLocation = class'XComGameState_MissionSite'.static.SelectRandomMissionLocation(RegionRef);
    MissionState.BuildMission(MissionSource, MissionLocation, RegionRef, MissionRewards, true, false);

    if (MissionState.GeneratedMission.Mission.sType == "")
    {
        History.CleanupPendingGameState(NewGameState);
        `LOG("[WSG] prototype-mission-deferred no-mission-definition", true, 'StargateWOTC');
        return false;
    }

    ProgramState.bPrototypeMissionCreated = true;
    ProgramState.PrototypeMissionRef = MissionState.GetReference();

    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    `HQPRES.StrategyMap2D.UpdateMissions();
    `LOG("[WSG] prototype-mission-created id=" $ MissionState.ObjectID $
         " type=" $ MissionState.GeneratedMission.Mission.sType, true, 'StargateWOTC');

    return true;
}
