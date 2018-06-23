const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
  entry: {
    app: ['./src/index.js']
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    publicPath: '/',
    filename: '[name].[hash].js'
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-hot-loader'
          },
          {
            loader: 'elm-webpack-loader',
            options: {
              verbose: true,
              warn: true,
              debug: true,
              forceWatch: true
            }
          }
        ]
      }
    ],

    noParse: /\.elm$/
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  plugins: [
    new CleanWebpackPlugin(['dist']),
    new HtmlWebpackPlugin({
      template: 'public/index.html'
    }),
    new webpack.HashedModuleIdsPlugin(),
    new webpack.HotModuleReplacementPlugin()
  ],

  devServer: {
    hot: true,
    inline: true,
    overlay: true,
    compress: true,
    port: 5000,
    historyApiFallback: true,
    contentBase: path.join(__dirname, 'public'),
    watchContentBase: true,
    publicPath: '/',
    watchOptions: {
      ignored: /node_modules/
    }
  }
};
