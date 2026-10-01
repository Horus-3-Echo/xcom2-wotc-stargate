class XComGameState_MissionSite_Stargate extends XComGameState_MissionSite;

// The stock HQ presentation dispatcher only knows Firaxis mission sources.
// Keep the normal MissionSite lifecycle, but enter its own squad-select path
// directly instead of asking HQPRES to dispatch this custom source.
function MissionSelected()
{
    if (Source != 'MissionSource_StargatePrototype')
    {
        super.MissionSelected();
        return;
    }

    `LOG("[WSG] prototype-mission-selected id=" $ ObjectID, true, 'StargateWOTC');
    SelectSquad();
}
