function search(name, url, key) { return {name, url, key}; }

export default [
    search("Google", "https://www.google.com/search?q=", "g"),
    search("Wikipedia", "https://en.wikipedia.org/wiki/", "w"),
    search("C++ Reference", "https://duckduckgo.com/?sites=cppreference.com&q=", "c"),
];
