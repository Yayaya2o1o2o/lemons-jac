"""A single research briefing."""

def:pub PickCard(
    market: str,
    pick: str,
    verdict: str,
    confidence: int,
    edge_pct: float,
    thesis: str,
    angles: list[dict],
    risks: list[str]
) -> JsxElement {
    tone = {
        "STRONG_BET": "#7c5c3e",
        "LEAN": "#8a7250",
        "PASS": "#8a8378",
        "FADE": "#9a5b42"
    }.get(verdict, "#8a8378");

    return
        <div
            style={{
                "padding": "1.25rem 1.4rem",
                "marginBottom": "1rem",
                "backgroundColor": "#fffdf8",
                "border": "1px solid #e8ded0",
                "borderRadius": "14px",
                "boxShadow": "0 1px 2px rgba(60,45,30,0.04)"
            }}
        >
            <div style={{"fontSize": "0.78rem", "color": "#9a9086", "marginBottom": "0.5rem"}}>
                {market}
            </div>
            <div
                style={{
                    "display": "flex",
                    "alignItems": "baseline",
                    "gap": "0.7rem",
                    "flexWrap": "wrap"
                }}
            >
                <strong style={{"fontSize": "1.3rem", "color": "#2f2a24"}}>{pick}</strong>
                <span
                    style={{
                        "fontSize": "0.7rem",
                        "letterSpacing": "0.08em",
                        "padding": "0.2rem 0.6rem",
                        "borderRadius": "999px",
                        "backgroundColor": tone,
                        "color": "#fffdf8"
                    }}
                >
                    {verdict.replace("_", " ")}
                </span>
                <span style={{"fontSize": "0.8rem", "color": "#7a7268"}}>
                    {confidence}% confidence · {edge_pct}% edge
                </span>
            </div>
            <p style={{"margin": "0.8rem 0 0", "color": "#4a423a", "lineHeight": "1.6"}}>
                {thesis}
            </p>
            <div style={{"marginTop": "1rem", "display": "grid", "gap": "0.45rem"}}>
                {[
                    <div key={i} style={{"fontSize": "0.86rem", "color": "#5c5349"}}>
                        <strong style={{"color": "#3d362e"}}>{a.get("factor", "")}</strong>
                        {" — " + a.get("impact", "")}
                    </div>
                    for (i, a) in enumerate(angles)
                ]}
            </div>
            <div
                style={{
                    "marginTop": "1rem",
                    "paddingTop": "0.8rem",
                    "borderTop": "1px dashed #e8ded0"
                }}
            >
                <div style={{"fontSize": "0.7rem", "letterSpacing": "0.08em", "color": "#9a9086"}}>
                    WHAT BREAKS THIS
                </div>
                {[
                    <div key={i} style={{"fontSize": "0.84rem", "color": "#6b6259", "marginTop": "0.35rem"}}>
                        {r}
                    </div>
                    for (i, r) in enumerate(risks)
                ]}
            </div>
        </div>;
}
