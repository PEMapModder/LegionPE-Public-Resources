LegionPE Eta Plugin TODO List
===
Abbreviations used in this list:
* _`R.F.C.` Request for Comments_: Everyone is welcome to submit comments about it, but we reserve the final decision. The whole list is looking for comments, but those tagged with `R.F.C.` are especially looking for community comment. Note that these are not votes, different from normal RFCs.
* _`L.P.`: Low Priority_: The item is of low priority. It may noy be done when the server is first released.

- [ ] Authentication and session handling
  - [x] MySQL database for auth info
  - [x] Block player until he is authenticated
  - [x] `R.F.C.` Allow name grouping when registering `IMPLEMENTED, BUT COMMENTED OUT`
  - [x] Block chat as password input panel
  - [x] Require information from player when registering
    - [x] Password
    - [x] Repeat password and check if matches
    - [x] IP options
  - [ ] `/auth`
  - [x] Disallow speaking password out in chat
  - [x] IP authentication
  - [x] Monitor player sessions
    - [x] Update authentication sessions
    - [x] Update in-game sessions
    - [x] Update sessions when an operator switched worlds
  - [x] Auto-kick AFK players
- [ ] Games
  - [x] Hub
    - [x] Portals
    - [ ] Inventory
  - [ ] KitPvP
    - [x] `/stat`: kills, deaths, ratio
      - [x] `/stat top [rows]`
        - [x] MySQL query once only!
        - [x] Display kills, deaths, player name and K/D ratio
    - [ ] `/team`
    - [ ] `/friend`
      - setup MySQL table `kitpvp_friends`
      - [x] `/friend` help message
      - [x] `/friend add`
        - [x] Send friend requests
        - [x] Accept requests
        - [x] Check maximum number of friends
      - [ ] `/friend remove`
        - [ ] Update both sides
      - [ ] `/friend list`
        - [ ] Fetch from MySQL table (remember to fetch from both `smalluid` and `largeuid` columns)
        - [ ] Maximum friends
        - [ ] Whether they are online
      - [ ] `/friend inbox`
        - [x] Alias `requests`
        - [x] List
        - [ ] Warn if cannot accept
        - [x] ~~`/friend inbox deny <player>`~~ (replaced by `/friend remove`)
      - [ ] `/friend outbox`
        - [x] Alias `pending`
        - [ ] List
        - [ ] ~~`/friend outbox remove <player>`~~ (replaced by `/friend remove`)
      - [ ] Remind once rejoin KitPvP
    - [ ] `L.P.` Teams support
      - [ ] Same team should not kill each other
    - [ ] `R.F.C.` Throw eggs for splash healing potion?
      - [ ] Only for members of the same team?
  - [ ] Spleef
    - [ ] `/stat`: wins, loses, ratio
    - [ ] arena generation (100% code?)
    - [ ] Auto-queue players to join arenas
    - [ ] Teleport players to arena top, each player distant from one another
    - [ ] Allow spectators
    - [ ] Possibly generate random holes
    - [ ] Support multi-floor
    - [ ] Detect player falling (losing)
    - [ ] `L.P.` If players surviving are all of the same team, end game.
    - [ ] `L.P.` Count points with floors instead of wins and loses.
  - [ ] Infected
    - [ ] Waiting for @Lambo16
  - [ ] Parkour
    - [ ] Checkpoints
    - [ ] Teleport when fallen
	- [ ] Victory reward
- [ ] Teams
  - [ ] `/team`
    - [ ] Database setup
    - [ ] `/team create`
      - [ ] Permission check (@Lambo16 why limit to owners and donators?)
      - [ ] Validate name
      - [ ] Create team
    - [ ] `/team add`
      - [ ] Send invitation
    - [ ] `/team join`
      - [ ] Accept invitation
    - [ ] `/team kick`
    - [ ] `/team mod` make player moderator inside team
    - [ ] `/team view`
      - [ ] team stats from all games
    - [ ] `/team leave`
    - [ ] `/team requests`
    - [ ] team channel setup
