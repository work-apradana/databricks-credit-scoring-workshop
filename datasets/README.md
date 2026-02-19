# Databricks Workshop - Credit Decisioning Dataset

## Overview

This dataset simulates a **credit decisioning** scenario for an Indonesian bank. It contains applicant profiles, loan applications, and payment history — designed to walk through the full Databricks medallion architecture (Bronze → Silver → Gold) and build a simple credit scoring model.

---

## Dataset Files

### 1. `data_nasabah.csv` — Applicant Profiles
**1,000 rows** | Primary Key: `applicant_id`

| Column | Type | Description |
|--------|------|-------------|
| `applicant_id` | String | Unique applicant ID (e.g., APP00001) |
| `ktp_number` | String | 16-digit Indonesian national ID (KTP) |
| `nama_lengkap` | String | Full name |
| `jenis_kelamin` | String | Gender |
| `tanggal_lahir` | Date | Date of birth (YYYY-MM-DD) |
| `usia` | Integer | Age in years |
| `status_pernikahan` | String | Marital status: Menikah, Belum Menikah, Cerai |
| `jumlah_tanggungan` | Integer | Number of dependents |
| `pendidikan_terakhir` | String | Education level: SD, SMP, SMA, D3, S1, S2, S3 |
| `jenis_pekerjaan` | String | Employment type: PNS, BUMN, Swasta, Wiraswasta, Profesional, TNI/Polri |
| `lama_bekerja_tahun` | Integer | Years of employment |
| `pendapatan_bulanan` | Numeric | Monthly income in IDR |
| `kota` | String | City of residence |
| `provinsi` | String | Province |
| `no_telepon` | String | Phone number |
| `hutang_bulanan_existing` | Integer | Existing monthly debt obligations in IDR |

---

### 2. `data_pinjaman.csv` — Loan Applications
**1,255 rows** | Primary Key: `loan_id` | Foreign Key: `applicant_id` → `data_nasabah`

| Column | Type | Description |
|--------|------|-------------|
| `loan_id` | String | Unique loan ID (e.g., LN000001) |
| `applicant_id` | String | Reference to applicant in `data_nasabah` |
| `tujuan_pinjaman` | String | Loan purpose: KPR, KKB, Kredit Multiguna, Modal Usaha, Renovasi Rumah, Pendidikan, Kredit Tanpa Agunan, Konsumtif |
| `jumlah_pinjaman` | Numeric | Loan amount in IDR |
| `tenor_bulan` | Integer | Loan tenure in months |
| `suku_bunga_persen` | Float | Annual interest rate (%) |
| `angsuran_bulanan` | Integer | Monthly installment amount in IDR |
| `tanggal_pengajuan` | Date | Application date (YYYY-MM-DD) |
| `status_persetujuan` | String | Approval status: Disetujui, Ditolak, Dalam Proses |
| `skor_kredit` | Integer | Credit score (1–5, where 1 = best) |
| `agunan` | String | Has collateral: Ya / Tidak |
| `nilai_agunan` | Integer | Collateral value in IDR |
| `flag_default` | Integer | **Target variable** — 1 = defaulted, 0 = not defaulted (only for approved loans) |

---

### 3. `data_pembayaran.csv` — Payment History
**3,855 rows** | Primary Key: `payment_id` | Foreign Key: `loan_id` → `data_pinjaman`

| Column | Type | Description |
|--------|------|-------------|
| `payment_id` | String | Unique payment ID (e.g., PAY0000001) |
| `loan_id` | String | Reference to loan in `data_pinjaman` |
| `bulan_ke` | Integer | Payment month number (1, 2, 3, …) |
| `tanggal_jatuh_tempo` | Date | Payment due date (YYYY-MM-DD) |
| `tanggal_bayar` | Date | Actual payment date (empty if not paid) |
| `jumlah_angsuran` | Numeric | Expected installment amount in IDR |
| `jumlah_dibayar` | Numeric | Actual amount paid in IDR |
| `denda` | Integer | Late fee in IDR |
| `status_pembayaran` | String | Payment status: Tepat Waktu, Terlambat, Gagal Bayar |
| `hari_keterlambatan` | Integer | Days past due |

