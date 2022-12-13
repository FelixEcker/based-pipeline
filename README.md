# based-pipeline
An utility to play the Andrew Tate theme song when the [ITT-Discord-Bot](https://gitlab.com/CommandCrafterHD/ITT-Discord-Bot)
recieves the `!based` command.

## The Based-Protocol
**Definitions** <br>
Alpha-Client: The Client which commands all other clients on when to "be based" <br>
bugattiserv: The Server distributing the Alpha-Client's commands <br>

**Basics**<br>
The Based-Protocol is a simple, TCP-Based protocol, designed specifically for the based-pipeline.
When a Client connects to the bugattiserv, it is expected to send a passphrase, if this matches the
bugattiserv's passphrase and there is no Alpha-Client already connected, this Client becomes the
Alpha Client.

**Be-Based**<br>
When the Alpha-Client sends the `b` command followed by a unix-timestamp, the Server will distribute
this message to all other Clients.  When a Client receives this message, they should schedule the
Andrew Tate theme to be played at the given timestamp.<br>
The Command should be formatted as follows:<br>
`b <unix-timestamp>`

## Server
A simple TCP-server written in Pascal to pass on the signal from the bot to the clients.

## Client
A simple TCP-client listening to the server and playing the sound.


