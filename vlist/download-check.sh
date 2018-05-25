#! /bin/bash

# new files
echo "List of new files:"
grep -e '^\[download\] Destination\:' out.txt | cut -f2 -d: | sed 's/^ /"/;s/$/"/'

# checksum for new files
grep -e '^\[download\] Destination\:' out.txt | cut -f2 -d: | sed 's/^ /"/;s/$/"/' | xargs shasum -a 256 >> sha256.txt

echo ""
echo "New files appended to sha256.txt. You may want to: rm out.txt"
