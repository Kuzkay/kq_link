# KQ_LINK – Fixes Applied

This document describes each change made to the kq_link resource: **what** was fixed, **how** it was fixed, and **why**.

---

## 1. GetNearbyPlayerInteractions returning nil (Critical)

**File:** `resource/interactions/client/client.lua`

**What:** When any entry in `PLAYER_INTERACTIONS` was `nil` (e.g. after an interaction was deleted), the loop did `return` with no value. The cache then returned `nil`, so callers could assign `nil` to `NEARBY_INTERACTIONS` and then run `#NEARBY_INTERACTIONS`, causing a runtime error.

**How:** Replaced the early `return` with `goto continue` and added a `::continue::` label at the end of the loop so that nil entries are skipped and the function always returns a table (possibly empty).

**Why:** Nil entries can exist after `Delete()` sets `PLAYER_INTERACTIONS[key] = nil`. The main loop must always receive a table so that `#NEARBY_INTERACTIONS` and iteration are safe.

---

## 2. CanPlayerAfford crash when player is nil (Critical)

**File:** `links/frameworks/qbcore/server.lua`

**What:** `CanPlayerAfford(player, amount)` did not check if `QBCore.Functions.GetPlayer(player)` returned `nil`. When the player was offline or invalid, `xPlayer.Functions.GetMoney(...)` caused an error.

**How:** Added `if not xPlayer then return false end` immediately after getting `xPlayer`.

**Why:** Exports can be called with invalid or offline player IDs. Returning `false` is the correct behavior and avoids a server crash.

---

## 3. Invalid minZ/maxZ in target zone (Critical)

**File:** `resource/interactions/client/target.lua`

**What:** In the generic (non–ox-target, non–qb-target) branch of `InputUtils.AddZoneToTargeting`, `minZ` and `maxZ` were set with `coords - (scale.z / 2)` and `coords + (scale.z / 2)`. In Lua/FiveM, `vector3 ± number` is not valid; only numeric Z values are correct for zone options.

**How:** Changed to `minZ = coords.z - (scale.z / 2)` and `maxZ = coords.z + (scale.z / 2)`.

**Why:** Zone systems expect numeric Z bounds. Using the vector in arithmetic could error or produce wrong behavior; using `coords.z` is correct and portable.

---

## 4. Dispatch standalone crash when data.blip is nil (Critical)

**File:** `links/dispatch/client/standalone.lua`

**What:** `SendDispatchMessage(data)` built a `blip` table from `data.blip.sprite`, `data.blip.color`, etc. When `data` or `data.blip` was missing, this caused a nil index error.

**How:** Normalized input with `data = data or {}` and `local blip = data.blip or {}`, then used `blip.sprite or 58`, `blip.color or 1`, etc., so all blip fields have safe defaults.

**Why:** Callers may omit `data` or `data.blip`. Providing defaults keeps the standalone dispatch usable and avoids client crashes.

---

## 5. Callback error print when ret[2] is nil (Critical)

**File:** `resource/callbacks/client.lua`

**What:** On callback failure, the code did `print('^1' .. ret[2], 2)`. When the server sent no message, `ret[2]` was `nil`, and `'^1' .. nil` errors in Lua.

**How:** Replaced with `print('^1[kq_link] Callback error: ' .. tostring(ret[2] or 'unknown'))` so the message is always a string.

**Why:** Error reporting must not throw a second error. Using `tostring(ret[2] or 'unknown')` guarantees a valid string and avoids a crash when logging callback failures.

---

## 6. DetectAndSetNotifications setting standalone inside loop (Moderate)

**File:** `links/frameworks/shared.lua`

**What:** `Link.notifications = 'standalone'` was inside the `for` loop, so it ran on every non-matching resource instead of only when no notification system was found.

**How:** Removed the assignment from inside the loop and added a single `Link.notifications = 'standalone'` after the loop.

