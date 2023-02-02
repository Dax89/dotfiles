<script>
    import websites from "./lib/websites.js";
</script>

<div class="flex justify-center items-center h-screen flex-col gap-y-10 bg-[#F9F9FB]">
  <div class="flex gap-x-6" style:height="82px">
    <img class="object-contain" alt="logo" src="chrome://branding/content/about-logo.png"/>
    <img class="object-contain" alt="logotext" src="chrome://branding/content/firefox-wordmark.svg"/>
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
