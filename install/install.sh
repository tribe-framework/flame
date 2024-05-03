#Initialising install path and IP address of host
installpath="/var/www/html";
installpath1=$(echo "$installpath" | sed 's/\//\\\//g');
ipv4address=$(hostname -I);

#Initialising colours
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

#user input for directory details
read -p "MySQL Root Username: " mysqluser;
echo "MySQL Root Password:";
read -s mysqlpass;
read -p "Tribe Domain: " tribedomain;
read -p "Tribe Certbot Email Address: " adminemail;
read -p "Tribe MySQL Database Name: " mysqlwuser;
echo "Tribe MySQL Database Password:";
read -s mysqlwpass;

#ARE YOU SURE prompt
#yes, no or cancel
read -rp "You're about to create a folder, NginX config and MySQL database for $tribedomain at location $installpath/$tribedomain. Are you sure you wish to proceed [y/n/c]: ";

#choosing cancelled in ARE YOU SURE prompt
[[ ${REPLY,,} =~ ^(c|cancel|C|CANCEL|Cancel)$ ]] && {
	echo "Website not created. Action cancelled.";
	exit 1;
}

#choosing yes in ARE YOU SURE prompt
if [[ ${REPLY,,} =~ ^(y|yes|Y|YES|Yes)$ ]]; then

	if [ -d "$installpath/$tribedomain/" ];
	then
		echo "${red}ERROR:${reset} A directory already exists on the path $installpath/$tribedomain.";
	else
	
		if [ -n "$tribedomain" ] && [ -n "$mysqluser" ] && [ -n "$mysqlpass" ] && [ -n "$mysqlwuser" ] && [ -n "$adminemail" ] && [ -n "$mysqlwpass" ]
		then
			#get tribe from github
			git clone https://github.com/tribe-framework/tribe.git $installpath/$tribedomain;

			#remove .git folder
			cd $installpath/$tribedomain;
			rm -rf .git;

			#prepare tribe.sh for execution
			#replace placeholders with user inputs in tribe.sh file
			sed -i "s/xyz.com/$tribedomain/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/ipv4_address/$ipv4address/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/mysql_root_user/$mysqluser/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/mysql_root_pass/$mysqlpass/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/admin_email/$adminemail/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/install_path/$installpath1/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/mysql_w_user/$mysqlwuser/g" $installpath/$tribedomain/install/tribe.sh;
			sed -i "s/mysql_w_pass/$mysqlwpass/g" $installpath/$tribedomain/install/tribe.sh;

			#run tribe.sh
			bash $installpath/$tribedomain/install/tribe.sh;

			#display success message
			echo -e "\r\n### -----------------\r\n";
			echo "${green}Website successfully created.${reset}";
			echo -e "\r\n### -----------------\r\n";
		
		else
			echo "${red}ERROR:${reset} Website details not defined. All fields are compulsory. Please try again.";
		fi

	fi

#choosing no or invalid input in ARE YOU SURE prompt
else
	echo "Website not created. Action cancelled.";
fi