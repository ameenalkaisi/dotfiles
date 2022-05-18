#!/bin/bash
get_vol () {
    actual_vol=$(amixer sget Master | awk -F"[][]" '/dB/ { printf "%d", $2 }');
    cur_vol=$(expr $actual_vol / 10);
    output=""
    for i in {1..10}; do
        if [[ $i -le $cur_vol ]] ; then
            output+=":";
        else
            output+="-";
        fi
    done

    output+=" ";
    output+="$actual_vol";
    output+="%";
    echo $output;
}

while [[ $GDMSESSION == "dwm" && $(who | grep -w $USER | wc -l) -eq 1 ]]
do 
    xsetroot -name "$(get_vol) | $(acpitool -b | awk '{ print $5 }') | $(date)";
    #xsetroot -name "testing!";
    sleep 1s;
done &
