"""Lemons - AI betting research, rebuilt in Jac.

Every question a user asks becomes a `Research` node hanging off `root`, so the
graph itself is the research history. The LLM fills a plain `Analysis` obj and
the walker copies it onto the node, keeping the AI schema and the storage
schema independent.
"""

import from byllm.lib { Model }

glob llm: Model = Model(model_name="groq/llama-3.3-70b-versatile");

enum Verdict {
    STRONG_BET,
    LEAN,
    PASS,
    FADE
}

sem Verdict.STRONG_BET = "Clear, well-supported edge. Worth a full-size position.";
sem Verdict.LEAN = "Mild edge. Worth a reduced position, not a headline bet.";
sem Verdict.PASS = "No demonstrable edge. Sit this one out.";
sem Verdict.FADE = "The market is wrong in the opposite direction. Bet the other side.";

obj Angle {
    has factor: str;
    has impact: str;
}

sem Angle.factor = "One concrete, checkable factor driving this market: an injury, a pace mismatch, a weather condition, a line move, a scheduling spot.";
sem Angle.impact = "One sentence on how that factor moves the true probability, and in whose favor.";

obj Analysis {
    has pick: str;
    has verdict: Verdict;
    has confidence: int;
    has edge_pct: float;
    has thesis: str;
    has angles: list[Angle];
    has risks: list[str];
}

sem Analysis = "A disciplined research briefing on a single betting market. Be specific and quantitative. Never invent statistics you are not confident in; prefer stating uncertainty.";
sem Analysis.pick = "The exact side and number being recommended, e.g. 'Warriors -3.5' or 'Under 47.5'. If the verdict is PASS, state the side you came closest to backing.";
sem Analysis.verdict = "How strong this opportunity actually is. Be honest; most markets are efficient and deserve PASS.";
sem Analysis.confidence = "Confidence in the thesis, 0 to 100. Stay under 70 unless the edge is genuinely obvious.";
sem Analysis.edge_pct = "Estimated percentage edge over the implied market price. Small single digits are normal. Use 0.0 for PASS.";
sem Analysis.thesis = "Two or three sentences making the core argument in plain language a bettor can act on.";
sem Analysis.angles = "Two to four distinct supporting angles. No filler, no restating the thesis.";
sem Analysis.risks = "Two or three specific ways this thesis is wrong. Be concrete about what would invalidate it.";

def analyze_market(market: str, bankroll: float) -> Analysis by llm(temperature=0.3, max_tokens=1400);

sem analyze_market = "Research a betting market end to end and return a disciplined Analysis. You are a sharp, skeptical analyst whose reputation depends on not talking a user into bad bets. Efficient markets are the default assumption.";
sem analyze_market.market = "The market or matchup the user wants researched, in their own words.";
sem analyze_market.bankroll = "The user's stated bankroll in dollars, used to size the recommendation sensibly.";

node Research {
    has market: str,
        pick: str,
        verdict: str,
        confidence: int,
        edge_pct: float,
        thesis: str,
        angles: list[dict],
        risks: list[str];
}

walker:pub RunResearch {
    """Research one market and persist the briefing onto the graph."""

    has market: str,
        bankroll: float = 100.0,
        reports: list[Research] = [];

    can go with Root entry {
        a = analyze_market(self.market, self.bankroll);
        report (here ++> Research(
            market=self.market,
            pick=a.pick,
            verdict=a.verdict.name,
            confidence=a.confidence,
            edge_pct=a.edge_pct,
            thesis=a.thesis,
            angles=[{"factor": g.factor, "impact": g.impact} for g in a.angles],
            risks=a.risks
        ))[0];
    }
}

walker:pub History {
    """Report every briefing already on the graph, newest last."""

    has reports: list[Research] = [];

    can collect with Root entry {
        visit [-->];
    }

    can gather with Research entry {
        report here;
    }
}
