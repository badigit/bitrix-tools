#!/bin/bash

BASHRC="/root/.bashrc"
TEMP_FILE=$(mktemp)

# Функции и алиасы для добавления
read -r -d '' CONTENT_TO_ADD << 'EOF'
showtask() {
        tailf "/opt/webdir/temp/\$1/status"
}

_showtask() {
        local cur=\${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=( \$(compgen -W "\$(ls /opt/webdir/temp/)"-- \$cur) )
}
complete -F _showtask showtask

alias menu='/root/menu.sh'
EOF

# Проверка и добавление в .bashrc, если отсутствует
grep -qF -- "$CONTENT_TO_ADD" "$BASHRC" || echo "$CONTENT_TO_ADD" >> "$BASHRC"

# Удаление временного файла
rm "$TEMP_FILE"
