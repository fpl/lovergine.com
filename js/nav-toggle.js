// Collapsible site menu for narrow screens.
//
// The menu is only collapsed by the CSS when <html> has the "js" class
// (set by an inline script in <head>), so without JavaScript the full
// menu simply stays visible.  The button is hidden on wide screens.
(function () {
  document.addEventListener('DOMContentLoaded', function () {
    var button = document.querySelector('.nav-toggle');
    var nav = document.querySelector('.nav');
    if (!button || !nav) return;

    function setOpen(open) {
      nav.classList.toggle('open', open);
      button.setAttribute('aria-expanded', open ? 'true' : 'false');
      button.setAttribute('aria-label', open ? 'Close menu' : 'Menu');
      button.setAttribute('title', open ? 'Close menu' : 'Menu');
    }

    button.addEventListener('click', function () {
      setOpen(!nav.classList.contains('open'));
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && nav.classList.contains('open')) {
        setOpen(false);
        button.focus();
      }
    });
  });
})();
