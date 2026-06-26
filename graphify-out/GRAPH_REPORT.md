# Graph Report - helm-charts  (2026-06-26)

## Corpus Check
- 1 files · ~17,584 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 16 nodes · 15 edges · 4 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7e31be78`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]

## God Nodes (most connected - your core abstractions)
1. `Blockcast CDN Gateway — Helm Charts` - 8 edges
2. `Installation` - 3 edges
3. `Post-installation` - 3 edges
4. `Troubleshooting` - 3 edges
5. `Step 1 — Install cluster prerequisites (admin, once per namespace)` - 2 edges
6. `Prerequisites` - 1 edges
7. `Add the Helm repository` - 1 edges
8. `Verify Step 1 landed` - 1 edges
9. `Step 2 — Install the gateway` - 1 edges
10. `1. Register the gateway` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (4 total, 0 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.33
Nodes (5): Add the Helm repository, Blockcast CDN Gateway — Helm Charts, Prerequisites, Uninstall, Upgrades

### Community 1 - "Community 1"
Cohesion: 0.50
Nodes (4): Installation, Step 1 — Install cluster prerequisites (admin, once per namespace), Step 2 — Install the gateway, Verify Step 1 landed

### Community 2 - "Community 2"
Cohesion: 0.67
Nodes (3): 1. Register the gateway, 2. Verify registration, Post-installation

### Community 3 - "Community 3"
Cohesion: 0.67
Nodes (3): Gateway stuck on `PROGRAMMED=Unknown` ("Waiting for controller"), `helm search repo` returns no results, Troubleshooting

## Knowledge Gaps
- **10 isolated node(s):** `Prerequisites`, `Add the Helm repository`, `Verify Step 1 landed`, `Step 2 — Install the gateway`, `1. Register the gateway` (+5 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Blockcast CDN Gateway — Helm Charts` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`?**
  _High betweenness centrality (0.886) - this node is a cross-community bridge._
- **Why does `Installation` connect `Community 1` to `Community 0`?**
  _High betweenness centrality (0.362) - this node is a cross-community bridge._
- **Why does `Post-installation` connect `Community 2` to `Community 0`?**
  _High betweenness centrality (0.257) - this node is a cross-community bridge._
- **What connects `Prerequisites`, `Add the Helm repository`, `Verify Step 1 landed` to the rest of the system?**
  _10 weakly-connected nodes found - possible documentation gaps or missing edges._