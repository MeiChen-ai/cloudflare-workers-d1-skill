---
name: cloudflare-workers-d1
description: OpenCode 專用：Cloudflare Workers（前端網站＋後端 API）＋ Cloudflare D1（SQLite 雲端資料庫）免金鑰、免 MCP 零複製全自動閉環部署指南。支援「專案根目錄 AGENTS.md（教學規則）＋學生貼上的 Prompt（教材內容）」雙層指令，內建第 10 週「A2/B1/B2 分級閱讀與聽力鷹架網」與第 11 週「我自己設計的英文 App」（5 種 App 類型）標準範本。當使用者在 OpenCode 提到「連接 Cloudflare」「設定 Cloudflare」「用 Cloudflare 部署」「Cloudflare D1」「Wrangler 登入」「照 AGENTS.md 部署到 Cloudflare」時自動啟用。
---

# OpenCode × Cloudflare Workers + D1 零金鑰全自動閉環系統（教學與自動化實作指南）

> 來源改編：[agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)  
> 適用環境：**OpenCode**（自動讀取專案根目錄 `AGENTS.md` 的規則，再依學生貼上的 Prompt 取得內容；亦相容各類 AI Coding Agent）  
> 核心精神：**「免裝 MCP、免複製任何 API Key 或 Token！OpenCode 先讀資料夾最外層的 `AGENTS.md`（規則），再依學生貼上的 Prompt（內容），將前端網站（Workers Static Assets）＋ 後端 API（Worker）＋ 雲端資料庫（D1 SQLite）同源合一部署，學生只需在瀏覽器按一次 Allow。」**

---

## 🎯 你（OpenCode Agent）的角色與分工原則（必守）

你面對的使用者是**英文系學生或老師（預設無工程背景）**，在 **OpenCode** 中透過兩層指令與你互動：專案根目錄的 `AGENTS.md`（每次都要遵守的教學規則）＋貼進對話框的 Prompt（這次的教材內容），請全程使用**清楚、友善的繁體中文**引導：

| 學生/使用者只負責（3 件事） | OpenCode Agent 全自動包辦 |
| :--- | :--- |
| ① 沒帳號時註冊 Cloudflare（輸入 Email＋密碼並去信箱點驗證信）<br>② 瀏覽器跳出 Wrangler 授權頁時按 **Allow**<br>③ 首次部署若提示設定 `workers.dev` 子網域時，在後台取一個英文名稱 | 自動讀取根目錄 `AGENTS.md` 規則與學生 Prompt 內容、環境檢查、安裝 Node.js、執行 `npx.cmd -y wrangler` 所有指令、建立專案結構、自動建立 D1 資料庫與資料表、撰寫並套用 SQL migrations（含預塞教材題庫）、部署網站、端到端 API 驗收、輸出完成卡 |

1. **禁止叫學生自己開終端機打指令或手動建資料庫／資料表**：所有 CLI 指令、SQL 建表、預塞題庫與檔案修改一律由 OpenCode 自動執行。
2. **一次只請學生做一件事**：需要學生點擊授權、收驗證信或設子網域時，**停下來用一句話講清楚要點哪裡，等學生回覆「好了」再繼續**。
3. **Windows PowerShell 相容性（極重要）**：
   - 在 Windows PowerShell 中，請一律使用 **`npx.cmd -y wrangler ...`**（避免直接打 `npx` 觸發 `npx.ps1` 執行原則阻擋 `PSSecurityException`）。
   - 不要用 `&&` 串接指令，請分步執行或改用 `;`。

---

## 🔒 五條安全與避坑紅線

1. **絕不索取或印出任何密碼與金鑰**：本流程 100% 透過 `npx.cmd -y wrangler login` 瀏覽器 OAuth 完成，**嚴禁**要求學生貼上 API Token、密碼，也不可讀取 `~/.wrangler/` 憑證檔內容。
2. **學生隱私去識別化**：D1 資料庫的學習紀錄表**只記錄「測試者暱稱 (`nickname`)、班級/組別代號 (`class_code`)、互動歷程與得分」**，嚴禁收集真實全名、身分證字號、電話或住址。
3. **名稱必須全小寫英數連字號**：`wrangler.jsonc` 的 `"name"` 與 D1 資料庫名稱**只能使用小寫英文 `a-z`、數字 `0-9` 與連字號 `-`**（且開頭必為英文字母，例如 `alice-w10-reading` 或 `alice-w11-app`）。若含大寫字母，Wrangler 會直接報錯拒絕。
4. **Migrations 必加 `--remote`**：套用資料庫結構時，必須執行 `npx.cmd -y wrangler d1 migrations apply <資料庫名> --remote --yes`。若漏掉 `--remote` 只會改到本機暫存檔，線上網站會報 `no such table` 錯誤。
5. **使用 Workers Static Assets（勿用舊版 `wrangler pages`）**：Cloudflare Pages 已併入 Workers，一律透過 `wrangler.jsonc` 的 `"assets": { "directory": "./public", "run_worker_first": ["/api/*"] }` 搭配 `npx.cmd -y wrangler deploy` 部署。

