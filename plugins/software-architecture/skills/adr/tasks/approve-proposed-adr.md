# Approve a Proposed ADR

* When invoked with a request (e.g., via `/adr`), the request should identify
  which ADR to approve (by number or title). If it doesn't, ask the user to
  identify it before proceeding.
* Only ADRs in the `proposed` state can be accepted.
* Update the state to `accepted`.
* Update the `date` field to reflect the date of approval.
* Update the `decision-makers`, `consulted`, and `informed` fields as needed to
  reflect any changes in the decision-making process. You should ask the user if
  there are names to add to or remove from the fields.
* Rename the ADR from `draft-{title}.md` to `{number}-{title}.md`, where
  `{number}` is the next available ADR number and `{title}` is the brief
  description of the decision.
  * `{number}` should be in the format `NNNN` where `NNNN` is the next available
    ADR number and the number is zero-padded on the left (e.g., `0001` or
    `0123`.
* Update the `docs/adrs/README.md` file:
  * Update the filename to reflect the change in the ADR's state and filename.
  * Update the brief description of the ADR as needed.
  * Update the state to indicate that the ADR was accepted.
* If the ADR being approved supersedes and deprecates an existing ADR, the
  ADR being superseded should be updated:
  * Set the `status` field to 
    `superseded by [ADR-{number}](link to the new ADR)`.
  * Update the `date` field to reflect the date of approval for the new ADR.
