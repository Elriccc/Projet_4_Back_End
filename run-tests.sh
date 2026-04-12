set -e

OUTPUT_DIR="test-results"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

NODE_REPORTS_DIR="reports"
GRADLE_REPORTS_DIR="build/test-results/test"

if [ -f "package-lock.json" ]; then
    npm test
    if [ -d "$NODE_REPORTS_DIR" ]; then
      cp -r "$NODE_REPORTS_DIR"/*.xml "$OUTPUT_DIR"/
      exit 0
    fi
    exit 1
fi

if [ -f "gradlew" ]; then
    chmod +x gradlew
    ./gradlew clean test
    if [ -d "$GRADLE_REPORTS_DIR" ]; then
      cp -r "$GRADLE_REPORTS_DIR"/*.xml "$OUTPUT_DIR"/
      exit 0
    fi
    exit 1
fi
exit 1