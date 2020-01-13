import Rails from '@rails/ujs';
import ActiveStorage from '@rails/activestorage';
import Turbolinks from 'turbolinks';
import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue';
import '@/directives/action';
import store, { hydrate } from '@/store';
import App from '@/app';

Vue.config.productionTip = false;

// Hydrate store data from Rails
hydrate(store, window.__INITIAL_STATE__);

// Register any other modules

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    store,
    components: { App },
  });
});

// Start Rails Turbolinks and ActiveStorage
Rails.start();
Turbolinks.start();
ActiveStorage.start();
