---
name: cloudflare-workers-d1-en
description: OpenCode Edition: Automated Cloudflare Workers (frontend + backend API) + Cloudflare D1 (SQLite cloud database) zero-key, zero-MCP closed-loop web system guide. Designed for OpenCode reading a project-root AGENTS.md file, featuring built-in schemas for Week 10 (A2/B1/B2 Scaffolded Reading & Listening Web App) and Week 11 (L2 Pragmatics Politeness Branching Scenario Cards). Activate automatically in OpenCode when the user says "connect Cloudflare", "setup Cloudflare", "deploy to Cloudflare", "Cloudflare D1", "wrangler login", or "follow AGENTS.md to deploy to Cloudflare".
---

# OpenCode × Cloudflare Workers + D1 Zero-Key Closed-Loop System (English Student Edition)

> Adapted from [agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)  
> Target Environment: **OpenCode** (automatically reads `AGENTS.md` from the project root; also compatible with other AI coding agents)  
> Core Philosophy: **"Zero MCP setup, zero API keys or tokens to copy-paste! OpenCode reads `AGENTS.md` in the root folder and deploys Frontend static site (Workers Assets) + Backend API (Worker) + Cloud SQL Database (D1) under one Cloudflare account. The student only clicks 'Allow' once in the browser."**

---

## 🎯 Your Role as the OpenCode Agent & Division of Labor (Mandatory)

Your user is an **English-major student or educator without a backend engineering background**, working inside **OpenCode** via a project-root `AGENTS.md` file:

| The Student Only Does (3 Simple Actions) | The OpenCode Agent Handles Everything Else |
| :--- | :--- |
| ① Sign up for Cloudflare if needed (enter Email + password and click the verification link in their inbox)<br>② Click **Allow** on the Cloudflare OAuth screen in the browser<br>③ Pick a `workers.dev` subdomain in the Cloudflare dashboard if prompted on first deploy | Automatically reading root `AGENTS.md`, environment checks, installing Node.js if missing, running all `npx.cmd -y wrangler` CLI commands, scaffolding frontend & backend files, auto-creating the D1 database & tables, writing and applying SQL migrations (with pre-seeded learning content), deploying the Worker, verifying the live API, and printing the Completion Card |

1. **Pure English & Zero Manual Database Setup**:
   - Communicate 100% in clear, encouraging, jargon-free **English**.
   - Never ask the student to open a terminal, type CLI commands, create database tables manually, or edit config files by hand.
2. **One Action at a Time**:
   - Whenever the student needs to click **Allow**, verify their email, or set a `workers.dev` subdomain, **STOP and explain what to click in one clear sentence, then wait for the student to reply "Done" before continuing**.
3. **Windows PowerShell Compatibility (Critical)**:
   - On Windows PowerShell, always use **`npx.cmd -y wrangler ...`** (running bare `npx` triggers `npx.ps1`, which is blocked by Windows PowerShell `ExecutionPolicy` / `PSSecurityException`).
   - Do not chain commands with `&&`; run commands separately or use `;`.

---

## 🔒 Five Hard Safety & Pitfall Red Lines

1. **Never Ask For or Print Passwords, Tokens, or Keys**: This workflow uses 100% browser OAuth via `npx.cmd -y wrangler login`. **NEVER** ask the student to paste an API token or password, and never read or print `~/.wrangler/` credential files.
2. **Student Privacy & De-identification**: Database tables (such as reading logs or pragmatics branching logs) must **only store `nickname`, selected levels, clicked words, or branching paths**. Never collect real full names, national ID numbers, phone numbers, or addresses.
3. **Lowercase Alphanumeric + Hyphen Names Only**: Both `"name"` in `wrangler.jsonc` and the D1 database name **must only contain lowercase letters `a-z`, digits `0-9`, and hyphens `-`** (starting with a letter, e.g., `alice-w10-reading` or `alice-w11-pragmatics`). Uppercase letters are rejected by Wrangler.
4. **Always Pass `--remote` to Migrations**: When applying SQL migrations, always run `npx.cmd -y wrangler d1 migrations apply <db-name> --remote --yes`. Omitting `--remote` only updates a local SQLite file, causing `no such table` errors on the live site.
5. **Use Workers Static Assets (Never Use Legacy `wrangler pages`)**: Cloudflare Pages is now unified into Workers. Always configure `"assets": { "directory": "./public", "run_worker_first": ["/api/*"] }` in `wrangler.jsonc` and deploy with `npx.cmd -y wrangler deploy`.

---

## 🧭 Complete 7-Step Automated Connection & Deployment Workflow (OpenCode Edition)

This workflow is **idempotent (resumable)**: always check current state first and skip any steps that are already completed.

### Step 0: Read Root `AGENTS.md` & Ask for an English Nickname
1. First, check the current project root folder for `AGENTS.md` and read the target week/task specification (**Week 10: A2/B1/B2 Scaffolded Reading & Listening Web App** or **Week 11: L2 Pragmatics Politeness Branching Scenario Cards**).
2. If the student hasn't given a nickname yet, ask:
   > "Please give me a short **English nickname** (lowercase letters and numbers only, e.g., `alice` or `sean01`) so I can name your live Cloudflare website and D1 cloud database in OpenCode!"
   *(Automatically convert any uppercase letters to lowercase).*
