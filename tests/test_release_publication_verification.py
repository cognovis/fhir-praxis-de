import base64
import importlib.util
import sys
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / ".github" / "scripts" / "verify-fhir-release-publication.py"
spec = importlib.util.spec_from_file_location("verify_fhir_release_publication", SCRIPT)
verify = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = verify
spec.loader.exec_module(verify)


def test_basic_auth_value_accepts_raw_password():
    expected = base64.b64encode(b"cognovis:secret").decode("ascii")
    assert verify.basic_auth_value("secret") == f"Basic {expected}"


def test_basic_auth_value_accepts_preencoded_user_password():
    token = base64.b64encode(b"cognovis:secret").decode("ascii")
    assert verify.basic_auth_value(token) == f"Basic {token}"


def test_matching_current_entry_requires_version_package_and_path():
    data = {
        "list": [
            {
                "version": "0.67.0",
                "package": "de.cognovis.fhir.praxis#0.67.0",
                "path": "https://fhir.cognovis.de/praxis",
                "current": False,
            },
            {
                "version": "0.68.0",
                "package": "de.cognovis.fhir.praxis#0.68.0",
                "path": "https://fhir.cognovis.de/praxis/",
                "current": True,
            },
        ]
    }

    assert verify.matching_current_entry(
        data,
        "0.68.0",
        "de.cognovis.fhir.praxis",
        "https://fhir.cognovis.de/praxis",
    ) == data["list"][1]
    assert verify.matching_current_entry(
        data,
        "0.67.0",
        "de.cognovis.fhir.praxis",
        "https://fhir.cognovis.de/praxis",
    ) is None


def test_registry_headers_accepts_supported_token_names():
    expected = verify.basic_auth_value("secret")
    assert verify.registry_headers({"VERDACCIO_TOKEN": "secret"}) == {"Authorization": expected}
