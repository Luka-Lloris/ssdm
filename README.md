# ẞDM (쓰담) — 프로젝트 구조

```
sdm/
├── backend/
│   ├── .env.example      # 환경변수 템플릿
│   ├── schema.sql        # Supabase 초기 스키마
│   ├── main.py           # FastAPI 엔트리포인트 (B 단계)
│   ├── routers/          # API 라우터 (B 단계)
│   ├── services/         # OCR, 분류, 유효기간 계산 (B 단계)
│   └── requirements.txt  # (B 단계)
│
└── frontend/
    ├── .env.example      # 환경변수 템플릿
    └── ...               # React 앱 (C 단계)
```

## 클라우드 구성 (A)

| 역할 | 서비스 |
|------|--------|
| Backend | Railway |
| Frontend | Vercel |
| DB | Supabase (PostgreSQL) |
| Storage | Supabase Storage |

## NAS 전환 (B) — BEP 이후

`backend/.env`의 `DATABASE_URL` 한 줄만 교체.  
코드 수정 없음.
