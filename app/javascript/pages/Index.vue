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
    const user = this.$store.state.auth.user;

    return {
      msg: 'VueJS on Rails',
      items: [
        { label: user.email },
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
