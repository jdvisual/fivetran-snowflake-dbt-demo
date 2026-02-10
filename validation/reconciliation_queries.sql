-- ============================================
-- Reconciliation Queries (RAW validation)
-- ============================================

-- 1) Row counts by sync date (detect gaps/spikes)
select
  cast(_fivetran_synced as date) as sync_date,
  count(*) as row_count
from raw.fivetran_postgres.claims
group by 1
order by 1 desc;

-- 2) Null checks on key fields (example)
select
  count(*) as null_claim_id_rows
from raw.fivetran_postgres.claims
where claim_id is null;

-- 3) Duplicate business key detection (example)
select
  claim_id,
  count(*) as cnt
from raw.fivetran_postgres.claims
group by 1
having count(*) > 1
order by cnt desc;

-- 4) Soft-delete visibility (if supported)
select
  _fivetran_deleted,
  count(*) as row_count
from raw.fivetran_postgres.claims
group by 1;
