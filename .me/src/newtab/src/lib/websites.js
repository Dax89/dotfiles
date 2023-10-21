import ImgYouTube from "./img/youtube.png";
import ImgSteam from "./img/steam.svg";
import Img3BMeteo from "./img/3bmeteo.png";
import ImgGitHub from "./img/github.png";
import ImgTwitter from "./img/twitter.png";
import ImgReddit from "./img/reddit.png";
import ImgMemoryAlpha from "./img/memoryalpha.svg";
import ImgCAAutoBank from "./img/caautobank.png";
import ImgSella from "./img/sella.png";
import ImgAmazon from "./img/amazon.jpg";
import ImgeBay from "./img/ebay.jpg";
import ImgREDasm from  "./img/redasm.png";
import ImgSpotify from "./img/spotify.svg";
import ImgPinterest from "./img/pinterest.png";

function website(label, url, logo) { 
    return { label, url, logo };
}

export default [
    website("Steam", "https://steamcommunity.com/id/dax89", ImgSteam),
    website("YouTube", "https://www.youtube.com/feed/subscriptions", ImgYouTube),
    website("3BMeteo", "https://www.3bmeteo.com/meteo/macomer", Img3BMeteo),
    website("GitHub", "https://github.com", ImgGitHub),
    website("Twitter", "https://twitter.com", ImgTwitter),
    website("Reddit", "https://reddit.com", ImgReddit),
    website("Memory Alpha", "https://memory-alpha.fandom.com", ImgMemoryAlpha),
    website("CA Auto Bank", "https://www.ca-autobank.it/my-ca-autobank", ImgCAAutoBank),
    website("Sella", "https://www.sella.it", ImgSella),
    website("Amazon", "https://www.amazon.it", ImgAmazon),
    website("eBay", "https://www.ebay.it", ImgeBay),
    website("REDasm", "https://redasm.io", ImgREDasm),
    website("Spotify", "https://open.spotify.com", ImgSpotify),
    website("Pinterest", "https://www.pinterest.it", ImgPinterest),
];
