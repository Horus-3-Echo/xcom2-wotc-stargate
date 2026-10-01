"""Check WotC source packaging, not UnrealScript compilation or game behavior."""
from pathlib import Path
import configparser
import json
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[1]
mod = root / 'StargateWOTC'
ns = {'m': 'http://schemas.microsoft.com/developer/msbuild/2003'}
project = ET.parse(mod / 'StargateWOTC.x2proj').getroot()
assert project.findtext('m:PropertyGroup/m:Name', namespaces=ns) == 'StargateWOTC'
assert project.attrib['ToolsVersion'] == '12.0'
assert project.attrib['DefaultTargets'] == 'Default'
assert project.findtext('m:PropertyGroup/m:SteamPublishID', namespaces=ns) == '0'
imports = [node.attrib['Project'].replace(chr(92), '/') for node in project.findall('m:Import', ns)]
assert imports == ['$(MSBuildLocalExtensionPath)/XCOM2.targets'], imports
included = {node.attrib['Include'].replace(chr(92), '/') for node in project.findall('.//m:Content', ns)}
required_content = {
    'Config/XComEditor.ini',
    'Config/XComEngine.ini',
    'Config/XComGame.ini',
    'Config/XComMissionSources.ini',
    'Src/StargateWOTC/Classes/X2DownloadableContentInfo_StargateWOTC.uc',
    'Src/StargateWOTC/Classes/X2StargateMissionFactory.uc',
    'Src/StargateWOTC/Classes/X2StrategyElement_StargateMissionSource.uc',
    'Src/StargateWOTC/Classes/XComGameState_StargateProgram.uc',
}
assert required_content <= included, required_content - included
for node in project.findall('.//m:Content', ns):
    assert (mod / node.attrib['Include'].replace(chr(92), '/')).is_file(), node.attrib
def config(name):
    parser = configparser.ConfigParser(interpolation=None)
    parser.read(mod / 'Config' / name, encoding='utf-8')
    return parser
assert config('XComEditor.ini')['ModPackages']['+ModPackages'] == 'StargateWOTC'
assert config('XComEngine.ini')['Engine.ScriptPackages']['+NonNativePackages'] == 'StargateWOTC'
section = 'StargateWOTC.X2DownloadableContentInfo_StargateWOTC'
assert config('XComGame.ini')[section]['DLCIdentifier'] == '"StargateWOTC"'
mission_sources = config('XComMissionSources.ini')['XComGame.XComTacticalMissionManager']
mission_mapping = mission_sources['+arrSourceRewardMissionTypes']
for value in (
    'MissionSource="MissionSource_StargatePrototype"',
    'RewardType="Reward_None"',
    'MissionFamily="SupplyLineRaid"',
):
    assert value in mission_mapping, value
classes = mod / 'Src' / 'StargateWOTC' / 'Classes'
loader = (classes / 'X2DownloadableContentInfo_StargateWOTC.uc').read_text(encoding='utf-8')
mission_source = (classes / 'X2StrategyElement_StargateMissionSource.uc').read_text(encoding='utf-8')
factory = (classes / 'X2StargateMissionFactory.uc').read_text(encoding='utf-8')
program_state = (classes / 'XComGameState_StargateProgram.uc').read_text(encoding='utf-8')
assert 'static event UpdateDLC()' in loader
assert "EnsurePrototypeMission()" in loader
assert "MissionSource_StargatePrototype" in mission_source
assert "bRequiresSkyrangerTravel = false" in mission_source
assert "WasMissionSuccessfulFn = OneStrategyObjectiveCompleted" in mission_source
assert "BuildMission(MissionSource, MissionLocation, RegionRef, MissionRewards, true, false)" in factory
assert "GeneratedMission.Mission.sType == \"\"" in factory
assert "Reward_None" in factory
assert "bPrototypeMissionCreated" in factory
assert "class XComGameState_StargateProgram extends XComGameState_BaseObject" in program_state
solution = (root / 'StargateWOTC.XCOM_sln').read_text(encoding='utf-8')
guid = project.findtext('m:PropertyGroup/m:ProjectGuid', namespaces=ns)
assert guid in solution
for configuration in ('Debug', 'Default'):
    assert f'{configuration}|XCOM 2 = {configuration}|XCOM 2' in solution
    assert f'{guid}.{configuration}|XCOM 2.Build.0 = {configuration}|XCOM 2' in solution
for name in ['README.md', 'AGENTS.md', 'BUILD.md', 'STATUS.md', 'BACKLOG.md', 'DECISIONS.md', 'docs/BRIEF.md']:
    assert (root / name).is_file(), name
json.loads((root / 'environment.example.json').read_text(encoding='utf-8'))
print('PASS T00: WSG project XML, source inclusion, solution and INI registration')
print('PASS T00-MISSION: source/reward/family mapping, direct-travel source and persisted duplicate guard')
print('NOT_RUN T01/T05: current 0.2.0 sources require a fresh WotC SDK build and game test')
