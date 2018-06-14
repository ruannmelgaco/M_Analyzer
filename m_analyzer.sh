#!/bin/bash
echo "+---------------------------------------------------------------------+"
echo "| __    __                                                            |"
echo "||  \  /  |   Desenvolvido por: Ruann Melgaço    R.A: 1680971721013   |"
echo "||   \/   |                     Kauan Ferreira   R.A: 1680971721025   |"
echo "||        |                     Matias Fernandes R.A: 1680971721002   |"
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

#Função Processos
chkprocessos(){

   clear;
   echo -e "Opção 1 - Listar Processos\n";
   echo -e "Opção 2 - Matar Processos\n";
   echo -e "Opção 3 - Alterar Processos\n";
   echo -e "Opção 4 - Voltar ao menu anterior\n";

read -p "--> " list_option
case $list_option in
	1) 
	read -p "De qual usuario gostaria de listar os processos: " usuario_list
	top -b -n 1 | grep $usuario_list | less ;
	sleep 2;
	clear;
	chkprocessos;
	;;
2) 
   read -p "Qual processo você gostaria de matar: " processo_kill
   echo -e "\nSIGTERM - 1  , SIGKILL - 2\n";
   read -p "Gostaria de utilizar o SIGTERM ou SIGKILL para finalizar o processo?: " escolha_kill
   if [ $escolha_kill == 1 ];then
	kill $processo_kill 1>/dev/null;
   else if [ $escolha_kill == 2 ];then
	   kill -9 $processo_kill;
   else
	   echo -e "Opcao invalida\n";
	   sleep 2;
	   chkprocessos;
   fi 
  fi
  chkprocessos;
  ;;
3) 
   read -p "Qual o PID do processo que você gostaria de alterar a prioridade: " processo_PID 
   read -p "Qual o valor da nova prioridade: " nova_prioridade
   renice $nova_prioridade -p $processo_PID; 
   chkprocessos;;
4) clear;main;;
*) clear;
   echo "Opcao inválida";
   sleep 2;
   chkprocessos;;
esac

}	

