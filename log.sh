#!/bin/bash

# Path to your input text file
input_file="/var/log/auth.log"

# Path to the generated output file
output_file="/var/www/html/auth-display"

# Get the last 30 lines of the input file
tail -n 100 "$input_file" > "$output_file"