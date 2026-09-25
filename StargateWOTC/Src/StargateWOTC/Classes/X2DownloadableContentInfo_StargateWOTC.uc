class X2DownloadableContentInfo_StargateWOTC extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    `LOG("[WSG] templates-ready version=0.1.0", true, 'StargateWOTC');
}

static event InstallNewCampaign(XComGameState StartState)
{
    `LOG("[WSG] new-campaign", true, 'StargateWOTC');
}

static event OnLoadedSavedGameToStrategy()
{
    `LOG("[WSG] strategy-save-loaded", true, 'StargateWOTC');
}
