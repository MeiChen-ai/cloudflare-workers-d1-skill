---
name: cloudflare-workers-d1
description: Cloudflare Workers（前端網站＋後端 API）＋ Cloudflare D1（SQLite 雲端資料庫）免金鑰、免 MCP 零複製全自動閉環部署指南。當使用者提到「連接 Cloudflare」「設定 Cloudflare」「用 Cloudflare 部署」「Cloudflare D1」「Wrangler 登入」「用 Cloudflare 做網頁遊戲或資料庫」「照 AGENTS.md 連接 Cloudflare」時自動啟用。
---

# Cloudflare Workers + D1 零金鑰全自動閉環系統（教學與自動化實作指南）

> 來源改編：[agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)  
> 核心精神：**「免裝 MCP、免複製任何 API Key 或 Token！前端網站（Workers Static Assets）＋ 後端 API（Worker）＋ 雲端資料庫（D1 SQLite）同源合一，學生只需在瀏覽器按一次 Allow。」**

---

## 🎯 你的角色與分工原則（必守）

你面對的使用者是**學生或老師（預設無工程背景）**，全程使用**清楚、友善的繁體中文**引導：

| 學生/使用者只負責（3 件事） | Agent 全自動包辦 |
| :--- | :--- |
| ① 沒帳號時註冊 Cloudflare（輸入 Email＋密碼並去信箱點驗證信）<br>② 瀏覽器跳出 Wrangler 授權頁時按 **Allow**<br>③ 首次部署若提示設定 `workers.dev` 子網域時，在後台取一個英文名稱 | 環境檢查、安裝 Node.js、執行 `npx.cmd -y wrangler` 所有指令、建立專案結構、建立 D1 資料庫、撰寫並執行 SQL migrations、部署網站、端到端 API 驗收、輸出完成卡 |

1. **禁止叫學生自己開終端機打指令或改設定檔**：所有 CLI 指令與檔案修改一律由你執行。
2. **一次只請學生做一件事**：需要學生點擊授權、收驗證信或設子網域時，**停下來用一句話講清楚要點哪裡，等學生回覆「好了」再繼續**。
3. **Windows PowerShell 相容性（極重要）**：
   - 在 Windows PowerShell 中，請一律使用 **`npx.cmd -y wrangler ...`**（避免直接打 `npx` 觸發 `npx.ps1` 執行原則阻擋 `PSSecurityException`）。
   - 不要用 `&&` 串接指令，請分步執行或改用 `;`。

---

## 🔒 五條安全與避坑紅線

1. **絕不索取或印出任何密碼與金鑰**：本流程 100% 透過 `npx.cmd -y wrangler login` 瀏覽器 OAuth 完成，**嚴禁**要求學生貼上 API Token、密碼，也不可讀取 `~/.wrangler/` 憑證檔內容。
2. **學生隱私去識別化**：D1 資料庫的資料表（如排行榜、測驗紀錄）**只記錄「班級代號 (`class_code`)、座號 (`seat_no`)、分數 (`score`)」**，嚴禁收集真實姓名、身分證字號、電話或住址。
3. **名稱必須全小寫英數連字號**：`wrangler.jsonc` 的 `"name"` 與 D1 資料庫名稱**只能使用小寫英文 `a-z`、數字 `0-9` 與連字號 `-`**（且開頭必為英文字母，例如 `wang-vocab-game`）。若含大寫字母，Wrangler 會直接報錯拒絕。
4. **Migrations 必加 `--remote`**：套用資料庫結構時，必須執行 `npx.cmd -y wrangler d1 migrations apply <資料庫名> --remote`。若漏掉 `--remote` 只會改到本機暫存檔，線上網站會報 `no such table` 錯誤。
5. **使用 Workers Static Assets（勿用舊版 `wrangler pages`）**：Cloudflare Pages 已併入 Workers，一律透過 `wrangler.jsonc` 的 `"assets": { "directory": "./public", "run_worker_first": ["/api/*"] }` 搭配 `npx.cmd -y wrangler deploy` 部署。

---

## 🧭 完整 7 步自動化連接與部署流程

本流程具備**可續跑性（Idempotent）**：每一步開始前先檢查狀態，已完成的步驟自動跳過。

### 第 0 步：詢問英文暱稱與確認目標
1. 若學生尚未提供英文暱稱，先問一句：
   > 「請告訴我一個簡單的**英文暱稱**（例如 `wang` 或 `chen01`，只用小寫英文與數字），我會用它幫你建立專屬網站與雲端資料庫！」
   *(若學生給大寫，自動幫他轉小寫)*。
