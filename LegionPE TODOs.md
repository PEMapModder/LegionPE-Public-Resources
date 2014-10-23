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
- [ ] Games
  - [x] Hub
    - [x] Portals
	- [x] Inventory
  - [ ] KitPvP
    - [ ] `/stat`: kills, deaths, ratio
    - [ ] `/team`
  - [ ] Spleef
    - [ ] `/stat`: wins, loses, ratio
    - [ ] arena generation (100% code?)
  - [ ] Infected
    - [ ] Waiting for @Lambo16
  - [ ] Parkour
    - [ ] Checkpoints
    - [ ] Teleport when fallen
	- [ ] Victory reward
- [ ] Chat handling
  - [x] Subscribe to (read chat messages from) chat channels
  - [x] Update chat channels when changing sessions
  - [x] Mandatory chat channel
  - [ ] Chat moderation
    - [x] Operators: free channels switching
    - [ ] Spam detection
    - [ ] Bad word filtering
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
      - [ ] rules
      - [ ] ranks
      - [ ] staffs
      - [ ] games
        - [ ] KitPvP
        - [ ] Spleef
        - [ ] Parkour
        - [ ] Infected
  - [ ] /quit (alias /hub)
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
| donator | `0100` | $2.5 |
| donator + | `0101` | $5 |
| VIP | `1100` | $10 |
| VIP + | `1101` | $15 |
| VIP * | `1110` | ? |

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