---

## 🧭 完整 7 步自動化連接與部署流程（OpenCode 專用）

本流程具備**可續跑性（Idempotent）**：每一步開始前先檢查狀態，已完成的步驟自動跳過。

### 第 0 步：讀取 `AGENTS.md`（規則）＋學生 Prompt（內容）與確認英文暱稱
1. 先檢查當前專案資料夾最外層（根目錄）是否有 `AGENTS.md`，若有則讀取其中的**教學規則**（課程週次、分級／提示規則或 App 類型與回饋規則、資料表與部署要求）。
   - **教材內容來自學生貼上的 Prompt**：第 10 週為暱稱、文章、5 個關鍵字、2 題理解題；第 11 週為暱稱、學習者與問題、App 點子、練習題。
   - **兩層分工**：`AGENTS.md` 管「怎麼教」，Prompt 管「教什麼」。若 Prompt 與 `AGENTS.md` 的規則衝突，**以 `AGENTS.md` 為準**，並用一句話告訴學生哪裡不一致。
   - 若只有 Prompt、沒有 `AGENTS.md`：提醒學生先從 Cockpit 設計卡下載 `AGENTS.md` 放進資料夾最外層；學生堅持不放時，才改用 Prompt 內容與本技能的預設規則繼續。
   - 若只有 `AGENTS.md`、還沒有內容：請學生貼上設計卡產生的 Prompt，不要自行編造文章或練習題。
2. 若 Prompt 裡沒有英文暱稱，先問一句：
   > 「請告訴我你的**英文小寫暱稱**（例如 `alice` 或 `sean01`，只用小寫英文與數字），我會用它在 OpenCode 幫你建立專屬的 Cloudflare 網站與 D1 雲端資料庫！」
   *(若學生給大寫，自動幫他轉小寫)*。
3. 決定命名：
   - **第 10 週（分級閱讀與聽力鷹架網）**：網站名為 `<暱稱>-w10-reading`，資料庫名為 `<暱稱>-w10-reading-db`。
   - **第 11 週（我自己設計的英文 App）**：網站名為 `<暱稱>-w11-app`，資料庫名為 `<暱稱>-w11-app-db`。

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
   - 若輸出中已顯示使用者的 Email，且**沒有**出現 `WARNING: Wrangler is missing some expected Oauth scopes`（需確認具備 `workers:write` 與 `d1:write`），**直接跳過第 2、3 步，進入第 4 步**！（例如第 10 週已登入過，第 11 週即可 0 秒直接跳第 4 步！）
   - ⚠️ **避坑關鍵**：若舊憑證缺少 `workers:write`，後續 `wrangler deploy` 會報 `No access to the specified resource`。此時仍須執行第 3 步 `npx.cmd -y wrangler login` 請使用者按一次 Allow 更新憑證！

---

### 第 2 步：確認 Cloudflare 帳號（未登入時才做）
詢問學生：「請問你已經有註冊過 Cloudflare 帳號（並點過信箱驗證信）了嗎？」
- **若還沒有**：請學生打開 [https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up) 輸入 Email 與密碼註冊，並**務必去信箱點擊驗證信**（沒點驗證信後續無法部署），完成後回覆「好了」。

---

### 第 3 步：🔑【學生關鍵動作】Wrangler 瀏覽器一鍵授權
1. 執行登入指令：
   ```powershell
   npx.cmd -y wrangler login
   ```
2. 從終端機輸出抓取 `https://dash.cloudflare.com/oauth2/auth?...` 授權連結，完整呈現給學生並說明：
   > 「請點開下方連結（或看剛剛自動彈出的瀏覽器視窗），登入你的 Cloudflare 帳號後，按下 **『Allow（允許）』** 即可！」
3. 授權完成後，執行 `npx.cmd -y wrangler whoami` 確認顯示帳號 Email。
   - *避坑*：若學生按了 Allow 但終端機一直沒收到 `localhost:8976` 回呼，多半是學校網路或防毒擋住，請學生改連手機熱點或將網址貼到系統預設瀏覽器再按一次 Allow。

---

