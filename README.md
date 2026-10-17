# ⚡ AntiGravity 零金鑰全端網站＋Cloudflare D1 雲端資料庫實作講義
# ⚡ AntiGravity Zero-Key Web App + Cloudflare D1 Database Classroom Handout

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這套方法有什麼超強優點？
透過 **`/cloudflare-workers-d1`** 技能，你的 AI Agent 會幫你把「**前端互動網頁＋後端 API＋D1 雲端資料庫**」一次部署在同一個 **Cloudflare** 帳號裡：
* **完全免裝 MCP、免複製任何 API Key 或 Token**：你不需要貼任何密碼或權杖給 AI！
* **前後端同源（零跨域問題）**：不用開無痕視窗，不管是學校電腦、手機、平板或任何瀏覽器點開都能直接連線！
* **你的任務**：寫程式與打指令全部交給 AntiGravity AI，你只需要做 **「1 句安裝指令 ＋ 1 句許願提示詞 ＋ 在瀏覽器按一次 Allow」**！

---

### 二、 Step 1：把技能安裝進你的 AntiGravity（只需做一次）

打開 **AntiGravity**，直接複製以下**整段話**貼進對話框送出（AI 會自動幫你建立資料夾並下載技能，完全不用自己去檔案總管找路徑）：

#### 💬 複製貼給 AntiGravity 的安裝指令（中文版）：
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1/SKILL.md 下載技能檔，並儲存到我的 ~/.gemini/config/skills/cloudflare-workers-d1/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，請開一個新的對話視窗，輸入 `/` 就能看到 `/cloudflare-workers-d1` 技能！建議同時將右上角模型切換為 **Gemini Flash**，速度最快且最省免費版額度。)*

---

### 三、 Step 2：課前 2 分鐘準備（註冊 Cloudflare 帳號）

1. 如果你還沒有 Cloudflare 帳號，請打開 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. 輸入你的 Email 與自訂密碼完成註冊。
3. **🔑【必做】去信箱收信並點擊 Cloudflare 驗證信**（如果沒看到請檢查垃圾郵件匣；未驗證信箱將無法發佈網站）。

---

### 四、 Step 3：填空式「一桿進洞」許願 Prompt（CEFR B1 / B2 單字練習專用）

直接挑選一個範本，修改 `【...】` 括號內的內容後貼給 AntiGravity：

#### 🎮 範本 A：做「B1 / B2 單字闖關小遊戲＋雲端英雄榜」
```text
/cloudflare-workers-d1 我的英文暱稱是【填入小寫英文暱稱，例如：chen01】。
請幫我做一個練習 CEFR 【選填：B1 或 B2】 英語單字的【選一種遊戲類型：迷宮追逐遊戲 / 打地鼠遊戲 / 太空射擊問答 / 翻牌配對遊戲 / 炸彈拆解拼字遊戲】。
需求：
1. 題目玩法為【選一種：看中文解釋找英文單字 / 看英文例句克漏字選正確單字 / 看英文定義找同義字】，畫面要有計分、生命值與關卡顯示，支援鍵盤與手機觸控按鈕。
2. 用 Cloudflare D1 當資料庫，建立 `vocab` 資料表（預先塞入 12 個 CEFR B1/B2 常用單字、解釋與例句，並可從網頁新增單字）與 `leaderboard` 資料表（只記錄班級代號、座號、總分、答對題數，不收真實姓名）。
3. 請自動幫我建立 D1 資料庫、套用遠端 migrations 並部署到 Cloudflare Workers！
```

#### 📚 範本 B：做「B1 / B2 智慧單字卡與限時測驗系統＋雲端紀錄榜」
```text
/cloudflare-workers-d1 我的英文暱稱是【填入小寫英文暱稱，例如：chen01】。
請幫我做一個 CEFR 【選填：B1 或 B2】 英語單字的「互動單字卡 (Flashcards) ＋ 限時四選一測驗」網頁系統。
需求：
1. 包含「學習模式（可翻面看單字、詞性、中英解釋與例句）」與「挑戰測驗模式（限時作答計分）」。
2. 用 Cloudflare D1 當資料庫，建立 `vocab` 資料表（預先塞入 12 個 B1/B2 單字）與 `leaderboard` 資料表（只記錄班級代號、座號、測驗分數，不收真實姓名）。
3. 請自動幫我建立 D1 資料庫、套用遠端 migrations 並部署到 Cloudflare Workers！
```

---

### 五、 Step 4：執行過程中，AI 請你配合的唯一點擊動作

1. **🔑【瀏覽器按 Allow 授權】**：
   * 當 AI 啟動登入並跳出瀏覽器（或給你一串 `https://dash.cloudflare.com/oauth2/auth?...` 連結）時，登入你的 Cloudflare 帳號並點擊 **`Allow（允許）`**（整台電腦只需做這一次！）。
