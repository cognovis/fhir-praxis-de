import json

import yaml

import sync


def test_apply_smoke_and_sushi_self_version(tmp_path):
    manifest = {
        "igs": {"de.cognovis.fhir.dental": {"version": "0.35.0"}},
        "packages": {"de.cognovis.fhir.base": {"version": "1.1.0"}},
        "bundles": {
            "de.cognovis.fhir.bundle": {
                "version": "2.0.0",
                "dependencies": {"de.cognovis.fhir.base": "1.1.0"},
            }
        },
    }
    (tmp_path / "fhir-versions.lock.yaml").write_text(
        """
igs:
  de.cognovis.fhir.dental:
    version: 0.35.0
packages:
  de.cognovis.fhir.base:
    version: 1.1.0
bundles:
  de.cognovis.fhir.bundle:
    version: 2.0.0
    dependencies:
      de.cognovis.fhir.base: 1.1.0
""".lstrip(),
        encoding="utf-8",
    )

    sushi = tmp_path / "sushi-config.yaml"
    sushi.write_text(
        """
id: de.cognovis.fhir.dental
version: 0.36.0
dependencies:
  de.cognovis.fhir.base: 1.0.0
""".lstrip(),
        encoding="utf-8",
    )
    package_json = tmp_path / "package.json"
    package_json.write_text(
        json.dumps(
            {
                "name": "de.cognovis.fhir.bundle",
                "version": "2.0.0",
                "dependencies": {"de.cognovis.fhir.base": "1.0.0"},
            }
        )
        + "\n",
        encoding="utf-8",
    )

    consumers = [
        sync.read_consumer_file(sushi),
        sync.read_consumer_file(package_json),
    ]
    drifts = sync.compute_drifts(consumers, manifest)
    assert {(drift.package, drift.current, drift.expected, drift.action) for drift in drifts} == {
        (
            "de.cognovis.fhir.dental",
            "0.36.0",
            "0.35.0",
            "RELEASE_LOCAL_OR_UPDATE_MANIFEST",
        ),
        ("de.cognovis.fhir.base", "1.0.0", "1.1.0", "UPDATE"),
    }

    sync.apply_drifts(consumers, manifest)
    assert "version: 0.36.0" in sushi.read_text(encoding="utf-8")
    assert "de.cognovis.fhir.base: 1.1.0" in sushi.read_text(encoding="utf-8")
    assert json.loads(package_json.read_text(encoding="utf-8"))["dependencies"] == {
        "de.cognovis.fhir.base": "1.1.0"
    }

    sushi.write_text(
        sushi.read_text(encoding="utf-8").replace("version: 0.36.0", "version: 0.35.0"),
        encoding="utf-8",
    )
    consumers = [sync.read_consumer_file(sushi), sync.read_consumer_file(package_json)]
    assert sync.compute_drifts(consumers, manifest) == []


def test_apply_nested_sushi_form(tmp_path):
    manifest = {
        "igs": {"de.basisprofil.r4": {"version": "2.0.0"}},
    }
    (tmp_path / "fhir-versions.lock.yaml").write_text(
        """
igs:
  de.basisprofil.r4:
    version: "2.0.0"
""".lstrip(),
        encoding="utf-8",
    )

    sushi = tmp_path / "sushi-config.yaml"
    sushi.write_text(
        """
id: de.cognovis.fhir.praxis
version: 1.0.0
dependencies:
  de.basisprofil.r4:
    version: 1.6.0-ballot2
    uri: https://simplifier.net/resolve?scope=de.basisprofil.r4@1.6.0-ballot2&filepath=package.tgz
""".lstrip(),
        encoding="utf-8",
    )

    consumer = sync.read_consumer_file(sushi)
    assert consumer is not None
    assert consumer.dependencies["de.basisprofil.r4"] == "1.6.0-ballot2"

    drifts = sync.compute_drifts([consumer], manifest)
    assert [(drift.package, drift.current, drift.expected, drift.action) for drift in drifts] == [
        ("de.basisprofil.r4", "1.6.0-ballot2", "2.0.0", "UPDATE")
    ]

    sync.apply_drifts([consumer], manifest)
    applied = yaml.safe_load(sushi.read_text(encoding="utf-8"))
    dependency = applied["dependencies"]["de.basisprofil.r4"]
    assert dependency["version"] == "2.0.0"
    assert (
        dependency["uri"]
        == "https://simplifier.net/resolve?scope=de.basisprofil.r4@1.6.0-ballot2&filepath=package.tgz"
    )


