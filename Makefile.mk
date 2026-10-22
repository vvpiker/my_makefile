# ==============================================================================
# Компиляторы и инструменты
# ==============================================================================
CC        = gcc
CPPCHECK  = cppcheck

# ==============================================================================
# Флаги
# ==============================================================================
# Строгие флаги предупреждений для C99
CFLAGS   += -Werror
CFLAGS   += -Wpedantic
CFLAGS   += -std=c99 -Wall -Wextra
CFLAGS   += -Wstrict-prototypes
# CFLAGS   += -Wshadow -Wconversion -Wsign-conversion
# CFLAGS   += -Wcast-qual -Wmissing-prototypes
# CFLAGS   += -Wold-style-definition -Wvla -Wformat=2 -Wundef
# CFLAGS   += -Wpointer-arith -Wwrite-strings -Wdouble-promotion
# CFLAGS   += -Wfloat-equal -Wswitch-enum

# Флаги cppcheck
CPPCHECK_FLAGS = --std=c99 \
                 --enable=warning,style,portability,performance \
                 --force \
                 --error-exitcode=1 \
                 --suppress=missingIncludeSystem \
                 --quiet
                 # --inconclusive

# ==============================================================================
# Санитайзеры (ASan + UBSan)
# ==============================================================================
# По умолчанию отключены. Включаются через SANITIZE=1.
SANITIZE ?= 0

ifeq ($(SANITIZE),1)
  CFLAGS   += -fsanitize=address,undefined
  CFLAGS   += -fno-omit-frame-pointer
  CFLAGS   += -fno-sanitize-recover=all
  LDFLAGS  += -fsanitize=address,undefined
endif

# Флаги времени выполнения для ASan/UBSan
SANITIZER_ENV = ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 \
                UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1

# ==============================================================================
# Файлы
# ==============================================================================
# Автоматический поиск всех .c файлов в src/
SRCS      := $(wildcard ./*.c)
OBJS      := $(SRCS:.c=.o)
TARGET    := program

# ==============================================================================
# Основные цели
# ==============================================================================

# Цель по умолчанию: полная проверка и сборка
all: check build

# Только сборка
build: $(TARGET)

# Финальная сборка
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

# Компиляция объектных файлов
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# ==============================================================================
# Статические проверки
# ==============================================================================

# Полная проверка: clang (быстро) + cppcheck (глубоко)
check: clang-check cppcheck

# Быстрая проверка синтаксиса и предупреждений clang
clang-check:
	@echo "==> Running clang syntax check..."
	$(CC) $(CFLAGS) -fsyntax-only $(SRCS)

# Глубокий статический анализ cppcheck
cppcheck:
	@echo "==> Running cppcheck..."
	$(CPPCHECK) $(CPPCHECK_FLAGS) $(SRCS)

# ==============================================================================
# CI
# ==============================================================================

ci:
	@bash scripts/ci.sh

# ==============================================================================
# Очистка
# ==============================================================================

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all build check clang-check cppcheck ci clean
