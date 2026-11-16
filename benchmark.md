# Benchmark Tools

## LLM Benchmark Runner

[Repository](https://github.com/kuhung/benchmark-for-LLM/)

```bash
# Run on the same host as the server
source $HOME/LLM_Practice/py3-venv/bin/activate
pip install llm-benchmark-runner

$HOME/LLM_Practice/py3-venv/bin/llm-benchmark \
    --url http://localhost:8731 \
    --model halogen-qwen3.8-flash-next \
    --repeat 10 --concurrency 1,2 \
    --max-tokens 512
```

## Halogen Server Built-in Bench

> Command not yet recorded. See Halogen Flash server docs for reference.
