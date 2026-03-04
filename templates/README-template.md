# README テンプレート

> 最終成果物 `project/README.md` の雛形。英語で記載し、末尾に日本語セクションを設ける。

---

以下がテンプレート本文:

---

```markdown
# Expense Reimbursement SaaS

> A multi-tenant expense reimbursement SaaS application built with Rust (Actix Web) and React (TypeScript).

## Overview

[1-2 paragraph description of the project, its purpose, and key features]

### Key Features

- Multi-tenant architecture with data isolation (application-level + PostgreSQL RLS)
- Role-based access control (Admin / Approver / Member / Accounting)
- Expense report workflow: draft → submitted → approved/rejected → paid
- Receipt upload with presigned URLs (S3)
- JWT authentication (RS256) with refresh token rotation

## Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Backend | Rust (Actix Web) | [brief reason] |
| Frontend | React (TypeScript, Vite) | [brief reason] |
| Database | PostgreSQL | [brief reason] |
| DB Access | SQLx | [brief reason] |
| Infrastructure | AWS (ECS Fargate, RDS, S3) | [brief reason] |
| CI/CD | GitHub Actions | [brief reason] |

## Architecture

[Architecture diagram - system components and data flow]

### Tenant Isolation

[Brief description of dual-layer tenant isolation: app-level WHERE clause + PostgreSQL RLS]

### RBAC

[Role permissions matrix]

## Getting Started

### Prerequisites

- Rust (latest stable)
- Node.js (v20+)
- Docker & Docker Compose
- PostgreSQL 16

### Setup

\```bash
# Clone the repository
git clone https://github.com/[username]/expense-reimbursement-saas.git
cd expense-reimbursement-saas

# Start local development environment
docker compose up -d

# Run database migrations
sqlx migrate run

# Start backend
cd apps/api && cargo run

# Start frontend (in another terminal)
cd apps/web && npm install && npm run dev
\```

### Environment Variables

[Table of required environment variables]

## API Documentation

[Link to OpenAPI/Swagger documentation or brief endpoint summary]

## Testing

\```bash
# Run backend tests
cargo test

# Run frontend tests
npm test

# Run E2E tests
npx playwright test
\```

### Test Coverage

- **Tenant isolation**: Verifies cross-tenant data access is impossible
- **RBAC**: Verifies unauthorized role operations return 403
- **Workflow**: Verifies invalid state transitions are rejected
- **Authentication**: Token expiration, refresh flow, logout

## Deployment

[Brief deployment instructions or link to runbook]

### Health Check

`GET /health` returns service status.

## Project Structure

\```
apps/
  api/          # Rust backend (Actix Web)
  web/          # React frontend (TypeScript, Vite)
database/
  migrations/   # SQLx migrations
docker/         # Docker configurations
infra/          # Terraform / IaC
tests/
  e2e/          # Playwright E2E tests
\```

## Design Decisions

See [ADR documents](./docs/adr/) for architectural decisions.

## License

[License information]

---

## 日本語セクション

### 概要

[日本語での概要説明]

### セットアップ

[日本語でのセットアップ手順（上記の補足）]
```
