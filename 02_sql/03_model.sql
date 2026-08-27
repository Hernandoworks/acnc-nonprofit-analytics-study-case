-- Study Case 01 | ACNC Charity Analytics
-- 03_model.sql
-- Purpose: build the canonical relational model from the cleaned source.

CREATE SCHEMA IF NOT EXISTS acnc;

-- Canonical entity: one charity per valid ABN.
CREATE TABLE IF NOT EXISTS acnc.charities (
    charity_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    abn TEXT UNIQUE NOT NULL,
    charity_name TEXT,
    registration_status TEXT,
    charity_website TEXT,
    charity_size TEXT,
    basic_religious_charity BOOLEAN,
    ais_due_date DATE,
    date_ais_received DATE,
    financial_report_date_received DATE,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.financials (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    fin_report_from DATE,
    fin_report_to DATE,
    cash_or_accrual TEXT,
    type_of_financial_statement TEXT,
    revenue_from_government NUMERIC,
    donations_and_bequests NUMERIC,
    revenue_from_goods_and_services NUMERIC,
    revenue_from_investments NUMERIC,
    all_other_revenue NUMERIC,
    total_revenue NUMERIC,
    total_expenses NUMERIC,
    net_surplus_deficit NUMERIC,
    total_assets NUMERIC,
    total_liabilities NUMERIC,
    net_assets_liabilities NUMERIC,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.workforce (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    staff_full_time NUMERIC,
    staff_part_time NUMERIC,
    staff_casual NUMERIC,
    total_full_time_equivalent_staff NUMERIC,
    staff_volunteers NUMERIC,
    key_management_personnel BOOLEAN,
    number_of_key_management_personnel NUMERIC,
    total_paid_to_key_management_personnel NUMERIC,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.operations (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    conducted_activities TEXT,
    why_charity_did_not_conduct_activities TEXT,
    international_activities_details TEXT,
    how_purposes_were_pursued TEXT,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.reporting (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    report_consolidated_with_more_than_one_entity BOOLEAN,
    charity_report_has_a_modification BOOLEAN,
    type_of_report_modification TEXT,
    charity_has_reportable_related_party_transactions BOOLEAN,
    relevant_transactions TEXT,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.registration (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    incorporated_association BOOLEAN,
    association_number_act TEXT,
    association_number_nsw TEXT,
    association_number_nt TEXT,
    association_number_qld TEXT,
    association_number_sa TEXT,
    association_number_tas TEXT,
    association_number_vic TEXT,
    association_number_wa TEXT,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

CREATE TABLE IF NOT EXISTS acnc.fundraising (
    charity_id BIGINT PRIMARY KEY REFERENCES acnc.charities(charity_id),
    fundraising_act BOOLEAN,
    fundraising_number_act TEXT,
    fundraising_nsw BOOLEAN,
    fundraising_number_nsw TEXT,
    fundraising_nt BOOLEAN,
    fundraising_qld BOOLEAN,
    fundraising_number_qld TEXT,
    fundraising_sa BOOLEAN,
    fundraising_number_sa TEXT,
    fundraising_tas BOOLEAN,
    fundraising_number_tas TEXT,
    fundraising_vic BOOLEAN,
    fundraising_number_vic TEXT,
    fundraising_wa BOOLEAN,
    fundraising_number_wa TEXT,
    fundraising_online BOOLEAN,
    source_file TEXT,
    etl_batch_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_hash TEXT
);

-- Canonical population example.
INSERT INTO acnc.charities (abn, charity_name, registration_status, charity_size, source_file, etl_batch_id, record_hash)
SELECT
    abn, charity_name, registration_status, charity_size,
    source_file, etl_batch_id,
    MD5(CONCAT_WS('|',abn,charity_name,registration_status,charity_size))
FROM staging.v_acnc_clean s
WHERE s.abn IS NOT NULL
ON CONFLICT (abn) DO UPDATE
SET charity_name = EXCLUDED.charity_name,
    registration_status = EXCLUDED.registration_status,
    charity_size = EXCLUDED.charity_size,
    source_file = EXCLUDED.source_file,
    etl_batch_id = EXCLUDED.etl_batch_id,
    record_hash = EXCLUDED.record_hash,
    updated_at = NOW();
