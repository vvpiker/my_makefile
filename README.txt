Структура проекта

Предполагается, что исходники лежат в папке src/:
project/
├── src/
│   ├── main.c
│   └── utils.c
├── include/          # если есть заголовки
│   └── utils.h
└── Makefile



Использование
# Полная проверка и сборка (по умолчанию)
make

# Только быстрая проверка clang
make clang-check

# Только глубокий анализ cppcheck
make cppcheck

# Только сборка (без проверок)
make build

# Сборка с ASan + UBSan (обязательно с чистого листа!)
make clean && make SANITIZE=1 build

# Запуск с флагами времени выполнения
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 \
UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1 ./program

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
--enable=all включает все проверки, 
--error-exitcode=1 заставляет make упасть при любом замечании, 
а --suppress=missingIncludeSystem убирает ложные срабатывания на системных заголовках .
