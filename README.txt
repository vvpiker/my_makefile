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

# Очистка
make clean