def test_package_json_reads_and_updates_cross_repo_dependency_fields(tmp_path):
    manifest = {
        "igs": {
            "de.cognovis.fhir.praxis": {"version": "0.66.0"},
            "de.cognovis.fhir.dental": {"version": "0.35.0"},
        }
    }
    package_json = tmp_path / "package.json"
    package_json.write_text(
        json.dumps(
            {
                "name": "@polaris/fhir-de",
                "version": "0.8.0",
                "dependencies": {
                    "@polaris/sdk": "^0.2.0",
                    "@local/fhir-de-copy": "file:vendor/polaris-fhir-de",
                },
                "devDependencies": {
                    "de.cognovis.fhir.dental": "0.30.0",
                },
                "overrides": {
                    "de.cognovis.fhir.praxis": "0.65.0",
                    "io.health-samurai.de-identification.r4": "https://packages2.fhir.org/web/io.health-samurai.de-identification.r4-0.2603.0.tgz",
                },
            }
        )
        + "\n",
        encoding="utf-8",
    )

    consumer = sync.read_consumer_file(package_json)
    assert consumer is not None
    assert consumer.dependencies["@polaris/fhir-de"] == "0.8.0"
    assert consumer.dependencies["de.cognovis.fhir.dental"] == "0.30.0"
    assert consumer.dependencies["de.cognovis.fhir.praxis"] == "0.65.0"
    assert "@local/fhir-de-copy" not in consumer.dependencies
    assert "io.health-samurai.de-identification.r4" not in consumer.dependencies

    drifts = sync.compute_drifts([consumer], manifest)
    assert {(drift.package, drift.current, drift.expected) for drift in drifts} == {
        ("de.cognovis.fhir.dental", "0.30.0", "0.35.0"),
        ("de.cognovis.fhir.praxis", "0.65.0", "0.66.0"),
    }

    sync.apply_drifts([consumer], manifest)
    applied = json.loads(package_json.read_text(encoding="utf-8"))
    assert applied["devDependencies"]["de.cognovis.fhir.dental"] == "0.35.0"
    assert applied["overrides"]["de.cognovis.fhir.praxis"] == "0.66.0"
    assert (
        applied["overrides"]["io.health-samurai.de-identification.r4"]
        == "https://packages2.fhir.org/web/io.health-samurai.de-identification.r4-0.2603.0.tgz"
    )


def test_public_package_list_audit_detects_stale_current_entry():
    expected = {"de.cognovis.fhir.praxis": "0.68.0"}

    def fetcher(url):
        assert url.startswith("https://fhir.cognovis.de/praxis/package-list.json?")
        return {
            "list": [
                {
                    "version": "0.66.0",
                    "package": "de.cognovis.fhir.praxis#0.66.0",
                    "path": "https://fhir.cognovis.de/praxis",
                    "current": True,
                }
            ]
        }

    drifts = sync.compute_public_package_list_drifts(expected, fetcher=fetcher)

    assert [(drift.package, drift.action) for drift in drifts] == [
        ("de.cognovis.fhir.praxis", "PUBLIC_PACKAGE_LIST_STALE")
    ]
    assert "0.66.0" in drifts[0].current
    assert "0.68.0" in drifts[0].expected


def test_public_package_list_audit_accepts_matching_current_entry():
    expected = {"de.cognovis.fhir.praxis": "0.68.0"}

    def fetcher(url):
        return {
            "list": [
                {
                    "version": "0.68.0",
                    "package": "de.cognovis.fhir.praxis#0.68.0",
                    "path": "https://fhir.cognovis.de/praxis/",
                    "current": True,
                }
            ]
        }

    assert sync.compute_public_package_list_drifts(expected, fetcher=fetcher) == []


