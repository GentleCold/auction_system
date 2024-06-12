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

<style>
.right-btn {
  display: flex;
  justify-content: flex-end;
}
.el-col {
  margin: 12px 0;
}
.el-select {
  margin-bottom: 10px;
}
.card-header {
  text-align: center;
}
.title {
  font-weight: bold;
}
</style>