2. **🔑【新帳號首次部署：設定子網域】**（若 AI 有提示才需做）：
   * 若是全新 Cloudflare 帳號第一次發佈，AI 會請你打開 [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ 點左側選單 **`Workers & Pages`** ➔ 自取一個英文子網域名稱並儲存，然後跟 AI 說「好了」。
3. **🎉【完成驗收】**：
   * AI 會自動幫你建好資料庫、建好表格、部署上線並完成測試，最後給你一張「**🎉 部署完成卡**」與公開網址 `https://xxx.workers.dev`，直接點開就能玩！

---
---

## 🌍 Part 2: English Student Handout (For Non-Chinese Environments)

### 1. Why Use This Workflow?
With the **`/cloudflare-workers-d1-en`** skill, your AI Agent deploys your **Frontend Web App + Backend API + Cloud SQL Database (D1)** all together under a single **Cloudflare** account:
* **Zero MCP Setup, Zero API Keys or Tokens**: You never have to copy or paste any secret tokens!
* **Same-Origin Architecture (Zero CORS Issues)**: Works immediately in any normal browser window on desktop, tablet, or mobile—no Incognito window needed!
* **Your Job**: Let the AntiGravity AI run all commands and write all code—you only need **1 install prompt + 1 wish prompt + 1 click on "Allow" in your browser**!

---

### 2. Step 1: Install the Skill into AntiGravity (One-Time Setup)

Open **AntiGravity**, copy the entire block below, and paste it directly into the chat box (the AI will automatically create the folders and install the English skill for you):

#### 💬 Copy & Paste This Install Prompt into AntiGravity (English Edition):
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1-en/SKILL.md and save it as my global AntiGravity skill at ~/.gemini/config/skills/cloudflare-workers-d1-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 After installation, open a new chat and type `/` to see `/cloudflare-workers-d1-en`! Also switch your model selector to **Gemini Flash** for the fastest speed and best free-tier quota efficiency.)*

---

### 3. Step 2: 2-Minute Pre-Flight Checklist (Create a Cloudflare Account)

1. If you don't have a Cloudflare account yet, open 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. Sign up with your Email and a password.
3. **🔑 [Must Do] Verify Your Email**: Open your email inbox (check Spam if needed) and click the verification link from Cloudflare (unverified accounts cannot deploy websites).

---

### 4. Step 3: Fill-in-the-Blank Wish Prompts (CEFR B1 / B2 Vocabulary Practice)

Copy one of the templates below, customize the brackets `[...]`, and send it to AntiGravity:

#### 🎮 Template A: CEFR B1 / B2 Vocabulary Arcade Game + Cloud Leaderboard
```text
/cloudflare-workers-d1-en My English nickname is [enter lowercase nickname, e.g., alex01].
Please build a [Choose Game Type: Maze Chase Game / Whack-a-Mole / Space Quiz Shooter / Memory Card Matching / Word Bomb Defuser] web game for practicing CEFR [Choose: B1 or B2] English vocabulary.
Requirements:
1. Gameplay mode: [Choose: match the English definition to the target word / fill in the blank in a context sentence / match synonyms], with live Score, Lives, and Stage display (supporting both keyboard and touch buttons).
2. Use Cloudflare D1 as the SQLite database with two tables: a `vocab` table (pre-seeded with 12 CEFR B1/B2 words, English definitions, and example sentences—all in pure English, plus a web form to add new words) and a `leaderboard` table (recording only class_code, seat_no, score, and correct_count—no real names).
3. Please automatically create the D1 database, apply remote migrations, and deploy the full-stack app to Cloudflare Workers!
```

#### 📚 Template B: CEFR B1 / B2 Smart Flashcards & Speed Quiz + Cloud Scoreboard
```text
/cloudflare-workers-d1-en My English nickname is [enter lowercase nickname, e.g., alex01].
Please build an interactive "CEFR [Choose: B1 or B2] Vocabulary Flashcards & Timed Speed Quiz" web application.
Requirements:
1. Include a "Study Mode" (flip cards showing the word, part of speech, English definition, and example sentence) and a "Timed Quiz Challenge Mode" (multiple-choice cloze questions with live scoring).
2. Use Cloudflare D1 as the SQLite database with two tables: a `vocab` table (pre-seeded with 12 B1/B2 words in pure English) and a `leaderboard` table (recording only class_code, seat_no, and score—no real names).
3. Please automatically create the D1 database, apply remote migrations, and deploy the full-stack app to Cloudflare Workers!
```

---

### 5. Step 4: What You Click During Deployment

1. **🔑 [Click "Allow" in Browser]**:
   * When the AI runs `wrangler login` and opens your browser (or gives you a `https://dash.cloudflare.com/oauth2/auth?...` link), sign in to Cloudflare and click **`Allow`** (only needed once per computer!).
2. **🔑 [First-Time Account Subdomain Setup]** *(only if prompted)*:
   * If this is a brand-new Cloudflare account, the AI may ask you to open [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ Click **`Workers & Pages`** in the left sidebar ➔ Pick a custom `workers.dev` subdomain name and save it, then reply **"Done"**.
3. **🎉 [Play & Share!]**:
   * The AI will automatically create your D1 database, run SQL migrations, deploy your site, verify the database connection, and hand you your live `https://xxx.workers.dev` URL!

---

## 💻 進階：終端機一鍵安裝腳本 / Advanced: CLI One-Click Install

**Windows (PowerShell):**
```powershell
git clone https://github.com/MeiChen-ai/cloudflare-workers-d1-skill.git
.\cloudflare-workers-d1-skill\scripts\install.ps1
```

**macOS / Linux:**
```bash
git clone https://github.com/MeiChen-ai/cloudflare-workers-d1-skill.git
bash ./cloudflare-workers-d1-skill/scripts/install.sh
```
