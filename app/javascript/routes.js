import Vue from 'vue';
import Router from 'vue-router';
import Meta from 'vue-meta';

// Pages
import IndexPage from './pages/Index.vue';

// Use router and meta plugins
Vue.use(Router);
Vue.use(Meta);

// Routes
const routes = [
  { path: '/', component: IndexPage },
];

export default new Router({ routes });
