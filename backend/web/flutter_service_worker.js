'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "80eb773cfe28f102da5b71af30d1d94e",
".git/config": "58cd3b365112cf3b9fcf9df2e23c697f",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/gk/config": "34f05cf087257521835e157128024c98",
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
".git/index": "9e432ecbb7753fbc657014453aab9d1e",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c27b07af89d1266a3ce1cd0eb5fad997",
".git/logs/refs/heads/main": "4ccbae3b5995dcebb54b8b749941350b",
".git/logs/refs/remotes/origin/main": "4302943e1a17c317793d07b077995e66",
".git/objects/05/34b7b1406de4372975be02d6e2539bcbe65bf3": "1544c369871beca1d8cc496011aab4d1",
".git/objects/09/dd41e40a5ea411c03677001c2f5aa6149761a9": "0a56a54fdfb7272485721c5911989e86",
".git/objects/11/0b46751d05e96f77c0cfc81d2fe04cc5604b46": "12abec8116bf3b806ac9715f19ec2522",
".git/objects/11/52340e23e5d83ab167e2e0ae4e2463e26c5cad": "ed81dfcd8f106764eb523acd541e8c65",
".git/objects/1a/d7683b343914430a62157ebf451b9b2aa95cac": "94fdc36a022769ae6a8c6c98e87b3452",
".git/objects/24/50e4b22e9fe7dad83a63f974caac44e0c990ec": "393b3e32e477f7103f4a048ec056318a",
".git/objects/39/47e0e0f274015464a9f5699d542f154e7a7c1c": "2fea30a9b6bb1412366188faeeee116b",
".git/objects/3d/87fcff614ba19453e38184b81c2d0acf820975": "88b5d5ca72a5163f64602efe8d4cd920",
".git/objects/45/ad47059832fe0a30de8b953e332253933a5406": "29d123f23f751785ef5a56ce71721e25",
".git/objects/4c/51fb2d35630595c50f37c2bf5e1ceaf14c1a1e": "a20985c22880b353a0e347c2c6382997",
".git/objects/4d/b6b28a76785171f54d61854fd4004659af42a8": "143002a60c7d5d37832b6d802e4609bd",
".git/objects/50/e08d034533bb07a7827ab449516b5fdf11cb19": "2bcf5837754e70fe350399d0ad4b0c24",
".git/objects/53/18a6956a86af56edbf5d2c8fdd654bcc943e88": "a686c83ba0910f09872b90fd86a98a8f",
".git/objects/53/3d2508cc1abb665366c7c8368963561d8c24e0": "4592c949830452e9c2bb87f305940304",
".git/objects/5d/4a57fc49d21a8061cd8955a97d901b217690ba": "f7df4e9c463ef8b160910c4f970ab525",
".git/objects/61/20847e07c3cd329053a404881621ebc51790ef": "c02fa47719cb23adf92756cf92738e45",
".git/objects/68/7b80693bea76e2d58aceb3e36304714ce4ac13": "191e1393d00dd640594402bee44c689a",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6b/b973b421acf0be1cc7ae7b5399b2700a17bcd4": "c604710991ce4484317f6da67fce43ba",
".git/objects/6d/2f5f6f912b76793428b6d07db316013ff61b15": "c44739a8906b4a1d89c0db1fd68ad212",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "d95736cd43d2676a49e58b0ee61c1fb9",
".git/objects/73/c63bcf89a317ff882ba74ecb132b01c374a66f": "6ae390f0843274091d1e2838d9399c51",
".git/objects/76/4b0079f09b4e8da4647b2160edab5536f6eddb": "20842d3b52c85667a7209e4430ce3e64",
".git/objects/7c/0fe780bb6f62e2a02fc71a26ddd75833f8fc06": "24210be740bd8d01701657af714294b9",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8e/3c7d6bbbef6e7cefcdd4df877e7ed0ee4af46e": "025a3d8b84f839de674cd3567fdb7b1b",
".git/objects/8e/6b1d7994afb9e0b2cb378dc272f4de3897f3b7": "ecb06a704ef0579a371558e860e8fdc9",
".git/objects/94/fa918fd74f2086abdd492cfc6e77eda04d05fc": "89ba298bef31922b9c57717e5534be09",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "784f8e1966649133f308f05f2d98214f",
".git/objects/b4/9d990bcd8e7998477fb61d4af9263efb4fa302": "57e7e1c0fcbadbf582d32b5b1bc7a11e",
".git/objects/b5/5db3aef91cf9501ca0f65ddc8e310691c37b0d": "b51bfbea6c06d5aeba074a3af8d23cf2",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "4227e5e94459652d40710ef438055fe5",
".git/objects/be/38bcdb094f0a14639da4c517400fbc23309cc3": "e184bf662196ace372bad6ef6e91f81d",
".git/objects/c8/08fb85f7e1f0bf2055866aed144791a1409207": "92cdd8b3553e66b1f3185e40eb77684e",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/431289ec96a4610b990a51d774eebf1aa3052a": "cc29dbf5bd1c27bd80c4f813590313d6",
".git/objects/da/3eba1caf65af6877313ab64d94dcee408eec82": "a84222cdd2fbaa5a9129c7aa1b2425ef",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "761c08dfe3c67fe7f31a98f6e2be3c9c",
".git/objects/e0/7ac7b837115a3d31ed52874a73bd277791e6bf": "74ebcb23eb10724ed101c9ff99cfa39f",
".git/objects/e4/23b74780b16934a073769bd147d46479ceb8b2": "32d8800bba013086240bc8edfddfd88a",
".git/objects/e5/0d71eafd1d0c50f59a1d5e5d7bbdd60c722797": "8d11df5177ec43b698d5aecf3ef1b155",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f0/c64e112f8bce3989c497e36523d2ddad6bf20e": "5956ec4a6c3a0bb29356cb7454c7b2db",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f8/e17d6ac93c2d735eb1cd3b7b57242a7448646d": "8c1cd261629b4987a06b8c8ae9530aa7",
".git/objects/fa/9b785350cfbe8ab34214c5c4209054412c4178": "048a1cbeefff89e2d1879df8e1c3d160",
".git/refs/heads/main": "c9aed27a4eb914bc37bd076d8383ee92",
".git/refs/remotes/origin/main": "c9aed27a4eb914bc37bd076d8383ee92",
"assets/AssetManifest.bin": "1438acccd2e44c568fd58d645b194cf5",
"assets/AssetManifest.bin.json": "cd2633f227b5d4460796dd878992c296",
"assets/AssetManifest.json": "c8598c90414dda4df2cc6f05df9bc9c9",
"assets/assets/fonts/IBMPlexSansArabic-Bold.ttf": "3b112e6aa65695f31fa1e1a8fb0589a9",
"assets/assets/fonts/IBMPlexSansArabic-ExtraLight.ttf": "2ac69265ef57c13e2bf7d71f0d86e30b",
"assets/assets/fonts/IBMPlexSansArabic-Light.ttf": "fc8d66d7803c5703326895c99f36aa39",
"assets/assets/fonts/IBMPlexSansArabic-Medium.ttf": "5fb42fdbaf9db9218cd8b43c4f53cae1",
"assets/assets/fonts/IBMPlexSansArabic-Regular.ttf": "bf7497338196d1ed6c36ea4d010f12a8",
"assets/assets/fonts/IBMPlexSansArabic-SemiBold.ttf": "c6da47ef5746d5af5a7bca3f07a444c3",
"assets/assets/fonts/IBMPlexSansArabic-Thin.ttf": "454434ea7b20d86b0b52f4c8a9e772d9",
"assets/assets/fonts/OFL.txt": "992dcb568e1ffac11f740ee2fa1f028b",
"assets/assets/images/Logo.png": "e3b830e4012aea23bce6cdcdb3ad349b",
"assets/FontManifest.json": "a3da6b9cb9a4f8e251af2af76c464a3f",
"assets/fonts/MaterialIcons-Regular.otf": "43b484634dac67d6d980f14e7b35ac58",
"assets/NOTICES": "0fabb3a894510a01e04c9c9b4dbcbef5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "73c3981aba0081fc34ecbbf8409d09dd",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "5719998be126bf257cd8a32799c91e28",
"/": "5719998be126bf257cd8a32799c91e28",
"main.dart.js": "b3a51f8c775218913a18c705900f2ed7",
"manifest.json": "881085ff450520a9656b458acd9cbe79",
"version.json": "29e8af9dfd13d626d0fc43e4841fa499"};
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
