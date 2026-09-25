import { createApp } from 'vue'
import App from '@/App.vue'
import router from '@/router'
import '@/assets/main.css'
import '@fortawesome/fontawesome-free/css/all.css'

createApp(App).use(router).mount('#app')

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch((error) => {
      console.error('Falha ao registrar o service worker:', error)
    })
  })
}
