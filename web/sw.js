// Offline-first service worker for the Workout Timer PWA.
//
// Flutter no longer ships a usable service worker (the generated
// flutter_service_worker.js only unregisters itself), so this file provides
// the caching the PWA needs: the app shell is precached on install, engine
// and asset files are cached as they are first requested.
//
// Bump CACHE_VERSION whenever the caching strategy below changes.
const CACHE_PREFIX = 'workout-timer-';
const CACHE_VERSION = 'v3';
const CACHE_NAME = `${CACHE_PREFIX}${CACHE_VERSION}`;
const SHELL_INDEX = './index.html';

// Files needed for the very first paint. Everything else (CanvasKit, fonts,
// shaders) is cached by the runtime handler on first use.
const SHELL_ASSETS = [
  './',
  SHELL_INDEX,
  './manifest.json',
  './favicon.png',
  './flutter.js',
  './flutter_bootstrap.js',
  './main.dart.js',
  './assets/AssetManifest.bin.json',
  './assets/FontManifest.json',
  './assets/fonts/MaterialIcons-Regular.otf',
  './assets/assets/sounds/bell.mp3',
  './assets/assets/sounds/beep.mp3',
  './assets/assets/background/gym.webp',
  './assets/assets/background/gym-soft.webp',
  './icons/Icon-192.png',
  './icons/Icon-512.png',
  './icons/Icon-maskable-192.png',
  './icons/Icon-maskable-512.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      // Best effort: one unavailable optional file must not abort the install.
      await Promise.all(
        SHELL_ASSETS.map(async (url) => {
          try {
            await cache.add(new Request(url, { cache: 'reload' }));
          } catch (error) {
            console.warn('[sw] skipped precache of', url, error);
          }
        }),
      );
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const names = await caches.keys();
      await Promise.all(
        names
          .filter((name) => name.startsWith(CACHE_PREFIX) && name !== CACHE_NAME)
          .map((name) => caches.delete(name)),
      );
      await self.clients.claim();
    })(),
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;

  // Leave cross-origin traffic (and media range requests) alone.
  if (new URL(request.url).origin !== self.location.origin) return;
  if (request.headers.has('range')) return;

  event.respondWith(
    request.mode === 'navigate'
      ? serveNavigation(request)
      : staleWhileRevalidate(event, request),
  );
});

// Network first, so a newly deployed build is picked up immediately while
// online; the cached shell keeps the app usable offline.
async function serveNavigation(request) {
  const cache = await caches.open(CACHE_NAME);
  try {
    const response = await fetch(request);
    if (response.ok) await cache.put(SHELL_INDEX, response.clone());
    return response;
  } catch (error) {
    const cached = await cache.match(SHELL_INDEX, { ignoreSearch: true });
    if (cached) return cached;
    return new Response('Offline and no cached app shell is available yet.', {
      status: 503,
      headers: { 'Content-Type': 'text/plain' },
    });
  }
}

// Engine files, fonts and assets: serve the cached copy at once and refresh it
// in the background so the next load runs the newest version.
async function staleWhileRevalidate(event, request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request, { ignoreSearch: true });

  const update = fetch(request)
    .then((response) => {
      if (response.ok) cache.put(request, response.clone());
      return response;
    })
    .catch(() => undefined);

  if (cached) {
    event.waitUntil(update);
    return cached;
  }

  const response = await update;
  if (response) return response;
  return new Response('Offline and this resource is not cached.', {
    status: 503,
    headers: { 'Content-Type': 'text/plain' },
  });
}
