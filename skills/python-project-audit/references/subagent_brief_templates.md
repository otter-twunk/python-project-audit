# Subagent Brief Templates for Python Project Audit

When invoking subagents via `invoke_subagent`, the orchestrator provides a self-contained brief following this standardized contract.

---

## 1. Repository Reconnaissance Brief

```text
ROLE: Python Repository Reconnaissance Specialist

OBJECTIVE:
Map the repository structure, entry points, dependencies, build/test configuration, deployment targets, and documentation.

REPOSITORY CONTEXT:
Target repository: {repo_name}
Target scope: {directory_or_whole_repo}

SCOPE:
Root files (README, pyproject.toml, setup.cfg, requirements*.txt, Dockerfile, Makefile, CI workflows in .github/workflows/), entry-point modules, and package top-level structure.

MUST REVIEW:
- Detect packaging tooling (uv, poetry, pipenv, setup.py, flit, hatch).
- Identify application entry points (CLI, FastAPI/Flask/Django routes, Celery workers, background scripts).
- Inventory test suites and CI checks configured.
- Identify containerization, Dockerfiles, and runtime deployment specs.
- Note documentation completeness vs reality.

MUST NOT DO:
- Do not modify files.
- Do not install packages.
- Do not run destructive commands.
- Do not contact external services.
- Do not invent findings without file or configuration evidence.

EVIDENCE REQUIREMENTS:
- Cite exact file paths and line ranges.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Architecture & Entry Points Map: compact Markdown bullet list.
3. Detected Tooling & Dependencies: compact summary table.
4. Key file inventory.
5. Open questions or unmapped areas.

DEFINITION OF DONE:
Architecture map, packaging inventory, and entry points verified against repository files.
```

---

## 2. Security Review Brief

```text
ROLE: Python Security Reviewer

OBJECTIVE:
Inspect the target codebase for injection surfaces, unsafe deserialization/APIs, secret leaks, authentication/authorization gaps, network exposure, and container risks.

REPOSITORY CONTEXT:
Target repository: {repo_name}
Target components: {components_or_paths}

SCOPE:
{specific_directories_or_modules, e.g. src/auth/, src/api/, src/storage/}

MUST REVIEW:
- Injection risks: SQL, shell/command execution, path traversal, template injection, pickle/YAML deserialization.
- Unsafe APIs: eval(), exec(), pickle.loads(), yaml.load(), subprocess(..., shell=True).
- Authentication and token/session validation.
- Secrets handling: hardcoded keys, passwords, tokens in logs, .env commitments.
- Outbound network requests, SSRF controls, TLS verification flags (verify=False).
- Container execution user (root vs non-root) and capabilities.

MUST NOT DO:
- Do not modify files.
- Do not install packages.
- Do not run active exploits or network probes.
- Do not contact external services.
- Do not invent findings without file or configuration evidence.

EVIDENCE REQUIREMENTS:
- Cite exact file paths and line ranges.
- Quote only the minimal relevant code snippet needed to justify the finding.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Findings table: ID, severity (Critical/High/Medium/Low/Informational), file/location, finding, impact, recommendation, confidence.
3. Key evidence: concise file/line references and minimal snippets.
4. Blocked or unverified checks.

DEFINITION OF DONE:
All files in designated scope reviewed for the listed risk classes with concrete evidence cited.
```

---

## 3. Code Correctness & Concurrency Brief

```text
ROLE: Python Core Correctness & Concurrency Reviewer

OBJECTIVE:
Review core Python modules for logic bugs, unhandled edge cases, concurrency/async hazards, resource leaks, and type mismatches.

REPOSITORY CONTEXT:
Target repository: {repo_name}
Target modules: {modules}

SCOPE:
{specific_files_and_directories}

MUST REVIEW:
- Logic flaws, incorrect conditionals, off-by-one errors, timezone naive datetimes, floating point currency math.
- Async/await misuse: blocking sync I/O inside async functions, unhandled task exceptions, task cancellation leaks.
- Concurrency & race conditions: check-then-act races, shared mutable state without locks.
- Resource management: unclosed file handles, unmanaged database connections, leaked threads/subprocesses.
- Exception handling: bare `except:`, swallowed exceptions, misleading re-raises without `from exc`.
- Mutable default arguments and unsafe object mutations.

MUST NOT DO:
- Do not modify files.
- Do not install packages.
- Do not run destructive commands.
- Do not invent findings without file evidence.

EVIDENCE REQUIREMENTS:
- Cite exact file paths and line ranges.
- Describe reproducible trigger conditions or inputs.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Findings table: ID, severity, file/location, bug/failure mode, trigger condition, impact, recommendation, confidence.
3. Key evidence: concise file/line references.
4. Blocked checks.

DEFINITION OF DONE:
All scoped modules reviewed with concrete failure scenarios for each finding.
```

---

## 4. Reliability & Operational Hardening Brief

```text
ROLE: Python Reliability & Production Operability Reviewer

OBJECTIVE:
Assess failure handling, timeouts, retries, graceful shutdown, schema migrations, and production observability.

REPOSITORY CONTEXT:
Target repository: {repo_name}

SCOPE:
{service_handlers, worker_loops, database_access, network_clients}

MUST REVIEW:
- Timeouts and deadline propagation on all network, socket, and database calls.
- Retry policies: backoff, jitter, idempotency safeguards.
- Graceful shutdown: SIGTERM/SIGINT signal handlers, in-flight work draining.
- Configuration validation: fail-fast on startup for missing/invalid environment variables.
- Observability: structured logging, log levels, sensitive data filtering, health check endpoints (liveness/readiness).
- Database migration safety: locking, reversibility, transaction boundaries.

MUST NOT DO:
- Do not modify files.
- Do not run destructive load tests.
- Do not invent findings without configuration/code evidence.

EVIDENCE REQUIREMENTS:
- Cite exact file paths and line ranges.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Findings table: ID, severity, file/location, finding, operational impact, recommendation, confidence.
3. Key evidence: concise file/line references.
4. Operational gaps summary.

DEFINITION OF DONE:
All networked, worker, and database interfaces checked for timeouts, shutdown, and error resiliency.
```

