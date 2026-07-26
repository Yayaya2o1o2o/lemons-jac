"""Implementations for the Lemons frontend."""

impl app.loadHistory -> None {
    result = root spawn History();
    # The walker reports oldest first; the UI shows newest first.
    ordered = [];
    for r in result.reports {
        ordered = [r] + ordered;
    }
    picks = ordered;
}

impl app.runResearch(e: FormEvent) -> None {
    e.preventDefault();
    if not market.strip() or busy {
        return;
    }
    busy = True;
    failed = False;
    amount = 100.0;
    try {
        amount = float(bankroll);
    } except ValueError {
        amount = 100.0;
    }
    # Never leave the button stuck on "Researching..." if the model call fails.
    try {
        result = root spawn RunResearch(market=market, bankroll=amount);
        picks = result.reports + picks;
        market = "";
    } except Exception {
        failed = True;
    }
    error = "That research call failed. Try again." if failed else "";
    busy = False;
}
