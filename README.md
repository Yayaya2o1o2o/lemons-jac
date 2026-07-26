# Lemons

AI betting research, built in Jac at **JacHacks SF 2026**.

Ask about any market. The agent researches it, argues a thesis, and tells you
honestly when there is no edge worth taking.

## What it does

`RunResearch` takes a market in plain language, delegates the analysis to an LLM
through Jac's `by llm` (Groq, `llama-3.3-70b-versatile`), and persists the
briefing as a `Research` node on the graph. `History` walks the graph to replay
every briefing. The research history *is* the graph.

The LLM fills a plain `Analysis` obj, and the walker copies it onto the node, so
the AI schema and the storage schema stay independent.

Each briefing returns a pick, a verdict (`STRONG_BET` / `LEAN` / `PASS` /
`FADE`), a confidence, an estimated edge, the supporting angles, and the
specific ways the thesis breaks.

## Run it

```bash
uv venv --python 3.12
uv pip install jaclang byllm jac-client
echo "GROQ_API_KEY=your_key" > .env
set -a && . ./.env && set +a
jac start main.jac --port 8899
```

Open http://localhost:8899. Swagger is at `/docs`.

## Layout

| File | Role |
|---|---|
| `endpoints.sv.jac` | Graph nodes, the `by llm` research function, and the walkers |
| `frontend.cl.jac` | Client UI, compiled to the browser bundle |
| `frontend.impl.jac` | Frontend handler bodies |
| `components/PickCard.cl.jac` | One research briefing |
| `main.jac` | Entry point |
