import Vue from 'vue';
import Vuex from 'vuex';

import state from '@/store/state';
import actions from '@/store/actions';
import mutations from '@/store/mutations';
import getters from '@/store/getters';
import modules from '@/store/modules';
import plugins from '@/store/plugins';
import { setCsrfToken } from '@/utils/axios';

Vue.use(Vuex);

export const hydrate = (store, dataKey = '__INITIAL_STATE__') => {
  if (typeof window === 'object' && dataKey in window) {
    const data = window[dataKey];
    delete window[dataKey];
    setCsrfToken(data);
    const storeState = store.state;
    store.replaceState({ ...storeState, ...data });
  }
};

export default new Vuex.Store({
  state,
  actions,
  mutations,
  getters,
  modules,
  plugins,
});
