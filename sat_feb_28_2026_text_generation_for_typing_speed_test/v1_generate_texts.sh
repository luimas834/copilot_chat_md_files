#!/bin/bash

# ============================================================
# TypeDrift - Text File Generator
# Splits no_vowel.txt -> data/no_vowel_txt/n_vwl1.txt ... n_vwl50.txt
# Splits time_test.txt -> data/time_txt/time1.txt ... time50.txt
# Run from the ROOT of the TypeDrift project directory
# ============================================================

set -e

echo "=== TypeDrift Text File Generator ==="
echo ""

# ---------- NO VOWEL MODE ----------
NO_VOWEL_DIR="data/no_vowel_txt"
NO_VOWEL_SRC="no_vowel.txt"

if [ ! -f "$NO_VOWEL_SRC" ]; then
    echo "ERROR: $NO_VOWEL_SRC not found in current directory!"
    echo "Place no_vowel.txt in the project root and re-run."
    exit 1
fi

mkdir -p "$NO_VOWEL_DIR"

# Split by blank lines (each paragraph = one text)
count=0
current_text=""

while IFS= read -r line || [ -n "$line" ]; do
    if [ -z "$line" ]; then
        # Blank line = separator
        if [ -n "$current_text" ] && [ $count -lt 50 ]; then
            count=$((count + 1))
            echo -n "$current_text" > "${NO_VOWEL_DIR}/n_vwl${count}.txt"
            echo "  Created: ${NO_VOWEL_DIR}/n_vwl${count}.txt"
            current_text=""
        fi
    else
        if [ -n "$current_text" ]; then
            current_text="${current_text}
${line}"
        else
            current_text="$line"
        fi
    fi
done < "$NO_VOWEL_SRC"

# Don't forget the last block (no trailing blank line)
if [ -n "$current_text" ] && [ $count -lt 50 ]; then
    count=$((count + 1))
    echo -n "$current_text" > "${NO_VOWEL_DIR}/n_vwl${count}.txt"
    echo "  Created: ${NO_VOWEL_DIR}/n_vwl${count}.txt"
fi

echo ""
echo "No Vowel: $count files created in $NO_VOWEL_DIR"
echo ""

# ---------- TIME TEST MODE ----------
TIME_DIR="data/time_txt"
TIME_SRC="time_test.txt"

if [ ! -f "$TIME_SRC" ]; then
    echo "ERROR: $TIME_SRC not found in current directory!"
    echo "Place time_test.txt in the project root and re-run."
    exit 1
fi

mkdir -p "$TIME_DIR"

count=0
current_text=""

while IFS= read -r line || [ -n "$line" ]; do
    if [ -z "$line" ]; then
        if [ -n "$current_text" ] && [ $count -lt 50 ]; then
            count=$((count + 1))
            echo -n "$current_text" > "${TIME_DIR}/time${count}.txt"
            echo "  Created: ${TIME_DIR}/time${count}.txt"
            current_text=""
        fi
    else
        if [ -n "$current_text" ]; then
            current_text="${current_text}
${line}"
        else
            current_text="$line"
        fi
    fi
done < "$TIME_SRC"

if [ -n "$current_text" ] && [ $count -lt 50 ]; then
    count=$((count + 1))
    echo -n "$current_text" > "${TIME_DIR}/time${count}.txt"
    echo "  Created: ${TIME_DIR}/time${count}.txt"
fi

echo ""
echo "Time Test: $count files created in $TIME_DIR"
echo ""
echo "=== Done! ==="
echo ""
echo "Generated file structure:"
echo "  data/"
echo "  ├── no_vowel_txt/"
echo "  │   ├── n_vwl1.txt"
echo "  │   ├── n_vwl2.txt"
echo "  │   └── ... n_vwl${count}.txt"
echo "  └── time_txt/"
echo "      ├── time1.txt"
echo "      ├── time2.txt"
echo "      └── ... time${count}.txt"