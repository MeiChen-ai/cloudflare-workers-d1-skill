# ⚡ OpenCode 零金鑰全端網站＋Cloudflare D1 雲端資料庫實作講義（Weeks 10–11 專用）
# ⚡ OpenCode Zero-Key Web App + Cloudflare D1 Database Classroom Handout (Weeks 10–11 Edition)

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這套方法有什麼超強優點？
在 **OpenCode** 中搭配 **`cloudflare-workers-d1`** 技能與專案根目錄的 **`AGENTS.md`**，你的 AI Agent 會幫你把「**前端互動網頁＋後端 API＋D1 雲端資料庫**」一次部署在同一個 **Cloudflare** 帳號裡：
* **用 `AGENTS.md` 管理教學規則**：只要把從課程 Cockpit 設計卡下載的 `AGENTS.md` 放在你的專案資料夾**最外層（根目錄）**，OpenCode 一啟動就會自動讀取並遵守！
* **完全免裝 MCP、免複製任何 API Key 或 Token**：你不需要貼任何密碼或權杖給 AI！
* **前後端同源（零跨域問題）＋ 雲端資料庫全自動建立**：D1 資料表與初始教材皆由 OpenCode 自動建好並寫入，網頁最下方還會內建「**📊 Cloud D1 Peer-Test Logs（雲端同儕測試紀錄即時看板）**」，任何電腦或手機點開網址就能直接測試！
* **你的任務**：寫程式、寫 SQL 與打指令全部交給 OpenCode AI，你只需要做 **「1 句安裝技能指令 ＋ 把 `AGENTS.md` 放進資料夾最外層 ＋ 在瀏覽器按一次 Allow」**！

---

### 二、 Step 1：把技能安裝進你的 OpenCode（只需做一次）

打開 **OpenCode**，直接複製以下**整段話**貼進對話框送出（OpenCode 會自動幫你建立全域技能資料夾並下載技能，完全不用自己去檔案總管找路徑）：

#### 💬 複製貼給 OpenCode 的安裝指令（中文版）：
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1/SKILL.md 下載技能檔，並同時儲存到我的 ~/.config/opencode/skills/cloudflare-workers-d1/SKILL.md 與 ~/.agents/skills/cloudflare-workers-d1/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，之後在任何專案資料夾打開 OpenCode，它都能自動啟用 `cloudflare-workers-d1` 技能！)*

---

### 三、 Step 2：課前 2 分鐘準備（註冊 Cloudflare 帳號）

1. 如果你還沒有 Cloudflare 帳號，請打開 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. 輸入你的 Email 與自訂密碼完成註冊。
3. **🔑【必做】去信箱收信並點擊 Cloudflare 驗證信**（如果沒看到請檢查垃圾郵件匣；未驗證信箱將無法發佈網站）。

---

### 四、 Step 3：把 `AGENTS.md` 放進專案資料夾最外層（或直接貼上許願指令）

在桌面上建立你的專案資料夾（例如第 10 週 `Week10_App` 或第 11 週 `Week11_App`），把從課堂 Cockpit 設計卡下載的 **`AGENTS.md`** 放進該資料夾的**最外層（根目錄）**：

```text
Week10_App/          👈 在這個資料夾打開 OpenCode
└── AGENTS.md        👈 把下載的 AGENTS.md 直接放在這裡（全大寫加 S）！
```

接著在該資料夾打開 **OpenCode**，直接輸入一句話：
> **`請讀取資料夾裡的 AGENTS.md，幫我建立網站與 Cloudflare D1 資料庫並部署上線！`**

*(如果你沒有用 Cockpit 下載 `AGENTS.md`，也可以直接複製下方第 10 週或第 11 週範本貼給 OpenCode：)*

#### 📖 第 10 週範本：做「A2 / B1 / B2 分級閱讀與聽力鷹架網＋雲端測試紀錄表」
```text
請使用 cloudflare-workers-d1 技能，我的英文小寫暱稱是【填入小寫英文暱稱，例如：alice】。
請根據以下英文短文，幫我建立並部署一個「CEFR A2 / B1 / B2 分級閱讀與聽力鷹架微學習網頁」：
【在此貼上一篇 150–200 字的英文短文】

教學與資料庫需求（請全部自動建立，不要叫我手動建表）：
1. A2 / B1 / B2 即時難度切換：將短文改寫為 A2（短句、基礎字彙）、B1（中長句、標註 5 個重點單字）、B2（保留原文複雜度）三個分頁。
2. 聽力朗讀控制列：內建瀏覽器語音朗讀（Play/Pause 與 1.0x / 0.85x 慢速切換）。
3. 兩段式點擊單字提示（Two-Click Gloss）：點底線單字第 1 下只顯示「語境推敲線索問句（不可直接顯示定義）」，點第 2 下才顯示英英釋義與例句。
4. 讀後 2 題四選一理解小考，並在網頁最下方內建可展開的「📊 Cloud D1 Peer-Test Logs」即時看板。
5. 自動建立 Cloudflare D1 資料庫（含預塞三級課文的 `passages` 表，以及記錄測試者暱稱、所選等級、語速、點選單字與得分的 `reading_logs` 表），套用遠端 migrations 並部署到 Cloudflare Workers！
```

