"""Structural regression tests for AW-SST billing claim profile constraints.

These tests read the generated StructureDefinition JSON files and assert that the
required constraints are present. This catches any future FSH change that would
accidentally loosen a constraint — something positive example instances cannot detect.

Run: uv run pytest tests/test_aw_sst_billing_constraints.py -v
"""
from __future__ import annotations

import json
from pathlib import Path

import pytest

FSH_GENERATED = Path(__file__).parent.parent / "fsh-generated" / "resources"

BILLING_CLAIM_SUBTYPE_SYSTEM = (
    "https://fhir.cognovis.de/praxis/CodeSystem/billing-claim-subtype"
)
CLAIM_TYPE_PROFESSIONAL_SYSTEM = (
    "http://terminology.hl7.org/CodeSystem/claim-type"
)
PRELIMINARY_PROFILE_URL = (
    "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-preliminary-billing-claim-de"
)


def load_sd(filename: str) -> dict:
    path = FSH_GENERATED / filename
    assert path.exists(), f"StructureDefinition not found: {path}"
    return json.loads(path.read_text())


def get_element(sd: dict, element_id: str) -> dict | None:
    """Return the first differential element matching element_id, or None."""
    for elem in sd.get("differential", {}).get("element", []):
        if elem.get("id") == element_id:
            return elem
    return None


# ---------------------------------------------------------------------------
# Preliminary claim constraints
# ---------------------------------------------------------------------------


class TestPreliminaryBillingClaimConstraints:
    """PraxisPreliminaryBillingClaimDE must carry item lines and have the right use/subType/type."""

    @pytest.fixture(scope="class")
    def sd(self):
        return load_sd("StructureDefinition-praxis-preliminary-billing-claim-de.json")

    def test_item_min_1(self, sd):
        """item must be 1..* (item carrier for AW billing split)."""
        elem = get_element(sd, "Claim.item")
        assert elem is not None, "Claim.item element missing from differential"
        assert elem.get("min") == 1, f"Expected item min=1, got {elem.get('min')}"

    def test_use_fixed_predetermination(self, sd):
        """use must be pattern-fixed to predetermination."""
        elem = get_element(sd, "Claim.use")
        assert elem is not None, "Claim.use element missing from differential"
        assert elem.get("fixedCode") == "predetermination" or (
            elem.get("patternCode") == "predetermination"
        ), f"use not fixed to predetermination: {elem}"

    def test_subtype_pattern_vorlaeufig(self, sd):
        """subType must carry the vorlaeufig pattern code."""
        elem = get_element(sd, "Claim.subType")
        assert elem is not None, "Claim.subType element missing from differential"
        pattern = elem.get("patternCodeableConcept", {})
        codes = [c.get("code") for c in pattern.get("coding", [])]
        assert "vorlaeufig" in codes, f"subType pattern does not contain 'vorlaeufig': {codes}"

    def test_subtype_min_1(self, sd):
        """subType must be required (min=1)."""
        elem = get_element(sd, "Claim.subType")
        assert elem is not None
        assert elem.get("min") == 1, f"Expected subType min=1, got {elem.get('min')}"

    def test_type_fixed_professional(self, sd):
        """type must be pattern-fixed to professional."""
        elem = get_element(sd, "Claim.type")
        assert elem is not None, "Claim.type element missing from differential"
        pattern = elem.get("patternCodeableConcept", {})
        codes = [c.get("code") for c in pattern.get("coding", [])]
        assert "professional" in codes, f"type not fixed to professional: {codes}"


# ---------------------------------------------------------------------------
# Final claim shared constraint assertions
# ---------------------------------------------------------------------------


