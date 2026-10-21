# Boardroom6.7

*Where all the greatest minds work together to help.*


A Claude Code skill that puts your AI advisors in one room and makes them argue:

| Panelist | From | Lens |
|---|---|---|
| **Paul Graham** (`paul-graham`) | [PaulG_Supastar](https://github.com/thaliag16/PaulG_Supastar) | Founders, users, growth, "make something people want" |
| **Aswath Damodaran** (`damodaran`) | [DamoAgent](https://github.com/thaliag16/DamoAgent) | Story + numbers, value vs price, cost of capital |
| **gstack partner** (`gstack-partner`) | this repo, reading your installed [gstack](https://github.com/garrytan/gstack) skills | YC forcing questions, premise challenge, 10x thinking |

## How a session runs

1. **Brief.** You state the motion (e.g. "Should I raise a $3M seed now or get to ramen profitability first?") plus the facts.
2. **Round 1: openings.** Each advisor answers independently and in parallel: a verdict, three reasons, the biggest risk, the question they'd ask, and what would change their mind.
3. **Round 2: cross-examination.** Each sees the others' openings and must name its strongest disagreement, concede something, and revise (or defend) its verdict.
4. **Round 3: the crux** (if needed). Targeted questions on the disagreements that actually change the decision.
5. **Synthesis.** The moderator writes where they agree, a crux table, a scorecard (who changed their mind), a recommendation, this week's actions, and the strongest dissent.

Everything is saved to `~/.boardroom/<date>-<topic>/` (`brief.md`, `transcript.md`, `verdict.md`).

## Cost modes

| Mode | Say | Panelists run on | Rounds |
|---|---|---|---|
| quick | "quick boardroom: …" | Haiku, no tool use | openings + synthesis |
| standard (default) | `/boardroom …` | Sonnet, ≤2 tool calls each | openings, rebuttals, crux only if needed |
| deep | "deep boardroom: …" | your session model | up to 3 rounds, full research |

Panelists load compact core files (~750–1,100 tokens each) instead of their full knowledge bases.
The gstack partner reads a 750-token digest instead of ~25,000 tokens of raw gstack skills. Rebuttals
reuse each panelist's cached context and get compressed digests of the others' openings.

## Install

Install the two advisor repos first (each has its own `./setup.sh`), and gstack. Then:

```bash
git clone https://github.com/thaliag16/Boardroom6.7.git ~/Boardroom && cd ~/Boardroom && ./setup.sh
```

The installer prints a panel check showing which advisors are available. Restart Claude Code, then:

```
/boardroom Should I quit my job to build <idea>?
/boardroom Is Nvidia worth its current price?
/boardroom just PG vs Damodaran: is a $20M post-money fair for my seed round?
```

All panelists are AIs modeled on public work, not the real people. Valuation output is analysis,
not personalized financial advice.

## License

[MIT](LICENSE)
