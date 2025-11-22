#!/usr/bin/env python3
import json, os
from datetime import datetime

ARCHIVE = os.path.expanduser("~/local_ai_assistant/notes/reflections_archive.txt")
OUTPUT = os.path.expanduser("~/local_ai_assistant/personality.json")

entries = []
with open(ARCHIVE) as f:
    for line in f:
        if '|' in line:
            date, mood, text = line.strip().split("|", 2)
            entries.append({"date": date.strip(), "mood": mood.strip(), "text": text.strip()})

entries = sorted(entries, key=lambda x: x["date"], reverse=True)[:500]  # last ~1.5 years

system_prompt = f"""
You are my second brain. You have been watching me journal every day since 2025.
Here is what you have learned about me so far ({len(entries)} days of data):

"""
for e in entries[:100]:  # recency bias
    system_prompt += f"- {e['date']} | felt: {e['mood']} | {e['text']}\n"

system_prompt += "\nMirror my real personality, energy, values, and style exactly. Never moralize or give generic advice."

with open(OUTPUT, "w") as f:
    json.dump({"system_prompt": system_prompt.strip()}, f, indent=2)

print(f"Personality updated → {OUTPUT} ({len(entries)} days)")
