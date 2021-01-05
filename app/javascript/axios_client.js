import Axios from 'axios'
import { csrfToken } from 'rails-ujs'

const axiosClient = Axios.create({})

document.addEventListener('DOMContentLoaded', () => {
  axiosClient.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()
})

axiosClient.interceptors.response.use(
  response => response,
  (error) => {
    if (error.response.status === 500) {
      this.$notify({
        title: 'エラー',
        message: 'サーバー内部でエラーが発生しました',
        type: 'error'
      })
    }
    return Promise.reject(error)
  }
)

export { axiosClient }
