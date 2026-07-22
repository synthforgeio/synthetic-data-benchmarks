# Synthetic data benchmarks + open field-type catalog

Two open, code-verified artifacts from the team behind
[SynthForge](https://synthforge.io) (synthetic / test-data generator with
multi-table foreign-key integrity):

1. **Benchmark results** comparing schema-driven generation (SynthForge) against
   a learned baseline (CTGAN) on public datasets, with methodology and numbers.
2. The **field-type catalog** (152 types across 19 categories) as plain JSON.

**License: MIT.** The generator product is not in this package. This is
reference data, metrics, and methodology only.

> **Public repo:** [github.com/synthforgeio/synthetic-data-benchmarks](https://github.com/synthforgeio/synthetic-data-benchmarks)
>
> Maintainer sync source in the private monorepo: `distribution/oss-synthetic-data-benchmarks/`.

## Why publish this

Most "our synthetic data is great" claims are unfalsifiable. These numbers are
not: the methodology is documented, the catalog is inspectable, and the same
results render at <https://synthforge.io/benchmarks>.

## What the benchmark measures

For each real public dataset (UCI Adult Census Income, UCI Credit Card Default)
we score two synthesizers on four axes:

- **Fidelity** — how closely the synthetic distribution matches the real one
  (column shapes + column-pair trends).
- **ML utility** — train-on-synthetic / test-on-real vs train-on-real.
- **Privacy distance** — how far synthetic rows sit from real ones (DCR / NNDR).
- **Integrity** — fraction of rows satisfying declared schema constraints.

## What the results show (read before quoting)

They are a **tradeoff, not a leaderboard win**. CTGAN trains on the real
dataset, so it reproduces that dataset's statistics more closely. That is
expected.

SynthForge generates from a **schema it is given, with no access to the real
data**. Rows sit farther from real records (higher privacy distance) and
satisfy declared constraints (integrity 1.0 on the published runs).

**Honest takeaway:** if you **have** a real dataset and want a statistically
faithful synthetic copy, a learned model (CTGAN, or privacy-grade tools like
NVIDIA NeMo / Tonic) is the right call. If you **do not have the data yet**
(greenfield fixtures, pre-launch, cannot touch production), schema-driven
generation fits, and it never ingests a real record.

## Layout

```text
catalog/catalog.json     # 152 field types, 19 categories
results/results.json     # latest published benchmark run
results/results-history.json
docs/methodology.md      # how numbers are produced (monorepo-linked)
scripts/sync-from-monorepo.sh
```

## The open field-type catalog

`catalog/catalog.json` is the SynthForge field-type registry: 152 types in 19
categories (personal, financial, medical, technical, geographic, and more),
each with a category, primitive, and examples. Browse it, diff it, reuse it.

## What SynthForge does (and does not) do

- **Does:** multi-table generation where every foreign key references a real
  parent in one pass; SQL dialects + JSON/JSONL + Parquet; AI schema design;
  hosted MCP for agents (`mcp.synthforge.io`).
- **Does not:** de-identify real production data; differential privacy; Excel
  export. For those, see Tonic or NVIDIA NeMo.

## Links

- App (free web sessions): <https://app.synthforge.io>
- Benchmarks page: <https://synthforge.io/benchmarks>
- Hosted MCP: <https://synthforge.io/docs/mcp>
- DuckDB integration: <https://synthforge.io/integrations/duckdb>
- Honest alternatives: <https://synthforge.io/alternatives/faker>

## Sync from the monorepo (maintainers)

From the SynthForge monorepo root:

```bash
./distribution/oss-synthetic-data-benchmarks/scripts/sync-from-monorepo.sh
```


## License

MIT. Use it, fork it, check our numbers.
