<template>
  <div>
    <alert
      v-if="hasAlerts"
      :messages="alerts" />
    <navbar
      :user="currentUser"
      class="bg-primary">
      <router-link
        v-if="spa"
        slot="brand"
        to="/"
        class="brand transition hover:opacity-75">
        <feather-icon
          class="mr-1"
          name="activity" />
        {{ appName }}
      </router-link>
      <a
        v-else
        slot="brand"
        href="/"
        class="brand transition hover:opacity-75">
        <feather-icon
          class="mr-1"
          name="activity" />
        {{ appName }}
      </a>
      <ul
        slot="actions-right"
        class="list-reset flex">
        <li
          :class="{'border-white opacity-100': currentRoute(announcementsUrl)}"
          class="mr-6 md:py-1 border-transparent md:border-b-2 opacity-50 hover:opacity-100 hover:border-white transition inline-flex items-center"><a
            :href="announcementsUrl"
            class="text-white no-underline font-thin inline-flex items-center">
            <span class="hidden md:inline-flex">Announcements</span>
            <feather-icon
              :size="20"
              class="md:hidden"
              name="radio" />
        </a></li>
        <li
          :class="{'border-white opacity-100': currentRoute(notificationsUrl)}"
          class="mr-6 md:py-1 border-transparent md:border-b-2 opacity-50 hover:opacity-100 hover:border-white transition inline-flex items-center"><a
            :href="notificationsUrl"
            class="text-white no-underline font-thin">
            <span class="hidden md:inline-flex">Notifications</span>
            <feather-icon
              :size="20"
              class="md:hidden"
              name="bell" />
        </a></li>
      </ul>
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
import endpoint from '@/endpoints';

export default {
  components: {
    Alert,
    FeatherIcon,
    Navbar,
  },

  props: {
    spa: {
      type: Boolean,
      default: true,
    },
  },

  data() {
    return {
      appName: 'Vine',
      announcementsUrl: endpoint.announcements,
      notificationsUrl: endpoint.notifications,
    };
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

  methods: {
    currentRoute(url) {
      return window.location.pathname === url;
    },
  },

  metaInfo() {
    return {
      title: this.appName,
    };
  },
};
</script>
