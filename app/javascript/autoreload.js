// Presence of class="autoreload" anywhere on the page triggers autoreload behavior
function findAutoreload() {
    return document.querySelector(".autoreload")
}

var refreshTimer;

// Clear any existing timer before visiting a new page
document.addEventListener("turbo:visit", (event) => {
    if (refreshTimer) {
        clearTimeout(refreshTimer);
        refreshTimer = null;
    }
});

// Check page for autoreload whenever content changes
document.addEventListener("turbo:load", (event) => {
    if (findAutoreload()) {
        refreshTimer = setTimeout(
            () => {
                refreshTimer = null;
                Turbo.visit(event.detail.url);
            },
            2000
        );
    }
});
