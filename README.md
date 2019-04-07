# Magento 2 Playground   
Dev environment to play with Magento 2, Vue Storefront, PWA Studio   
Default Magento 2 stack for this project is: Varnish 5.2, Nginx, PHP-FPM 7.2, MariaDB 10.3, Elasticsearch 5.6, Redis 5

## Quick Reference
### Project setup
Copy **.env.dist** to **.env**. Please make sure that ports from env file aren't used by host system  
Copy **auth.json.dist** to **auth.json** and add generated tokens from [Magento Marketplace](https://marketplace.magento.com/). Steps how to do it can be found [here](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html)   
Create external volume `docker volume create mariadb`   
Add following line to **/etc/hosts** -> `127.0.0.1 mage2playground.docker`

### Install and Run Magento 2
From the Project root run command `docker-compose run --rm cli mage2install`   
When previous step is finished run `docker-compose up -d` to start Magento 2 stack   
Optionally you can add Kibana instance by using `docker-compose.kibana.yml`   
e.g `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker/kibana/docker-compose.kibana.yml up -d`   
Open your browser and go to http://mage2playground.docker. To access admin dashboard got to **/admin** page. Default creds are _admin/admin123_ (can be changed in env file before installation)   

#### Notes   

Magento recommend to use Elasticsearch as Catalog Search engine. You can set it up in Admin Dashboard:
- Stores-Configuration-Catalog-Catalog-Catalog Search  
- Choose Elasticsearch 5.0+ and **elasticsearch** as hostname  

To preform Magento 2 manipulations you can use special container, the one you used above to install Magento.   
That container have pre-installed **composer** and **n98-magerun2**:   
- e.g Composer `docker-compose run --rm cli composer update`   
- or n98-magerun2 `docker-compose run --rm cli n98-magerun2 sys:info`   

After Magento 2 installation you also will have access to **magento cli**:   
- e.g `docker-compose run --rm cli magento cache:clean`

### Install and Run Vue Storefront
#### Setup
From the Project root run following commands:
- `git clone https://github.com/DivanteLtd/vue-storefront.git vue-storefront` and checkout to latest stable release
- `git clone https://github.com/DivanteLtd/vue-storefront-api.git vue-storefront-api` and checkout to latest stable release
- From inside **vue-storefront-api** folder run `git clone https://github.com/magento/magento2-sample-data.git var/magento2-sample-data`
- Add following line to **/etc/hosts** -> `127.0.0.1 vue-s8t-api`

Setup Magento API https://docs.vuestorefront.io/guide/installation/magento.html   
Copy example configuration files:
- docker/vuestorefront/config/vue-storefront.local.json.dist to vue-storefront/config/local.json
- docker/vuestorefront/config/vue-storefront-api.local.json.dist to vue-storefront-api/config/local.json
- Populate vue-storefront-api/config/local.json with Magento API tokens like stated in [Docs](https://docs.vuestorefront.io/guide/installation/magento.html#fast-integration)
- Run `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker/vuestorefront/docker-compose.vue.yml -f docker/kibana/docker-compose.kibana.yml up -d`
- Go to localhost:3000 in your browser to see initial setup 
- Import data from Magento to Vue Storefront by running following command inside vue-s8t-api container `yarn mage2vs import` with following after that `yarn setup`   
e.g `docker exec mage2playground_vue-s8t-api_1 ash` and run those two commands inside

## Useful Links
- Magento 2 configuration guide https://devdocs.magento.com/guides/v2.3/config-guide/bk-config-guide.html
- Vue Storefront Docs https://docs.vuestorefront.io

## Credits
meanbee/docker-magento2 https://github.com/meanbee/docker-magento2