def test_legacy_package_list_deploy_target_audit_detects_old_host_and_path(tmp_path):
    repo = tmp_path / "fhir-praxis-de"
    workflow = repo / ".github" / "workflows" / "ig-release.yml"
    workflow.parent.mkdir(parents=True)
    workflow.write_text(
        """
jobs:
  update-package-list:
    steps:
      - run: ssh fhir@116.202.111.75 'python3 /var/www/fhir/praxis/package-list.json'
""".lstrip(),
        encoding="utf-8",
    )

    drifts = sync.compute_legacy_package_list_deploy_target_drifts(
        {"de.cognovis.fhir.praxis": repo}
    )

    assert [(drift.package, drift.action) for drift in drifts] == [
        ("de.cognovis.fhir.praxis", "LEGACY_PACKAGE_LIST_DEPLOY_TARGET")
    ]
    assert "116.202.111.75" in drifts[0].current
    assert "/var/www/fhir/" in drifts[0].current


def test_discover_consumers_adds_external_repos_and_excludes_generated_dirs(
    tmp_path, monkeypatch
):
    repo_root = tmp_path / "fhir-terminology-de"
    package_dir = repo_root / "packages" / "de.cognovis.bundle.praxis-billing-de"
    package_dir.mkdir(parents=True)
    (package_dir / "package.json").write_text(
        json.dumps(
            {
                "name": "de.cognovis.bundle.praxis-billing-de",
                "version": "1.0.0",
                "dependencies": {"de.cognovis.fhir.praxis": "0.66.0"},
            }
        )
        + "\n",
        encoding="utf-8",
    )

    deidentification_sushi = tmp_path / "fhir-deidentification-de" / "sushi-config.yaml"
    deidentification_sushi.parent.mkdir()
    deidentification_sushi.write_text(
        """
id: io.cognovis.de-identification.de
version: 0.11.0
dependencies:
  de.cognovis.fhir.praxis:
    version: 0.45.0
""".lstrip(),
        encoding="utf-8",
    )

    polaris_package = tmp_path / "polaris" / "packages" / "fhir-de" / "package.json"
    polaris_package.parent.mkdir(parents=True)
    polaris_package.write_text(
        json.dumps(
            {
                "name": "@polaris/fhir-de",
                "version": "0.8.0",
                "devDependencies": {
                    "io.cognovis.de-identification.de": "0.10.0",
                },
            }
        )
        + "\n",
        encoding="utf-8",
    )

    generated_package = (
        tmp_path
        / "polaris"
        / "packages"
        / "fhir-de"
        / ".codegen-cache"
        / "node"
        / "package.json"
    )
    generated_package.parent.mkdir(parents=True)
    generated_package.write_text(
        json.dumps(
            {
                "name": "generated",
                "version": "0.0.0",
                "dependencies": {"de.cognovis.fhir.praxis": "0.1.0"},
            }
        )
        + "\n",
        encoding="utf-8",
    )

    mira_package = tmp_path / "mira" / "package.json"
    mira_package.parent.mkdir()
    mira_package.write_text(
        json.dumps(
            {
                "name": "mira",
                "version": "0.1.0",
                "dependencies": {"@polaris/fhir-de": "^0.3.0"},
            }
        )
        + "\n",
        encoding="utf-8",
    )

    monkeypatch.setattr(sync, "SUSHI_CONSUMERS", (deidentification_sushi,))
    monkeypatch.setattr(
        sync, "PACKAGE_JSON_CONSUMER_ROOTS", (tmp_path / "polaris", tmp_path / "mira")
    )

    consumers = sync.discover_consumers(repo_root)
    paths = {consumer.path for consumer in consumers}
    assert deidentification_sushi in paths
    assert package_dir / "package.json" in paths
    assert polaris_package in paths
    assert mira_package in paths
    assert generated_package not in paths

    manifest = {"igs": {"de.cognovis.fhir.praxis": {"version": "0.66.0"}}}
    drifts = sync.compute_drifts(consumers, manifest)
    assert {(drift.package, drift.current, drift.expected) for drift in drifts} == {
        ("de.cognovis.fhir.praxis", "0.45.0", "0.66.0"),
        ("io.cognovis.de-identification.de", "0.10.0", "0.11.0"),
    }


