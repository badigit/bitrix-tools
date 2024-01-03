#!/bin/bash

BASHRC="/root/.bashrc"

# Функция для добавления блока кода, если он отсутствует
add_if_missing() {
    local search="$1"
    local block="$2"
    if ! grep -qF "$search" "$BASHRC"; then
        echo "Добавляем в .bashrc: $search"
        echo "$block" >> "$BASHRC"
    fi
}

# Блоки кода для добавления
showtask_block='
showtask() {
    tailf "/opt/webdir/temp/$1/status"
}
'

_showtask_block='
_showtask() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls /opt/webdir/temp/)" -- $cur) )
}
complete -F _showtask showtask
'

menu_alias='
alias menu='\''/root/menu.sh'\''
'

# Добавление блоков
add_if_missing "showtask()" "$showtask_block"
add_if_missing "_showtask()" "$_showtask_block"
add_if_missing "alias menu=" "$menu_alias"

# Источник .bashrc
if [ "$(whoami)" = "root" ]; then
    source "$BASHRC"
else
    echo "Script is not running as root. Please run 'source /root/.bashrc' manually."
fi
