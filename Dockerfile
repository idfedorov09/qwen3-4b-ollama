ARG OLLAMA_VERSION=latest
ARG HF_REPO=unsloth/Qwen3-4B-Instruct-2507-GGUF
ARG QUANT=Q4_K_M

########################################
# Stage 1: builder — предзагрузка модели
########################################
FROM ollama/ollama:${OLLAMA_VERSION} AS builder
ARG HF_REPO
ARG QUANT

RUN bash -lc '\
  set -euo pipefail; \
  (ollama serve >/tmp/ollama.log 2>&1 &) ; \
  for i in $(seq 1 120); do ollama list >/dev/null 2>&1 && break; sleep 1; done; \
  echo ">>> Pull hf.co/${HF_REPO}:${QUANT}"; \
  ollama pull hf.co/${HF_REPO}:${QUANT}; \
  # делаем читаемое имя модели через cp (официальная команда CLI)
  ollama cp hf.co/${HF_REPO}:${QUANT} qwen3-4b; \
  ollama show qwen3-4b >/dev/null \
'

########################################
# Stage 2: runtime — финальный образ
########################################
FROM ollama/ollama:${OLLAMA_VERSION}
ARG HF_REPO
ARG QUANT

COPY --from=builder /root/.ollama /root/.ollama

ENV OLLAMA_HOST=0.0.0.0
EXPOSE 11434

HEALTHCHECK --interval=30s --timeout=10s --retries=5 \
  CMD ollama show qwen3-4b >/dev/null 2>&1 || exit 1

CMD ["serve"]
