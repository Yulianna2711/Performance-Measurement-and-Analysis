#!/bin/bash

TARGET_FILE=$1
if [ -z "$TARGET_FILE" ]; then
    echo "Missing target file. Execution aborted"
    exit 1
fi

if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: File '$TARGET_FILE' not found or not compiled!"
    exit 1
fi

P_IDLE=5

P_DYNAMIC=25.0

P_TOTAL_LOAD=$(echo "$P_IDLE + $P_DYNAMIC" | bc -l)

TEMP_LOG=$(mktemp)

/usr/bin/time -f "%e\n%U\n%S" -o $TEMP_LOG $TARGET_FILE > /dev/null

if [ $? -ne 0 ]; then
    echo "Error during execution of $TARGET_FILE"
    rm -f $TEMP_LOG
    exit 1
fi

TIME_ELAPSED=$(sed -n '1p' $TEMP_LOG)
TIME_USER=$(sed -n '2p' $TEMP_LOG)
TIME_SYS=$(sed -n '2p' $TEMP_LOG)

rm -f $TEMP_LOG

TIME_CPU=$(echo "$TIME_USER + $TIME_SYS" | bc -l)

E_SYS_J=$(echo "($P_IDLE * $TIME_ELAPSED) + ($P_DYNAMIC * $TIME_CPU)" | bc -l)

E_PROG_J=$(echo "$P_DYNAMIC * $TIME_CPU" | bc -l)

E_SYS_WH=$(echo "$E_SYS_J / 3600" | bc -l)
E_PROG_WH=$(echo "$E_PROG_J / 3600" | bc -l)

AVG_POWER=$(echo "$E_SYS_J / $TIME_ELAPSED" | bc -l)

echo "Target Executable:           $TARGET_FILE"
echo "Elapsed (Wall) Time:         ${TIME_ELAPSED} s"
echo "Active CPU Time:             ${TIME_CPU} s (User: ${TIME_USER}s, Sys: ${TIME_SYS}s)"
echo "Estimated Avg Power:         $(printf "%.2f" $AVG_POWER) W"
printf "Total System Energy:        %7.2f J (%6.4f W*h)\n" $E_SYS_J $E_SYS_WH
printf "Program-Specific Energy:    %7.2f J (%6.4f W*h)\n" $E_PROG_J $E_PROG_WH
