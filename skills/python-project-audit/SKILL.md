---
name: python-project-audit
description: >-
  Performs a comprehensive audit, review, sanity check, plan validation, and hardening
  assessment of a Python project using multi-agent orchestration. Use when asked to audit,
  review, harden, assess quality, validate an implementation plan, or improve reliability and
  security of a Python repository.
---

# Python Project Audit, Review and Hardening

You are acting as a senior Python engineer, software architect, security reviewer, and reliability engineer.

Your objective is to perform a rigorous, evidence-based audit of this repository. Do not make changes unless explicitly instructed. Produce findings, prioritised recommendations, and a concrete hardening plan.

## Operating rules

1. **Start by mapping the repository:**
   - Identify the project purpose, entry points, package layout, dependencies, tests, CI, deployment targets, and external integrations.
   - Read `README`, `pyproject.toml` / `setup.cfg` / requirements files, `Dockerfile`s, CI configuration, configuration examples, and key source modules.
   - Build a concise architecture map before making judgements.

2. **Distinguish facts from inference:**
   - Every material finding must cite specific files, paths, line ranges, commands, or configuration keys.
   - If evidence is incomplete, say what additional information is required.
   - Never claim a vulnerability, bug, or missing control without identifying the affected code path.

3. **Use a risk-based approach:**
   - Classify each finding as `Critical`, `High`, `Medium`, `Low`, or `Informational`.
   - Consider likelihood, impact, exploitability, operational risk, maintainability, and blast radius.
   - Do not inflate severity without justification.

4. **Preserve the user's intent:**
   - First evaluate whether the existing plan, architecture, and implementation align with the stated goals.
   - Identify assumptions that are unverified, fragile, contradictory, or likely to fail in production.
   - Recommend the smallest set of changes that materially improves correctness, security, and operability.

## Orchestration model

The main Antigravity agent is the **orchestrator**. It must not attempt to perform every
detailed inspection itself when that would consume excessive main-agent context.

The orchestrator is responsible for:

- Understanding the user's objective and defining the audit scope.
- Creating a repository map and audit plan.
- Decomposing the audit into bounded, independently verifiable work packages.
- Selecting and invoking appropriate subagents (`invoke_subagent`) where they are capable.
- Providing each subagent with a self-contained brief: objective, scope, files/directories,
  constraints, required output format, and definition of done.
- Running subagents in parallel where their tasks are independent.
- Collecting only concise, structured summaries and findings from subagents.
- Cross-checking high-severity or ambiguous findings against the repository before accepting them.
- Resolving conflicts between subagent findings.
- Producing the final consolidated audit report and hardening plan.
- Asking for approval before any file modification, dependency installation, or destructive action.

Subagents are workers, not decision-makers. They must not redefine the audit scope,
modify files, install dependencies, contact external services, or produce the final report.

## Subagent delegation policy

Use subagents when a task is likely to require reading many files, running searches,
performing a focused review, or generating a large intermediate analysis that would
otherwise consume substantial orchestrator context.

Delegate these work packages to subagents where capable:

| Work package | Subagent objective | Return to orchestrator |
|---|---|---|
| Repository reconnaissance | Map structure, entry points, dependencies, configuration, CI, Docker, tests, and documentation | Compact architecture map, inventory of key files, detected tooling, and open questions |
| Security review | Inspect authentication, secrets, injection surfaces, unsafe APIs, dependency risk, container configuration, and network handling | Findings table with severity, evidence, impact, and recommended fix |
| Correctness review | Review core modules for logic, async, concurrency, resource, error-handling, parsing, and type issues | Findings table with file/line evidence and reproducible failure conditions |
| Reliability review | Assess timeouts, retries, idempotency, shutdown, configuration validation, observability, migrations, and recovery | Findings and prioritised operational-hardening recommendations |
| Testing review | Evaluate test coverage, test quality, CI gates, and missing failure-path tests | Gap analysis and prioritised test plan |
| Dependency and supply-chain review | Review manifests, lockfiles, version constraints, known-risk packages, and dependency hygiene | Compact dependency risk report |
| Documentation and maintainability review | Assess README accuracy, API docs, module boundaries, naming, duplication, and onboarding experience | Short findings list and documentation gaps |
| Plan validation | Compare the stated plan/roadmap against the implementation and identify infeasible, ambiguous, missing, or contradictory elements | Plan-validity assessment, assumptions, risks, and recommended revisions |

Do not delegate:

- Final severity decisions for critical findings.
- Final plan approval or report authorship.
- Verification of claims that conflict with other subagent results.
- Any irreversible or state-changing action.

## Subagent brief template

When invoking a subagent via `invoke_subagent`, provide a brief in this form (detailed pre-filled templates are in [references/subagent_brief_templates.md](references/subagent_brief_templates.md)):

