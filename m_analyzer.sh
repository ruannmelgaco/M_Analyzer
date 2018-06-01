#!/bin/bash
echo "+---------------------------------------------------------------------+"
echo "| __    __                                                            |"
echo "||  \  /  |   Desenvolvido por: Ruann Melgaço    R.A: 1680971721013   |"
echo "||   \/   |                     Kauan Ferreira   R.A: 1680971721      |"
echo "||        |                     Matias Fernandes R.A: 1680971721      |"
echo "||__|\/|__|                                                           |"
echo "|                                                                     |"
echo "+---------------------------------------------------------------------+"

#Função de busca de usuários
findusr(){
read -p "Indique o usuário a ser buscado: " fndusr
grep $fndusr /etc/passwd
}

#Função de busca de permissões
chkperm(){
read -p "Forneça o grupo de OCTAIS para buscar: " gperm
read -p "Forneça um ponto de partida para buscar: " dsrch
find $dsrch -perm $gperm
}

#Função inicial
main(){
echo "+-----------------------+----------------------+-------------------+"
echo "|=====Monitoramento=====|=====Configuração=====|=======Busca=======|"
echo "+-----------------------+----------------------+-------------------+"
echo "|1 =       CPU          |7 =    Threshold      |10 =  Usuários     |"
echo "|2 =     Memória        |                      |11 = Permissões    |"
echo "|3 = Memória Virtual    |                      |                   |"
echo "|4 =      Disco         |                      |                   |"
echo "|5 =      Rede          |                      |                   |"
echo "|6 =      Sair          |                      |                   |"
echo "+-----------------------+----------------------+-------------------+"

read -p "--> " escolha
case $escolha in
1) echo c | nmon;;
2) echo m | nmon;;
3) echo V | nmon;;
4) echo d | nmon;;
5) echo n | nmon;;
6) clear; echo "Script finalizado"; sleep 2; exit;;
10) findusr;;
11) chkperm;;
*) clear; echo "Opção inválida"; sleep2; menu
esac
}

#Inicia a função Main
main


