module.exports = {
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      'assets',
    ],

    // Where to compile files to
    public: 'priv/static',
  },
  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    assets: /^(web\/static\/assets)/,
  },
  files: {
    javascripts: {
      joinTo: {
        'app.js': 'js/app.js',
        'vendor.js': ['node_modules/**', 'vendor/**'],
      },
    },
    stylesheets: {
      joinTo: 'app.css',
      order: {
        after: ['/css/app.css'], // concat app.css last
      },
    },
  },
  modules: {
    autoRequire: {
      'app.js': ['initialize'],
    },
  },
  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/(web\/static\/vendor)|node_modules/],
    },
    sass: {
      options: {
        includePaths: [
          'node_modules/bootstrap-sass/assets/stylesheets',
          'node_modules/font-awesome/scss',
          'node_modules/toastr',
        ], // tell sass-brunch where to look for files to @import
      },
      precision: 8, // minimum precision required by bootstrap-sass
    },
    copycat: {
      fonts: [
        'node_modules/bootstrap-sass/assets/fonts/bootstrap',
        'node_modules/font-awesome/fonts',
      ], // copy these files into priv/static/fonts/
    },
  },
  npm: {
    static: ['node_modules/phaser/dist/phaser.js'],
  },
  server: {
    noPushState: true,
  },
};
