#!/usr/bin/env bash
set -euo pipefail

# ---------- 0. Проверяем CLT/Xcode версии ----------
echo ">>> Проверяю версию инструментов"
SDK_VER=$(xcrun --show-sdk-version 2>/dev/null || echo "0")
if [[ "${SDK_VER%%.*}" -lt 26 ]]; then
  echo ">>> Текущий SDK ${SDK_VER:-unknown} < 26 — ставлю Command-Line Tools 26"
  sudo rm -rf /Library/Developer/CommandLineTools || true
  softwareupdate --install --all --agree-to-license --verbose \
    || { echo ">>> Не удалось установить CLT 26 через softwareupdate"; exit 1; }
  sudo xcode-select --switch /Library/Developer/CommandLineTools
else
  echo ">>> CLT/Xcode уже ≥ 26, идём дальше"
fi

# ---------- 1. Обновляем Homebrew и deps ----------
brew update && brew upgrade

echo ">>> Чищу старые Sunshine"
brew uninstall --zap sunshine sunshine-beta || true
brew untap lizardbyte/homebrew || true
rm -rf "$(brew --cache)"/{sunshine*,miniupnpc*,nlohmann-json*}

echo ">>> Ставлю зависимости"
brew install cmake ninja pkg-config boost icu4c opus miniupnpc nlohmann-json

echo ">>> Добавляю tap и собираю Sunshine beta"
brew tap lizardbyte/homebrew
arch -arm64 brew install --build-from-source --verbose sunshine-beta \
  || { echo '>>> Ошибка сборки sunshine-beta'; exit 2; }

echo ">>> Запускаю Sunshine как сервис"
brew services start sunshine-beta

echo ">>> Открываю Web-GUI"
open http://localhost:47990

echo '=== DONE ==='
brew services list | grep sunshine
ipconfig getifaddr en0 || ipconfig getifaddr en1
