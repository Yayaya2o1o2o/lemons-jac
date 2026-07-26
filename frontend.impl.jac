"""Implementations for the Lemons frontend."""

impl app.loadHistory -> None {
    result = root spawn History();
    picks = result.reports;
}

impl app.runResearch(e: FormEvent) -> None {
    e.preventDefault();
    if not market.strip() or busy {
        return;
    }
    busy = True;
    amount = 100.0;
    try {
        amount = float(bankroll);
    } except ValueError {
        amount = 100.0;
    }
    result = root spawn RunResearch(market=market, bankroll=amount);
    picks = picks + result.reports;
    market = "";
    busy = False;
}