### 第 4 步：依 `AGENTS.md` 規則與 Prompt 內容建立專案結構與 D1 資料庫（Week 10 閱讀聽力 ／ Week 11 自訂英文 App）

在學生啟動 OpenCode 的專案資料夾內，建立以下同源全端結構（`AGENTS.md` 位於專案最外層根目錄）：

```text
<專案資料夾>/
├── AGENTS.md                      ← 【OpenCode 自動讀取】Cockpit 設計卡 Part A 產生的教學與部署規則（內容在學生的 Prompt）
├── wrangler.jsonc                 ← Cloudflare Workers + D1 + 靜態資源設定
├── worker.js                      ← 後端 API 路由（/api/* 讀寫 env.DB，並提供 /Logs 檢視或 JSON 讀取）
├── migrations/
│   └── 0001_init.sql              ← D1 SQLite 資料表結構與自動預塞的教材內容
└── public/                        ← 前端靜態網頁（同源免 CORS！）
    ├── index.html
    ├── style.css
    └── app.js
```

#### 1. `wrangler.jsonc` 標準範本（注意 `name` 必為全小寫）
```jsonc
{
  "name": "<小寫暱稱>-<w10-reading或w11-app>",
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
- 若提示未自動寫入或資料庫已存在（`already exists`），執行 `npx.cmd -y wrangler d1 list` 查出 `uuid`，補進 `wrangler.jsonc`。

---

#### 3A. 【第 10 週範例】A2/B1/B2 分級閱讀與聽力鷹架網（`migrations/0001_init.sql` 範本）
OpenCode 依 `AGENTS.md` 的分級與提示規則，處理學生 Prompt 裡的短文、5 個關鍵字與 2 題理解題，自動產生 A2、B1、B2 三種難度課文、兩段式單字註解（`glosses_json`：點第 1 下給語境線索 `clue`、點第 2 下才給定義 `definition`）與讀後測驗題（`questions_json`），並建立 `reading_logs` 作答紀錄表：

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
*(OpenCode 必須在 `0001_init.sql` 檔尾直接用 `INSERT INTO passages ...` 把改寫好的 A2、B1、B2 三筆課文與單字提示自動塞入資料庫，學生完全免手動輸入資料庫！)*

---

#### 3B. 【第 11 週範例】我自己設計的英文 App（`migrations/0001_init.sql` 範本）
學生在 Cockpit 設計卡自選 1 種 App 類型：**Branching conversation**（3 關對話，選 1 個回應）、**Put it in order**（把打亂的字排回句子）、**Listen and type**（聽句子打字）、**Sort into groups**（把字卡分組）或 **Flip and recall**（翻卡回想並自評）。OpenCode 依 `AGENTS.md` 的 App 類型、回饋規則與資料表要求，把學生 Prompt 裡的練習題（一行一題，格式依 App 類型而定）預塞進 `items`，並建立記錄每次練習的 `practice_logs` 表：

```sql
CREATE TABLE IF NOT EXISTS items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  position INTEGER NOT NULL,         -- 題目順序 1, 2, 3...
  content_json TEXT NOT NULL         -- 依 App 類型而定，例如 Branching conversation：{"line":"Professor: Hi, what can I do for you?","best":"Could I possibly have three more days?","weaker":["I need three more days.","Um, something happened."]}
);

