#!/bin/bash

BASHRC="/root/.bashrc"

# Проверка и добавление функции showtask
if ! grep -q "showtask()" "$BASHRC"; then
    echo "Добавляем функцию showtask..."
    cat << 'EOF' >> "$BASHRC"

showtask() {
    tailf "/opt/webdir/temp/\$1/status"
}

EOF
fi

# Проверка и добавление функции _showtask
if ! grep -q "_showtask()" "$BASHRC"; then
    echo "Добавляем вспомогательную функцию _showtask..."
    cat << 'EOF' >> "$BASHRC"

_showtask() {
    local cur=\${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( \$(compgen -W "\$(ls /opt/webdir/temp/)" -- \$cur) )
}
complete -F _showtask showtask

EOF
fi

# Проверка и добавление алиаса menu
if ! grep -q "alias menu=" "$BASHRC"; then
    echo "Добавляем алиас menu..."
    echo -e "\nalias menu='/root/menu.sh'" >> "$BASHRC"
fi

# Перезагрузка .bashrc
if [ "$(whoami)" = "root" ]; then
    source "$BASHRC"
else
    echo "Script is not running as root. Please run 'source /root/.bashrc' manually."
fi
