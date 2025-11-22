#!/bin/bash
# One-command setup for second-brain-termux (November 2025)

echo "🚀 Setting up second-brain-termux…"

# Install deps (Termux/Android only – skip on desktop)
if [ -d "/data/data/com.termux" ]; then
  pkg update -y
  pkg install -y python git pandoc weasyprint jq
  pip install pandas jinja2 wordcloud matplotlib
fi

# Create structure
BASE_DIR="$HOME/local_ai_assistant"
NOTES_DIR="$BASE_DIR/notes"
SCRIPTS_DIR="$BASE_DIR/scripts"
REFLECTIONS_DIR="$NOTES_DIR/reflections"

mkdir -p "$REFLECTIONS_DIR"
touch "$NOTES_DIR/reflections_archive.txt"
touch "$BASE_DIR/journal_$(date +%Y).txt"
touch "$NOTES_DIR/projects.txt"
touch "$BASE_DIR/personality.json"

# Copy scripts
cp scripts/* "$SCRIPTS_DIR/"
chmod +x "$SCRIPTS_DIR/"*

# Aliases
ALIAS_FILE="$HOME/.bashrc"
cat << 'ALIAS_EOF' >> "$ALIAS_FILE"

# second-brain-termux aliases
alias note='bash ~/local_ai_assistant/scripts/daily_note.sh'
alias update_personality='python ~/local_ai_assistant/scripts/load_personality.py && echo "✅ personality.json updated ($(wc -l < ~/local_ai_assistant/notes/reflections_archive.txt) days)"'
alias webme='echo ""; echo "Copy below into Grok/Claude/ChatGPT:"; echo "────────────────────────────────────"; cat ~/local_ai_assistant/personality.json | jq -r .system_prompt 2>/dev/null || python -c "import json; print(json.load(open(\"~/local_ai_assistant/personality.json\"))[\"system_prompt\"])"; echo "────────────────────────────────────"'
alias yearbook='python ~/local_ai_assistant/scripts/make_year_book.py'
ALIAS_EOF
source "$ALIAS_FILE"

# Optional widget (Termux only)
if [ -d "/data/data/com.termux" ]; then
  pkg install -y termux-widget
  mkdir -p ~/.termux/tasker
  echo "#!/bin/bash" > ~/.termux/tasker/daily_note.task
  echo "bash ~/local_ai_assistant/scripts/daily_note.sh" >> ~/.termux/tasker/daily_note.task
  chmod +x ~/.termux/tasker/daily_note.task
  echo "Add Termux:Widget to homescreen → select daily_note.task"
fi

echo "✅ Setup complete!"
echo "Type 'note' to start."
