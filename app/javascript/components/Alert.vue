<template>
  <div class="z-20 fixed pin-t pin-x">
    <div
      v-for="(message, index) in messages"
      :key="index"
      :class="styles(message)"
      class="text-white py-4">
      <div class="flex items-center container px-2 md:px-0 mx-auto">
        <button
          class="text-white px-2 mr-2"
          @click="remove(index)"
        >×</button>
        <span>{{ text(message) }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
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
        ['bg-green-light']: type === 'success',
        ['bg-red-light']: type === 'alert',
        ['bg-red-light']: type === 'error',
        ['bg-blue-light']: type === 'notice',
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
