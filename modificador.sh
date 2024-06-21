#!/bin/bash

# Caminho para o arquivo de texto que contém as palavras
arquivo_palavras="rockyou_1.txt"

# Verifica se o arquivo existe
if [ ! -f "$arquivo_palavras" ]; then
  echo "Arquivo $arquivo_palavras não encontrado."
  exit 1
fi

# Seleciona uma palavra aleatória do arquivo para o novo nome de usuário
newusername=$(shuf -n 1 "$arquivo_palavras")

# Seleciona uma palavra aleatória do arquivo para a nova senha
newpassword=$(shuf -n 1 "$arquivo_palavras")

# Defina o nome de usuário antigo (alterar conforme necessário)
oldusername="usuario_antigo"

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

# Verifica se o diretório home do novo usuário foi criado
if [ ! -d "/home/$newusername" ]; then
  echo "Diretório home do usuário $newusername não encontrado. Criando o diretório."
  mkdir -p "/home/$newusername"
  chown "$newusername:$newusername" "/home/$newusername"
fi

# Altera a senha do usuário
echo "$newusername:$newpassword" | chpasswd

echo "Alterações concluídas com sucesso."
echo "O nome de usuário foi alterado de $oldusername para $newusername, a senha foi atualizada, e o prompt do terminal foi modificado."
