#!/bin/bash
# ============================================================
# INTEGRITY CHECK — Democratic ProFront National 1.0
# Verifies file checksums, detects tampering, logs attempts
# Installer ID: MEARVK LLC - Max Rupplin
# ============================================================
set -u

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
INTEGRITY_FILE="$PROJECT_DIR/.integrity.sha256"
LOG_FILE="$PROJECT_DIR/logging/integrity.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

mkdir -p "$PROJECT_DIR/logging"

echo "============================================================"
echo " INTEGRITY CHECK — Democratic ProFront National 1.0"
echo " $TIMESTAMP"
echo "============================================================"
echo ""

# Files to monitor for tampering
CRITICAL_FILES=(
    "source/ai/server/DemocraticAIServer.java"
    "source/ai/server/DemocraticHardServer.java"
    "source/ai/module/TaxDefenseSpeculator.java"
    "source/pro/national/ConnectionGuard.java"
    "source/pro/national/ConsentGate.java"
    "source/pro/national/EjectionFuture.java"
    "configuration/ai-module-config.xml"
    "configuration/server-config.xml"
    "configuration/database-config.xml"
    "configuration/nwe-config.xml"
    "sql/schema.sql"
    "sql/schema-update-ai.sql"
    "install.sh"
    "start.sh"
    "shutdown.sh"
    "test.sh"
)

# Generate current checksums
CURRENT_SUMS=""
MISSING=0
for FILE in "${CRITICAL_FILES[@]}"; do
    FULL="$PROJECT_DIR/$FILE"
    if [ -f "$FULL" ]; then
        SUM=$(sha256sum "$FULL" | awk '{print $1}')
        CURRENT_SUMS+="$SUM  $FILE"$'\n'
    else
        echo "  ⚠ MISSING: $FILE"
        MISSING=$((MISSING + 1))
    fi
done

# First run: create baseline
if [ ! -f "$INTEGRITY_FILE" ]; then
    echo "$CURRENT_SUMS" > "$INTEGRITY_FILE"
    echo "  Baseline created: $INTEGRITY_FILE (${#CRITICAL_FILES[@]} files)"
    echo "[$TIMESTAMP] BASELINE CREATED — ${#CRITICAL_FILES[@]} files" >> "$LOG_FILE"
    echo ""
    echo "  ✓ INTEGRITY BASELINE ESTABLISHED"
    exit 0
fi

# Compare against baseline
TAMPERED=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    EXPECTED_SUM=$(echo "$line" | awk '{print $1}')
    FILE_PATH=$(echo "$line" | awk '{print $2}')
    FULL="$PROJECT_DIR/$FILE_PATH"

    if [ ! -f "$FULL" ]; then
        echo "  ✗ DELETED: $FILE_PATH"
        echo "[$TIMESTAMP] TAMPER:DELETED $FILE_PATH" >> "$LOG_FILE"
        TAMPERED=$((TAMPERED + 1))
        continue
    fi

    ACTUAL_SUM=$(sha256sum "$FULL" | awk '{print $1}')
    if [ "$EXPECTED_SUM" != "$ACTUAL_SUM" ]; then
        echo "  ✗ MODIFIED: $FILE_PATH"
        echo "[$TIMESTAMP] TAMPER:MODIFIED $FILE_PATH expected=$EXPECTED_SUM actual=$ACTUAL_SUM" >> "$LOG_FILE"
        TAMPERED=$((TAMPERED + 1))
    else
        echo "  ✓ OK: $FILE_PATH"
    fi
done < "$INTEGRITY_FILE"

echo ""
if [ "$TAMPERED" -eq 0 ] && [ "$MISSING" -eq 0 ]; then
    echo "  ✓ INTEGRITY VERIFIED — no tampering detected"
    echo "[$TIMESTAMP] INTEGRITY OK" >> "$LOG_FILE"
else
    echo "  ✗ INTEGRITY VIOLATION — $TAMPERED file(s) tampered, $MISSING missing"
    echo "[$TIMESTAMP] VIOLATION tampered=$TAMPERED missing=$MISSING" >> "$LOG_FILE"
fi

echo ""
echo "  Log: $LOG_FILE"
exit $TAMPERED
