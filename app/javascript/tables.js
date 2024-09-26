document.addEventListener("click", e => {
    // Search for:
    // - an ancestor <tr> element
    // - and an ancestor .row-click element
    // - up to but not past the nearest <table> ancestor

    var row = null;
    var rowClickEnabled = false;
    for (var elem = e.target; elem; elem = elem.parentNode) {
        if (elem.tagName == "TR") {
            row = elem;
        }
        if (elem.classList && elem.classList.contains('row-click')) {
            rowClickEnabled = true;
            break;
        }
        if (elem.tagName == "TABLE" || elem.tagName == "A") {
            break;
        }
    }

    if (rowClickEnabled && row) {
        Turbo.visit(row.querySelector("a").href);
        e.preventDefault();
    }
});
