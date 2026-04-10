-- ẞDM Phase 1 Schema
-- 실행 위치: Supabase Dashboard > SQL Editor

-- ── 1. 회사 ────────────────────────────────────────────────
CREATE TABLE companies (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL,
    biz_no      TEXT,                          -- 사업자등록번호
    created_at  TIMESTAMPTZ DEFAULT now()
);

-- ── 2. 서류 원본 파일 ────────────────────────────────────────
CREATE TABLE documents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id      UUID REFERENCES companies(id) ON DELETE CASCADE,
    file_name       TEXT NOT NULL,
    storage_path    TEXT NOT NULL,             -- Supabase Storage 경로
    doc_type        TEXT,                      -- 자동 분류된 서류 종류
    raw_text        TEXT,                      -- OCR 추출 텍스트
    ocr_method      TEXT,                      -- 'pymupdf' | 'paddleocr'
    uploaded_at     TIMESTAMPTZ DEFAULT now()
);

-- ── 3. 유효기간 분석 결과 ────────────────────────────────────
CREATE TABLE validity_results (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID REFERENCES documents(id) ON DELETE CASCADE,
    issue_date      DATE,                      -- 발급일
    expire_date     DATE,                      -- 만료일
    status          TEXT NOT NULL,             -- 'valid' | 'expiring' | 'expired' | 'unconfirmed'
    status_reason   TEXT,                      -- 상태 판단 근거 (디버깅용)
    analyzed_at     TIMESTAMPTZ DEFAULT now()
);

-- ── 인덱스 ──────────────────────────────────────────────────
CREATE INDEX idx_documents_company ON documents(company_id);
CREATE INDEX idx_validity_document ON validity_results(document_id);
CREATE INDEX idx_validity_status   ON validity_results(status);

-- ── 마이그레이션 비고 ────────────────────────────────────────
-- BEP 이후 NAS 전환 시:
--   1. pg_dump -Fc [supabase_conn_string] > sdm_backup.dump
--   2. pg_restore -d [nas_conn_string] sdm_backup.dump
--   3. backend .env DATABASE_URL 교체 후 재배포
--   4. Supabase 프로젝트 일시정지
