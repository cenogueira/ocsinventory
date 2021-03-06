#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 29/09/2016
# Versão: 0.10
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Instalação do OCS Inventory Server
# Instalação do OCS Inventory Reports
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do ocs_server.sh
LOG="/var/log/ocs_server.log"
#
# Variável da Data Inicial para calcular tempo de execução do Script
DATAINICIAL=`date +%s`
#
# Validando o ambiente, verificando se o usuário e "root"
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`

if [ "$USUARIO" == "0" ]
then
	if [ "$UBUNTU" == "16.04" ]
		then
			if [ "$KERNEL" == "4.4" ]
				then
					 clear
					 
					 # Variáveis de configuração do OCS Inventory Server e Reports
					 OCSVERSION="2.2.1/OCSNG_UNIX_SERVER-2.2.1.tar.gz"
					 OCSTAR="OCSNG_UNIX_SERVER-2.2.1.tar.gz"
					 OCSINSTALL="OCSNG_UNIX_SERVER-2.2.1"
					 
					 #Exportando a variável do Debian Frontend Noninteractive para não solicitar interação com o usuário
					 export DEBIAN_FRONTEND=noninteractive
					 
					 echo -e "Usuário é `whoami`, continuando a executar o ocs_server.sh"
					 echo
					 echo  ============================================================ >> $LOG
					 
					 echo -e "Download do OCS Inventory Server do Github, pressione <Enter> para continuar"
					 read
					 sleep 2
					 echo -e "Aguarde, fazendo o download..."
					 #Fazendo o download do código fonte do OCS Inventory Server
					 wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/$OCSVERSION &>> $LOG
					 #Descompactando o arquivos do OCS Inventory Server
					 tar -zxvf $OCSTAR &>> $LOG
					 #Acessando a pasta do OCS Inventory
					 cd $OCSINSTALL
					 echo -e "CUIDADO com as opções que serão solicitadas no decorrer da instalação."
					 echo -e "Download do OCS Inventory Server feito com Sucesso!!!, pressione <Enter> para instalar"
					 echo
					 read
					 clear
					 #Executando a instalação do OCS Inventory Server e Reports
					 ./setup.sh
					 #MENSAGENS QUE SERÃO SOLICIDATAS NA INSTALAÇÃO DO OCS INVENTORY SERVER:
					 #01. Do you wish to continue ([y]/n): y <-- digite y pressione <Enter>;
					 #02. Which host is running database server [localhost]?: Deixe o padrão pressione <Enter>;
					 #03. On which port is running database server [3306]?: Deixe o padrão pressione <Enter>;
					 #04. Where is Apache daemon binary [/usr/sbin/apache2ctl]?: Deixe o padrão pressione <Enter>;
					 #05. Where is Apache main configuration file [/etc/apache2/apache2.conf]?: Deixe o padrão pressione <Enter>;
					 #06. Which user account is running Apache Web Server [www-data]?: Deixe o padrão pressione <Enter>;
					 #07. Which user group is running Apache web server [www-data]?: Deixe o padrão pressione <Enter>;
					 #08. Where is Apache Include configuration directory [/etc/apache2/conf-available]?: Deixe o padrão pressione <Enter>;
					 #09. Where is PERL Intrepreter binary [/usr/bin/perl]?: Deixe o padrão pressione <Enter>;
					 #10. Do you wish to setup Communication server on this computer ([y]/n)?: y <-- digite y pressione <Enter>;
					 #11. Where to put Communication server log directory [/var/log/ocsinventory-server]?: Deixe o padrão pressione <Enter>;
					 #12. Where to put Communication server plugins configuration files [/etc/ocsinventory-server/plugins]?: Deixe o padrão pressione <Enter>;
					 #13. Where to put Communication server plugins Perl module files [/etc/ocsinventory-server/perl]?: Deixe o padrão pressione <Enter>;
					 #MENSAGEM: NÃO SE PREOCUPE COM A MENSAGEM DE ERRO DO Apache2::SOAP PERL module..
					 #14. Do you wish to continue ([y]/n)?: y <-- digite y pressione <Enter>;
					 #15. Do you allow Setup renaming Communication Server Apache configuration file to 'z-ocsinventory-server.conf' ([y]/n)?: y <-- digite y pressione <Enter>;
					 #16. Do you wish to setup Administration Server (Web Administration Console) on this computer ([y]/n)?: y <-- digite y pressione <Enter>;
					 #17. Do you wish to continue ([y]/n)?: y <-- digite y pressione <Enter>;
					 #18. Where to copy Administration Server static files for PHP Web Console [/usr/share/ocsinventory-reports]?: Deixe o padrão pressione <Enter>;
					 #19. Where to create writable/cache directories for deployment packages administration console logs, IPDiscover and SNMP [/var/lib/ocsinventory-reports]?: Deixe o padrão pressione <Enter>;
					 #APÓS A INSTALAÇÃO VIA NAVEGADOR, REMOVER O ARQUIVO install
					 #Atualizando as informações do Apache2 para o suporte ao OCS Inventory Server e Reports
					 a2dissite 000-default
					 #Habilitando o conf do OCS Inventory Reports no Apache2
					 a2enconf ocsinventory-reports
					 #Habilitando o conf do OCS Inventory Server no Apache2
					 a2enconf z-ocsinventory-server
					 #Reinicializando o Apache2
					 sudo service apache2 restart
					 #Saindo do diretório do OCS Iventory
					 cd ..
					 echo
					 echo -e "Instalação do OCS Inventory Server e Reports feito com Sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Atualizando os arquivos de configuração do OCS Inventory Server"
					 echo
					 echo -e "Editando o arquivo do OCS Inventory Server, pressione <Enter> para continuar"
					 #Arquivo de configuração do Servidor do OCS Inventory que vai receber as atualização do Clientes
					 read
					 #Fazendo o backup do arquivo de configuração original
					 cp -v /etc/apache2/conf-available/z-ocsinventory-server.conf /etc/apache2/conf-available/z-ocsinventory-server.conf.bkp &>> $LOG
					 #Atualizando para o novo arquivo de configuração
					 cp -v conf/z-ocsinventory-server.conf /etc/apache2/conf-available/ &>> $LOG
					 #Editando o arquivo de configuração
					 vim /etc/apache2/conf-available/z-ocsinventory-server.conf
					 echo -e "Arquivo editado com Sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo do OCS Inventory Server DBConfig, pressione <Enter> para continuar"
					 #Arquivo de configuração para conexão com o Banco de Dados do MySQL
					 #Configuração das variáveis de usuário e senha do banco de dados: database name (ocsweb) e user (ocs)
					 read
					 #Esse arquivo será recriado novamente após a instalação via navegador
					 #Fazendo o backup do arquivo de configuração original
					 cp -v /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php.bkp &>> $LOG
					 #Atualizando para o novo arquivo de configuração
					 cp -v conf/dbconfig.inc.php /usr/share/ocsinventory-reports/ocsreports/ &>> $LOG
					 #Editando o arquivo de configuração
					 vim /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php
					 echo -e "Arquivo editado com Sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo do MySQL Server, pressione <Enter> para continuar"
					 #Arquivo de configuração do Banco de Dados do MySQL Server
					 #Permitir acesso aremoto ao MySQL comentando a linha: bind-address
					 read
					 #Fazendo o backup do arquivo de configuração original
					 cp -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.bkp &>> $LOG
					 #Atualizando para o novo arquivo de configuração
					 cp -v conf/mysqld.cnf /etc/mysql/mysql.conf.d/ &>> $LOG
					 #Editando o arquivo de configuração
					 vim /etc/mysql/mysql.conf.d/mysqld.cnf
					 #Reinicializando o serviço do MySQL Server
					 sudo service mysql restart
					 echo -e "Arquivo editado com Sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo do PHP, pressione <Enter> para continuar"
					 #Arquivo de configuração do PHP que será utilizado pelo Apache2
					 #Aumentar os valores das váriaveis: post_max_size e upload_max_filesize para: 250MB
					 read
					 #Fazendo o backup do arquivo de configuração original
					 cp -v /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2/php.ini.bkp &>> $LOG
					 #Atualizando para o novo arquivos de configuração
					 cp -v conf/php.ini /etc/php/7.0/apache2/ &>> $LOG
					 #Editando o arquivo de configuração
					 vim /etc/php/7.0/apache2/php.ini
					 #Reinicializando o serviço do Apache2
					 sudo service apache2 restart
					 echo -e "Arquivo editado com Sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Removendo aplicativos desnecessários, aguarde..."
					 #Removendo arquivos que não são mais utilizados
					 apt-get autoremove &>> $LOG
					 echo -e "Aplicativos removidos com Sucesso!!!, continuando com o script!!!"
					 echo
					 echo ============================================================ >> $LOG

					 echo -e "Limpando o Cache do Apt-Get, aguarde..."
					 #Limpando o diretório de cache do apt-get
					 apt-get clean &>> $LOG
					 echo -e "Cache Limpo com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG

					 echo -e "Fim do ocs_server.sh em: `date`" >> $LOG
					 echo -e "Instalação do OCS Inventory Server Feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do ocs_server.sh
						 DATAFINAL=`date +%s`
						 SOMA=`expr $DATAFINAL - $DATAINICIAL`
						 RESULTADO=`expr 10800 + $SOMA`
						 TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do ocs_server.sh: $TEMPO"
					 echo -e "Pressione <Enter> para reinicializar o servidor: `hostname`"
					 read
					 sleep 2
					 reboot
					 else
						 echo -e "Versão do Kernel: $KERNEL não homologada para esse script, versão: >= 4.4 "
						 echo -e "Pressione <Enter> para finalizar o script"
						 read
			fi
	 	 else
			 echo -e "Distribuição GNU/Linux: `lsb_release -is` não homologada para esse script, versão: $UBUNTU"
			 echo -e "Pressione <Enter> para finalizar o script"
			 read
	fi
else
	 echo -e "Usuário não é ROOT, execute o comando com a opção: sudo -i <Enter> depois digite a senha do usuário `whoami`"
	 echo -e "Pressione <Enter> para finalizar o script"
	read
fi
