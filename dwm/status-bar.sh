#!/bin/bash
get_vol () {
    if [[ $(amixer sget Master | awk -F"[][]" '/dB/ { printf $6 }') == "off" ]];
    then 
        echo "Muted";
    else
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
    fi
}

# get xkblayout-state from 
# https://github.com/nonpop/xkblayout-state.git
get_lang() {
    # todo: i think xblayout-state needs proper $PATH
    echo $(xkblayout-state print "%s");
}

# keep looping as long as user is logged in
# 
# this removes an issue where script would keep
# running multiple times on lightdm login and would make
# configuring the script difficult as you would have to reboot
# to see changes

while [[ $(who | grep -w $USER | wc -l) -eq 1 ]]
do 
    # todo: fix get_lang
    xsetroot -name "| $(get_vol) | $(get_lang) | $(acpitool -b | awk '{ print $5 }') | $(date)";
    # xsetroot -name "| $(get_vol) | $(acpitool -b | awk '{ print $5 }') | $(date)";
    sleep 0.5s;
done &
