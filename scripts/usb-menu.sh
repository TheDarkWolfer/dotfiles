while true; do
    # Get device ID using fzf   
    ID=$( (echo "REFRESH : Refresh the list" ; usbguard list-devices) | fzf --reverse --header="Select a device or REFRESH to skip" | awk '{print $1}' | tr -d ":")

    # If REFRESH is typed, skip to the next iteration
    if [[ "$ID" == "REFRESH" ]]; then
        echo "Skipping to the next iteration..."
        continue
    fi

    # Get the state of the selected device
    STATE=$(usbguard list-devices | grep "$ID:" | awk '{print $2}')

    # Perform actions based on the state
    if [[ "$STATE" == "allow" ]]; then
        usbguard block-device $ID
        echo "Blocked device with ID $ID"
    elif [[ "$STATE" == "block" ]]; then
        usbguard allow-device $ID
        echo "Allowed device with ID $ID"
    else
        echo "Invalid state or device ID. Exiting."
        exit
    fi

done

