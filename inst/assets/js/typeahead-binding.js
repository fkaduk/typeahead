// typeahead-binding.js
// Assumes typeahead-standalone UMD (window.typeahead) + jQuery.

(function () {
  // Toggle this to silence logs
  const DEBUG = true;
  const log = (...args) => {
    if (DEBUG) console.debug("[typeahead]", ...args);
  };
  const warn = (...args) => {
    if (DEBUG) console.warn("[typeahead]", ...args);
  };
  const err = (...args) => console.error("[typeahead]", ...args);

  function parseJSONAttr(el, attr, fallback) {
    const raw = el.getAttribute(attr);
    log("parseJSONAttr", { id: el.id, attr, raw });
    if (!raw) return fallback;
    try {
      const v = JSON.parse(raw);
      log("parseJSONAttr OK", { id: el.id, attr, type: typeof v, sample: v });
      return v;
    } catch (e) {
      warn("parseJSONAttr FAIL", { id: el.id, attr, raw, error: e });
      return fallback;
    }
  }

  function getInstance(el) {
    return el.__ta_instance__ || null;
  }
  function setInstance(el, inst) {
    el.__ta_instance__ = inst;
  }
  function destroyInstance(el) {
    const inst = getInstance(el);
    if (inst && typeof inst.destroy === "function") {
      log("destroyInstance", el.id);
      try {
        inst.destroy();
      } catch (e) {
        warn("destroyInstance error", e);
      }
    }
    el.__ta_instance__ = null;
  }

  const binding = new Shiny.InputBinding();

  $.extend(binding, {
    find(scope) {
      const $els = $(scope).find("input.typeahead-standalone");
      log("find", { count: $els.length });
      return $els;
    },

    getId(el) {
      return el.id;
    },

    initialize(el) {
      log("initialize start", { id: el.id, value: el.value });
      const options = parseJSONAttr(el, "data-options", {}) || {};
      const local = parseJSONAttr(el, "data-source", []) || [];

      const inst = window.typeahead({
        input: el,
        source: { local },
        ...options,
        onSelect: (item) => {
          const t = typeof item;
          log("onSelect", { id: el.id, typeof: t, item });
          // Force a primitive string for Shiny
          const str =
            t === "string"
              ? item
              : (item &&
                  (item.label ??
                    item.value ??
                    (item.toString && item.toString()))) ||
                "";
          el.value = String(str);
          log("onSelect -> set el.value", { id: el.id, value: el.value });
          // notify Shiny without payload
          $(el).trigger("input");
        },
      });

      setInstance(el, inst);
      log("initialize done", {
        id: el.id,
        local_size: Array.isArray(local) ? local.length : null,
      });
    },

    getValue(el) {
      const v = el.value || "";
      log("getValue", { id: el.id, type: typeof v, value: v });
      // MUST be a primitive; object here triggers "Unexpected input value mode"
      return v;
    },

    setValue(el, value) {
      const v = value == null ? "" : String(value);
      log("setValue", {
        id: el.id,
        incoming_type: typeof value,
        incoming: value,
        set: v,
      });
      el.value = v;
    },

    receiveMessage(el, data) {
      log("receiveMessage START", { id: el.id, data });

      if (Object.prototype.hasOwnProperty.call(data, "value")) {
        this.setValue(el, data.value);
      }
      if (Object.prototype.hasOwnProperty.call(data, "choices")) {
        const arr = Array.isArray(data.choices) ? data.choices : [];
        log("receiveMessage choices", {
          id: el.id,
          len: arr.length,
          sample: arr.slice(0, 5),
        });
        el.setAttribute("data-source", JSON.stringify(arr));

        const inst = getInstance(el);
        if (inst) {
          log("receiveMessage reset+addToIndex", { id: el.id });
          const currentValue = el.value;
          inst.reset(true);
          inst.addToIndex(arr);
          // reset() clears el.value; restore and dispatch a native
          // InputEvent so the library re-searches with the current query
          el.value = currentValue;
          el.dispatchEvent(
            new InputEvent("input", {
              bubbles: true,
              inputType: "insertText",
              data: currentValue,
            }),
          );
        }
      }

      // Notify Shiny that the value may have changed
      $(el).trigger("input");
      log("receiveMessage END", { id: el.id, value: el.value });
    },

    subscribe(el, callback) {
      log("subscribe", { id: el.id });
      const $el = $(el);
      const handler = (ev) => {
        // DO NOT pass arguments to callback; Shiny expects none
        log("event -> callback()", {
          id: el.id,
          ev: ev.type,
          value: el.value,
          type: typeof el.value,
        });
        try {
          callback();
        } catch (e) {
          err("callback error", e);
        }
      };
      $el.on("input.typeaheadBinding change.typeaheadBinding", handler);
      el.__ta_handler__ = handler;

      // Extra: log focus/blur for debugging
      $el.on("focus.typeaheadBinding blur.typeaheadBinding", (ev) =>
        log("event", { id: el.id, ev: ev.type, value: el.value }),
      );
    },

    unsubscribe(el) {
      log("unsubscribe", { id: el.id });
      $(el).off(".typeaheadBinding");
      destroyInstance(el);
      el.__ta_handler__ = null;
    },
  });

  Shiny.inputBindings.register(binding, "typeahead.standalone.debug");
})();