2. 決定命名：
   - 若學生只是要「測試連接 Cloudflare」：網站名為 `<暱稱>-hello`，資料庫名為 `<暱稱>-hello-db`。
   - 若學生指定要做特定作品（如單字遊戲）：網站名為 `<暱稱>-<專案簡稱>`（如 `wang-vocab-maze`），資料庫名為 `<暱稱>-<專案簡稱>-db`。

---

### 第 1 步：本機環境與 Wrangler 登入檢查
1. 執行 `node -v` 與 `npx.cmd -v`：
   - 若未安裝 Node.js：在 Windows 執行 `winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements`（先提醒學生在跳出的視窗按「是」），並刷新當前 PowerShell PATH：
     ```powershell
     $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
     ```
2. 檢查是否已登入 Cloudflare 且權限完整：
   ```powershell
   npx.cmd -y wrangler whoami
   ```
   - 若輸出中已顯示使用者的 Email，且**沒有**出現 `WARNING: Wrangler is missing some expected Oauth scopes`（特別是需確認具備 `workers:write` 與 `d1:write`），**直接跳過第 2、3 步，進入第 4 步**！
   - ⚠️ **避坑關鍵**：若舊憑證只有 `d1 (write)` 而缺少 `workers:write`，後續 `wrangler deploy` 會報 `No access to the specified resource`。此時仍須執行第 3 步 `npx.cmd -y wrangler login` 請使用者按一次 Allow 更新憑證！

---

### 第 2 步：確認 Cloudflare 帳號（未登入時才做）
詢問學生：「請問你已經有註冊過 Cloudflare 帳號（並點過信箱驗證信）了嗎？」
- **若還沒有**：請學生打開 [https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up) 輸入 Email 與密碼註冊，並**務必去信箱點擊驗證信**（沒點驗證信後續無法部署），完成後回覆「好了」。

---

### 第 3 步：🔑【學生關鍵動作】Wrangler 瀏覽器一鍵授權
1. 在背景啟動登入指令（逾時設長或放入背景任務）：
   ```powershell
   npx.cmd -y wrangler login
   ```
2. 從終端機輸出抓取 `https://dash.cloudflare.com/oauth2/auth?...` 授權連結，完整呈現給學生並說明：
   > 「請點開下方連結（或看剛剛自動彈出的瀏覽器視窗），登入你的 Cloudflare 帳號後，按下 **『Allow（允許）』** 即可！」
3. 授權完成後，執行 `npx.cmd -y wrangler whoami` 確認顯示帳號 Email。
   - *避坑*：若學生按了 Allow 但終端機一直沒收到 `localhost:8976` 回呼，多半是學校網路或防毒擋住，請學生改連手機熱點或將網址貼到系統預設瀏覽器再按一次 Allow。

---

### 第 4 步：建立標準專案結構與 D1 資料庫

在專案資料夾（例如 `C:\Users\hp\.gemini\antigravity\scratch\<專案名>`）建立以下同源全端結構：

```text
<專案資料夾>/
├── wrangler.jsonc                 ← Cloudflare Workers + D1 + 靜態資源設定
├── worker.js                      ← 後端 API 路由（/api/* 讀寫 env.DB）
├── migrations/
│   └── 0001_init.sql              ← D1 SQLite 資料表結構與初始題庫資料
└── public/                        ← 前端靜態網頁（同源免 CORS！）
    ├── index.html
    ├── style.css
    └── app.js
```

#### 1. `wrangler.jsonc` 標準範本（注意 `name` 必為全小寫）
```jsonc
{
  "name": "<小寫暱稱>-<專案名>",
  "main": "worker.js",
  "compatibility_date": "2026-10-01",
  "assets": {
    "directory": "./public",
    "run_worker_first": ["/api/*"]
  }
}
```

#### 2. 建立 D1 雲端資料庫並自動綁定至 `wrangler.jsonc`
在專案資料夾內執行：
```powershell
npx.cmd -y wrangler d1 create <小寫暱稱>-<專案名>-db --binding DB --update-config
```
- 成功後，`wrangler.jsonc` 會自動寫入 `"d1_databases": [{ "binding": "DB", "database_name": "...", "database_id": "..." }]`。
- 若提示未自動寫入設定檔，執行 `npx.cmd -y wrangler d1 list` 查出 `uuid`，手動將 `d1_databases` 區塊補進 `wrangler.jsonc`。
- 若提示資料庫已存在（`already exists`），直接透過 `d1 list` 查出該 `uuid` 填入 `wrangler.jsonc` 沿用即可。

