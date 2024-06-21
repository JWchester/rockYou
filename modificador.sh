#!/bin/bash

# Defina os nomes de usuário e senha aqui
oldusername="usuario_antigo"
newusername="usuario_novo"
newpassword="senha_nova"

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script deve ser executado como root. Use sudo."
  exit 1
fi

# Verifica se o usuário atual existe
if ! id "$oldusername" &>/dev/null; then
  echo "O usuário $oldusername não existe."
  exit 1
fi

# Altera o nome de usuário
usermod -l "$newusername" "$oldusername"

# Altera o diretório home do usuário
usermod -d "/home/$newusername" -m "$newusername"

# Altera o nome do grupo
groupmod -n "$newusername" "$oldusername"

# Altera a senha do usuário
echo "$newusername:$newpassword" | chpasswd

# Modifica o arquivo .bashrc do novo usuário para alterar o prompt
bashrc_path="/home/$newusername/.bashrc"

if [ -f "$bashrc_path" ]; then
  echo "Modificando o prompt no arquivo .bashrc"
  echo "PS1='$newusername@\h:\w\$ '" >> "$bashrc_path"
else
  echo "Arquivo .bashrc não encontrado para o usuário $newusername. Criando novo .bashrc."
  echo "PS1='$newusername@\h:\w\$ '" > "$bashrc_path"
fi

# Ajusta as permissões do arquivo .bashrc
chown "$newusername:$newusername" "$bashrc_path"

echo "Alterações concluídas com sucesso."


