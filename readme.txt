---в IDEA---
установка плагина
Ctrl+Shit+A -> Plugins -> Perl
//https://github.com/Camelcade/Perl5-IDEA/wiki

для работы отладчика нужно
---в консоли xubuntu---
проверить версию и наличие perl
$ perl -v

установить CPAN
$ sudo perl -MCPAN -e shell

установить модуль (для отладки в IDEA) через CPAN
$ sudo cpan
> install "Devel::Camelcadedb"
> quit