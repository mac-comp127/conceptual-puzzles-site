function findExpandingIframes() {
  return document.querySelectorAll("iframe.expand-to-content-height");
}

function resizeIframes() {
  for (let iframe of findExpandingIframes()) {
    iframe.style.height = (iframe.contentWindow.document.documentElement.scrollHeight + 50) + 'px';
  }
};


document.addEventListener("load", resizeIframes);
document.addEventListener("turbo:load", () => {
  for (let iframe of findExpandingIframes()) {
    iframe.addEventListener("load", resizeIframes);
  }
  resizeIframes();  // in case it’s already loaded
});
window.addEventListener("resize", resizeIframes);
