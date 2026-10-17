---
name: cloudflare-workers-d1-en
description: Automated Cloudflare Workers (frontend + backend API) + Cloudflare D1 (SQLite cloud database) zero-key, zero-MCP closed-loop web system guide. Activate automatically when the user says "connect Cloudflare", "setup Cloudflare", "deploy to Cloudflare", "Cloudflare D1", "wrangler login", "build a web game with Cloudflare D1", or "follow AGENTS.md to connect Cloudflare".
---

# Cloudflare Workers + D1 Zero-Key Closed-Loop System (English Student Edition)

> Adapted from [agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)  
> Core Philosophy: **"Zero MCP setup, zero API keys or tokens to copy-paste! Frontend static site (Workers Assets) + Backend API (Worker) + Cloud SQL Database (D1) all live under one Cloudflare account. The student only clicks 'Allow' once in the browser."**

---

## 🎯 Your Role & Division of Labor (Mandatory)

Your user is likely a **student or educator without a backend engineering background**, using an **English-only computer environment**:

| The Student Only Does (3 Simple Actions) | The AI Agent Handles Everything Else |
| :--- | :--- |
| ① Sign up for Cloudflare if needed (enter Email + password and click the verification link in their inbox)<br>② Click **Allow** on the Cloudflare OAuth screen in the browser<br>③ Pick a `workers.dev` subdomain in the Cloudflare dashboard if prompted on first deploy | Environment checks, installing Node.js if missing, running all `npx.cmd -y wrangler` CLI commands, scaffolding frontend & backend files, creating the D1 database, running SQL migrations, deploying the Worker, verifying the live API, and printing the Completion Card |

1. **Pure English & ASCII-Safe Naming**:
   - Communicate 100% in clear, encouraging, jargon-free **English**.
   - Never ask the student to open a terminal, type CLI commands, or edit config files manually.
2. **One Action at a Time**:
   - Whenever the student needs to click **Allow**, verify their email, or set a `workers.dev` subdomain, **STOP and explain what to click in one clear sentence, then wait for the student to reply "Done" before continuing**.
3. **Windows PowerShell Compatibility (Critical)**:
   - On Windows PowerShell, always use **`npx.cmd -y wrangler ...`** (running bare `npx` triggers `npx.ps1`, which is blocked by Windows PowerShell `ExecutionPolicy` / `PSSecurityException`).
   - Do not chain commands with `&&`; run commands separately or use `;`.

---

## 🔒 Five Hard Safety & Pitfall Red Lines

1. **Never Ask For or Print Passwords, Tokens, or Keys**: This workflow uses 100% browser OAuth via `npx.cmd -y wrangler login`. **NEVER** ask the student to paste an API token or password, and never read or print `~/.wrangler/` credential files.
2. **Student Privacy & De-identification**: Database tables (such as leaderboards or quiz logs) must **only store `class_code`, `seat_no`, and `score`**. Never collect real full names, national ID numbers, phone numbers, or addresses.
3. **Lowercase Alphanumeric + Hyphen Names Only**: Both `"name"` in `wrangler.jsonc` and the D1 database name **must only contain lowercase letters `a-z`, digits `0-9`, and hyphens `-`** (starting with a letter, e.g., `alex-vocab-game`). Uppercase letters are rejected by Wrangler.
4. **Always Pass `--remote` to Migrations**: When applying SQL migrations, always run `npx.cmd -y wrangler d1 migrations apply <db-name> --remote --yes`. Omitting `--remote` only updates a local SQLite file, causing `no such table` errors on the live site.
5. **Use Workers Static Assets (Never Use Legacy `wrangler pages`)**: Cloudflare Pages is now unified into Workers. Always configure `"assets": { "directory": "./public", "run_worker_first": ["/api/*"] }` in `wrangler.jsonc` and deploy with `npx.cmd -y wrangler deploy`.

---

## 🧭 Complete 7-Step Automated Connection & Deployment Workflow

This workflow is **idempotent (resumable)**: always check current state first and skip any steps that are already completed.

### Step 0: Ask for an English Nickname & Confirm Project Goal
1. If the student hasn't given a nickname yet, ask:
   > "Please give me a short **English nickname** (lowercase letters and numbers only, e.g., `alex` or `student01`) so I can name your live website and cloud database!"
   *(Automatically convert any uppercase letters to lowercase).*
