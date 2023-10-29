<script>
    import websites from "./lib/websites.js";

    const SEARCH_PREFIX = "https://www.google.com/search?q=";

    let inpsearch;

    function onWindowKeyUp(e) {
        if(e.key === " " && document.activeElement !== inpsearch) {}
            inpsearch.focus();
    }

    function onInputKeyUp(e) {
        if(e.key !== "Enter") return;

        let value = e.target.value.trim();
        if(!value) return;

        inpsearch.disabled = true;
        window.location.href = SEARCH_PREFIX + encodeURIComponent(value);
    }
</script>

<svelte:window on:keyup={onWindowKeyUp} />

<div class="flex justify-center items-center h-screen flex-col gap-y-5 bg-[#F9F9FB]">
    <input class="w-3/4" type="text" placeholder="Search" on:keyup={onInputKeyUp} on:focus={e => e.target.select()} bind:this={inpsearch}/>
    <div class="grid grid-cols-3 md:grid-cols-7 gap-5">
        {#each websites as ws}
            <div class="flex flex-col gap-y-3 w-28">
                <a href={ws.url} class="flex-1 border rounded p-5 shadow hover:border-primary">
                    <img class="object-contain h-full w-full" src={ws.logo} alt={ws.label}/>
                </a>
                <div class="text-center">{ws.label}</div>
            </div>
        {/each}
    </div>
</div>
