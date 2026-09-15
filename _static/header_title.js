/* Persistent HART title in the Jupyter Book top header.
   Loaded globally through _config.yml. */
(function () {
  function addHartHeaderTitle() {
    const header = document.querySelector("header.bd-header, .bd-header");
    if (!header) return false;

    const inner =
      header.querySelector(".bd-header__inner") ||
      header.querySelector(".navbar-header-items") ||
      header;

    if (inner.querySelector(".hart-top-title")) return true;

    const title = document.createElement("a");
    title.className = "hart-top-title";
    title.textContent =
      "Using Humic Acid for Nutrient Reduction and Red Tide Mitigation";

    const brand = document.querySelector(
      ".bd-sidebar-primary .navbar-brand, .navbar-brand"
    );
    title.href = brand && brand.href ? brand.href : "./";
    title.setAttribute("aria-label", "HART home");

    inner.appendChild(title);
    return true;
  }

  function init() {
    if (addHartHeaderTitle()) return;

    let attempts = 0;
    const timer = window.setInterval(function () {
      attempts += 1;
      if (addHartHeaderTitle() || attempts >= 20) {
        window.clearInterval(timer);
      }
    }, 100);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, { once: true });
  } else {
    init();
  }
})();
