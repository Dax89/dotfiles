import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

const dev = process.env.NODE_ENV === "development";

export default defineConfig({
    plugins: [svelte()],
    base: dev ? "" : "/newtab",

    build: {
        outDir: "../../http/newtab",
        emptyOutDir: true,
    }
})
