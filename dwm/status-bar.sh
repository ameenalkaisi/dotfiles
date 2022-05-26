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

get_lang() {
    # solution grabbed from fikovnik from github
    # https://gist.github.com/fikovnik/ef428e82a26774280c4fdf8f96ce8eeb#file-getxkblayout-c
    echo $(~/dotfiles/dwm/getxkblayout.o | awk '/Layout/ { printf $3; }');
}

get_network() {
    echo $(nmcli c show --active | awk 'NR == 2 { printf $1; }');
}

# keep looping as long as user is logged in
# 
# this removes an issue where script would keep
# running multiple times when there is alot of lightdm logins and would make
# configuring the script difficult as you would have to reboot
# to see changes

while [[ $(who | grep -w $USER | wc -l) -ge 1 ]]
do 
    xsetroot -name "| $(get_vol) | $(get_lang) | $(get_network) | $(acpitool -b | awk '{ print $5 }') | $(date +'%r %d/%m/%y %a %b')";
    sleep 0.5s;
done &
