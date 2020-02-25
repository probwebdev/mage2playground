# Magento 2 Playground   
**NOTE**: This is not a _one click install_ and requires additional setup.   
Dev environment to play with Magento 2, Vue Storefront, PWA Studio   
Default Magento 2 stack for this project is: Traefik 2.1, Varnish 6.0, Nginx, PHP 7.3, MariaDB 10.2, Elasticsearch 6.8, Redis 5

## Quick Reference
### Project setup
Copy **.dist.env** to **.env**. Please make sure that ports from env file aren't used by host system. Don't forget to set your user UID-GID so there won't be an issue with file permissions. UID-GID can be changes during build time and runtime.     
Copy **config/cli/mage2cli.dist.env** to **config/cli/mage2cli.env**   
Copy **config/db/mage2db.dist.env** to **config/db/mage2db.env**      
Copy **config/traefik/traefik.dist.yml** to **config/traefik/traefik.yml**   
Copy **config/nginx/mage2playground.dist.nginx** to **config/nginx/mage2playground.nginx**   
Copy **config/elasticsearch/elasticsearch.dist.yml** to **config/elasticsearch/elasticsearch.yml**   
Copy **config/varnish/default.vcl.dist** to **config/varnish/default.vcl**   
Copy **config/mage2/composer.json**, **config/mage2/composer.lock**, **config/mage2/auth.json** to **/mage2** and add generated tokens from [Magento Marketplace](https://marketplace.magento.com/). Steps how to do it can be found [here](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html)   
Create external volume `docker volume create mariadb-data`   
Add following lines to **/etc/hosts**:
```
127.0.0.1 mage2playground.docker
127.0.0.1 traefik.mage2playground.docker
127.0.0.1 elastic.mage2playground.docker
127.0.0.1 mailhog.mage2playground.docker
```

### Install and Run Magento 2
From the Project root run command `docker-compose run --rm cli mage2install.sh`   
When previous step is finished run `docker-compose up -d` to start Magento 2 stack   
Optionally you can add Kibana instance by using `docker-compose.kibana.yml`   
e.g `docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d`   
Open your browser and go to http://mage2playground.docker. To access admin dashboard go to **/admin** page. Default creds are _admin/admin123_ (can be changed in mage2cli.env file before installation).
Other services available at address added above.   

#### Notes   
Magento recommend to use Elasticsearch as Catalog Search engine. You can set it up in Admin Dashboard:
- Stores->Configuration->Catalog->Catalog->Catalog Search  
- Choose Elasticsearch 6.0+ and **elasticsearch** as hostname  

To preform Magento 2 manipulations you can use special container, the one you used above to install Magento.   
That container have pre-installed **magento** command, **composer** and **n98-magerun2** and can be accessed either while project is active via `docker exec -itu magento mage2playground_cli_1 <command>`, either as a standalone container:   
- e.g magento `docker-compose run --rm cli magento cache:clean`   
- or n98-magerun2 `docker-compose run --rm cli n98-magerun2 sys:info`   

### Install and Run Vue Storefront (VSF 1.11+)
#### Setup
Copy **config/vsf/mage2vsf.dist.env** to **config/vsf/mage2vsf.env**   
From the `project` dir run following commands:
- `git clone https://github.com/DivanteLtd/vue-storefront.git mage2vsf` and checkout to latest stable release (git checkout tags/v1.11.1 -b v1.11.1)
- `git clone https://github.com/DivanteLtd/vue-storefront-api.git mage2vsf-api` and checkout to latest stable release
- From inside **project/mage2vsf-api** folder run `git clone https://github.com/magento/magento2-sample-data.git var/magento2-sample-data`
- Add following lines to **/etc/hosts**:   
```
127.0.0.1 vuestorefront.docker
127.0.0.1 api.vuestorefront.docker
127.0.0.1 elastic.vuestorefront.docker
```
Setup Magento API https://docs.vuestorefront.io/guide/installation/magento.html   
Copy example configuration files:
- **config/vsf/vue-storefront.local.json.dist** to **project/mage2vsf/config/local.json**
- **config/vsf/vue-storefront-api.local.json.dist** to **project/mage2vsf-api/config/local.json**
- **docker/vsf/docker/Dockerfile** to both **project/mage2vsf/** and **project/mage2vsf-api/**
- **docker/vsf/vue-storefront/docker-entrypoint.sh** to **project/mage2vsf/**
- **docker/vsf/vue-storefront-api/docker-entrypoint.sh** to **project/mage2vsf-api/**
- Populate **project/mage2vsf-api/config/local.json** with Magento API tokens like stated in [Docs](https://docs.vuestorefront.io/guide/installation/magento.html#fast-integration)
- Run `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f compose/docker-compose.vsf.yml up -d`
- Import data from Magento to Vue Storefront by running proper commands inside storefront-api container (read https://docs.vuestorefront.io or project github). Probably you should run something like `yarn restore7 && yarn migrate && yarn mage2vs import`   
e.g `docker exec -it mage2playground_vsf-api_1 ash` and run those two commands inside   
- Go to http://vuestorefront.docker in your docker-compose.vsf.ymlbrowser to see initial setup  

#### Notes     
Native indexer [Magento 2 Data Indexer](https://github.com/DivanteLtd/magento2-vsbridge-indexer)    
Reviews sync [Magento 2 Review API](https://github.com/DivanteLtd/magento2-review-api) 

### Install and Run PWA Studio
**NOTE**: Before deploying PWA Studio you should completely remove Magento Sample Data and use instead [Venia Sample Data](https://magento-research.github.io/pwa-studio/venia-pwa-concept/install-sample-data/)   
Copy **config/venia/mage2venia.dist.env** to **config/venia/mage2venia.env**   
From the `project` dir run following commands:
- `https://github.com/magento-research/pwa-studio.git mage2venia` and checkout to latest stable release
- Update `mage2venia/packages/venia-concept/deployVeniaSampleData.sh` script with proper github url `githubBaseUrl='https://github.com/PMET-public'`. You can run it inside **cli** container to deploy sample data but don't forget to mount it as volume(refer to compose/docker-compose.venia.yml)
- Copy from `docker/venia` **venia.Dockerfile** and **pwa-studio.sh** into cloned `mage2venia` dir (replace default Dockerfile)
- Add following line to **/etc/hosts**:   
```
127.0.0.1 venia.docker
```
- Run `docker-compose -f docker-compose.yml -f docker-compose.override.yml -f compose/docker-compose.venia.yml up -d`
- Go to http://venia.docker in your browser to see initial setup   

## Useful Links
- Magento 2 configuration guide https://devdocs.magento.com/guides/v2.3/config-guide/bk-config-guide.html
- Vue Storefront Docs https://docs.vuestorefront.io
- PWA Studio https://magento-research.github.io/pwa-studio/

## Credits
meanbee/docker-magento2 https://github.com/meanbee/docker-magento2
