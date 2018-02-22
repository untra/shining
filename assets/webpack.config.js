/*
 * Modules
 **/
const path = require("path");
const webpack = require("webpack");
const env = process.env.MIX_ENV || 'dev'
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const isProduction = (env === 'prod')


/*
 * Configuration
 **/
module.exports = (env) => {
  const isDev = !(env && env.prod);
  const devtool = isDev ? "eval" : "source-map";

  return {
    devtool: devtool,

    context: __dirname,

    entry: './web/static/js/app.js',

    output: {
      path: path.resolve(__dirname, '../priv/static/'),
      filename: 'app.js'
    },

    resolve: {
      alias: {
        phoenix: __dirname + '/deps/phoenix/web/static/js/phoenix.js'
      }
    },

    devServer: {
      headers: {
        "Access-Control-Allow-Origin": "*",
      }
    },

    module: {
      loaders: [
          {
            test: /\.jsx?$/,
            exclude: /(node_modules|bower_components)/,
            loader: 'babel',
            query: {
              presets: ['es2015', 'react']
            }
          },
          {
            test: /\.scss$/,
            loader: ExtractTextPlugin.extract(
              'style',
              'css' + '!sass?outputStyle=expanded'
            )
          },
          // Inlining not working
          {
            test: /\.(png|jpg)$/,
            loader: 'url-loader?limit=8192'
          },
          {
            test: /\.woff(2)?(\?v=\d+\.\d+\.\d+)?$/,
            loader: "url?limit=10000&minetype=application/font-woff"
          },
          {
            test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
            loader: "url?limit=10000&minetype=application/octet-stream"
          },
          {
            test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
            loader: "file"
          },
          {
            test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
            loader: "url?limit=10000&minetype=image/svg+xml"
          }
        ]
    },

    resolve: {
      modules: ["node_modules", __dirname],
      extensions: [".js", ".json", ".jsx", ".css", ".styl"]
    },

    plugins: [
      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }]),
      new webpack.DefinePlugin({
        'CANVAS_RENDERER': true,
        'WEBGL_RENDERER': true
      }),

      new ExtractTextPlugin({
        filename: "css/[name].css",
        allChunks: true
      }),

      new webpack.optimize.UglifyJsPlugin({ 
        sourceMap: true,
        beautify: false,
        comments: false,
        extractComments: false,
        compress: {
          warnings: false,
          drop_console: true
        },
        mangle: {
          except: ['$'],
          screw_ie8 : true,
          keep_fnames: true,
        }
      })
    ]
  };
};