- [ ] Chat handling
  - [x] Subscribe to (read chat messages from) chat channels
  - [x] Update chat channels when changing sessions
  - [x] Mandatory chat channel
  - [ ] Chat moderation
    - [x] Operators: free channels switching
    - [ ] Spam detection
    - [x] Bad word filtering
- [ ] Commands
  - [x] /chat on|off
  - [x] /chat color|decolor
  - [x] /channel
    - [x] /channel join
    - [x] /channel quit
    - [x] /channel switch
  - [x] /eval (dangerous, must-log)
  - [x] /ignore <player>
  - [x] /mute <player> [unmute time = 15 (minutes)]
  - [x] /unmute <player>
  - [ ] /info [<game>|rules|ranks|staffs]
    - [x] Sending info (_need better sending_)
    - [ ] Info writing
      - [x] rules
      - [x] ranks
      - [x] staffs
      - [ ] games
        - [ ] KitPvP
        - [ ] Spleef
        - [ ] Parkour
        - [ ] Infected
  - [ ] `/quit` (alias `/hub`)
- [ ] Provide data to MySQL server for website
  - [ ] Server/Games average number of players (per 30 minutes)
- [ ] Emergency maintenance HTTP server
  - [x] Socket creation
  - [ ] Webpages
    - [ ] MySQL database query
    - [ ] Server status
- [ ] **_External Public Plugin:_** [SpicyCapacitor](https://github.com/PEMapModder/Small-ZC-Plugins/tree/master/SpicyCapacitor): An operator's favourite plugin


===
## Ranks
A rank consists of three bytes (a bitmask of 24 bits), saved exactly in the MySQL database. Counting from left to right, from bit 0 to bit 23, the ranks are saved in the database like this:

### Importance
Bits 20-23 are for how "important" the user is. That is, how much the user donated/helped to the server. A minimum of a "donator" always gets true in bit 21, and a minimum of a "VIP" always gets the 1st bit. Bits 22-23 are for making the ranks more precise.

| importance | bitmask | requirements |
| :---: | :---: | :---- |
| default | `0000` | none |
| tester | `0001` | be a tester |
| donator | `0100` | donate $2.5 |
| donator + | `0101` | donate $5 |
| VIP | `1100` | donate $10 |
| VIP + | `1101` | donate $15 |
| VIP * | `1110` | donate $20 |

### Ranked Permission
Bits 16-19 of the bitmask is for the ranked permissions a user has.

(Accumulative permissions mean: if a rank has a permission, all ranks below it has that permission too)

| permission rank | bitmask | accumulative permissions |
| :---: | :---: | :---- |
| default | `0000` | all the basic things |
| moderator (mod) | `0001` | ability to mute, teleport, manage chat channels, process reports and issue warnings |
| admin (administrator) | `0011` | ability to see (and monitor) what moderators are doing, and resolve appeals |
| owner | `0111` | nothing special, just a special tag :P but well, absolute power |

### Extra Permissions
Bits 12-15 of the bitmask defines the extra permissions the user has access to.

| name | bitmask | permissions |
| :---: | :---: | :---- |
| developer | `1000` | run PHP code directly |
| builder | `0100` | edit the world |

### Precise Permissions
Bits 8-11 of the bitmask defines the precise permission rank of a user.

| name | bitmask | special permissions/exclusions |
| :---: | :---: | :---- |
| standard | `0000` | none |
| trial | `0001` | Trial mods cannot close reports. They can only read them and resolve them, and possibly add a "resolved" flag too, but there must be a user of a higher rank to confirm that the report is properly closed. |
| head | `0010` | none |

### Team capacity
If this user creates a team, the team's capacity is represented by bits 4-7 as a nibble, allowing values from 0 to 15. The default is 3.

===
Therefore, the default value of a rank is 0x00030000.
