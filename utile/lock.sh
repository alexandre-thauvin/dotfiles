i3lock -t -i /home/thauvi_a/Pictures/wallpaper/`ls /home/thauvi_a/Pictures/wallpaper | head -$((RANDOM%$(ls /home/thauvi_a/Pictures/wallpaper | wc -w)+1)) | tail -1`
