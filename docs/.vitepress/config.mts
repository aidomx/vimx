import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'vimx',
  description: 'Vim Configuration Manager — IDE-like Vim for full-stack development',
  base: '/vimx/',

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/vimx/logo.svg' }],
  ],

  themeConfig: {
    logo: '/logo.svg',

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/getting-started' },
      {
        text: 'Languages',
        items: [
          { text: 'JavaScript / TypeScript', link: '/languages/web' },
          { text: 'Python', link: '/languages/python' },
          { text: 'C / C++', link: '/languages/c-cpp' },
          { text: 'Go', link: '/languages/go' },
          { text: 'PHP / Laravel', link: '/languages/php-laravel' },
          { text: 'Bash', link: '/languages/bash' },
        ],
      },
      { text: 'vimx CLI', link: '/vimx' },
    ],

    sidebar: {
      '/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Introduction', link: '/' },
            { text: 'Quick Start', link: '/getting-started' },
            { text: 'Installation', link: '/installation' },
            { text: 'Prerequisites', link: '/prerequisites' },
            { text: 'Project Structure', link: '/structure' },
          ],
        },
        {
          text: 'vimx CLI',
          items: [
            { text: 'Overview', link: '/vimx' },
            { text: 'Plugin Management', link: '/vimx-plugins' },
            { text: 'Language Manager', link: '/vimx-langs' },
            { text: 'Settings & Themes', link: '/vimx-settings' },
            { text: 'Backup & Restore', link: '/vimx-backup' },
          ],
        },
        {
          text: 'Configuration',
          items: [
            { text: 'Key Mappings', link: '/keymappings' },
            { text: 'Customization', link: '/customization' },
            { text: 'Plugins Reference', link: '/plugins' },
          ],
        },
        {
          text: 'Language Guides',
          items: [
            { text: 'JavaScript / TypeScript', link: '/languages/web' },
            { text: 'Python', link: '/languages/python' },
            { text: 'C / C++', link: '/languages/c-cpp' },
            { text: 'Go', link: '/languages/go' },
            { text: 'PHP / Laravel', link: '/languages/php-laravel' },
            { text: 'Bash', link: '/languages/bash' },
          ],
        },
        {
          text: 'Advanced',
          items: [
            { text: 'Performance', link: '/performance' },
            { text: 'Termux Optimization', link: '/termux' },
            { text: 'Troubleshooting', link: '/troubleshooting' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/aidomx/vimconfig' },
    ],

    search: {
      provider: 'local',
    },

    editLink: {
      pattern: 'https://github.com/aidomx/vimconfig/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },

    footer: {
      message: 'Released under the MIT License.',
      copyright: '© 2025 aidomx',
    },

    outline: {
      label: 'On this page',
      level: [2, 3],
    },
  },
})
