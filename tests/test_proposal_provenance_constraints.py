"""Structural regression tests for the proposal Provenance profile.

These tests read SUSHI-generated resources and assert that the terminology,
profile constraints, and derived-proposal invariant are present.

Run: uv run pytest tests/test_proposal_provenance_constraints.py -v
"""
from __future__ import annotations

import json
from pathlib import Path

import pytest

FSH_GENERATED = Path(__file__).parent.parent / "fsh-generated" / "resources"

PROFILE_URL = (
    "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-proposal-provenance"
)
ROLE_SYSTEM = (
    "https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role"
)
ROLE_VS = (
    "https://fhir.cognovis.de/praxis/ValueSet/proposal-contribution-role-vs"
)
EXPECTED_CODES = {
    "software-suggested",
    "llm-suggested",
    "clinician-confirmed",
    "linked-existing",
    "manual-entry",
}
INVARIANT_ID = "provenance-source-required-for-derived"


def load_resource(filename: str) -> dict:
    path = FSH_GENERATED / filename
    assert path.exists(), f"Generated resource not found: {path}"
    return json.loads(path.read_text())


def get_element(sd: dict, element_id: str) -> dict:
    for elem in sd.get("differential", {}).get("element", []):
        if elem.get("id") == element_id:
            return elem
    pytest.fail(f"Element not found in differential: {element_id}")


def get_element_or_empty(sd: dict, element_id: str) -> dict:
    for elem in sd.get("differential", {}).get("element", []):
        if elem.get("id") == element_id:
            return elem
    return {}


def effective_min(sd: dict, element_id: str, base_min: int) -> int:
    elem = get_element_or_empty(sd, element_id)
    return elem.get("min", base_min)


def coding_codes(codeable_concept: dict) -> set[str]:
    return {
        coding.get("code")
        for coding in codeable_concept.get("coding", [])
        if coding.get("code")
    }


def test_codesystem_contains_all_proposal_roles() -> None:
    cs = load_resource("CodeSystem-proposal-contribution-role.json")

    assert cs["url"] == ROLE_SYSTEM
    assert {concept["code"] for concept in cs["concept"]} == EXPECTED_CODES
    assert cs["caseSensitive"] is True


def test_valueset_composes_from_role_codesystem() -> None:
    vs = load_resource("ValueSet-proposal-contribution-role-vs.json")

    assert vs["url"] == ROLE_VS
    includes = vs.get("compose", {}).get("include", [])
    assert any(include.get("system") == ROLE_SYSTEM for include in includes)


def test_profile_cardinalities_and_required_binding() -> None:
    sd = load_resource("StructureDefinition-praxis-proposal-provenance.json")

    assert sd["url"] == PROFILE_URL
    assert effective_min(sd, "Provenance.target", base_min=1) == 1
    assert effective_min(sd, "Provenance.recorded", base_min=1) == 1
    assert effective_min(sd, "Provenance.activity", base_min=0) == 1
    assert effective_min(sd, "Provenance.agent", base_min=1) == 1
    assert effective_min(sd, "Provenance.agent.type", base_min=0) == 1
    assert effective_min(sd, "Provenance.agent.role", base_min=0) == 1
    assert effective_min(sd, "Provenance.agent.who", base_min=1) == 1
    assert effective_min(sd, "Provenance.entity", base_min=0) == 0

    role = get_element(sd, "Provenance.agent.role")
    binding = role.get("binding", {})
    assert binding.get("strength") == "required"
    assert binding.get("valueSet") == ROLE_VS


def test_profile_contains_source_required_invariant() -> None:
    sd = load_resource("StructureDefinition-praxis-proposal-provenance.json")
    root = get_element(sd, "Provenance")
    constraints = {
        constraint["key"]: constraint
        for constraint in root.get("constraint", [])
    }

    assert INVARIANT_ID in constraints
    invariant = constraints[INVARIANT_ID]
    assert invariant["severity"] == "error"
    assert "software-suggested" in invariant["expression"]
    assert "llm-suggested" in invariant["expression"]
    assert "linked-existing" in invariant["expression"]
    assert "entity.exists()" in invariant["expression"]


def test_llm_suggestion_example_has_required_source_entity() -> None:
    instance = load_resource("Provenance-ExampleProposalSuggestionProvenance.json")

    assert PROFILE_URL in instance.get("meta", {}).get("profile", [])
    assert instance["target"]
    assert instance["entity"][0]["role"] == "source"
    role_codes = coding_codes(instance["agent"][0]["role"][0])
    assert "llm-suggested" in role_codes


def test_manual_entry_example_has_no_source_entity() -> None:
    instance = load_resource("Provenance-ExampleProposalManualEntryProvenance.json")

    assert PROFILE_URL in instance.get("meta", {}).get("profile", [])
    assert "entity" not in instance
    role_codes = coding_codes(instance["agent"][0]["role"][0])
    assert "manual-entry" in role_codes
