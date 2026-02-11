# Fivetran → dbt → Snowflake Claims Pipeline (ELT Demo)

## Overview

This project demonstrates a production-style healthcare claims data pipeline built using **Fivetran**, **dbt**, and **Snowflake**, following a **medallion architecture (Bronze → Silver → Gold)**.

The focus is on data quality, deduplication, and analytics readiness—mirroring real-world payer and TPA environments where claims accuracy directly impacts billing, accumulators, and financial reporting.

---

## Architecture

 PostgreSQL (Source System) | Fivetran Ingestion | Snowflake `RAW.FIVETRAN_POSTGRES.CLAIMS` | dbt Bronze: `stg_claims_raw` | dbt Silver: `claims_deduped` | dbt Gold: `member_claims_summary`


## dbt Documentation & Lineage

This project leverages dbt's built-in documentation and lineage features to make data
flows transparent and auditable.

The documentation captures:
- model dependencies and execution order
- column-level metadata
- test coverage and results
- end-to-end lineage from raw ingestion to analytics outputs

This enables faster onboarding, easier troubleshooting, and greater confidence in
downstream reporting.

---

## Data Quality Strategy

Data quality is enforced at multiple layers of the pipeline.

### Source-Level Controls
- Not-null checks on primary identifiers (`claim_id`, `member_id`)
- Early detection of ingestion failures or malformed source data

### Transformation-Level Controls
- Deterministic deduplication logic in the Silver layer
- Canonical record selection using load timestamps
- Clear separation between raw, cleaned, and aggregated data

These controls ensure that downstream models operate on trusted, consistent data.

---

## Scalability & Incremental Processing

The pipeline is designed with scalability in mind.

Key models—particularly `claims_deduped`—are structured to support incremental
processing, allowing new or changed claims to be processed efficiently without
rebuilding historical data.

This pattern supports high-volume claims ingestion while maintaining predictable
performance as data grows.

---

## Operational Considerations

In a production environment, this pipeline supports:
- late-arriving data
- source reprocessing and replay
- deterministic re-runs
- auditability across layers

The architecture enables reliable backfills and controlled downstream impact when
upstream data changes.

---

## Intended Use Cases

The Gold-layer outputs are suitable for:
- member utilization reporting
- financial summaries and reconciliation
- quality measurement pipelines (e.g., HEDIS-style analytics)
- BI dashboards and downstream machine learning workflows
