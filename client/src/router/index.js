import { createRouter, createWebHashHistory } from 'vue-router'
import AuctionSystem from '@/views/AuctionSystem.vue'

// 路由规则
const routes = [
  {
    path: '/',
    name: 'defalut',
    component: AuctionSystem
  }
]

// 路由实例
export default createRouter({
  history: createWebHashHistory(),
  routes
})
