// ==UserScript==
// @name         GitHub Pull Request Branch Links
// @version      0.1
// @description  Open in a new tab the clicked branch on a pull request page.
// @author       Ionică Bizău, Nikos Filippakis
// @match        https://github.com/*/*/pull/*
// @grant        none
// ==/UserScript==

window.addEventListener("load", function () {
    if (!/^https\:\/\/github\.com\/[a-z]+\/.*\/pull\/[0-9]+/i.test(location.href)) { return; }
    document.querySelectorAll(".commit-ref").forEach(function(cRef) {
        var parts = cRef.title.split(':');
        var url = '/' + parts[0] + (parts[1] ? '/tree/' + parts[1] : '');
        cRef.innerHTML = `<a href="${url}" style="text-decoration: none;">${cRef.innerHTML}</a>`;
    });
});