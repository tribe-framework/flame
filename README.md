# Tribe - a web project management framework.

Tribe is a project management framework that allows us to build platforms, products, applications and web interfaces, using a modular approach. It provides a coherent language for UX, content and design collaborations.

## Minimum system requirements
- independent cloud or dedicated server
- php 8
- 1gb ram
- 1 core
- ubuntu 20.04
- make your server ready for tribe using - https://github.com/tribe-framework/ubuntu-server

## Install Tribe
```
bash -c "$(wget --no-cache --no-cookie https://raw.githubusercontent.com/tribe-framework/tribe/master/install/install.sh -O -)"
```

## Configure Ember apps' domains and subdomains on the server
```
bash -c "$(wget --no-cache --no-cookie https://raw.githubusercontent.com/tribe-framework/tribe/master/install/ember.sh -O -)"
```

#### Upgrade instructions
- To upgrade from exiting tribe projects, update composer.json and copy files auth.php, api.php, uploads.php and index.php to the root folder of the existing project

### Database structure
1. there are 2 tables - data and meta. both tables have same table structure
2. tribe uses json heavily, the need for creating new tables is eleminated by use of json
3. the column 'content' uses json, example usage:
```$sql->executeSQL("SELECT \`id\` FROM \`data\` WHERE \`content\`->'$.type'='user'");```
4. data table stores all posts', post-types' and users' data
5. meta table is for plugins to use as the developers deem fit, it can be used for web analytics data, to store user sessions or any other use-case

### NginX config
- nginx config is available at /etc/nginx/sites-available/&lt;domain.tld&gt;

## Uninstall
```
bash -c "$(wget --no-cache --no-cookie https://raw.githubusercontent.com/tribe-framework/tribe-uninstall/master/uninstall.sh -O -)"
```
more info on uninstall - https://github.com/tribe-framework/tribe-uninstall