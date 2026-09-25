export function isMobileDevice() {
  return window.matchMedia('(max-width: 767px)').matches
}

export function getInitialRoute() {
  return isMobileDevice() ? '/mobile/dashboard' : '/home'
}
