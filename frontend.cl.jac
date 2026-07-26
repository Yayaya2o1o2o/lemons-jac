"""Lemons - client UI."""

import from .components.PickCard { PickCard }

sv import from endpoints { Research, RunResearch, History }

def:pub app -> JsxElement {
    has picks: list[Research] = [],
        market: str = "",
        bankroll: str = "100",
        error: str = "",
        busy: bool = False;

    can with entry {
        loadHistory();
    }

    async def loadHistory -> None;
    async def runResearch(e: FormEvent) -> None;

    return
        <div
            style={{
                "minHeight": "100vh",
                "backgroundColor": "#faf6ef",
                "fontFamily": "ui-sans-serif, system-ui, -apple-system, sans-serif"
            }}
        >
            <div style={{"maxWidth": "760px", "margin": "0 auto", "padding": "3.5rem 1.25rem 5rem"}}>
                <h1
                    style={{
                        "fontSize": "2.6rem",
                        "margin": "0",
                        "color": "#2f2a24",
                        "letterSpacing": "-0.02em"
                    }}
                >
                    Lemons
                </h1>
                <p style={{"color": "#7a7268", "marginTop": "0.5rem", "lineHeight": "1.6"}}>
                    Ask about any market. The agent researches it, argues a thesis, and tells you
                    honestly when there is no edge worth taking.
                </p>

                <form
                    onSubmit={runResearch}
                    style={{"display": "flex", "gap": "0.6rem", "margin": "2rem 0 2.5rem", "flexWrap": "wrap"}}
                >
                    <input
                        type="text"
                        value={market}
                        onChange={lambda e: ChangeEvent { market = e.target.value; }}
                        placeholder="Warriors vs Lakers tonight, spread"
                        style={{
                            "flex": "3",
                            "minWidth": "260px",
                            "padding": "0.85rem 1rem",
                            "border": "1px solid #e0d5c5",
                            "borderRadius": "10px",
                            "backgroundColor": "#fffdf8",
                            "color": "#2f2a24",
                            "fontSize": "0.95rem"
                        }}
                    />
                    <input
                        type="text"
                        value={bankroll}
                        onChange={lambda e: ChangeEvent { bankroll = e.target.value; }}
                        placeholder="Bankroll"
                        style={{
                            "flex": "1",
                            "minWidth": "90px",
                            "padding": "0.85rem 1rem",
                            "border": "1px solid #e0d5c5",
                            "borderRadius": "10px",
                            "backgroundColor": "#fffdf8",
                            "color": "#2f2a24",
                            "fontSize": "0.95rem"
                        }}
                    />
                    <button
                        type="submit"
                        disabled={busy}
                        style={{
                            "padding": "0.85rem 1.6rem",
                            "backgroundColor": "#b5643c" if not busy else "#c9b9a6",
                            "color": "#fffdf8",
                            "border": "none",
                            "borderRadius": "10px",
                            "cursor": "pointer" if not busy else "default",
                            "fontSize": "0.95rem"
                        }}
                    >
                        {"Researching..." if busy else "Research"}
                    </button>
                </form>

                {<p
                    style={{
                        "color": "#a04a2c",
                        "backgroundColor": "#f7e7df",
                        "border": "1px solid #e8cdc0",
                        "borderRadius": "10px",
                        "padding": "0.75rem 1rem",
                        "margin": "0 0 2rem"
                    }}
                >
                    {error}
                </p> if error else None}

                {[
                    <PickCard
                        key={idx}
                        market={p.market}
                        pick={p.pick}
                        verdict={p.verdict}
                        confidence={p.confidence}
                        edge_pct={p.edge_pct}
                        thesis={p.thesis}
                        angles={p.angles}
                        risks={p.risks}
                    />
                    for (idx, p) in enumerate(picks)
                ]}
            </div>
        </div>;
}
