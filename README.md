# TCP Watcher

Monitors TCP connections on specific ports and sends notifications via Telegram when they happen. It also keeps a `notifications.log` file.

## Usage

`./tcp_watch.sh "Minecraft, 25565, 43200" "Tibia, 7171, 7200"`

Each argument is a quoted string:  
`"Label, Port, ExpiryInSeconds"`  
Example: Notify the same IP once every 12h for Minecraft, 2h for Tibia.

Check the `tcp_watcher.service` for a systemctl service example.  
And for logs: `sudo journalctl -u tcp_watcher.service -f`.

## Setup

1. Copy `.env.sample` to `.env` and fill in your Telegram bot token and chat ID:  
   `export TELEGRAM_BOT_TOKEN="your_token"`  
   `export TELEGRAM_BOT_CHAT_ID="your_chat_id"`
3. Load the environment:  
   `source .env` or `eval $(cat .env)`

## How to quickly create a Telegram bot and get the token and chat ID

1. Open Telegram and search for @BotFather.
2. Send `/start`, then `/newbot`.
3. Give it a name and a username (e.g., my_bot).
4. BotFather will give you a token string.

### Getting the chat ID

Open this URL in your browser (replace TOKEN):  
`https://api.telegram.org/bot<TOKEN>/getUpdates`

Send a message to your bot in Telegram. Then refresh the above URL and look for your chat object:
```
"chat": {
    "id": 123456789,
    ...
}
```

That's your chat ID.
