# Canonical Audit Report Template: Python Project Audit

When producing the final audit report, the orchestrator compiles and formats findings into this standard markdown document.

```markdown
# Repository Audit & Hardening Report: {Repository Name}

- **Date:** {YYYY-MM-DD}
- **Assumed Workload & Scale:** {Single-user CLI / Microservice / High-concurrency Web Service}
- **Audit Scope:** {Whole Repository / Scoped Path}
- **Orchestration Model:** Multi-agent distributed audit ({N} work packages evaluated)

---

## 1. Executive Summary

- **Overall Project Health:** `Strong` | `Adequate` | `At Risk` | `Critical`
- **Plan Soundness:** `Sound` | `Needs Refinement` | `Requires Redesign`
- **Top 5 Risks:**
  1. **{Risk 1}** — {Brief explanation and impact}
  2. **{Risk 2}** — {Brief explanation and impact}
  3. **{Risk 3}** — {Brief explanation and impact}
  4. **{Risk 4}** — {Brief explanation and impact}
  5. **{Risk 5}** — {Brief explanation and impact}
- **Immediate Recommended Actions:**
  - {Action 1}
  - {Action 2}

---

## 2. Repository Architecture & Runtime Map

- **Purpose:** {Two-to-three sentence summary of what the software does}
- **Package Layout & Main Components:**
  - `{dir/package}`: {role and responsibility}
- **Entry Points:**
  - CLI: `{entry_point}`
  - Web/API: `{route_definitions}`
  - Background/Workers: `{job_handlers}`
- **External Dependencies & Integrations:** {Databases, third-party APIs, message queues}
- **Data Flow:** {Where data enters, transforms, persists, and exits}
- **Deployment & Runtime Model:** {Docker, serverless, VM, local execution}

---

## 3. Plan & Architecture Review

- **Sound Elements:** {What is well-designed and implemented correctly}
- **Ambiguities & Design Risks:** {Gaps between intent and implementation}
- **Unverified Assumptions:** {Assumptions that require team confirmation or real-world verification}
- **Architectural Simplifications:** {Opportunities to reduce layers, delete dead code, or eliminate premature abstractions}

---

## 4. Consolidated Findings Register

| ID | Sev | Area | File / Location | Finding | Impact | Recommended Fix | Effort | Verification Tier |
|---|---|---|---|---|---|---|---|---|
| AUD-001 | Critical | Security | `src/auth.py:L45-52` | Hardcoded secret key fallback | Key leakage in production | Enforce mandatory env var check | S | Direct Orchestrator Verified |
| AUD-002 | High | Correctness | `src/worker.py:L112` | Unhandled task cancellation | Corrupts in-flight batch | Wrap in asyncio.CancelledError handler | M | Direct Orchestrator Verified |
| AUD-003 | Medium | Reliability | `src/client.py:L30` | Missing HTTP timeout | Worker hang on dead server | Set explicit timeout=10.0 | S | Subagent Accepted |

*Verification Tiers:*
- **Direct Orchestrator Verified:** Directly inspected in code and validated by orchestrator.
- **Subagent Accepted:** Reported by subagent with verified file/line evidence.
- **Requires Further Verification:** Reported but requires runtime simulation or team input.

---

## 5. Detailed Findings & Evidence

### AUD-001: {Title}
- **Severity:** `Critical` | **Category:** `Security`
- **Location:** [`file_path:Lxx-Lyy`](file:///path/to/file#Lxx-Lyy)
- **Problem & Concrete Failure Case:** {Precise explanation of what breaks and under what conditions}
- **Minimal Recommended Fix:**
  ```python
  # Proposed replacement code
  ```
- **Consequence If Skipped:** {Impact of inaction}
- **Verification Tier:** {Direct Orchestrator Verified / Subagent Accepted}

---

## 6. Prioritised Hardening Plan

### P0 — Immediate (Critical Security, Data Loss, Crash Risks)
- [ ] **H-01: {Action Title}**
  - **Objective:** {Why this must be fixed now}
  - **Affected Files:** [`file_path`](file:///path/to/file)
  - **Concrete Change:** {What to do}
  - **Verification:** {Command or test to confirm fix}
  - **Effort:** `S` (`< 2 hrs`) | `M` (`half-day`) | `L` (`> 1 day`)

### P1 — Near Term (Reliability, Observability, Test Quality)
- [ ] **H-02: {Action Title}**
  - **Objective:** {Operational resilience improvement}
  - **Affected Files:** [`file_path`](file:///path/to/file)
  - **Concrete Change:** {What to do}
  - **Verification:** {Test or metric}
  - **Effort:** `S` | `M` | `L`

### P2 — Strategic (Architecture, Tech Debt, Maintainability)
- [ ] **H-03: {Action Title}**
  - **Objective:** {Long-term health and developer ergonomics}
  - **Affected Files:** [`file_path`](file:///path/to/file)
  - **Concrete Change:** {What to do}
  - **Verification:** {Verification step}
  - **Effort:** `S` | `M` | `L`

---

## 7. Verification Checklist & Safe Commands

Run these checks to confirm baseline integrity after applying changes:

```bash
# 1. Environment & syntax
python --version
pip check

# 2. Linting & formatting
ruff check .
ruff format --check .

# 3. Static type analysis
mypy .

# 4. Automated tests
pytest -q

# 5. Security audit
pip-audit
```

---

## 8. Uncompleted & Blocked Checks

- **Checks not executed:** {e.g. End-to-end integration tests due to absent database credentials}
- **Excluded paths:** {e.g. legacy/ directory excluded per user instruction}
- **Reason:** {Why the check was skipped}
```