#### 💬 第 11 週範本：做「跨文化語用禮貌度情境分支卡＋雲端決策路徑紀錄表」
```text
請使用 cloudflare-workers-d1 技能，我的英文小寫暱稱是【填入小寫英文暱稱，例如：alice】。
請幫我建立並部署一個「3 關卡跨文化英語語用禮貌度情境分支網頁 (L2 Pragmatics Branching Scenario Cards)」！
情境主題：【填入溝通情境，例如：寫 Email 向教授申請報告遲交三天 / 職場婉拒主管臨時加派的週末工作 / 跨文化小組討論禮貌反駁隊友意見】。

教學與資料庫需求（請全部自動建立，不要叫我手動建表）：
1. 3 關卡對話情境（Turn 1 開場與來意 -> Turn 2 說明理由 -> Turn 3 提出補救與結尾）：每一關顯示對方說的話與 3 個不同禮貌程度的回應選項（Too Blunt 太直接沒禮貌 / Too Vague 太模糊 / Appropriate 恰當得體）。
2. 禮貌度溫度計與語用修復分支（Repair Branch）：當學習者選到 Too Blunt 或 Too Vague 時，不要直接公布答案，請更新禮貌度計量條、跳出「語用提示小卡（Pragmatic Clue，例如提示改用 Could I possibly... 等緩和語氣）」並讓學習者重選修復後才能進入下一關。
3. 網頁最下方內建可展開的「📊 Cloud D1 Peer-Test Logs」即時看板。
4. 自動建立 Cloudflare D1 資料庫（含預塞 3 關情境題庫的 `scenario_nodes` 表，以及記錄測試者暱稱、完整決策路徑 `choice_path` 與觸發修復次數的 `pragmatics_logs` 表），套用遠端 migrations 並部署到 Cloudflare Workers！
```

---

### 五、 Step 4：執行過程中，OpenCode 請你配合的唯一點擊動作

1. **🔑【瀏覽器按 Allow 授權】**：
   * 當 OpenCode 啟動登入並跳出瀏覽器（或給你一串 `https://dash.cloudflare.com/oauth2/auth?...` 連結）時，登入你的 Cloudflare 帳號並點擊 **`Allow（允許）`**（整台電腦只需在第 10 週做這一次，第 11 週免重新登入！）。
2. **🔑【新帳號首次部署：設定子網域】**（若 AI 有提示才需做）：
   * 若是全新 Cloudflare 帳號第一次發佈，AI 會請你打開 [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ 點左側選單 **`Workers & Pages`** ➔ 自取一個英文子網域名稱並儲存，然後跟 AI 說「好了」。
3. **🎉【完成驗收與同儕互測】**：
   * OpenCode 會自動幫你建好 D1 資料庫、寫入教材、部署上線並完成測試，最後給你一張「**🎉 部署完成卡**」與公開網址 `https://xxx.workers.dev`，直接貼上 Padlet 讓同學進行 Peer Testing！

---
---

## 🌍 Part 2: English Student Handout (For Non-Chinese Environments)

### 1. Why Use This Workflow in OpenCode?
With the **`cloudflare-workers-d1-en`** skill and a project-root **`AGENTS.md`** file in **OpenCode**, your AI Agent deploys your **Frontend Web App + Backend API + Cloud SQL Database (D1)** all together under a single **Cloudflare** account:
* **Rule-Driven via `AGENTS.md`**: Simply drop the `AGENTS.md` file downloaded from your course Cockpit Design Card into the **top level (root) of your project folder**, and OpenCode reads and follows it automatically!
* **Zero MCP Setup, Zero API Keys or Tokens**: You never have to copy or paste any secret tokens!
* **Auto-Created Cloud Database + Live Log Viewer**: OpenCode automatically creates the D1 SQLite tables, seeds your reading passages or pragmatics scenarios, and adds a collapsible **"📊 Cloud D1 Peer-Test Logs"** viewer at the bottom of your webpage!
* **Your Job**: Let the OpenCode AI run all commands, write all SQL, and build all code—you only need **1 install prompt + placing `AGENTS.md` in your project root + 1 click on "Allow" in your browser**!

---

### 2. Step 1: Install the Skill into OpenCode (One-Time Setup)

Open **OpenCode**, copy the entire block below, and paste it directly into the prompt box (the AI will automatically create the folders and install the English skill for you):

#### 💬 Copy & Paste This Install Prompt into OpenCode (English Edition):
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1-en/SKILL.md and save it to both ~/.config/opencode/skills/cloudflare-workers-d1-en/SKILL.md and ~/.agents/skills/cloudflare-workers-d1-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 Once installed, OpenCode will automatically recognize the `cloudflare-workers-d1-en` skill in any project folder!)*

---

### 3. Step 2: 2-Minute Pre-Flight Checklist (Create a Cloudflare Account)

