#!/usr/bin/python3

import sys
import json
import numpy
import os

def load_orca(filename, type):
    if not filename.endswith(".json"):
        filename = filename + ".json"

    for path in [ "system/Custom/", "system/OrcaFilamentLibrary/", "system/Prusa", "user/default/" ]:
        full_path = "/home/crpalmer/.config/OrcaSlicer/" + path + "/" + type + "/" + filename
        if os.path.exists(full_path):
            filename = full_path

    with open(filename, "r") as file:
        sys.stderr.write("Loading: " + filename + "\n")
        orca = json.load(file)
        if "inherits" in orca and orca["inherits"] != "":
            additional = load_orca(orca["inherits"], type)
            orca.update(additional)
        return orca

def load_prusa(filename):
    prusa = {}
    with open(filename, "r") as file:
        for line in file:
            kv = line.split("=")
            if len(kv) == 2:
                prusa[kv[0].strip()] = kv[1].strip()
    return prusa

def edit_distance(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            cost = 0 if s1[i - 1] == s2[j - 1] else 1
            dp[i][j] = min(
                dp[i - 1][j] + 1,  # Deletion
                dp[i][j - 1] + 1,  # Insertion
                dp[i - 1][j - 1] + cost,  # Substitution or Match
            )
    return dp[m][n]

# -------------------------

if len(sys.argv) < 3:
    print("usage: orca-config config-type prusa-config...")
    exit(1)

orca = load_orca(sys.argv[1], sys.argv[2])

with open("/tmp/orca", "w") as f:
    json.dump(orca, f, indent=4)

prusa = {}
for filename in sys.argv[3:]:
    prusa.update(load_prusa(filename))

mapping = {}
for key in orca:
    best = "???"
    best_score = 999999
    for possible in prusa:
        distance = edit_distance(key, possible)
        if distance < best_score:
            best_score = distance
            best = possible
    mapping[best] = { "key": key, "scalar": numpy.isscalar(orca[key]), "ed": best_score }

print("mapping = {", end="")
comma = "\n\t"
for kv in sorted(mapping.items()):
    print(comma + '"' + kv[0] + '": ', end="")
    print(kv[1], end="")
    comma = ",\n\t"
print()
print("}")
