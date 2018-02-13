# About this Repo

This automated build is based on [Dragontek/octobercms](https://github.com/Dragontek/octobercms) with `apache` and `PHP 7.1`. Those scripts and `docker-compose.yml` should be used only on local development environments.

Scripts in repo work only on Linux systems and have been tested only on Archlinux. All contribution welcomed.

# Changes to `dragontek/octobercms`
1. Plugin to composer: [hirak/prestissimo](https://github.com/hirak/prestissimo).
2. Updated version of `phpunit` and `phpunit-selenium` in `composer.json` file for plugin [Initbiz.Selenium2Tests](https://octobercms.com/plugin/initbiz-selenium2tests)
3. User www-data has a changable UID
4. User www-data has /bin/bash shell
5. Bash script to generate `docker-compose.yml` file

# How to
1. Clone the repo to empty directory for example: `git clone https://github.com/initbizlab/octobercms-docker myproject`
1. Run `sudo ./dock-october.sh <domain> <username>` where `<domain>` is your local development domain to be added to `/etc/hosts` file and `<username>` is name of the local user that is going to develop the project. In my case: `sudo ./dock-october.sh local tomasz`. Optionally you can also pass project name in the first parameter.
1. The `docker-compose.yml` is now created. Now you can edit it as you wish and then run `sudo docker-compose up`

Now the source code is in `./source` directory, and DB files in `./mysqldata` directory.

Your project will be visible on `<project_name>.<domain>` and `phpMyAdmin` panel on `phpMyAdmin.<project_name>.<domain>` domain.

All those scripts are aimed to be used only on local development environment. You should not use them in production.

# Troubleshooting
There is a bug in `dragontek/octobercms` with edge updates enabled that fails the first time you start it. After the container stops working you can just stop all the containers and run themh again: `sudo docker-compose stop` and `sudo docker-compose start`.

# Limitations
Because of the fact that `nginx-proxy` works on port 80 by default, only one instance of this container can be run. If you want to run more than one project you have to ensure the `nginx-proxy` container will not be listed in `docker-compose.yml`. The container has access to docker's socket, so it does not matter where you run the container, it will work.

# Additional Env vars
* `WWW_DATA_UID` - for workaround with permissions in volumes
