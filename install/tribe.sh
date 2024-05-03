installpath1=$(echo "install_path" | sed 's/\//\\\//g');

#--------CORE CHANGES BEGIN---------#

wget --no-cache --no-cookie https://raw.githubusercontent.com/tribe-framework/types.json/master/types.json;
mv types.json install_path/xyz.com/config/;

cp install_path/xyz.com/install/tribe-nginx.conf /etc/nginx/sites-available/xyz.com;
sed -i 's/your_server_ip/ipv4_address/g' /etc/nginx/sites-available/xyz.com;
sed -i 's/your_server_base_dir/xyz.com/g' /etc/nginx/sites-available/xyz.com;
sed -i 's/your_server_domain/xyz.com/g' /etc/nginx/sites-available/xyz.com;
ln -s /etc/nginx/sites-available/xyz.com /etc/nginx/sites-enabled/xyz.com;

certbot --agree-tos --no-eff-email --email admin_email --nginx -d xyz.com;

cp install_path/xyz.com/.env.sample install_path/xyz.com/.env;
sed -i 's/xyz-domain-var/xyz.com/g' install_path/xyz.com/.env;
sed -i 's/xyz-db-name-var/mysql_w_user/g' install_path/xyz.com/.env;
sed -i 's/xyz-db-pass-var/mysql_w_pass/g' install_path/xyz.com/.env;
sed -i 's/xyz-port-var/xyz_port/g' install_path/xyz.com/.env;
sed -i 's/your_server_email/admin_email/g' install_path/xyz.com/.env;
sed -i "s/xyz-install-path/$installpath1/g" install_path/xyz.com/.env;
echo "CREATE USER 'mysql_w_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql_w_pass'; FLUSH PRIVILEGES;" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
echo "CREATE DATABASE mysql_w_user CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
echo "GRANT ALL PRIVILEGES on mysql_w_user.* to 'mysql_w_user'@'localhost';" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
mysql -umysql_w_user -pmysql_w_pass mysql_w_user < install_path/xyz.com/install/install.sql;

rm install_path/xyz.com/install -R;
rm install_path/xyz.com/.env.sample;
chown www-data: install_path/xyz.com/uploads -R;
composer create-project phpmyadmin/phpmyadmin install_path/xyz.com/phpmyadmin;
composer update;
service nginx restart;

#--------CORE CHANGES END---------#