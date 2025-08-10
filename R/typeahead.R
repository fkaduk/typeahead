#' @title typeahead-standalone dependency
#' @description Registers JS + CSS with Shiny
dependency_typeahead_standalone <- function() {
  htmltools::htmlDependency(
    name       = "typeahead-standalone",
    version    = "5.4.0",
    src        = c(file = "assets"),
    script     = "lib/typeahead-standalone/typeahead-standalone.umd.js",
    stylesheet = c("lib/typeahead-standalone/basic.css", "css/typeahead-shiny.css"),
    package    = "typeahead"
  )
}

#' @title Type-ahead text input
#' @description Bootstrap-styled text box with client-side autocomplete.
#' @inheritParams shiny::textInput
#' @param hint Logical; whether to show hints as you type
#' @export
typeaheadInput <- function(inputId,
                           label = NULL,
                           choices = character(),
                           value = NULL,
                           width = NULL,
                           placeholder = NULL,
                           items = 8,
                           min_length = 1,
                           hint = TRUE,
                           options = list()) {
  opts <- modifyList(
    list(limit = items, minLength = min_length, hint = hint),
    options
  )

  dep <- dependency_typeahead_standalone()

  js_binding <- htmltools::tags$script(htmltools::HTML(sprintf("
    (function () {
      var binding = new Shiny.InputBinding();
      $.extend(binding, {
        find: function (scope) {
          return $(scope).find('.typeahead-standalone');
        },
        initialize: function (el) {
          const src   = $(el).data('source')   || [];
          const opts  = $(el).data('options')  || {};

          // Initialize typeahead
          const ta = typeahead(Object.assign(
            { input: el, source: { local: src } }, // must-have fields
            opts                                    // user options win
          ));
          $(el).data('ta', ta);

          // Style adjustments for the created elements
          const wrapper = el.parentElement;
          if (wrapper && wrapper.classList.contains('typeahead-standalone')) {
            // Match form-control styling for hint
            const hintInput = wrapper.querySelector('.tt-hint');
            if (hintInput) {
              hintInput.classList.add('form-control');
            }
          }
        },
        getValue: function (el) { return el.value; },
        subscribe  : function (el, cb) { $(el).on('typeahead:select.typeahead-standalone change.typeahead-standalone', cb); },
        unsubscribe: function (el)      { $(el).off('.typeahead-standalone'); },
        receiveMessage: function (el, data) {
          var ta = $(el).data('ta');
          if (ta && data.choices) { ta.reset(true); ta.addToIndex(data.choices); }
          if (data.value !== undefined) { el.value = data.value; }
        }
      });
      Shiny.inputBindings.register(binding);
    })();")))

  input_tag <- htmltools::tags$input(
    id = inputId,
    type = "text",
    class = "typeahead-standalone form-control",
    autocomplete = "off",
    value = value %||% "",
    `data-source` = jsonlite::toJSON(choices, auto_unbox = TRUE),
    `data-options` = htmltools::HTML(
      jsonlite::toJSON(opts, auto_unbox = TRUE, null = "null")
    ),
    placeholder = placeholder,
    style = if (!is.null(width)) sprintf("width:%s;", shiny::validateCssUnit(width))
  )

  htmltools::tagList(
    if (!is.null(label)) htmltools::tags$label(`for` = inputId, label),
    htmltools::attachDependencies(htmltools::tagList(input_tag, js_binding), dep)
  )
}

#' @title Update a typeahead input
#' @description Replace choices, value or settings client-side.
#' @export
updateTypeaheadInput <- function(session,
                                 inputId,
                                 choices = NULL,
                                 value = NULL,
                                 items = NULL,
                                 min_length = NULL) {
  msg <- list()
  if (!is.null(choices)) {
    msg$choices <- choices
  }
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(min_length)) {
    msg$`data-min-length` <- min_length
  }

  session$sendInputMessage(inputId, msg)
}
