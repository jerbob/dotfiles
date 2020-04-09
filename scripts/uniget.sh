#!/bin/bash

day=$((`date +%w` - 1))
(( day > 4 )) && echo && exit

index=0
current=`date +%s`

if [[ ! -f /tmp/today ]]
then
  jq ".[$day]" ~/.config/uniget/timetable.json > /tmp/today
fi

for time in $(jq -r ".[] | .[2]" /tmp/today)
do
  lesson=$(date --date=$time +%s)
  remaining=$((lesson - current))
  if [[ $remaining -gt 0 ]]
  then
    hour="$(( `date -d @$remaining +%-H` - 1 ))"
    [ "$hour" -eq "0" ] && hour="" || hour="${hour}h "
    minute="$(( `date -d @$remaining +%-M` + 1))m"
    room=$(jq -r ".[$index]|.[0]" /tmp/today) 
    type=$(grep -Po '(?<=\()[A-Za-z]+' <(jq -r ".[$index]|.[1]" /tmp/today))
    echo "    ${hour}${minute} until $type in $room"
    exit
  else
    index=$((index + 1))
  fi
done

echo
