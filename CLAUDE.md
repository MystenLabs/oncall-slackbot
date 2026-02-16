# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
npm run build          # Compile TypeScript + resolve path aliases (tsc && tsc-alias)
npm start              # Build then run (node dist/src/app.js)
npm run lint           # ESLint with TypeScript rules
npm test               # Jest (no tests exist yet)
```

## Architecture

Slack bot using **@slack/bolt** (Socket Mode) that integrates with **PagerDuty** to summon on-call team members. Users mention `@oncall` or a shortcut name (e.g., `@pesui`) in Slack, and the bot looks up who's on-call via PagerDuty escalation policies, matches them to Slack users by email, and notifies them.

### Key Layers

- **`src/app.ts`** — Entry point. Creates Bolt app, registers listeners, starts on port 3000.
- **`src/listeners/`** — Slack event/message handlers, split into:
  - `events/app-mentioned.ts` — Handles `@bot` mentions in channels (routes to version/ls/help commands)
  - `messages/oncall-mentioned.ts` — Detects `@<shortname>` mentions via dynamic regex built from `oncall_map` config
  - `messages/app-mentioned-dm.ts` — Handles DM commands
  - `common/` — Shared command implementations (help, version, ls)
- **`src/api/`** — External API integrations:
  - `pd/pagerduty.ts` — PagerDuty API client with node-cache caching and pagination
  - `slack/index.ts` — Slack user lookup (matches PD users to Slack users by email)
  - `oncall/index.ts` — Bridge: `getOncallSlackMembers()` combines PD + Slack data

### Configuration

- **Environment variables** (`.env`): Slack credentials (see `env.sample`)
- **Runtime config** (`config/default.json`, not versioned): Created from `config/sample.json`. Uses `node-config` library. Contains Slack display settings, PagerDuty token, cache intervals, and `oncall_map` (shortname → escalation policy ID mappings).

### Path Aliases

Defined in `tsconfig.json`, resolved at build time by `tsc-alias`:
- `@src*` → `./src`
- `@types*` → `./src/types`
- `@api*` → `./src/api`

## Code Style

- ESLint extends `standard-with-typescript`
- Semicolons required, double quotes, semicolon member delimiters
- TypeScript strict mode enabled
