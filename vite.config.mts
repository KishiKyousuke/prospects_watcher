import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue2 from '@vitejs/plugin-vue2'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue2(),
  ],
})
