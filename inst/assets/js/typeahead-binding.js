(function () {
  const DEBUG = false;
  const log = (...args) => {
    if (DEBUG) console.debug("[typeahead]", ...args);
  };
  const warn = (...args) => {
    if (DEBUG) console.warn("[typeahead]", ...args);
  };

  const aa = window["@algolia/autocomplete-js"];
  if (!aa || !aa.autocomplete) {
    console.error("[typeahead] @algolia/autocomplete-js not found");
    return;
  }
  const { autocomplete } = aa;

  function parseJSONAttr(el, attr, fallback) {
    const raw = el.getAttribute(attr);
    if (!raw) return fallback;
    try {
      return JSON.parse(raw);
    } catch (e) {
      warn("parseJSONAttr FAIL", { id: el.id, attr, error: e });
      return fallback;
    }
  }

  function getInput(el) {
    return el.querySelector(".aa-Input");
  }

  function getInstance(el) {
    return el.__aa_instance__ || null;
  }
  function setInstance(el, inst) {
    el.__aa_instance__ = inst;
  }
  function destroyInstance(el) {
    const inst = getInstance(el);
    if (inst && typeof inst.destroy === "function") {
      try {
        inst.destroy();
      } catch (e) {
        warn("destroyInstance error", e);
      }
    }
    el.__aa_instance__ = null;
    el.__aa_choices__ = null;
  }

  function normalize(str) {
    return str
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "");
  }

  const binding = new Shiny.InputBinding();

  $.extend(binding, {
    find(scope) {
      return $(scope).find("div.typeahead-container");
    },

    getId(el) {
      return el.id;
    },

    initialize(el) {
      const options = parseJSONAttr(el, "data-options", {}) || {};
      const choices = parseJSONAttr(el, "data-source", []) || [];
      const initialValue = el.getAttribute("data-value") || "";
      const placeholder = el.getAttribute("data-placeholder") || "";
      const limit = options.limit || 8;
      const minLength = options.minLength || 1;

      el.__aa_choices__ = choices;

      const inst = autocomplete({
        container: el,
        placeholder: placeholder,
        openOnFocus: false,
        initialState: {
          query: initialValue,
        },
        getSources: ({ query }) => {
          if (query.length < minLength) return [];
          const q = normalize(query);
          const items = (el.__aa_choices__ || [])
            .filter((item) => normalize(item).includes(q))
            .slice(0, limit)
            .map((item) => ({ label: item }));
          return [
            {
              sourceId: "local",
              getItems: () => items,
              getItemInputValue: ({ item }) => item.label,
              templates: {
                item: ({ item, html }) => {
                  return html`<div class="aa-ItemContent">${item.label}</div>`;
                },
              },
            },
          ];
        },
        onStateChange: ({ state, prevState }) => {
          if (state.query !== prevState.query) {
            log("stateChange", { id: el.id, query: state.query });
            $(el).trigger("change");
          }
        },
      });

      setInstance(el, inst);
      log("initialize done", { id: el.id, choices: choices.length });
    },

    getValue(el) {
      const input = getInput(el);
      return input ? input.value || "" : "";
    },

    setValue(el, value) {
      const inst = getInstance(el);
      if (inst) {
        inst.setQuery(value == null ? "" : String(value));
      }
    },

    receiveMessage(el, data) {
      log("receiveMessage", { id: el.id, data });

      if (Object.prototype.hasOwnProperty.call(data, "choices")) {
        const arr = Array.isArray(data.choices) ? data.choices : [];
        el.__aa_choices__ = arr;
        el.setAttribute("data-source", JSON.stringify(arr));
        const inst = getInstance(el);
        if (inst) {
          inst.refresh();
        }
      }

      if (Object.prototype.hasOwnProperty.call(data, "value")) {
        this.setValue(el, data.value);
      }

      $(el).trigger("change");
    },

    subscribe(el, callback) {
      log("subscribe", { id: el.id });
      $(el).on("change.typeaheadBinding", () => {
        callback();
      });

      // Also listen for direct input on the Algolia input
      const input = getInput(el);
      if (input) {
        $(input).on("input.typeaheadBinding", () => {
          callback();
        });
      }
    },

    unsubscribe(el) {
      log("unsubscribe", { id: el.id });
      $(el).off(".typeaheadBinding");
      const input = getInput(el);
      if (input) {
        $(input).off(".typeaheadBinding");
      }
      destroyInstance(el);
    },
  });

  Shiny.inputBindings.register(binding, "typeahead.algolia");
})();
