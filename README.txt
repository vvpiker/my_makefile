Структура проекта

Предполагается, что исходники лежат в папке src/:
project/
├── scripts/
│   ├── ci.sh              # главный скрипт CI
│   ├── build.sh           # обычная сборка
│   ├── static-check.sh    # clang-check + cppcheck
│   └── sanitize.sh        # сборка и запуск с ASan + UBSan
├── src/
│   ├── main.c
│   └── utils.c
├── include/          # если есть заголовки
│   └── utils.h
└── Makefile

* scripts/build.sh        — local build without sanitizers (dev only)
* scripts/static-check.sh — clang syntax check + cppcheck static analysis
* scripts/sanitize.sh     — clean rebuild with ASan+UBSan, then run
* scripts/ci.sh           — CI entry: static checks followed by sanitized run

Использование

# Полная проверка и сборка (по умолчанию)
make
или
bash scripts/static-check.sh
bash scripts/build.sh

# Только быстрая проверка clang
make clang-check

# Только глубокий анализ cppcheck
make cppcheck

# Полная прокерка
make check
или
bash scripts/static-check.sh

# Только сборка (без проверок)
make build
или
bash scripts/build.sh

# Сборка с ASan + UBSan (обязательно с чистого листа!)
make clean && make SANITIZE=1 build
или
bash scripts/sanitize.sh

# Запуск санитайзеров с аргументами программы
bash scripts/sanitize.sh input.txt --verbose


# Запуск CI

# Локально — через Makefile
make ci

# Локально — напрямую
bash scripts/ci.sh


# Очистка
make clean


Как это работает
    make all — это главная цель. Она сначала запускает check (обе проверки), 
и только при успехе — build. 
Если clang или cppcheck найдут ошибку, make остановится и не будет компилировать битый код .



    clang-check использует флаг -fsyntax-only. 
Это заставляет компилятор пройти все этапы анализа и проверки типов, но не генерировать объектные файлы. 
Это очень быстро и отсеивает синтаксические ошибки до запуска тяжёлого cppcheck .


    cppcheck запускается со строгими флагами:

--enable=
warning: Серьезные ошибки, приводящие к неопределенному поведению или утечкам. Например, разыменование nullptr, выход за границы массива, утечки памяти.
style: Стилистические проблемы и «мертвый» код. Например, неиспользуемые переменные/функции, избыточные условия, неправильная область видимости.
performance: Советы по оптимизации. Например, передача больших объектов по значению вместо ссылки, лишние копирования.
portability: Проблемы переносимости между платформами (32/64 бита, разные компиляторы). Например, предположение о размере типа или платформозависимое поведение.

--error-exitcode=1 заставляет make упасть при любом замечании, 
а --suppress=missingIncludeSystem убирает ложные срабатывания на системных заголовках .
