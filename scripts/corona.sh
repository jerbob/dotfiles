#!/bin/env zsh

function jq() {
  /bin/jq $@ 2>/dev/null
}

curl -s 'https://corona-stats.online/uk?source=2&format=json' | jq '.data[0]' > /tmp/corona

confirmed=$(jq '.cases' /tmp/corona)
deaths=$(jq '.deaths' /tmp/corona)

echo "    $confirmed cases, $deaths dead" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
