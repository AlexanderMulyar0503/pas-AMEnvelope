# AMEnvelope

Создание поздравительных конвертов


## Возможности
- Добавление картинок и текста
- Печать конвертов


## Сборка
```
lazbuild --build-mode <build_mode> ./AMEnvelope.lpi
```

Режимы сборки:
- Default_win - версия для Windows
- Default_gtk - версия для Linux с интерфейсом gtk2
- Default_qt - версия для Linux с интерфкйсом qt5


## Зависимости
Для сборки и запуска qt5-версии программы необходимо установить:
- __*libqt5pas-dev*__ для Debian, Ubuntu
- __*qt5pas-devel*__ для Fedora
