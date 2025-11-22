#!/bin/bash
# Final enhanced daily reflection (multi-line, archive, journal – November 2025)

NOTE_DIR="$HOME/local_ai_assistant/notes/reflections"
ARCHIVE="$HOME/local_ai_assistant/notes/reflections_archive.txt"
JOURNAL="$HOME/local_ai_assistant/journal_$(date +%Y).txt"
mkdir -p "$NOTE_DIR"

NOTE_FILE="$NOTE_DIR/$(date +%Y-%m-%d).txt"

DATE=$(date --iso-8601=seconds)
UPTIME=$(uptime -p 2>/dev/null || echo "unknown")
CWD=$(pwd)

{
  echo "==================================="
  echo "Date: $DATE"
  echo "Uptime: $UPTIME"
  echo "Location/context: $CWD"
  echo ""
} > "$NOTE_FILE"

echo "One-word mood (e.g. calm, drained, electric): "
read MOOD
echo "Mood: $MOOD" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"

echo "Quick reflection (write freely, press Enter then Ctrl-D when done):"
cat >> "$NOTE_FILE"

# One-line archive (for LLM training)
echo "$(date +%Y-%m-%d) | $MOOD | $(tail -n +7 "$NOTE_FILE" | tr '\n' ' ' | sed 's/ $//')" >> "$ARCHIVE"

# Yearly journal
cat "$NOTE_FILE" >> "$JOURNAL"
echo -e "\n\n" >> "$JOURNAL"

echo "✅ Saved → $NOTE_FILE"
echo "   Archive → $ARCHIVE"
echo "   Journal → $JOURNAL"
