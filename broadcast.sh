#ffmpeg -re -i input-file  -rtsp_transport tcp -i "rtsp://password@(streamaddress with local IP)"  -acodec libmp3lame  -ar 44100 -b:a 128k -pix_fmt yuv420p -profile:v baseline -s 426x240 -bufsize 2048k -vb 400k -maxrate 800k -deinterlace -vcodec libx264 -preset medium -g 30 -r 30 -f flv "rtmp://a.rtmp.youtube.com/live2/(Stream name/key)"

## CREDIT:
## +flamethrower1982 @flamethrower82
## You're welcome to use my script. You can even borrow my file structure
## if you find it useful.
##
## If you have any questions, message me on Twitter @flamethrower82
##
## GNU Standard License 3.0
##
## Written 12/28/2016
##
## You are free to distribute, just please make sure to keep my original
## comment if you modify it. Please leave contact info and modified date
## in modified lines and/or sections

# To stream to YouTube, go to your Channel Studio, then to the Broadcast Live
# section. Your ID will be on the bottom after pressing the button to reveal
# it. Be careful with that code. Anyone can live stream with it.
YOUTUBECODE=

ffmpeg -re -i /dev/video2  -acodec libmp3lame  -ar 44100 -b:a 128k -pix_fmt yuv420p -profile:v baseline -s 426x240 -bufsize 2048k -vb 400k -maxrate 800k -deinterlace -vcodec libx264 -preset medium -g 30 -r 30 -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBECODE"
