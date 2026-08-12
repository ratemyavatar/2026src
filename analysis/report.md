# RBXL Analysis — `r69 (1).rbxl`

## 1. File overview

| Property | Value |
|---|---|
| File size | 2,390,653 bytes (~2.3 MB) |
| Format | Roblox **binary** `.rbxl` (rbx-dom "Version 0" binary format) |
| Header | `<roblox!` + signature, format version `0`, 8 reserved bytes |
| Chunks | 1,897 (1 `SSTR`, 134 `INST`, 1,760 `PROP`, 1 `PRNT`, 1 `END`) |
| Distinct classes | 134 |
| Instances | 13,834 |
| Shared strings | 41 |
| Chunk compression | LZ4 (every non-`END` chunk is LZ4-compressed; `END` holds `</roblox>`) |
| Int encoding | Zigzag-transformed big-endian ints, byte-interleaved arrays, Roblox float format |

A custom parser for this format was written for this analysis: **`tools/parse_rbxl.py`**
(handles LZ4 chunks, zigzag ints, byte-interleaved arrays, Roblox floats, and all
PROP data types). All 415 Lua script sources were extracted to **`analysis/scripts/`**.

### What the place is
A player-run **booth / shop game** (the `Server` script in `ServerScriptService` is a
"Booth" economy + admin system, and `StarterGui/MainUI/Theguin` is its client — *"Original
booth system by ywinfe and thugshaker"*), bundled with the **ADONIS v2.2.5 admin
system**, a custom **nametag/tag system** ("handler by matt and fuz"), a map with trees,
a TV (video player), AFK system, and a few legacy gadgets (ClassicSword, TopbarPlus,
Server-Dex, F3X build tools, R6/R15 rigs).

---

## 2. TAG CONFIG — the custom nametag/chat-tag system

The place has a **fully custom tag system** split across 4 scripts plus a ServerStorage
GUI template:

### 2.1 `ReplicatedStorage/TagConfig` (ModuleScript, ref 13812) — **the tag definitions**

```lua
local TagConfig = {
    DefaultFont = Enum.Font.SourceSans,
    DefaultColor = Color3.fromRGB(255, 255, 255),
    ["verified"]  = { text = utf8.char(0xE000) .. " ", animated = false, animationStyle = "Wave", ... },
    ["premium"]   = { text = utf8.char(0xE001) .. " ", ... },
    ["robux"]     = { text = utf8.char(0xE002) .. " ", ... },
    ["plus"]      = { text = utf8.char(0xE003) .. " ", ... },
    ["owner"]     = { text = "[Owner] ",  animated = true, animationStyle = "Spin",    users = {49603, 78857, 181869} },
    ["developer"] = { text = "[Developer] ", animated = true, animationStyle = "Spin", users = {14159, 18205} },
    ["admin"]     = { text = "[Admin] ",  animated = true, animationStyle = "Shimmer", ... },
    ["mod"]       = { text = "[Mod] ",    animated = true, animationStyle = "Shimmer", ... },
    ["test"]      = { text = utf8.char(0xE005) .. " ", ... },
}
return TagConfig
```

| Tag key | Prefix text | Animation | Notes |
|---|---|---|---|
| `verified` | private-use glyph `U+E000` | Wave | icon tag |
| `premium` | `U+E001` | Wave | icon tag |
| `robux` | `U+E002` | Wave | icon tag |
| `plus` | `U+E003` | Wave | icon tag |
| `owner` | `[Owner]` | Spin | **hard-coded users: 49603, 78857, 181869** |
| `developer` | `[Developer]` | Spin | **hard-coded users: 14159, 18205** |
| `admin` | `[Admin]` | Shimmer | given via DataStore staff ranks |
| `mod` | `[Mod]` | Shimmer | given via DataStore staff ranks |
| `test` | `U+E005` | Wave | icon tag |

Commented-out (disabled) tag definitions also exist: `music`, `love`, `colossal`, `ice`,
`ghost`, `bounce`.

### 2.2 `ServerScriptService/TagHandler` (Script, ref 13766) — server-side tag giver

- "handler by matt and fuz".
- Loads a staff list from **DataStore `StaffList_v2`** (key `"staff"`), refreshed every
  **60 seconds**; entries are `UserId → {Rank = 1|2}`.
  - `RANK_MOD = 1` → tag `"mod"`, `RANK_ADMIN = 2` → tag `"admin"`.
- On `PlayerAdded` / `CharacterAdded`:
  - Disables the default nameplate (`Humanoid.DisplayDistanceType = None`).
  - Creates an **`Attachment` named `overhead`** on the character's `Head`
    at `CFrame.new(0, 1.7, 0)`, then clones the **`ServerStorage/overhead`
    BillboardGui** (a `TextLabel` named `name`) into it.
  - Applies the tag by reading `TagConfig[tag]`: sets the label's text
    (`config.text .. player.Name`), font, and color.
  - Sets attributes: `billboard:SetAttribute("TagType", tag)` and
    `player:SetAttribute("ActiveTag", tag)` (consumed by the client `Tags` script).
- Tag priority: DataStore staff rank first, then a scan of `TagConfig` for a `users`
  table containing `player.UserId` (i.e. the hard-coded `owner`/`developer` lists).
- **Commented-out chat command**: `player.Chatted` handler that would have applied
  tags via `.tag <name>` — disabled.

### 2.3 `StarterPlayerScripts/Tags` (LocalScript, ref 10396) — client-side tag FX

- "effects by matt and fuz" — runs every `RenderStepped`.
- For every `Attachment` named `overhead` in the workspace:
  - Reads `billboard:GetAttribute("TagType")` and animates the `name` label's
    `UIGradient` per the tag's `animationStyle`: **Wave, Shimmer, Spin, Slide, Pulse,
    Breath, Bounce** (with per-tag `speed`, `gradientRotation`, `gradientColors`,
    `pulseColorA/B`, `breathDim`).
- Occlusion system: raycasts from the camera to each tag (blacklist = all player
  characters), fades the label with distance (start 75, max 100 studs) and sets
  `BillboardGui.AlwaysOnTop = hit == nil` (nameplates hide behind walls).

### 2.4 `StarterPlayerScripts/VerifiedInChat` (LocalScript, ref 10394) — **chat tag**

- "verified chat tag". Hard-coded verified users: **`qzc`, `ywinfe`, `vxy`, `fuz`,
  `Thugshaker`**.
- Loads the default chat's `ChatService` (from `ServerScriptService:WaitForChild(
  "ChatServiceRunner")`) and on `SpeakerAdded` calls:

```lua
speaker:SetExtraData("Tags", { { TagText = VERIFIED_ICON } })  -- VERIFIED_ICON = utf8.char(0xE000)
```

### 2.5 `ServerScriptService/Server` (Script, ref 13767, ~116 KB) — staff rank tags

The main server script contains a "Staff tags" + "Chat tags" section:

- **Ranks**: `RANK_MOD`, `RANK_ADMIN`, `RANK_DEV`, `RANK_OWNER`, with colors:
  - `mod` → `Color3.fromRGB(130, 200, 255)` (light blue)
  - `admin` → `Color3.fromRGB(214, 170, 255)` (purple)
  - `dev` → `Color3.fromRGB(120, 235, 160)` (green)
  - `owner` → `Color3.fromRGB(255, 196, 92)` (gold)
- `SetStaffRank`/`Make Mod`/`Make Admin`/`Remove Staff` admin-panel commands write to
  the same rank state that drives the tags; `RefreshTagsFor(Player)` re-applies both
  tags on any rank change.
- **Chat tags** (`ApplyChatTag`, active): on `SpeakerAdded` via `ChatService`:

```lua
speaker:SetExtraData("Tags", { { TagText = RankLabel(rank), TagColor = RANK_COLOUR[rank] } })
speaker:SetExtraData("NameColor", RANK_COLOUR[rank])   -- name recolored to match
```

  Falls back gracefully: `"[Booth] Default chat not found, staff will have nametags
  but no chat tag."`
