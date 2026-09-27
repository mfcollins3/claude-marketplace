# Edit a Proposed ADR

* When invoked with a request (e.g., via `/adr`), the request should identify
  which ADR to edit (by number or title) and describe the desired change. If
  either is missing or ambiguous, ask the user to clarify before editing.
* Only ADRs in the `proposed` state can be edited.
* Update the `date` field to reflect the date of the last update.
* Update the `decision-makers`, `consulted`, and `informed` fields as needed to
  reflect any changes in the decision-making process. You should ask the user if
  there are names to add to or remove from the fields.
* Add [Mermaid](https://mermaid-js.github.io/mermaid/#/) diagrams when they can
  help to illustrate the context, decision, or consequences of the architectural
  decision.
