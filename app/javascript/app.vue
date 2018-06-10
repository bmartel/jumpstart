<template>
  <div>
    <alert
      v-if="hasAlerts"
      :messages="alerts" />
    <navbar
      :user="currentUser"
      class="bg-blue">
      <span
        slot="brand"
        class="brand">
        <feather-icon
          class="mr-1"
          name="activity" />
        Vine
      </span>
      <template slot="actions-right"/>
    </navbar>
    <div class="container px-2 md:px-0 mx-auto mt-6">
      <slot>
        <router-view/>
      </slot>
    </div>
  </div>
</template>

<script>
import Alert from '@/components/Alert';
import Navbar from '@/components/Navbar';
import FeatherIcon from '@/components/FeatherIcon';

export default {
  components: {
    Alert,
    FeatherIcon,
    Navbar,
  },

  computed: {
    currentUser() {
      return this.$store.state.auth.user;
    },
    alerts() {
      return this.$store.state.alert.messages;
    },

    hasAlerts() {
      return this.$store.getters['alert/hasAlerts'];
    },
  },

  metaInfo: {
    title: 'VueJS Rails',
  },
};
</script>
