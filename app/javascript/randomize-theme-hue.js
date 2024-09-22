// The hue only changes on initial site load/refresh; because Turbo does hot content replacement,
// the Javascript doesn’t run on link navigation.

var hue = Math.round(Math.random() * 360);
document.documentElement.style.setProperty("--theme-hue0", hue);
document.documentElement.style.setProperty("--theme-hue1", hue + 180);
