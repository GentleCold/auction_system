<template>
  <div id="app">
    <Suspense>
      <template #default>
        <router-view />
      </template>
      <template #fallback>
        <div>Loading...</div>
      </template>
    </Suspense>
  </div>
</template>

<script>
export default {
  name: 'App',
};
</script>
