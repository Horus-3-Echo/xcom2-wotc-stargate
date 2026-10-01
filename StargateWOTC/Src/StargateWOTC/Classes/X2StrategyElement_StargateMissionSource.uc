class X2StrategyElement_StargateMissionSource extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreatePrototypeMissionSource());
    return Templates;
}

static function X2DataTemplate CreatePrototypeMissionSource()
{
    local X2MissionSourceTemplate Template;

    `CREATE_X2TEMPLATE(class'X2MissionSourceTemplate', Template, 'MissionSource_StargatePrototype');

    Template.bRequiresSkyrangerTravel = false;
    Template.bIncreasesForceLevel = false;
    Template.bStart = false;
    Template.bGoldenPath = false;
    Template.bAlienNetwork = false;
    Template.bShowRewardOnPin = false;
    Template.bSkipRewardsRecap = true;
    Template.bDisconnectRegionOnFail = false;
    Template.bBlockFirstEncounterVO = true;
    Template.bMakesDoom = false;
    Template.SpawnUFOChance = 0;
    Template.DifficultyValue = 1;

    // Reuse only presentation assets from the built-in Supply Raid source.
    // Their exact paths are present in the pinned WotC SDK source.
    Template.OverworldMeshPath = "UI_3D.Overwold_Final.SupplyRaid_AdvConvoy";
    Template.MissionImage = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Supply_Raid";
    Template.MissionPinLabel = "STARGATE PROTOTYPE";
    Template.MissionFlavorText = "Test the first direct route through the gate.";
    Template.BattleOpName = "STARGATE PROTOTYPE";

    Template.OnSuccessFn = OnPrototypeSuccess;
    Template.OnFailureFn = OnPrototypeFailure;
    Template.GetMissionDifficultyFn = GetPrototypeDifficulty;
    Template.WasMissionSuccessfulFn = OneStrategyObjectiveCompleted;

    return Template;
}

static function int GetPrototypeDifficulty(XComGameState_MissionSite MissionState)
{
    return 1;
}

static function bool OneStrategyObjectiveCompleted(XComGameState_BattleData BattleDataState)
{
    return BattleDataState.OneStrategyObjectiveCompleted();
}

static function OnPrototypeSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
    `LOG("[WSG] prototype-mission-result=success id=" $ MissionState.ObjectID, true, 'StargateWOTC');
    MissionState.CleanUpRewards(NewGameState);
    MissionState.RemoveEntity(NewGameState);
}

static function OnPrototypeFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
    `LOG("[WSG] prototype-mission-result=failure id=" $ MissionState.ObjectID, true, 'StargateWOTC');
    MissionState.CleanUpRewards(NewGameState);
    MissionState.RemoveEntity(NewGameState);
}
