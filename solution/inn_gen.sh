#!/bin/bash

declare -A nums

for (( num = 1; num < 10; num++ ))
do
    nums["num_$num"]="$(shuf -n 1 -i 0-9)"
done

KONTROL=$((
    $((
        $((
            $(( ${nums["num_1"]} * 2)) +
            $(( ${nums["num_2"]} * 4)) +
            $(( ${nums["num_3"]} * 10)) +
            $(( ${nums["num_4"]} * 3)) +
            $(( ${nums["num_5"]} * 5)) +
            $(( ${nums["num_6"]} * 9)) +
            $(( ${nums["num_7"]} * 4)) +
            $(( ${nums["num_8"]} * 6)) +
            $(( ${nums["num_9"]} * 8))
        )) % 11
    )) % 10
))

INN=$(printf "%s%s%s%s%s%s%s%s%s%s" \
    ${nums["num_1"]}\
    ${nums["num_2"]}\
    ${nums["num_3"]}\
    ${nums["num_4"]}\
    ${nums["num_5"]}\
    ${nums["num_6"]}\
    ${nums["num_7"]}\
    ${nums["num_8"]}\
    ${nums["num_9"]}\
    $KONTROL
)

echo $INN