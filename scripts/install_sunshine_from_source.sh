#!/usr/bin/env bash
set -euo pipefail

echo ">>> 0. Обновляю Homebrew и инструменты"
brew update && brew upgrade
if ! xcode-select -p &>/dev/null; then
  echo ">>> Ставлю Xcode Command Line Tools"
  xcode-select --install
fi

echo ">>> 1. Чищу прошлые попытки Sunshine"
brew uninstall --zap sunshine sunshine-beta || true
brew untap lizardbyte/homebrew || true
rm -rf "$(brew --cache)"/{sunshine*,miniupnpc*,nlohmann-json*}

echo ">>> 2. Ставлю нужные зависимости"
brew install cmake ninja pkg-config boost icu4c opus miniupnpc nlohmann-json

echo ">>> 3. Добавляю tap и собираю beta-ветку"
brew tap lizardbyte/homebrew
# arm64 — чтобы сборка точно шла нативно, без Rosetta
arch -arm64 brew install --build-from-source --verbose sunshine-beta || BUILDERR=$?

if [[ -n "${BUILDERR:-}" ]]; then
  echo ">>> Основная сборка упала (код $BUILDERR) — пробую без web-ui"
  export SUNSHINE_SKIP_WEB_UI=1
  arch -arm64 brew reinstall --build-from-source --verbose sunshine-beta
fi

echo ">>> 4. Запускаю Sunshine как сервис"
brew services start sunshine-beta

echo ">>> 5. Открываю Web-GUI"
open http://localhost:47990

echo "=== DONE ==="
brew services list | grep sunshine
