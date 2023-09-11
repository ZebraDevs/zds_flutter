'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "2bab9f0c4725ec2b8659843d469b5143",
"index.html": "2a0fe39675db90726d51db3f1ca0338e",
"/": "2a0fe39675db90726d51db3f1ca0338e",
"main.dart.js": "b9944460d3c81178d17249ff92b6a5cb",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "15f73b7e8a8209c2206210b3ac8dea1b",
"assets/AssetManifest.json": "9f912c637e6ac394634a0ecb7db609cd",
"assets/NOTICES": "33b1ec8c09db5b0a56a34720b609dbfc",
"assets/FontManifest.json": "3966bba59116789ccdfe283ba933d673",
"assets/packages/giphy_get/assets/img/GIPHY_light.png": "7c7ed0e459349435c6694a720236d5f4",
"assets/packages/giphy_get/assets/img/poweredby_dark.png": "e4fe68503ab5d004deb31e43636a0a7c",
"assets/packages/giphy_get/assets/img/poweredby_light.png": "439da1ed3ca70fb090eb98698485c21e",
"assets/packages/giphy_get/assets/img/GIPHY_dark.png": "13139c9681ad6a03a0f4a45030aee388",
"assets/packages/zeta_flutter/lib/src/assets/fonts/IBMPlexSans-Medium.otf": "6ea277ff8637af42ff46683e7b4e0d63",
"assets/packages/zeta_flutter/lib/src/assets/fonts/IBMPlexSans-Light.otf": "72ed01a73518190d1c5d36042b37a626",
"assets/packages/zeta_flutter/lib/src/assets/fonts/IBMPlexSans-Regular.otf": "05b9240dd80b2276729426b2be2e9947",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "1e17b1ec3152f29bf783bd42db8b6023",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "093d2cde7075fcffb24ab215668d0da2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "5ac99533bd9dc46227434b4853c3e532",
"assets/packages/zds_flutter/lib/assets/strings/zh.json": "d8447e4e93ab608ee4b2a3d628a12c3d",
"assets/packages/zds_flutter/lib/assets/strings/tr.json": "e2f806c7163dd2dfe0cb8e872074e1a8",
"assets/packages/zds_flutter/lib/assets/strings/mk.json": "8fe1948d6a14887b109ccbc405f907fd",
"assets/packages/zds_flutter/lib/assets/strings/sl.json": "0a44d65ea07a863632a1c3d3c344469a",
"assets/packages/zds_flutter/lib/assets/strings/hu.json": "b604347444977b374b34c506d086945a",
"assets/packages/zds_flutter/lib/assets/strings/lt.json": "88b39031b9a7e0b76e2602b578d6e13f",
"assets/packages/zds_flutter/lib/assets/strings/zh_HK.json": "d8447e4e93ab608ee4b2a3d628a12c3d",
"assets/packages/zds_flutter/lib/assets/strings/fr_BE.json": "04355bd9ff128be081919a1fed1665e2",
"assets/packages/zds_flutter/lib/assets/strings/es_ES.json": "0dfb0ee9bad5b600d67c3882a3c4895d",
"assets/packages/zds_flutter/lib/assets/strings/nl.json": "d1fa3cb4e4e5dc796605859b5653a5c9",
"assets/packages/zds_flutter/lib/assets/strings/de_AT.json": "7b96eec3f9ef03cb51e9903915e94851",
"assets/packages/zds_flutter/lib/assets/strings/es_PE.json": "66b2471b20ac13239178b962e1d8c0c2",
"assets/packages/zds_flutter/lib/assets/strings/ja.json": "a9053469da899266d81f03449c93bbab",
"assets/packages/zds_flutter/lib/assets/strings/de.json": "7b96eec3f9ef03cb51e9903915e94851",
"assets/packages/zds_flutter/lib/assets/strings/es_CL.json": "372385b7fb4cc7054acb95383f58e0f1",
"assets/packages/zds_flutter/lib/assets/strings/ru.json": "b996cfdc6856e68c499bb50116ec667f",
"assets/packages/zds_flutter/lib/assets/strings/pl.json": "498a1515c9ac3d0cc8e390e6fcf8c73a",
"assets/packages/zds_flutter/lib/assets/strings/uk.json": "a8f970e0b974c90c370ba794c96eb9a6",
"assets/packages/zds_flutter/lib/assets/strings/en_CA.json": "6747d5f0af8fbd22711f4aa8c9c1ad57",
"assets/packages/zds_flutter/lib/assets/strings/fi.json": "c0a725d6bba269532b7d4e7f18d738a0",
"assets/packages/zds_flutter/lib/assets/strings/fr_CH.json": "04355bd9ff128be081919a1fed1665e2",
"assets/packages/zds_flutter/lib/assets/strings/sk.json": "52223c52bd839135a638bc9a36cbfdc8",
"assets/packages/zds_flutter/lib/assets/strings/pt.json": "eb4d5a03f12be77975264a47e48dcec7",
"assets/packages/zds_flutter/lib/assets/strings/en.json": "6747d5f0af8fbd22711f4aa8c9c1ad57",
"assets/packages/zds_flutter/lib/assets/strings/ka.json": "c59bf1b20ccb8af47ebc85e046cc8b4e",
"assets/packages/zds_flutter/lib/assets/strings/it.json": "53011908adb49930a61fc6e1a472f60c",
"assets/packages/zds_flutter/lib/assets/strings/sr.json": "e45e039ef6f3b4075e79008a80ff640d",
"assets/packages/zds_flutter/lib/assets/strings/hr.json": "9813be7a4f08831d2d737804cefbee5e",
"assets/packages/zds_flutter/lib/assets/strings/tl.json": "3c48afd6a922580fc31d71c698f98872",
"assets/packages/zds_flutter/lib/assets/strings/es_EC.json": "66b2471b20ac13239178b962e1d8c0c2",
"assets/packages/zds_flutter/lib/assets/strings/en_GB.json": "a1c08236d3e5c0e4434db175fa086924",
"assets/packages/zds_flutter/lib/assets/strings/de_CH.json": "492deb09c183d3725e7a872a97d75ed0",
"assets/packages/zds_flutter/lib/assets/strings/sq.json": "79f7fdfa6328eb8e247368b2001c0bce",
"assets/packages/zds_flutter/lib/assets/strings/in.json": "7013eacd720167433dc55519c7449709",
"assets/packages/zds_flutter/lib/assets/strings/bs.json": "7993650c181a0b672fa9755f573f635b",
"assets/packages/zds_flutter/lib/assets/strings/fr.json": "01ba2452bdd11b11d48d62725b7b38fc",
"assets/packages/zds_flutter/lib/assets/strings/el.json": "39fdde3f92205f60d8bb66cafedbd182",
"assets/packages/zds_flutter/lib/assets/strings/bg.json": "a6526d253874fd6214fe3c4ad60d607d",
"assets/packages/zds_flutter/lib/assets/strings/ro.json": "36f84f71983546e9a47690795fd1188f",
"assets/packages/zds_flutter/lib/assets/strings/ko.json": "f0212f1c6f34afcad209080f5f29a518",
"assets/packages/zds_flutter/lib/assets/strings/vi.json": "bf8d22c64c9c521ced872fb17f9fce2c",
"assets/packages/zds_flutter/lib/assets/strings/cs.json": "2a55d911d374d83255630caaa0b24c67",
"assets/packages/zds_flutter/lib/assets/strings/pt_BR.json": "e6a18901faeb0ccbc848c85fb190e9eb",
"assets/packages/zds_flutter/lib/assets/strings/lv.json": "95883875a01879208a2487831e9637c7",
"assets/packages/zds_flutter/lib/assets/strings/da.json": "65083263bed92c40f73844a41d7f77cf",
"assets/packages/zds_flutter/lib/assets/strings/th.json": "b462bfbad8eb75fd046068a6c6652cab",
"assets/packages/zds_flutter/lib/assets/strings/sv.json": "3c5664ee9fc8735a47753fd8a5262b23",
"assets/packages/zds_flutter/lib/assets/strings/es_UY.json": "66b2471b20ac13239178b962e1d8c0c2",
"assets/packages/zds_flutter/lib/assets/strings/es.json": "2bea7ba2b12f10f61b28f5baf1f7d76b",
"assets/packages/zds_flutter/lib/assets/strings/fr_CA.json": "364822436f4f88f6d9cc14eb88f3fa9c",
"assets/packages/zds_flutter/lib/assets/strings/ar.json": "588bb655f20d4d39126f3a8001bfc0ea",
"assets/packages/zds_flutter/lib/assets/strings/nb.json": "aa3ec0450022ad5e22e918dba4bb86e1",
"assets/packages/zds_flutter/lib/assets/strings/de_BE.json": "0a7d4bef95642311d4633186ba8d61c7",
"assets/packages/zds_flutter/lib/assets/strings/es_PR.json": "66b2471b20ac13239178b962e1d8c0c2",
"assets/packages/zds_flutter/lib/assets/images/search.svg": "79b7ce956cdf0a63c1af7c04be0956a2",
"assets/packages/zds_flutter/lib/assets/images/notes.svg": "5ca34a0734c621172f00cca3e6ee7f65",
"assets/packages/zds_flutter/lib/assets/images/load_fail.svg": "7c751f1b6a3d324f45730a20f0645706",
"assets/packages/zds_flutter/lib/assets/images/sleeping_zebra.svg": "8eb606f390f1bd27d5805790b83b4805",
"assets/packages/zds_flutter/lib/assets/images/completed_tasks.svg": "0dc32bc07940c6b4a5c9607ad7473191",
"assets/packages/zds_flutter/lib/assets/images/map.svg": "cb867dde3c42171f5149d5f47bdb1d8c",
"assets/packages/zds_flutter/lib/assets/images/cloud_fail.svg": "8a86ae2f4b82c4adcfafaeea80bc98df",
"assets/packages/zds_flutter/lib/assets/images/sad_zebra.svg": "f3c754f52a7679fb5275cb3902de459b",
"assets/packages/zds_flutter/lib/assets/images/chat.svg": "9c280d1b4a767df3784d10e463d7dee5",
"assets/packages/zds_flutter/lib/assets/images/server_fail.svg": "d20bc5ecaa1d0681198fd0289565f12f",
"assets/packages/zds_flutter/lib/assets/images/empty_box.svg": "34fcee2d89e36a035a22d687e57ccfdc",
"assets/packages/zds_flutter/lib/assets/images/punch.svg": "8e65a1dfaa58ec27ac40f7cbb88e4385",
"assets/packages/zds_flutter/lib/assets/images/calendar.svg": "8f8779a6f7c1cec4fec20ae3a5b04c6d",
"assets/packages/zds_flutter/lib/assets/images/notifications.svg": "a03c4a5e18990a6f598cc1c1c81bdaea",
"assets/packages/zds_flutter/lib/assets/fonts/selection.json": "a948f8250305213b3aabce1a325a3ee1",
"assets/packages/zds_flutter/lib/assets/fonts/zds.ttf": "1910d48096922937643864fd1f37cd82",
"assets/packages/zds_flutter/lib/assets/animations/thumbs_up_approved.json": "3d1324d15e8f9b0b656f3aca3ef460f7",
"assets/packages/zds_flutter/lib/assets/animations/time_approved.json": "f231a4009d94c46fe7f2306496f9f70b",
"assets/packages/zds_flutter/lib/assets/animations/time_approved_glimmer.json": "611fe564b1e7121458985e9b1f6cb8e8",
"assets/packages/zds_flutter/lib/assets/animations/two_checks.json": "65a5bddc7a4fe4a1499be20af35c1e3c",
"assets/packages/zds_flutter/lib/assets/animations/check_glimmer.json": "1f46d17f1bd17217ba5eb116fa290287",
"assets/packages/zds_flutter/lib/assets/animations/thumbs_up.json": "087bcb9e38fab38104bf64a83faedba0",
"assets/packages/zds_flutter/lib/assets/animations/approval_stamped.json": "8f6527f26ce5c233fea820941c4adab9",
"assets/packages/zds_flutter/lib/assets/animations/check.json": "ca516f06102d727d8e25fb6fa70e747a",
"assets/packages/zds_flutter/lib/assets/animations/check_ripple.json": "74638175550f77bd357a48de6d36e4cb",
"assets/packages/zds_flutter/lib/assets/animations/check_circle.json": "0893f6c2feebfcd4bc66838ce67b3f06",
"assets/packages/zds_flutter/lib/assets/animations/time_approved_box.json": "f106c3354e66fd07eb82b382e03e7066",
"assets/packages/zds_flutter/lib/assets/animations/timecard_tapping.json": "1aa17c200fa6f3d743e4e63f61947cad",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "ce031dcdd2255e75b97414068230a430",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