---

## Relationships

```
┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
│  data_nasabah    │       │  data_pinjaman    │       │ data_pembayaran  │
│  (1,000 rows)    │       │  (1,255 rows)     │       │ (3,855 rows)     │
│                  │       │                   │       │                  │
│  applicant_id PK │──1:N──│  applicant_id FK  │       │                  │
│                  │       │  loan_id PK       │──1:N──│  loan_id FK      │
│                  │       │                   │       │  payment_id PK   │
└──────────────────┘       └───────────────────┘       └──────────────────┘
```

- **Nasabah → Pinjaman** (one-to-many): Each applicant has 1–2 loan applications.
- **Pinjaman → Pembayaran** (one-to-many): Each **approved** loan has 1–12 monthly payment records. Rejected and pending loans have no payment history.

---

## Data Quality Issues (for Silver Layer Cleaning)

Each file contains exactly **3 dirty columns**. All other columns are clean.

| Cleaning Action | data_nasabah | data_pinjaman | data_pembayaran |
|----------------|--------------|---------------|-----------------|
| **Standardize categorical values** | `jenis_kelamin` (Male, Pria, L, perempuan, …) | `status_persetujuan` (Approved, disetujui, DITOLAK, …) | `status_pembayaran` (On Time, tepat waktu, TERLAMBAT, …) |
| **Trim whitespace** | `nama_lengkap` ("&nbsp;&nbsp;Adi Wijaya&nbsp;&nbsp;") | `tujuan_pinjaman` ("KPR&nbsp;&nbsp;") | — |
| **Remove currency prefix** | `pendapatan_bulanan` (Rp 5450000, IDR 3000000) | `jumlah_pinjaman` (Rp. 159300000) | `jumlah_angsuran` and `jumlah_dibayar` (Rp/IDR prefix) |

**What is NOT dirty:** No missing values, no duplicate rows, no broken foreign keys, no inconsistent date formats.

---

## Medallion Architecture Usage

### Bronze Layer (Raw Ingestion)
Load the 3 CSV files as-is into Delta tables. No transformation.

### Silver Layer (Clean & Standardize)
Apply 3 cleaning actions:
1. **Trim whitespace** — Remove leading/trailing spaces from text fields
2. **Standardize categorical values** — Map all variants to a single standard value (e.g., "Male", "Pria", "L" → "Laki-laki")
3. **Remove currency formatting** — Strip "Rp", "Rp.", "IDR" prefixes and cast to numeric

### Gold Layer (Business-Ready)
1. **Aggregate** `data_pembayaran` per `loan_id` (e.g., count late payments, average days past due, payment-on-time ratio)
2. **Join** all 3 tables: `nasabah` ← `pinjaman` ← `aggregated pembayaran`
3. **Filter** to approved loans only (`flag_default` = 0 or 1)
4. **Engineer features** such as debt-to-income ratio, loan-to-collateral ratio
5. Use the resulting table for **credit scoring model** with `flag_default` as the target variable

---

## Credit Scoring Model Guide

**Target variable:** `flag_default` (1 = defaulted, 0 = not defaulted)

**Suggested features:**
- From nasabah: `usia`, `pendidikan_terakhir`, `jenis_pekerjaan`, `lama_bekerja_tahun`, `pendapatan_bulanan`, `jumlah_tanggungan`, `hutang_bulanan_existing`
- From pinjaman: `jumlah_pinjaman`, `tenor_bulan`, `suku_bunga_persen`, `angsuran_bulanan`, `skor_kredit`, `agunan`, `nilai_agunan`
- From pembayaran (aggregated): count of late payments, count of missed payments, average days past due, payment-on-time ratio
- Engineered: `debt_to_income_ratio` = angsuran_bulanan / pendapatan_bulanan, `loan_to_collateral_ratio` = jumlah_pinjaman / nilai_agunan

**Recommended model for workshop demo:** Logistic Regression or Decision Tree (easy to interpret for a bank audience).
