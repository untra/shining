/*
 * Modules
 **/
const path = require("path");
const webpack = require("webpack");
const env = process.env.MIX_ENV || 'dev'
const HtmlWebpackPlugin = require('html-webpack-plugin')
const BrowserSyncPlugin = require('browser-sync-webpack-plugin')
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const isProduction = (env === 'prod')
const supportedBrowsers = require("./browsers");
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const phaserModule = path.join(__dirname, '/node_modules/phaser/')
const phaser = path.join(phaserModule, 'src/phaser.js')
const phoenixModule = path.join(__dirname, '../deps/phoenix/web/static/js/phoenix.js')
const phoenix = path.join(phoenixModule)

const paths = {
  static: path.join(__dirname, "../priv/static"),
  build: path.join(__dirname, "../priv/static/dist"),
  node_modules: path.join(__dirname, "./node_modules"),
  src: path.join(__dirname, "./"),
}

/*
 * Configuration
 **/
module.exports = (env) => {
  const isDev = !(env && env.prod);
  const devtool = isDev ? "eval" : "source-map";

  return {
    devtool: devtool,

    context: __dirname,

    entry: {
      'app': path.join(paths.src, "js/app.js"),
      'css': path.join(paths.src, "css/app.scss"),
    },

    output: {
      path: paths.build,
      filename: "[name].js",
    },

    resolve: {
      modules: ["node_modules", __dirname],
      extensions: [".js", ".json", ".jsx", ".css", ".styl"],
      alias: {
        phoenix,
        phaser
      }
    },

    devServer: {
      headers: {
        "Access-Control-Allow-Origin": "*",
      }
    },

    module: {
      rules: [
        {
          test: /\.js$/,
          loader: 'babel-loader',
          query: {
            presets: ['es2015'],
          },
        },
        { test: /phaser-split\.js$/, use: ['expose-loader?Phaser'] },
        { test: [/\.vert$/, /\.frag$/], use: 'raw-loader' },
        {
          test: /\.tsx?$/,
          use: [{
            loader: 'babel-loader'
          }, {
            loader: 'ts-loader'
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
        to: paths.static
      }]),
      new webpack.DefinePlugin({
        'CANVAS_RENDERER': false,
        'WEBGL_RENDERER': true
      }),

      new ExtractTextPlugin({
        filename: "css/[name].css",
        allChunks: true
      }),

    ]
  };
};