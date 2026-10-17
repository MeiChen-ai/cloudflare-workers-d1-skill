# ⚡ OpenCode 零金鑰全端網站＋Cloudflare D1 雲端資料庫實作講義（Weeks 10–11 專用）
# ⚡ OpenCode Zero-Key Web App + Cloudflare D1 Database Classroom Handout (Weeks 10–11 Edition)

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這套方法有什麼超強優點？
在 **OpenCode** 中搭配 **`cloudflare-workers-d1`** 技能與專案根目錄的 **`AGENTS.md`**，你的 AI Agent 會幫你把「**前端互動網頁＋後端 API＋D1 雲端資料庫**」一次部署在同一個 **Cloudflare** 帳號裡：
* **兩層指令：`AGENTS.md` 管規則、Prompt 管內容**：Cockpit 設計卡的 Part A 產生 `AGENTS.md`（每次都要遵守的教學規則），放在專案資料夾**最外層（根目錄）**；Part B 產生 Prompt（這次的文章、單字、題目或情境），貼進 OpenCode 對話框。想改「怎麼教」就改 `AGENTS.md`，想改「教什麼」就改 Prompt！
* **完全免裝 MCP、免複製任何 API Key 或 Token**：你不需要貼任何密碼或權杖給 AI！
* **前後端同源（零跨域問題）＋ 雲端資料庫全自動建立**：D1 資料表與初始教材皆由 OpenCode 自動建好並寫入，網頁最下方還會內建「**📊 Cloud D1 Peer-Test Logs（雲端同儕測試紀錄即時看板）**」，任何電腦或手機點開網址就能直接測試！
* **你的任務**：寫程式、寫 SQL 與打指令全部交給 OpenCode AI，你只需要做 **「1 句安裝技能指令 ＋ 把 `AGENTS.md` 放進資料夾最外層 ＋ 貼上 Prompt ＋ 在瀏覽器按一次 Allow」**！

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

### 四、 Step 3：放好 `AGENTS.md`（規則），再貼上 Prompt（內容）

在桌面上建立你的專案資料夾（例如第 10 週 `Week10_App` 或第 11 週 `Week11_App`），把從課堂 Cockpit 設計卡 **Part A** 下載的 **`AGENTS.md`** 放進該資料夾的**最外層（根目錄）**：

```text
Week10_App/          👈 在這個資料夾打開 OpenCode
└── AGENTS.md        👈 把下載的 AGENTS.md 直接放在這裡（全大寫加 S）！
```

接著在該資料夾打開 **OpenCode**，貼上設計卡 **Part B** 產生的 Prompt（按 **Copy Prompt for OpenCode and Padlet** 複製），同一份也貼到 Padlet。

| | `AGENTS.md`（放進資料夾） | Prompt（貼進對話框） |
| :--- | :--- | :--- |
| 角色 | 每次都要遵守的**規則** | 這一次的**內容** |
| 第 10 週 | 分級規則、first-click clue（點第 1 下的提示）、語音、理解題形式、D1 資料表與部署 | 暱稱、文章、5 個關鍵字、2 題理解題 |
| 第 11 週 | 3 關結構、禮貌度量表、選錯時的提示與重選、D1 資料表與部署 | 暱稱、情境主題 |
| 想修改時 | 改「怎麼教」 | 改「教什麼」 |

*(沒有用 Cockpit 的話，也可以照下方範本自己建一個 `AGENTS.md`，再貼上 Prompt：)*

#### 📖 第 10 週範本：「A2 / B1 / B2 分級閱讀與聽力鷹架網＋雲端測試紀錄表」

**① `AGENTS.md`（規則）**
```markdown
# AGENTS.md — Week 10 Scaffolded Reading & Listening App
## 1. Tools
- 使用 cloudflare-workers-d1 技能，部署到 Cloudflare Workers + D1。
- 網站名 <暱稱>-w10-reading，資料庫名 <暱稱>-w10-reading-db（暱稱見我的 Prompt）。
## 2. Teaching Rules
1. 分級切換：把我的文章改寫成 A2 / B1 / B2 三個分頁，三級講同一個故事。分級規則：【A2：每句 12 字以內、基礎字彙；B1：中長句、保留 5 個關鍵字；B2：保留原文】
2. 聽力朗讀列：瀏覽器語音朗讀，Play/Pause 與 1.0x / 0.85x。
3. 兩段式單字提示：每一級都標出我的 5 個關鍵字。點第 1 下：【一個幫我猜意思的語境問句】，不可顯示定義；點第 2 下才顯示英英釋義與例句。
4. 2 題四選一理解題（每一級都能作答），測試者先輸入暱稱再送出、看分數。
5. 網頁最下方可展開的「📊 Cloud D1 Peer-Test Logs」看板。
## 3. D1 & Deployment
- 不要叫我寫 SQL、建表或貼任何金鑰。
- 建立 passages（預塞三級課文、單字提示與題目）與 reading_logs（nickname、selected_level、audio_speed、words_clicked、quiz_score、created_at），套用遠端 migrations 並部署。
## 4. Content
- 內容來自我的 Prompt。Prompt 與本檔規則衝突時，以本檔為準並告訴我。
```

