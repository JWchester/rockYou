#!/bin/bash

# Array de senhas
PASSWORDS=(
  "c1sa"
  "p2ao"
  "a3le"
  "m4or"
  "v5er"
  "s6ol"
  "d7ia"
  "g8as"
  "f9lo"
  "r0sa"
  "a1mo"
  "b2ol"
  "t3er"
  "j4oi"
  "p5az"
  "m6eu"
  "r7io"
  "v8en"
  "a9ce"
  "d0os"
  "p1ar"
  "n2uv"
  "e3st"
  "r4ua"
  "f5oz"
  "l6ua"
  "b7oa"
  "m8ar"
  "v9oz"
  "s0eu"
  "t1al"
  "c2or"
  "d3el"
  "j4ar"
  "p5er"
  "m6il"
  "v7ir"
  "a8la"
  "b9os"
  "t0om"
  "a@1b"
  "c#2d"
  "e$3f"
  "g%4h"
  "i^5j"
  "k&6l"
  "m*7n"
  "o(8p"
  "q)9r"
  "s!0t"
)

# Função para obter um item aleatório de um array
get_random_item() {
  local array=("$@")
  local index=$((RANDOM % ${#array[@]}))
  echo "${array[$index]}"
}

# Definindo nova senha aleatoriamente
NOVA_SENHA=$(get_random_item "${PASSWORDS[@]}")

# Verificando se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Por favor, execute este script como root"
  exit 1
fi

# Verificando se o usuário msfadmin existe
if id "msfadmin" >/dev/null 2>&1; then
  echo "OK"
else
  echo "O usuário msfadmin não existe."
  exit 1
fi

# Alterando a senha do usuário msfadmin
echo "msfadmin:$NOVA_SENHA" | chpasswd

# Mensagem de confirmação
echo "A senha do usuário foi alterada"

exit 0

