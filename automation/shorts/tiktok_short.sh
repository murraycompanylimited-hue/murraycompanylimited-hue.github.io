#!/data/data/com.termux/files/usr/bin/bash
# tiktok_short.sh  — Build a 9:16 vertical short from image + audio + word
# Usage: ./automation/shorts/tiktok_short.sh "veritas" /path/to/audio.mp3 /path/to/bg.jpg

set -e
WORD="$1"; AUDIO="$2"; BG="$3"
if [ -z "$WORD" ] || [ -z "$AUDIO" ] || [ -z "$BG" ]; then
  echo "Usage: $0 \"WORD\" AUDIO.mp3 BACKGROUND.jpg"; exit 1; fi

STAMP=$(date +%Y%m%d_%H%M%S)
OUTDIR="exports/${WORD}_${STAMP}"
mkdir -p "$OUTDIR"

# Build 1080x1920 vertical video (image loop + audio; pad/scale safely)
ffmpeg -y -loop 1 -i "$BG" -i "$AUDIO" \
  -filter_complex "scale=1080:-2, pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black" \
  -c:v libx264 -tune stillimage -c:a aac -b:a 160k -pix_fmt yuv420p -shortest \
  "$OUTDIR/${WORD}.mp4"

# Make caption text
cat > "$OUTDIR/${WORD}.txt" <<EOF
${WORD} — etymology & lawful origin.
Full breakdown @ DonnieDictionary (YouTube).
#DonnieDictionary #Etymology #Law #Truth #Latin #WordOfTheDay #Shorts #TikTok #YouTubeShorts
EOF

# Copy to phone’s shared storage for easy upload
SHARE="$HOME/storage/shared/DonnieDictionary/exports/${WORD}_${STAMP}"
mkdir -p "$SHARE"
cp -a "$OUTDIR/." "$SHARE/"

echo "✅ Built:"
echo "  $OUTDIR/${WORD}.mp4"
echo "  $OUTDIR/${WORD}.txt"
echo "Also copied to: $SHARE"

