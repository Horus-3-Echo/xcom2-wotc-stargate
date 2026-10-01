class X2DownloadableContentInfo_StargateWOTC extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    `LOG("[WSG] templates-ready version=0.2.0", true, 'StargateWOTC');
}

static event InstallNewCampaign(XComGameState StartState)
{
    `LOG("[WSG] new-campaign", true, 'StargateWOTC');
}

static event OnLoadedSavedGameToStrategy()
{
    `LOG("[WSG] strategy-save-loaded", true, 'StargateWOTC');
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
