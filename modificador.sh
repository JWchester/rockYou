#!/bin/bash


arquivo_palavras="/caminho/para/seu/arquivo/usuarios_senhas.txt"


if [ ! -f "$arquivo_palavras" ]; then
  echo "Arquivo $arquivo_palavras não encontrado."
  exit 1
fi


newusername=$(shuf -n 1 "$arquivo_palavras")


newpassword=$(shuf -n 1 "$arquivo_palavras")


oldusername="usuario_antigo"


if [ "$(id -u)" -ne 0 ]; then
  echo "Este script deve ser executado como root. Use sudo."
  exit 1
fi


if ! id "$oldusername" &>/dev/null; then
  echo "O usuário $oldusername não existe."
  exit 1
fi


usermod -l "$newusername" "$oldusername"


usermod -d "/home/$newusername" -m "$newusername"


groupmod -n "$newusername" "$oldusername"


echo "$newusername:$newpassword" | chpasswd


bashrc_path="/home/$newusername/.bashrc"

if [ -f "$bashrc_path" ]; then
  echo "Modificando o prompt no arquivo .bashrc"
  echo "PS1='$newusername@\h:\w\$ '" >> "$bashrc_path"
else
  echo "Arquivo .bashrc não encontrado para o usuário $newusername. Criando novo .bashrc."
  echo "PS1='$newusername@\h:\w\$ '" > "$bashrc_path"
fi


chown "$newusername:$newusername" "$bashrc_path"

echo "Alterações concluídas com sucesso."


