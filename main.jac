"""Lemons - entry point.

Built at JacHacks SF 2026. Server-side research walkers plus the client UI.
"""

import from endpoints { Research, RunResearch, History }

cl {
    import from .frontend { app as ClientApp }

    def:pub app -> JsxElement {
        return <ClientApp/>;
    }
}
