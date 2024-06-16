#!/bin/bash

check_word_aspell() {
    local word="$1"
    echo "$word" | aspell -a | grep -q '*'
}

# sanitize word - remove punctuation
sanitize_word() {
    local word="$1"
    echo "$word" | tr -d '[:punct:]'
}

process_document() {
    local file="$1"
    local line_number=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        line_number=$((line_number + 1))
        for word in $line; do
            local clean_word
            clean_word=$(sanitize_word "$word")
            if ! check_word_aspell "$clean_word"; then
                echo "Line $line_number: '$word' is misspelled"
            fi
        done
    done < "$file"
}

main() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 filename"
        exit 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "File not found!"
        exit 1
    fi
    process_document "$1"
}

main "$@"