3. Determine resource names:
   - **Week 10 (Reading & Listening App)**: Worker name `<nickname>-w10-reading`, D1 database `<nickname>-w10-reading-db`.
   - **Week 11 (Pragmatics Branching Cards)**: Worker name `<nickname>-w11-pragmatics`, D1 database `<nickname>-w11-pragmatics-db`.

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
   - If the output shows the user's logged-in email address AND does **not** warn `Wrangler is missing some expected Oauth scopes` (must have both `workers:write` and `d1:write`), **skip Steps 2 and 3 and jump directly to Step 4**! (For example, in Week 11, students who already logged in during Week 10 skip straight to Step 4!)
   - ⚠️ **Critical Pitfall**: If an older token is missing `workers:write`, `wrangler deploy` will fail with `No access to the specified resource`. In that case, run Step 3 (`npx.cmd -y wrangler login`) so the student clicks **Allow** once to refresh the token scopes!

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

### Step 4: Create Project Structure & D1 Cloud Database from `AGENTS.md` (Week 10 Reading/Listening or Week 11 Pragmatics Cards)

In the project folder where the student launched OpenCode, create the unified full-stack directory structure (`AGENTS.md` sits in the root folder):

```text
<project-folder>/
├── AGENTS.md                      ← [Read by OpenCode] Pedagogical & deployment rules from Cockpit Design Card
├── wrangler.jsonc                 ← Cloudflare Workers + D1 + Static Assets config
├── worker.js                      ← Backend API router (/api/* queries env.DB)
├── migrations/
│   └── 0001_init.sql              ← D1 SQLite schema & auto-seeded Week 10 or Week 11 content
└── public/                        ← Frontend static files (same-origin, zero CORS!)
    ├── index.html
    ├── style.css
    └── app.js
```

#### 1. `wrangler.jsonc` Template (Lowercase `name` Required)
```jsonc
{
  "name": "<nickname>-<w10-reading-or-w11-pragmatics>",
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
- If the database already exists (`already exists`) or wasn't written automatically, run `npx.cmd -y wrangler d1 list` to get its `uuid` and add the `d1_databases` block to `wrangler.jsonc`.

---

#### 3A. [Week 10 Example] A2/B1/B2 Scaffolded Reading & Listening Web App (`migrations/0001_init.sql` Template)
OpenCode reads the source article and rules from `AGENTS.md`, automatically adapts the passage into CEFR `A2`, `B1`, and `B2` versions, generates two-click vocabulary glosses (`glosses_json`: 1st click = context clue; 2nd click = English definition), creates comprehension questions (`questions_json`), and sets up the `reading_logs` table:

```sql
CREATE TABLE IF NOT EXISTS passages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  level TEXT NOT NULL,           -- 'A2', 'B1', or 'B2'
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  glosses_json TEXT NOT NULL,    -- JSON: [{"word":"procrastinate","clue":"Look at 'delay homework'—does it mean finish early or put off?","definition":"To delay doing something that must be done."}]
  questions_json TEXT NOT NULL   -- JSON: [{"q":"What is the main reason people procrastinate?","options":["Fear of failure","Too much sleep","Lack of paper"],"answer":0}]
);

CREATE TABLE IF NOT EXISTS reading_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT NOT NULL,
  selected_level TEXT NOT NULL,
  audio_speed TEXT DEFAULT '1.0x',
  words_clicked TEXT DEFAULT '',
  quiz_score INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```
*(OpenCode must automatically append `INSERT INTO passages ...` statements at the bottom of `0001_init.sql` to pre-populate the A2, B1, and B2 passages, glosses, and questions—the student never creates tables or types SQL manually!)*

---

#### 3B. [Week 11 Example] L2 Pragmatics Politeness Branching Scenario Cards (`migrations/0001_init.sql` Template)
OpenCode reads the pragmatics scenario specification from `AGENTS.md`, automatically creates the 3-turn branching scenario table `scenario_nodes` (including pragmatic clues and repair branches for overly blunt/vague choices), and sets up the `pragmatics_logs` table to record peer testers' decision paths:

```sql
CREATE TABLE IF NOT EXISTS scenario_nodes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  step_no INTEGER NOT NULL,          -- 1, 2, or 3
  speaker_line TEXT NOT NULL,        -- Interlocutor prompt (e.g., professor, supervisor, classmate)
  options_json TEXT NOT NULL         -- JSON: [{"label":"A","text":"I need an extension.","politeness":"Too Blunt","clue":"Using 'I need' sounds demanding to a professor. Try a modal verb + reason.","is_best":false}, ...]
);

