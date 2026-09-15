(function () {

    function addHartHeaderTitle() {

        const header = document.querySelector(".bd-header");

        if (!header) return;

        if (header.querySelector(".hart-top-title")) return;

        const title = document.createElement("div");

        title.className = "hart-top-title";
        title.textContent =
            "Using Humic Acid for Nutrient Reduction and Red Tide Mitigation";

        /* IMPORTANT: append directly to the full header */
        header.appendChild(title);
    }

    if (document.readyState === "loading") {
        document.addEventListener(
            "DOMContentLoaded",
            addHartHeaderTitle,
            { once: true }
        );
    } else {
        addHartHeaderTitle();
    }

})();