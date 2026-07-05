import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue2 from '@vitejs/plugin-vue2'

export default defineConfig({
  resolve: {
    extensions: ['.mjs', '.js', '.mts', '.ts', '.jsx', '.tsx', '.json', '.vue'],
    alias: [
      { find: /^vuetify$/, replacement: 'vuetify/lib' },
    ],
  },
  define: {
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
  },
  plugins: [
    RubyPlugin(),
    vue2(),
  ],
})
