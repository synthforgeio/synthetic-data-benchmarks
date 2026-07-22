# SynthForge public benchmarks — methodology

## What we measure

Four metric families per dataset, per synthesizer:

| Family | Metric | Source | Direction |
|---|---|---|---|
| Statistical fidelity | SDMetrics QualityReport — overall, column shapes, column pair trends | [sdv-dev/SDMetrics](https://github.com/sdv-dev/SDMetrics) | higher = better |
| ML utility | TSTR (Train-Synthetic-Test-Real) AUC and TRTR (Train-Real-Test-Real) AUC, for logistic regression and gradient boosting | [Esteban et al., 2017](https://arxiv.org/abs/1706.02633) | higher = better; closer TSTR-to-TRTR is the meaningful signal |
| Privacy | DCR (5th-percentile distance to closest record, normalised by intra-real median) and NNDR (median nearest-neighbour distance ratio) | standard tabular-privacy literature | DCR higher = better; NNDR closer to 1 = better |
| Constraint conformance | fraction of synthetic rows that satisfy all schema constraints (range, enum membership) | SynthForge | higher = better |

## What we run

- **SynthForge** at the commit recorded in `synthforge_commit` of `results.json`.
- **CTGAN** via SDV's `CTGANSynthesizer`, default hyperparameters, 300 epochs, seed 42.

Both synthesizers produce a synthetic dataset of the same size as the real dataset, then every metric is run on the (real, synthetic) pair.

## Datasets

- **UCI Adult** (Census Income, 1994). 48,842 rows, 14 features, binary income target. <https://archive.ics.uci.edu/dataset/2/adult>
- **UCI Credit Card Default** (Taiwan, 2005). 30,000 rows, 23 features, binary default target. <https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients>

## Schema authoring — important caveat

**SynthForge is schema-driven, not data-fitted.** For each dataset we hand-author a SynthForge schema from the *public UCI data dictionary* — documented column types, ranges, categorical sets, and standard demographic priors. We do **not** fit the SynthForge schema to the real CSV; doing so would presuppose a schema-import feature that is not part of the benchmarked product surface.

This is the honest framing of SynthForge: given only the public data dictionary, what does it produce? CTGAN, in contrast, sees the real data during training. This is a deliberate asymmetry that the benchmark exists to measure — a tool that needs no data access has different operational properties from one that does.

## Reproducibility

- Harness lives at `apps/generator/app/benchmarks/`; tests at `apps/generator/tests/benchmarks/`.
- CLI: `python -m app.benchmarks.cli --dataset all --output results.json`.
- Real CSVs are not committed; download instructions in `apps/generator/benchmarks_data/README.md`.
- All randomness uses seed 42 unless otherwise documented.
- Re-run any time. The page at `/benchmarks` displays the `generated_at` timestamp and the `synthforge_commit` from the most recent run committed to `www/src/data/benchmarks/results.json`.

## What we explicitly do not measure (and why)

- **Differential privacy guarantees (ε, δ).** SynthForge does not yet ship a DP-aware path; SmartNoise integration is on the roadmap, not the current product. Reporting DP without the math is misleading.
- **Image, text, time-series datasets.** Out of scope for tabular synthetic data benchmarks.
- **Membership-inference attacks against DP baselines.** Same gap as DP.

## What's missing today (to add later)

- A second non-CTGAN baseline (TabDDPM or copula). One open-source baseline is enough for v1.
- Multi-table benchmarks. Both UCI datasets here are single-table; the multi-table referential-integrity story is left for when a public multi-table benchmark anchor is chosen.
- CI regression gating. Benchmarks are run by hand for v1; wiring the CLI into CI as a nightly job is a deliberate Phase 4 follow-on.
