<script>
    function search(name, url) { return {name, url}; }
    function website(label, url, logo) { return {label, url, logo}; }

    const WEBSITES = [
        website("Steam", "https://steamcommunity.com/id/dax89", "https://upload.wikimedia.org/wikipedia/commons/8/83/Steam_icon_logo.svg"),
        website("YouTube", "https://youtube.com", "https://upload.wikimedia.org/wikipedia/commons/e/ef/Youtube_logo.png"),
        website("3BMeteo", "https://www.3bmeteo.com/meteo/macomer", "https://www.3bmeteo.com/images/site/logo_3b.png"),
        website("GitHub", "https://github.com", "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"),
        website("Twitter", "https://twitter.com", "https://upload.wikimedia.org/wikipedia/commons/4/4f/Twitter-logo.svg"),
        website("Reddit", "https://reddit.com", "https://www.redditinc.com/assets/images/site/reddit-logo.png"),
        website("Notion", "https://www.notion.so", "https://upload.wikimedia.org/wikipedia/commons/e/e9/Notion-logo.svg"),
        website("FCA", "https://fcabank.it/area-clienti", "https://fcabankgroup.com/images/icons/flags/IconaDrivalia.png"),
        website("Sella", "https://www.sella.it", "https://upload.wikimedia.org/wikipedia/commons/1/15/Banca_Sella_Logo.png"),
        website("Amazon", "https://www.amazon.it", "https://www.niascaportofino.it/wp-content/uploads/2016/10/amazon-logo.jpg"),
        website("eBay", "https://www.ebay.it", "https://img.freepik.com/free-icon/ebay_318-674223.jpg?w=2000"),
        website("ChatGPT", "https://chat.openai.com", "https://seeklogo.com/images/C/chatgpt-logo-02AFA704B5-seeklogo.com.png"),
        website("GodBolt", "https://godbolt.org", "https://avatars.githubusercontent.com/u/57653830"),
        website("Pinterest", "https://www.pinterest.it", "https://play-lh.googleusercontent.com/dVsv8Hc4TOUeLFAahxR8KANg22W9dj2jBsTW1VHv3CV-5NCZjP9D9i2j5IpfVx2NTB8=s0?imgmax=0"),
    ];

    const SEARCHES = [
        search("Google", "https://www.google.com/search?q="),
        search("CppReference", "https://duckduckgo.com/?sites=cppreference.com&q="),
    ];

    let selsearch = 0, q = "";

    function doSearch() {
        if(!q) return;
        window.location.href = SEARCHES[selsearch].url + q;
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
   <div class="text-center w-1/3">
        <div class="input-group input-group-lg">
            <select class="select select-bordered" bind:value={selsearch}>
                {#each SEARCHES as s, i}
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
    <div class="grid grid-cols-7 gap-5 w-4/12">
        {#each WEBSITES as ws}
            <div class="flex flex-col gap-y-3">
                <a href={ws.url} class="flex-1 border rounded p-5 shadow hover:border-primary">
                    <img class="object-contain h-full w-full" src={ws.logo} alt={ws.label}/>
                </a>
                <div class="text-center">{ws.label}</div>
            </div>
        {/each}
    </div>
</div>
