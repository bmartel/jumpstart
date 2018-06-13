<template>
  <div class="text-center pt-6">
    <h1 class="text-xxl mt-6">{{ msg }}</h1>
    <p class="my-6">{{ description }}</p>
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
