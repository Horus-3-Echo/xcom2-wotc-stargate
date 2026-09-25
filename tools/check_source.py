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
solution = (root / 'StargateWOTC.XCOM_sln').read_text(encoding='utf-8')
guid = project.findtext('m:PropertyGroup/m:ProjectGuid', namespaces=ns)
assert guid in solution
for name in ['README.md', 'AGENTS.md', 'BUILD.md', 'STATUS.md', 'BACKLOG.md', 'DECISIONS.md', 'docs/BRIEF.md']:
    assert (root / name).is_file(), name
json.loads((root / 'environment.example.json').read_text(encoding='utf-8'))
print('PASS T00: WSG project XML, source inclusion, solution and INI registration')
print('NOT_RUN T01-T04: no WotC SDK or game runtime')