CREATE TABLE IF NOT EXISTS practice_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT NOT NULL,
  app_type TEXT NOT NULL,            -- 例如 'Put it in order'
  score INTEGER NOT NULL DEFAULT 0,
  hints_used INTEGER NOT NULL DEFAULT 0,
  details TEXT DEFAULT '',           -- 依 AGENTS.md 的規定，例如選擇路徑 'T1:weak->T1:best->T2:best->T3:best' 或重播次數
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```
*(同樣由 OpenCode 在 `0001_init.sql` 檔尾直接 `INSERT INTO items ...` 預塞學生 Prompt 裡的全部練習題！)*

---

#### 4. `worker.js` 標準範本（支援同源 `/api/data` 讀取題庫與紀錄、`POST /api/log` 寫入同儕測試紀錄）
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

    // 讀取題庫（課文或練習題）與最新 25 筆同儕測試紀錄（供網頁下方「📊 Teacher / Designer Cloud Log Drawer」即時檢視）
    if (url.pathname === "/api/data" && request.method === "GET") {
      try {
        // 依專案表名自動查詢（Week 10 為 passages + reading_logs；Week 11 為 items + practice_logs）
        const tables = await env.DB.prepare("SELECT name FROM sqlite_master WHERE type='table'").all();
        const tableNames = tables.results.map(r => r.name);

        if (tableNames.includes("passages")) {
          const { results: passages } = await env.DB.prepare("SELECT * FROM passages ORDER BY id ASC").all();
          const { results: logs } = await env.DB.prepare("SELECT * FROM reading_logs ORDER BY id DESC LIMIT 25").all();
          return json({ ok: true, mode: "week10_reading", passages, logs });
        } else {
          const { results: items } = await env.DB.prepare("SELECT * FROM items ORDER BY position ASC").all();
          const { results: logs } = await env.DB.prepare("SELECT * FROM practice_logs ORDER BY id DESC LIMIT 25").all();
          return json({ ok: true, mode: "week11_app", items, logs });
        }
      } catch (err) {
        return json({ ok: false, error: String(err.message || err) }, 500);
      }
    }

    // 寫入同儕測試學習紀錄
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
            "INSERT INTO practice_logs (nickname, app_type, score, hints_used, details) VALUES (?, ?, ?, ?, ?)"
          ).bind(
            String(body.nickname || "Anonymous").trim(),
            String(body.appType || "").trim(),
            Number(body.score || 0),
            Number(body.hintsUsed || 0),
            String(body.details || "").trim()
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
> 💡 **教學貼心設計**：前端 `public/index.html` 最下方請務必內建一個可展開的 **「📊 Cloud D1 Learner Logs（雲端測試紀錄即時看板）」** 區塊（直接顯示 `/api/data` 回傳的 `logs` 表格），讓學生與同儕互測完，不用進 Cloudflare 後台就能直接在網頁上看到誰選了哪個等級、點了哪些單字、或在自訂 App 拿了幾分、用了幾次提示！

---

### 第 5 步：套用雲端資料表結構與初始題庫（Migrations Apply）
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

### 第 7 步：端到端自動驗收與輸出「🎉 OpenCode × Cloudflare 連接完成卡」
1. 部署成功後，OpenCode 先自行呼叫一次 API（例如讀取 `/api/data`），確認回傳 `{"ok":true,...}`，代表前端、Worker 與 D1 資料庫 100% 連通！
2. 向學生輸出完成卡：
   ```markdown
   🎉 **OpenCode × Cloudflare 全端教學網站＋D1 資料庫部署完成卡**
   - 🌐 **你的公開網站網址**：https://<網站名>.<子網域>.workers.dev
   - 🗄️ **雲端 D1 資料庫**：`<資料庫名>`（已自動建表、寫入教材並開啟網頁下方即時紀錄看板 ✅）
   - 📄 **規則與內容**：已套用專案根目錄 `AGENTS.md` 的教學規則，以及你 Prompt 裡的教材內容
   - 🔒 **安全狀態**：零金鑰外洩、前後端同源免 CORS，同學直接點開網址就能進行 Peer Testing！
   ```

---

## 🛠️ 常見問題快速排除表

| 症狀 / 錯誤訊息 | 原因 | 解法 |
| :--- | :--- | :--- |
| Windows 報 `無法載入 npx.ps1` (`PSSecurityException`) | PowerShell 預設阻擋 `.ps1` 腳本 | 改用 `npx.cmd -y wrangler ...` 即可 100% 繞過。 |
| 部署提示需驗證 Email | 註冊 Cloudflare 後尚未點信箱驗證信 | 請學生檢查收件匣與垃圾郵件，點擊驗證連結後重跑 `deploy`。 |
| 部署提示需設定 `workers.dev` 子網域 | 新 Cloudflare 帳號首次使用 Workers | 請學生到 Cloudflare 後台左側 `Workers & Pages` 設定子網域名稱。 |
| 新帳號首次部署後點開 `https://` 顯示 SSL 錯誤 (`ERR_SSL_VERSION_OR_CIPHER_MISMATCH`) | 新註冊的 `*.<子網域>.workers.dev` 萬用字元 SSL 憑證需要 2～3 分鐘簽發 | 先給學生 `http://<網站名>.<子網域>.workers.dev`（可立即秒開測試），過 2～3 分鐘憑證簽發完畢後 `https://` 即可正常開啟。 |
| 網頁 API 報 `no such table` | 第 5 步忘記跑 migrations 或漏加 `--remote` | 補跑 `npx.cmd -y wrangler d1 migrations apply <資料庫名> --remote --yes`（不必重新 deploy）。 |
| 網頁 API 報 `找不到資料庫綁定 DB` | `wrangler.jsonc` 缺少 `d1_databases` 區段 | 執行 `npx.cmd -y wrangler d1 list` 取得 UUID，補進 `wrangler.jsonc` 後重新 `wrangler deploy`。 |
