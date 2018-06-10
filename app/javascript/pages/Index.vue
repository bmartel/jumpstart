<template>
  <div>
    <h1>{{ msg }}</h1>
    <button
      v-if="loggedIn"
      class="px-3 py-2 rounded"
      @click="$store.dispatch('auth/logout')">Logout</button>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  data() {
    return {
      msg: 'VueJS on Rails',
    };
  },
  computed: {
    ...mapGetters('auth', ['loggedIn']),
  },
};
</script>
