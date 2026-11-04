#!/usr/bin/env sh
# Minimal Gradle launcher for CI builders that require a gradlew file.
set -eu
GRADLE_VERSION="8.9"
BASE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
GRADLE_HOME_BASE="${GRADLE_USER_HOME:-$HOME/.gradle}/aerovista-distributions"
GRADLE_HOME="$GRADLE_HOME_BASE/gradle-$GRADLE_VERSION"
if [ ! -x "$GRADLE_HOME/bin/gradle" ]; then
  mkdir -p "$GRADLE_HOME_BASE"
  ARCHIVE="$GRADLE_HOME_BASE/gradle-$GRADLE_VERSION-bin.zip"
  if [ ! -f "$ARCHIVE" ]; then
    if command -v curl >/dev/null 2>&1; then
      curl -fL --retry 3 "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip" -o "$ARCHIVE"
    elif command -v wget >/dev/null 2>&1; then
      wget -O "$ARCHIVE" "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
    else
      echo "ERROR: curl or wget is required to download Gradle." >&2; exit 1
    fi
  fi
  unzip -q -o "$ARCHIVE" -d "$GRADLE_HOME_BASE"
fi
exec "$GRADLE_HOME/bin/gradle" -p "$BASE_DIR" "$@"
