# Reject a Proposed ADR

* When invoked with a request (e.g., via `/adr`), the request should identify
  which ADR to reject (by number or title) and, ideally, why. If the ADR
  isn't identifiable, ask the user to identify it before proceeding.
* Update its state to `rejected`.
* Update the `date` field to reflect the date of rejection.
* Update the `decision-makers`, `consulted`, and `informed` fields as needed to
  reflect any changes in the decision-making process. You should ask the user if
  there are names to add to or remove from the fields.
* Update the ADR with the reasons why the ADR was rejected.
* Rename the ADR from `draft-{title}.md` to `rejected-{title}.md`, where title
  is the brief description of the decision.
* Update the `docs/adrs/README.md` file:
  * Update the filename to reflect the change in the ADR's state and filename.
  * Update the brief description of the ADR as needed.
  * Update the state to indicate that the ADR was rejected.
