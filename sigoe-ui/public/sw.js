const CACHE_NAME = 'sigoe-pwa-v1'

self.addEventListener('install', () => {
  self.skipWaiting()
})

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim())
})

self.addEventListener('fetch', (event) => {
  const request = event.request

  if (request.method !== 'GET') {
    return
  }

  const url = new URL(request.url)

  if (url.origin !== self.location.origin) {
    return
  }

  if (request.destination === 'document') {
    event.respondWith(
      fetch(request).catch(() => caches.match('/index.html'))
    )
    return
  }

  if (
    request.destination === 'script' ||
    request.destination === 'style' ||
    request.destination === 'image' ||
    request.destination === 'font'
  ) {
    event.respondWith(
      caches.match(request).then((cached) => {
        if (cached) {
          return cached
        }

        return fetch(request).then((response) => {
          if (response.ok) {
            const copy = response.clone()

            caches.open(CACHE_NAME).then((cache) => {
              cache.put(request, copy)
            })
          }

          return response
        })
      })
    )
  }
})
