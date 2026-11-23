# AGENTS.md — minecraft-setup

Scope: **every file in this repository** (repo-wide). This is the public,
portable setup template. The private running instance lives in
`minecraft-deployment`.

## What this repo is

Portable templates, operating guides, and reusable automation for a
whitelist-only Paper + Bedrock server. Start at [README.md](README.md) and
[docs/bootstrap.md](docs/bootstrap.md).

## Layout

- `docs/` — guides: bootstrap, whitelist, bedrock, bluemap, backups,
  world-reset, updating-plugins, testing, maintenance, local-recovery.
- `config/` — sanitized templates and `config/sources/*.env.example` source pins.
- `plugins/` — `plugins.list` / `test-plugins.list` pin format and release model.
- `automation/` — backup/verify/reset/report/build/install scripts (including
  the read-only `whitelist-check.sh` enforcement check and the BlueMap
  `bluemap-spawn-view.py` helper) and their mock tests.
- `seasons/` — sanitized, per-server/season policy records.
- `compose.yaml`, `.env.example` — MCSManager panel and documented variables.

## Privacy (public repo)

- Never commit secrets or instance values: hostnames, IPs, non-default ports,
  usernames, home paths, MCSManager ids/UUIDs, player names/UUIDs, whitelist/ops
  contents, seeds, coordinates, Discord ids, webhook URLs, tokens, passwords.
- Use placeholders such as `<SERVER_HOST>`, `<instance-data>`,
  `/srv/minecraft`, and `CHANGE_ME`.
- Never copy a file from the private deployment verbatim, and never merge its
  history. Replace each instance value, then scan the diff before pushing.

## Native-first default

MCSManager owns the container lifecycle; the itzg/Paper image owns the runtime.
Reuse the built-in environment, panel API, and plugin functions. Keep custom code
only for a documented gap (exact SHA-256 pins, backup verify/retention, shared
lifecycle lock, date cutoff, guarded reset, recovery). The deployment's map of
native vs. custom behavior is the reference for that split.

## Build / test

```bash
just install   # pinned tools plus PyYAML
just check     # formatting, bash -n, shellcheck, YAML validation, mock suites
just secrets   # redacted gitleaks scan
```

The mock suites run through `just test` (`automation/run-tests.sh`): no Docker,
network, or live server. CI also runs `just lint`, which covers `bash -n`,
shellcheck and YAML validation, and a separate `secrets` check. Any shell,
config, or doc change must keep `just check` green.

## Workflow

Read
[.agents/skills/portable-template-change/SKILL.md](.agents/skills/portable-template-change/SKILL.md)
for the sanitizing-port workflow. `origin` is the org repository. Branches live
in that repo, and PRs target `awepeeps/minecraft-setup`; history never
crosses into a private repo.
