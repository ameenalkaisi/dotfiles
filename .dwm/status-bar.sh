while true;
do 
    xsetroot -name "$(acpitool -b | awk '{ print $5 }') | $(date)";
    sleep 1s;
done &
