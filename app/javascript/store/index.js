import Vue from 'vue';
import Vuex from 'vuex';

import state from '@/store/state';
import actions from '@/store/actions';
import mutations from '@/store/mutations';
import getters from '@/store/getters';
import modules from '@/store/modules';
import plugins from '@/store/plugins';

Vue.use(Vuex);

export const hydrate = (store, data) => {
  if (data) {
    store.replaceState(data);
  }
}

export default new Vuex.Store({
  state,
  actions,
  mutations,
  getters,
  modules,
  plugins,
});