def test_generated_provenance_reports_stale_polaris_codegen(tmp_path):
    generated_root = tmp_path / "polaris" / "packages" / "fhir-de" / "generated"
    profile = (
        generated_root
        / "de-cognovis-fhir-dental"
        / "de-cognovis-fhir-dental"
        / "profiles"
        / "CarePlan_DentalCarePlanDE.ts"
    )
    profile.parent.mkdir(parents=True)
    profile.write_text(
        """
// WARNING: This file is autogenerated by @atomic-ehr/codegen.
// CanonicalURL: https://fhir.cognovis.de/dental/StructureDefinition/dental-care-plan (pkg: de.cognovis.fhir.dental#0.30.0)
""".lstrip(),
        encoding="utf-8",
    )
    manifest = {"igs": {"de.cognovis.fhir.dental": {"version": "0.35.0"}}}

    drifts = sync.compute_drifts([], manifest, (generated_root,))

    assert [
        (drift.file, drift.package, drift.current, drift.expected, drift.action)
        for drift in drifts
    ] == [
        (
            generated_root,
            "de.cognovis.fhir.dental",
            "0.30.0",
            "0.35.0",
            "REGENERATE",
        )
    ]


def test_generated_provenance_uses_local_sushi_self_version(tmp_path):
    sushi = tmp_path / "fhir-deidentification-de" / "sushi-config.yaml"
    sushi.parent.mkdir()
    sushi.write_text(
        """
id: io.cognovis.de-identification.de
version: 0.11.0
dependencies: {}
""".lstrip(),
        encoding="utf-8",
    )
    generated_root = tmp_path / "polaris" / "packages" / "fhir-de" / "src" / "client" / "generated"
    generated_root.mkdir(parents=True)
    (generated_root / "pii-fields.ts").write_text(
        """
/**
 * MACHINE-GENERATED: DO NOT EDIT
 *
 * Source: io.cognovis.de-identification.de@0.10.0
 */
""".lstrip(),
        encoding="utf-8",
    )

    consumer = sync.read_consumer_file(sushi)
    assert consumer is not None
    drifts = sync.compute_drifts([consumer], {}, (generated_root,))

    assert [
        (drift.file, drift.package, drift.current, drift.expected, drift.action)
        for drift in drifts
    ] == [
        (
            generated_root,
            "io.cognovis.de-identification.de",
            "0.10.0",
            "0.11.0",
            "REGENERATE",
        )
    ]


def test_regeneration_followup_names_bead_workstream_and_checks(tmp_path, capsys):
    drift = sync.Drift(
        file=tmp_path / "polaris" / "packages" / "fhir-de" / "generated",
        package="de.cognovis.fhir.dental",
        current="0.30.0",
        expected="0.35.0",
        action="REGENERATE",
    )

    sync.print_regeneration_followup([drift])

    output = capsys.readouterr().out
    assert "Regeneration follow-up suggested:" in output
    assert "new Polaris bead/workstream" in output
    assert "de.cognovis.fhir.dental 0.30.0 -> 0.35.0" in output
    assert "bun run --cwd packages/fhir-de generate" in output
    assert "bun run --cwd packages/fhir-de check:deidentification" in output
    assert "Fix generation/type/test issues" in output
    assert "Commit, pull --rebase or merge current main, push beads data, and git push" in output


