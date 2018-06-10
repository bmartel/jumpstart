import 'babel-polyfill';

import Vue from 'vue';
import Vuex from 'vuex';
import { sync } from 'vuex-router-sync';
import store, { hydrate } from '@/store';
import router from '@/routes';
import App from '@/app';
import '@/styles/application.css';

// Hydrate store data from Rails
hydrate(store, window.__INITIAL_STATE__);

// Sync router with the store
const unsync = sync(store, router);

// Release the router sync when navigating to turbolinks page
document.addEventListener('turbolinks:before-visit', function() {
  unsync();
});

new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App),
});
