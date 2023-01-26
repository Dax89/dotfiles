<script>
    import searches from "./lib/searches.js";
    import websites from "./lib/websites.js";

    let selsearch = 0, q = "";

    function doSearch() {
        if(!q) return;
        window.location.href = searches[selsearch].url + q;
    }

    function onKeyDown(e) {
        if(!q || e.key !== "Enter") return;
        e.preventDefault();
        doSearch();
    }
</script>

<div class="flex justify-center items-center h-screen flex-col gap-y-10 bg-[#F9F9FB]">
  <div class="flex gap-x-6" style:height="82px">
    <img class="object-contain" alt="logo" src="chrome://branding/content/about-logo.png"/>
    <img class="object-contain" alt="logotext" src="chrome://branding/content/firefox-wordmark.svg"/>
  </div>
   <div class="text-center">
        <div class="input-group input-group-lg">
            <select class="select select-bordered" bind:value={selsearch}>
                {#each searches as s, i}
                    <option value="{i}">{s.name}</option>
                {/each}
            </select>
            <input class="input input-bordered w-full" type="text" placeholder="Search..." autofocus bind:value={q} on:keydown={onKeyDown}/>
            <button class="btn btn-square" on:click={doSearch} disabled={!q}>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </button>
        </div>
    </div>
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