def test_manifest_ahead_row_prints_local_manifest_registry_state(tmp_path, capsys):
    drift = sync.Drift(
        file=tmp_path / "sushi-config.yaml",
        package="de.cognovis.fhir.dental",
        current="0.36.0",
        expected="0.35.0",
        action="RELEASE_LOCAL_OR_UPDATE_MANIFEST",
        registry="0.35.0",
    )

    sync.print_drift_table([drift])

    output = capsys.readouterr().out
    assert "LOCAL/ACTUAL" in output
    assert "MANIFEST/EXPECTED" in output
    assert "REGISTRY" in output
    assert "0.36.0" in output
    assert "0.35.0" in output
    assert "RELEASE_LOCAL_OR_UPDATE_MANIFEST" in output
    assert "0.36.0 -> 0.35.0" not in output


def test_registry_metadata_drift_reports_published_package_stale_dependency():
    expected_versions = {
        "de.cognovis.fhir.praxis": "0.66.0",
        "de.cognovis.terminology.imaging": "1.0.0",
    }

    def load_package(package_name, version, registry):
        if package_name == "de.cognovis.fhir.praxis":
            return {"dependencies": {"de.cognovis.terminology.imaging": "2026.0.0"}}
        return {"dependencies": {}}

    drifts = sync.compute_registry_metadata_drifts(
        expected_versions, "https://registry.example.invalid", load_package
    )

    assert [
        (
            drift.file,
            drift.package,
            drift.current,
            drift.expected,
            drift.action,
            drift.registry,
        )
        for drift in drifts
    ] == [
        (
            sync.Path("npm:de.cognovis.fhir.praxis@0.66.0/package.json"),
            "de.cognovis.terminology.imaging",
            "2026.0.0",
            "1.0.0",
            "REGISTRY_METADATA_STALE",
            "de.cognovis.fhir.praxis@0.66.0",
        )
    ]


def test_aux_pin_drift_reports_workflow_and_script_version_duplicates(tmp_path):
    repo_root = tmp_path / "fhir-dental-de"
    workflow = repo_root / ".github" / "workflows" / "ig-ci.yml"
    action = repo_root / ".github" / "actions" / "preload" / "action.yml"
    script = repo_root / "scripts" / "prefetch-praxis.sh"
    workflow.parent.mkdir(parents=True)
    action.parent.mkdir(parents=True)
    script.parent.mkdir(parents=True)
    workflow.write_text(
        "uses: cognovis/fhir-praxis-de/.github/actions/preload@v0.67.0\n",
        encoding="utf-8",
    )
    action.write_text(
        "- de.cognovis.terminology.imaging@1.0.0 (transitive dep from de.cognovis.fhir.praxis)\n",
        encoding="utf-8",
    )
    script.write_text(
        "# fhir-praxis-de pinned to 0.65.0\nPRACTICE_VERSION=0.1.0\n",
        encoding="utf-8",
    )

    drifts = sync.compute_aux_pin_drifts(
        {"de.cognovis.fhir.praxis": "0.66.0"},
        {"de.cognovis.fhir.dental": repo_root},
    )

    assert [
        (drift.file, drift.package, drift.current, drift.expected, drift.action)
        for drift in drifts
    ] == [
        (
            workflow,
            "de.cognovis.fhir.praxis",
            "0.67.0 (line 1)",
            "0.66.0",
            "AUX_PIN_DRIFT",
        ),
        (
            script,
            "de.cognovis.fhir.praxis",
            "0.65.0 (line 1)",
            "0.66.0",
            "AUX_PIN_DRIFT",
        ),
    ]


def test_topological_release_order_uses_manifest_dependency_edges():
    manifest = {
        "packages": {
            "de.cognovis.terminology.imaging": {"version": "1.0.0"},
        },
        "igs": {
            "de.cognovis.fhir.praxis": {
                "version": "0.66.0",
                "dependencies": {"de.cognovis.terminology.imaging": "1.0.0"},
            },
            "de.cognovis.fhir.dental": {
                "version": "0.36.0",
                "dependencies": {"de.cognovis.fhir.praxis": "0.66.0"},
            },
        },
    }
    expected_versions = sync.build_transitive_expected_versions(manifest)

    cycle_nodes, order = sync.topological_release_order(manifest, expected_versions)

    assert cycle_nodes == []
    assert order.index("de.cognovis.terminology.imaging") < order.index(
        "de.cognovis.fhir.praxis"
    )
    assert order.index("de.cognovis.fhir.praxis") < order.index(
        "de.cognovis.fhir.dental"
    )


