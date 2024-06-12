import { createRouter, createWebHashHistory } from 'vue-router'
import AuctionSystem from '@/views/AuctionSystem.vue'

const routes = [
  {
    path: '/',
    name: 'defalut',
    component: AuctionSystem
  }
]

export default createRouter({
  history: createWebHashHistory(),
  routes
})