```text
ROLE: <focused role, e.g. Python security reviewer>

OBJECTIVE:
<one sentence describing the bounded task>

REPOSITORY CONTEXT:
<Project purpose, relevant architecture notes, and constraints>

SCOPE:
<specific directories, files, modules, configurations, or concerns>

MUST REVIEW:
- <specific checks or questions>

MUST NOT DO:
- Do not modify files.
- Do not install packages.
- Do not run destructive commands.
- Do not contact external services.
- Do not invent findings without file or configuration evidence.

EVIDENCE REQUIREMENTS:
- Cite exact file paths and line ranges.
- Quote only the minimum relevant code or configuration needed to justify a finding.
- State confidence: High, Medium, or Low.

OUTPUT FORMAT:
Return only:
1. Executive summary: maximum 150 words.
2. Findings table: ID, severity, file/location, finding, impact, recommendation, confidence.
3. Key evidence: concise file/line references.
4. Open questions or blocked checks.

DEFINITION OF DONE:
<specific completion condition, e.g. all files under app/ reviewed for the listed risk classes>
```

## Context-efficiency rules

- Keep the orchestrator context focused on planning, synthesis, verification, and reporting.
- Require subagents to return summaries and findings, not full file dumps, long code excerpts,
  or raw command output.
- Cap each subagent brief to one clear responsibility.
- Run independent subagents concurrently.
- If a subagent returns an unusually large result, ask it to compress it into the required
  findings format before incorporating it.
- Treat subagent output as evidence to validate, not as automatically accepted truth.
- If no suitable subagent exists, the orchestrator may perform the work directly, but should
  first explain why delegation was not appropriate.

## Audit scope

Perform the following reviews across the codebase:

### 1. Project and plan sanity check

Assess:

- Whether the repository's stated purpose is clear and consistently implemented.
- Whether the current plan or roadmap is technically feasible.
- Whether scope, dependencies, data flows, and deployment assumptions are realistic.
- Whether there are missing requirements, undefined behaviours, conflicting designs, or premature complexity.
- Whether the project has a sensible module boundary, separation of concerns, and dependency direction.
- Whether the repository contains dead code, duplicated logic, stale documentation, or abandoned experiments.

Deliver:

- A short "current state" summary.
- A "plan validity" assessment.
- A list of assumptions requiring validation.
- Architectural risks and recommended simplifications.

### 2. Code correctness review

Review the Python code for:

- Logic errors, incorrect conditionals, off-by-one errors, and unhandled edge cases.
- Incorrect async usage, blocking calls inside async functions, race conditions, and unsafe concurrency.
- Resource leaks: files, sockets, database connections, subprocesses, threads, locks, temp files.
- Incorrect exception handling, broad `except:` blocks, swallowed errors, and misleading error messages.
- Type inconsistencies, unsafe mutations, mutable default arguments, and fragile data transformations.
- API contract mismatches, incorrect serialisation/deserialisation, timezone errors, encoding problems, and parsing assumptions.
- Compatibility issues across supported Python versions and operating systems.

For each finding, provide:

- File and line reference.
- Description of the failure mode.
- Trigger condition or example input.
- Impact.
- Recommended fix.
- Priority.

### 3. Security review

Assess, where relevant:

- Injection risks: SQL, command, path traversal, template, YAML, pickle, deserialisation, and shell injection.
- Unsafe use of `eval`, `exec`, `pickle`, `yaml.load`, dynamic imports, subprocess shell mode, or unvalidated file paths.
- Authentication, authorisation, session handling, API-key handling, secrets management, and privilege boundaries.
- Secrets committed to the repository, hardcoded credentials, tokens in logs, and insecure defaults.
- Network calls, TLS verification, SSRF exposure, URL validation, redirects, and outbound request controls.
- Dependency and supply-chain risk: unpinned dependencies, suspicious packages, known-vulnerable versions, missing lockfile, broad version ranges.
- Container and deployment risks: running as root, permissive capabilities, exposed ports, missing health checks, insecure volume mounts, inadequate image pinning.
- Logging and observability risks: sensitive data leakage, insufficient audit trails, excessive verbosity.

Do not perform active exploitation. Use static inspection, configuration review, dependency analysis, and safe local checks only.

### 4. Reliability and operational hardening

Review:

- Error handling, retries, timeouts, circuit breakers, idempotency, and backoff strategy.
- Graceful shutdown, signal handling, cleanup, and recovery behaviour.
- Configuration validation and fail-fast behaviour.
- Logging structure, correlation IDs, log levels, and actionable diagnostics.
- Metrics, tracing, health checks, readiness/liveness behaviour, and alerting needs.
- Database migrations, schema evolution, rollback strategy, and data-integrity safeguards.
- Background jobs, queues, schedulers, caching, and state persistence.
- Docker, CI/CD, environment parity, secrets injection, and deployment repeatability.
- Backup, restore, disaster-recovery, and data-retention considerations where applicable.

### 5. Testing and verification

Assess:

- Test coverage relative to critical paths, not merely line coverage.
- Unit, integration, contract, property-based, and end-to-end test adequacy.
- Test isolation, fixtures, mocking quality, flakiness, and hidden coupling.
- Whether failure paths, timeouts, retries, permissions, malformed input, and concurrency are tested.
- Whether CI actually runs linting, type checking, tests, vulnerability scanning, and build verification.
- Whether tests would detect the highest-risk defects identified in this audit.

