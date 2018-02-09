FROM dragontek/octobercms:7.1-apache

RUN composer global require hirak/prestissimo

RUN cd /usr/src/october \
      && sed -i -e 's/phpunit": "~/phpunit":">/g' composer.json \
      && sed -i -e 's/phpunit-selenium": "~/phpunit-selenium":">=/g' composer.json \
      && composer update phpunit/phpunit phpunit/phpunit-selenium --with-dependencies --no-interaction --prefer-dist \
      && chown -R www-data:www-data .

#Add some helpful aliasses for users root and www-data
RUN echo 'alias procesy="ps aux | grep -v grep | grep -i"' >> ~root/.bashrc \
         && echo 'alias hgrep="history | grep"' >> ~root/.bashrc \
         && echo 'alias pa="php artisan"' >> ~root/.bashrc \
         && echo 'alias papr="php artisan plugin:refresh"' >> ~root/.bashrc \
         && echo 'alias :q="exit"' >> ~root/.bashrc

RUN echo 'alias procesy="ps aux | grep -v grep | grep -i"' >> ~www-data/.bashrc \
         && echo 'alias hgrep="history | grep"' >> ~www-data/.bashrc \
         && echo 'alias pa="php artisan"' >> ~www-data/.bashrc \
         && echo 'alias papr="php artisan plugin:refresh"' >> ~www-data/.bashrc \
         && echo 'alias :q="exit"' >> ~www-data/.bashrc

#UID set for volume permissions
ENV WWW_DATA_UID 33
RUN usermod -u $WWW_DATA_UID www-data

RUN chown -R www-data:www-data ~www-data

COPY init-docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["init-docker-entrypoint.sh"]
CMD ["apache2-foreground"]
