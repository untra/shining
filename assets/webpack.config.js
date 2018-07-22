/*
 * Modules
 * */
const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const phaserModule = path.join(__dirname, '/node_modules/phaser/');
const phaser = path.join(phaserModule, 'src/phaser.js');
const phoenixModule = path.join(__dirname, '../deps/phoenix/web/static/js/phoenix.js');
const phoenix = path.join(phoenixModule);

const paths = {
  static: path.join(__dirname, '../priv/static/'),
  build: path.join(__dirname, '../priv/static/'),
  node_modules: path.join(__dirname, './node_modules'),
  src: path.join(__dirname, './'),
};

/*
 * Configuration
 * */
module.exports = (env) => {
  const isDev = !(env && env.prod);
  const devtool = isDev ? 'eval' : 'source-map';

  return {
    devtool,

    context: __dirname,

    entry: {
      app: path.join(paths.src, 'js/app.js'),
      game: path.join(paths.src, 'js/game.js'),
      css: path.join(paths.src, 'css/app.scss'),
    },

    output: {
      path: paths.static,
      filename: '[name].js',
      publicPath: 'http://localhost:8080/',
    },

    resolve: {
      modules: ['node_modules', path.resolve(__dirname, 'js')],
      extensions: ['.js', '.json', '.jsx'],
      alias: {
        phoenix,
        phaser,
      },
    },

    devServer: {
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    },

    module: {
      rules: [
        {
          test: /\.scss$/,
          use: [
            'style-loader', // creates style nodes from JS strings
            'css-loader', // translates CSS into CommonJS
          ],
        },
        {
          test: /\.js$/,
          loader: 'babel-loader',
          exclude: /node_modules/,
          query: {
            presets: ['es2015'],
          },
        },
        { test: /phaser-split\.js$/, use: ['expose-loader?Phaser'] },
        { test: [/\.vert$/, /\.frag$/], use: 'raw-loader' },
        {
          test: /\.tsx?$/,
          use: [{
            loader: 'babel-loader',
          }, {
            loader: 'ts-loader',
          }],
          exclude: [/node_modules/, /mocks/],
        },
      ],
    },

    optimization: {

    },

    plugins: [
      new CopyWebpackPlugin([{
        from: path.join(paths.src, 'static'),
        to: paths.static,
      }]),
      new webpack.DefinePlugin({
        CANVAS_RENDERER: true,
        WEBGL_RENDERER: false,
      }),

      new ExtractTextPlugin({
        filename: 'css/[name].css',
        allChunks: true,
      }),

    ],
  };
};
