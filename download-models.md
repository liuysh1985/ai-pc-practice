# Download Models

## Prerequisites

1. Install dependencies:

```bash
sudo apt install -y python3-pip python3-venv aria2
```

2. Create Python venv and install HuggingFace CLI:

```bash
mkdir -p $HOME/LLM_Practice/{scripts,py3-venv}
python3 -m venv $HOME/LLM_Practice/py3-venv
source $HOME/LLM_Practice/py3-venv/bin/activate
pip install -U "huggingface_hub[cli]"  # 2.3.0+
alias hf=$HOME/LLM_Practice/py3-venv/bin/hf
hf version
```

3. Install mirror download script (for China):

```bash
wget https://hf-mirror.com/hfd/hfd.sh -O $HOME/LLM_Practice/scripts/hfd.sh && chmod +x $HOME/LLM_Practice/scripts/hfd.sh
alias hfd=$HOME/LLM_Practice/scripts/hfd.sh
```

## Model Reference

| Model | Source | Local Path |
|-------|--------|------------|
| Halogen Qwen3.8 Flash Next (v2) | `peonist-ai/halogen-qwen3.8-flash-next` | `models/halogen-qwen3.8-v2/` |
| Qwen3.8-27B (UD) | `unsloth/Qwen3.8-27B-GGUF` | `models/qwen38-27b/` |
| Qwen3.8-27B (DFlash2) | `z-lab/Qwen3.8-27B-DFlash2-GGUF` | `models/qwen38-27b-dflash2/` |
| Qwen3.8-Flash-Next (GGUF) | `unsloth/Qwen3.8-Flash-Next-GGUF` | `models/qwen38-flash-next/` |
| Muse Glimmer 30B | `meta-models/Muse-Glimmer-30B-GGUF` | `models/muse-glimmer-30b/` |
| Qwen3.6-35B-A3B (MTP) | `unsloth/Qwen3.6-35B-A3B-MTP-GGUF` | `models/qwen36-35b-a3b/` |

## Download Commands

```bash
# Use mirror (set for China)
export HF_ENDPOINT=https://hf-mirror.com

# Auth (requires HK/SG proxy if in China)
hf auth login

# Halogen Qwen3.8 Flash Next (v2) — includes mtp, vision, ngram
hfd peonist-ai/halogen-qwen3.8-flash-next \
  --include "qwen38-flash-next-v2.hgn" \
  --include "qwen38-flash-next-ngram.hgn" \
  --include "qwen38-flash-next-mtp.hgn" \
  --include "qwen38-flash-next-vision.hgn" \
  --include "tokenizer/*" \
  --local-dir $HOME/LLM_Practice/models/halogen-qwen3.8-v2 \
  --tool aria2c -x 10

# Qwen3.8-27B (UD)
hfd unsloth/Qwen3.8-27B-GGUF \
  --revision ce331efc48d5722b4b8041f72793e530eae18d9b \
  --include "Qwen3.8-27B-UD-Q4_K_XL.gguf" \
  --include "mmproj-BF16.gguf" \
  --local-dir $HOME/LLM_Practice/models/qwen38-27b \
  --tool aria2c -x 10

# Qwen3.8-27B (DFlash2)
hfd z-lab/Qwen3.8-27B-DFlash2-GGUF \
  --revision 2d9571f8ce46e151f61c6499c99dee6079e1d610 \
  --include "Qwen3.8-27B-DFlash2-Q4_K_M.gguf" \
  --local-dir $HOME/LLM_Practice/models/qwen38-27b-dflash2 \
  --tool aria2c -x 10

# Qwen3.8-Flash-Next (GGUF) — includes MTP shared model
hfd unsloth/Qwen3.8-Flash-Next-GGUF \
  --revision d96201194f103c906994f283f504209dc8d2a10c \
  --include "UD-Q4_K_XL/*" \
  --include "MTP/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf" \
  --include "mmproj-BF16.gguf" \
  --local-dir $HOME/LLM_Practice/models/qwen38-flash-next \
  --tool aria2c -x 10

# Muse Glimmer 30B
hfd meta-models/Muse-Glimmer-30B-GGUF \
  --include "Muse-Glimmer-30B-KQuant-17GB-Q4_K_M.gguf" \
  --include "dflash-Muse-Glimmer-30B-Q4_K_M.gguf" \
  --include "mmproj-Muse-Glimmer-30B-Q4_K_M.gguf" \
  --local-dir $HOME/LLM_Practice/models/muse-glimmer-30b \
  --tool aria2c -x 10

# Qwen3.6-35B-A3B (MTP)
hfd unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
  --include "Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf" \
  --include "mmproj-BF16.gguf" \
  --local-dir $HOME/LLM_Practice/models/qwen36-35b-a3b \
  --tool aria2c -x 10
```
