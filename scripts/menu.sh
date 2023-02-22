#!/bin/bash

toolset=(
  "firefox"
  "gedit"
  "giggle"
  "gitg"
  "gitk"
  "gnome-system-monitor"
  "gnome-terminal"
  "gthumb"
  "meld"
  "nautilus"
  "nemo"
  "synapse"
  "terminator"
  "tilda"
  "tilix"
  "xdiskusage"
  "xfe"
  "xterm"
)

display_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e "  \e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done

        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then
           cur=$(( $cur )) # Preserve selected cursor position
           eval ${options[$cur]} >> .toolbox.log 2>&1 & # Launch the selected application
        elif [[ $key == "qqq" ]];
           then break # Quit menu on press Q for 3 times
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

display_menu "Select application to launch:" selected_program "${toolset[@]}"