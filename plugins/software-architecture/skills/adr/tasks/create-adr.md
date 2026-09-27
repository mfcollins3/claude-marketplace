# Create an Architectural Decision Record

## Procedure

* When invoked with a request describing a decision (e.g., via `/adr`), use
  the text of the request as the basis for the ADR's title and to draft the
  `Context and Problem Statement` section. Ask the user for any additional
  details needed to complete the ADR (decision drivers, considered options,
  decision-makers, etc.).
* Use the [template](../resources/template.md) to create the ADR.
* New ADRs should be added to the `docs/adrs` directory.
* New ADRs should be named using the format `draft-{title}.md`, where `{title}`
  is a brief description of the decision.
* New ADRs should be added to the `docs/adrs/README.md` file with a link to the
  new ADR and a brief description of the decision.
* New ADRs should be created in the `proposed` state.
* Add [Mermaid](https://mermaid-js.github.io/mermaid/#/) diagrams when they can
  help to illustrate the context, decision, or consequences of the architectural
  decision.
* If the ADR is extending an existing ADR, the new ADR should reference the
  existing ADR and clearly indicate how the new ADR is extending the existing
  ADR.

## Deprecating an Existing ADR

* If the ADR is deprecating or replacing an existing ADR, the new ADR should
  reference the ADR being deprecated and clearly explain why the new ADR has
  made the existing ADR obsolete.
* The existing ADR should be updated and have its `status` field updated to
  indicate that the older ADR is being superseded by the new ADR.
