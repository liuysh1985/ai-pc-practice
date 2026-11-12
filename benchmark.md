
## Benchmark Tools
### Halogen Server built-in bench tool

### LLM Benchmark Runner
Github Repository: https://github.com/kuhung/benchmark-for-LLM/

```bash
# Performed on the same host
source <PYTHON_VENV_PATH>/bin/activate
pip install llm-benchmark-runner
<PYTHON_VENV_PATH>/bin/llm-benchmark \
    --url http://localhost:8731 \
    --model halogen-qwen3.8-flash-next \
    --repeat 10 --concurrency 1,2 \
    --max-tokens 512
```