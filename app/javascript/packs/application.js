import Vue from 'vue';
import TurbolinksAdapter from 'vue-turbolinks';

import App from '../app.vue';
import '../styles/application.css';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  var vueapp = new Vue({
    el: "#app",
    components: { App },
  });
});
