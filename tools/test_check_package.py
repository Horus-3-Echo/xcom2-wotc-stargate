"""Synthetic fixtures only. Never represent these files as compiled packages."""
from pathlib import Path
import tempfile
import unittest

from check_package import check_package


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.mod = Path(self.temp.name)
        source = Path(__file__).resolve().parents[1] / 'StargateWOTC'
        (self.mod / 'Config').mkdir()
        for name in ('XComEditor.ini', 'XComEngine.ini', 'XComGame.ini'):
            (self.mod / 'Config' / name).write_bytes((source / 'Config' / name).read_bytes())
        self.descriptor = self.mod / 'StargateWOTC.XComMod'
        self.metadata = '[mod]\npublishedFileId=0\nTitle=StargateWOTC\nRequiresXPACK=true\n'
        self.descriptor.write_text(self.metadata, encoding='utf-8')
        (self.mod / 'Script').mkdir()
        self.script = self.mod / 'Script/StargateWOTC.u'
        self.script.write_bytes(b'SYNTHETIC-NOT-UNREAL-BYTECODE')

    def test_expected_layout_only(self):
        self.assertEqual(check_package(self.mod), [])

    def test_utf16_descriptor(self):
        self.descriptor.write_text(self.metadata, encoding='utf-16')
        self.assertEqual(check_package(self.mod), [])

    def test_utf8_bom_descriptor(self):
        self.descriptor.write_text(self.metadata, encoding='utf-8-sig')
        self.assertEqual(check_package(self.mod), [])

    def test_missing_descriptor(self):
        self.descriptor.unlink()
        self.assertTrue(check_package(self.mod))

    def test_missing_or_false_wotc_marker(self):
        for marker in ('', 'RequiresXPACK=false\n'):
            with self.subTest(marker=marker):
                self.descriptor.write_text(self.metadata.replace('RequiresXPACK=true\n', marker))
                self.assertTrue(check_package(self.mod))

    def test_duplicate_descriptor_key(self):
        self.descriptor.write_text(self.metadata + 'RequiresXPACK=false\n')
        self.assertTrue(check_package(self.mod))

    def test_missing_and_empty_script(self):
        self.script.unlink()
        self.assertTrue(check_package(self.mod))
        self.script.touch()
        self.assertTrue(check_package(self.mod))

    def test_wrong_registration(self):
        path = self.mod / 'Config/XComEngine.ini'
        path.write_text('[Engine.ScriptPackages]\n+NonNativePackages=Wrong\n')
        self.assertTrue(check_package(self.mod))

    def test_missing_config(self):
        (self.mod / 'Config/XComGame.ini').unlink()
        self.assertTrue(check_package(self.mod))

    def test_source_is_not_built_package(self):
        source = Path(__file__).resolve().parents[1] / 'StargateWOTC'
        self.assertTrue(check_package(source))

    def test_wrong_identity_or_workshop_id(self):
        for old, new in [('Title=StargateWOTC', 'Title=Wrong'), ('publishedFileId=0', 'publishedFileId=123')]:
            with self.subTest(field=old):
                self.descriptor.write_text(self.metadata.replace(old, new))
                self.assertTrue(check_package(self.mod))


if __name__ == '__main__':
    unittest.main()
