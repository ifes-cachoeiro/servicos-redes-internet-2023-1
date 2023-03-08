#!/bin/bash

OPC=100

opcInvalida(){
        clear
        echo "Opção Inválida!"
        read -p "Pressione ENTER para continuar"
}

admUsuarios(){
	OPC1=100
	while [ $OPC1 -ne 0 ];do
		clear
		echo " ----------------------------------"
		echo "# 1 - Cadastrar Usuário            #"
		echo "# 2 - Remover Usuário              #"
		echo "# 3 - Definir Senha                #"
		echo "# 4 - Adicionar usuário a um grupo #"
		echo "# 5 - Remover usuário de um grupo  #"
		echo "# 6 - Listar usuários              #"
		echo "# 0 - Voltar                       #"
		echo " ----------------------------------"
		read -p "Informe uma opção: " OPC1
		case $OPC1 in
			1) clear
			   read -p "Informe o nome do usuário: " NOME
			   sudo useradd $NOME
			   ;;
			2) clear
			   read -p "Informe o nome do usuário: " NOME
			   sudo userdel $NOME
			   ;;
			3) clear
			   read -p "Informe o nome do usuário: " NOME
			   sudo passwd $NOME
			   ;;
			4) clear 
			   read -p "Informe o nome do usuário: " NOME
			   read -p "Informe o nome do grupo: " GRUPO
			   sudo gpasswd -a $NOME $GRUPO
			   ;;
			5) clear
			   read -p "Informe o nome do usuário: " NOME
			   read -p "Informe o nome do grupo: " GRUPO
			   sudo gpasswd -d $NOME $GRUPO
			   ;;
			6) cat /etc/passwd | cut -d: -f 1 | more
			   ;;
			0) echo;;
			*) opcInvalida;;
		esac
	done	
}
admRede(){
	OPC1=100
	while [ $OPC1 -ne 0 ];do
		clear
		echo " ------------------------------------"
		echo "# 1 - Listar interfaces de rede     #"
		echo "# 2 - Configurar interface de rede  #"
		echo "# 3 - Adicionar/Remover rota        #"
		echo "# 4 - Listar rotas                  #"
		echo "# 5 - Configurar DNS                #"
		echo "# 6 - Testar conectividade          #"
		echo "# 0 - Sair                          #"
		echo " -----------------------------------"
		read -p "Informe uma opção: " OPC1
		case $OPC1 in
			1) clear
			   ip addr && read -p "Enter para continuar"
			   ;;
			2) clear
			   read -p "Tipo de configuracao (1) manual (2) dhcp: " TIPO
			   if [ $TIPO -eq 1 ];then
				   read -p "Informe o nome da Interface: " IFACE
				   read -p "Informe o IP/MASK: " ENDREDE
				   read -p "Informe o Gateway: " GATEWAY
				   sudo ip addr add $ENDREDE dev $IFACE
				   sudo ip link set up dev $IFACE
				   echo "Interface configurada com sucesso!"
			   elif [ $TIPO -eq 2 ];then
				   read -p "Informe o nome da Interface: " IFACE
				   sudo dhclient $IFACE
		           fi
			   read -p "=> Pressione ENTER para continuar <="
			   ;;
			3) clear
			   read -p "Informe (1) adicionar (2) remover: " TIPO
			   if [ $TIPO -eq 1 ];then
				   read -p "Informe a rede destino: " REDE
				   read -p "Informe o IP do gateway: " GATEWAY
				   sudo ip route add $REDE via $GATEWAY
				   echo "Rota criada com sucesso!"
			   elif [ $TIPO -eq 2 ];then
				   read -p "Informe a rede destino: " REDE
				   read -p "Informe o IP do gateway: " GATEWAY
				   sudo ip route del $REDE via $GATEWAY
				   echo "Rota removida com sucesso!"
		    	   fi
			   read -p "=> Pressione ENTER para continuar <="
			   ;;
			4) clear
			   ip route
			   read -p "=> Pressione ENTER para continuar <="
			   ;;
			5) clear
			   read -p "Informe o endereço do DNS: " DNS
			   sudo su -c "echo 'nameserver $DNS' > /etc/resolv.conf"
			   read -p "=> Pressione ENTER para continuar <="
			   ;;
			6) clear
			   ping -c 4 8.8.8.8
			   read -p "=> Pressione ENTER para continuar <="
			   ;;
			0) echo;;
			*) opcInvalida;;
		esac	
	done
}
admServ(){
	clear
	OPC1=100
	while [ $OPC1 -ne 0 ];do
		clear
		echo " ------------------------------------"
		echo "# 1 - Listar servicos               #"
		echo "# 2 - Iniciar um servico            #"
		echo "# 3 - Parar um servico               #"
		echo "# 4 - Habilitar inicializacao serv  #"
		echo "# 5 - Desabilitar inic servico      #"
		echo "# 0 - Sair                          #"
		echo " ------------------------------------"
		read -p "Informe uma opção: " OPC1
		case $OPC1 in
			1) # sudo systemctl --type=service --state=running
			   ;;
			2) # sudo systemctl start $servico.service
			   ;;
			3) # sudo systemctl stop ssh.service
			   ;;
			4) # sudo systemctl enable ssh.service
			   ;;
			5) # sudo systemctl disable ssh.service
			   ;;
			0) echo;;
			*) opcInvalida;;
		esac	
	done
}

menu(){
	clear
	echo "##############################"
	echo "###	   MENU   	 ###"
	echo "##############################"
	echo "# 1 - Administrar Usuários   #"
	echo "# 2 - Administrar Rede       #"
	echo "# 3 - Administrar Serviços   #"
	echo "# 0 - Sair                   #"
	echo "##############################"
	read -p "# Informe um valor: " OPC
	case $OPC in
		1) admUsuarios;;
		2) admRede;;
		3) admServ;;
		0) echo "Saindo...";;
		*) opcInvalida;;
	esac
}

while [ $OPC -ne 0 ];do 
	menu
done
