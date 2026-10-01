class X2DownloadableContentInfo_StargateWOTC extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    `LOG("[WSG] templates-ready version=0.2.2", true, 'StargateWOTC');
}

static event InstallNewCampaign(XComGameState StartState)
{
    `LOG("[WSG] new-campaign", true, 'StargateWOTC');
}

static event OnLoadedSavedGameToStrategy()
{
    `LOG("[WSG] strategy-save-loaded", true, 'StargateWOTC');
}

static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local X2MissionSourceTemplate MissionSource;
    local int SquadIndex;
    local int SquadCount;
    local string TravelMode;

    if (MissionState == none || MissionState.Source != 'MissionSource_StargatePrototype')
    {
        return;
    }

    XComHQ = XComGameState_HeadquartersXCom(
        `XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

    if (XComHQ != none)
    {
        for (SquadIndex = 0; SquadIndex < XComHQ.Squad.Length; ++SquadIndex)
        {
            if (XComHQ.Squad[SquadIndex].ObjectID != 0)
            {
                ++SquadCount;
            }
        }
    }

    TravelMode = "missing-source";
    MissionSource = MissionState.GetMissionSource();
    if (MissionSource != none)
    {
        TravelMode = MissionSource.bRequiresSkyrangerTravel ? "skyranger" : "direct";
    }

    `LOG("[WSG] prototype-mission-launch id=" $ MissionState.ObjectID $
         " squad=" $ SquadCount $
         " travel=" $ TravelMode $
         " type=" $ MissionState.GeneratedMission.Mission.sType, true, 'StargateWOTC');
}

static event UpdateDLC()
{
    local UIStrategyMap StrategyMap;

    StrategyMap = `HQPRES.StrategyMap2D;

    // The geoscape tick is the first verified point with a complete strategy
    // world. Avoid adding history while travelling or another alert owns the UI.
    if (StrategyMap != none &&
        StrategyMap.m_eUIState != eSMS_Flight &&
        !`HQPRES.ScreenStack.IsCurrentClass(class'UIAlert'))
    {
        class'X2StargateMissionFactory'.static.EnsurePrototypeMission();
    }
}
