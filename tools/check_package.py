"""Read-only WSG package layout check; NOT compilation or game validation."""
from pathlib import Path
import argparse
import configparser


def read_ini(path):
    raw = path.read_bytes()
    encoding = 'utf-16' if raw.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig'
    parser = configparser.ConfigParser(interpolation=None)
    parser.read_string(raw.decode(encoding))
    return parser


def check_package(mod):
    mod = Path(mod)
    errors = []
    expected = [
        ('StargateWOTC.XComMod', 'mod', 'RequiresXPACK', 'true'),
        ('StargateWOTC.XComMod', 'mod', 'Title', 'StargateWOTC'),
        ('StargateWOTC.XComMod', 'mod', 'publishedFileId', '0'),
        ('Config/XComEditor.ini', 'ModPackages', '+ModPackages', 'StargateWOTC'),
        ('Config/XComEngine.ini', 'Engine.ScriptPackages', '+NonNativePackages', 'StargateWOTC'),
        ('Config/XComGame.ini', 'StargateWOTC.X2DownloadableContentInfo_StargateWOTC',
         'DLCIdentifier', '"StargateWOTC"'),
    ]
    parsed = {}
    for filename, section, key, value in expected:
        if filename not in parsed:
            try:
                parsed[filename] = read_ini(mod / filename)
            except (OSError, UnicodeError, configparser.Error) as exc:
                errors.append(f'{filename}: {exc}')
                parsed[filename] = None
        config = parsed[filename]
        if config is None:
            continue
        actual = config.get(section, key, fallback=None)
        if key == 'RequiresXPACK' and actual is not None:
            actual = actual.lower()
        if actual != value:
            errors.append(f'{filename}: [{section}] {key} expected {value!r}, got {actual!r}')
    script = mod / 'Script/StargateWOTC.u'
    try:
        if not script.is_file() or script.stat().st_size == 0:
            errors.append('Script/StargateWOTC.u: missing or empty')
    except OSError as exc:
        errors.append(f'Script/StargateWOTC.u: {exc}')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mod_directory', type=Path, help='Actual built StargateWOTC folder, not source')
    args = parser.parse_args()
    errors = check_package(args.mod_directory)
    for error in errors:
        print(f'FAIL PACKAGE: {error}')
    if not errors:
        print('PASS PACKAGE: WSG metadata, registration and nonempty script file')
    print('LIMIT: file presence does not prove compilation, freshness, loadability or gameplay')
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
