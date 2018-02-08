FROM dragontek/octobercms:latest

# install the PHP extensions we need
RUN apt-get update && apt-get install -y zsh && rm -rf /var/lib/apt/lists/*

RUN composer global require jakoch/composer-fastfetch

RUN cd /usr/src/october \
      && sed -i -e 's/phpunit": "~/phpunit":">/g' composer.json \
      && sed -i -e 's/phpunit-selenium": "~/phpunit-selenium":">/g' composer.json \
      && composer update --no-interaction --prefer-dist

ENV WWW_DATA_UID 33
RUN usermod -u $WWW_DATA_UID www-data

RUN chsh -s /bin/zsh root
RUN chsh -s /bin/zsh www-data

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN su - www-data -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

COPY docker-entrypoint.sh /usr/local/bin/

# ENTRYPOINT resets CMD
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