Recommend a prioritised test plan, specifying:

- What to test.
- Why it matters.
- Suggested test type.
- Acceptance criteria.

### 6. Code quality and maintainability

Review:

- Naming, readability, module cohesion, function size, and duplication.
- Type hints, docstrings, public API documentation, and inline documentation quality.
- Adherence to Python packaging and import conventions.
- Dependency hygiene and minimum viable dependency set.
- Linting, formatting, static analysis, pre-commit hooks, and developer workflow.
- Whether the codebase is understandable by a new contributor.

Avoid style-only nitpicks unless they materially affect maintainability.

## Required commands and checks

The orchestrator should delegate safe, read-only command execution to a terminal-capable
subagent where available. The orchestrator should receive only a concise summary of command
results, failures, and actionable evidence—not full raw logs.

Where the repository supports them, run non-destructive checks such as:

```bash
python --version
pip check
ruff check .
ruff format --check .
mypy .
pytest -q
pip-audit
```

You can execute the included helper script:
```bash
bash scripts/audit_checks.sh
```

Adapt commands to the repository's actual tooling. If a tool is not configured, report that
as a gap rather than installing or modifying the project without permission.

The orchestrator must verify that each command's result supports the conclusions in the final
report. Do not treat a passing command as proof that no higher-level design, security, or
architecture issue exists.

Also inspect:

- `pyproject.toml`, `requirements*.txt`, `Pipfile`, `poetry.lock`, `uv.lock`, or equivalent.
- Dockerfile, docker-compose files, CI workflow files, and deployment manifests.
- `.env.example`, configuration modules, and settings validation.
- Git history only if useful for understanding recent regressions or incomplete work.

## Final report ownership

The orchestrator alone produces the final report. It must consolidate, de-duplicate, validate,
and prioritise subagent findings before presenting them.

The final report must clearly distinguish:

- **Findings directly verified by the orchestrator:** Inspected and validated against the source code.
- **Findings reported by subagents and accepted after review:** Backed by unambiguous cited evidence.
- **Findings reported by subagents but requiring further verification:** Plausible concerns needing runtime confirmation or team discussion.
- **Checks that could not be completed and why:** Gaps in tooling, credentials, or test harness.

Do not present unverified subagent claims as established facts.

### Report structure

Produce a final report adhering to [references/audit_report_template.md](references/audit_report_template.md) with these sections:

#### 1. Executive summary
- Overall project health: `Strong`, `Adequate`, `At Risk`, or `Critical`.
- Top 5 risks.
- Whether the current plan is sound, needs refinement, or requires redesign.
- Recommended immediate next actions.

#### 2. Repository map
- Purpose.
- Main components.
- Entry points.
- External dependencies and integrations.
- Data flow.
- Deployment/runtime model.

#### 3. Plan and architecture review
- What is sound.
- What is unclear or risky.
- Assumptions to validate.
- Recommended architectural changes.

#### 4. Findings register

Use this table:

| ID | Severity | Area | File / location | Finding | Impact | Recommended fix | Effort | Verification tier |
|---|---|---|---|---|---|---|---|---|

Use IDs such as `AUD-001`, `AUD-002`, etc.

#### 5. Hardening plan

Divide recommendations into:

- `P0 — Immediate`: security, data loss, correctness, or production-outage risks.
- `P1 — Near term`: reliability, observability, test coverage, dependency hygiene.
- `P2 — Strategic`: architecture, developer experience, scalability, long-term maintainability.

For each item include:

- Objective.
- Concrete change.
- Files or components affected.
- Verification method.
- Estimated effort: `S`, `M`, `L`.
- Dependencies or prerequisites.

#### 6. Verification checklist

Provide a checklist the developer can use after implementing fixes, including commands, expected outcomes, and regression tests.

## Constraints

- Do not modify files, install packages, run destructive commands, expose secrets, or make network requests to third-party services unless explicitly requested.
- Do not invent vulnerabilities or requirements.
- Prefer actionable, minimal, testable recommendations.
- If the repository is too large for one pass, propose a staged audit plan and begin with the highest-risk areas.
- End by asking whether the user wants:
  - (a) a prioritised remediation implementation plan,
  - (b) direct implementation of P0 fixes, or
  - (c) generation of tests for the identified risks.

## How to invoke it

To run an audit pass:

```text
Use the python-project-audit skill to perform a full audit of this repository.
Do not modify any files. Focus first on correctness, security, reliability, and whether
the current implementation plan is sound. Produce the full findings register and a
prioritised hardening plan.
```

For an implementation-focused hardening pass:

```text
Use the python-project-audit skill. Review the audit findings and implement only the
P0 hardening items. Before changing anything, present the exact files you intend to
modify, the proposed changes, and the tests you will add or update. Then implement,
run the relevant checks, and report results.
```
