# typeahead R pkg specifications

## expected behavior

- users can dynamically update typeahead choices and selected values using `updateTypeaheadInput()`, following `updateSelectInput()` behavior:
    - multiple rapid calls are batched and only the final state is sent to browser after the reactive cycle completes
- Shiny reactivity triggers only on selection, not on every keystroke
- empty state handling: with `choices = character(0)` or `NULL`, renders functional input field with no suggestions and `NULL` value and return value `""`

## possible extension

- [x] add `hint` parameter for auto-completion hints
- [ ] make it possible for the typeahead input to load remote data
- [ ] add `reactive_on` parameter to control when shiny reactivity triggers (e.g., "selection", "input", "debounced")
- [ ] enable `server`-side processing
- [ ] enable named choices to allow for differences between display/backend value