- **Nametag** (`ApplyStaffTag`, commented out in this save): would have built a
  `BillboardGui` on the Head at `StudsOffset(0, 3.4, 0)`, `AlwaysOnTop = false`,
  `MaxDistance = 60`, with a `[Rank]` `TextLabel` + black `UIStroke` (thickness 3).

### 2.6 Chat service configuration (engine instance)

| Property | Value |
|---|---|
| `Chat.LoadDefaultChat` | `true` |
| `Chat.BubbleChatEnabled` | `true` |
| `Chat.Tags` | **empty** (`""`) — no engine-level chat tag table |

Note: the place file does **not** contain a `ChatServiceRunner` instance — both
`VerifiedInChat` and `Server` wait/scan for it at runtime (default chat is loaded by
the engine because `LoadDefaultChat = true`).

---

## 3. CHAT TAG MENTIONS — summary of every `Tags`/chat-tag reference

| Where | What |
|---|---|
| `StarterPlayerScripts/VerifiedInChat` | `speaker:SetExtraData("Tags", {{TagText = VERIFIED_ICON}})` for qzc, ywinfe, vxy, fuz, Thugshaker |
| `ServerScriptService/Server` (ApplyChatTag) | `speaker:SetExtraData("Tags", {{TagText = RankLabel(rank), TagColor = ...}})` + `SetExtraData("NameColor", ...)` for staff ranks |
| `ServerScriptService/TagHandler` | commented-out `.tag <name>` chat command (`player.Chatted`) |
| `ServerScriptService/Server` | `ChatService:RegisterProcessCommandsFunction("BoothMute", ...)` — chat muting hook |
| ADONIS_v225 (`MainModule/Client/UI/Default|Aero|Unity/.../Chat`) | its own chat UI modules (admin system, not the tag system) |
| `Chat` service | `LoadDefaultChat = true`, `BubbleChatEnabled = true`, `Tags = ""` |

