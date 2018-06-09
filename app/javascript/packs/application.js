import 'babel-polyfill';

import Vue from 'vue';
import Vuex from 'vuex';
import store, { hydrate } from '@/store';
import router from '@/routes';
import App from '@/App';
import '@/styles/application.css';

// Hydrate store data from Rails
hydrate(store, window.__INITIAL_STATE__);

// Sync router with the store
sync(store, router);

// **
// * If using Turbolinks
// * Remember to include the turbolinks application.js
// **

// import TurbolinksAdapter from 'vue-turbolinks';
// Vue.use(TurbolinksAdapter);

// document.addEventListener('turbolinks:load', () => {
//   var vueapp = new Vue({
//     el: '#app',
//     store,
//     render: h => h(App)
//   });
// });

new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App),
});
