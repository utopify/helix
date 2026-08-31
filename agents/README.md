# HELIX Agents

### Downloadable AI Agent Templates for Higher Education Data Migration & Analytics

> Pre-built agent configurations that embed HELIX's data models, compliance guardrails, and domain expertise into AI assistants your team can deploy.

---

## What Are HELIX Agent Templates?

Each agent template is a JSON file containing everything needed to stand up a specialized AI agent:

- **System prompt** with deep domain expertise (ERP structures, compliance rules, analytical methods)
- **Knowledge file references** pointing to the specific HELIX resources, Bridge mappings, and documentation the agent needs
- **Compliance guardrails** that enforce FERPA, GLBA, and institutional data policies
- **Tool recommendations** for platforms that support tool use (SQL execution, file generation, notifications)
- **Sample interactions** showing what the agent can do

**Download a template, load it into your platform, point it at your HELIX-shaped data, and go.**

## Available Agent Templates

| Agent | File | What It Does |
|-------|------|-------------|
| **PS-to-Workday FIN** | `ps-to-workday-fin-agent.json` | Migrates PeopleSoft Financials to Workday Financial Management. Maps chartfields to worktags, generates transformation code, enforces GLBA compliance, produces reconciliation queries. |
| **Enrollment Analytics** | `enrollment-analytics-agent.json` | Analyzes enrollment funnels, calculates marketing ROI by channel, predicts summer melt, generates student readiness profiles, recommends interventions for at-risk students. |
| **Advancement & Donor** | `advancement-donor-agent.json` | Accelerates stewardship (48-hour thank-you letters), identifies unassigned major-gift prospects, generates pre-event briefings, creates personalized outreach from giving + engagement data. |
| **Banner-to-Lakehouse** | `banner-to-lakehouse-agent.json` | Migrates Ellucian Banner data into a HELIX-conformant data lakehouse. Handles PIDM resolution, STV lookups, effective-term dating. Generates dbt models and Spark transformations. |

## Compatible Platforms

These templates are designed to work with:

| Platform | How to Use |
|----------|-----------|
| **Amazon Q / Amazon Quick** | Import as a custom agent with the system prompt and knowledge files |
| **AWS Bedrock Agents** | Use the system prompt as the agent instruction, attach knowledge files to a knowledge base |
| **AWS AgentCore** | Deploy as an agent configuration with the recommended tools |
| **OpenAI Assistants API** | Create an assistant with the system prompt and upload knowledge files |
| **Any LLM with system prompt support** | Use the system_prompt field directly; load knowledge files into context or RAG |

The JSON structure is platform-agnostic. Extract the fields you need for your specific platform.

## Template Structure

```json
{
  "metadata": {
    "id": "helix-agent-...",
    "name": "...",
    "description": "...",
    "tags": ["migration", "peoplesoft", "workday", ...]
  },
  "agent_configuration": {
    "system_prompt": "...",       // The agent's expertise and rules
    "temperature": 0.3,           // Recommended temperature
    "max_tokens": 8192            // Recommended max output
  },
  "knowledge_files": {
    "required": ["..."],          // HELIX files the agent must have access to
    "recommended": ["..."]        // Additional files that improve performance
  },
  "tools": {
    "recommended": [...]          // Tool integrations for platforms that support them
  },
  "guardrails": {
    "data_classification": {...}, // FERPA/GLBA enforcement rules
    "pii_handling": {...},        // PII tokenization and access rules
    "reconciliation": {...}       // Data validation requirements
  },
  "sample_interactions": [...]    // Example conversations
}
```

## How to Deploy

### Quick Start (Any Platform)

1. Download the agent template JSON for your use case
2. Copy the `system_prompt` from `agent_configuration`
3. Gather the files listed in `knowledge_files.required` from the HELIX repo
4. Create an agent/assistant on your platform with the prompt and files
5. Test with one of the `sample_interactions`

### With AWS Bedrock Agents

1. Create a new agent in Amazon Bedrock
2. Paste the `system_prompt` as the agent instruction
3. Create a knowledge base and upload the `knowledge_files.required` files
4. Associate the knowledge base with the agent
5. (Optional) Add action groups for the recommended `tools`
6. Deploy and test

### With Amazon Quick

1. Create a new custom agent
2. Paste the `system_prompt` as the agent instructions
3. Upload the `knowledge_files.required` files as reference materials
4. Save and start chatting with the agent

## Building Your Own HELIX Agent

Use these templates as starting points. Common customizations:

- **Add institution-specific context** to the system prompt (your ERP version, custom fields, local policies)
- **Add your own knowledge files** (institutional data dictionary, local coding standards, specific SQL dialect)
- **Adjust guardrails** for your institution's data classification policy
- **Add tools** specific to your environment (Jira for tracking, Slack for notifications, your specific query engine)

## Contributing Agent Templates

Built a useful HELIX agent for your institution? Generalize it and contribute it back:

1. Remove institution-specific data and credentials
2. Reference HELIX resources/files by relative path
3. Include sample interactions
4. Submit a pull request to the `agents/` directory

---

*HELIX Agents v0.1 — August 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
