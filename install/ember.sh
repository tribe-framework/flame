installpath="/var/www/html";
installpath1=$(echo "$installpath" | sed 's/\//\\\//g');

#Initialising colours
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

#user input for directory details
read -p "Tribe Domain: " tribedomain;
read -p "Ember App Certbot Email Address: " adminemail;
read -p "Ember App Domain: " emberdomain;
read -p "Ember App Dir in applications/<dir-name>: " emberdir;

emberpath1=$(echo "$tribedomain/applications/$emberdir/dist" | sed 's/\//\\\//g');

#ARE YOU SURE prompt
#yes, no or cancel
read -rp "You're about to install NginX config for $emberdomain. Are you sure you wish to proceed [y/n/c]: ";

#choosing cancelled in ARE YOU SURE prompt
[[ ${REPLY,,} =~ ^(c|cancel|C|CANCEL|Cancel)$ ]] && {
	echo "Ember App NginX not created. Action cancelled.";
	exit 1;
}

#choosing yes in ARE YOU SURE prompt
if [[ ${REPLY,,} =~ ^(y|yes|Y|YES|Yes)$ ]]; then

	if [ -n "$tribedomain" ] && [ -n "$adminemail" ] && [ -n "$emberdomain" ] && [ -n "$emberdir" ]
	then
		#ember nginx conf + certbot
		cd ~;
		rm /etc/nginx/sites-available/$emberdomain;
		rm /etc/nginx/sites-enabled/$emberdomain;
		wget --no-cache --no-cookie https://raw.githubusercontent.com/tribe-framework/tribe/master/install/ember-nginx.conf;
		mv ember-nginx.conf /etc/nginx/sites-available/$emberdomain;
		sed -i 's/your_server_ember_domain/'"${emberdomain}"'/g' /etc/nginx/sites-available/$emberdomain;
		sed -i 's/your_server_tribe_dir/'"${tribedomain}"'/g' /etc/nginx/sites-available/$emberdomain;
		sed -i 's/your_server_ember_dir/'"${emberpath1}"'/g' /etc/nginx/sites-available/$emberdomain;
		ln -s /etc/nginx/sites-available/$emberdomain /etc/nginx/sites-enabled/$emberdomain;
		certbot --agree-tos --no-eff-email --email $adminemail --nginx -d $emberdomain;
		service nginx restart;

		#display success message
		echo -e "\r\n### -----------------\r\n";
		echo "${green}Ember App NginX successfully created.${reset}";
		echo -e "\r\n### -----------------\r\n";
	
	else
		echo "${red}ERROR:${reset} Ember App details not defined. All fields are compulsory. Please try again.";
	fi

#choosing no or invalid input in ARE YOU SURE prompt
else
	echo "Ember App not created. Action cancelled.";
fi