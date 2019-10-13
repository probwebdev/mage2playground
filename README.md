# Magento 2 Playground   
Dev environment to play with Magento 2, Vue Storefront, PWA Studio   
Default Magento 2 stack for this project is: Traefik 2.0, Varnish 6.0, Nginx, PHP 7.3, MariaDB 10.2, Elasticsearch 6.8, Redis 5

## Quick Reference
### Project setup
Copy **.env.dist** to **.env**. Please make sure that ports from env file aren't used by host system. Don't forget to set your user UID-GID so there won't be an issue with file permissions. UID-GID can be changes during build time and runtime.  
Copy **docker/cli/mage2cli.env.dist** to **docker/cli/mage2cli.env**   
Copy **docker/db/mage2db.env.dist** to **docker/db/mage2db.env**      
Copy **docker/traefik/traefik.dist.yml** to **docker/traefik/traefik.yml**   
Copy **docker/nginx/config/mage2playground.conf.dist** to **docker/nginx/config/mage2playground.conf**   
Copy **docker/elasticsearch/config/elasticsearch.yml.dist** to **docker/elasticsearch/config/elasticsearch.yml**   
Copy **docker/varnish/config/default.vcl.dist** to **docker/varnish/config/default.vcl**   
Copy **mage2/auth.json.dist** to **mage2/auth.json** and add generated tokens from [Magento Marketplace](https://marketplace.magento.com/). Steps how to do it can be found [here](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html)   
Create external volume `docker volume create mariadb`   
Add following lines to **/etc/hosts**:
```
127.0.0.1 mage2playground.docker
127.0.0.1 traefik.mage2playground.docker
127.0.0.1 elastic.mage2playground.docker
127.0.0.1 mailhog.mage2playground.docker
```

### Install and Run Magento 2
From the Project root run command `docker-compose run --rm cli mage2install`   
When previous step is finished run `docker-compose up -d` to start Magento 2 stack   
Optionally you can add Kibana instance by using `docker-compose.kibana.yml`   
e.g `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker/kibana/docker-compose.kibana.yml up -d`   
Open your browser and go to http://mage2playground.docker. To access admin dashboard go to **/admin** page. Default creds are _admin/admin123_ (can be changed in mage2cli.env file before installation).
Other services available at address added above.   

#### Notes   
Magento recommend to use Elasticsearch as Catalog Search engine. You can set it up in Admin Dashboard:
- Stores-Configuration-Catalog-Catalog-Catalog Search  
- Choose Elasticsearch 5.0+ and **elasticsearch** as hostname  

To preform Magento 2 manipulations you can use special container, the one you used above to install Magento.   
That container have pre-installed **magento** command, **composer** and **n98-magerun2**:   
- e.g magento `docker-compose run --rm cli magento cache:clean`   
- or n98-magerun2 `docker-compose run --rm cli n98-magerun2 sys:info`   

### Install and Run Vue Storefront (postponed until 1.11 release with Elasticsearch 7 support)
#### Setup
Copy **docker/vuestorefront/mage2vue.env.dist** to **docker/vuestorefront/mage2vue.env**   
From the Project root run following commands:
- `git clone https://github.com/DivanteLtd/vue-storefront.git mage2vue` and checkout to latest stable release
- `git clone https://github.com/DivanteLtd/vue-storefront-api.git mage2vue-api` and checkout to latest stable release
- From inside **mage2vue-api** folder run `git clone https://github.com/magento/magento2-sample-data.git var/magento2-sample-data`
- Add following lines to **/etc/hosts**:   
```
127.0.0.1 storefront.docker
127.0.0.1 api.storefront.docker
```
Setup Magento API https://docs.vuestorefront.io/guide/installation/magento.html   
Copy example configuration files:
- **docker/vuestorefront/config/vue-storefront.local.json.dist** to **mage2vue/config/local.json**
- **docker/vuestorefront/config/vue-storefront-api.local.json.dist** to **mage2vue-api/config/local.json**
- Populate **mage2vue-api/config/local.json** with Magento API tokens like stated in [Docs](https://docs.vuestorefront.io/guide/installation/magento.html#fast-integration)
- Run `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker/vuestorefront/docker-compose.vue.yml -f docker/kibana/docker-compose.kibana.yml up -d`
- Go to http://mage2vue.docker in your browser to see initial setup 
- Import data from Magento to Vue Storefront by running following command inside vue-s8t-api container `yarn mage2vs import` with following `yarn setup`   
e.g `docker exec mage2playground_vue-s8t-api_1 ash` and run those two commands inside   
- Go to http://storefront.docker in your browser to see initial setup  

#### Notes   
At the moment of writing Vue Storefront don't support Elasticsearch 6+   
Native indexer [Magento 2 Data Indexer](https://github.com/DivanteLtd/magento2-vsbridge-indexer)    
Reviews sync [Magento 2 Review API](https://github.com/DivanteLtd/magento2-review-api) 

### Install and Run PWA Studio
**NOTE**: Before deploying PWA Studio you should completely remove Magento Sample Data and use instead [Venia Sample Data](https://magento-research.github.io/pwa-studio/venia-pwa-concept/install-sample-data/)   
Copy **docker/pwa-studio/mage2pwa.env.dist** to **docker/pwa-studio/mage2pwa.env**   
From the Project root run following commands:
- `https://github.com/magento-research/pwa-studio.git mage2pwa` and checkout to latest stable release
- Update `mage2pwa/packages/venia-concept/deployVeniaSampleData.sh` script with proper github url `githubBaseUrl='https://github.com/PMET-public'`. You can run it inside **cli** container to deploy sample data but don't forget to mount it as volume(refer to docker/pwa-studio/docker-compose.pwa.yml)
- Copy from `docker/pwa-studio` **Dockerfile** and **pwa-studio.sh** into cloned `mage2pwa` dir (replace default Dockerfile)
- Add following line to **/etc/hosts**:   
```
127.0.0.1 venia.docker
```
- Go to http://venia.docker or http://localhost:8080 in your browser to see initial setup   

## Useful Links
- Magento 2 configuration guide https://devdocs.magento.com/guides/v2.3/config-guide/bk-config-guide.html
- Vue Storefront Docs https://docs.vuestorefront.io
- PWA Studio https://magento-research.github.io/pwa-studio/

## Credits
meanbee/docker-magento2 https://github.com/meanbee/docker-magento2