CREATE TABLE IF NOT EXISTS pragmatics_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT NOT NULL,
  scenario_topic TEXT NOT NULL,
  choice_path TEXT NOT NULL,         -- e.g., 'Step1:A(Repair)->Step1:C->Step2:B->Step3:A'
  repairs_triggered INTEGER NOT NULL DEFAULT 0,
  final_reflection TEXT DEFAULT '',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```
*(OpenCode automatically appends `INSERT INTO scenario_nodes ...` at the bottom of `0001_init.sql` to pre-seed all 3 scenario turns!)*

---

#### 4. `worker.js` Template (Same-Origin `/api/data` + `POST /api/log` + Static Assets)
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

    // Load content (Week 10 passages OR Week 11 pragmatics nodes) + latest 25 peer-test logs
    if (url.pathname === "/api/data" && request.method === "GET") {
      try {
        const tables = await env.DB.prepare("SELECT name FROM sqlite_master WHERE type='table'").all();
        const tableNames = tables.results.map(r => r.name);

        if (tableNames.includes("passages")) {
          const { results: passages } = await env.DB.prepare("SELECT * FROM passages ORDER BY id ASC").all();
          const { results: logs } = await env.DB.prepare("SELECT * FROM reading_logs ORDER BY id DESC LIMIT 25").all();
          return json({ ok: true, mode: "week10_reading", passages, logs });
        } else {
          const { results: nodes } = await env.DB.prepare("SELECT * FROM scenario_nodes ORDER BY step_no ASC").all();
          const { results: logs } = await env.DB.prepare("SELECT * FROM pragmatics_logs ORDER BY id DESC LIMIT 25").all();
          return json({ ok: true, mode: "week11_pragmatics", nodes, logs });
        }
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    // Save peer-tester interaction logs to Cloudflare D1
    if (url.pathname === "/api/log" && request.method === "POST") {
      try {
        const body = await request.json();
        if (body.mode === "week10_reading") {
          await env.DB.prepare(
            "INSERT INTO reading_logs (nickname, selected_level, audio_speed, words_clicked, quiz_score) VALUES (?, ?, ?, ?, ?)"
          ).bind(
            String(body.nickname || "Anonymous").trim(),
            String(body.selectedLevel || "B1").trim(),
            String(body.audioSpeed || "1.0x").trim(),
            String(body.wordsClicked || "").trim(),
            Number(body.quizScore || 0)
          ).run();
        } else {
          await env.DB.prepare(
            "INSERT INTO pragmatics_logs (nickname, scenario_topic, choice_path, repairs_triggered, final_reflection) VALUES (?, ?, ?, ?, ?)"
          ).bind(
            String(body.nickname || "Anonymous").trim(),
            String(body.scenarioTopic || "Pragmatics Task").trim(),
            String(body.choicePath || "").trim(),
            Number(body.repairsTriggered || 0),
            String(body.finalReflection || "").trim()
          ).run();
        }
        return json({ ok: true });
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    return env.ASSETS.fetch(request);
  }
};
```
> 💡 **Pedagogical UI Requirement**: Always include a collapsible **"📊 Cloud D1 Peer-Test Logs"** section at the bottom of `public/index.html` (rendering the `logs` array returned by `/api/data`). This lets student designers and peer testers immediately see logged reading levels, clicked gloss words, or pragmatics branching paths right on the webpage without needing to open the Cloudflare console!

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
   🎉 **OpenCode × Cloudflare Full-Stack Web App + D1 Database Deployed!**
   - 🌐 **Live Public Website**: https://<worker-name>.<subdomain>.workers.dev
   - 🗄️ **Cloud D1 Database**: `<db-name>` (Tables initialized, content seeded & live log viewer active ✅)
   - 📄 **Pedagogical Rules**: Built from root `AGENTS.md` specification
   - 🔒 **Security & Compatibility**: Zero API keys exposed, same-origin API (no CORS issues, ready for Peer Testing on desktop or mobile!)
   ```

---

## 🛠️ Quick Troubleshooting Table

| Symptom / Error | Root Cause | Solution |
| :--- | :--- | :--- |
| Windows error: `cannot be loaded because running scripts is disabled` (`npx.ps1`) | PowerShell blocks `.ps1` scripts by default | Always use `npx.cmd -y wrangler ...` instead of `npx`. |
| Deploy fails asking to verify email | Cloudflare signup email not verified yet | Ask the student to check their email inbox/spam and click the Cloudflare verification link. |
| Deploy asks to register a `workers.dev` subdomain | Brand-new Cloudflare account | Have the student open Cloudflare Dashboard ➔ `Workers & Pages` to pick a subdomain name once. |
| `https://` shows SSL error (`ERR_SSL_VERSION_OR_CIPHER_MISMATCH`) right after first deploy | Cloudflare takes 2–3 minutes to issue the wildcard SSL certificate for a brand-new `*.<subdomain>.workers.dev` | Provide `http://<worker>.<subdomain>.workers.dev` for instant testing; `https://` will work automatically after 2–3 minutes. |
| API returns `no such table` | Forgot Step 5 or omitted `--remote` | Run `npx.cmd -y wrangler d1 migrations apply <db-name> --remote --yes`. |
| API returns `DB binding not found` | Missing `d1_databases` in `wrangler.jsonc` | Run `npx.cmd -y wrangler d1 list`, add the `d1_databases` block to `wrangler.jsonc`, and re-run `npx.cmd -y wrangler deploy`. |
