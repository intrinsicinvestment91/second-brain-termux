# second-brain-termux

100% local, zero-permissions daily journal → personality.json → talk to an AI mirror of yourself in any LLM (Grok, Claude, local Ollama, etc.).

- Offline forever
- No battery drain
- Gets smarter about YOU every day

## One-Command Install (Termux on Android)
1. Install Termux from F-Droid (not Play Store).
2. Run:
pkg update -y && pkg install -y python git pandoc weasyprint jq
pip install pandas jinja2 wordcloud matplotlib
git clone https://github.com/intrinsicinvestment91/second-brain-termux.git
cd second-brain-termux && bash setup.sh

## Usage
- `note` → daily journal (mood + multi-line reflection)
- `update_personality` → rebuild personality.json (weekly/monthly)
- `webme` → print prompt to copy into Grok/Claude (instant chat with yourself)
- `yearbook 2025` → generate printable PDF book on Jan 1

Test with demo data in `notes/demo`.

For desktop/Linux: Just clone and run the scripts manually (no Termux needed).

You now have a private second brain that will outlive every app.
