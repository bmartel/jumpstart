<template>
  <span class="inline-flex">
    <img
      :src="url"
      :class="classes"
      :style="styles"
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
    classes() {
      return {
        [roundedLevels[this.rounded]]: true,
      };
    },
    styles() {
      return {
        height: `${this.size}px`,
        width: `${this.size}px`,
      };
    },
  },
};
</script>
