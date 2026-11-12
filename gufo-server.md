# GUFO Server Practice
## Information
**Github repo**: https://github.com/gufo-org/gufo

**Image URI**: ghcr.io/gufo-org/toolboxes/gufo-runtime:0.34.0

**Documentation**: https://github.com/gufo-org/gufo/tree/main/docs

## Run in container
Qwen3.8-27B
```bash
docker run --rm \
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

Qwen3.8-Flash-Next
```bash
docker run --rm \
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


Muse Glimmer 30B
```bash
```