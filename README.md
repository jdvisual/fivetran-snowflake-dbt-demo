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

## Design Decisions & Tradeoffs

Several intentional design decisions were made to balance data quality, performance,
and operational simplicity.

### Medallion Architecture
A Bronze → Silver → Gold structure was chosen to:
- isolate raw ingestion from business logic
- enable safe reprocessing and backfills
- make data quality enforcement explicit

### Deduplication in the Silver Layer
Claims deduplication is performed in the Silver layer rather than at ingestion to:
- preserve raw source fidelity
- allow deterministic replay of source data
- support evolving business rules without reloading raw data

### Materialization Choices
- Bronze models favor lightweight transformations to minimize compute cost
- Silver models prioritize correctness and determinism
- Gold models are optimized for downstream consumption

These tradeoffs favor reliability and transparency over premature optimization.

---

## Production Hardening Checklist

The following items represent standard production hardening steps for this pipeline:

- [x] Clear separation of raw, cleaned, and aggregated data
- [x] Source-level integrity tests on key identifiers
- [ ] Source freshness checks with alerting
- [ ] Incremental processing for high-volume models
- [ ] Row count and financial reconciliation across layers
- [ ] Data contract validation for downstream consumers
- [ ] Monitoring for late-arriving and reprocessed data
- [ ] CI enforcement for tests and documentation generation

This checklist reflects common requirements in regulated and financially sensitive
data environments.

---

## Mapping to Real Healthcare Claims Systems

This pipeline mirrors patterns commonly found in healthcare payer and TPA data
platforms.

### Source Characteristics
- Append-only claim files
- Periodic reprocessing of historical data
- Late-arriving adjustments and corrections

### Operational Realities
- Claims may appear multiple times with different load timestamps
- Financial fields must remain auditable across versions
- Downstream consumers require stable, trusted aggregates

### Platform Alignment
- Fivetran handles ingestion and schema drift
- dbt enforces transformation logic, testing, and lineage
- Snowflake provides scalable storage and compute separation

These patterns support reliable analytics while maintaining traceability and control
across the full claims lifecycle.
