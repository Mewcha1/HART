(function () {

    function addHartHeaderTitle() {

        const header = document.querySelector(".bd-header");

        if (!header) return;

        // Prevent duplicate title
        if (header.querySelector(".hart-top-title")) return;

        const title = document.createElement("div");

        title.className = "hart-top-title";
        title.textContent =
            "Using Humic Acid for Nutrient Reduction and Red Tide Mitigation";

        // Add directly to the global header
        header.appendChild(title);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", addHartHeaderTitle);
    } else {
        addHartHeaderTitle();
    }

})();