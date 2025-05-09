#!/bin/bash

export GITHUB_REPO_URI="${NOMAD_VAR_GITHUB_REPO_URI}"
export GITHUB_BRANCH="${NOMAD_VAR_GITHUB_BRANCH}"
export NOMAD_ADDR="${NOMAD_VAR_NOMAD_ADDR}"
export NOMAD_ACL_TOKEN="${NOMAD_VAR_NOMAD_ACL_TOKEN}"

cd /app
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
