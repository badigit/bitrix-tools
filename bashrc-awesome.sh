#!/bin/bash

BASHRC="/root/.bashrc"

# Добавление функции showtask, если она отсутствует 
if ! grep -q 'showtask()' "$BASHRC"; then
    echo "Добавляем функцию showtask..."
    cat << 'EOF' >> "$BASHRC"

showtask() {
    tailf "/opt/webdir/temp/\$1/status"
}

_showtask() {
    local cur=\${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( \$(compgen -W "\$(ls /opt/webdir/temp/)" -- \$cur) )
}
complete -F _showtask showtask

EOF
fi

# Добавление алиаса menu, если он отсутствует
if ! grep -q "alias menu=" "$BASHRC"; then
    echo "Добавляем алиас menu..."
    echo -e "\nalias menu='/root/menu.sh'" >> "$BASHRC"
fi

# Источник .bashrc
if [ "$(whoami)" = "root" ]; then
    source "$BASHRC"
else
    echo "Script is not running as root. Please run 'source /root/.bashrc' manually."
fi
