// Light/dark/auto theme toggle.
//
// The initial theme (avoiding a flash of the wrong colors) is applied
// by an inline script in <head>, before this file loads; this file
// only wires up the button so clicking it cycles through the modes.
(function () {
  var STORAGE_KEY = 'theme';
  var MODES = ['auto', 'light', 'dark'];
  var LABELS = { auto: 'Auto (follows system)', light: 'Light', dark: 'Dark' };

  function getStored() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  }

  function setStored(mode) {
    try {
      localStorage.setItem(STORAGE_KEY, mode);
    } catch (e) {}
  }

  function apply(mode) {
    if (mode === 'auto') {
      document.documentElement.removeAttribute('data-theme');
    } else {
      document.documentElement.setAttribute('data-theme', mode);
    }
  }

  function updateButton(button, mode) {
    button.setAttribute('data-mode', mode);
    button.setAttribute('aria-label', 'Theme: ' + LABELS[mode] + ' (click to change)');
    button.setAttribute('title', 'Theme: ' + LABELS[mode]);
  }

  document.addEventListener('DOMContentLoaded', function () {
    var button = document.querySelector('.theme-toggle');
    if (!button) return;

    var current = getStored() || 'auto';
    updateButton(button, current);

    button.addEventListener('click', function () {
      current = MODES[(MODES.indexOf(current) + 1) % MODES.length];
      setStored(current);
      apply(current);
      updateButton(button, current);
    });
  });
})();
