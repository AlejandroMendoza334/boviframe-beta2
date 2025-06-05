'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "1399f45066802f7666ca4854834f8be8",
".git/config": "4d13f83610924402812b3df064140d02",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "093e34224cc7fcf33aefc98ea9939abe",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "9f25d30c5d0616b85ac13aa3714736f9",
".git/logs/refs/heads/main": "70c2b646d936305ae8c1845731270299",
".git/logs/refs/remotes/origin/main": "5c778f382c7d426b234f075648c2ec78",
".git/objects/07/22bb12f2ed9b33c0fd9deb33b0db32c538c855": "fda1749b69271b03cd093e27fd002384",
".git/objects/0d/b970f275b56928ed47214ce14a89528b0deada": "37a136bbef94374f73c3a9f7953aa1c2",
".git/objects/0f/3b5d511a2bf9f1b5418db14c9939660b3aa79b": "3b3f658b8e5e7912a726f7fff2527127",
".git/objects/10/78cda765d979b3beedc95a97c39fe0e7f77ed6": "d2cc6a3b861e5dc4b3d92f80704f77a8",
".git/objects/11/a7d24936257347e616e0f0cd1918d264f39b02": "584ce76d9485c16b2b4b664bf4bd2666",
".git/objects/21/4215a03b2343798e31d9cbcc9d8029380a11ad": "b0486f433d29368a047e2605d1a4d154",
".git/objects/24/651de3e40143f04cd1ad5d317dc09ac6d6ad20": "99c8eb695066e0c4fc74704179e72f12",
".git/objects/2c/5bcd94b10ca990c0e76f6931d30fe34cb9b43f": "134ebe8eb08d1b14a0e6ec87c2d2cde4",
".git/objects/2e/7e379eb58e46d00e20a15b901c24bcd1417c70": "226c76dcd88afe12d3b118618faa9b56",
".git/objects/2f/5cc8a5666866cabe32f29ca881cb0d62bf49bd": "efc2c4346f61190dfbaa3b3cf7556de8",
".git/objects/31/edfe0161ac7c9117968bc771793148e630f501": "fcc5d3924928b9eb3261fa4aeafc0a80",
".git/objects/3e/3fd2a57f4618bb8e8a961bebb824f7669740bc": "307c785a98120f5e7c635369a42a414c",
".git/objects/3f/d2c1a48381d3a4462f5e8810292ad0a960de4b": "e5e012cc76164913d8bb3277fb93fc4e",
".git/objects/40/1785df54352ae06d6dae7dec61ab1b69afcf6d": "cc7486f23537ace3d85a0ea5fecc33fc",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/48/37533a8ffb636e111644446b8b5254d152a146": "54ab11d80a5332cf91fd2999264849ea",
".git/objects/58/31840272dc1c691085a1cda9eff0467b035365": "adfbc6c173c4e9b037c82eb43ea9b9d0",
".git/objects/5e/e95ee7c4b7addb6bc26e13ed0bdc11fa1ea598": "c6575cf743c05b154c025fda5ae87a94",
".git/objects/6d/d9160f8bc5693dcffc2727a95292733fcd61f3": "d4e057688aeac25fd7402af8513c6e7f",
".git/objects/6f/005ddd54f7c9cd5fd83a786a196b23ddc86888": "c312d169e8d091656c6eee78fbc775ea",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "d95736cd43d2676a49e58b0ee61c1fb9",
".git/objects/73/9f6cedae530acead81b567c0936e3553069b3c": "b0b7be59f6b5fef1a5b4af3b7dffa809",
".git/objects/7f/6b35288a74e406bd0fb0506568ca4305011b36": "e386a1cf162c464d942f16479d904722",
".git/objects/83/b65a6e0a1ad028b2b47c6e761dbee2a1eaa4d9": "89f375982ab73b48aeab0bf0cba5e418",
".git/objects/85/4dbe932df8df6a75b12b4d07f62f655f155901": "c6d7f3406a7f24d06761264a41443bbe",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8d/e159903cca06dab0e9d8970e558663d8efdf0a": "70d70de8381980fbc54078540f1ac774",
".git/objects/8e/bf7f5481d1687c843bb29a337d4b9602952de4": "08720d5f1370df5a32ee5c0bc281ae9f",
".git/objects/9a/54a12e07518d774d1aec7f8994c2ac75cc147f": "62e5b19dc0e38064163a0f5de7638115",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "784f8e1966649133f308f05f2d98214f",
".git/objects/a3/5a24eb773f65c9808628a9aeac4bef367a6e54": "c407ac02fa739d1978b2f262e680787b",
".git/objects/a8/6f703084d17020859a78f48b1175cc0d672a94": "efb2d3f99c30fff1f13ae08e6c33b7a5",
".git/objects/ab/20d739260b059b1d97fe58e1333c2119c11105": "351194b43e881f30c683e227243649d8",
".git/objects/ab/b3a8125ad2e2af2143f6341c6a6cc0aa046bf0": "ff13e107ef73232bb8b31a825c2e3b22",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "4227e5e94459652d40710ef438055fe5",
".git/objects/c2/de2acec1324290949b2241c8c14a01b1913091": "5b0c52a514133f5d5dd0063460f063a0",
".git/objects/c3/6bf3064383b769138ebb4eab2871027c73eda4": "a6e88a19cdbc7edb33c7745e04616e0b",
".git/objects/cd/7b21e794f60be04e281a7ff40e9f8b710f614d": "ca86c5d10d76324722f825d21091f976",
".git/objects/d2/eb573169695b8a9a7389bc82add68b05db413e": "7387d9148bd5f6ebc931ddaa2671b254",
".git/objects/d3/a50a3db2546f068fe2f71d6ebfd63bce290178": "9e22736e074f0357ea59f7a2706235aa",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/5dce8b3664d9bbb66cfeea63a2d58b77ac816e": "a9cb0510b7c697b6bee12c71826ebad6",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "761c08dfe3c67fe7f31a98f6e2be3c9c",
".git/objects/e0/b0c1e02c0b56a84b4d052d764aee3a8dfb22d0": "1aebfce905471878499cce523ebf202f",
".git/objects/e4/fd53f12e19b8d859b5f66be79e72bb2abf699b": "a428c27319c2d6629de11dd5cebc0bd6",
".git/objects/e7/d106c4421e680481973b9d78dfbe4f0f09ed97": "f80fd6cdcf1f6c406f9dcf4ca6c55fc7",
".git/objects/e9/85853ed84acf10f62f639a4733083229c5a55d": "0fa4c11ffb67d2134def6bc8d43a77d3",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ec/949458f3a766fd5b59d728dafd9c92bf361684": "d0940c2df72efdb6c5d3eff9eb7b6325",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/55c80afa25a81e0f41faa1da6c57965e35726e": "86b4f8b6698d370fe1b6e490ae86ec4f",
".git/objects/f5/bad3b998e5657aea1a638cc6bf652fbb81ea1d": "2b2afcccacba54338fd7071efe218731",
".git/objects/fc/670d19e6e092a6aaa54a55eee38b010849b592": "db30ba7b07ab1aaa8d98491333de54a7",
".git/objects/ff/4db77ac5957d5cdf7e0e588f63de96aa1c6be9": "52059fa0d3cefdbeaec1a1f32d0bdff5",
".git/refs/heads/main": "8c901062d1d92ac327c40a1dc0db2eab",
".git/refs/remotes/origin/main": "8c901062d1d92ac327c40a1dc0db2eab",
".vercel/project.json": "3064cfc3afbbab3be712940a490315e4",
".vercel/README.txt": "2b13c79d37d6ed82a3255b83b6815034",
"assets/AssetManifest.bin": "69f32a6b8cf8ea2f18fe8cbf236feaf5",
"assets/AssetManifest.bin.json": "d77faa2a8ef8fa4c77059663fe86e6a2",
"assets/AssetManifest.json": "e46f8811ff8ae13483feedc072ffcf45",
"assets/assets/icons/IMAGOTIPO_BOVIFRAME_FONDODARK.jpg": "40ed663b2d5823ed2719e56ec9341ea4",
"assets/assets/icons/IMAGOTIPO_BOVIFRAME_SINFONDO.png": "ee6a0dd65ce7ebe20d09a6279b47cae1",
"assets/assets/img/bases_teoricas.jpg": "45ee87abc2adc18a429c3b6522de16bd",
"assets/assets/img/buscar.jpg": "10d95b51bd87c6197b733dc938200ae5",
"assets/assets/img/estadisticas.jpg": "f713c5118460aa89e4388a11183b88fb",
"assets/assets/img/facebook.png": "bf1b2e9f17e4869160342be8d2d6ca3c",
"assets/assets/img/google.png": "937c87b4439809d5b17b82728df09639",
"assets/assets/img/history.png": "2654d121461c7f7987d6d994a389e48d",
"assets/assets/img/icono_boviframe.png": "dd1136137a076c22f36116b2ffeef11f",
"assets/assets/img/indice.png": "8dd561c235955db74052c05c947e8c13",
"assets/assets/img/noticias.jpg": "787dd8b38810ca857e241a44cb85e916",
"assets/assets/img/OIP.jpg": "9bcd2c95192b524dd4aa0606a47ff92c",
"assets/assets/img/vaca.jpg": "60f9ecee0dc81cc3ad86f8830f22aa32",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "2002c39b5b595334699eacffe6d5f5d1",
"assets/NOTICES": "4506673f6009b832a214b7f9de5d2f20",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "7fad070dfb084e06dd58b3778a25998b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "dd73c01f163d14ee1d7f2b12cb56ec2a",
"/": "dd73c01f163d14ee1d7f2b12cb56ec2a",
"main.dart.js": "a5bf109591c152b4588cdeacecdcb998",
"manifest.json": "55b1972561a6c0f961230ac8924f5fae",
"version.json": "384ddfdd18400f5c8b65bafa9ec6d583"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
