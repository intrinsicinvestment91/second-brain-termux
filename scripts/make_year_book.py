#!/usr/bin/env python3
"""
One-command end-of-year book generator
Run on Dec 31 or Jan 1 → get a print-ready PDF in 3–8 minutes
Tested daily on Android + Termux since 2023
"""
import os
import re
import sys
from datetime import datetime
from collections import Counter
import matplotlib.pyplot as plt
from wordcloud import WordCloud
import pandas as pd
from jinja2 import Template

# ───────────────────────────── CONFIG ─────────────────────────────
YEAR = int(sys.argv[1]) if len(sys.argv) > 1 else datetime.now().year
HOME = os.path.expanduser("~")
BASE = f"{HOME}/local_ai_assistant/notes"
JOURNAL_FILE = f"{BASE}/journal_{YEAR}.txt"
ARCHIVE_FILE = f"{BASE}/reflections_archive.txt"
OUTPUT_PDF = f"{HOME}/{YEAR}_My_Year.pdf"

# Install once: pkg install pandoc weasyprint python && pip install pandas jinja2 wordcloud matplotlib
# ──────────────────────────────────────────────────────────────────

entries = []
moods = []
dates = []
all_text = ""

print(f"📚 Building {YEAR} book…")

# Parse the big yearly journal (human-readable, has separators)
if os.path.exists(JOURNAL_FILE):
    with open(JOURNAL_FILE) as f:
        content = f.read()
    # Split by the === separator your daily_note.sh uses
    days = re.split(r"={10,}", content)
    for day in days:
        if not day.strip():
            continue
        lines = day.strip().splitlines()
        if not lines:
            continue
        date_line = lines[0]
        date_match = re.search(r"\d{4}-\d{2}-\d{2}", date_line)
        if not date_match:
            continue
        date = date_match.group(0)
        mood = "unknown"
        text = []
        for line in lines[1:]:
            if line.startswith("Mood:"):
                mood = line.split(":", 1)[1].strip().split()[0].lower()
            elif line.strip() and not line.startswith(("Date:", "Uptime:", "Location:")):
                text.append(line.strip())
        full_text = " ".join(text)
        entries.append({"date": date, "mood": mood, "text": "\n".join(text), "raw": full_text})
        moods.append(mood)
        dates.append(date)
        all_text += " " + full_text

# Mood statistics
mood_counter = Counter(moods)
top_moods = mood_counter.most_common(10)

# Word cloud + stats
words = re.findall(r"\b\w+\b", all_text.lower())
common_words = [w for w in Counter(words).most_common(300) if len(w[0]) > 4]
wordcloud = WordCloud(width=1200, height=800, background_color="white", colormap="viridis").generate_from_frequencies(dict(common_words[:100]))

# Heat-map calendar
df = pd.DataFrame(entries)
df['date'] = pd.to_datetime(df['date'])
df = df.set_index('date')
calendar_data = df.resample('D').size().reindex(pd.date_range(f"{YEAR}-01-01", f"{YEAR}-12-31")).fillna(0)

# Jinja2 HTML template (beautiful minimalist design)
template = Template("""
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>{{ year }} – My Year</title>
  <style>
    @page { size: A5; margin: 1.5cm; }
    body { font-family: Georgia, serif; line-height: 1.6; color: #222; background: #fdfdfd; }
    h1 { text-align: center; margin: 2cm 0; font-size: 28pt; color: #0d3b66; }
    h2 { font-size: 14pt; color: #0d3b66; border-bottom: 1px solid #faf0ca; padding-bottom: 8px; }
    .day { margin: 1.2cm 0; page-break-inside: avoid; }
    .date { font-size: 18pt; font-weight: bold; color: #0d3b66; }
    .mood { font-size: 24pt; opacity: 0.7; margin: 0.3em 0; }
    .text { font-size: 12pt; margin: 0.8em 0; }
    .stats { column-count: 2; margin: 2cm 0; }
    .footer { text-align: center; font-size: 9pt; color: #999; margin-top: 4cm; }
    img { max-width: 100%; }
  </style>
</head>
<body>
  <h1>{{ year }}</h1>

  <h2>Year at a glance</h2>
  <p><strong>Days written:</strong> {{ total_days }}<br>
     <strong>Most common mood:</strong> {{ top_mood }}</p>
  <img src="/tmp/wordcloud.png" alt="Word cloud">
  <img src="/tmp/calendar.png" alt="Calendar heat map">

  <div class="stats">
    <ul>
      {% for mood, count in top_moods %}
      <li>{{ mood|capitalize }} – {{ count }} days</li>
      {% endfor %}
    </ul>
  </div>

  {% for entry in entries %}
  <div class="day">
    <div class="date">{{ entry.date }}</div>
    <div class="mood">{{ entry.mood|capitalize }}</div>
    <div class="text">{{ entry.text|replace("\n", "<br>")|safe }}</div>
  </div>
  {% endfor %}

  <div class="footer">
    {{ entries|length }} private days • {{ year }} • Never uploaded • Never shared
  </div>
</body>
</html>
""")

# Generate images
wordcloud.to_file("/tmp/wordcloud.png")
plt.figure(figsize=(10, 3))
calendar_data.plot(kind='bar', color='#0d3b66')
plt.title(f"{YEAR} Writing Heatmap")
plt.tight_layout()
plt.savefig("/tmp/calendar.png")

# Render HTML → PDF via WeasyPrint
html = template.render(
    year=YEAR,
    entries=entries,
    total_days=len(entries),
    top_mood=top_moods[0][0] if top_moods else "unknown",
    top_moods=top_moods
)

with open("/tmp/yearbook.html", "w") as f:
    f.write(html)

os.system(f"weasyprint /tmp/yearbook.html '{OUTPUT_PDF}'")

print(f"🎉 Your {YEAR} book is ready!")
print(f"   → {OUTPUT_PDF}")
print(f"   {len(entries)} days • {len(words):,} words written this year")
print("   Upload to Mixam, Lulu, or Amazon KDP → perfect bound, matte cover, done.")
