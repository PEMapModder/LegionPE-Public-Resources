LegionPE Eta Plugin TODO List
===
- [ ] Authentication and session handling
  - [x] MySQL database for auth info
  - [x] Block player until he is authenticated
  - [x] Allow name grouping when registering, using `/GROUP` **[IMPLEMENTED, BUT COMMENTED OUT]**
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
  - [ ] Auto-kick AFK players (with DataPacketReceivedEvent)
- [ ] Games
  - [x] Hub
    - [x] Portals
	- [x] Inventory
  - [ ] KitPvP
    - [ ] `/stat`: kills, deaths, ratio
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
        - [ ] Alias `requests`
        - [ ] List
        - [ ] Warn if cannot accept
        - [ ] `/friend inbox deny <player>`
      - [ ] `/friend outbox`
        - [ ] Alias `pending`
        - [ ] List
        - [ ] `/friend outbox remove <player>`
      - [ ] Remind once rejoin KitPvP
  - [ ] Spleef
    - [ ] `/stat`: wins, loses, ratio
    - [ ] arena generation (100% code?)
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
A rank consists of two bytes (a bitmask of 16 bits), saved exactly in the MySQL database.

### Importance
The lower 4 bits are for how "important" the user is. That is, how much the user donated/helped to the server. A minimum of a "donator" always gets the 2nd bit, and a minimum of a "VIP" always gets the 1st bit. The lower 2 bits are for making the ranks more precise.

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
The 3rd quarter (4 bits of 16) of the bitmask is for the ranked permissions a user has.

(Accumulative permissions mean: if a rank has a permission, all ranks below it has that permission too)

| permission rank | bitmask | accumulative permissions |
| :---: | :---: | :---- |
| default | `0000` | all the basic things |
| moderator (mod) | `0001` | ability to mute, teleport, manage chat channels, process reports and issue warnings |
| admin (administrator) | `0011` | ability to see (and monitor) what moderators are doing, and resolve appeals |
| owner | `0111` | nothing special, just a special tag :P but well, absolute power |

### Extra Permissions
The 2nd quarter (4 bits of 16) of the bitmask defines the extra permissions the user has access to.

| name | bitmask | permissions |
| :---: | :---: | :---- |
| developer | `1000` | run PHP code directly |
| builder | `0100` | edit the world |

### Precise Permissions
The first 4 bits of the bitmask defines the precise permission rank of a user.

| name | bitmask | special permissions/exclusions |
| :---: | :---: | :---- |
| standard | `0000` | none |
| trial | `0001` | Trial mods cannot close reports. They can only read them and resolve them, and possibly add a "resolved" flag too, but there must be a user of a higher rank to confirm that the report is properly closed. |
| head | `0010` | none |
