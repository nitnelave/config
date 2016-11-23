#! /bin/sh

displays="0"
#echo $(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')
#while read id
#do
#    displays="$displays $id"
#done
#echo $displays

# loop through every display looking for a fullscreen window
for display in $displays
do
    #get id of active window and clean output
    activ_win_id=`DISPLAY=:0.${display} xprop -root _NET_ACTIVE_WINDOW`
    #activ_win_id=${activ_win_id#*# } #gives error if xprop returns extra ", 0x0" (happens on some distros)
    activ_win_id=${activ_win_id:40:9}

    # Skip invalid window ids (commented as I could not reproduce a case
    # where invalid id was returned, plus if id invalid
    # isActivWinFullscreen will fail anyway.)
    #if [ "$activ_win_id" = "0x0" ]; then
    #     continue
    #fi

    # Check if Active Window (the foremost window) is in fullscreen state
    isActivWinFullscreen=`DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN`
    if [[ "$isActivWinFullscreen" = *NET_WM_STATE_FULLSCREEN* ]];then
        exit 1
    fi
done
