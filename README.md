# Planus

一本私人的問題日記：想到的問題先記下來，之後再補上答案。

介面參考 iOS 的 Liquid Glass 風格，支援淺色／深色模式，加到 iPhone 主畫面後會以獨立 App 的形式全螢幕開啟。

Planus 是一個**純前端、本機優先（local-first）**的單頁網頁（`index.html`，另有主畫面圖示 `icon.png` 與 `manifest.webmanifest`）：

- 不需要後端、資料庫、登入或任何 API key
- 所有資料都存放在瀏覽器的 `localStorage` 裡
- 不會把資料傳到任何伺服器

## 功能

- 新增、編輯、刪除問題
- 新增、修改答案（答案清空後，問題會回到「待回答」）
- 篩選：待回答／已回答／全部
- 搜尋問題和答案
- 隨機抽一題待回答的問題
- 匯出／匯入 JSON 備份
- 支援手機和桌面（響應式版面）
- 在輸入框按 `Ctrl/⌘ + Enter` 可以快速儲存
- 網址加上 `?capture=1` 會一打開就進入「新問題」畫面，適合做成手機主畫面捷徑

## ⚠️ 關於資料儲存（請務必閱讀）

- **資料只存在當前的瀏覽器和裝置裡。** 手機和電腦各自有一份，**不會自動同步**。
- 不同瀏覽器（例如 Safari 和 Chrome）的資料也是分開的。
- `localStorage` 綁定**網址（網域）**。換了網址（例如從 GitHub Pages 搬到 Netlify），新網址會是空的，舊資料要先匯出再匯入。
- 清除瀏覽器資料或網站資料、使用無痕模式，或 iOS Safari 長期（約 7 天以上）沒有開啟網站，資料都**可能被清除**。把網站「加入主畫面」後使用，被清除的機會較低，但仍然建議定期備份。
- **請定期按右上角 ⋯ →「匯出備份」**，把 JSON 檔存到 iCloud Drive、Google Drive 等安全的地方。

### 在不同裝置之間搬資料

1. 在舊裝置按右上角 **⋯ → 匯出備份**，得到 `planus-backup-YYYY-MM-DD.json`
2. 把檔案傳到新裝置
3. 在新裝置開啟 Planus，按右上角 **⋯ → 匯入備份**，選擇該檔案
   - **確定**：用備份完全取代目前資料
   - **取消**：合併（同一條記錄以較新的版本為準）

匯入也接受舊版（Supabase 版本）匯出的 JSON 陣列。

## 本機使用

不需要安裝任何東西：

- 直接用瀏覽器開啟 `index.html` 即可；或
- 在資料夾內啟動一個本機伺服器（建議，網址比較固定）：

  ```bash
  python3 -m http.server 8000
  # 然後開啟 http://localhost:8000
  ```

> 注意：用 `file://` 開啟和用 `http://localhost:8000` 開啟是兩個不同的「網址」，資料不互通。

## 部署（上線）

整個網站只有靜態檔案，不需要建置（build）步驟，也沒有環境變數。任選一種方式：

### 方案 A：Cloudflare Pages / Netlify / Vercel（私人倉庫免費可用）

1. 登入服務，選擇「Import from GitHub」並授權存取 `hosoning/Planus`
2. 設定：
   - Framework preset：**None**
   - Build command：**留空**
   - Output / Publish directory：`/`（根目錄）
3. 部署。之後每次 push 到 `main` 都會自動更新

### 方案 B：Netlify Drop（最快，不需要連 GitHub）

到 <https://app.netlify.com/drop>，把整個資料夾（或只有 `index.html`）拖進去即可。之後要更新就再拖一次到同一個網站。

### 方案 C：GitHub Pages

1. 倉庫 **Settings → Pages**
2. Source 選 **Deploy from a branch**，Branch 選 `main`、資料夾 `/ (root)`，按 Save
3. 幾分鐘後網址會是 `https://hosoning.github.io/Planus/`

> 免費帳號只有公開倉庫可以使用 GitHub Pages（私人倉庫需要 GitHub Pro）。Pages 網站本身任何人都能打開，但這不影響隱私：網站只是一個空殼，你的問題和答案只存在你自己的瀏覽器裡，別人打開看到的是一本空白的問題本。

### 加到手機主畫面

- **iPhone（Safari）**：開啟網址 → 分享 → 「加入主畫面」（會使用 Planus 圖示，並以全螢幕 App 形式開啟）
- **Android（Chrome）**：開啟網址 → 選單 → 「加到主畫面」

想要一打開就能直接輸入，可以把網址設成 `https://你的網址/?capture=1`。

## 資料格式

`localStorage` 鍵名：`planus.questions.v1`

匯出檔格式：

```json
{
  "app": "planus",
  "version": 1,
  "exported_at": "2026-11-06T10:00:00.000Z",
  "questions": [
    {
      "id": "uuid",
      "question": "問題內容",
      "answer": "回答內容或 null",
      "created_at": "ISO 時間",
      "answered_at": "ISO 時間或 null",
      "updated_at": "ISO 時間"
    }
  ]
}
```
