#!/usr/bin/env sh

alias playerctl="playerctl --ignore-player=chromium"

if [ "$(playerctl -l 2>&1)" != "No players were found" ]; then
  player_status=$(playerctl status 2>/dev/null)
  artist="$(playerctl metadata artist 2>/dev/null) - "
  title="$(playerctl metadata title 2>/dev/null)"
  if [ "$player_status" = "Playing" ]; then
    if [ "$title" == "_" ]; then
      exit
    fi
    if [ "$artist" != " - " ]; then
      echo "     $artist$title"
    else
      title="${title%.*}"
      echo "     $title"
    fi
  elif [ "$player_status" = "Paused" ]; then
    if [ "$artist" != " - " ]; then
      echo "     $artist$title"
    else
      title="${title%.*}"
      echo "     $title"
    fi
  else
    echo " "
  fi
else
  echo " "
fi
