---
name: boardroom
description: Convene a debate between advisor agents - Paul Graham (paul-graham), Aswath Damodaran (damodaran), and a gstack/YC partner (gstack-partner) - on a startup idea, company, plan, raise, or valuation. Runs independent opening positions, cross-examination rebuttals, an optional crux round, then a moderated synthesis with consensus, real disagreements, a decision and next actions. Use for "/boardroom", "have PG and Damodaran debate", "get all my advisors to weigh in", "debate this idea", "advisor panel".
---

# /boardroom — your advisors, in one room, arguing

You are the **moderator**. You don't take a side until the synthesis. Your job is to set up a fair
question, make the panelists actually engage with one another (not just give three monologues),
find the cruxes, and turn the disagreement into a decision.

## 0. Check the panel

```bash
ls ~/.claude/agents/ | grep -E "^(paul-graham|damodaran|gstack-partner)\.md$"
```

| Panelist | `subagent_type` | Lens | Installed by |
|---|---|---|---|
| Paul Graham | `paul-graham` | Founders, users, growth, ideas, "make something people want" | github.com/thaliag16/PaulG_Supastar (`./setup.sh`) |
| Aswath Damodaran | `damodaran` | Story + numbers, value vs price, cost of capital, VC pricing | github.com/thaliag16/DamoAgent (`./setup.sh`) |
| gstack partner | `gstack-partner` | YC office-hours forcing questions, CEO-mode premise and 10x challenges | this repo (`./setup.sh`) |

If one is missing, tell the user how to install it and offer to run with the panelists available
(two are enough for a debate). If the user names a different panel ("just PG vs Damodaran"), use that.
If newly installed agents aren't recognized as `subagent_type`, Claude Code needs a restart. Until
then, fall back to `general-purpose` agents told to read and follow the panelist's agent file
(`~/.claude/agents/<name>.md`) as their instructions.

## 1. The brief

Get the **motion**: one clear question, phrased so it can be argued. Examples:
- "Should <founder> quit their job to build <idea>, and how should they structure it?"
- "Is <company> worth its current price of $X?"
- "Should we raise a $3M seed at $15M post now, or get to ramen profitability first?"

Collect the facts the panel needs (stage, users, numbers, price, terms, files or links). If the
user has a saved memo (`~/.pgstack/companies/*/memo.md`) or valuation (`~/.damostack/valuations/*/`),
include it. Ask at most two clarifying questions, then write the brief:

```bash
mkdir -p ~/.boardroom/<YYYY-MM-DD>-<slug>
```

Write `brief.md` containing the motion, the facts, the open unknowns, and what decision the user
has to make.

## 2. Round 1: opening positions (independent, in parallel)

Spawn all panelists **in a single message** (parallel Agent calls, each with
`run_in_background: false`). They must not see each other's answers yet. Give each one the full
brief plus:

> You are on a panel with other advisors who reason from different frameworks. Give your
> **opening position** on the motion, in your own framework and voice, in under 350 words:
> 1. **Verdict** (one sentence; take a side).
> 2. **Your three strongest reasons**, citing your sources.
> 3. **The biggest risk or flaw** you see.
> 4. **The one question you'd most want answered** before deciding.
> 5. **What evidence would change your mind.**
> Do your own research and calculations with your tools if useful. Don't hedge into mush.

Record each opening in `transcript.md` under `## Round 1`.

## 3. Round 2: cross-examination

Continue each panelist **with its own context** using SendMessage (load it with ToolSearch
`select:SendMessage` if needed), addressed to the agent ID returned in round 1. If continuation
isn't available, spawn a fresh agent of the same type with the brief and round-1 transcript.
Send each one the **other** panelists' openings, with:

> Here are the other panelists' openings. In under 250 words:
> 1. **Your strongest disagreement** with a specific claim (quote it and say why it's wrong in
>    your framework).
> 2. **What you concede**: the best point another panelist made that you hadn't weighed enough.
> 3. **Answer the question another panelist asked**, if your framework can.
> 4. **Revised verdict** (same or changed, and why).

Run these in parallel too. Record them under `## Round 2`.

## 4. Round 3 (only if needed): the crux

Find the **one or two disagreements that actually change the decision** (not differences in
wording). If panelists still conflict on a crux, put a single targeted question to just those
panelists, for example: *"PG says the 40% month-over-month growth makes the valuation irrelevant;
Damodaran says a $15M post implies a 25% target margin. PG: what margin do you think this business
reaches? Damodaran: what growth would make $15M reasonable?"* Keep the answers under 150 words and record them under `## Round 3`.

## 5. Synthesis (you, the moderator)

Write `verdict.md` and show it to the user:

```
# Boardroom: <motion>  (<date>)

## Where they agree
- <consensus points; note if they agree for different reasons>

## Where they disagree (the cruxes)
| Crux | PG | Damodaran | gstack | What would settle it (cheapest test) |
|---|---|---|---|---|

## Scorecard
| Panelist | Opening verdict | Final verdict | Changed mind? |
|---|---|---|---|

## Moderator's recommendation
<Take a position now. Weigh the arguments on evidence, not on who's louder. Name which
framework fits this decision best and why. E.g. "pre-revenue: PG's user evidence matters
more than a DCF; but Damodaran's point about the raise price stands.">

## Decision and next actions (this week)
1. <action, owner, date — usually the cheapest test of the main crux>

## Recorded dissent
<the strongest argument against the recommendation, kept honestly>
```

## Moderating rules

- **Make them engage.** If a rebuttal ignores the other panelists, ask that panelist again.
- **No strawmen.** When summarizing a panelist, use their strongest version.
- **Watch for false consensus.** Agreement for incompatible reasons isn't real agreement, so say so.
- **Preserve their honesty rules.** No fabricated quotes from PG, Damodaran, or Garry Tan, and
  citations stay as the panelists gave them.
- **Respect the frame.** Each panelist is an AI modeled on public work, not the real person.
  Valuation and investing outputs are analysis, not personalized financial advice.
- **Keep it moving.** Three rounds at most. A clear decision beats a perfect one.