2. Determine resource names:
   - For a quick connection check: Worker name `<nickname>-hello`, D1 database `<nickname>-hello-db`.
   - For a custom game/app: Worker name `<nickname>-<project-slug>` (e.g., `alex-vocab-maze`), D1 database `<nickname>-<project-slug>-db`.

---

### Step 1: Local Environment & Wrangler Login Check
1. Check `node -v` and `npx.cmd -v`:
   - If Node.js is missing on Windows: run `winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements` (warn the student to click **Yes** on the Windows UAC prompt), then refresh PATH in PowerShell:
     ```powershell
     $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
     ```
2. Check if Wrangler is logged in with full OAuth scopes:
   ```powershell
   npx.cmd -y wrangler whoami
   ```
   - If the output shows the user's logged-in email address AND does **not** warn `Wrangler is missing some expected Oauth scopes` (must have both `workers:write` and `d1:write`), **skip Steps 2 and 3 and jump directly to Step 4**!
   - ⚠️ **Critical Pitfall**: If an older token only has `d1 (write)` and is missing `workers:write`, `wrangler deploy` will fail with `No access to the specified resource`. In that case, run Step 3 (`npx.cmd -y wrangler login`) so the student clicks **Allow** once to refresh the token scopes!

---

### Step 2: Confirm Cloudflare Account (Only if Not Logged In)
Ask the student: *"Do you already have a Cloudflare account (with your email verified)?"*
- **If NO**: Ask the student to open [https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up), sign up with their email and password, and **click the verification link sent to their email inbox** (check Spam if needed), then reply **"Done"**.

---

### Step 3: 🔑 [Student Key Action] Wrangler Browser OAuth Login
1. Run the login command:
   ```powershell
   npx.cmd -y wrangler login
   ```
2. Copy the `https://dash.cloudflare.com/oauth2/auth?...` URL from the terminal output, present it as a clickable link to the student, and explain:
   > "Please click the authorization link below (or check the browser window that just opened), sign in to Cloudflare, and click **`Allow`**!"
3. Once completed, run `npx.cmd -y wrangler whoami` to confirm the account email is displayed.
   - *Troubleshooting*: If the student clicks **Allow** but the terminal hangs waiting for `localhost:8976`, school Wi-Fi or antivirus may be blocking localhost callbacks—advise switching to a mobile hotspot or pasting the OAuth URL into their default system browser.

---

### Step 4: Create Standard Project Structure & D1 Cloud Database

In the project workspace (e.g., `C:\Users\hp\.gemini\antigravity\scratch\<project-name>`), create the unified full-stack directory structure:

```text
<project-folder>/
├── wrangler.jsonc                 ← Cloudflare Workers + D1 + Static Assets config
├── worker.js                      ← Backend API router (/api/* queries env.DB)
├── migrations/
│   └── 0001_init.sql              ← D1 SQLite schema & initial seed data
└── public/                        ← Frontend static files (same-origin, zero CORS!)
    ├── index.html
    ├── style.css
    └── app.js
```

#### 1. `wrangler.jsonc` Template (Lowercase `name` Required)
```jsonc
{
  "name": "<nickname>-<project>",
  "main": "worker.js",
  "compatibility_date": "2026-10-01",
  "assets": {
    "directory": "./public",
    "run_worker_first": ["/api/*"]
  }
}
```

#### 2. Create the D1 Database & Bind to `wrangler.jsonc`
Inside the project folder, run:
```powershell
npx.cmd -y wrangler d1 create <nickname>-<project>-db --binding DB --update-config
```
- Verify that `wrangler.jsonc` now contains `"d1_databases": [{ "binding": "DB", "database_name": "...", "database_id": "..." }]`.
- If the database already exists (`already exists`) or wasn't written to the file automatically, run `npx.cmd -y wrangler d1 list` to get its `uuid` and add the `d1_databases` block to `wrangler.jsonc`.

#### 3. `migrations/0001_init.sql` Template (CEFR B1/B2 Vocab + Leaderboard Example)
```sql
CREATE TABLE IF NOT EXISTS vocab (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  word TEXT NOT NULL,
  definition TEXT NOT NULL,
  example TEXT DEFAULT '',
  level TEXT DEFAULT 'B1'
);

CREATE TABLE IF NOT EXISTS leaderboard (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  class_code TEXT NOT NULL,
  seat_no TEXT NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  stage INTEGER NOT NULL DEFAULT 1,
  correct_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```
*(Seed 12 pure-English CEFR B1/B2 vocabulary items using `INSERT INTO vocab (word, definition, example, level) VALUES ...` at the bottom of `0001_init.sql`!)*

