FROM dragontek/octobercms:latest

# install the PHP extensions we need
RUN apt-get update && apt-get install -y zsh && rm -rf /var/lib/apt/lists/*

RUN composer global require jakoch/composer-fastfetch

RUN cd /usr/src/october \
      && sed -i -e 's/phpunit": "~/phpunit":">/g' composer.json \
      && sed -i -e 's/phpunit-selenium": "~/phpunit-selenium":">/g' composer.json \
      && composer update --no-interaction --prefer-dist

#UID set for volume permissions
ENV WWW_DATA_UID 33
RUN usermod -u $WWW_DATA_UID www-data

#change shell for users root and www-data to zsh
RUN chsh -s /bin/zsh root
RUN chsh -s /bin/zsh www-data

#pull Oh My ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN su - www-data -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

#change theme for Oh my ZSH to flazz
RUN sed -i "s/robbyrussell/flazz/g" {~root,~www-data}/.zshrc

#Add some helpful aliasses for users root and www-data
RUN echo 'alias procesy="ps aux | grep -v grep | grep -i"' >> {~root,~www-data}/.zshrc
RUN echo 'alias hgrep="history | grep"' >> {~root,~www-data}/.zshrc
RUN echo 'alias gacm="git add --all && git commit -m"' >> {~root,~www-data}/.zshrc
RUN echo 'alias pa="php artisan"' >> {~root,~www-data}/.zshrc
RUN echo 'alias papr="php artisan plugin:refresh"' >> {~root,~www-data}/.zshrc
RUN echo 'alias :q="exit"' >> {~root,~www-data}/.zshrc

COPY docker-entrypoint.sh /usr/local/bin/

# ENTRYPOINT resets CMD
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
