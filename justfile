set shell := ["bash", "-euo", "pipefail", "-c"]

# List the recipes.
default:
    @just --list

# Install the pinned tools and validation dependencies.
install:
    mise install
    python3 -m pip install --disable-pip-version-check -r requirements-dev.txt

# Format the repository.
fmt:
    bun scripts/format.ts

# Fail when a file needs formatting.
fmt-check:
    bun scripts/format.ts --check

# Syntax-check shell, lint it, validate YAML, and lint the workflows.
lint:
    git ls-files -z '*.sh' | xargs -0 -n1 bash -n
    shellcheck --severity=warning --external-sources $(git ls-files '*.sh')
    python3 automation/validate-yaml.py
    actionlint
    zizmor .github/workflows

# Run the portable mock suites; no Docker, network, or live server.
test:
    bash automation/run-tests.sh

# Redacted secret scan: the pull request diff in CI, full history otherwise.
secrets:
    bun scripts/secrets.ts

# Everything CI requires.
check: fmt-check lint test

# Install the committed git hooks.
hooks:
    git config --local core.hooksPath .githooks

# Fail when .agents/skills and .claude/skills disagree.
agent-files:
    bun scripts/agent-files.ts
