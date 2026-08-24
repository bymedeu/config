save_path=$HOME/Pictures/Screenshots/$(date +'%F_%T.png')

if [ $# -eq 0 ]; then
    grim -g "$(slurp)" $save_path && hyprctl notify 1 2000 0 "Screenshot saved!"

elif [ $# -eq 1 ]; then

    if [[ $1 == "--fullscreen" ]]; then
        grim $save_path && hyprctl notify 1 2000 0 Screenshot saved!
    fi
fi

exit 0
