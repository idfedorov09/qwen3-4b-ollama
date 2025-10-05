# Qwen3-4B Ollama Stack

This repository provisions Ollama with the `Qwen3-4B` model baked into the image (`unsloth/Qwen3-4B-Instruct-2507-GGUF:Q4_K_M`). The stack targets fast local or server-side inference via Docker Compose.

## Features
- Automated Ollama image build with the model preloaded.
- Ready-to-run `docker-compose.yml` exposing the API on port 11434.
- Health check that keeps the container alive and restarts it if the model becomes unavailable.

## Requirements
- Docker 24 or newer.
- Docker Compose v2+.
- At least 8 GB of free disk space for the image and model cache.

## Quick Start
1. Clone the repository and move into the project directory.
2. Build and launch the stack:
   ```bash
   docker compose up -d --build
   ```
3. Inspect the container status and model load:
   ```bash
   docker compose ps
   docker compose logs ollama
   ```
4. Confirm the API is reachable:
   ```bash
   curl http://localhost:11434/api/tags
   ```

## Usage
- Call the model through the Ollama REST API:
  ```bash
  curl http://localhost:11434/api/generate \
    -d '{"model":"qwen3-4b","prompt":"Hello"}'
  ```
- Python example with LangChain:
  ```python
  from langchain_ollama import ChatOllama

  llm = ChatOllama(
      model="qwen3-4b",
      base_url="http://localhost:11434",
  )

  response = llm.invoke("Tell me a short fact about Qwen.")
  print(response.content)
  ```
- Tail container logs: `docker compose logs -f ollama`
- Stop the stack: `docker compose down`

## Configuration
- The Ollama version, Hugging Face repository, and quantization level are controlled via build arguments in `docker-compose.yml` / `Dockerfile`:
  - `OLLAMA_VERSION` — base Ollama image.
  - `HF_REPO` — source model repository on Hugging Face (defaults to `unsloth/Qwen3-4B-Instruct-2507-GGUF`).
  - `QUANT` — quantization variant.
- Update the values in the `build.args` block and rebuild if you want a different model.

## Project Structure
- `Dockerfile` — two-stage build: the first stage downloads the model, the second stage produces the runtime image.
- `docker-compose.yml` — service definition for `ollama`, port 11434 mapping, and persistent `ollama` volume.
- `README.md` — documentation you are reading now.

## Maintenance
- Update the model: adjust the build arguments and run `docker compose build`.
- Clear the model cache: `docker volume rm qwen3-4b_ollama` (stop the container first).
- Scale or customize: extend `docker-compose.yml` with additional environment variables or services as needed.

## Useful Links
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Hugging Face — unsloth/Qwen3-4B-Instruct-2507-GGUF](https://huggingface.co/unsloth/Qwen3-4B-Instruct-2507-GGUF)
