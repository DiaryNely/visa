import { createRouter, createWebHistory } from 'vue-router'
import SearchPage from './views/SearchPage.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'search',
      component: SearchPage
    },
    {
      path: '/demande/:id',
      name: 'demande-search',
      component: SearchPage,
      props: true
    }
  ]
})

export default router
