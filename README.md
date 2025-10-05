# Qwen3-4B Ollama Stack

Этот репозиторий разворачивает Ollama со встроенной моделью `Qwen3-4B` (квантованная сборка `unsloth/Qwen3-4B-Instruct-2507-GGUF:Q4_K_M`). Проект рассчитан на быстрый запуск инференса локально или на сервере через Docker Compose.

## Возможности
- Автоматическая сборка образа Ollama c предзагруженной моделью.
- Готовый `docker-compose.yml` с публикацией API на 11434 порту.
- Healthcheck, который следит за доступностью модели и перезапускает контейнер при сбоях.

## Требования
- Docker 24+.
- Docker Compose v2+
- Не менее 8 ГБ свободного места под образ и модель.

## Быстрый старт
1. Склонируйте репозиторий и перейдите в каталог проекта.
2. Соберите и поднимите стек:
   ```bash
   docker compose up -d --build
   ```
3. Проверьте состояние контейнера и загрузку модели:
   ```bash
   docker compose ps
   docker compose logs ollama
   ```
4. Убедитесь, что API отвечает:
   ```bash
   curl http://localhost:11434/api/tags
   ```

## Использование
- Вызов модели через стандартный Ollama API:
  ```bash
  curl http://localhost:11434/api/generate \
    -d '{"model":"qwen3-4b","prompt":"Hello"}'
  ```
- Логи контейнера: `docker compose logs -f ollama`
- Остановка: `docker compose down`

## Настройка
- Версия Ollama, репозиторий модели и квантование задаются через аргументы сборки в `docker-compose.yml` / `Dockerfile`:
  - `OLLAMA_VERSION` — базовый образ Ollama.
  - `HF_REPO` — исходный репозиторий на Hugging Face (по умолчанию `unsloth/Qwen3-4B-Instruct-2507-GGUF`).
  - `QUANT` — вариант квантования модели.
- Чтобы изменить модель, исправьте значения в блоке `build.args` и пересоберите образ.

## Структура проекта
- `Dockerfile` — двухстадийная сборка: на первом этапе скачивается модель, на втором формируется финальный образ.
- `docker-compose.yml` — описание сервиса `ollama`, проброс порта 11434, монтирование volume `ollama` для кэша моделей.
- `README.md` — текущий файл с инструкциями.

## Обслуживание
- Обновление модели: поменяйте переменные и выполните `docker compose build`.
- Очистка кэша моделей: `docker volume rm qwen3-4b_ollama` (контейнер должен быть остановлен).
- Масштабирование: добавьте переменные окружения или дополнительные сервисы в `docker-compose.yml` при необходимости.

## Полезные ссылки
- [Документация Ollama](https://github.com/ollama/ollama)
- [Hugging Face — unsloth/Qwen3-4B-Instruct-2507-GGUF](https://huggingface.co/unsloth/Qwen3-4B-Instruct-2507-GGUF)
