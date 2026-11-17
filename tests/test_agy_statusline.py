import importlib.util
from pathlib import Path
import unittest

STATUSLINE_PATH = Path(__file__).resolve().parent.parent / "antigravity" / "agy-statusline.py"
spec = importlib.util.spec_from_file_location("agy_statusline", STATUSLINE_PATH)
agy_statusline = importlib.util.module_from_spec(spec)
spec.loader.exec_module(agy_statusline)


class TestAgyStatusline(unittest.TestCase):
    def test_pct_valid(self):
        self.assertEqual(agy_statusline.pct(0.5), "50%")

    def test_pct_none(self):
        self.assertEqual(agy_statusline.pct(None), "—")

    def test_pct_invalid(self):
        self.assertEqual(agy_statusline.pct("invalid"), "—")

    def test_git_info_dummy_path(self):
        self.assertEqual(agy_statusline.git_info("/nonexistent/dummy/path"), ("", 0))


if __name__ == "__main__":
    unittest.main()
