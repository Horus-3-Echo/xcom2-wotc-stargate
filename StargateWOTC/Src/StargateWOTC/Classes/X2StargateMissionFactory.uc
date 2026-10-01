class X2StargateMissionFactory extends Object;

static function bool EnsurePrototypeMission()
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_StargateProgram ProgramState;
    local XComGameState_MissionSite MissionState;
    History = `XCOMHISTORY;

    foreach History.IterateByClassType(class'XComGameState_StargateProgram', ProgramState)
    {
        break;
    }

    // Find the active site before trusting the guard. Version 0.2.1 persisted
    // a base MissionSite which the stock HQ UI cannot dispatch; it must be
    // replaced once even though the guard is already true.
    foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
    {
        if (MissionState.Source == 'MissionSource_StargatePrototype' && MissionState.Available)
        {
            if (XComGameState_MissionSite_Stargate(MissionState) == none)
            {
                return CreatePrototypeMission(ProgramState, MissionState);
            }

            if (ProgramState == none || !ProgramState.bPrototypeMissionCreated ||
                ProgramState.PrototypeMissionRef.ObjectID != MissionState.ObjectID)
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

            return false;
        }
    }

    if (ProgramState != none && ProgramState.bPrototypeMissionCreated)
    {
        return false;
    }

    return CreatePrototypeMission(ProgramState);
}

static function bool CreatePrototypeMission(
    XComGameState_StargateProgram ProgramState,
    optional XComGameState_MissionSite PreviousMission)
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_MissionSite OldMissionState;
    local XComGameState_MissionSite_Stargate MissionState;
    local X2StrategyElementTemplateManager StrategyManager;
    local X2MissionSourceTemplate MissionSource;
    local X2RewardTemplate RewardTemplate;
    local XComGameState_Reward RewardState;
    local array<XComGameState_Reward> MissionRewards;
    local StateObjectReference RegionRef;
    local Vector2D MissionLocation;
    local int PreviousMissionID;

    History = `XCOMHISTORY;
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

    if (PreviousMission != none)
    {
        PreviousMissionID = PreviousMission.ObjectID;
        OldMissionState = XComGameState_MissionSite(
            NewGameState.ModifyStateObject(class'XComGameState_MissionSite', PreviousMissionID));
        OldMissionState.RemoveEntity(NewGameState);
    }

    RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
    MissionRewards.AddItem(RewardState);
    MissionState = XComGameState_MissionSite_Stargate(
        NewGameState.CreateNewStateObject(class'XComGameState_MissionSite_Stargate'));

    MissionLocation = SelectPrototypeMissionLocation(RegionRef);
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

    if (PreviousMissionID != 0)
    {
        `LOG("[WSG] prototype-mission-migrated old=" $ PreviousMissionID $
             " new=" $ MissionState.ObjectID $
             " region=" $ RegionRef.ObjectID $
             " type=" $ MissionState.GeneratedMission.Mission.sType, true, 'StargateWOTC');
    }
    else
    {
        `LOG("[WSG] prototype-mission-created id=" $ MissionState.ObjectID $
             " region=" $ RegionRef.ObjectID $
             " type=" $ MissionState.GeneratedMission.Mission.sType, true, 'StargateWOTC');
    }

    return true;
}

static function Vector2D SelectPrototypeMissionLocation(out StateObjectReference RegionRef)
{
    local XComGameStateHistory History;
    local XComGameState_WorldRegion RegionState;
    local array<XComGameState_WorldRegion> ContactedRegions;

    History = `XCOMHISTORY;
    foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
    {
        if (RegionState.HaveMadeContact())
        {
            ContactedRegions.AddItem(RegionState);
        }
    }

    if (ContactedRegions.Length > 0)
    {
        RegionState = ContactedRegions[`SYNC_RAND_STATIC(ContactedRegions.Length)];
        RegionRef = RegionState.GetReference();
        return RegionState.GetRandom2DLocationInRegion();
    }

    return class'XComGameState_MissionSite'.static.SelectRandomMissionLocation(RegionRef);
}
