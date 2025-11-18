#!/data/data/com.termux/files/usr/bin/bash
# Minimal daily reflection script (no Android permissions needed)

NOTE_DIR="$HOME/local_ai_assistant/notes/reflections"
mkdir -p "$NOTE_DIR"
NOTE_FILE="$NOTE_DIR/$(date +%Y-%m-%d).txt"

DATE=$(date --iso-8601=seconds)
UPTIME=$(uptime -p 2>/dev/null || echo "unknown")
CWD=$(pwd)

{
  echo "-----------------------------------"
  echo "📅 Date: $DATE"
  echo "💻 Uptime: $UPTIME"
  echo "📂 Directory: $CWD"
  echo ""
} >> "$NOTE_FILE"

echo -n "Mood (1 word): "
read MOOD
echo "🙂 Mood: $MOOD" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"

echo -n "Reflection: "
read ENTRY
echo "$ENTRY" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"

echo "✅ Saved to $NOTE_FILE"
