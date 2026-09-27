# Deprecate an Accepted ADR

* When invoked with a request (e.g., via `/adr`), the request should identify
  which ADR to deprecate (by number or title) and, ideally, why. If the ADR
  isn't identifiable, ask the user to identify it before proceeding.
* Only ADRs in the `accepted` state can be deprecated.
* Update its state to `deprecated`.
* Update the `date` field to reflect the date of deprecation.
* Update the `decision-makers`, `consulted`, and `informed` fields as needed to
  reflect any changes in the decision-making process. You should ask the user if
  there are names to add to or remove from the fields.
* Update the ADR with the reasons why it was deprecated.
* Update the `docs/adrs/README.md` file to indicate that the ADR was deprecated.
