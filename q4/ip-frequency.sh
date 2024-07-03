#!/bin/bash

# Default log file path
SCRIPT_DIR=$(dirname "$0")
DEFAULT_LOG_FILE="$SCRIPT_DIR/logfile.log"

# Check if a command line argument is provided for the log file path
LOG_FILE="${1:-$DEFAULT_LOG_FILE}"

# Check if the specified log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file does not exist: $LOG_FILE"
  exit 1
fi

# Filter for IP Address, then sort and count occurances, then sort occurances descending
awk '{print $2}' "$LOG_FILE" | sort | uniq -c | sort -nr