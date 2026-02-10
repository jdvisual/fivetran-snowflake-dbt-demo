# Ingestion Controls (Fivetran → Snowflake)

## Purpose
Fivetran is responsible for **managed ingestion** into Snowflake RAW.
dbt is responsible for **standardization, validation, deduplication, and business logic** in Bronze/Silver/Gold.

This separation preserves auditability and supports repeatable backfills.

---

## Landing Zone (Snowflake RAW)
**Database/Schema convention**
- RAW database: `RAW`
- Schema: `FIVETRAN_<SOURCE>` (example: `FIVETRAN_POSTGRES`)

**Table characteristics**
- Raw tables are append/update as delivered by the connector.
- No business rules are applied in RAW.

**Fivetran metadata columns (typical)**
- `_FIVETRAN_SYNCED` : timestamp of when the row was last synced
- `_FIVETRAN_DELETED` : boolean indicator for soft-deletes (when supported)
- Optional connector-specific fields (varies by source)

---

## Sync Strategy
### Incremental ingestion
Fivetran uses the best available strategy per source:
- Log-based (preferred, if CDC is available)
- Timestamp/updated_at based
- Full refresh when incremental is not possible

---

## Reconciliation (Source → RAW)
### What we validate
1. **Counts by load date**
   - Compare counts grouped by `_FIVETRAN_SYNCED::date`
2. **Key integrity**
   - Ensure primary identifiers are not null
3. **Duplicate patterns**
   - Identify duplicate business keys that require downstream dedupe rules

### What “good” looks like
- No unexpected ingestion gaps (missing days/batches)
- No sustained spikes/drops without an explained upstream cause
- Row-level changes correlate with known updates/backfills

---

## Failure Handling
- Fivetran connector failures are surfaced via connector status/alerts.
- Data quality failures are surfaced via dbt tests (severity-driven).
- Backfills are performed by re-syncing historical ranges (source-dependent) and re-running dbt.

---

## Ownership Boundaries
- **Fivetran owns** connectivity, incremental sync mechanics, schema drift capture.
- **Data Engineering owns** reconciliation logic, dedupe/business rules, and analytics models (dbt).
