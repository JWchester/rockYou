#!/bin/bash

# Arquivos de lista de nomes de usuário e senhas
USER_LIST="rockyou_1.txt"
PASSWORD_LIST="rockyou_1.txt"

# Função para obter um item aleatório de um arquivo
get_random_item() {
  local file="$1"
  shuf -n 1 "$file"
}

# Definindo novos valores de usuário e senha aleatoriamente
NOVO_USUARIO=$(get_random_item "$USER_LIST")
NOVA_SENHA=$(get_random_item "$PASSWORD_LIST")

# Verificando se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Por favor, execute este script como root"
  exit 1
fi

# Verificando se o usuário msfadmin existe
if id "msfadmin" >/dev/null 2>&1; then
  echo "O usuário msfadmin existe."
else
  echo "O usuário msfadmin não existe."
  exit 1
fi

# Alterando a senha do usuário msfadmin
echo "msfadmin:$NOVA_SENHA" | chpasswd

# Mensagem de confirmação
echo "A senha do usuário msfadmin foi alterada para: $NOVA_SENHA"

# Opcionalmente, alterando o nome de usuário para NOVO_USUARIO
if [ "$NOVO_USUARIO" != "msfadmin" ]; then
  # Verificando se o novo usuário já existe
  if id "$NOVO_USUARIO" >/dev/null 2>&1; then
    echo "O usuário $NOVO_USUARIO já existe. Escolha outro nome de usuário."
    exit 1
  fi
  
  # Criando um novo usuário com o nome NOVO_USUARIO e copiando dados
  useradd -m -s /bin/bash "$NOVO_USUARIO"
  echo "$NOVO_USUARIO:$NOVA_SENHA" | chpasswd
  rsync -a /home/msfadmin/ /home/$NOVO_USUARIO
  chown -R $NOVO_USUARIO:$NOVO_USUARIO /home/$NOVO_USUARIO
  userdel -r msfadmin

  echo "Usuário msfadmin renomeado para $NOVO_USUARIO"
fi

exit 0

