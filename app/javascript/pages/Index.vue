<template>
  <div>
    <h1>{{ msg }}</h1>
    <menu-sheet
      v-if="loggedIn"
      :items="items"
      class="mt-6 max-w-xs shadow rounded" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import MenuSheet from '@/components/MenuSheet';

export default {
  components: {
    MenuSheet,
  },

  data() {
    return {
      msg: 'VueJS on Rails',
      items: [
        { label: 'brandonmartel@gmail.com' },
        {
          text: 'Logout',
          prependIcon: 'log-out',
          action: () => this.$store.dispatch('auth/logout'),
        },
      ],
    };
  },
  computed: {
    ...mapGetters('auth', ['loggedIn']),
  },
};
</script>
