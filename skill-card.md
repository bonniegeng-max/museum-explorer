## Description:

Museum Explorer helps agents plan museum visits, guide on-site exhibit exploration, and produce post-visit journals with source-checked curation cards, checklists, and stamp-style artifacts.

This skill is ready for commercial/non-commercial use.

## Publisher:

[bonniegeng-max](https://clawhub.ai/user/bonniegeng-max)

### License/Terms of Use:

MIT-0

## Use Case:

External users and agents use this skill to prepare for exhibitions, capture on-site exhibit notes, and turn the visit into a reusable local journal. It is suited for museum and gallery trip planning where source checks, date-sensitive exhibition details, and local artifact generation matter.

### Deployment Geography for Use:

Global

## Known Risks and Mitigations:

Risk: Generated journal HTML may load a font stylesheet from jsDelivr, so artifacts are not fully offline or fully private when opened in a network-enabled browser.

Mitigation: Users who need offline or private artifacts should remove or block the remote font import before opening generated journals.

Risk: The skill can update local session, journal, stamp, and exhibition index files as part of its workflow.

Mitigation: Review proposed writes and data-index change summaries before allowing updates, and keep writes within the documented local paths.

## Reference(s):

- [ClawHub skill page](https://clawhub.ai/bonniegeng-max/skills/museum-explorer)
- [Source verification guide](artifact/references/source-verification.md)
- [Data sources guide](artifact/references/data-sources.md)
- [Exhibits schema](artifact/references/exhibits.schema.json)
- [Stamp design guide](artifact/references/stamp-design-guide.md)

## Skill Output:

**Output Type(s):** [text, markdown, code, configuration, guidance]

**Output Format:** [Markdown, HTML journal data, SVG stamp assets, JSON exhibition records, and concise conversational guidance]

**Output Parameters:** [1D]

**Other Properties Related to Output:** [Produces local visit artifacts under the documented journal and data paths; generated HTML may reference a third-party font stylesheet unless users remove or block it.]

## Skill Version(s):

1.6.4 (source: server release evidence and ClawHub Meta)

## Ethical Considerations:

Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment.
