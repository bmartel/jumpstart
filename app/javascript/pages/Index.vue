<template>
  <div class="text-center">
    <h1>{{ msg }}</h1>
    <p class="my-3">{{ description }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      msg: 'Welcome to your app!',
      description: 'This is a special scaffold to help you quickly get working with VueJS with Rails.',
    };
  },
};
</script>
