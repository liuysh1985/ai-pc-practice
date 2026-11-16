# AGENTS.md

**Repo:** Local LLM practice & reference on AMD Strix Halo 395 mini PC. Docs-only — no code, no build, no tests.

## Key facts

- **Models live at:** `$HOME/LLM_Practice/models/` on the host
- **Python venv:** `$HOME/LLM_Practice/py3-venv` (HuggingFace CLI, aria2)
- **Scripts dir:** `$HOME/LLM_Practice/scripts/` (hfd mirror script)
- **Host IP:** `192.168.34.66` (the mini PC)

## Server quick reference

All servers in `local-llm-servers.md`.

| Server | Port | Image |
|--------|------|-------|
| llama.cpp | 8080 | `ghcr.io/ggml-org/llama.cpp:server-vulkan` |
| Halogen Flash | 8731 | `ghcr.io/peonist-ai/halogen-flash-server:0.19.1` |
| Gufo | 8080 | `ghcr.io/gufo-org/toolboxes/gufo-runtime:0.34.0` |

Group IDs on the host: `video: 44`, `render: 990` (may vary per machine).

## Models & their locations

| Model | Path | Speculative |
|-------|------|-------------|
| Halogen Qwen3.8 Flash Next (v2) | `models/halogen-qwen3.8-v2/` | — |
| Qwen3.8-27B (UD) | `models/qwen38-27b/` | dflash2 |
| Qwen3.8-27B (DFlash2) | `models/qwen38-27b-dflash2/` | — |
| Qwen3.8-Flash-Next (GGUF) | `models/qwen38-flash-next/` | MTP |
| Muse Glimmer 30B | `models/muse-glimmer-30b/` | dflash |
| Qwen3.6-35B-A3B | `models/qwen36-35b-a3b/` | MTP |

## OpenCode providers (opencode.jsonc)

- `llama` → `192.168.34.66:58080` (default model: Qwen3.6-35B-A3B)
- `halogen` → `192.168.34.66:58731` (Qwen3.8 Flash Next)
- `gufo` → `192.168.34.66:58080` (Qwen3.8 27B / Flash Next, reasoning models)

## Common gotchas

- **VRAM/GTT setup** is non-trivial: 8GB UMA in BIOS + `ttm.pages_limit=28835840` kernel param. See `system-setup.md`.
- **Desktop disabled by default** (`multi-user.target`). Start with `sudo systemctl start gdm3`.
- **Docker needs device access:** `--device /dev/kfd --device /dev/dri --group-add 44 --group-add 990 --ulimit memlock=-1`.
- **Model download from China:** use `hfd` (hf-mirror.com) alias, not `hf` directly.
- **Docker Compose files:** none. All servers run via `docker run`.