---

## 4. CollectionService TAGS (instance `Tags` property, NUL-separated)

The `Tags` property (CollectionService tags) is populated on a large number of parts:

| Tag | Count | Used on | Consumer in this file |
|---|---|---|---|
| `WindShake` | 1,570 | `Part`×1569, `MeshPart`×1 — tree foliage (`Map/Models/Tree2/Tree5/Folliage`, `Map/BaseParts`) | **none found** (dead tag — likely a removed wind-sway script) |
| `Ghost` | 81 | `Part`×75, `WedgePart`×4, `UnionOperation`×2 — map (`House/Walls`, `Window`, `BaseParts`, `Roof`) | **none found** (dead tag — likely a removed ghost-build/visibility system) |
| `Grass` | 20 | `Part`×20 — `Map/BaseParts` | **none found** (dead tag) |
| `ThreeDTextObject` | 2 | `Model`×2 (`Workspace/Model/ThreeDTextObject`) | none in-place (legacy 3D-text system) |
| `ThreeDTextObjectBoundingBox` | 2 | `Part`×2 (its bounding box) | same |
| `Item`, `Storable`, `Natural` | 1 each | `Model` — `Workspace/vxy/Burger` (player booth item) | no consumer in file (booth item DB system, likely driven by removed/external code) |
| `UIScaleRuntimeObject` | 1 | `UIScale` — `StarterGui/rma gui/UIScale` | engine-internal tag |

**Important**: no script in the place calls `CollectionService:GetTagged()` /
`HasTag()` for any of these — every non-engine CollectionService tag is *unused
leftover* in this save, while the *live* tag system is the custom `TagConfig`/
`TagHandler`/`Tags` stack described in §2.

---

## 5. Other notable findings

- **Attributes**: 49 instances carry a non-empty `AttributesSerialize` blob; **none**
  contain the strings "tag" or "chat". (The `TagHandler`/`Tags` scripts *set* runtime
  attributes `TagType` / `ActiveTag`, but those are not saved in the file.)
- **`ServerStorage/overhead`**: a `BillboardGui` (ref 13784) containing `TextLabel
  "name"` (ref 13785) — the cloned template used by `TagHandler` for nametags.
- **`VerifiedUsername`** (`ServerScriptService`, ref 13765): a separate script that
  appends the `U+E000` verified glyph to the **DisplayName** of the same five users
  (vxy, Thugshaker, qzc, ywinfe, fuz) — i.e. verified status is shown both as a
  chat tag and in the character nameplate.
- **Booth system**: `Workspace/vxy/Burger` (tagged `Item/Storable/Natural`) is a
  player booth item; `Server` handles `OwnedBooth` ObjectValues, booth resets, and
  gamepass shop state, mirrored by the `Theguin` client script.
- **Large scripts** (for reference): `Server` 115,975 B; `Theguin` 130,189 B;
  ADONIS's `RawApiJson` 465,748 B (Server-Dex property database); the `Server`
  script also contains the AFK/mute/ban/lock systems.
- **Map/place composition**: 7,478 Parts + 442 MeshParts + 132 UnionOperations, a
  `tv` with a video player, `Booths` in workspace, ADONIS_v225 in ServerScriptService,
  TopbarPlus in ReplicatedStorage, ClassicSword in both ServerStorage and
  ReplicatedStorage.

## 6. How to reproduce

```bash
# parse + validate the whole file
python3 tools/parse_rbxl.py "r69 (1).rbxl"

# full JSON dump (instances, classes, properties, sstr)
python3 tools/parse_rbxl.py "r69 (1).rbxl" --dump analysis/place_dump.json

# all script sources are in analysis/scripts/ (415 files, named refXXXXX_ClassName_Name.lua)
```
