# ⚡ OpenCode 零金鑰全端網站＋Cloudflare D1 雲端資料庫實作講義（Weeks 10–11 專用）
# ⚡ OpenCode Zero-Key Web App + Cloudflare D1 Database Classroom Handout (Weeks 10–11 Edition)

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

> 📌 **來源致謝與改編說明 (Credits & Attribution)**
> * **中文說明**：本技能與課堂講義改編並參考自 **[mathruffian-dot/agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)**（原作者：三師爸 `mathruffian-dot`）。在此基礎上，專為 **OpenCode** 與「生成式 AI 與語言學習」課程（第 10–11 週）重構為免 MCP、免 API Key 的 **Cloudflare Workers + D1（SQLite 雲端資料庫）** 雙語技能，並內建「一份 Prompt＝教學規則＋教材內容」的設計與同儕測試紀錄即時看板。
> * **English**: Adapted from and based on **[mathruffian-dot/agent-connect-lazy-pack](https://github.com/mathruffian-dot/agent-connect-lazy-pack)** by `mathruffian-dot`. Tailored into a bilingual (Traditional Chinese & English) **OpenCode** skill for the *GenAI and Language Learning* course (Weeks 10–11), featuring a zero-key, zero-MCP **Cloudflare Workers + D1 (SQLite)** workflow, a one-prompt design (teaching rules + learning content), and a live peer-test log viewer.

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這套方法有什麼超強優點？
在 **OpenCode** 中搭配 **`cloudflare-workers-d1`** 技能與 Cockpit 設計卡產生的指令，你的 AI Agent 會幫你把「**前端互動網頁＋後端 API＋D1 雲端資料庫**」一次部署在同一個 **Cloudflare** 帳號裡：
* **一份 Prompt 搞定（規則＋內容）**：第 10、11 週的設計卡都把「怎麼教」的規則和「教什麼」的內容合成**一份 Prompt**，打開專案資料夾後直接貼進 OpenCode 就好，不需要任何檔案。
* **完全免裝 MCP、免複製任何 API Key 或 Token**：你不需要貼任何密碼或權杖給 AI！
* **前後端同源（零跨域問題）＋ 雲端資料庫全自動建立**：D1 資料表與初始教材皆由 OpenCode 自動建好並寫入，網頁最下方還會內建「**📊 Cloud D1 Peer-Test Logs（雲端同儕測試紀錄即時看板）**」，任何電腦或手機點開網址就能直接測試！
* **你的任務**：寫程式、寫 SQL 與打指令全部交給 OpenCode AI，你只需要做 **「1 句安裝技能指令 ＋ 在 OpenCode 打開專案資料夾 ＋ 貼上 Prompt ＋ 在瀏覽器按一次 Allow」**！

---

### 二、 Step 1：如何安裝？（只需做一次，支援 Antigravity / OpenCode / Claude Code / Codex）

你**完全不需要自己開終端機找資料夾路徑**！只要打開你正在使用的 AI Agent（**OpenCode** 或 **Google Antigravity**），複製下方對應的一段話貼進對話框，AI 就會自動幫你把技能全部安裝好。

#### 💬 複製貼給 AI Agent 自動安裝

##### 選項 1：通用一鍵安裝指令（同時安裝技能到 Antigravity / OpenCode / Claude Code / Codex）
直接複製以下**整段話**貼給你的 **Antigravity** 或 **OpenCode**：
```text
請幫我把 https://github.com/MeiChen-ai/cloudflare-workers-d1-skill.git 完整 clone 到暫存資料夾，並執行裡面的安裝腳本（或將 skills/ 底下的 cloudflare-workers-d1 與 cloudflare-workers-d1-en 完整資料夾複製到 ~/.gemini/config/skills/、~/.config/opencode/skills/、~/.agents/skills/ 與 ~/.claude/skills/，若資料夾不存在請自動建立）。
```

##### 選項 2：如果你只用 Google Antigravity
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1/SKILL.md 下載技能檔，並儲存到我的 ~/.gemini/config/skills/cloudflare-workers-d1/SKILL.md（若資料夾不存在請自動建立）。
```

##### 選項 3：如果你只用 OpenCode
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1/SKILL.md 下載技能檔，並同時儲存到我的 ~/.config/opencode/skills/cloudflare-workers-d1/SKILL.md 與 ~/.agents/skills/cloudflare-workers-d1/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，之後在任何專案資料夾打開 OpenCode 或 Antigravity，它都能自動啟用 `cloudflare-workers-d1` 技能！)*

---

### 三、 Step 2：課前 2 分鐘準備（註冊 Cloudflare 帳號）

1. 如果你還沒有 Cloudflare 帳號，請打開 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. 輸入你的 Email 與自訂密碼完成註冊。
3. **🔑【必做】去信箱收信並點擊 Cloudflare 驗證信**（如果沒看到請檢查垃圾郵件匣；未驗證信箱將無法發佈網站）。

---

### 四、 Step 3：在 OpenCode 打開專案資料夾，貼上 Prompt

1. 在桌面建立一個新的空資料夾（名稱自取，例如 `Week10_App`；第 11 週請另建一個新資料夾，例如 `Week11_App`），這就是你的**專案資料夾**。
2. 打開 **OpenCode 桌面 app**，在開始畫面按 **New Project（新增專案）**，選你的專案資料夾，確認視窗上顯示的是這個資料夾的名稱。
3. 貼上設計卡產生的 Prompt（按 **Copy Prompt for OpenCode and Padlet** 複製），同一份也貼到 Padlet。

| Prompt 的兩部分 | 第 10 週 | 第 11 週 |
| :--- | :--- | :--- |
| 規則（怎麼教） | 分級規則、first-click clue（點第 1 下的提示）、語音、理解題、D1 資料表與部署 | 遊戲類型、輸贏與計分、英文就是玩法、先提示、只做一個循環、先給計畫、D1 資料表與部署 |
| 內容（教什麼） | 暱稱、文章、5 個關鍵字、2 題理解題 | 暱稱、玩家與問題、目標英文、遊戲點子、遊戲內容 |

*(沒有用 Cockpit 的話，也可以照下方範本自己寫：)*

#### 📖 第 10 週範本：「A2 / B1 / B2 分級閱讀與聽力鷹架網＋雲端測試紀錄表」（一份 Prompt）

```text
請用 cloudflare-workers-d1 技能，把我的第 10 週分級閱讀聽力網部署到 Cloudflare Workers + D1。網站名 【暱稱】-w10-reading，資料庫名 【暱稱】-w10-reading-db。

## 規則（怎麼教）
1. 分級切換：把我的文章改寫成 A2 / B1 / B2 三個分頁，三級講同一個故事。分級規則：【A2：每句 12 字以內、基礎字彙；B1：中長句、保留 5 個關鍵字；B2：保留原文】
2. 聽力朗讀列：瀏覽器語音朗讀，Play/Pause 與 1.0x / 0.85x。
3. 兩段式單字提示：每一級都標出我的 5 個關鍵字。點第 1 下：【一個幫我猜意思的語境問句】，不可顯示定義；點第 2 下才顯示英英釋義與例句。
4. 2 題四選一理解題（每一級都能作答），測試者先輸入暱稱再送出、看分數。
5. 網頁最下方可展開的「📊 Cloud D1 Peer-Test Logs」看板。
6. 全部幫我做好：不要叫我寫 SQL、建表或貼任何金鑰。建立 passages（預塞三級課文、單字提示與題目）與 reading_logs（nickname、selected_level、audio_speed、words_clicked、quiz_score、created_at），套用遠端 migrations、部署，最後給我 workers.dev 網址。

## 內容（教什麼）
- 我的暱稱：【小寫英文，例如 alice】
- 文章標題：【標題】
- 文章：【150–200 字英文短文】
- 5 個關鍵字：【word1, word2, word3, word4, word5】
- 2 題理解題：
  Q1：【題目】（正確答案：【答案】）
  Q2：【題目】（正確答案：【答案】）
```

#### 💬 第 11 週範本：「我自己設計的英文遊戲＋雲端遊玩紀錄表」（一份 Prompt）

```text
請用 cloudflare-workers-d1 技能，把我的第 11 週英文遊戲部署到 Cloudflare Workers + D1。網站名 【暱稱】-w11-app，資料庫名 【暱稱】-w11-app-db。第 10 週已登入 Cloudflare：先跑 npx.cmd -y wrangler whoami，需要時才 wrangler login。

## 規則（遊戲怎麼運作）
1. 遊戲類型：【4 選 1：Detective Clues（一個案件、4 條線索，讀線索後猜答案）／ Escape Room（3 個房間，輸入答案開下一間）／ Social Survival（3 個場景，選回應維持「好感度」）／ Word-Building Race（限時把打亂的字排成句子）】
2. 輸贏與計分：【贏的條件、輸的條件、怎麼算分，各一句】
3. 英文就是玩法：玩家不注意或不使用這個英文就不能贏：【目標英文】。不要加不靠它也能得到的分數、生命或獎勵。
4. 先提示：某一題第一次答錯，給一個指向「看哪裡／改什麼」的提示（我有寫提示就用我的）；同一題沒有錯滿兩次之前，不顯示答案；之後顯示答案與一句理由。
5. 只做一個循環：只做上面這個循環，不要加關卡、商店、地圖或多餘畫面。一回合約 3 分鐘。先輸入暱稱（不用真名）；結束顯示輸贏、分數與 Play again 按鈕，並把這回合存進 D1。
6. 先給計畫：動手前先給我一份簡短計畫（玩家做什麼、怎麼輸贏、D1 表放什麼），等我說 OK 才開始做。
7. 網頁最下方可展開的「📊 Cloud D1 Peer-Test Logs」看板。
8. 全部幫我做好：不要叫我寫 SQL、建表或貼任何金鑰。建立 items（預塞我下面的遊戲內容）與 practice_logs（nickname、app_type、score、hints_used、details、created_at）；app_type 存遊戲類型；details 以 win 或 lose 開頭，再依下表存；套用遠端 migrations、部署，最後給我 workers.dev 網址。

## 內容（誰玩、練什麼英文）
- 我的暱稱：【小寫英文，例如 alice】
- 玩家與問題：【例如：英文訊息寫給老師時語氣太直接的大一學生（B1）】
- 目標英文：【玩家必須注意或使用的英文，例如：用 could 的禮貌請求】
- 遊戲點子：【例如：玩家要在請老師幫忙時，讓老師的好感度保持高的生存遊戲】
- 遊戲內容：【依遊戲類型的格式，一行一筆】
```

**遊戲內容格式與 `details`（依你選的遊戲類型）**

| 遊戲類型 | 遊戲內容格式 | 行數 | `details` 要存什麼（開頭先寫 `win` 或 `lose`） |
| :--- | :--- | :--- | :--- |
| Detective Clues | 第 1 行：`問題 \| *正確答案 \| 錯誤答案 \| 錯誤答案`（正確答案前加 `*`）；第 2–5 行：各一條線索 | 5 | 最後猜答案前讀了幾條線索，與猜錯次數 |
| Escape Room | `房間的提示 \| 要輸入的答案 \| 提示` | 3 | 走到第幾間房，與每間房答錯幾次 |
| Social Survival | `情境 \| *最佳回應 \| 較弱回應 \| 較弱回應`（最佳回應前加 `*`） | 3 | 每個場景選了哪些回應（例如 `S1:weak->S1:best->S2:best`）與最後的好感度 |
| Word-Building Race | 正確的句子（遊戲會自己打亂字的順序） | 6 | 答對的句數、用了幾秒、用了幾次提示 |

---

### 五、 Step 4：執行過程中，OpenCode 請你配合的唯一點擊動作

1. **🔑【瀏覽器按 Allow 授權】**：
   * 當 OpenCode 啟動登入並跳出瀏覽器（或給你一串 `https://dash.cloudflare.com/oauth2/auth?...` 連結）時，登入你的 Cloudflare 帳號並點擊 **`Allow（允許）`**（整台電腦只需在第 10 週做這一次，第 11 週免重新登入！）。
2. **🎉【完成驗收與同儕互測】**：
   * OpenCode 會自動幫你建好 D1 資料庫、寫入教材、部署上線並完成測試，最後給你一張「**🎉 部署完成卡**」與公開網址 `https://xxx.workers.dev`，直接貼上 Padlet 讓同學進行 Peer Testing！

---
---

## 🌍 Part 2: English Student Handout (For Non-Chinese Environments)

### 1. Why Use This Workflow in OpenCode?
With the **`cloudflare-workers-d1-en`** skill and the instructions from your Cockpit design card in **OpenCode**, your AI Agent deploys your **Frontend Web App + Backend API + Cloud SQL Database (D1)** all together under a single **Cloudflare** account:
* **One Prompt (Rules + Content)**: In both Week 10 and Week 11, the design card joins the rules (*how* the app teaches) and the content (*what* it teaches) into **one prompt**. Open your project folder in OpenCode and paste it. No file needed.
* **Zero MCP Setup, Zero API Keys or Tokens**: You never have to copy or paste any secret tokens!
* **Auto-Created Cloud Database + Live Log Viewer**: OpenCode automatically creates the D1 SQLite tables, seeds your reading passages or practice items, and adds a collapsible **"📊 Cloud D1 Peer-Test Logs"** viewer at the bottom of your webpage!
* **Your Job**: Let the OpenCode AI run all commands, write all SQL, and build all code—you only need **1 install prompt + opening your project folder in OpenCode + pasting your prompt + 1 click on "Allow" in your browser**!

---

### 2. Step 1: One-Time Installation (Supports Antigravity, OpenCode, Claude Code & Codex)

You do **not** need to manually hunt for hidden skill folders! Simply open your AI Agent (**OpenCode** or **Google Antigravity**), copy one of the blocks below, and paste it directly into the chat box.

#### 💬 Copy & Paste One Prompt to Your AI Agent

##### Option 1: Universal Install Prompt (Installs the Skill to Antigravity, OpenCode, Claude Code & Codex)
Copy and paste this entire block into **Antigravity** or **OpenCode**:
```text
Please clone https://github.com/MeiChen-ai/cloudflare-workers-d1-skill.git into a temporary folder and run its installer script (or copy `cloudflare-workers-d1` and `cloudflare-workers-d1-en` from `skills/` into `~/.gemini/config/skills/`, `~/.config/opencode/skills/`, `~/.agents/skills/`, and `~/.claude/skills/`, creating the directories if they do not exist).
```

##### Option 2: Google Antigravity Only
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1-en/SKILL.md and save it as my global AntiGravity skill at ~/.gemini/config/skills/cloudflare-workers-d1-en/SKILL.md (automatically create the directories if they do not exist).
```

##### Option 3: OpenCode Only
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/cloudflare-workers-d1-skill/main/skills/cloudflare-workers-d1-en/SKILL.md and save it to both ~/.config/opencode/skills/cloudflare-workers-d1-en/SKILL.md and ~/.agents/skills/cloudflare-workers-d1-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 Once installed, OpenCode or Antigravity will automatically recognize the `cloudflare-workers-d1-en` skill in any project folder!)*

---

### 3. Step 2: 2-Minute Pre-Flight Checklist (Create a Cloudflare Account)

1. If you don't have a Cloudflare account yet, open 👉 **[https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)**
2. Sign up with your Email and a password.
3. **🔑 [Must Do] Verify Your Email**: Open your email inbox (check Spam if needed) and click the verification link from Cloudflare (unverified accounts cannot deploy websites).

---

### 4. Step 3: Open Your Project Folder in OpenCode, Then Paste Your Prompt

1. Make a new empty folder on your Desktop. Any name is fine, e.g. `Week10_App`. In Week 11, make another new one, e.g. `Week11_App`. This is your **project folder**.
2. Open the **OpenCode desktop app**, click **New Project（新增專案）** on the start screen, choose your project folder, and check that the window shows its name.
3. Paste the prompt from your design card (press **Copy Prompt for OpenCode and Padlet**). Post the same prompt on Padlet.

| The two parts of the prompt | Week 10 | Week 11 |
| :--- | :--- | :--- |
| Rules (how it teaches) | level rules, first-click clue, audio, check questions, D1 tables & deployment | game type, win/lose/score, English is the mechanic, hint first, one loop, plan first, D1 tables & deployment |
| Content (what it teaches) | nickname, article, 5 key words, 2 check questions | nickname, player & problem, target English, game idea, game content |

*(No Cockpit? Write your own from the templates below.)*

#### 📖 Week 10 Template: CEFR A2 / B1 / B2 Scaffolded Reading & Listening Web App + Cloud Logs (one prompt)

```text
Use the cloudflare-workers-d1-en skill to build and deploy my Week 10 Reading & Listening App on Cloudflare Workers + D1. Name the Worker [nickname]-w10-reading and the database [nickname]-w10-reading-db.

## Rules (how it teaches)
1. Level switcher: rewrite my article into A2 / B1 / B2 tabs that tell the same story. Level rules: [A2: 12 words or fewer per sentence, everyday words; B1: medium sentences, keep the 5 key words; B2: keep the original]
2. Listening bar: browser text-to-speech with Play/Pause and 1.0x / 0.85x.
3. Two-click word help: underline my 5 key words in every level. First click: [a short question about the sentence that helps me guess the meaning]; never show the definition on the first click. Second click: English definition and one example.
4. My 2 check questions as multiple choice (4 options), answerable at every level. The tester types a nickname before submitting, then sees the score.
5. A collapsible "📊 Cloud D1 Peer-Test Logs" table at the bottom.
6. Do it all for me: do NOT ask me to write SQL, create tables, or copy any key or token. Create passages (pre-filled with the three levels, word clues and questions) and reading_logs (nickname, selected_level, audio_speed, words_clicked, quiz_score, created_at), apply remote migrations, deploy, and give me the workers.dev address.

## Content (what it teaches)
- My nickname: [lowercase, e.g., alice]
- Article title: [title]
- Article: [150–200 words of English]
- 5 key words: [word1, word2, word3, word4, word5]
- 2 check questions:
  Q1: [question] (Right answer: [answer])
  Q2: [question] (Right answer: [answer])
```

#### 💬 Week 11 Template: My Own English Game + Cloud Play Logs (one prompt)

```text
Use the cloudflare-workers-d1-en skill to build and deploy my Week 11 English game on Cloudflare Workers + D1. Name the Worker [nickname]-w11-app and the database [nickname]-w11-app-db. I logged in to Cloudflare in Week 10: check with npx.cmd -y wrangler whoami first and only run wrangler login if needed.

## Rules (how my game works)
1. Game type: [pick 1 of 4: Detective Clues (one mystery, 4 clues, read them and guess) / Escape Room (3 rooms, type the answer to open the next one) / Social Survival (3 scenes, pick replies to keep the goodwill up) / Word-Building Race (build sentences from mixed-up words before time runs out)]
2. Win, lose and score: [how the player wins, how they lose, how the score is counted, one sentence each]
3. The English is the mechanic: the player cannot win without noticing or using this English: [target English]. Do not add points, lives or bonuses that work without it.
4. Hint first: after a first miss on an item, show a hint that points to where to look or what to change (use the hint I wrote, if there is one). Never show the answer until the player has missed twice on that item; then show the answer and one short reason.
5. One loop only: build only the loop above. No levels, shop, story map or extra screens. One round takes about 3 minutes. Ask for a nickname first (no real names). At the end show win or lose, the score, and a Play again button, then save the round to D1.
6. Plan first: before you build, show me a short plan (what the player does, how they win or lose, what goes in the D1 tables) and wait for me to say OK.
7. A collapsible "📊 Cloud D1 Peer-Test Logs" viewer at the bottom.
8. Do it all for me: do NOT ask me to write SQL, create tables, or copy any key or token. Create items (pre-filled with my game content below) and practice_logs (nickname, app_type, score, hints_used, details, created_at). Save the game type in app_type; start details with win or lose, then save what the table below says; apply remote migrations, deploy, and give me the workers.dev address.

## Content (who plays and which English)
- My nickname: [lowercase, e.g., alice]
- Player & problem: [e.g., First-year university students (B1) whose messages to teachers sound too direct]
- Target English: [the English the player must notice or use, e.g., polite requests with could]
- Game idea: [e.g., A survival game where the player keeps the teacher's goodwill high while asking for help]
- Game content: [one line each, in the format for your game type]
```

**Game content formats (for the game type you picked)**

| Game type | Game content format | Lines | What `details` saves (start with `win` or `lose`) |
| :--- | :--- | :--- | :--- |
| Detective Clues | Line 1: `question \| *right answer \| wrong answer \| wrong answer` (put `*` before the right answer); lines 2-5: one clue each | 5 | how many clues were read before the final guess, and the number of wrong guesses |
| Escape Room | `note shown in the room \| answer to type \| hint` | 3 | the room reached and the number of wrong tries in each room |
| Social Survival | `situation \| *best reply \| weaker reply \| weaker reply` (put `*` before the best reply) | 3 | the replies chosen in each scene (e.g. `S1:weak->S1:best->S2:best`) and the final goodwill |
| Word-Building Race | the correct sentence (the game mixes up the words) | 6 | sentences correct out of the total, seconds used, and the number of hints used |

---

### 5. Step 4: What You Click During Deployment

1. **🔑 [Click "Allow" in Browser]**:
   * When OpenCode runs `wrangler login` and opens your browser (or gives you a `https://dash.cloudflare.com/oauth2/auth?...` link), sign in to Cloudflare and click **`Allow`** (only needed once in Week 10—Week 11 skips login automatically!).
2. **🎉 [Peer Test & Inspect Cloud D1 Logs!]**:
   * OpenCode will automatically create your D1 database, seed your content, deploy your site, verify the API, and hand you your live `https://xxx.workers.dev` URL ready for Peer Testing!

