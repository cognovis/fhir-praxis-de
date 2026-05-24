import importlib.util
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / ".github" / "scripts" / "update-package-list-remote.py"
spec = importlib.util.spec_from_file_location("update_package_list_remote", SCRIPT)
update_package_list = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(update_package_list)


def test_exact_path_only_skips_nginx_and_root_scans(tmp_path, monkeypatch):
    target = tmp_path / "public" / "package-list.json"
    target.parent.mkdir()

    monkeypatch.setenv("PACKAGE_LIST_EXACT_PATH_ONLY", "true")
    candidates = list(
        update_package_list.iter_package_lists(
            str(target),
            "https://fhir.cognovis.de/praxis",
        )
    )

    assert candidates == [target]
