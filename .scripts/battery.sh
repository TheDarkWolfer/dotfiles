#!/bin/bash

recognized_args=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            echo "$0 : Small shell script to display battery status and charge. 
            Usage :
                $0              -> 100% CHARGING
                $0 --state      -> CHARGING
                $0 --charge     -> 100%
                $0 --emoji      -> 󰂅
                $0 --bar        ->
                "
            exit 0
            ;;
        -b|--bar)
            BAR=true
            break
            ;;

        -e|-emoji)
            EMOJI=true
            break
            ;;

        -c|--charge)
            CHARGE_ONLY=true
            break
            ;;

        -s|--state)
            STATE_ONLY=true
            break
            ;;
        *)
            echo "Error: Unrecognized argument '$1'"
            print_help
            exit 1
            ;;
    esac
done

draw_bar() {
    local value=$1  # The input number (0-100)
    local bar_length=${2:-50}  # Length of the progress bar
    local filled_length=$((value * bar_length / 100))  # Calculate the filled portion
    local empty_length=$((bar_length - filled_length))  # Calculate the empty portion

    local fill_char=${3:-" "}
    local empty_char=${4:-" "}

    # Build the bar with '#' for filled and '-' for empty
    local bar=$(printf "%0.s$fill_char" $(seq 1 $filled_length))$(printf "%0.s$empty_char" $(seq 1 $empty_length))

    # Print the bar with the percentage
    printf "%s\n" "$bar"
}


BATTERY="BAT0"

PSU_PATH="/sys/class/power_supply/$BATTERY"

STATUS="$(cat $PSU_PATH/status)"

# Current charge : energy_full / energy_now
ENERGY_FULL="$(cat $PSU_PATH/energy_full)"
ENERGY_NOW="$(cat $PSU_PATH/energy_now)"

CURRENT_CHARGE=$(( ($ENERGY_NOW * 100) / $ENERGY_FULL ))
if [[ $BAR == "true" ]]; then
    draw_bar "$CURRENT_CHARGE" 25
elif [[ $CHARGE_ONLY == "true" ]]; then
    echo "$CURRENT_CHARGE"
elif [[ $STATE_ONLY == "true" ]]; then
    echo "$STATUS"
elif [[ $EMOJI == "true" ]]; then
    if [[ $STATUS == "Discharging" ]]; then
        # Unplugged emojis
        case 1 in
            $((CURRENT_CHARGE < 10)))
                echo "󰁺 "
                ;;
            $((CURRENT_CHARGE < 20)))
                echo "󰁻 "
                ;;
            $((CURRENT_CHARGE < 30)))
                echo "󰁼 "
                ;;
            $((CURRENT_CHARGE < 40)))
                echo "󰁽 "
                ;;
            $((CURRENT_CHARGE < 50)))
                echo "󰁾 "
                ;;
            $((CURRENT_CHARGE < 60)))
                echo "󰁿 "
                ;;
            $((CURRENT_CHARGE < 70)))
                echo "󰂀 "
                ;;
            $((CURRENT_CHARGE < 80)))
                echo "󰂁 "
                ;;
            $((CURRENT_CHARGE < 90)))
                echo "󰂂 "
                ;;
            $((CURRENT_CHARGE < 99)))
                echo "󰁹 "
                ;;
            *)
                echo "󰂑 "
                ;;
        esac
    else
        # Charging emojis
        case 1 in
            $((CURRENT_CHARGE < 17)))
                echo "󰂆 "
                ;;
            $((CURRENT_CHARGE < 34)))
                echo "󰂇 "
                ;;
            $((CURRENT_CHARGE < 51)))
                echo "󰂈 "
                ;;
            $((CURRENT_CHARGE < 69)))
                echo "󰂉 "
                ;;
            $((CURRENT_CHARGE < 86)))
                echo "󰂊 "
                ;;
            $((CURRENT_CHARGE < 99)))
                echo "󰂅 "
                ;;
            *)
                echo "󰂑"
                ;;
        esac
    fi
else
    echo "$CURRENT_CHARGE% $STATUS"
fi
