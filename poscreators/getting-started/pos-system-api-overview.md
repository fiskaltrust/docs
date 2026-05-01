---
slug: /poscreators/pos-system-api-overview
title: POS System API – Technical Overview
---

# POS System API – Technical Overview

The **fiskaltrust POS System API** is the central, process-driven interface between a POS system and the **fiskaltrust.Middleware**. It provides a unified HTTP/JSON API to execute all fiscal-relevant operations required by a compliant POS integration.

Through this API, POS systems interact with the Middleware to:

- Register order and payment data
- Fiscalize and cryptographically seal receipts
- Issue digital or printable receipts
- Export journal data for audits and closings

The POS System API acts as the **single technical entry point** for fiscalization, payments, issuing, and data export, independent of country-specific fiscal rules.

## Process-Driven and Idempotent Design

The API follows a **processual, state-based design**. Each transaction is handled as a sequence of state transitions on the server side, comparable to a finite state machine.

Key characteristics:

- Each request represents one step in a fiscal process
- Calls are **idempotent** and safe to retry
- The backend guarantees deterministic results for repeated calls

To enable safe retries, every request must include a unique **operation identifier** (`x-operation-id`). If a request is repeated with the same identifier, the Middleware either:

- Returns the already completed result, or
- Blocks until the original operation finishes

This approach ensures robustness against network interruptions and timeouts without risking duplicate fiscal actions.

## Authentication and Identification

The POS System API is always accessed **in the context of a CashBox**.

Each request must include:

- `x-cashbox-id` – identifies the target CashBox
- `x-cashbox-accesstoken` – authenticates the caller
- `x-possystem-id` – identifies the registered POS system variant
- `x-operation-id` – ensures idempotent execution

All access credentials are managed and issued via the **fiskaltrust Portal** as part of the CashBox configuration.

## Core API Endpoints

The API exposes a compact, consistent set of endpoints covering the full fiscal lifecycle:

- `/echo` – connectivity check and health verification
- `/order` – register order data and query processing state
- `/pay` – execute and monitor payment processing
- `/sign` – finalize and fiscalize receipts according to national rules
- `/issue` – generate and manage digital or printable receipts
- `/journal` – retrieve audit-relevant journal data

Each endpoint performs a well-defined step within the overall fiscal workflow and contributes to a traceable, compliant transaction chain.

## Versioning and Compatibility

The POS System API uses **semantic versioning**:

- Breaking changes are introduced only in major versions
- Non-breaking changes may add fields without altering existing models
- If no version is specified, the latest available version is used

This guarantees backward compatibility while allowing regulatory and functional extensions over time.
