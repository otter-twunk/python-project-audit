#!/usr/bin/env bash
set -uo pipefail

echo "========================================"
echo "   Python Project Audit Safe Checks"
echo "========================================"

echo ""
echo "== Python version =="
python --version 2>/dev/null || python3 --version 2>/dev/null || echo "python not found in PATH"

echo ""
echo "== Dependency consistency =="
pip check 2>/dev/null || echo "pip check completed with warnings/errors or pip not available"

echo ""
echo "== Lint (Ruff) =="
if command -v ruff >/dev/null 2>&1; then 
  ruff check . || true
else
  echo "ruff not installed / not configured"
fi

echo ""
echo "== Format check (Ruff) =="
if command -v ruff >/dev/null 2>&1; then 
  ruff format --check . || true
else
  echo "ruff not installed / not configured"
fi

echo ""
echo "== Type check (mypy) =="
if command -v mypy >/dev/null 2>&1; then 
  mypy . || true
else
  echo "mypy not installed / not configured"
fi

echo ""
echo "== Tests (pytest) =="
if [ -d "tests" ] || [ -d "test" ]; then
  if command -v pytest >/dev/null 2>&1; then 
    pytest -q || true
  else
    echo "pytest not installed / not configured in PATH"
  fi
else
  echo "No tests/ or test/ directory found in current working directory"
fi

echo ""
echo "== Dependency vulnerabilities (pip-audit) =="
if command -v pip-audit >/dev/null 2>&1; then 
  pip-audit || true
else
  echo "pip-audit not installed / not configured"
fi

echo ""
echo "========================================"
echo "   Safe Audit Checks Completed"
echo "========================================"
