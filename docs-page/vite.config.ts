import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Relative base so GitHub Pages works under /devkit/ (project site).
// Build output goes straight to the repo docs/ folder (GitHub Pages source).
export default defineConfig({
  plugins: [react()],
  base: './',
  build: {
    outDir: '../docs',
    emptyOutDir: true,
  },
})