#Função inicial
main(){
#Verifica se o usuário está logado como root
if [ "$(id -u)" != "0" ]; then
clear; echo "Você precisa ser usuário Root para executar esta aplicação"; sleep 2; exit;
else
echo "                     Usuário root autenticado!"
fi

#verifica se os programas NMON, BC e LESS estão instalados na maquina
dpkg -l | grep nmon  1>/dev/null   
NMON_STATUS=$(echo $?);
dpkg -l | grep ii'[[:space:]]''[[:space:]]'bc 1>/dev/null
BC_STATUS=$(echo $?);
dpkg -l | grep less 1>/dev/null
LESS_STATUS=$(echo $?);

if [ $NMON_STATUS != 0 ] || [ $BC_STATUS != 0 ] || [ $LESS_STATUS != 0 ]; then
	echo -e "\nPara o funcionamento completo da ferramenta , é necessario ter instalado na maquina os programa NMON ,BC e LESS\n"
	read -p "Digite "S" para instalar ou "N" para não instalar , porém sem o NMON, BC e o LESS , a ferramenta não funcionará: " resposta
	if [ $resposta == "s" ] || [ $resposta == "S" ];then 
		apt-get install nmon -y 
		apt-get install bc -y
		apt-get install less -y 
		sleep 2;clear;echo -e "instalação do NMON , BC e do LESS  foi feita com sucesso\n";
		
	else 
	     if [ $resposta == "n" ] || [ $resposta == "N" ];then
		clear;echo -e "\n Você escolheu não instalar o NMON, LESS e o BC \n";sleep 2;exit;
	     else 
		
		clear;echo -e "\nOpção invalida, a instalação do NMON, LESS e do BC foi cancelada\n";sleep 2;exit;
	     fi 
	fi

else
	echo "		Os Programas NMON , BC e LESS já estão instalados";
fi

echo "+-----------------------+------------------------+-------------------+"
echo "|=====Monitoramento=====|======Configuração======|=======Busca=======|"
echo "+-----------------------+------------------------+-------------------+"
echo "|1 =       CPU          |6 =     Threshold       |9 =  Usuários      |"
echo "|2 =     Memória        |7 = 	Processos        |10 = Permissões    |"
echo "|3 = Memória Virtual    |8 = 	  Sair           |                   |"
echo "|4 =      Disco         |                        |                   |"
echo "|5 =      Rede          |                        |                   |"
echo "|	                |                        |                   |"
echo "+-----------------------+------------------------+-------------------+"

read -p "--> " escolha
case $escolha in
1) export NMON=c ; nmon; sleep 2; clear; main;; #Executa a função de análise de CPU do NMON
2) export NMON=m ; nmon; sleep 2; clear; main;; #Executa a função de análise de Memória do NMON
3) export NMON=V ; nmon; sleep 2; clear; main;; #Executa a função de análise de Memória Virtual do NMON
4) export NMON=d ; nmon; sleep 2; clear; main;; #Executa a função de análise de Disco do NMON
5) export NMON=n ; nmon; sleep 2; clear; main;; #Executa a função de análise de Rede do NMON
6) clear;
   read -p "Digite o valor de threshold minimo: " threshold_minimo
   read -p "Digite o valor de threshold maximo: " threshold_maximo

   echo "Verificando os recursos de CPU, Memoria RAM e Disco Rigido ... ";
   CPU_1=$(top -b -n 1 | grep %Cpu | tr -s " " | cut -d " " -f 4| cut -d "," -f1);
   CPU_2=$(top -b -n 1 | grep %Cpu | tr -s " " | cut -d " " -f 4| cut -d "," -f2);
   MEM_TOTAL=$(top -b -n 1 | grep buff/cache | tr -s " " | cut -d " " -f 4);
   MEM_OCUPADA=$(top -b -n 1 | grep buff/cache | tr -s " " | cut -d " " -f 6);
   DISCO=$(df | grep /dev/sda | tr -s " " | cut -d " " -f5 | cut -d "%" -f1);
   CPU_OCUPADA=$CPU_1.$CPU_2;
   CPU_CONTA=$( echo 100 - $CPU_OCUPADA | bc -l);
   MEM_CONTA=$( echo "($MEM_OCUPADA * 100) / $MEM_TOTAL" | bc -l );
   DISCO_CONTA=$( echo 100 - $DISCO | bc -l );
   MEM_CONTA2=$( echo 100 - $MEM_CONTA | bc -l);
  #Verifica a quantidade de Processamento Utilizado
 echo -e "\nUSO de CPU em %: $CPU_OCUPADA\n";
 echo -e "USO de Memoria RAM em %: $MEM_CONTA2\n";
 echo -e "USO de Disco em %: $DISCO\n\n";


  if [ $(echo "$CPU_OCUPADA <= $threshold_minimo" | bc -l) == 1 ];then
	  echo -e "Seu consumo de CPU está abaixo de $threshold_minimo%\n"; 
   fi

   if [ $(echo "$CPU_OCUPADA > $threshold_minimo" | bc -l) == 1 ] && [ $(echo "$CPU_OCUPADA < $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de CPU está entre $threshold_minimo% e $threshold_maximo%\n";
   fi
   
   if [ $(echo "$CPU_OCUPADA > $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de CPU está acima de $threshold_maximo%\n";
   fi 

  #Verifica a quantidade de memoria utilizado
   
  if [ $(echo "$MEM_CONTA2 <= $threshold_minimo" | bc -l) == 1 ];then
	  echo -e "Seu consumo de Memoria RAM está abaixo de $threshold_minimo%\n"; 
   fi

   if [ $(echo "$MEM_CONTA2 > $threshold_minimo" | bc -l) == 1 ] && [ $(echo "$MEM_CONTA < $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de Memoria RAM está entre $threshold_minimo% e $threshold_maximo%\n";
   fi
   if [ $(echo "$MEM_CONTA2 > $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de Memoria RAM está acima de $threshold_maximo%\n";
   fi 
#Verifica a quantidade de disco utilizado

  if [ $(echo "$DISCO <= $threshold_minimo" | bc -l) == 1 ];then
	  echo -e "Seu consumo de Disco está abaixo de $threshold_minimo%\n"; 
   fi

   if [ $(echo "$DISCO > $threshold_minimo" | bc -l) == 1 ] && [ $(echo "$DISCO < $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de CPU está entre $threshold_minimo% e $threshold_maximo%\n";
   fi
   if [ $(echo "$DISCO > $threshold_maximo" | bc -l) == 1 ];then
	   echo -e "Seu consumo de CPU está acima de $threshold_maximo%\n";
   fi 
   sleep 10;
   clear;
	main;;

7)chkprocessos;

;;	
8) clear;echo "Programa finalizado";sleep 2;exit;;
9) findusr;;
10) chkperm;;
*) clear; echo "Opção inválida"; sleep 2; clear; main;;
esac
}

#Inicia a função Main
main
