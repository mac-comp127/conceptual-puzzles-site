// Presence of class="autoreload" anywhere on the page triggers autoreload behavior
function findAutoreload() {
    return document.querySelector(".autoreload")
}

function findFlashes() {
    return document.querySelector(".flashes");
}

let refreshTimer;
let savedFlashes = null;  // so autoreload doesn't wipe out useful messages

// Clear any existing timer before visiting a new page
document.addEventListener("turbo:visit", (event) => {
    if (refreshTimer) {
        clearTimeout(refreshTimer);
        refreshTimer = null;
    }
});

// Check page for autoreload whenever content changes
document.addEventListener("turbo:load", (event) => {
    if (savedFlashes && savedFlashes.url == event.detail.url) {
        let flashes = findFlashes();
        if (flashes.children.length == 0) {
            flashes.replaceWith(savedFlashes.content);
        }
    }
    if (findAutoreload()) {
        refreshTimer = setTimeout(
            () => {
                refreshTimer = null;
                savedFlashes = { url: event.detail.url, content: findFlashes() };
                Turbo.visit(event.detail.url);
            },
            2000
        );
    }
});
