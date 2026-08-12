# Replacement guide — swap these files into Studio

This folder contains the updated scripts. Below is exactly what to replace,
and nothing else. Instance names and locations in Studio stay the same — you
are only replacing the **Source** (the Lua code) of each script.

---

## Files in this folder

| File | Replaces (in Studio) |
|---|---|
| `TagConfig.lua` | `ReplicatedStorage/TagConfig` (ModuleScript) |
| `TagHandler.lua` | `ServerScriptService/TagHandler` (Script) |
| `Server.lua` | `ServerScriptService/Server` (Script) |
| `VerifiedInChat.lua` | `StarterPlayer/StarterPlayerScripts/VerifiedInChat` (LocalScript) |

---

## Step 0 — Before you start

1. Open the place (`r69 (1).rbxl`) in Roblox Studio.
2. Make sure the **Explorer** window is open (View tab → Explorer).
3. Make sure the **Script Editor** / output area is visible (View tab → Script Editor).
4. Keep a copy of the original place file somewhere, so you can go back if needed.
5. The `Server.lua` file is large (~124 KB). Copy it from this folder with
   **Ctrl+A → Ctrl+C** in your text editor, then paste it into Studio in one go.

---

## Step 1 — Replace `ReplicatedStorage/TagConfig`

1. In the **Explorer**, expand `ReplicatedStorage`.
2. Find the ModuleScript named **`TagConfig`** (it sits directly under ReplicatedStorage, next to `TopbarPlus`, `ModuleScript`, etc.).
3. Double-click it — the ModuleScript editor opens.
4. In the editor, press **Ctrl+A** (selects the entire current source) then **Delete** — the editor must be completely empty.
5. Open `tag_scripts/TagConfig.lua` from this folder, **Ctrl+A → Ctrl+C** the whole file.
6. Paste into the empty editor (**Ctrl+V**).
7. Press **Ctrl+S** (saves the script — this saves into the place file).

> Do NOT rename `TagConfig`, do NOT move it out of `ReplicatedStorage`, do NOT
> create a second TagConfig anywhere.

---

## Step 2 — Replace `ServerScriptService/TagHandler`

1. In the **Explorer**, expand `ServerScriptService`.
2. Find the Script named **`TagHandler`** (sits directly under ServerScriptService, between `VerifiedUsername` and `Server`).
3. Double-click it to open the editor.
4. **Ctrl+A → Delete** until the editor is completely empty.
5. Open `tag_scripts/TagHandler.lua`, **Ctrl+A → Ctrl+C** the whole file, paste it in.
6. **Ctrl+S**.

> Do NOT rename `TagHandler`, do NOT move it out of `ServerScriptService`.

---

## Step 3 — Replace `ServerScriptService/Server`

1. In the **Explorer**, still under `ServerScriptService`, find the Script named **`Server`** (it's right after `TagHandler` in the list — the large one).
2. Double-click it to open the editor.
3. **Ctrl+A → Delete** — the editor must be completely empty. (This one is big; make sure you deleted everything before pasting, otherwise you'll end up with two copies of the code on top of each other.)
4. Open `tag_scripts/Server.lua` (the ~124 KB file), **Ctrl+A → Ctrl+C** the whole file, paste it in.
5. **Ctrl+S**.

> Do NOT rename `Server`, do NOT move it out of `ServerScriptService`. Do NOT
> replace any other script in that folder — `AdminPanelServer`, `tvs`, `afk`,
> `VerifiedUsername`, and the `ADONIS_v225` folder all stay untouched.

---

## Step 4 — Replace `StarterPlayer/StarterPlayerScripts/VerifiedInChat`

1. In the **Explorer**, expand `StarterPlayer` → `StarterPlayerScripts`.
2. Find the LocalScript named **`VerifiedInChat`** (between `clickdet` and `TopbarScript`).
3. This file (`tag_scripts/VerifiedInChat.lua`) is the **original, untouched**
   version. Only replace it if you previously pasted a *modified* version of
   this script into Studio (from an earlier step). If you never touched it,
   skip this step entirely.
4. To replace: double-click it, **Ctrl+A → Delete**, paste the whole contents
   of `tag_scripts/VerifiedInChat.lua`, **Ctrl+S**.

---

## Step 5 — Verify everything

1. In the **Explorer**, confirm each replaced script is in the right place and
   still named exactly: `ReplicatedStorage/TagConfig`,
   `ServerScriptService/TagHandler`, `ServerScriptService/Server`,
   `StarterPlayer/StarterPlayerScripts/VerifiedInChat`.
2. Open each of the three replaced scripts and confirm there is exactly **one**
   copy of the code (no duplicated blocks at the top or bottom) and the file
   starts with `local TagConfig = {` / `-- // handler by matt and fuz` /
   `--[[\n\tBooth admin script` respectively.
3. Open the place in **Play** mode (or publish it) — the Output window should
   show no `TagConfig not found` warnings from `Server`.
4. File → **Save** (and File → Publish to Roblox if this is the live place).

---

## What NOT to touch

- `ServerScriptService/AdminPanelServer`
- `ServerStorage/AdminPanelClient`
- `StarterGui/MainUI/Theguin`
- The `ADONIS_v225` folder
- The `ChatServiceRunner` (it's created by the engine, not in the place file)
- Any script named `AdminPanelClient` / `AdminPanelServer` — the chat tag
  system lives in `Server`, which you already replaced.
