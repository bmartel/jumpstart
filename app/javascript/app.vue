<template>
  <div>
    <navbar
      :user="currentUser"
      class="bg-green">
      <span
        slot="brand"
        class="brand">
        Project
      </span>
      <template slot="actions"/>
    </navbar>
    <div class="container px-2 md:px-0 mx-auto mt-6">
      <slot>
        <router-view/>
      </slot>
    </div>
  </div>
</template>

<script>
import Navbar from '@/components/Navbar';

export default {
  components: {
    Navbar,
  },

  computed: {
    currentUser() {
      return this.$store.state.auth.user;
    },
  },

  metaInfo: {
    title: 'VueJS Rails',
  },
};
</script>
