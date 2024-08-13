#!/usr/bin/env bash

readonly t_file=$HOME/projects/therofisaurus/thesaurus.txt

escape_key="Escape"
exit_key="Alt+q"
start_key="Alt+a"
emph_color="#FF79C6"

menu="Press <span color='${emph_color}'>${exit_key}</span> or \
<span color='${emph_color}'>Escape</span> to exit
Press <span color='${emph_color}'>${start_key}</span> to restart"

do_rofi="rofi -kb-custom-1 ${exit_key} -kb-custom-2 ${start_key} -dmenu -p"

function check_output() {
    local code=${1}
    local result=${2}
    if [[ ${code} -eq 10 ]]; then
        exit
    elif [[ ${code} -eq 11 ]]; then
        return 1
    fi

    if [[ -z ${result} ]]; then
        exit
    fi

    return 0
}

while :; do
    word=$(${do_rofi} "Enter a single word" -mesg "${menu}")
    check_output $? ${word} || continue

    result=$(tail -n +2 "${t_file}" | grep -w "${word}")

    if [[ -z "${result}" ]]; then
        rofi -e "No entries found for '${word}' (press <Enter> to continue)"
        continue
    fi

    result=$(echo "${result}" | ${do_rofi} "Select line to expand" -mesg "${menu}")
    check_output $? ${result} || continue

    result=$(echo ${result} | tr " " "\n" | ${do_rofi} "Results (${word})" -mesg "${menu}")
    check_output $? ${result} || continue
done
