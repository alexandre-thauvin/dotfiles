i3lock -f -t --image "/home/alexandrethauvin/Pictures/wallpapers/`ls /home/alexandrethauvin/Pictures/wallpapers | head -$((RANDOM%$(ls /home/alexandrethauvin/Pictures/wallpapers | wc -w)+1)) | tail -1`"

