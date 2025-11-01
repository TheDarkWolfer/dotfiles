#!/usr/bin/env bash

GOOD='{"text":"Good","class":"good","alt":"good"}'
OKAY='{"text":"Okay","class":"okay","alt":"okay"}'
BAD='{"text":"Bad","class":"bad","alt":"bad"}'
CRITICAL='{"text":"Critical","class":"critical","alt":"critical"}'

BATTERY="$(cat /sys/class/power_supply/BAT0/capacity)"
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
sleep 0.5
read cpu2 user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 < /proc/stat
CPU=$((100 * ((user2-user) + (nice2-nice) + (system2-system) + (irq2-irq) + (softirq2-softirq) + (steal2-steal)) / ((user2-user)+(nice2-nice)+(system2-system)+(idle2-idle)+(iowait2-iowait)+(irq2-irq)+(softirq2-softirq)+(steal2-steal))))
MEM=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf "%.0f", (1 - avail/total) * 100}' /proc/meminfo)

#echo "CPU: $CPU | RAM: $MEM | BAT: $BATTERY"

# CPU impact
(( CPU > 90 )) && ((SCORE+=3)) || (( CPU > 75 )) && ((SCORE+=2)) || (( CPU > 50 )) && ((SCORE+=1))
# RAM impact
(( MEM > 90 )) && ((SCORE+=3)) || (( MEM > 80 )) && ((SCORE+=2)) || (( MEM > 60 )) && ((SCORE+=1))
# Battery impact (inverse logic)
(( BAT < 20 )) && ((SCORE+=3)) || (( BAT < 40 )) && ((SCORE+=2)) || (( BAT < 70 )) && ((SCORE+=1))

#echo "Score : $SCORE"
#exit

if    (( SCORE <= 10 )) ;     then    echo "$GOOD"
elif  (( SCORE <= 20 )) ;     then    echo "$OKAY"
elif  (( SCORE <= 30 ));      then    echo "$BAD"
else                                  echo "$CRITICAL"
fi
