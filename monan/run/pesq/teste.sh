LABELI=2014020100
LABELF=2014031500
RUNHOURSTEP=6  # Step size in hours
RUNHOUR=24      # Hours to run each date

start=${LABELI}
end=${LABELF}

current="${start}"

while [[ "${current}" -le "${end}" ]]; do
    # Format current date to "YYYY-MM-DD HH"
    formatted_date=$(date -d "${current:0:8} ${current:8}:00" "+%Y-%m-%d %H")

    # Calculate LABELF (next date + RUNHOUR at 00)
    next_label_date=$(date -d "${current:0:8} +1 day" "+%Y%m%d")
    LABELF="${next_label_date}00"  # Set LABELF to the next day at hour 00

    # Print formatted date and current label
    echo "${formatted_date},${current}"

    # Increment current by RUNHOURSTEP to the next hour
    current=$(date -d "${formatted_date} + ${RUNHOURSTEP} hour" "+%Y%m%d%H")
    
    # If current exceeds LABELF, break the loop
    if [[ "${current}" -gt "${LABELF}" ]]; then
        break
    fi
done