def assert_final_claim_constraints(sd: dict, expected_subtype_code: str) -> None:
    """Shared assertions for all four final billing claim profiles."""
    # item must be 0..0
    elem_item = get_element(sd, "Claim.item")
    assert elem_item is not None, "Claim.item element missing from differential"
    assert elem_item.get("max") == "0", (
        f"Expected item max='0' (no items in final claims), got {elem_item.get('max')!r}"
    )

    # related must be exactly 1..1
    elem_related = get_element(sd, "Claim.related")
    assert elem_related is not None, "Claim.related element missing from differential"
    assert elem_related.get("min") == 1, (
        f"Expected related min=1, got {elem_related.get('min')}"
    )
    assert elem_related.get("max") == "1", (
        f"Expected related max='1' (exactly one preliminary reference), got {elem_related.get('max')!r}"
    )

    # related.claim must be 1..1 and typed to PraxisPreliminaryBillingClaimDE
    elem_claim = get_element(sd, "Claim.related.claim")
    assert elem_claim is not None, "Claim.related.claim element missing from differential"
    assert elem_claim.get("min") == 1, (
        f"Expected related.claim min=1, got {elem_claim.get('min')}"
    )
    target_profiles = [
        t.get("targetProfile") for t in elem_claim.get("type", [])
        if "targetProfile" in t
    ]
    # FHIR FSH flattens targetProfile as a list on the type entry
    all_targets: list[str] = []
    for tp in target_profiles:
        if isinstance(tp, list):
            all_targets.extend(tp)
        else:
            all_targets.append(tp)
    assert PRELIMINARY_PROFILE_URL in all_targets, (
        f"related.claim targetProfile must include {PRELIMINARY_PROFILE_URL}. "
        f"Found: {all_targets}"
    )

    # subType must be present and carry the expected code
    elem_subtype = get_element(sd, "Claim.subType")
    assert elem_subtype is not None, "Claim.subType element missing from differential"
    assert elem_subtype.get("min") == 1, (
        f"Expected subType min=1, got {elem_subtype.get('min')}"
    )
    pattern = elem_subtype.get("patternCodeableConcept", {})
    codes = [c.get("code") for c in pattern.get("coding", [])]
    assert expected_subtype_code in codes, (
        f"subType pattern does not contain '{expected_subtype_code}': {codes}"
    )

    # type must be fixed to professional
    elem_type = get_element(sd, "Claim.type")
    assert elem_type is not None, "Claim.type element missing from differential"
    type_pattern = elem_type.get("patternCodeableConcept", {})
    type_codes = [c.get("code") for c in type_pattern.get("coding", [])]
    assert "professional" in type_codes, (
        f"Claim.type not fixed to professional: {type_codes}"
    )

    # use must be fixed to claim
    elem_use = get_element(sd, "Claim.use")
    assert elem_use is not None, "Claim.use element missing from differential"
    assert (
        elem_use.get("fixedCode") == "claim"
        or elem_use.get("patternCode") == "claim"
    ), f"use not fixed to claim: {elem_use}"


class TestGKVClaimConstraints:
    @pytest.fixture(scope="class")
    def sd(self):
        return load_sd("StructureDefinition-praxis-gkv-claim-de.json")

    def test_all_final_constraints(self, sd):
        assert_final_claim_constraints(sd, "gkv")


class TestPrivateClaimConstraints:
    @pytest.fixture(scope="class")
    def sd(self):
        return load_sd("StructureDefinition-praxis-private-claim-de.json")

    def test_all_final_constraints(self, sd):
        assert_final_claim_constraints(sd, "privat")


class TestBGClaimConstraints:
    @pytest.fixture(scope="class")
    def sd(self):
        return load_sd("StructureDefinition-praxis-bg-claim-de.json")

    def test_all_final_constraints(self, sd):
        assert_final_claim_constraints(sd, "bg")

    def test_no_accident_element(self, sd):
        """BG claim must not constrain Claim.accident — accident context goes via Condition/Procedure."""
        elem = get_element(sd, "Claim.accident")
        assert elem is None, (
            "Claim.accident found in BG claim differential — remove it; "
            "BG accident context must be carried via referenced Condition/Procedure resources."
        )


class TestSelectiveContractClaimConstraints:
    @pytest.fixture(scope="class")
    def sd(self):
        return load_sd("StructureDefinition-praxis-selective-contract-claim-de.json")

    def test_all_final_constraints(self, sd):
        assert_final_claim_constraints(sd, "hzv-selektiv")
