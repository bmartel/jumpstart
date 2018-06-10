<template>
  <span class="inline-flex">
    <img
      :src="url"
      :class="styles"
      :height="size"
      :width="size"
      :alt="alt">
  </span>
</template>

<script>
const roundedLevels = ['', 'rounded', 'rounded-lg', 'rounded-full'];
export default {
  props: {
    url: {
      type: String,
      required: true,
    },

    alt: {
      type: String,
      default: '',
    },

    size: {
      type: Number,
      default: 32,
    },

    rounded: {
      type: Number,
      default: 3,
    },
  },
  computed: {
    styles() {
      return {
        [roundedLevels[this.rounded]]: true,
      };
    },
  },
};
</script>
