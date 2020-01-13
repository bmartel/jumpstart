<template>
  <div class="z-20 fixed top-0 inset-x-0">
    <div
      v-for="(message, index) in messages"
      :key="index"
      :class="styles(message)"
      class="text-white py-4">
      <div class="flex items-center justify-center container px-2 md:px-0 mx-auto">
        <button
          class="text-white px-2 mr-2 mt-1 hover:opacity-50"
          @click="remove(index)"
        ><feather-icon
          :size="20"
          name="x" /></button>
        <span>{{ text(message) }}</span>
      </div>
    </div>
  </div>
</template>

<script>
import FeatherIcon from '@/components/FeatherIcon';

export default {
  components: {
    FeatherIcon,
  },

  props: {
    messages: {
      type: Array,
      default: () => [],
    },
  },

  methods: {
    text(message) {
      return this.extract(message).text;
    },

    styles(message) {
      const { type } = this.extract(message);

      return {
        ['bg-success']: type === 'success',
        ['bg-error']: type === 'error',
        ['bg-warning']: type === 'alert',
        ['bg-info']: type === 'notice',
      };
    },

    extract(message) {
      let type = 'notice';
      let text = '';

      try {
        type = message[0];
        text = message[1];

        return { type, text };
      } catch (err) {
        return { type, text: message };
      }
    },

    remove(index) {
      this.$store.dispatch('alert/dismiss', index);
    },
  },
};
</script>
