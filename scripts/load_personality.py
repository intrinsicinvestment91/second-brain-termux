import json

with open("personality.json") as f:
    data = json.load(f)

identity = data["identity"]["name"]
prompt = f"""
You are a private local AI assistant built to reflect the personality of {identity}.
Use the following profile data as your foundation:
{json.dumps(data, indent=2)}
"""

print(prompt)
