#!/usr/bin/env bash
set -euo pipefail

echo ">>> Проверяю Homebrew…"
if ! command -v brew &>/dev/null; then
  echo ">>> Homebrew нет — ставлю:"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo ">>> Добавляю tap LizardByte"
brew tap lizardbyte/homebrew

echo ">>> Ставлю Sunshine (stable cask)"
brew install --cask sunshine

echo ">>> Запускаю Sunshine как сервис"
brew services start sunshine

echo ">>> Готово! Открой http://localhost:47990 в браузере."
echo "1) Разреши «Screen Recording» и «Accessibility» при первом старте."
echo "2) В web-GUI Sunshine (Applications) нажми ➕ и добавь /Applications/Cursor.app."
echo "3) На iPhone запусти Moonlight, выбери Mac и введи PIN."