**② Prompt（內容）**
```text
請讀取資料夾裡的 AGENTS.md 並遵守所有規則，然後用 cloudflare-workers-d1 技能，依以下內容建立並部署我的第 10 週分級閱讀聽力網：
- 我的暱稱：【小寫英文，例如 alice】
- 文章標題：【標題】
- 文章：【150–200 字英文短文】
- 5 個關鍵字：【word1, word2, word3, word4, word5】
- 2 題理解題：
  Q1：【題目】（正確答案：【答案】）
  Q2：【題目】（正確答案：【答案】）
```

#### 💬 第 11 週範本：「跨文化語用禮貌度情境分支卡＋雲端決策路徑紀錄表」

**① `AGENTS.md`（規則）**
```markdown
# AGENTS.md — Week 11 L2 Pragmatics Politeness Branching Cards
## 1. Tools
- 使用 cloudflare-workers-d1 技能，部署到 Cloudflare Workers + D1。
- 網站名 <暱稱>-w11-pragmatics，資料庫名 <暱稱>-w11-pragmatics-db（暱稱見我的 Prompt）。
## 2. Teaching Rules
1. 3 關對話（Turn 1 開場與來意 -> Turn 2 說明理由 -> Turn 3 提出補救與結尾）：每關顯示對方說的話與 3 個選項（Too Blunt / Too Vague / Appropriate）。
2. 禮貌度溫度計與修復分支：選到 Too Blunt 或 Too Vague 時不公布答案，更新禮貌度計量條、顯示語用提示小卡（例如改用 Could I possibly...），讓學習者重選後才進下一關。
3. 網頁最下方可展開的「📊 Cloud D1 Peer-Test Logs」看板。
## 3. D1 & Deployment
- 不要叫我寫 SQL、建表或貼任何金鑰。
- 建立 scenario_nodes（預塞 3 關情境）與 pragmatics_logs（nickname、scenario_topic、choice_path、repairs_triggered），套用遠端 migrations 並部署。
## 4. Content
- 內容來自我的 Prompt。Prompt 與本檔規則衝突時，以本檔為準並告訴我。
```

**② Prompt（內容）**
```text
請讀取資料夾裡的 AGENTS.md 並遵守所有規則，然後用 cloudflare-workers-d1 技能，依以下內容建立並部署我的第 11 週語用情境分支卡：
- 我的暱稱：【小寫英文，例如 alice】
- 情境主題：【例如：寫 Email 向教授申請報告遲交三天 / 職場婉拒主管臨時加派的週末工作 / 跨文化小組討論禮貌反駁隊友意見】
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
* **Two Layers: `AGENTS.md` for Rules, a Prompt for Content**: Part A of the Cockpit design card gives you `AGENTS.md` (the teaching rules OpenCode follows every time), which goes in the **top level (root) of your project folder**. Part B gives you a prompt (this app's article, words, questions or scenario), which you paste into OpenCode. Change *how* it teaches in `AGENTS.md`; change *what* it teaches in the prompt!
* **Zero MCP Setup, Zero API Keys or Tokens**: You never have to copy or paste any secret tokens!
* **Auto-Created Cloud Database + Live Log Viewer**: OpenCode automatically creates the D1 SQLite tables, seeds your reading passages or pragmatics scenarios, and adds a collapsible **"📊 Cloud D1 Peer-Test Logs"** viewer at the bottom of your webpage!
* **Your Job**: Let the OpenCode AI run all commands, write all SQL, and build all code—you only need **1 install prompt + placing `AGENTS.md` in your project root + pasting your prompt + 1 click on "Allow" in your browser**!

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

### 4. Step 3: Place `AGENTS.md` (Rules), Then Paste Your Prompt (Content)

Create your weekly project folder on your Desktop (e.g., `Week10_App` or `Week11_App`) and place the **`AGENTS.md`** file from **Part A** of your course Cockpit design card directly in the **top-level root directory**:

```text
Week10_App/          👈 Open OpenCode in this folder
└── AGENTS.md        👈 Place your downloaded AGENTS.md right here (ALL CAPS + S)!
```

Then launch **OpenCode** inside that folder and paste the prompt from **Part B** of the design card (press **Copy Prompt for OpenCode and Padlet**). Post the same prompt on Padlet.

| | `AGENTS.md` (in your folder) | Prompt (pasted into OpenCode) |
| :--- | :--- | :--- |
| Job | the **rules**, followed every time | this app's **content** |
| Week 10 | level rules, first-click clue, audio, question format, D1 tables & deployment | nickname, article, 5 key words, 2 check questions |
| Week 11 | 3-turn structure, politeness meter, clue-and-retry branch, D1 tables & deployment | nickname, scenario topic |
| To change | *how* it teaches | *what* it teaches |

*(No Cockpit? Build your own `AGENTS.md` and prompt from the templates below.)*

#### 📖 Week 10 Template: CEFR A2 / B1 / B2 Scaffolded Reading & Listening Web App + Cloud Logs

**① `AGENTS.md` (rules)**
```markdown
# AGENTS.md — Week 10 Scaffolded Reading & Listening App
## 1. Tools
- Use the cloudflare-workers-d1-en skill to deploy on Cloudflare Workers + D1.
- Name the Worker <nickname>-w10-reading and the database <nickname>-w10-reading-db (nickname is in my prompt).
## 2. Teaching Rules
1. Level switcher: rewrite my article into A2 / B1 / B2 tabs that tell the same story. Level rules: [A2: 12 words or fewer per sentence, everyday words; B1: medium sentences, keep the 5 key words; B2: keep the original]
2. Listening bar: browser text-to-speech with Play/Pause and 1.0x / 0.85x.
3. Two-click word help: underline my 5 key words in every level. Click 1: [a short question about the sentence that helps me guess the meaning]; never show the definition on click 1. Click 2: English definition and one example.
4. My 2 check questions as multiple choice (4 options), answerable at every level. The tester types a nickname before submitting, then sees the score.
5. A collapsible "📊 Cloud D1 Peer-Test Logs" table at the bottom.
## 3. D1 & Deployment
- Do NOT ask me to write SQL, create tables, or copy any key or token.
- Create passages (pre-filled with the three levels, word clues and questions) and reading_logs (nickname, selected_level, audio_speed, words_clicked, quiz_score, created_at), apply remote migrations, and deploy.
## 4. Content
- The content comes from my prompt. If my prompt and these rules disagree, follow these rules and tell me.
```

**② Prompt (content)**
```text
Please read AGENTS.md in this folder and follow all its rules. Then use the cloudflare-workers-d1-en skill to build and deploy my Week 10 Reading & Listening App with this content:
- My nickname: [lowercase, e.g., alice]
- Article title: [title]
- Article: [150–200 words of English]
- 5 key words: [word1, word2, word3, word4, word5]
- 2 check questions:
  Q1: [question] (Right answer: [answer])
  Q2: [question] (Right answer: [answer])
