# Custom Tags — updated scripts (2021-compatible)

Drop-in replacements for the tag system in `r69 (1).rbxl`. No RBXL is shipped —
paste each file over the matching script in Studio and republish.

| File | Where it goes | What changed |
|---|---|---|
| `TagConfig.lua` | `ReplicatedStorage/TagConfig` | + `thug` tag (shimmer, glowing white, users = thugshaker 49603). `headadmin` tag added but now **staff-list driven** (no hard-coded user). |
| `TagHandler.lua` | `ServerScriptService/TagHandler` | + `RANK_HEADADMIN = 3` → staff-list rank 3 gets the `headadmin` **nametag**. `thug` kept in priority list so thugshaker always gets `[Thug]` (he's also in the owner list, and `pairs()` order is random). |
| `Server.lua` | `ServerScriptService/Server` | **The chat-tag home.** + `RANK_HEADADMIN = 3` rank (Developer→4, Owner→5, all comparisons are `>=` so nothing else changes). Head Admin shows in the staff list, who-list, ADONIS sync and chat tag. + `Make Head Admin` command (owner-only) which writes Rank 3 into `StaffList_v2`. + `CUSTOM_CHAT_TAGS`: thugshaker (49603) gets `[Thug]` in yellow-gold `Color3.fromRGB(255, 200, 0)` with his name recolored gold, overriding his Owner chat tag. |
| `VerifiedInChat.lua` | `StarterPlayerScripts/VerifiedInChat` | **Unchanged** (restored to original). Chat tags do NOT live here — they're in `Server.lua`'s `ApplyChatTag`, which is the real admin-panel chat tag system. |

## How the tags get given

### Thug tag (thugshaker, 49603)
- **Nametag:** `TagHandler.getAutoTag` → priority scan → `TagConfig["thug"]`
  → `[Thug] ` + shimmer/white gradient above his head.
- **Chat tag:** `Server.lua` `ApplyChatTag` → `CUSTOM_CHAT_TAGS[49603]`
  → `SetExtraData("Tags", {{TagText = "[Thug] ", TagColor = gold}})`
  + `SetExtraData("NameColor", gold)`.

### Head Admin tag
- Put the head admin in the staff whitelist (`StaffList_v2`, key `"staff"`) with
  **Rank = 3**. The easiest way: open the admin panel as Owner and use the new
  **"Make Head Admin"** command (it shows in the COMMANDS grid). Or edit the
  DataStore row directly: `{ Rank = 3, Name = "their name", By = "you" }`.
- **Nametag:** `TagHandler` staff check → `headadmin` → `[Head Admin]` gold shimmer.
- **Chat tag:** generic staff path → `RankLabel(3)` = `Head Admin` in gold
  `Color3.fromRGB(255, 215, 0)`, name recolored gold.
- The `LoadStaff` clamp (`rank >= RANK_DEV → Admin`) still blocks tampered ranks
  4+, but Head Admin (3) is a real whitelist rank and survives restarts, exactly
  like Mod/Admin.
- Owner-only guard: only an Owner can grant/change Head Admin (admins get
  "You cannot hand out a rank at or above your own.").

## 2021 compatibility
Everything used is 2019–2021 era: `Color3.fromRGB`, `ColorSequence`,
`utf8.char`, `SetExtraData`, `SetAttribute`, `spawn()`/`wait()`. No `task.*`,
no string interpolation, no `continue`. (The original `Server.lua` itself
states it targets 2021-era Luau; the edits stay in that style.)
