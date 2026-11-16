# Own Your Intelligence Layer

### Why your AI agents should point at your lakehouse, not at your vendors' platforms

Every major vendor in higher education now sells an AI and analytics layer on top of its own system. Workday has Prism Analytics and Workday Data Cloud. Salesforce has Data 360 (formerly Data Cloud) and Agentforce. Ellucian, Oracle, and others have their own. Each one is good at what it does, and each one sees one system.

A university doesn't run on one system. A question like "which first-generation students on Pell, working more than 20 hours a week in a campus job, are at risk of not returning in the spring?" touches the student system, financial aid, HR and payroll, and the CRM. No single vendor's AI layer can answer it, because no single vendor holds all of that data.

Your lakehouse can. That's the argument of this page.

---

## The principle

**Land institutional data in a lake you control, shape it into HELIX, attach your own definitions and rules to it, and point your AI agents at that.** Not at each vendor's platform.

Three things follow:

1. **Full visibility.** Silver and gold hold every system, joined on one identity. An agent pointed at gold sees the whole student, the whole employee, the whole donor.
2. **You own the logic.** Metric definitions, business rules, join paths, and institutional knowledge live in your storage as open files (Iceberg tables, YAML, Markdown, W3C ontologies). They don't live inside a vendor's semantic layer that you rent.
3. **You can change vendors.** When the ERP or CRM changes, the bridge changes. The silver model, the gold metrics, the context layer, and the agents built on them stay.

## What this means for add-on purchases

You don't need a vendor's add-on AI or analytics product to get trusted, AI-ready institutional data. The base subscription already gives you a way to get your data out (Workday reports as a service and web services, Salesforce Bulk API and Change Data Capture). Land it, shape it, govern it, and the lakehouse becomes the trusted source.

That isn't the same as saying those products are bad, or that no school should buy them. They solve real problems, mostly about working **inside** the vendor's application. Be honest about the trade-offs:

| You want... | Vendor add-on (Prism, Workday Data Cloud, Data 360, Agentforce) | HELIX lakehouse |
|-------------|------------------------------------------------------------------|-----------------|
| Answers that cross systems (SIS + aid + HR + CRM) | Limited to what you load into that vendor | Built in: every system lands in one silver model |
| Definitions you own and can move | Live in the vendor's semantic layer | Live in your bucket as open files |
| Blend outside data into **Workday or Salesforce reports and pages** | Strong. This is what Prism and Data 360 are for | Possible through write-back, but not the natural fit |
| Vendor's security model applied automatically | Strong. Permissions travel with the data | You rebuild it once, in Lake Formation (`govern/access-control-matrix.json` is the blueprint) |
| Near real-time | Live query and zero-copy options | Minutes to hours for most extracts; streaming where it matters |
| Cost model | Platform fee plus usage credits, per vendor | Storage and compute you already run, once, for every source |
| What happens when you change vendors | Rebuild the analytics and AI layer | Swap one bridge |

The honest summary: **a vendor add-on is optional, and it's a choice about convenience inside that vendor's application, not a requirement for AI.** If a school buys one, the lakehouse can still be the system of record for definitions and the place agents go for cross-system questions. Zero-copy features can be one more way to land data, as long as your definitions and rules live on your side.

## The real cost of owning it

Owning the layer isn't free, and HELIX says so:

- **You rebuild security once.** Workday and Salesforce permissions don't come with an extract. HELIX gives you the access matrix, the Lake Formation model, and masking policies, but someone has to apply them and keep them in step with campus roles.
- **You run pipelines.** Extracts break when reports or objects change. Version-control report definitions and API field lists alongside the pipeline.
- **Freshness is a design choice.** Most decisions are fine with nightly data. A few (registration holds, aid disbursement, a donor arriving at an event) need minutes. Pick per use case.
- **You curate definitions.** The context layer is only as good as the stewards who review it. See `docs/context/`.

## How it fits together

```
  Workday      Salesforce     Banner / PeopleSoft     Canvas, Handshake, NSC ...
  (RaaS, WWS)  (Bulk API, CDC) (DMS from reporting copy) (files and APIs)
      |             |                |                         |
      v             v                v                         v
  +---------------------------------------------------------------------+
  | BRONZE  raw, source-shaped, immutable (S3)                          |
  +---------------------------------------------------------------------+
      |  HELIX bridges: bridge/workday, bridge/salesforce, bridge/...    
      v
  +---------------------------------------------------------------------+
  | SILVER  HELIX Core resources, one identity, governed (S3 Tables)    |
  +---------------------------------------------------------------------+
      |  gold metric definitions you own (templates/context/gold-metrics)
      v
  +---------------------------------------------------------------------+
  | GOLD    census, retention, melt, yield, aid, workforce, giving      |
  +---------------------------------------------------------------------+
      |
      v
  +---------------------------------------------------------------------+
  | CONTEXT  definitions, rules, join paths, ontology, skills           |
  |          Glue business context, S3 annotations, AWS Context         |
  +---------------------------------------------------------------------+
      |
      v
  AI agents (Bedrock AgentCore, Amazon Quick, any MCP client)
  asking questions across every system, with the caller's permissions
```

## Where to go next

- **Landing Workday:** [`landing-zones/workday-landing-zone.md`](landing-zones/workday-landing-zone.md)
- **Landing Salesforce:** [`landing-zones/salesforce-landing-zone.md`](landing-zones/salesforce-landing-zone.md)
- **Building the context layer:** [`context/context-route.md`](context/context-route.md)
- **The lakehouse itself:** [`lakehouse-architecture-guide.md`](lakehouse-architecture-guide.md)

*HELIX v0.10.0, November 2026*