```

#### 💬 Week 11 Template: L2 Pragmatics Politeness Branching Scenario Cards + Cloud Path Logs

**① `AGENTS.md` (rules)**
```markdown
# AGENTS.md — Week 11 L2 Pragmatics Politeness Branching Cards
## 1. Tools
- Use the cloudflare-workers-d1-en skill to deploy on Cloudflare Workers + D1.
- Name the Worker <nickname>-w11-pragmatics and the database <nickname>-w11-pragmatics-db (nickname is in my prompt).
## 2. Teaching Rules
1. 3 turns (Turn 1 Opening Request -> Turn 2 Explaining Reasons -> Turn 3 Follow-up & Closing): show the other person's line and 3 choices (Too Blunt / Too Vague / Appropriate).
2. Politeness Meter & Repair Branch: for Too Blunt or Too Vague, do NOT reveal the best answer; update the meter, show a Pragmatic Clue (e.g., hedging with "Could I possibly..."), and let the learner retry before moving on.
3. A collapsible "📊 Cloud D1 Peer-Test Logs" viewer at the bottom.
## 3. D1 & Deployment
- Do NOT ask me to write SQL, create tables, or copy any key or token.
- Create scenario_nodes (pre-filled with the 3 turns) and pragmatics_logs (nickname, scenario_topic, choice_path, repairs_triggered), apply remote migrations, and deploy.
## 4. Content
- The content comes from my prompt. If my prompt and these rules disagree, follow these rules and tell me.
```

**② Prompt (content)**
```text
Please read AGENTS.md in this folder and follow all its rules. Then use the cloudflare-workers-d1-en skill to build and deploy my Week 11 Pragmatics Branching Cards with this content:
- My nickname: [lowercase, e.g., alice]
- Scenario topic: [e.g., Emailing a professor to request a 3-day essay extension / Politely declining a coworker's last-minute weekend request / Disagreeing politely in an international team meeting]
```

---

### 5. Step 4: What You Click During Deployment

1. **🔑 [Click "Allow" in Browser]**:
   * When OpenCode runs `wrangler login` and opens your browser (or gives you a `https://dash.cloudflare.com/oauth2/auth?...` link), sign in to Cloudflare and click **`Allow`** (only needed once in Week 10—Week 11 skips login automatically!).
2. **🔑 [First-Time Account Subdomain Setup]** *(only if prompted)*:
   * If this is a brand-new Cloudflare account, the AI may ask you to open [https://dash.cloudflare.com/](https://dash.cloudflare.com/) ➔ Click **`Workers & Pages`** in the left sidebar ➔ Pick a custom `workers.dev` subdomain name and save it, then reply **"Done"**.
3. **🎉 [Peer Test & Inspect Cloud D1 Logs!]**:
   * OpenCode will automatically create your D1 database, seed your content, deploy your site, verify the API, and hand you your live `https://xxx.workers.dev` URL ready for Peer Testing!

