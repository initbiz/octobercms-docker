# About this Repo

This automated build is based on [Dragontek/octobercms](https://github.com/Dragontek/octobercms) and should be used only on local development environments.

Here we have PHP 7.1 with Apache.

# Improvements
* I have added a plugin to composer: [jakoch/composer-fastfetch](https://github.com/jakoch/composer-fastfetch).
* Updated version of `phpunit` and `phpunit-selenium` in `composer.json` file for plugin [Initbiz.Selenium2Tests](https://octobercms.com/plugin/initbiz-selenium2tests)
* Installed ZSH shell and changed default one for `root` and `www-data` users (sometimes we want to move around) to zsh with [Oh my ZSH](https://github.com/robbyrussell/oh-my-zsh)


# Additional Env vars

* `WWW_DATA_UID` - for permissions in volumes
