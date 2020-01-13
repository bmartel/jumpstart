import Vue from 'vue';
import "../utils/registerServiceWorker";
import store, { hydrate } from '@/store';
import { sync } from 'vuex-router-sync';
import router from '@/routes';
import App from '@/app';
import '@/styles/application.css';

Vue.config.productionTip = false;

// Hydrate store data from Rails
hydrate(store);

// Sync router with the store
sync(store, router);

// Release the router sync when navigating to turbolinks page
// document.addEventListener('turbolinks:before-visit', function() {
//   unsync();
// });

new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App),
});
