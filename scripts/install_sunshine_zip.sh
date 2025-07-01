#!/usr/bin/env bash
set -euo pipefail

TMP="$(mktemp -d)"
echo ">>> Скачиваю последний universal ZIP"
ZIP_URL=$(curl -s https://api.github.com/repos/LizardByte/Sunshine/releases/latest \
  | grep -Eo 'https.*sunshine-macos.*universal.*zip')
curl -L "$ZIP_URL" -o "$TMP/sunshine.zip"

echo ">>> Распаковываю и перемещаю в /Applications"
unzip -q "$TMP/sunshine.zip" -d "$TMP"
mv -f "$TMP"/Sunshine.app /Applications/

echo ">>> Добавляю Sunshine в Login Items"
osascript - <<'OSA'
tell application "System Events"
  if (login item "Sunshine" exists) is false then
    make login item at end with properties {name:"Sunshine", path:"/Applications/Sunshine.app", hidden:true}
  end if
end tell
OSA

echo ">>> Запускаю Sunshine"
open -g -a /Applications/Sunshine.app

echo "=== DONE === Открой http://localhost:47990 в браузере, спарь Moonlight и добавь /Applications/Cursor.app"
