const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

const distPath = path.resolve(__dirname + '/../dist');

module.exports = {
  entry: {
    main: ['./src/index.js']
  },

  output: {
    path: distPath,
    filename: '[name].[hash].js',
    publicPath: '/'
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader'
      }
    ],

    noParse: /\.elm$/
  },

  plugins: [
    new CleanWebpackPlugin([distPath]),
    new CopyWebpackPlugin([{ from: 'public' }]),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new HtmlWebpackPlugin({
      template: 'public/index.html'
    }),
    new webpack.HashedModuleIdsPlugin(),
    new UglifyJSPlugin({
      sourceMap: false,
      parallel: true
    })
  ],

  resolve: {
    extensions: ['.js', '.elm']
  }
};