1. If you don't have a Cloudflare account yet, open 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. Sign up with your Email and a password.
3. **🔑 [Must Do] Verify Your Email**: Open your email inbox (check Spam if needed) and click the verification link from Cloudflare (unverified accounts cannot deploy websites).

---

### 4. Step 3: Place `AGENTS.md` in Your Project Root (or Paste a Wish Prompt)

Create your weekly project folder on your Desktop (e.g., `Week10_App` or `Week11_App`) and place the **`AGENTS.md`** file downloaded from your course Cockpit Design Card directly in the **top-level root directory**:

```text
Week10_App/          👈 Open OpenCode in this folder
└── AGENTS.md        👈 Place your downloaded AGENTS.md right here (ALL CAPS + S)!
```

Then launch **OpenCode** inside that folder and type one short sentence:
> **`Please read AGENTS.md in this folder, build the web app and Cloudflare D1 database, and deploy it live!`**

*(Or, if you want to prompt OpenCode directly without a pre-downloaded `AGENTS.md`, copy one of the templates below:)*

#### 📖 Week 10 Template: CEFR A2 / B1 / B2 Scaffolded Reading & Listening Web App + Cloud Logs
```text
Please use the cloudflare-workers-d1-en skill. My lowercase English nickname is [enter lowercase nickname, e.g., alice].
Based on the source article below, please build and deploy a "CEFR A2 / B1 / B2 Scaffolded Reading & Listening Microlearning Web App":
[Paste a 150–200 word English article here]

Pedagogical & Database Requirements (Auto-create all tables and seed data—do not ask me to write SQL manually):
1. A2 / B1 / B2 Instant Level Switcher: Adapt the source article into three selectable tabs—A2 (short sentences <=12 words, basic vocabulary), B1 (medium sentences, 5 highlighted target words), and B2 (authentic text complexity).
2. Listening Scaffold: Add a browser TTS audio bar (window.speechSynthesis) with Play/Pause and 1.0x / 0.85x speed buttons.
3. Two-Click Vocabulary Glosses: Highlight 5 key words in the text. 1st click shows ONLY a context-inference clue question (never reveal the definition on the 1st click); 2nd click reveals the English definition and example.
4. Add 2 multiple-choice comprehension questions at the bottom, plus a collapsible "📊 Cloud D1 Peer-Test Logs" table showing all submitted peer-test records.
5. Automatically create the Cloudflare D1 database (with a pre-seeded `passages` table and a `reading_logs` table recording nickname, selected_level, audio_speed, words_clicked, and quiz_score), apply remote migrations, and deploy to Cloudflare Workers!
```

#### 💬 Week 11 Template: L2 Pragmatics Politeness Branching Scenario Cards + Cloud Path Logs
```text
Please use the cloudflare-workers-d1-en skill. My lowercase English nickname is [enter lowercase nickname, e.g., alice].
Please build and deploy an interactive "3-Turn L2 Pragmatics Politeness Branching Scenario Web App"!
Scenario Topic: [Enter scenario, e.g., Emailing a professor to request a 3-day essay extension / Politely declining a coworker's last-minute weekend request / Disagreeing politely in an international team meeting].

Pedagogical & Database Requirements (Auto-create all tables and seed data—do not ask me to write SQL manually):
1. 3-Turn Scenario Cards (Turn 1 Opening Request -> Turn 2 Explaining Reasons -> Turn 3 Offering Follow-up & Closing): At each turn, display the interlocutor's line and 3 response choices (Too Blunt / Too Vague / Pragmatically Appropriate).
2. Politeness Meter & Repair Branch: When a learner selects a Too Blunt or Too Vague option, do NOT auto-reveal the best answer—update the visual Politeness Meter, show a Pragmatic Clue (Elicitation, e.g., suggesting modal hedging like "Could I possibly..."), and let the learner retry before advancing.
3. Include a collapsible "📊 Cloud D1 Peer-Test Logs" viewer at the bottom of the webpage.
4. Automatically create the Cloudflare D1 database (with a pre-seeded `scenario_nodes` table and a `pragmatics_logs` table recording nickname, scenario_topic, full choice_path such as Step1:Blunt(Repair)->Step2:OK->Step3:OK, and repairs_triggered), apply remote migrations, and deploy to Cloudflare Workers!
```

---

### 5. Step 4: What You Click During Deployment

1. **🔑 [Click "Allow" in Browser]**:
   * When OpenCode runs `wrangler login` and opens your browser (or gives you a `https://dash.cloudflare.com/oauth2/auth?...` link), sign in to Cloudflare and click **`Allow`** (only needed once in Week 10—Week 11 skips login automatically!).
2. **🔑 [First-Time Account Subdomain Setup]** *(only if prompted)*:
   * If this is a brand-new Cloudflare account, the AI may ask you to open [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ Click **`Workers & Pages`** in the left sidebar ➔ Pick a custom `workers.dev` subdomain name and save it, then reply **"Done"**.
3. **🎉 [Peer Test & Inspect Cloud D1 Logs!]**:
   * OpenCode will automatically create your D1 database, seed your content, deploy your site, verify the API, and hand you your live `https://xxx.workers.dev` URL ready for Peer Testing!

