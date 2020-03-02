#!/bin/bash
#taken from https://unix.stackexchange.com/a/388148/48971

if [ $# -lt 4 ]; then
        echo "Usage: $0 <youtube's URL> <HH:mm:ss.milisecs from time> <HH:mm:ss.milisecs to time> <output_file_name>"
        echo "e.g.:"
        echo "$0 https://www.youtube.com/watch?v=T1n5gXIPyws 00:00:25 00:00:42 intro.mp4"
        exit 1
fi

echo "processing..."

from=$(date "+%s" -d "UTC 01/01/1970 $2")
to=$(date "+%s" -d "UTC 01/01/1970 $3")

from_pre=$(($from - 30))

if [ $from_pre -lt 0 ]
then
        from_pre=0
fi

from_pre_command_print=$(date -u "+%T" -d @$from_pre)
from_command_print=$(date -u "+%T" -d @$(($from - $from_pre)))$(grep -o "\..*" <<< $2)
to_command_print=$(date -u "+%T" -d @$(($to - $from_pre)))$(grep -o "\..*" <<< $3)

command="ffmpeg -y "

for uri in $(youtube-dl -g $1)
do
        command+="-ss $from_pre_command_print -i $uri "
done

command+="-ss $from_command_print -to $to_command_print $4"
echo "downloading with the following command:"
echo "$command" 
$command