**Why:** The fallback should run only once when no configured notification resource is started. This keeps behavior correct and makes the logic clear for future changes.

---

## 7. gs-notify using nil source on client (Moderate)

**File:** `links/notifications/client/client.lua`

**What:** For gs-notify, the code used `source` as the first argument. On the client, `source` is only set in server-triggered event handlers; when `Notify()` is called from other client code, `source` can be `nil`.

**How:** Replaced `source` with `GetPlayerServerId(PlayerId())` so the local player’s server ID is always passed.

**Why:** gs-notify expects a valid player server ID. Using the local player’s ID ensures client-side calls work whether triggered by the server or by other client scripts.

---

## 8. math.randomseed with string in HoldSequenceMinigame (Moderate)

**File:** `resource/minigames/slowSequence.lua`

**What:** The code used `math.randomseed(seed .. currentStep[1])`. Both values are numbers, so `..` produced a string. `math.randomseed()` expects a numeric seed; passing a string is not portable and can behave incorrectly.

**How:** Changed to `math.randomseed(seed + currentStep[1])` so the seed is always a number.

**Why:** Correct and portable use of `math.randomseed` requires a numeric argument. A numeric expression keeps the boost position logic deterministic and valid across Lua versions.

---

## 9. Redundant Link = {} in config (Minor)

**File:** `config.lua`

**What:** The first line was `Link = {}`, and a few lines later `Link` was reassigned to the full config table. The first assignment had no effect.

**How:** Removed the initial `Link = {}` line.

**Why:** Reduces confusion and makes it clear that the real config is the single `Link = { ... }` table.

---

## 10. Inventory auto-detect and documentation (Minor)

**Files:** `links/frameworks/shared.lua`, `config.lua`, `resource/client.lua`

**What:** Auto-detect for inventory did not include tgiann-inventory, origen_inventory, or jaksam_inventory, even though they are supported when set manually. Config did not document the `qb-inventory` option used in the QBCore server script. `resource/client.lua` was empty with no explanation.

**How:**
- In `links/frameworks/shared.lua`, added to the inventory auto-detect table: `['tgiann-inventory'] = 'tgiann-inventory'`, `['origen_inventory'] = 'origen_inventory'`, `['jaksam_inventory'] = 'jaksam_inventory'`.
- In `config.lua`, added a comment that `'qb-inventory'` is the QBCore default inventory option.
- In `resource/client.lua`, added a short comment that the file is a placeholder and that client logic lives in links and interactions.

**Why:** Auto-detect now matches the documented inventory options. Documenting `qb-inventory` aligns config comments with code. The client placeholder comment clarifies intent for maintainers.

---

## Summary

| # | Severity  | File(s) | Issue |
|---|-----------|---------|--------|
| 1 | Critical  | interactions/client/client.lua | Nil return from GetNearbyPlayerInteractions |
| 2 | Critical  | frameworks/qbcore/server.lua | CanPlayerAfford nil xPlayer |
| 3 | Critical  | interactions/client/target.lua | Invalid minZ/maxZ (vector ± number) |
| 4 | Critical  | dispatch/client/standalone.lua | data.blip nil access |
| 5 | Critical  | callbacks/client.lua | print with nil ret[2] |
| 6 | Moderate  | frameworks/shared.lua | Notifications standalone inside loop |
| 7 | Moderate  | notifications/client/client.lua | gs-notify source nil on client |
| 8 | Moderate  | minigames/slowSequence.lua | math.randomseed string argument |
| 9 | Minor     | config.lua | Redundant Link = {} |
| 10| Minor     | frameworks/shared.lua, config.lua, resource/client.lua | Auto-detect + docs + placeholder comment |

**Note:** The fxmanifest line `'@qbx_core/modules/playerdata.lua'` was not changed. It is a hard dependency for client scripts when that path is loaded. If you do not use QBox, remove or comment out that line in `fxmanifest.lua` so the resource can start without qbx_core.
