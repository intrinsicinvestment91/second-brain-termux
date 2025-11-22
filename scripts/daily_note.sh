#!/bin/bash
# Final enhanced daily reflection (multi-line, archive, journal – November 2025)
# With all improvements: mood trim, weather prompt, journal in notes/, empty check, platform tweaks

NOTE_DIR="$HOME/local_ai_assistant/notes/reflections"
ARCHIVE="$HOME/local_ai_assistant/notes/reflections_archive.txt"
JOURNAL="$HOME/local_ai_assistant/notes/journal_$(date +%Y).txt"
mkdir -p "$NOTE_DIR"

NOTE_FILE="$NOTE_DIR/$(date +%Y-%m-%d).txt"

DATE=$(date --iso-8601=seconds)
UPTIME=$(uptime -p 2>/dev/null || echo "unknown")
CWD=$(pwd)

# Platform-aware tweaks
if ! command -v uptime >/dev/null; then
  UPTIME="unknown (non-Linux platform)"
fi
if [ ! -d "/data/data/com.termux" ]; then
  echo "Note: Running on non-Termux platform – some features (e.g., widgets) skipped."
fi

{
  echo "==================================="
  echo "Date: $DATE"
  echo "Uptime: $UPTIME"
  echo "Location/context: $CWD"
  echo ""
} > "$NOTE_FILE"

# Optional weather/context
echo "Optional weather/context (e.g., rainy 15C, or skip with Enter): "
read WEATHER
echo "Weather/context: $WEATHER" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"

# One-word mood with trim
echo "One-word mood (e.g. calm, drained, electric): "
read MOOD_INPUT

MOOD=$(echo "$MOOD_INPUT" | awk '{print $1}')  # Trim to first word

if [ "$MOOD" != "$MOOD_INPUT" ]; then
  echo "Note: Trimmed mood to first word '$MOOD' for consistency."
fi

echo "Mood: $MOOD" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"

# Reflection input
echo "Quick reflection (write freely, press Enter then Ctrl-D when done):"
cat >> "$NOTE_FILE"

# Corrected empty check: strip header + blank lines
REFLECTION_TEXT=$(tail -n +7 "$NOTE_FILE" | sed '/^\s*$/d')

if [ -z "$REFLECTION_TEXT" ]; then
  echo "No reflection entered – skipping save."
  rm -f "$NOTE_FILE"
  exit 0
fi

# One-line archive
echo "$(date +%Y-%m-%d) | $MOOD | $WEATHER | $REFLECTION_TEXT" >> "$ARCHIVE"

# Yearly journal
cat "$NOTE_FILE" >> "$JOURNAL"
echo -e "\n\n" >> "$JOURNAL"

echo "✅ Saved → $NOTE_FILE"
echo "   Archive → $ARCHIVE"
echo "   Journal → $JOURNAL"