#### 4. `worker.js` Template (Same-Origin `/api/*` + Static Assets)
```javascript
const JSON_HEADERS = {
  "content-type": "application/json; charset=utf-8",
  "cache-control": "no-store"
};

function json(body, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: JSON_HEADERS });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === "/api/data" && request.method === "GET") {
      try {
        const { results: vocab } = await env.DB.prepare("SELECT * FROM vocab ORDER BY id ASC").all();
        const { results: leaderboard } = await env.DB.prepare(
          "SELECT class_code, seat_no, score, stage, correct_count, created_at FROM leaderboard ORDER BY score DESC LIMIT 15"
        ).all();
        return json({ ok: true, vocab, leaderboard });
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    if (url.pathname === "/api/score" && request.method === "POST") {
      try {
        const body = await request.json();
        await env.DB.prepare(
          "INSERT INTO leaderboard (class_code, seat_no, score, stage, correct_count) VALUES (?, ?, ?, ?, ?)"
        ).bind(
          String(body.classCode || "101").trim(),
          String(body.seatNo || "01").trim(),
          Number(body.score || 0),
          Number(body.stage || 1),
          Number(body.correctCount || 0)
        ).run();
        return json({ ok: true });
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    if (url.pathname === "/api/vocab" && request.method === "POST") {
      try {
        const body = await request.json();
        await env.DB.prepare(
          "INSERT INTO vocab (word, definition, example, level) VALUES (?, ?, ?, ?)"
        ).bind(
          String(body.word || "").trim(),
          String(body.definition || "").trim(),
          String(body.example || "").trim(),
          String(body.level || "B1").trim()
        ).run();
        return json({ ok: true });
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    return env.ASSETS.fetch(request);
  }
};
```

---

### Step 5: Apply Cloud Database Migrations (`--remote`)
Inside the project folder, run:
```powershell
npx.cmd -y wrangler d1 migrations apply <db-name> --remote --yes
```

---

### Step 6: Deploy to Cloudflare Workers
Inside the project folder, run:
```powershell
npx.cmd -y wrangler deploy
```
- Record the live URL printed in the output: `https://<worker-name>.<subdomain>.workers.dev`.
- ⚠️ **First-Time Subdomain Setup**: If Wrangler reports that the account needs a `workers.dev` subdomain, pause and guide the student:
  > "Since this is your first time deploying on this Cloudflare account, please open [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ Click **'Workers & Pages'** in the left sidebar ➔ Choose and save a custom `workers.dev` subdomain name. Reply **'Done'** once saved, and I'll finish deploying immediately!"

---

### Step 7: End-to-End Verification & Output Completion Card
1. Test the live API endpoint (e.g., fetch `https://<worker-name>.<subdomain>.workers.dev/api/data`) to verify that `{"ok":true,...}` is returned from D1.
2. Present the final Completion Card to the student:
   ```markdown
   🎉 **Cloudflare Full-Stack Web App + D1 Database Deployed!**
   - 🌐 **Live Public Website**: https://<worker-name>.<subdomain>.workers.dev
   - 🗄️ **Cloud D1 Database**: `<db-name>` (Tables initialized & verified ✅)
   - 🔒 **Security & Compatibility**: Zero API keys exposed, same-origin API (no CORS issues, works in any normal browser window on desktop or mobile!)
   ```

---

## 🛠️ Quick Troubleshooting Table

| Symptom / Error | Root Cause | Solution |
| :--- | :--- | :--- |
| Windows error: `cannot be loaded because running scripts is disabled` (`npx.ps1`) | PowerShell blocks `.ps1` scripts by default | Always use `npx.cmd -y wrangler ...` instead of `npx`. |
| Deploy fails asking to verify email | Cloudflare signup email not verified yet | Ask the student to check their email inbox/spam and click the Cloudflare verification link. |
| Deploy asks to register a `workers.dev` subdomain | Brand-new Cloudflare account | Have the student open Cloudflare Dashboard ➔ `Workers & Pages` to pick a subdomain name once. |
| API returns `no such table` | Forgot Step 5 or omitted `--remote` | Run `npx.cmd -y wrangler d1 migrations apply <db-name> --remote --yes`. |
| API returns `DB binding not found` | Missing `d1_databases` in `wrangler.jsonc` | Run `npx.cmd -y wrangler d1 list`, add the `d1_databases` block to `wrangler.jsonc`, and re-run `npx.cmd -y wrangler deploy`. |
