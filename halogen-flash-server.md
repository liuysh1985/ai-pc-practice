# Halogen Flash Server Practice
## Information
**Github repo**: https://github.com/peonist-ai/halogen-flash-server

**Image URI**: ghcr.io/peonist-ai/halogen-flash-server:0.19.1

**Documentation**: https://github.com/peonist-ai/halogen-flash-server/tree/main/docs


## Run in container
About the group id in `/etc/group`, it could be different in each machine. For example the group ids in my mini PC:
- video: 44
- render: 990

```bash
docker run --rm -p 8731:8731 \
  --device /dev/kfd --device /dev/dri --group-add 44 --group-add 990 \
  --ipc=host --ulimit memlock=-1:-1 \
  -e HALOGEN_CHECKPOINT=/models/qwen38-flash-next-v2.hgn \
  -e HALOGEN_VISION_TOWER=/models/qwen38-flash-next-vision.hgn \
  -e HALOGEN_DOWNLOAD=0 \
  -v $HOME/LLM_Practice/models/halogen-qwen3.8-v2:/models:ro \
  ghcr.io/peonist-ai/halogen-flash-server:0.19.1
```