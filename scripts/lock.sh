i3lock -f -t --image "/home/toto/Pictures/wallpapers/`ls /home/toto/Pictures/wallpapers | head -$((RANDOM%$(ls /home/toto/Pictures/wallpapers | wc -w)+1)) | tail -1`"

