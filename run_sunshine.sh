#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  run_sunshine.sh  – Zero-click builder/launcher for Sunshine on macOS
# -----------------------------------------------------------------------------
# 1. Locates the project directory automatically (directory where this script
#    resides) so you can run it from anywhere.
# 2. Generates the Xcode build (Release) if it does not exist.
# 3. Compiles Sunshine (via `cmake --build …`).
# 4. Starts Sunshine with sensible defaults and opens the Web UI.
# -----------------------------------------------------------------------------
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/Sunshine"
BUILD_DIR="$PROJECT_DIR/build_xcode"
# first argument optional build type
CONFIG="Debug"
if [[ $# -gt 0 && ! $1 == -* ]]; then
  CONFIG="$1"
  shift
fi

# Remaining cli args forwarded to CMake generation step (e.g. -DWEB_UI=OFF)
EXTRA_CMAKE_ARGS=("$@")

BINARY="$BUILD_DIR/$CONFIG/sunshine"
CMAKE_FLAGS=(
  -G "Xcode"
  -DCMAKE_OSX_ARCHITECTURES=arm64
  "-DOPENSSL_ROOT_DIR=$(brew --prefix openssl)"
  "-DCMAKE_PREFIX_PATH=$(brew --prefix qt@6)"
  -DBUILD_TESTS=OFF
  -DBUILD_DOCS=OFF
)

printf "\n🌞  Sunshine helper script\n"
printf "📁 Project dir : %s\n" "$PROJECT_DIR"
printf "🛠  Build dir   : %s (%s)\n" "$BUILD_DIR" "$CONFIG"
echo "Usage: ./run_sunshine.sh [Debug|Release] [additional -D CMake args]"
echo "Example: ./run_sunshine.sh Release -DWEB_UI=OFF"

# -----------------------------------------------------------------------------
# Step 1. Generate Xcode project if missing
# -----------------------------------------------------------------------------
if [[ ! -d "$BUILD_DIR" || ! -f "$BUILD_DIR/build.ninja" && ! -f "$BUILD_DIR/compile_commands.json" ]]; then
  printf "🔧 Generating Xcode project…\n"
  cmake -S "$PROJECT_DIR" -B "$BUILD_DIR" "${CMAKE_FLAGS[@]}" ${EXTRA_CMAKE_ARGS[@]+"${EXTRA_CMAKE_ARGS[@]}"}
fi

# -----------------------------------------------------------------------------
# Step 2. Build if binary missing
# -----------------------------------------------------------------------------
if [[ ! -x "$BINARY" ]]; then
  printf "⚙️  Building Sunshine (%s)… this might take a while.\n" "$CONFIG"
  cmake --build "$BUILD_DIR" --config "$CONFIG" --target sunshine -- -quiet
fi

# Verify binary
if [[ ! -x "$BINARY" ]]; then
  echo "❌ Build failed – binary not found: $BINARY" >&2
  exit 1
fi

# -----------------------------------------------------------------------------
# Step 3. Launch
# -----------------------------------------------------------------------------
# Kill previous instance, ignore error if not running
killall sunshine 2>/dev/null || true
printf "🚀 Launching Sunshine…\n\n"
cd "$PROJECT_DIR"
"$BINARY" &
SUN_PID=$!

sleep 4  # give server time to start
if ps -p "$SUN_PID" >/dev/null; then
  echo "✅ Sunshine is running (PID $SUN_PID)"
  echo "🌐 Opening https://localhost:47990 …"
  open "https://localhost:47990"
  echo "Press Ctrl+C to stop."
  wait "$SUN_PID"
else
  echo "❌ Sunshine exited prematurely." >&2
  exit 1
fi 