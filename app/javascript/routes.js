import Vue from 'vue';
import Router from 'vue-router';
import Meta from 'vue-meta';

// Use router and meta plugins
Vue.use(Router);
Vue.use(Meta);

// Routes
const routes = [
  { path: '/', component: () => import('@/pages/Index.vue') },
];

export default new Router({ mode: 'history', routes });
