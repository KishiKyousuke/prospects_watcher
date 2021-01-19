<template>
  <v-container class="center my-160">
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
.my-160 {
  margin: 160px auto;
}

p {
  font-weight: bold;
  color: #6E6E6E;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}
</style>
