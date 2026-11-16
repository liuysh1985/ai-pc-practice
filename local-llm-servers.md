# Local LLM Servers

Reference for running local LLM inference servers on the Strix Halo 395 mini PC. All servers run via Docker.

> **Group IDs** on this host: `video: 44`, `render: 990` (may differ per machine).
> **Models directory:** `$HOME/LLM_Practice/models/`

---

## llama.cpp (ggml)

| | |
|---|---|
| **Repo** | https://github.com/ggml-org/llama.cpp |
| **Image** | `ghcr.io/ggml-org/llama.cpp:server-vulkan` |
| **Port** | 8080 |

**Run Qwen3.6-35B-A3B:**

```bash
docker run -d --rm \
  --memory="64g" \
  --memory-swap="64g" \
  --device=/dev/dri \
  --group-add 44 --group-add 990 \
  -v $HOME/LLM_Practice/models/qwen36-35b-a3b:/models:ro \
  -p 8080:8080 \
  ghcr.io/ggml-org/llama.cpp:server-vulkan \
  -m /models/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf \
  --alias Qwen3.6-35B-A3B \
  --reasoning-budget 0 \
  -ngl 99 \
  -fa on \
  -c 65536 \
  -ctk q8_0 -ctv q8_0 \
  --spec-type draft-mtp \
  --spec-draft-n-max 2 \
  --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 \
  --host 0.0.0.0 --port 8080
```

---

## Halogen Flash Server

| | |
|---|---|
| **Repo** | https://github.com/peonist-ai/halogen-flash-server |
| **Image** | `ghcr.io/peonist-ai/halogen-flash-server:0.19.1` |
| **Docs** | https://github.com/peonist-ai/halogen-flash-server/tree/main/docs |
| **Port** | 8731 |

**Run:**

```bash
docker run -d --rm -p 8731:8731 \
  --device /dev/kfd --device /dev/dri --group-add 44 --group-add 990 \
  --ipc=host --ulimit memlock=-1:-1 \
  -e HALOGEN_CHECKPOINT=/models/qwen38-flash-next-v2.hgn \
  -e HALOGEN_VISION_TOWER=/models/qwen38-flash-next-vision.hgn \
  -e HALOGEN_DOWNLOAD=0 \
  -v $HOME/LLM_Practice/models/halogen-qwen3.8-v2:/models:ro \
  ghcr.io/peonist-ai/halogen-flash-server:0.19.1
```

---

## Gufo Server

| | |
|---|---|
| **Repo** | https://github.com/gufo-org/gufo |
| **Image** | `ghcr.io/gufo-org/toolboxes/gufo-runtime:0.34.0` |
| **Docs** | https://github.com/gufo-org/gufo/tree/main/docs |
| **Port** | 8080 |

### Qwen3.8-27B (with dflash2 speculative decoding)

```bash
docker run -d --rm \
  -u 1000:1000 \
  --device /dev/kfd \
  --device /dev/dri \
  --group-add 44 --group-add 990 \
  --ulimit memlock=-1 \
  -p 8080:8080 \
  -v $HOME/LLM_Practice/models:/models:ro \
  ghcr.io/gufo-org/toolboxes/gufo-runtime:0.34.0 \
  gufo serve --host 0.0.0.0 --port 8080 llm \
  --model /models/qwen38-27b/Qwen3.8-27B-UD-Q4_K_XL.gguf \
  --speculative dflash2 \
  --dflash-model /models/qwen38-27b-dflash2/Qwen3.8-27B-DFlash2-Q4_K_M.gguf
```

### Qwen3.8-Flash-Next (with MTP speculative decoding)

```bash
docker run -d --rm \
  -u 1000:1000 \
  --device /dev/kfd \
  --device /dev/dri \
  --group-add 44 --group-add 990 \
  --ulimit memlock=-1 \
  -p 8080:8080 \
  -v $HOME/LLM_Practice/models:/models:ro \
  ghcr.io/gufo-org/toolboxes/gufo-runtime:0.34.0 \
  gufo serve --host 0.0.0.0 --port 8080 llm \
  --model /models/qwen38-flash-next/UD-Q4_K_XL/Qwen3.8-Flash-Next-UD-Q4_K_XL-00001-of-00004.gguf \
  --speculative mtp \
  --mtp-model /models/qwen38-flash-next/MTP/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf
```

### Muse Glimmer 30B

> Command pending — model downloaded but run command not yet recorded.

---

## Quick comparison

| Server | Port | Speculative | Best for |
|--------|------|-------------|----------|
| llama.cpp | 8080 | MTP | Qwen3.6-35B-A3B, general purpose |
| Halogen Flash | 8731 | — (native) | Qwen3.8 Flash Next, vision + text |
| Gufo | 8080 | dflash2 / MTP | Qwen3.8-27B, multi-model swapping |