def test_topological_release_order_uses_local_sushi_dependency_edges(tmp_path):
    manifest = {
        "igs": {
            "de.cognovis.fhir.praxis": {"version": "0.67.0"},
            "de.cognovis.fhir.dental": {"version": "0.36.0"},
        },
    }
    sushi = tmp_path / "sushi-config.yaml"
    sushi.write_text(
        """
id: de.cognovis.fhir.dental
version: 0.36.0
dependencies:
  de.cognovis.fhir.praxis: 0.67.0
""".lstrip(),
        encoding="utf-8",
    )
    consumer = sync.read_consumer_file(sushi)
    assert consumer is not None

    cycle_nodes, order = sync.topological_release_order(
        manifest, sync.build_transitive_expected_versions(manifest), [consumer]
    )

    assert cycle_nodes == []
    assert order.index("de.cognovis.fhir.praxis") < order.index(
        "de.cognovis.fhir.dental"
    )


def test_release_plan_prints_relevant_release_order(tmp_path, capsys):
    manifest = {
        "igs": {
            "de.cognovis.fhir.praxis": {"version": "0.67.0"},
            "de.cognovis.fhir.dental": {"version": "0.36.0"},
        },
        "packages": {
            "de.cognovis.terminology.imaging": {"version": "1.0.0"},
        },
    }
    sushi = tmp_path / "sushi-config.yaml"
    sushi.write_text(
        """
id: de.cognovis.fhir.dental
version: 0.36.0
dependencies:
  de.cognovis.fhir.praxis: 0.67.0
""".lstrip(),
        encoding="utf-8",
    )
    consumer = sync.read_consumer_file(sushi)
    assert consumer is not None
    drift = sync.Drift(
        file=tmp_path / "generated",
        package="de.cognovis.fhir.dental",
        current="0.35.0",
        expected="0.36.0",
        action="REGENERATE",
    )

    sync.print_release_plan(
        manifest, sync.build_transitive_expected_versions(manifest), [drift], [consumer]
    )

    output = capsys.readouterr().out
    assert "Relevant release order:" in output
    assert output.index("de.cognovis.fhir.praxis@0.67.0") < output.index(
        "de.cognovis.fhir.dental@0.36.0"
    )
    assert "de.cognovis.terminology.imaging@1.0.0" not in output


def test_tag_release_drifts_report_tag_release_and_registry_mismatches(
    tmp_path, monkeypatch
):
    repo_root = tmp_path / "fhir-dental-de"
    sushi = repo_root / "sushi-config.yaml"
    repo_root.mkdir()
    sushi.write_text(
        """
id: de.cognovis.fhir.dental
version: 0.36.0
dependencies: {}
""".lstrip(),
        encoding="utf-8",
    )
    monkeypatch.setattr(sync, "git_tag_exists", lambda repo, tag: True)
    monkeypatch.setattr(
        sync,
        "git_show_file",
        lambda repo, ref, path: "id: de.cognovis.fhir.dental\nversion: 0.35.0\n",
    )
    monkeypatch.setattr(sync, "github_release_exists", lambda repo, tag: False)
    monkeypatch.setattr(
        sync, "registry_package_version_exists", lambda package, version, registry: False
    )

    drifts = sync.compute_tag_release_drifts(
        {"de.cognovis.fhir.dental": "0.35.0"},
        "https://registry.example.invalid",
        {"de.cognovis.fhir.dental": repo_root},
    )

    assert [drift.action for drift in drifts] == [
        "TAG_VERSION_MISMATCH",
        "TAG_WITHOUT_RELEASE",
        "TAG_WITHOUT_REGISTRY_PACKAGE",
    ]
