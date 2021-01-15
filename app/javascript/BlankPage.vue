<template>
  <v-container class="center">
    <v-btn
        dark
        large
        color="light-green"
        class="mb-6"
        height="64px"
        href="/players"
    >
      <v-icon dark size="40px">
        mdi-plus
      </v-icon>
    </v-btn>
    <div>
      <p>まだ選手が登録されていません</p>
      <p>気になる選手を登録して成績をチェックしましょう！</p>
    </div>
  </v-container>
</template>

<script>
export default {
}
</script>

<style scoped>
.container {
  margin-top: 160px;
}

p {
  font-weight: bold;
  color: #6E6E6E;
}
</style>
