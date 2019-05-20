# TS3-mute-client
TS3 Lua plugin (muting a client by uid, supports hotkeys)

## Prerequisites
Make sure you have installed all of the following prerequisites on your machine:
* TS3 Client - [Download & Install TS3](https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/).
* Lua Plugin - [Download & Install TS3 Plugin](https://www.myteamspeak.com/addons/1ea680fd-dfd2-49ef-a259-74d27593b867).

## Setup
* Go to your Lua plugin directory (e.g. C:\Users\[your username]\AppData\Roaming\TS3Client\plugins\lua_plugin)
* Copy the clientmute folder into this directory.
* Start teamspeak and activate the Lua Plugin (Tools -> Options -> Addons -> My Addons -> Plugins -> Lua Plugin)
Hint: You must not be connected to a server otherwise the Lua plugin does not show up in the list
* Click on `Settings` and make sure the `muteclient` module is activated.
* Next go to Hotkey -> Add -> Advanced -> Plugins -> Run Plugin Command
* Enter `/lua run muteclient.muteByUid [uid]` where `[uid]` is the uid of the client you want to mute. (E.g. `/lua run muteclient.muteByUid HS96yTGyseRNgSfvJ7kGVK6yCYk=`)
* To get the uid of all clients on the current server, just run `/lua run muteclient.showClients`.
