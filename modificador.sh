#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root" 
    exit 1
fi

# Novo nome de usuário e senha
NOVO_USUARIO="novo_usuario"
NOVA_SENHA="123"

# Muda o nome do usuário
usermod -l "$NOVO_USUARIO" root
if [ $? -eq 0 ]; then
    echo "Nome de usuário alterado com sucesso para $NOVO_USUARIO"
else
    echo "Erro ao alterar o nome de usuário"
    exit 1
fi

# Define a nova senha para o usuário
echo -e "$NOVA_SENHA\n$NOVA_SENHA" | passwd "$NOVO_USUARIO"
if [ $? -eq 0 ]; then
    echo "Senha alterada com sucesso para o usuário $NOVO_USUARIO"
else
    echo "Erro ao alterar a senha para o usuário $NOVO_USUARIO"
    exit 1
fi

# Atualiza a exibição do nome de usuário no prompt do terminal
echo "PS1='\[\033[01;32m\]$NOVO_USUARIO\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" > /root/.bashrc
source /root/.bashrc

echo "Operação concluída com sucesso"