#### 3. `migrations/0001_init.sql` 標準範本（以單字練習＋排行榜為例）
```sql
CREATE TABLE IF NOT EXISTS vocab (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  word TEXT NOT NULL,
  meaning TEXT NOT NULL,
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
*(可在 SQL 檔尾直接用 `INSERT INTO vocab (word, meaning, example, level) VALUES ...` 預先塞入 12 筆 CEFR B1/B2 單字題庫！)*

#### 4. `worker.js` 標準範本（同源 `/api/*` + 靜態網頁）
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
          "INSERT INTO vocab (word, meaning, example, level) VALUES (?, ?, ?, ?)"
        ).bind(
          String(body.word || "").trim(),
          String(body.meaning || "").trim(),
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

### 第 5 步：套用雲端資料表結構（Migrations Apply）
在專案資料夾內執行（**務必加上 `--remote` 與 `--yes`**）：
```powershell
npx.cmd -y wrangler d1 migrations apply <資料庫名> --remote --yes
```

---

### 第 6 步：一鍵部署至 Cloudflare Workers
在專案資料夾內執行：
```powershell
npx.cmd -y wrangler deploy
```
- 從終端機輸出讀取正式網址：`https://<網站名>.<帳號子網域>.workers.dev`。
- ⚠️ **新帳號首次部署避坑**：若輸出提示需要設定 `workers.dev` subdomain（子網域），請停下來引導學生：
  > 「這是你的 Cloudflare 新帳號第一次發佈網站！請打開 [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ 點左側選單 **『Workers & Pages』（或 Compute › Workers & Pages）** ➔ 在畫面上輸入一個你喜歡的英文子網域並儲存。設好後跟我說『好了』，我馬上幫你完成發佈！」

---

### 第 7 步：端到端自動驗收與輸出「🎉 連接完成卡」
1. 部署成功後，Agent 先自行呼叫一次 API（例如讀取 `/api/data` 或發送測試請求至 `/api/check` / `/api/score`），確認回傳 `{"ok":true,...}`，代表前端、Worker 與 D1 資料庫 100% 連通！
2. 向學生輸出完成卡：
   ```markdown
   🎉 **Cloudflare 全端網站＋D1 資料庫部署完成卡**
   - 🌐 **你的公開網站網址**：https://<網站名>.<子網域>.workers.dev
   - 🗄️ **雲端 D1 資料庫**：`<資料庫名>`（已建立資料表並完成讀寫驗證 ✅）
   - 🔒 **安全狀態**：零金鑰外洩、前後端同源免無痕視窗，任何瀏覽器與手機點開都能直接玩！
   ```

---

## 🛠️ 常見問題快速排除表

| 症狀 / 錯誤訊息 | 原因 | 解法 |
| :--- | :--- | :--- |
| Windows 報 `無法載入 npx.ps1` (`PSSecurityException`) | PowerShell 預設阻擋 `.ps1` 腳本 | 改用 `npx.cmd -y wrangler ...` 即可 100% 繞過。 |
| 部署提示需驗證 Email | 註冊 Cloudflare 後尚未點信箱驗證信 | 請學生檢查收件匣與垃圾郵件，點擊驗證連結後重跑 `deploy`。 |
| 部署提示需設定 `workers.dev` 子網域 | 新 Cloudflare 帳號首次使用 Workers | 請學生到 Cloudflare 後台左側 `Workers & Pages` 設定子網域名稱（新版 Wrangler 亦會自動註冊）。 |
| 新帳號首次部署後點開 `https://` 顯示 SSL 錯誤 (`ERR_SSL_VERSION_OR_CIPHER_MISMATCH`) | 新註冊的 `*.<子網域>.workers.dev` 萬用字元 SSL 憑證需要 2～3 分鐘簽發 | 先給學生 `http://<網站名>.<子網域>.workers.dev`（可立即秒開測試），過 2～3 分鐘憑證簽發完畢後 `https://` 即可正常開啟。 |
| 網頁 API 報 `no such table` | 第 5 步忘記跑 migrations 或漏加 `--remote` | 補跑 `npx.cmd -y wrangler d1 migrations apply <資料庫名> --remote --yes`（不必重新 deploy）。 |
| 網頁 API 報 `找不到資料庫綁定 DB` | `wrangler.jsonc` 缺少 `d1_databases` 區段 | 執行 `npx.cmd -y wrangler d1 list` 取得 UUID，補進 `wrangler.jsonc` 後重新 `wrangler deploy`。 |