---

## 5. Testing & Verification Review Brief

```text
ROLE: Python Test & QA Specialist

OBJECTIVE:
Evaluate test coverage against critical failure paths, test quality, CI pipeline execution, and missing regression tests.

REPOSITORY CONTEXT:
Target repository: {repo_name}

SCOPE:
tests/ directory, test configuration (pytest.ini, pyproject.toml, tox.ini), and CI workflows.

MUST REVIEW:
- Test coverage across critical business logic vs trivial paths.
- Testing of negative cases, failure paths, timeouts, boundary values, and permission errors.
- Test isolation: shared state between tests, flaky tempfile/network dependencies, mock leakage.
- CI gate verification: what CI actually runs on pull requests vs what is documented.
- Missing integration and property-based test opportunities.

MUST NOT DO:
- Do not modify tests or files.
- Do not run destructive test commands.

EVIDENCE REQUIREMENTS:
- Cite test file paths, line ranges, or missing test targets.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Test gap analysis table: Area, Risk level, Current test state, Missing test scenario, Recommended test type.
3. CI test gates assessment.
4. Prioritised test implementation list.

DEFINITION OF DONE:
Gap analysis completed with concrete test scenarios mapped to critical codebase paths.
```

---

## 6. Dependency & Supply Chain Hygiene Brief

```text
ROLE: Python Supply Chain & Dependency Reviewer

OBJECTIVE:
Review package manifests, lockfiles, version pinning, known vulnerability surfaces, and dependency hygiene.

REPOSITORY CONTEXT:
Target repository: {repo_name}

SCOPE:
pyproject.toml, setup.py, requirements*.txt, uv.lock, poetry.lock, Pipfile.lock.

MUST REVIEW:
- Unpinned or floating dependency ranges in production requirements.
- Missing or out-of-date lockfiles.
- Known vulnerable packages or abandonware dependencies.
- Dual packaging / build-system discrepancies (e.g. poetry and setup.py drifting).
- Bloat: oversized dependencies imported for trivial utilities.

MUST NOT DO:
- Do not install or upgrade packages.
- Do not alter lockfiles or manifests.

EVIDENCE REQUIREMENTS:
- Cite exact dependency lines and lockfile entries.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Dependency risk table: Package, Installed/pinned version, Issue/vulnerability, Risk level, Recommended action.
3. Dependency hygiene recommendations.

DEFINITION OF DONE:
All direct dependencies and lockfile invariants evaluated against supply chain best practices.
```

---

## 7. Documentation & Maintainability Review Brief

```text
ROLE: Python Codebase Maintainability & Docs Reviewer

OBJECTIVE:
Assess documentation accuracy, onboarding clarity, public API typing/docstrings, dead code, and modular architecture.

REPOSITORY CONTEXT:
Target repository: {repo_name}

SCOPE:
README.md, docs/, top-level modules, public interfaces, configuration examples.

MUST REVIEW:
- README accuracy: setup instructions, prerequisites, example commands vs actual repository layout.
- API documentation and docstring coverage on public methods.
- Type annotations coverage across module boundaries.
- Unused/dead code, orphaned modules, and speculative abstractions (YAGNI).
- Code modularity: single responsibility, circular import risks, clean layer boundaries.

MUST NOT DO:
- Do not modify files.
- Do not make style-only nitpicks.

EVIDENCE REQUIREMENTS:
- Cite exact documentation and source file lines.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Documentation discrepancies table: Doc file/line, Stated behavior, Actual code reality, Impact, Suggested update.
3. Maintainability & dead code register.

DEFINITION OF DONE:
README and documentation verified against implementation reality; maintainability risks documented.
```

---

## 8. Plan & Roadmap Alignment Validation Brief

```text
ROLE: Python Software Architect & Plan Validator

OBJECTIVE:
Compare stated architectural plans, issues, or roadmaps against actual code implementation to find discrepancies, unfulfilled assumptions, and design risks.

REPOSITORY CONTEXT:
Target repository: {repo_name}

SCOPE:
PLANS.md, ARCHITECTURE.md, roadmap docs, open specs, and corresponding core implementation modules.

MUST REVIEW:
- Stated goals vs implemented capabilities: what is done, what is partial, what is missing.
- Architectural assumptions: are assumptions about data volume, hardware, concurrency, or external APIs realistic?
- Architectural debt or premature complexity introduced contrary to plan.
- Contradictory design decisions across different modules or docs.

MUST NOT DO:
- Do not modify plans or code.
- Do not speculate without cross-checking implementation.

EVIDENCE REQUIREMENTS:
- Cross-reference plan lines with code implementation lines.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Plan validity & alignment matrix: Stated plan item, Implementation status (Complete / Partial / Diverged / Missing), Code reference, Gap description.
3. Fragile or unverified assumptions.
4. Architectural recommendations.

DEFINITION OF DONE:
Full cross-comparison between documentation plan items and concrete repository code.
```
